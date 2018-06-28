public with sharing class UTIL_InvoiceSync_Batch
    implements Database.Batchable<SBO_YetiInvoiceSync_Search.SEARCHRESULT>,
    Database.AllowsCallouts,
    Database.Stateful,
    I_ParameterizedSync
{
    // MAX_ROWS is a SBO parameter which controls the maximum header rows retrieved,
    //  however, there have been 2600+ detail records returned by a MAX_ROWS of 150
    //  because of headers with large numbers of lines.
    // The response size needs to remain within a reasonable size so that the Apex heap
    //  limit isn't exceeded which would cause the job to fail.
    private final Integer MAX_ROWS = 150;

    // isAnotherBatchNeeded is a flag set in start() after examing how many rows were returned
    //  telling finish() whether to schedule another instance to retrieve additional records
    private Boolean isAnotherBatchNeeded = false;

    // jobInfo contains debug information persisted across contexts since start(),
    //   execute(), and finish() all run in separate contexts with separate debug logs
    private List<String> jobInfo = new List<String>();

    /* I_ParameterizedSync methods - setBatchParam() */
    // In this case, we will store the largest change date/time as the param
    private String fromLastSync = null;

    private class InvoiceTotal
    {
        public Decimal totalBeforeDiscount {get; set;}
        public Decimal subTotal {get; set;}
        public Decimal tax {get; set;}
        public Decimal shippingAmount {get; set;}

        public InvoiceTotal()
        {
            totalBeforeDiscount = 0;
            subTotal = 0;
            tax = 0;
            shippingAmount = 0;
        }
    }

    public void setBatchParam(String value)
    {
        this.fromLastSync = value;
    }
    /* end I_ParameterizedSync methods */

    /* Database.Batchable methods start(), execute(), and finish() */
    // start()
    //
    // Calls SBO and returns search results of update invoices
    public List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> start(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' started');

        SBO_YetiInvoiceSync_Search sbo = new SBO_YetiInvoiceSync_Search();

        sbo.SearchContext.SEARCHPARAMS.MAX_ROWS = MAX_ROWS;

        Datetime lastSync = getLastSyncDate();
        if (null != lastSync)
        {
            sbo.SearchContext.SEARCHPARAMS.FromLastChangeDate = lastSync.date();
            sbo.SearchContext.SEARCHPARAMS.ChangeTimeFrom = lastSync.time();
            this.jobInfo.add('from:' + lastSync.format('yyyy-MM-dd HH:mm:ss'));
        }
        else
        {
            this.jobInfo.add('no existing rows - completely fresh start (or something terrible like a'
                + ' null is in the last changed date)');
        }

        // Execute the search
        SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SR result = sbo.execute();

        // Write any response messages to the debug log
        List<ENSX.EnosixFramework.Message> messages = result.getMessages();
        if (null != messages)
        {
            for (ENSX.EnosixFramework.Message m: messages)
            {
                System.debug('response message[' + m.Type.name() + ']: ' + m.Text);
            }
        }

        if (!result.isSuccess())
        {
            System.debug('search failed');
            UTIL_SyncHelper.printJobInfo(this.jobInfo);
            return null;
        }

        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults = result.getResults();
        System.debug('search successfully retrieved ' + searchResults.size() + ' result records');

        // let finish() know to queue up another instance
        this.isAnotherBatchNeeded = searchResults.size() >= MAX_ROWS / 2;
        this.fromLastSync = getHighestLastChangeDateTimeInResultsForLastSync(searchResults);
        if (null != lastSync && null != this.fromLastSync)
        {
            Datetime searchLastSync = Datetime.newInstance(long.valueOf(this.fromLastSync));
            if (lastSync.getTime() == searchLastSync.getTime())
            {
                searchLastSync = searchLastSync.addSeconds(1);
                this.fromLastSync = String.valueOf(searchLastSync.getTime());
            }
        }

        this.jobInfo.add('searchResultsSize:' + searchResults.size());
        this.jobInfo.add('isAnotherBatchNeeded:' + this.isAnotherBatchNeeded);
        this.jobInfo.add(String.format('fromLastSync:{0}({1})', new List<String> {
            this.fromLastSync,
            this.fromLastSync == null ? null :
                Datetime.newInstance(long.valueOf(this.fromLastSync)).format('yyyy-MM-dd HH:mm:ss')
        }));

        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        return searchResults;
    }

    // execute()
    //
    // Given the updated search results, does the work of updating the order and lines tables
    public void execute(
        Database.BatchableContext context,
        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults)
    {
        System.debug(context.getJobId() + ' executing');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        if (null == searchResults || 0 == searchResults.size())
            return;

        List<Invoice__c> invoiceUpdates = new List<Invoice__c>();
        List<Invoice__c> invoiceInserts = new List<Invoice__c>();
        List<Invoice_Lines__c> lineUpdates = new List<Invoice_Lines__c>();
        List<Invoice_Lines__c> lineInserts = new List<Invoice_Lines__c>();
        List<sObject> errors = new List<sObject>();
        Map<String, Invoice__c> savedInvoiceMap = new Map<String, Invoice__c>();

        Set<String> customerIds = getCustomerIdsFromSearchResults(searchResults);
        Map<String, String> accountIdMap = UTIL_SyncHelper.createAccountIdMap(customerIds);

        Map<String, SBO_YetiInvoiceSync_Search.SEARCHRESULT> invoiceMap = createInvoiceKeyMap(searchResults);
        Map<String, SBO_YetiInvoiceSync_Search.SEARCHRESULT> lineMap = createLineKeyMap(searchResults);
        Map<String, InvoiceTotal> invoiceTotalMap = createInvoiceTotalKeyMap(searchResults);
        Set<String> salesOrderNumbers = getSalesOrderNumbersFromSearchResults(searchResults);
        Map<String, String> salesOrderIdMap = UTIL_YetiSyncHelper.createSalesOrderIdMap(salesOrderNumbers);
        Set<String> deliveryNumbers = getDeliveryNumbersFromSearchResults(searchResults);
        Map<String, String> deliveryIdMap = UTIL_YetiSyncHelper.createDeliveryIdMap(deliveryNumbers);

        // First, update matching existing orders
        for (SObject existingInvoiceSObject : UTIL_SyncHelper.getMatchingRecords('Invoice__c', invoiceMap.keySet()))
        {
            Invoice__c existingInvoice = (Invoice__c) existingInvoiceSObject;
            String invKey = existingInvoice.Name;
            SBO_YetiInvoiceSync_Search.SEARCHRESULT sr = invoiceMap.get(invKey);
            InvoiceTotal invoiceTotal = invoiceTotalMap.get(invKey);
            if (sr != null)
            {
                // Updates fields, saves record for later reference, and adds to invoiceUpdates list for later commit
                this.updateInvoice(existingInvoice, sr, accountIdMap, savedInvoiceMap, errors, invoiceUpdates, invoiceTotal, salesOrderIdMap, deliveryIdMap);
                // Remove from map so we end up with a map that only has new results in it
                invoiceMap.remove(invKey);
            }
            else
            {
                UTIL_SyncHelper.addLog(errors, 'ERROR', 'Search result null for key: ' + invKey);
            }
        }

        // Then, create new orders
        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : invoiceMap.values())
        {
            Invoice__c newInvoice = new Invoice__c();
            InvoiceTotal invoiceTotal = invoiceTotalMap.get(getInvoiceKey(sr));
            this.updateInvoice(newInvoice, sr, accountIdMap, savedInvoiceMap, errors, invoiceInserts, invoiceTotal, salesOrderIdMap, deliveryIdMap);
        }

        // Commit all the invoice changes
        if (invoiceUpdates.size() > 0)
        {
            update invoiceUpdates;
        }

        if (invoiceInserts.size() > 0)
        {
            insert invoiceInserts;
        }

        if (errors.size() > 0)
        {
            insert errors;
        }

        // Now do the line item updates
        for (SObject existingLineSObject : UTIL_SyncHelper.getMatchingRecords('Invoice_Lines__c', lineMap.keySet()))
        {
            Invoice_Lines__c existingLine = (Invoice_Lines__c) existingLineSObject;
            SBO_YetiInvoiceSync_Search.SEARCHRESULT sr = lineMap.get(existingLine.Name);
            this.updateLine(existingLine, sr, savedInvoiceMap, lineUpdates);
            // Remove from map so we end up with a map that only has new results in it
            lineMap.remove(existingLine.Name);
        }

        // and line item creates
        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : lineMap.values())
        {
            Invoice_Lines__c newLine = new Invoice_Lines__c();
            this.updateLine(newLine, sr, savedInvoiceMap, lineInserts);
        }

        // Finally, commit line item changes
        if (lineUpdates.size() > 0)
        {
            update lineUpdates;
        }

        if (lineInserts.size() > 0)
        {
            insert lineInserts;
        }
    }

    // finish()
    //
    // queues up another batch when isAnotherBatchNeeded is true
    public void finish(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' finished');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);
        UTIL_SyncHelper.launchAnotherBatchIfNeeded(
            this.isAnotherBatchNeeded, 'UTIL_InvoiceSync_Schedule', this.fromLastSync);
        if (!this.isAnotherBatchNeeded)
        {
            Database.executeBatch(new UTIL_BatchCleanup('Invoice__c'));
        }
    }
    /* end Database.Batchable methods */

    // getLastSyncDate()
    //
    // returns the hightest Last_Change_Time from the invoice table, which is used as
    // an SBO search param to filter only invoices updated since the last batch ran
    private Datetime getLastSyncDate()
    {
        if (null != this.fromLastSync)
        {
            return Datetime.newInstance(long.valueOf(this.fromLastSync));
        }
        return UTIL_SyncHelper.getLastDateFromTable('Last_Change_Time__c', 'Invoice_Lines__c');
    }

    // getCustomerIdsFromSearchResults()
    //
    // returns a set of all the customer ids referenced in the SR
    private Set<String> getCustomerIdsFromSearchResults(
        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.BillToParty))
            {
                result.add(sr.BillToParty);
            }
            if (String.isNotBlank(sr.ShipToParty))
            {
                result.add(sr.ShipToParty);
            }
            if (String.isNotBlank(sr.SoldToParty))
            {
                result.add(sr.SoldToParty);
            }
        }
        return result;
    }

    // getSalesOrderNumbersFromSearchResults()
    //
    // returns a set of all the Sales Order Numbers referenced in the SR
    private Set<String> getSalesOrderNumbersFromSearchResults(
        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.SalesOrder))
            {
                result.add(sr.SalesOrder);
            }
        }
        return result;
    }

    // getDeliveryNumbersFromSearchResults()
    //
    // returns a set of all the Sales Order Numbers referenced in the SR
    private Set<String> getDeliveryNumbersFromSearchResults(
        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.Delivery))
            {
                result.add(sr.Delivery);
            }
        }
        return result;
    }

    // createInvoiceKeyMap()
    //
    // create a map of invoice key / search result
    private Map<String, SBO_YetiInvoiceSync_Search.SEARCHRESULT> createInvoiceKeyMap(
        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults)
    {
        Map<String, SBO_YetiInvoiceSync_Search.SEARCHRESULT> result =
            new Map<String, SBO_YetiInvoiceSync_Search.SEARCHRESULT>();

        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : searchResults)
        {
            result.put(getInvoiceKey(sr), sr);
        }
        return result;
    }

    // createInvoiceTotalKeyMap()
    //
    // create a map of invoice key / search result
    private Map<String, InvoiceTotal> createInvoiceTotalKeyMap(
        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults)
    {
        Map<String, InvoiceTotal> result = new Map<String, InvoiceTotal>();
        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : searchResults)
        {
            InvoiceTotal invoiceTotal = result.get(getInvoiceKey(sr));
            if (null == invoiceTotal)
            {
                invoiceTotal = new InvoiceTotal();
            }
            if (sr.TotalBeforeDiscount != null)
            {
                invoiceTotal.totalBeforeDiscount += sr.TotalBeforeDiscount;
            }
            if (sr.Subtotal != null)
            {
                invoiceTotal.subTotal += sr.Subtotal;
            }
            if (sr.Tax != null)
            {
                invoiceTotal.tax += sr.Tax;
            }
            if (sr.ShippingAmount != null)
            {
                invoiceTotal.shippingAmount += sr.ShippingAmount;
            }
            result.put(getInvoiceKey(sr), invoiceTotal);
        }
        return result;
    }

    // createLineKeyMap()
    //
    // create a map of invoice line key / search result
    private Map<String, SBO_YetiInvoiceSync_Search.SEARCHRESULT> createLineKeyMap(
        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults)
    {
        Map<String, SBO_YetiInvoiceSync_Search.SEARCHRESULT> result =
            new Map<String, SBO_YetiInvoiceSync_Search.SEARCHRESULT>();

        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : searchResults)
        {
            result.put(getLineKey(sr), sr);
        }
        return result;
    }

    private void updateInvoice(
        Invoice__c invoice,
        SBO_YetiInvoiceSync_Search.SEARCHRESULT sr,
        Map<String, String> accountIdMap,
        Map<String, Invoice__c> savedInvoiceMap,
        List<sObject> errors,
        List<Invoice__c> updates,
        InvoiceTotal invoiceTotal,
        Map<String, String> salesOrderIdMap,
        Map<String, String> deliveryIdMap)
    {
        try
        {
            this.updateInvoiceFieldsFromSearchResult(invoice, accountIdMap, errors, sr, invoiceTotal, salesOrderIdMap, deliveryIdMap);
            if (invoice.Sold_To__c == null)
            {
                System.debug('WARNING: No SoldTo account found on SAP Invoice ID: ' + invoice.Name + ' and will need to be corrected in SAP. Skipping record...');
                return;
            }

            updates.add(invoice);
            savedInvoiceMap.put(invoice.Name, invoice);
        }
        catch (Exception ex)
        {
            String action = 'creating';
            if (invoice.Id != null)
            {
                action = 'updating';
            }
            System.debug('Failure ' + action + ' invoice ' + this.getInvoiceKey(sr) + ':');
            System.debug(sr);
            System.debug(ex);
        }
    }

    private void updateLine(
        Invoice_Lines__c line,
        SBO_YetiInvoiceSync_Search.SEARCHRESULT sr,
        Map<String, Invoice__c> savedInvoiceMap,
        List<Invoice_Lines__c> updates)
    {
        try
        {
            Invoice__c invoice = savedInvoiceMap.get(getInvoiceKey(sr));
            this.updateLineFromSearchResult(invoice, line, sr);
            updates.add(line);
        }
        catch (Exception ex)
        {
            String action = 'creating';
            if (line.Id != null)
            {
                action = 'updating';
            }
            System.debug('Failure ' + action + ' invoice_line ' + this.getLineKey(sr) + ':');
            System.debug(sr);
            System.debug(ex);
        }
    }

    // updateInvoiceFieldsFromSearchResult()
    //
    // fill in invoice fields from the sr data
    private void updateInvoiceFieldsFromSearchResult(
        Invoice__c invoice,
        Map<String, String> accountIdMap,
        List<sObject> errors,
        SBO_YetiInvoiceSync_Search.SEARCHRESULT sr,
        InvoiceTotal invoiceTotal,
        Map<String, String> salesOrderIdMap,
        Map<String, String> deliveryIdMap)
    {
        String key = getInvoiceKey(sr);
        System.debug('Invoice ID: ' + key);

        invoice.Name =  key;
        invoice.Deposit_Balance__c = sr.DepositBalance;
        invoice.Due_Date__c = sr.DueDate;
        invoice.FOB__c = sr.FOB;
        invoice.Invoice_Amount__c = sr.InvoiceAmount;
        invoice.Invoice_Balance__c = sr.InvoiceBalance;
        invoice.Invoice_Date__c = sr.InvoiceDate;
        invoice.PO__c = sr.PurchaseOrderNumber;
        invoice.Sales_Order__c = sr.SalesOrder;
        if (String.isNotBlank(sr.SalesOrder) && salesOrderIdMap.containsKey(sr.SalesOrder))
        {
            invoice.Order__c = Id.valueOf(salesOrderIdMap.get(sr.SalesOrder));
        }

        invoice.Delivery_Number__c = sr.Delivery;
        if (String.isNotBlank(sr.Delivery) && deliveryIdMap.containsKey(sr.Delivery))
        {
            invoice.Delivery__c = Id.valueOf(deliveryIdMap.get(sr.Delivery));
        }

        invoice.Status__c = sr.Status;
        invoice.Terms__c = sr.Terms;

        String notFoundAccountId = UTIL_YetiSyncHelper.getNotFoundAccountId(errors);

        // For these lookup fields, translate customers to accounts
        if (String.isBlank(sr.BillToParty))
        {
            System.debug('No account found for BillToParty: ' + sr.BillToParty);
            invoice.Bill_To__c = null;
            invoice.Bill_To_Number__c = null;
        }
        else
        {
            String billTo = accountIdMap.get(sr.BillToParty);
            invoice.Bill_To__c = billTo;
            invoice.Bill_To_Number__c = sr.BillToParty;
            if (String.isBlank(billTo) && String.isNotBlank(sr.BillToParty))
            {
                invoice.Bill_To__c = notFoundAccountId;
            }
        }

        if (String.isBlank(sr.ShipToParty))
        {
            System.debug('No account found for ShipToParty: ' + sr.ShipToParty);
            invoice.Ship_To__c = null;
            invoice.Ship_To_Number__c = null;
        }
        else
        {
            String shipTo = accountIdMap.get(sr.ShipToParty);
            invoice.Ship_To__c = shipTo;
            invoice.Ship_To_Number__c = sr.ShipToParty;
            if (String.isBlank(shipTo) && String.isNotBlank(sr.ShipToParty))
            {
                invoice.Ship_To__c = notFoundAccountId;
            }
        }

        if (String.isBlank(sr.SoldToParty))
        {
            System.debug('No account found for SoldToParty: ' + sr.SoldToParty);
            invoice.Sold_To__c = null;
            invoice.Sold_To_Number__c = null;
        }
        else
        {
            String soldTo = accountIdMap.get(sr.SoldToParty);
            invoice.Sold_To__c = soldTo;
            invoice.Sold_To_Number__c = sr.SoldToParty;
            if (String.isBlank(soldTo))
            {
                invoice.Sold_To__c = notFoundAccountId;
            }
        }

        invoice.Bill_To_Address__c = UTIL_YetiSyncHelper.buildAddress(
            sr.BillToName1, sr.BillToName2, sr.BillToStreet, sr.BillToCity,
            sr.BillToPostalCode, sr.BillToCountry);

        invoice.Total_Before_Discount__c = invoiceTotal.totalBeforeDiscount;
        invoice.Sub_Total__c = invoiceTotal.subTotal;
        invoice.Tax__c = invoiceTotal.tax;
        invoice.Shipping_Amount__c = invoiceTotal.shippingAmount;
    }


    // updateLineFromSearchResult()
    //
    // fill in invoice line fields from the sr data
    private void updateLineFromSearchResult(
        Invoice__c invoice,
        Invoice_Lines__c invoiceLine,
        SBO_YetiInvoiceSync_Search.SEARCHRESULT sr)
    {
        invoiceLine.Name = getLineKey(sr);
        // You cannot edit the master/detail lookup later
        if (invoiceLine.Id == null)
        {
            invoiceLine.Invoice__c = invoice.Id;
        }

        invoiceLine.Description__c = sr.Description;
        invoiceLine.Ext_Price__c = sr.ExtPrice;
        invoiceLine.Order_Quantity__c = sr.InvoicedQuantity;
        invoiceLine.Packing_Line__c = sr.PackingLineitemNumber;
        invoiceLine.Packing_Slip__c = sr.PackingSlipnumber;
        invoiceLine.Part_Number__c = sr.PartNumber;
        invoiceLine.PO__c = sr.PurchaseOrderNumber;
        invoiceLine.Sales_Order__c = sr.SalesOrder;
        invoiceLine.Unit_Price__c = sr.UnitPrice;
        invoiceLine.Discount__c = sr.Discount;
        invoiceLine.Subtotal__c = sr.Subtotal;
        invoiceLine.UPC__c = sr.UPC;
        invoiceLine.Last_Change_Time__c = DateTime.newInstance(sr.LastChangeDate, sr.LastChangeTime);
    }

    private String getInvoiceKey(SBO_YetiInvoiceSync_Search.SEARCHRESULT sr)
    {
        return sr == null ? null : sr.Invoice;
    }

    private String getLineKey(SBO_YetiInvoiceSync_Search.SEARCHRESULT sr)
    {
        return sr == null ? null : sr.Invoice + '/' + sr.InvoiceItemNumber;
    }

    // getHighestLastChangeDateTimeInResultsForLastSync()
    //
    // Loops over all the results and returns the highest change timestamp as the number of
    // milliseconds since January 1, 1970, 00:00:00 GMT, which will be used as a search param on
    // the next batch execution.
    private String getHighestLastChangeDateTimeInResultsForLastSync(
        List<SBO_YetiInvoiceSync_Search.SEARCHRESULT> searchResults)
    {
        if (0 == searchResults.size())
        {
            return null;
        }
        Long result = 0;
        for (SBO_YetiInvoiceSync_Search.SEARCHRESULT sr : searchResults)
        {
            Long value = Datetime.newInstance(sr.LastChangeDate, sr.LastChangeTime).getTime();
            if (value > result)
            {
                result = value;
            }
        }
        return String.valueOf(result);
    }
}
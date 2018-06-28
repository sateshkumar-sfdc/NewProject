public with sharing class UTIL_DeliverySync_Batch
    implements Database.Batchable<SBO_YetiDeliverySync_Search.SEARCHRESULT>,
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

    public void setBatchParam(String value)
    {
        this.fromLastSync = value;
    }
    /* end I_ParameterizedSync methods */

    /* Database.Batchable methods start(), execute(), and finish() */
    // start()
    //
    // Calls SBO and returns search results of update deliveries
    public List<SBO_YetiDeliverySync_Search.SEARCHRESULT> start(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' started');

        SBO_YetiDeliverySync_Search sbo = new SBO_YetiDeliverySync_Search();

        sbo.SearchContext.SEARCHPARAMS.MAX_ROWS = MAX_ROWS;

        Datetime lastSync = getLastSyncDate();
        if (null != lastSync)
        {
            sbo.SearchContext.SEARCHPARAMS.FromLastChangeDate = lastSync.date();
            sbo.SearchContext.SEARCHPARAMS.LastChangeTimeFrom = lastSync.time();
            this.jobInfo.add('from:' + lastSync.format('yyyy-MM-dd HH:mm:ss'));
        }
        else
        {
            this.jobInfo.add('no existing rows - completely fresh start (or something terrible like a'
                + ' null is in the last changed date)');
        }

        // Execute the search
        SBO_YetiDeliverySync_Search.YetiDeliverySync_SR result = sbo.execute();

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

        List<SBO_YetiDeliverySync_Search.SEARCHRESULT> searchResults = result.getResults();
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
        List<SBO_YetiDeliverySync_Search.SEARCHRESULT> searchResults)
    {
        System.debug(context.getJobId() + ' executing');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        if (null == searchResults || 0 == searchResults.size()){ return;}

        List<Deliveries__c> deliveryUpdates = new List<Deliveries__c>();
        List<Deliveries__c> deliveryInserts = new List<Deliveries__c>();
        List<Delivery_Lines__c> lineUpdates = new List<Delivery_Lines__c>();
        List<Delivery_Lines__c> lineInserts = new List<Delivery_Lines__c>();
        List<sObject> errors = new List<sObject>();
        Map<String, Deliveries__c> savedDeliveryMap = new Map<String, Deliveries__c>();

        Set<String> customerIds = getCustomerIdsFromSearchResults(searchResults);
        Map<String, String> accountIdMap = UTIL_SyncHelper.createAccountIdMap(customerIds);

        Map<String, SBO_YetiDeliverySync_Search.SEARCHRESULT> deliveryMap = createDeliveryKeyMap(searchResults);
        Map<String, SBO_YetiDeliverySync_Search.SEARCHRESULT> lineMap = createLineKeyMap(searchResults);
        Set<String> erpOrderNumbers = getSalesOrderNumbersFromSearchResults(searchResults);
        Map<String, String> orderIdMap = UTIL_YetiSyncHelper.createSalesOrderIdMap(erpOrderNumbers);
        Set<String> invoiceNumbers = getInvoiceNumbersFromSearchResults(searchResults);
        Map<String, String> invoiceIdMap = UTIL_YetiSyncHelper.createInvoiceIdMap(invoiceNumbers);

        // First, update matching existing orders
        for (SObject existingDeliverySObject : UTIL_SyncHelper.getMatchingRecords('Deliveries__c', deliveryMap.keySet()))
        {
            Deliveries__c existingDelivery = (Deliveries__c) existingDeliverySObject;
            SBO_YetiDeliverySync_Search.SEARCHRESULT sr = deliveryMap.get(existingDelivery.Name);
            // Updates fields, saves record for later reference, and adds to deliveryUpdates list for later commit
            this.updateDelivery(existingDelivery, sr, accountIdMap, savedDeliveryMap, errors, deliveryUpdates, orderIdMap, invoiceIdMap);
            // Remove from map so we end up with a map that only has new results in it
            deliveryMap.remove(existingDelivery.Name);
        }

        // Then, create new orders
        for (SBO_YetiDeliverySync_Search.SEARCHRESULT sr : deliveryMap.values())
        {
            Deliveries__c newOrder = new Deliveries__c();
            this.updateDelivery(newOrder, sr, accountIdMap, savedDeliveryMap, errors, deliveryInserts, orderIdMap, invoiceIdMap);
        }

        // Commit all the delivery changes
        if (deliveryUpdates.size() > 0)
        {
            update deliveryUpdates;
        }

        if (deliveryInserts.size() > 0)
        {
            insert deliveryInserts;
        }

        if (errors.size() > 0)
        {
            insert errors;
        }

        // Now do the line item updates
        for (SObject existingLineSObject : UTIL_SyncHelper.getMatchingRecords('Delivery_Lines__c', lineMap.keySet()))
        {
            Delivery_Lines__c existingLine = (Delivery_Lines__c) existingLineSObject;
            SBO_YetiDeliverySync_Search.SEARCHRESULT sr = lineMap.get(existingLine.Name);
            this.updateLine(existingLine, sr, savedDeliveryMap, lineUpdates);
            // Remove from map so we end up with a map that only has new results in it
            lineMap.remove(existingLine.Name);
        }

        // and line item creates
        for (SBO_YetiDeliverySync_Search.SEARCHRESULT sr : lineMap.values())
        {
            Delivery_Lines__c newLine = new Delivery_Lines__c();
            this.updateLine(newLine, sr, savedDeliveryMap, lineInserts);
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
            this.isAnotherBatchNeeded, 'UTIL_DeliverySync_Schedule', this.fromLastSync);

        if (!this.isAnotherBatchNeeded)
        {
            Database.executeBatch(new UTIL_BatchCleanup('Deliveries__c'));
        }
    }
    /* end Database.Batchable methods */

    // getLastSyncDate()
    //
    // returns the hightest Last_Change_Time from the delivery table, which is used as
    // an SBO search param to filter only deliveries updated since the last batch ran
    private Datetime getLastSyncDate()
    {
        if (null != this.fromLastSync)
        {
            return Datetime.newInstance(long.valueOf(this.fromLastSync));
        }
        return UTIL_SyncHelper.getLastDateFromTable('Last_Change_Time__c', 'Delivery_Lines__c');
    }

    // getCustomerIdsFromSearchResults()
    //
    // returns a set of all the customer ids referenced in the SR
    private Set<String> getCustomerIdsFromSearchResults(
        List<SBO_YetiDeliverySync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiDeliverySync_Search.SEARCHRESULT sr : searchResults)
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

    // createDeliveryKeyMap()
    //
    // create a map of delivery key / search result
    private Map<String, SBO_YetiDeliverySync_Search.SEARCHRESULT> createDeliveryKeyMap(
        List<SBO_YetiDeliverySync_Search.SEARCHRESULT> searchResults)
    {
        Map<String, SBO_YetiDeliverySync_Search.SEARCHRESULT> result =
            new Map<String, SBO_YetiDeliverySync_Search.SEARCHRESULT>();

        for (SBO_YetiDeliverySync_Search.SEARCHRESULT sr : searchResults)
        {
            result.put(getDeliveryKey(sr), sr);
        }
        return result;
    }

    // createLineKeyMap()
    //
    // create a map of delivery line key / search result
    private Map<String, SBO_YetiDeliverySync_Search.SEARCHRESULT> createLineKeyMap(
        List<SBO_YetiDeliverySync_Search.SEARCHRESULT> searchResults)
    {
        Map<String, SBO_YetiDeliverySync_Search.SEARCHRESULT> result =
            new Map<String, SBO_YetiDeliverySync_Search.SEARCHRESULT>();

        for (SBO_YetiDeliverySync_Search.SEARCHRESULT sr : searchResults)
        {
            result.put(getLineKey(sr), sr);
        }
        return result;
    }

    private void updateDelivery(
        Deliveries__c delivery,
        SBO_YetiDeliverySync_Search.SEARCHRESULT sr,
        Map<String, String> accountIdMap,
        Map<String, Deliveries__c> savedDeliveryMap,
        List<sObject> errors,
        List<Deliveries__c> updates,
        Map<String, String> orderIdMap,
        Map<String, String> invoiceIdMap)
    {
        try
        {
            this.updateDeliveryFieldsFromSearchResult(delivery, accountIdMap, errors, sr, orderIdMap, invoiceIdMap);
            if (delivery.Sold_To__c == null)
            {
                System.debug('WARNING: No SoldTo account found on SAP Delivery ID: ' + delivery.Name + ' and will need to be corrected in SAP. Skipping record...');
                return;
            }

            updates.add(delivery);
            savedDeliveryMap.put(delivery.Name, delivery);
        }
        catch (Exception ex)
        {
            String action = 'creating';
            if (delivery.Id != null)
            {
                action = 'updating';
            }
            System.debug('Failure ' + action + ' delivery ' + this.getDeliveryKey(sr) + ':');
            System.debug(sr);
            System.debug(ex);
        }
    }

    private void updateLine(
        Delivery_Lines__c line,
        SBO_YetiDeliverySync_Search.SEARCHRESULT sr,
        Map<String, Deliveries__c> savedDeliveryMap,
        List<Delivery_Lines__c> updates)
    {
        try
        {
            Deliveries__c delivery = savedDeliveryMap.get(getDeliveryKey(sr));
            this.updateLineFromSearchResult(delivery, line, sr);
            updates.add(line);
        }
        catch (Exception ex)
        {
            String action = 'creating';
            if (line.Id != null)
            {
                action = 'updating';
            }
            System.debug('Failure ' + action + ' delivery_line ' + this.getLineKey(sr) + ':');
            System.debug(sr);
            System.debug(ex);
        }
    }

    // updateDeliveryFieldsFromSearchResult()
    //
    // fill in delivery fields from the sr data
    private void updateDeliveryFieldsFromSearchResult(
        Deliveries__c delivery,
        Map<String, String> accountIdMap,
        List<sObject> errors,
        SBO_YetiDeliverySync_Search.SEARCHRESULT sr,
        Map<String, String> orderIdMap,
        Map<String, String> invoiceIdMap)
    {
        System.debug('CustomerShipment: ' + sr.CustomerShipment);

        String key = getDeliveryKey(sr);
        delivery.Name =  key;
        delivery.Account__c = sr.Account;
        delivery.ERP_Order__c = sr.ErpOrder;
        if (String.isNotBlank(sr.ErpOrder) && orderIdMap.containsKey(sr.ErpOrder))
        {
            delivery.Order__c = Id.valueOf(orderIdMap.get(sr.ErpOrder));
        }
        delivery.Need_By_Date__c = sr.NeedByDate;
        delivery.Sent_To_3PL__c = sr.SentTo3pl == 'X';
        delivery.Ship_Date__c = sr.ShipDate;
        delivery.Ship_To_Party__c = sr.ShipToParty;
        delivery.Site__c = sr.Site;
        delivery.Tracking_Number__c = sr.TrackingNumber;
        delivery.Unique_ID__c = sr.UniqueID;
        delivery.Warehouse__c = sr.Warehouse;
        delivery.Shipping_Method__c = sr.ShipMethod;
        delivery.Status__c = sr.SearchResultStatus;

        delivery.Invoice_Number__c = sr.Invoice;
        if (String.isNotBlank(sr.Invoice) && invoiceIdMap.containsKey(sr.Invoice))
        {
            delivery.Invoice__c = Id.valueOf(invoiceIdMap.get(sr.Invoice));
        }

        String notFoundAccountId = UTIL_YetiSyncHelper.getNotFoundAccountId(errors);

        // For these lookup fields, translate customers to accounts

        if (String.isBlank(sr.BillToParty))
        {
            System.debug('No matching account found for BillToParty: ' + sr.BillToParty);
            delivery.Bill_To__c = null;
            delivery.Bill_To_Number__c = null;
        }
        else
        {
            String billTo = accountIdMap.get(sr.BillToParty);
            delivery.Bill_To__c = billTo;
            delivery.Bill_To_Number__c = sr.BillToParty;
            if (String.isBlank(billTo) && String.isNotBlank(sr.BillToParty))
            {
                delivery.Bill_To__c = notFoundAccountId;
            }
        }

        if (String.isBlank(sr.ShipToParty))
        {
            System.debug('No matching account for ShipToParty: ' + sr.ShipToParty);
            delivery.Ship_To__c = null;
            delivery.Ship_To_Number__c = null;
        }
        else
        {
            String shipTo = accountIdMap.get(sr.ShipToParty);
            delivery.Ship_To__c = shipTo;
            delivery.Ship_To_Number__c = sr.ShipToParty;
            if (String.isBlank(shipTo) && String.isNotBlank(sr.ShipToParty))
            {
                delivery.Ship_To__c = notFoundAccountId;
            }
        }

        if (String.isBlank(sr.SoldToParty))
        {
            System.debug('No matching account for SoldToParty: ' + sr.SoldToParty);
            delivery.Sold_To__c = null;
            delivery.Sold_To_Number__c = null;
        }
        else
        {
            String soldTo = accountIdMap.get(sr.SoldToParty);
            delivery.Sold_To__c = soldTo;
            delivery.Sold_To_Number__c = sr.SoldToParty;
            if (String.isBlank(soldTo) && String.isNotBlank(sr.SoldToParty))
            {
                delivery.Sold_To__c = notFoundAccountId;
            }
        }
    }


    // updateLineFromSearchResult()
    //
    // fill in delivery line fields from the sr data
    private void updateLineFromSearchResult(
        Deliveries__c delivery,
        Delivery_Lines__c deliveryLine,
        SBO_YetiDeliverySync_Search.SEARCHRESULT sr)
    {
        deliveryLine.Name = getLineKey(sr);
        // You cannot edit the master/detail lookup later
        if (deliveryLine.Id == null)
        {
            deliveryLine.Deliveries__c = delivery.Id;
        }

        deliveryLine.ERP_Order__c = sr.ErpOrder;
        deliveryLine.Need_By_Date__c = sr.NeedByDate;
        deliveryLine.Pack_Line_Num__c = sr.PackLineNum;
        deliveryLine.Part_Description__c = sr.PartDescription;
        deliveryLine.Part_Number__c = sr.PartNumber;
        deliveryLine.Quantity__c = sr.Quantity;
        deliveryLine.Ship_By_Date__c = sr.ShipByDate;
        deliveryLine.Ship_Via__c = sr.ShipVia;
        deliveryLine.UOM__c = sr.Uom;
        deliveryLine.Warehouse__c = sr.Warehouse;
        deliveryLine.Last_Change_Time__c = DateTime.newInstance(sr.LastChangeDate, sr.LastChangeTime);
        //QuantityShipped is 'QTY_Ordered' while Quantity is similar to 'QTY_Shipped'
        deliveryLine.QTY_Ordered__c = String.valueOf(sr.QuantityOrdered);
        deliveryLine.QTY_Shipped__c = String.valueOf(sr.Quantity);
        deliveryLine.UPC__c = sr.Upc;
    }

    private String getDeliveryKey(SBO_YetiDeliverySync_Search.SEARCHRESULT sr)
    {
        return sr.CustomerShipment;
    }

    private String getLineKey(SBO_YetiDeliverySync_Search.SEARCHRESULT sr)
    {
        return sr.CustomerShipment + '/' + sr.DeliveryItemNumber;
    }

    // getSalesOrderNumbersFromSearchResults()
    //
    // returns a set of all the Delivery Numbers referenced in the SR
    private Set<String> getSalesOrderNumbersFromSearchResults(
        List<SBO_YetiDeliverySync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiDeliverySync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.ErpOrder))
            {
                result.add(sr.ErpOrder);
            }
        }
        return result;
    }

    // getInvoiceNumbersFromSearchResults()
    //
    // returns a set of all the Delivery Numbers referenced in the SR
    private Set<String> getInvoiceNumbersFromSearchResults(
        List<SBO_YetiDeliverySync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiDeliverySync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.Invoice))
            {
                result.add(sr.Invoice);
            }
        }
        return result;
    }

    // getHighestLastChangeDateTimeInResultsForLastSync()
    //
    // Loops over all the results and returns the highest change timestamp as the number of
    // milliseconds since January 1, 1970, 00:00:00 GMT, which will be used as a search param on
    // the next batch execution.
    private String getHighestLastChangeDateTimeInResultsForLastSync(
        List<SBO_YetiDeliverySync_Search.SEARCHRESULT> searchResults)
    {
        if (0 == searchResults.size())
        {
            return null;
        }

        Long result = 0;
        for (SBO_YetiDeliverySync_Search.SEARCHRESULT sr : searchResults)
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
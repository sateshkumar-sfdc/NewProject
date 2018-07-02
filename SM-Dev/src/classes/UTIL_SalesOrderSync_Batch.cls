public with sharing class UTIL_SalesOrderSync_Batch
    implements Database.Batchable<SBO_YetiSalesOrderSync_Search.SEARCHRESULT>,
    Database.AllowsCallouts,
    Database.Stateful,
    I_ParameterizedSync
{
    // MAX_ROWS is a SBO parameter which controls the maximum sales header rows retrieved,
    //  however, there have been 2600+ detail records returned by a MAX_ROWS of 150
    //  because of sales orders with large numbers of lines.
    // The response size needs to remain within a reasonable size so that the Apex heap
    //  limit isn't exceeded which would cause the job to fail.
    private final Integer MAX_ROWS = 150;

    // isAnotherBatchNeeded is a flag set in start() after examing how many rows were returned
    //  telling finish() whether to schedule another instance to retrieve additional records
    private Boolean isAnotherBatchNeeded = false;

    // jobInfo contains debug information persisted across contexts since start(),
    //   execute(), and finish() all run in separate contexts with separate debug logs
    private List<String> jobInfo = new List<String>();

    private Map<String, Decimal> orderTaxMap = new Map<String, Decimal>();
    private Map<String, Decimal> orderShippingMap = new Map<String, Decimal>();

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
    // Calls SBO and returns search results of update sales orders
    public List<SBO_YetiSalesOrderSync_Search.SEARCHRESULT> start(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' started');

        SBO_YetiSalesOrderSync_Search sbo = new SBO_YetiSalesOrderSync_Search();

        sbo.SearchContext.SEARCHPARAMS.MAX_ROWS = MAX_ROWS;

        Datetime lastSync = getLastSyncDate();
        if (null != lastSync)
        {
            sbo.SearchContext.SEARCHPARAMS.FromLastChangeDate = lastSync.date();
            sbo.SearchContext.SEARCHPARAMS.FromChangeTime = lastSync.time();
            this.jobInfo.add('from:' + lastSync.format('yyyy-MM-dd HH:mm:ss'));
        }
        else
        {
            this.jobInfo.add('no existing rows - completely fresh start (or something terrible like a'
                + ' null is in the last changed date)');
        }

        // Execute the search
        SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SR result = sbo.execute();

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

        List<SBO_YetiSalesOrderSync_Search.SEARCHRESULT> searchResults = result.getResults();
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
        List<SBO_YetiSalesOrderSync_Search.SEARCHRESULT> searchResults)
    {
        System.debug(context.getJobId() + ' executing');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        if (null == searchResults || 0 == searchResults.size()) {return;}

        List<Order__c> orderUpdates = new List<Order__c>();
        List<Order__c> orderInserts = new List<Order__c>();
        List<Order_Line__c> lineUpdates = new List<Order_Line__c>();
        List<Order_Line__c> lineInserts = new List<Order_Line__c>();
        List<sObject> errors = new List<sObject>();
        Map<String, Order__c> savedOrderMap = new Map<String, Order__c>();

        this.orderTaxMap.clear();
        this.orderShippingMap.clear();

        Set<String> customerIds = getCustomerIdsFromSearchResults(searchResults);
        Map<String, String> accountIdMap = UTIL_SyncHelper.createAccountIdMap(customerIds);

        Map<String, SBO_YetiSalesOrderSync_Search.SEARCHRESULT> orderMap = createOrderKeyMap(searchResults);
        Map<String, SBO_YetiSalesOrderSync_Search.SEARCHRESULT> lineMap = createLineKeyMap(searchResults);
        createShippingTaxKeyMap(searchResults);

        // First, update matching existing orders
        for (SObject existingOrderSObject : UTIL_SyncHelper.getMatchingRecords('Order__c', orderMap.keySet()))
        {
            Order__c existingOrder = (Order__c) existingOrderSObject;
            SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr = orderMap.get(existingOrder.Name);
            // Updates fields, saves record for later reference, and adds to orderUpdates list for later commit
            this.updateOrder(existingOrder, sr, accountIdMap, savedOrderMap, errors, orderUpdates);
            // Remove from map so we end up with a map that only has new results in it
            orderMap.remove(existingOrder.Name);
        }

        // Then, create new orders
        for (SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr : orderMap.values())
        {
            Order__c newOrder = new Order__c();
            this.updateOrder(newOrder, sr, accountIdMap, savedOrderMap, errors, orderInserts);
        }

        // Commit all the order changes
        if (orderUpdates.size() > 0)
        {
            update orderUpdates;
        }

        if (orderInserts.size() > 0)
        {
            insert orderInserts;
        }

        if (errors.size() > 0)
        {
            insert errors;
        }

         // Now do the line item updates
        for (SObject existingLineSObject : UTIL_SyncHelper.getMatchingRecords('Order_Line__c', lineMap.keySet()))
        {
            Order_Line__c existingLine = (Order_Line__c) existingLineSObject;
            SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr = lineMap.get(existingLine.Name);
            this.updateLine(existingLine, sr, savedOrderMap, lineUpdates);
            // Remove from map so we end up with a map that only has new results in it
            lineMap.remove(existingLine.Name);
        }

        // and line item creates
        for (SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr : lineMap.values())
        {
            Order_Line__c newLine = new Order_Line__c();
            this.updateLine(newLine, sr, savedOrderMap, lineInserts);
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
            this.isAnotherBatchNeeded, 'UTIL_SalesOrderSync_Schedule', this.fromLastSync);
        if (!this.isAnotherBatchNeeded)
        {
            Database.executeBatch(new UTIL_BatchCleanup('Order__c'));
        }
    }
    /* end Database.Batchable methods */

    // getLastSyncDate()
    //
    // returns the hightest LastChangeDate from the sales order table, which is used as
    // an SBO search param to filter only orders updated since the last batch ran
    private Datetime getLastSyncDate()
    {
        if (null != this.fromLastSync)
        {
            return Datetime.newInstance(long.valueOf(this.fromLastSync));
        }
        return UTIL_SyncHelper.getLastDateFromTable('Last_Change_Time__c', 'Order_Line__c');
    }

    // getCustomerIdsFromSearchResults()
    //
    // returns a set of all the customer ids referenced in the SR
    private Set<String> getCustomerIdsFromSearchResults(
        List<SBO_YetiSalesOrderSync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.BillTo))
            {
                result.add(sr.BillTo);
            }
            if (String.isNotBlank(sr.ShipTo))
            {
                result.add(sr.ShipTo);
            }
            if (String.isNotBlank(sr.SoldTo))
            {
                result.add(sr.SoldTo);
            }
        }
        return result;
    }

    // createOrderKeyMap()
    //
    // create a map of order key / search result
    private Map<String, SBO_YetiSalesOrderSync_Search.SEARCHRESULT> createOrderKeyMap(
        List<SBO_YetiSalesOrderSync_Search.SEARCHRESULT> searchResults)
    {
        Map<String, SBO_YetiSalesOrderSync_Search.SEARCHRESULT> result =
            new Map<String, SBO_YetiSalesOrderSync_Search.SEARCHRESULT>();

        for (SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr : searchResults)
        {
            result.put(getOrderKey(sr), sr);
        }
        return result;
    }

    // createLineKeyMap()
    //
    // create a map of order line key / search result
    private Map<String, SBO_YetiSalesOrderSync_Search.SEARCHRESULT> createLineKeyMap(
        List<SBO_YetiSalesOrderSync_Search.SEARCHRESULT> searchResults)
    {
        Map<String, SBO_YetiSalesOrderSync_Search.SEARCHRESULT> result =
            new Map<String, SBO_YetiSalesOrderSync_Search.SEARCHRESULT>();

        for (SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr : searchResults)
        {
            result.put(getLineKey(sr), sr);
        }
        return result;
    }

    // createShippingTaxKeyMap
    //
    // Create a map of (Order key / Tax value) & (Order key / Shipping Value)
    private void createShippingTaxKeyMap(
        List<SBO_YetiSalesOrderSync_Search.SEARCHRESULT> searchResults)
    {
        for (SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr : searchResults)
        {
            String orderKey = getOrderKey(sr);

            if (!this.orderTaxMap.containsKey(orderKey))
            {
                Decimal taxValue = (sr.Tax != null ? sr.Tax : 0);
                this.orderTaxMap.put(orderKey, taxValue);
            }
            else
            {
                Decimal currentOrderTaxVal = this.orderTaxMap.get(orderKey);
                currentOrderTaxVal += (sr.Tax != null ? sr.Tax : 0);
                this.orderTaxMap.put(orderKey, currentOrderTaxVal);
            }

            if (!this.orderShippingMap.containsKey(orderKey))
            {
                Decimal shippingValue = (sr.ShippingAmount != null ? sr.ShippingAmount : 0);
                this.orderShippingMap.put(orderKey, shippingValue);
            }
            else
            {
                Decimal currentOrderShippingVal = this.orderShippingMap.get(orderKey);
                currentOrderShippingVal += (sr.ShippingAmount != null ? sr.ShippingAmount : 0);
                this.orderShippingMap.put(orderKey, currentOrderShippingVal);
            }
        }
    }

    private void updateOrder(
        Order__c order,
        SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr,
        Map<String, String> accountIdMap,
        Map<String, Order__c> savedOrderMap,
        List<sObject> errors,
        List<Order__c> updates)
    {
        try
        {
            this.updateOrderFieldsFromSearchResult(order, accountIdMap, errors, sr);
            if (order.Sold_To__c == null)
            {
                System.debug('WARNING: No SoldTo account found on SAP Sales Order ID: ' + order.Name + ' and will need to be corrected in SAP. Skipping record...');
                return;
            }

            updates.add(order);
            savedOrderMap.put(order.Name, order);
        }
        catch (Exception ex)
        {
            String action = 'creating';
            if (order.Id != null)
            {
                action = 'updating';
            }
            System.debug('Failure ' + action + ' order ' + this.getOrderKey(sr) + ':');
            System.debug(sr);
            System.debug(ex);
        }
    }

    private void updateLine(
        Order_Line__c line,
        SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr,
        Map<String, Order__c> savedOrderMap,
        List<Order_Line__c> updates)
    {
        try
        {
            Order__c order = savedOrderMap.get(getOrderKey(sr));
            this.updateLineFromSearchResult(order, line, sr);
            updates.add(line);
        }
        catch (Exception ex)
        {
            String action = 'creating';
            if (line.Id != null)
            {
                action = 'updating';
            }
            System.debug('Failure ' + action + ' order_line ' + this.getLineKey(sr) + ':');
            System.debug(sr);
            System.debug(ex);
        }
    }

    // updateOrderFieldsFromSearchResult()
    //
    // fill in order fields from the sr data
    private void updateOrderFieldsFromSearchResult(
        Order__c order,
        Map<String, String> accountIdMap,
        List<sObject> errors,
        SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr)
    {
        String key = getOrderKey(sr);
        System.debug('SalesOrder ID: ' + key);

        Decimal taxValue = this.orderTaxMap.get(key);
        //Decimal shippingValue = this.orderShippingMap.get(key);
        order.Name = key;
        order.Discount_Amount__c = sr.DiscountAmount;
        order.FOB__c = sr.Fob;
        order.Need_By_Date__c = sr.NeedByDate;
        order.Order_Comment__c = sr.OrderComment;
        order.Order_Date__c = sr.OrderDate;
        order.Order_Held__c = sr.OrderHeld == 'X';
        order.Order_Source__c = sr.OrderSource;
        order.Order_Status__c = sr.OrderStatus;
        order.Order_Subtotal__c = sr.OrderSubtotal;
        order.Order_Type__c = sr.SalesDocumentType;
        order.PurchaseOrder__c = sr.PurchaseOrder;
        order.Ship_By__c = sr.ShipBy;
        order.Ship_Complete__c = sr.ShipComplete == 'X';
        order.Ship_Via__c = sr.ShipVia;
        order.Terms__c = sr.Terms;
        order.Order_Total__c = sr.OrderTotal;
        order.Tax__c = taxValue;
        //order.Shipping_Amount__c = shippingValue;
        order.Shipping_Amount__c = sr.ShippingAmount;
        order.Credit_Hold_Status__c = sr.CreditHoldStatusDescription;
        order.Bill_To_Address__c = UTIL_YetiSyncHelper.buildAddress(
                sr.BillToName1, sr.BillToName2, sr.BillToStreet, sr.BillToCity,
                sr.BillToPostCode, sr.BillToCountry);

        String notFoundAccountId = UTIL_YetiSyncHelper.getNotFoundAccountId(errors);

        // For these lookup fields, translate customers to accounts
        if (String.isBlank(sr.BillTo))
        {
            System.debug('No matching account for BillTo: ' + sr.BillTo);
            order.Bill_To__c = null;
            order.Bill_To_Number__c = null;
        }
        else
        {
            String billTo = accountIdMap.get(sr.BillTo);
            order.Bill_To__c = billTo;
            order.Bill_To_Number__c = sr.BillTo;
            if (String.isBlank(billTo) && String.isNotBlank(sr.BillTo))
            {
                order.Bill_To__c = notFoundAccountId;
            }
        }

        if (String.isBlank(sr.ShipTo))
        {
            System.debug('No matching account for ShipTo: ' + sr.ShipTo);
            order.Ship_To__c = null;
            order.Ship_To_Number__c = null;
        }
        else
        {
            String shipTo = accountIdMap.get(sr.ShipTo);
            order.Ship_To__c = shipTo;
            order.Ship_To_Number__c = sr.ShipTo;
            if (String.isBlank(shipTo) && String.isNotBlank(sr.ShipTo))
            {
                order.Ship_To__c = notFoundAccountId;
            }
        }

        if (String.isBlank(sr.SoldTo))
        {
            System.debug('No matching account for SoldTo: ' + sr.SoldTo);
            order.Sold_To__c = null;
            order.Sold_To_Number__c = null;
        }
        else
        {
            String soldTo = accountIdMap.get(sr.SoldTo);
            order.Sold_To__c = soldTo;
            order.Sold_To_Number__c = sr.SoldTo;
            if (String.isBlank(soldTo))
            {
                order.Sold_To__c = notFoundAccountId;
            }
        }
    }

    // updateLineFromSearchResult()
    //
    // fill in order line fields from the sr data
    private void updateLineFromSearchResult(
        Order__c order,
        Order_Line__c orderLine,
        SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr)
    {
        orderLine.Name = getLineKey(sr);

        // You cannot edit the master/detail lookup later
        if (orderLine.Id == null)
        {
            orderLine.Order_Details__c = order.Id;
        }
        orderLine.DiscountPrice__c = sr.DiscountPrice;
        orderLine.Ext_Price__c = sr.ExtPrice;
        orderLine.Line_Comment__c = sr.LineComment;
        orderLine.Line_Number__c = sr.LineNumber;
        orderLine.Line_Status__c = sr.LineStatusDesc;
        orderLine.Need_By_Date__c = sr.NeedByDate;
        orderLine.Need_By__c = sr.NeedBy;
        orderLine.Order_Line__c = sr.Order;
        orderLine.Order_Number__c = sr.ErpOrderNumber;
        orderLine.Order_Quantity__c = sr.OrderQuantity;
        orderLine.Part_Number__c = sr.PartNumber;
        orderLine.Product_Group__c = sr.ProductGroup;
        orderLine.Product__c = sr.Product;
        orderLine.Request_Date__c = sr.RequestDate;
        orderLine.Sales_Category__c = sr.SalesCategory;
        orderLine.Total_Shipped__c = sr.TotalShipped;
        orderLine.Unit_Price__c = sr.UnitPrice;
        orderLine.UPC__c = sr.Upc;
        orderLine.Product_Description__c = sr.ProductDesc;
        orderLine.Last_Change_Date__c = Date.valueOf(sr.LastChangeDate);
        orderLine.Last_Change_Time__c = DateTime.newInstance(sr.LastChangeDate, sr.LastChangeTime);
    }

    private String getOrderKey(SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr)
    {
        return sr.ErpOrderNumber;
    }

    private String getLineKey(SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr)
    {
        return sr.ErpOrderNumber + '/' + sr.LineNumber;
    }

    // getHighestLastChangeDateTimeInResultsForLastSync()
    //
    // Loops over all the results and returns the highest change timestamp as the number of
    // milliseconds since January 1, 1970, 00:00:00 GMT, which will be used as a search param on
    // the next batch execution.
    private String getHighestLastChangeDateTimeInResultsForLastSync(
        List<SBO_YetiSalesOrderSync_Search.SEARCHRESULT> searchResults)
    {
        if (0 == searchResults.size())
        {
            return null;
        }

        Long result = 0;
        for (SBO_YetiSalesOrderSync_Search.SEARCHRESULT sr : searchResults)
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
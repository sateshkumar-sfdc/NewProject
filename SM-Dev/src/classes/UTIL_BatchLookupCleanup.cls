public with sharing class UTIL_BatchLookupCleanup
    implements Database.Batchable<SObject>, Database.Stateful
{
    // jobInfo contains debug information persisted across contexts since start(),
    //   execute(), and finish() all run in separate contexts with separate debug logs
    private List<String> jobInfo = new List<String>();
    private List<SObject> errors = new List<SObject>();

    //Sets of object API name that can execute the cleanup process
    private Set<String> setsOfObjectName = new Set<String>
    {
        'Invoice__c', 'Deliveries__c', 'Order__c'
    };

    private String syncProcess;
    private String syncObject;

    public UTIL_BatchLookupCleanup(String syncProcess, String syncObject)
    {
        this.syncProcess = syncProcess;
        this.syncObject = syncObject;
    }

    //start()
    //
    //Start querying the records
    public Database.QueryLocator start(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' starts');
        System.debug('Start Batch for: ' + this.syncProcess + ' ' + this.syncObject);

        if (setsOfObjectName.contains(this.syncProcess) && setsOfObjectName.contains(this.syncObject))
        {
            String query = buildQueryString();
            if (null != query)
            {
                return Database.getQueryLocator(query);
            }
        }
        // Returning null causes "System.UnexpectedException: Start did not return a valid iterable object."
        // So to NOOP we must return a query that will always give 0 results. Id should never be
        // null in any table so we can arbitrarily pick Account.
        return Database.getQueryLocator([SELECT Id FROM Account WHERE Id = null]);
    }

    //execute()
    //
    //Execute the cleanup process
    public void execute(Database.BatchableContext context, List<SObject> records)
    {
        System.debug(context.getJobId() + ' executing');
        System.debug('Execute Batch for: ' + this.syncProcess + ' ' + this.syncObject);
        this.jobInfo.add('Execute Batch for: ' + this.syncProcess + ' ' + this.syncObject);
        this.jobInfo.add('resultsSize: ' + records.size());
        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        Set<String> syncObjectNumbers = new Set<String>();
        List<SObject> updateRecords = new List<SObject>();

        //Pull off SAP document numbers to select matching SalesForce objects
        for (SObject result : records)
        {
            //UTIL_DeliverySync_Batch just ran sync results with the Invoice__c object
            //Pull off the SAP Delivery Number from the Invoice__c object
            if (this.syncProcess.equals('Deliveries__c') && this.syncObject.equals('Invoice__c'))
            {
                if (String.isBlank((String) result.get('Delivery__c')))
                {
                    syncObjectNumbers.add((String) result.get('Delivery_Number__c'));
                }
            }
            else if (this.syncProcess.equals('Order__c'))
            {
                if (String.isBlank((String) result.get('Order__c')))
                {
                    //UTIL_SalesOrderSync_Batch just ran sync results with the Invoice__c object
                    //Pull off the SAP Sales Order Number from the Invoice__c object
                    if (this.syncObject.equals('Invoice__c'))
                    {
                        syncObjectNumbers.add((String) result.get('Sales_Order__c'));
                    }
                    //UTIL_SalesOrderSync_Batch just ran sync results with the Deliveries__c object
                    //Pull off the SAP Sales Order Number from the Deliveries__c object
                    else if (this.syncObject.equals('Deliveries__c'))
                    {
                        syncObjectNumbers.add((String) result.get('ERP_Order__c'));
                    }
                }
            }
            //UTIL_InvoiceSync_Batch just ran sync results with the Deliveries__c object
            //Pull off the SAP Invoice Number from the Deliveries__c object
            else if (this.syncProcess.equals('Invoice__c') && this.syncObject.equals('Deliveries__c'))
            {
                if (String.isBlank((String) result.get('Invoice__c')))
                {
                    syncObjectNumbers.add((String) result.get('Invoice_Number__c'));
                }
            }
        }

        //UTIL_DeliverySync_Batch just ran sync results with the Invoice__c object
        //Get the Delivers__c Ids for the matching SAP Delivery Numbers
        Map<String, String> syncObjectLink;
        if (this.syncProcess.equals('Deliveries__c'))
        {
            syncObjectLink = UTIL_YetiSyncHelper.createDeliveryIdMap(syncObjectNumbers);
        }
        //UTIL_SalesOrderSync_Batch just ran sync results with the Invoice__c and Deliveries__c objects
        //Get the Order__c Ids for the matching SAP Sales Order Numbers
        else if (this.syncProcess.equals('Order__c'))
        {
            syncObjectLink = UTIL_YetiSyncHelper.createSalesOrderIdMap(syncObjectNumbers);
        }
        //UTIL_InvoiceSync_Batch just ran sync results with the Deliveries__c object
        //Get the Invoice__c Ids for the matching SAP Invoice Numbers
        else if (this.syncProcess.equals('Invoice__c'))
        {
            syncObjectLink = UTIL_YetiSyncHelper.createInvoiceIdMap(syncObjectNumbers);
        }

        System.debug('SyncProcess ' + this.syncProcess + ' SyncObject ' + this.syncObject + ' Size: ' + syncObjectLink.size());

        //Update SalesForce objects with linked objects from SAP document numbers
        for (SObject record : records)
        {
            //UTIL_DeliverySync_Batch just ran sync results with the Invoice__c object
            //If the Invoice__c object is not linked to a Deliveries__c object and an object was found update the Invoice__c object
            if (this.syncProcess.equals('Deliveries__c') && this.syncObject.equals('Invoice__c'))
            {
                if (String.isBlank((String) record.get('Delivery__c')) && syncObjectLink.containsKey((String) record.get('Delivery_Number__c')))
                {
                    record.put('Delivery__c', syncObjectLink.get((String) record.get('Delivery_Number__c')));
                    updateRecords.add(record);
                }
            }
            else if (this.syncProcess.equals('Order__c'))
            {
                if (String.isBlank((String) record.get('Order__c')))
                {
                    //UTIL_SalesOrderSync_Batch just ran sync results with the Invoice__c object
                    //If the Invoice__c object is not linked to a Order__c object and an object was found update the Invoice__c object
                    if (this.syncObject.equals('Invoice__c'))
                    {
                        if (syncObjectLink.containsKey((String) record.get('Sales_Order__c')))
                        {
                            record.put('Order__c', syncObjectLink.get((String) record.get('Sales_Order__c')));
                            updateRecords.add(record);
                        }
                    }
                    //UTIL_SalesOrderSync_Batch just ran sync results with the Deliveries__c object
                    //If the Deliveries__c object is not linked to a Order__c object and an object was found update the Deliveries__c object
                    else if (this.syncObject.equals('Deliveries__c'))
                    {
                        if (syncObjectLink.containsKey((String) record.get('ERP_Order__c')))
                        {
                            record.put('Order__c', syncObjectLink.get((String) record.get('ERP_Order__c')));
                            updateRecords.add(record);
                        }
                    }
                }
            }
            //UTIL_InvoiceSync_Batch just ran sync results with the Deliveries__c object
            //If the Deliveries__c object is not linked to a Invoice__c object and an object was found update the Deliveries__c object
            else if (this.syncProcess.equals('Invoice__c') && this.syncObject.equals('Deliveries__c'))
            {
                if (String.isBlank((String) record.get('Invoice__c')) && syncObjectLink.containsKey((String) record.get('Invoice_Number__c')))
                {
                    record.put('Invoice__c', syncObjectLink.get((String) record.get('Invoice_Number__c')));
                    updateRecords.add(record);
                }
            }
        }

        try
        {
            if (updateRecords.size() > 0)
            {
                update updateRecords;
            }
        }
        catch (DmlException ex)
        {
            UTIL_SyncHelper.addLog(errors, 'Error', ex.getMessage());
            throw new UpdateBatchRecordException('Error updating batch records.', ex);
        }
    }

    //finish()
    //
    //Finish processing the cleanup
    public void finish(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' finished');
        System.debug('Finish Batch for: ' + this.syncProcess + ' ' + this.syncObject);
        UTIL_SyncHelper.printJobInfo(this.jobInfo);
    }

    //buildQueryString()
    //
    //Method to build the query
    private String buildQueryString()
    {
        String query = null;
        //UTIL_DeliverySync_Batch just ran sync results with the Invoice__c object
        //Build query to select Invoice__c objects with a SAP Delivery Number set
        if (this.syncProcess.equals('Deliveries__c') && this.syncObject.equals('Invoice__c'))
        {
            query = 'SELECT Id, Delivery_Number__c, Delivery__c ';
            query += 'FROM Invoice__c ';
            query += 'WHERE Delivery_Number__c <> \'\' ';
            query += 'AND (Delivery__c = null OR Delivery__c = \'\')';
        }
        //UTIL_SalesOrderSync_Batch just ran sync results with the Invoice__c object
        //Build query to select Invoice__c objects with a SAP Sales Order Number set
        else if (this.syncProcess.equals('Order__c') && this.syncObject.equals('Invoice__c'))
        {
            query = 'SELECT Id, Sales_Order__c, Order__c ';
            query += 'FROM Invoice__c ';
            query += 'WHERE Sales_Order__c <> \'\' ';
            query += 'AND (Order__c = null OR Order__c = \'\')';
        }
        //UTIL_SalesOrderSync_Batch just ran sync results with the Deliveries__c object
        //Build query to select Deliveries__c objects with a SAP Sales Order Number set
        else if (this.syncProcess.equals('Order__c') && this.syncObject.equals('Deliveries__c'))
        {
            query = 'SELECT Id, ERP_Order__c, Order__c ';
            query += 'FROM Deliveries__c ';
            query += 'WHERE ERP_Order__c <> \'\' ';
            query += 'AND (Order__c = null OR Order__c = \'\')';
        }
        //UTIL_InvoiceSync_Batch just ran sync results with the Deliveries__c object
        //Build query to select Deliveries__c objects with a SAP Invoice Number set
        else if (this.syncProcess.equals('Invoice__c') && this.syncObject.equals('Deliveries__c'))
        {
            query = 'SELECT Id, Invoice_Number__c, Invoice__c ';
            query += 'FROM Deliveries__c ';
            query += 'WHERE Invoice_Number__c <> \'\' ';
            query += 'AND (Invoice__c = null OR Invoice__c = \'\')';
        }

        return query;
    }

    //Custom Exception for batch updating process
    public class UpdateBatchRecordException extends Exception
    {}
}
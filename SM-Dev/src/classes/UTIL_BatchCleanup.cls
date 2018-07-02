public with sharing class UTIL_BatchCleanup
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

    private String objectName;
    private String notFoundAccountId;

    public UTIL_BatchCleanup(String value)
    {
        objectName = value;
        notFoundAccountId = UTIL_YetiSyncHelper.getNotFoundAccountId(this.errors);
    }

    //start()
    //
    //Start querying the records
    public Database.QueryLocator start(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' starts');
        this.jobInfo.add('BatchCleanup for: ' + this.objectName);

        if (setsOfObjectName.contains(this.objectName))
        {
            String query = buildQueryString(this.objectName);
            return Database.getQueryLocator(query);
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
        System.debug('records.size(): ' + records.size());
        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        Set<String> customerNumbers = new Set<String>();
        List<SObject> updateRecords = new List<SObject>();

        // Iterate through the records and append the customer numbers to a set
        for (SObject result : records)
        {
            String billToNumber = (String) result.get('Bill_To_Number__c');
            String shipToNumber = (String) result.get('Ship_To_Number__c');
            String soldToNumber = (String) result.get('Sold_To_Number__c');
            if (!String.isEmpty(billToNumber))
            {
                customerNumbers.add(billToNumber);
            }
            if (!String.isEmpty(shipToNumber))
            {
                customerNumbers.add(shipToNumber);
            }
            if (!String.isEmpty(soldToNumber))
            {
                customerNumbers.add(soldToNumber);
            }
        }
        Map<String, String> customerAccountLink = UTIL_SyncHelper.createAccountIdMap(customerNumbers);

        System.debug('Customer Account Size: ' + customerAccountLink.size());

        for (SObject record : records)
        {
            String billToNumber = (String) record.get('Bill_To_Number__c');
            String shipToNumber = (String) record.get('Ship_To_Number__c');
            String soldToNumber = (String) record.get('Sold_To_Number__c');
            boolean recordChanged = false;

            if (!String.isEmpty(billToNumber))
            {
                if (customerAccountLink.containsKey(billToNumber))
                {
                    String currentId = (String) record.get('Bill_To__c');
                    String newId = customerAccountLink.get(billToNumber);
                    if (currentId != newId)
                    {
                        record.put('Bill_To__c', newId);
                        recordChanged = true;
                    }
                }
            }

            if (!String.isEmpty(shipToNumber))
            {
                if (customerAccountLink.containsKey(shipToNumber))
                {
                    String currentId = (String) record.get('Ship_To__c');
                    String newId = customerAccountLink.get(shipToNumber);
                    if (currentId != newId)
                    {
                        record.put('Ship_To__c', newId);
                        recordChanged = true;
                    }
                }
            }

            if (!String.isEmpty(soldToNumber))
            {
                if (customerAccountLink.containsKey(soldToNumber))
                {
                    String currentId = (String) record.get('Sold_To__c');
                    String newId = customerAccountLink.get(soldToNumber);
                    if (currentId != newId)
                    {
                        record.put('Sold_To__c', newId);
                        recordChanged = true;
                    }
                }
            }

            if(recordChanged)
            {
                updateRecords.add(record);
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
        UTIL_SyncHelper.printJobInfo(this.jobInfo);
        for (String syncObject : setsOfObjectName)
        {
            Database.executeBatch(new UTIL_BatchLookupCleanup(this.objectName, syncObject));
        }
    }

    //buildQueryString()
    //
    //Method to build the query
    private String buildQueryString(String name)
    {
        String query = 'SELECT Id, Bill_To__c, Bill_To_Number__c, Ship_To__c, Ship_To_Number__c, Sold_To__c, Sold_To_Number__c ';
                query += 'FROM ' + name;
                query += ' WHERE Bill_To__c IN (:notFoundAccountId)';
                query += ' OR Ship_To__c IN (:notFoundAccountId)';
                query += ' OR Sold_To__c IN (:notFoundAccountId)';

        return query;
    }

    //Custom Exception for batch updating process
    public class UpdateBatchRecordException extends Exception
    {}
}
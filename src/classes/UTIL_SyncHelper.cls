// UTIL_SyncHelper
//
// Helper methods to re-use SAP sync batch and schedule code
public with sharing class UTIL_SyncHelper
{
    // executeBatch()
    //
    // The schedule logic is always identical - the only difference is the name
    // of the batch and schedule classes, and an optional param
    public static void executeBatch(String batchClass, String scheduleClass, String batchParam)
    {
        // Database.executeBatch throws an Apex Limit exception when there are 5 or more active
        // batch jobs. The goal is to keep checking for an available slot in the Batch window
        // so that this can eventually get out of the Schedule and into the Batch queue.
        Integer jobCount = [
            SELECT count() FROM AsyncApexJob
            WHERE JobType='BatchApex'
            AND (Status = 'Processing' OR Status = 'Preparing')
        ];

        if (!Test.isRunningTest() && jobcount < 5)
        {
            // We are under the Apex Limit so inserting into the Apex Batch queue will succeed
            Object batchInstance = Type.forName(batchClass).newInstance();
            if (null != batchParam && batchInstance instanceof I_ParameterizedSync)
            {
                ((I_ParameterizedSync)batchInstance).setBatchParam(batchParam);
            }
            Database.executeBatch((Database.Batchable<Object>)batchInstance);
        }
        else
        {
            // Schedule the same schedulable class again after a few minutes
            Object scheduleInstance = Type.forName(scheduleClass).newInstance();
            if (null != batchParam && scheduleInstance instanceof I_ParameterizedSync)
            {
                ((I_ParameterizedSync)scheduleInstance).setBatchParam(batchParam);
            }

            // either in 1 to 10 minutes
            Integer addMinutes = Integer.valueOf(Math.random() * 10);
            // or 10 to 20 minutes if the first random() selects 0
            addMinutes = addMinutes == 0 ? Integer.valueOf(10 + Math.random() * 10) : addMinutes;

            Datetime dt = Datetime.now().addMinutes(addMinutes);
            String timeForScheduler = dt.format('s m H d M \'?\' yyyy ');

            Id schedId = System.Schedule(
                batchClass + '_SyncRetryAfter' + timeForScheduler.trim(),
                timeForScheduler,
                (Schedulable)scheduleInstance
            );
        }
    }

    // executeBatch()
    //
    // Execute batch with no param
    public static void executeBatch(String batchClass, String scheduleClass)
    {
        executeBatch(batchClass, scheduleClass, null);
    }

    // launchAnotherBatchIfNeeded()
    //
    // Use this in the finish() method of a batch to schedule another instance if needed
    public static void launchAnotherBatchIfNeeded(Boolean isNeeded, String scheduleClass, String batchParam)
    {
        // launch another batch if there's reason to believe there is more data to retrieve
        if (isNeeded)
        {
            System.debug('scheduling another run since there are likely more records to be retrieved. Param: ' + batchParam);
            // Using reflection to execute the class allows us to re-use this code, and also allows
            // a runaway instance to be stopped by editing class in the web console
            System.debug('instantiating an instance of ' + scheduleClass);
            Object scheduleInstance = Type.forName(scheduleClass).newInstance();
            if (null != batchParam && scheduleInstance instanceof I_ParameterizedSync)
            {
                ((I_ParameterizedSync)scheduleInstance).setBatchParam(batchParam);
            }

            ((Schedulable)scheduleInstance).execute(null);
        }
    }

    // launchAnotherBatchIfNeeded()
    //
    // launch another batch with no param
    public static void launchAnotherBatchIfNeeded(Boolean isNeeded, String scheduleClass)
    {
        launchAnotherBatchIfNeeded(isNeeded, scheduleClass, null);
    }

    // getLastDateFromTable()
    //
    // returns the hightest value for [column] from [table]
    public static Datetime getLastDateFromTable(String column, String table)
    {
        Datetime result = null;

        try
        {
            SObject lastChangedRecord = Database.query(
                'SELECT ' + column + ' FROM ' + table +
                ' ORDER BY ' + column + ' DESC NULLS LAST LIMIT 1'
            );
            Datetime lastDate = (Datetime)lastChangedRecord.get(column);

            if (null != lastDate)
            {
                result = lastDate;
            }
        }
        catch (Exception ex)
        {
            System.debug(ex);
        }

        return result;
    }

    // getMatchingRecords()
    //
    // query sf database for existing records matching the given keys
    public static List<sObject> getMatchingRecords(String table, Set<String> keys)
    {
        List<sObject> result = new List<sObject>();
        try
        {
            result = Database.query('SELECT Id, Name FROM ' + table + ' WHERE Name IN :keys');
        }
        catch (Exception ex)
        {
            System.debug(ex);
        }
        return result;
    }

    // createAccountIdMap()
    //
    // Looks up accounts for the given customer IDs and creates a map of customer -> account ids
    public static Map<String, String> createAccountIdMap(Set<String> customerIds)
    {
        Map<String, String> result = new Map<String, String>();
        String customerIdField = UTIL_Account.CustomerFieldName;

        List<Account> accounts = Database.query(
            'SELECT Id, ' + customerIdField +
            ' FROM Account WHERE ' + customerIdField + ' IN :customerIds'
        );

        for (Account account : accounts)
        {
            String customerId = (String)account.get(customerIdField);
            result.put(customerId, account.Id);
        }
        return result;
    }

    // createAccountMap()
    //
    // Looks up accounts for the given customer IDs and creates a map of customer -> accounts
    public static Map<String, Account> createAccountMap(Set<String> customerIds)
    {
        Map<String, Account> result = new Map<String, Account>();
        String customerIdField = UTIL_Account.CustomerFieldName;

        List<Account> accounts = Database.query(
            'SELECT Id, ' + customerIdField +
            ' FROM Account WHERE ' + customerIdField + ' IN :customerIds'
        );

        for (Account account : accounts)
        {
            String customerId = (String)account.get(customerIdField);
            result.put(customerId, account);
        }
        return result;
    }

    // createSObject()
    //
    // Create an sObject of a given type. For example:
    //     sObject acc = UTIL_SyncHelper.createSObject('Account');
    //     acc.put('AccountNumber', accNumber);
    public static sObject createSObject(String typeName)
    {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        if (null == targetType)
        {
            System.debug('UTIL_SyncHelper.createSObject: ' + typeName + ' does not exist');
            return null;
        }
        return targetType.newSObject();
    }

    // addLog()
    //
    // Safely appends messages to log list for later inserting into the SAP_ETL_Log__c table and
    // also writes to System.debug for easier debugging in the Dev Console.
    // Leaves log untouched if SAP_ETL_Log__c table does not exist.
    public static void addLog(List<sObject> log, String logLevel, String message)
    {
        sObject logEntry = UTIL_SyncHelper.createLog(logLevel, message);
        if (null != log && null != logEntry)
        {
            log.add(logEntry);
        }
        System.debug(logLevel + ': ' + message);
    }

    // createLog()
    //
    // Construct a message for the SAP_ETL_Log__c table with the given level and message
    // The message is not inserted into the database. They can be added to a list and inserted
    // all at once later.
    // Returns null if SAP_ETL_Log__c table does not exist.
    public static sObject createLog(String logLevel, String message)
    {
        sObject log = UTIL_SyncHelper.createSObject('SAP_ETL_Log__c');
        if (null != log)
        {
            log.put('LogLevel__c', logLevel);
            log.put('Message__c', message);
        }
        return log;
    }

    // printJobInfo()
    //
    // helper method to write batch job info to System.debug()
    public static void printJobInfo(List<String> jobInfo)
    {
        for (String line : jobInfo)
        {
            System.debug('jobInfo:' + line);
        }
    }

    // debugLogResultMessages()
    //
    // send search result messages to the debug log
    public static void debugLogResultMessages(List<ENSX.EnosixFramework.Message> messages)
    {
        if (null != messages)
        {
            for (ENSX.EnosixFramework.Message m : messages)
            {
                System.debug('response message[' + m.Type.name() + ']: ' + m.Text);
            }
        }
    }

    // getPicklistEntriesForField()
    //
    // Return list of PickListEntry objects for the given sObject typeName.fieldName
    public static List<Schema.PicklistEntry> getPicklistEntriesForField(
        String typeName, String fieldName)
    {
        Schema.DescribeSObjectResult objResult =
            Schema.describeSObjects(new string[]{ typeName })[0];
        Map<string, SObjectField> fields = objResult.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        return fieldResult.getPicklistValues();
    }

    // getPicklistValueByLabel()
    //
    // Return the matching pick list value for the given label string. Returns null if no matching
    // entry is in the entries list
    public static String getPicklistValueByLabel(List<Schema.PicklistEntry> entries, String label)
    {
        String result = null;
        for (Schema.PicklistEntry ple : entries)
        {
            if (ple.getLabel() == label)
            {
                result = ple.getValue();
                System.debug('returning picklist value: ' + result);
                break;
            }
        }
        return result;
    }

    public static void testSchedulables(Set<Schedulable> schedulables)
    {
        for (Schedulable instance : schedulables)
        {
            Datetime dt = Datetime.now().addMinutes(1);
            String timeForScheduler = dt.format('s m H d M \'?\' yyyy ');
            String schedId = System.Schedule(
                String.valueOf(instance).split(':')[0] + 'RetryAfter' + timeForScheduler.trim(),
                timeForScheduler,
                instance
            );
            // ID in API is 15 digits
            System.assertEquals(15, schedId.length());
        }
    }
}
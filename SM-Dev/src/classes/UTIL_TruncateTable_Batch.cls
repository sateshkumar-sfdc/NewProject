// UTIL_TruncateTable_Batch
//
// Truncates a table of up to 50 million rows (limit of Database.getQueryLocator).
// This is useful when there are more than 5000 records in a table since that's the limit of records
// that can be deleted *and* purged from the recycle bin from an Execute Anonymous window.
//
// Example usage:
//   Database.executeBatch(new UTIL_TruncateTableBatch('ENSX_Logging__SAP_Http_Log__c'), 2000);
public class UTIL_TruncateTable_Batch implements Database.Batchable<sObject>, Database.Stateful
{
    String sObjectTypeName;
    Integer total = 0;

    // ctor()
    //
    // Takes the sObject table name to be truncated
    public UTIL_TruncateTable_Batch(String tableName)
    {
        sObjectTypeName = tableName;
    }

    /* Database.Batchable methods start(), execute(), and finish() */
    // start()
    //
    // Opens a database cursor to read the entire table
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('UTIL_TruncateTable_Batch[' + sObjectTypeName + ']: start');
        return Database.getQueryLocator('SELECT Id FROM ' + sObjectTypeName);
    }

    // execute()
    //
    // Deletes the given chunk of records and empties that chunk of records from the recycle bin.
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        System.debug('UTIL_TruncateTable_Batch[' + sObjectTypeName + ']: execute');
        total += scope.size();
        // delete transfers them to the recycle bin (sets isDeleted = true on the record)
        delete scope;
        // Database.emptyRecycleBin empties them out of the recycle bin,
        // but they are still visible with queryAll / ALL ROWS for 24 hours.
        Database.emptyRecycleBin(scope);
    }

    // finish()
    //
    // Reports the number of records deleted to System.debug
    public void finish(Database.BatchableContext BC)
    {
        System.debug(
            'UTIL_TruncateTable_Batch[' + sObjectTypeName + ']: finish. '
            + total + ' records deleted.'
        );
    }
    /* end Database.Batchable methods */
}
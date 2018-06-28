@isTest
public with sharing class TSTU_BatchCleanup
{
    //Number of records to insert
    public static final Integer NUM_OF_RECORDS = 50;

    public static testMethod void executeTest()
    {
        Test.StartTest();

        //Batch cleanup with records;
        insertTestRecordsToInvoice();
        UTIL_BatchCleanup batchCleanup = new UTIL_BatchCleanup('Invoice__c');
        Id batchCleanupId2 = Database.executeBatch(batchCleanup);
        AsyncApexJob apexJob = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                                FROM AsyncApexJob WHERE Id = :batchCleanupId2];

        System.debug('Apex Job: ' + apexJob);
        System.assertEquals(batchCleanupId2, apexJob.Id);

        Test.stopTest();
    }

    private static void insertTestRecordsToInvoice()
    {
        List<Account> insertAccounts = new List<Account>();
        Account billToAccount = new Account();
        billToAccount.Name = 'billToAccount';
        billToAccount.put(UTIL_Account.CustomerFieldName,'001001');
        insertAccounts.add(billToAccount);
        Account shipToAccount = new Account();
        shipToAccount.Name = 'shipToAccount';
        shipToAccount.put(UTIL_Account.CustomerFieldName,'001002');
        insertAccounts.add(shipToAccount);
        Account soldToAccount = new Account();
        soldToAccount.Name = 'soldToAccount';
        soldToAccount.put(UTIL_Account.CustomerFieldName,'001003');
        insertAccounts.add(soldToAccount);
        insert insertAccounts;

        Id notFoundAccountId = (Id) UTIL_YetiSyncHelper.getNotFoundAccountId(null);
        List<Invoice__c> invoiceLists = new List<Invoice__c>();

        //Insert numOfRecords to the Invoice object
        for (Integer count = 0; count < NUM_OF_RECORDS; count++)
        {
            invoiceLists.add(new Invoice__c(
                Bill_To_Number__c = '001001',
                Ship_To_Number__c = '001002',
                Sold_To_Number__c = '001003',
                Bill_To__c = notFoundAccountId,
                Ship_To__c = notFoundAccountId,
                Sold_To__c = notFoundAccountId,
                Delivery_Number__c = 'Delivery_Number',
                Sales_Order__c = 'Order_Number'
            ));
        }

        insert invoiceLists;
    }
}
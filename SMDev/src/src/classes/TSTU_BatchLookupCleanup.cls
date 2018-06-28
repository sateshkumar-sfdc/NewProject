@isTest
public with sharing class TSTU_BatchLookupCleanup
{
    //Number of records to insert
    public static final Integer NUM_OF_RECORDS = 50;

    public static testMethod void executeTest()
    {
        Test.StartTest();

        //Batch cleanup with records;
        insertTestRecordsToInvoice();
        insertTestRecordsToDeliveries();
        insertTestRecordsToOrder();
        UTIL_BatchLookupCleanup batchCleanup1 = new UTIL_BatchLookupCleanup('Deliveries__c', 'Invoice__c');
        Database.executeBatch(batchCleanup1);
        UTIL_BatchLookupCleanup batchCleanup2 = new UTIL_BatchLookupCleanup('Order__c', 'Invoice__c');
        Database.executeBatch(batchCleanup2);
        UTIL_BatchLookupCleanup batchCleanup3 = new UTIL_BatchLookupCleanup('Order__c', 'Deliveries__c');
        Database.executeBatch(batchCleanup3);
        UTIL_BatchLookupCleanup batchCleanup4 = new UTIL_BatchLookupCleanup('Invoice__c', 'Deliveries__c');
        Database.executeBatch(batchCleanup4);

        Test.stopTest();
    }

    private static void insertTestRecordsToInvoice()
    {
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
        invoiceLists.add(new Invoice__c(
            Name = 'Order_Number',
            Sold_To__c = notFoundAccountId
        ));

        insert invoiceLists;
    }

    private static void insertTestRecordsToDeliveries()
    {
        Id notFoundAccountId = (Id) UTIL_YetiSyncHelper.getNotFoundAccountId(null);
        List<SObject> deliveriesLists = new List<SObject>();

        //Insert numOfRecords to the Invoice object
        for (Integer count = 0; count < NUM_OF_RECORDS; count++)
        {
            deliveriesLists.add(new Deliveries__c(
                ERP_Order__c = 'Order_Number',
                Invoice_Number__c = 'Order_Number',
                Sold_To__c = notFoundAccountId
            ));
        }
        deliveriesLists.add(new Deliveries__c(
            Name = 'Delivery_Number',
            Sold_To__c = notFoundAccountId
        ));

        insert deliveriesLists;
    }

    private static void insertTestRecordsToOrder()
    {
        Id notFoundAccountId = (Id) UTIL_YetiSyncHelper.getNotFoundAccountId(null);
        insert new Order__c(
            Name = 'Order_Number',
            Sold_To__c = notFoundAccountId
        );
    }
}
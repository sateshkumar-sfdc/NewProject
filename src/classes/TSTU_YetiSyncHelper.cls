@isTest
public with sharing class TSTU_YetiSyncHelper
{
    @isTest
    public static void test_createSalesOrderIdMap()
    {
        Test.startTest();
        Set<String> orderNumbers = new Set<String>();
        orderNumbers.add('bogus');
        Map<String, String> result = UTIL_YetiSyncHelper.createSalesOrderIdMap(orderNumbers);
        System.assert(result.isEmpty());
        Test.stopTest();
    }

    @isTest
    public static void test_createDeliveryIdMap()
    {
        Test.startTest();
        Set<String> delivNums = new Set<String>();
        delivNums.add('bogus');
        Map<String, String> result = UTIL_YetiSyncHelper.createDeliveryIdMap(delivNums);
        System.assert(result.isEmpty());
        Test.stopTest();
    }

    @isTest
    public static void test_getNotFoundAccountId()
    {
        List<sObject> errors = new List<sObject>();

        Test.startTest();
        // The first time we run this, it may not exist so it will be created.
        String resultId = UTIL_YetiSyncHelper.getNotFoundAccountId(errors);
        System.assert(String.isNotBlank(resultId));

        // The second time we run this, it should already be created and will
        // be returning the ID of the account it found.
        String expected = resultId;
        resultId = UTIL_YetiSyncHelper.getNotFoundAccountId(errors);
        System.assert(String.isNotBlank(resultId) && resultId == expected);
        Test.stopTest();
    }

    @isTest
    public static void test_buildAddress()
    {
        Test.startTest();
        String expected = 'john doe\n' +
            '123 sesame st\n' +
            'nowhere, 45342, USA';
        String result = UTIL_YetiSyncHelper.buildAddress('john',
            'doe',
            '123 sesame st',
            'nowhere',
            '45342',
            'USA');
        System.assert(result == expected);
        Test.stopTest();
    }

    @isTest
    public static void test_customPricebook()
    {
        Test.startTest();
        String dealerPricebook = UTIL_YetiSyncHelper.dealerCustomPricebook;
        Pricebook2 newPricebook = new Pricebook2();
        newPricebook.Name = dealerPricebook;
        insert newPricebook;

        Pricebook2 customPricebook = UTIL_YetiSyncHelper.getCustomPricebook();        
        Test.stopTest();

        System.assertEquals(dealerPricebook, customPricebook.Name);
    }
}
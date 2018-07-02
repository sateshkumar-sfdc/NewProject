@isTest
public class TSTU_SalesOrderSync_Batch
{
    class MockSearch implements ensx.EnosixFramework.SearchSBOMock
    {
        Boolean isSuccess;
        public MockSearch(Boolean isSuccess)
        {
            this.isSuccess = isSuccess;
        }

        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SR searchResult =
                new SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SR();

            if (isSuccess)
            {
                SBO_YetiSalesOrderSync_Search.SEARCHRESULT result = new SBO_YetiSalesOrderSync_Search.SEARCHRESULT();
                result.ErpOrderNumber = '1';
                result.LineNumber = '10';
                result.LastChangeDate = Date.newInstance(2016, 12, 1);
                result.LastChangeTime = Time.newInstance(10, 30, 0, 0);
                result.Tax = 1;
                result.ShippingAmount = 1;
                result.SoldTo = '12345678';
                searchResult.SearchResults.add(result);
                searchResult.SearchResults.add(result);

                SBO_YetiSalesOrderSync_Search.SEARCHRESULT result2 = new SBO_YetiSalesOrderSync_Search.SEARCHRESULT();
                result2.ErpOrderNumber = '2';
                result2.LineNumber = '10';
                result2.LastChangeDate = Date.newInstance(2017, 2, 20);
                result2.LastChangeTime = Time.newInstance(13, 50, 0, 0);
                result2.Tax = 1;
                result2.ShippingAmount = 1;
                result2.SoldTo = '12345677';
                searchResult.SearchResults.add(result2);
            }

            searchResult.setSuccess(isSuccess);
            return searchResult;
        }
    }

    @isTest public static void executeTest()
    {
        List<String> allIds = new List<String>();

        ENSX.EnosixFramework.setMock(SBO_YetiSalesOrderSync_Search.class, new MockSearch(true));
        String notFoundAccountId = UTIL_YetiSyncHelper.getNotFoundAccountId(null);
        sObject order = UTIL_SyncHelper.createSObject('Order__c');
        order.put('Name', '2');
        order.put('Sold_To__c', Id.valueOf(notFoundAccountId));
        insert order;

        sObject orderLine = UTIL_SyncHelper.createSObject('Order_Line__c');
        orderLine.put('Name', '2/10');
        orderLine.put('Order_Details__c', order.get('Id'));
        insert orderLine;

        Test.startTest();
        for (Integer i = 0; i < 2; i++)
        {
            String schedId = Database.executeBatch(new UTIL_SalesOrderSync_Batch());
            allIds.add(schedId);
        }
        Test.stopTest();

        //ID in API is of 15 didgits
        for (Integer i =0; i< 2; i++)
        {
            System.assertEquals(15, allIds[i].length());
        }
    }
}
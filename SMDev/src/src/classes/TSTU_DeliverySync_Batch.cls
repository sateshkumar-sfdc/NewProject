@isTest
public class TSTU_DeliverySync_Batch
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
            SBO_YetiDeliverySync_Search.YetiDeliverySync_SR searchResult =
                new SBO_YetiDeliverySync_Search.YetiDeliverySync_SR();

            if (isSuccess)
            {
                SBO_YetiDeliverySync_Search.SEARCHRESULT result = new SBO_YetiDeliverySync_Search.SEARCHRESULT();
                result.CustomerShipment = '1';
                result.DeliveryItemNumber = '10';
                result.ErpOrder = '17';
                result.LastChangeDate = Date.newInstance(2016, 12, 1);
                result.LastChangeTime = Time.newInstance(10, 30, 0, 0);
                result.SoldToParty = '123456768';
                searchResult.SearchResults.add(result);
                SBO_YetiDeliverySync_Search.SEARCHRESULT result2 = new SBO_YetiDeliverySync_Search.SEARCHRESULT();
                result2.CustomerShipment = '2';
                result2.DeliveryItemNumber = '10';
                result2.ErpOrder = '18';
                result2.LastChangeDate = Date.newInstance(2017, 2, 20);
                result2.LastChangeTime = Time.newInstance(13, 50, 0, 0);
                result2.SoldToParty = '12345677';
                searchResult.SearchResults.add(result2);
            }

            searchResult.setSuccess(isSuccess);
            return searchResult;
        }
    }

    @isTest public static void executeTest()
    {
        List<String> allIds = new List<String>();

        ENSX.EnosixFramework.setMock(SBO_YetiDeliverySync_Search.class, new MockSearch(true));
        String notFoundAccountId = UTIL_YetiSyncHelper.getNotFoundAccountId(null);
        System.debug('TSTU_DeliverySync_Batch.executeTest(): NOT_FOUND account Id: ' + notFoundAccountId);
        sObject order = UTIL_SyncHelper.createSObject('Order__c');
        order.put('Sold_To__c', Id.valueOf(notFoundAccountId));
        order.put('Name', '18');
        insert order;

        sObject delivery = UTIL_SyncHelper.createSObject('Deliveries__c');
        delivery.put('Name', '2');
        delivery.put('Sold_To__c', Id.valueOf(notFoundAccountId));
        insert delivery;

        sObject deliveryLine = UTIL_SyncHelper.createSObject('Delivery_Lines__c');
        deliveryLine.put('Name', '2/10');
        deliveryLine.put('Deliveries__c', delivery.get('Id'));
        insert deliveryLine;

        Test.startTest();
        for (Integer i = 0; i < 2; i++)
        {
            UTIL_DeliverySync_Batch deliverSyncBatch = new UTIL_DeliverySync_Batch();
            deliverSyncBatch.setBatchParam(null);
            String schedId = Database.executeBatch(new UTIL_DeliverySync_Batch());
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
@isTest
public class TSTU_InvoiceSync_Batch
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
            SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SR searchResult =
                new SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SR();

            if (isSuccess)
            {
                SBO_YetiInvoiceSync_Search.SEARCHRESULT result = new SBO_YetiInvoiceSync_Search.SEARCHRESULT();
                result.Invoice = '1';
                result.InvoiceItemNumber = '10';
                result.LastChangeDate = Date.newInstance(2016, 12, 1);
                result.LastChangeTime = Time.newInstance(10, 30, 0, 0);
                result.SoldToParty = '12345678';
                searchResult.SearchResults.add(result);

                SBO_YetiInvoiceSync_Search.SEARCHRESULT result2 = new SBO_YetiInvoiceSync_Search.SEARCHRESULT();
                result2.Invoice = '2';
                result2.InvoiceItemNumber = '10';
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

        ENSX.EnosixFramework.setMock(SBO_YetiInvoiceSync_Search.class, new MockSearch(true));

        sObject invoice = UTIL_SyncHelper.createSObject('Invoice__c');
        invoice.put('Name', '2');
        invoice.put('Sold_To__c', UTIL_YetiSyncHelper.getNotFoundAccountId(null));
        insert invoice;

        sObject invoiceLine = UTIL_SyncHelper.createSObject('Invoice_Lines__c');
        invoiceLine.put('Name', '2/10');
        invoiceLine.put('Invoice__c', invoice.get('Id'));
        insert invoiceLine;

        Test.startTest();
        for (Integer i = 0; i < 2; i++)
        {
            UTIL_InvoiceSync_Batch invoiceSyncBatch = new UTIL_InvoiceSync_Batch();
            invoiceSyncBatch.setBatchParam(null);
            String schedId = Database.executeBatch(invoiceSyncBatch);
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
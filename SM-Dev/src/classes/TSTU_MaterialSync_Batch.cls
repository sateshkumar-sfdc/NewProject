@isTest
public with sharing class TSTU_MaterialSync_Batch
{
    public class MockSyncSearch implements ENSX.EnosixFramework.SearchSBOMock
    {
        Boolean isSuccess;

        public MockSyncSearch(Boolean isSuccess)
        {
            this.isSuccess = isSuccess;
        }

        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SR searchResult =
                new SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SR();

            if (isSuccess)
            {
                SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT result = new SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT();
                result.Material = '1234';
                result.MaterialDescription = 'This is a Material Description';
                result.Amount = 55.25;
                result.Active = 'X';
                searchResult.SearchResults.add(result);

                SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT result2 = new SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT();
                result2.Material = '2';
                result2.MaterialDescription = '10';
                result2.Amount = 34.5;
                result2.Active = '';
                searchResult.SearchResults.add(result2);
            }

            searchResult.setSuccess(isSuccess);
            return searchResult;
        }
    }

    @isTest(SeeAllData=true)
    static void test_MaterialSync()
    {
        ENSX.EnosixFramework.setMock(SBO_YetiDPMaterialPriceSync_Search.class, new MockSyncSearch(true));
        insertProductAndPricebook();
        PricebookEntry pbEntry = getPricebookEntry().get(0);
        System.assertEquals(50, pbEntry.UnitPrice);

        Test.startTest();
        UTIL_MaterialSync_Batch sync = new UTIL_MaterialSync_Batch();
        sync.setBatchParam(null);
        sync.setBatchParam('1');
        String schedId = Database.executeBatch(sync);
        Test.stopTest();

        List<PricebookEntry> pbEntries = getPricebookEntry();
        Pricebook2 customPricebook = UTIL_YetiSyncHelper.getCustomPricebook();
        Decimal pbEntryPrice = 0;
        for (PricebookEntry pbEntry2 : pbEntries)
        {
            if (null != customPricebook)
            {
                if (pbEntry2.Pricebook2Id == customPricebook.Id)
                {
                    pbEntryPrice = pbEntry2.UnitPrice;
                }
            }
        }
    }

    private static List<PricebookEntry> getPricebookEntry()
    {
        return Database.query('SELECT Id, UnitPrice, Name, Pricebook2Id FROM PricebookEntry WHERE Name = \'1234\'');
    }

    private static void insertProductAndPricebook()
    {
        Product2 product = new Product2();
        product.Name = '1234';
        product.Description = 'Material Description';
        product.ProductCode = '1234';
        insert product;

        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.UnitPrice = 50;
        pbEntry.Product2Id = product.Id;
        pbEntry.Pricebook2Id = Test.getStandardPricebookId();
        insert pbEntry;

        Pricebook2 customPricebook = new Pricebook2();
        customPricebook.Name = UTIL_YetiSyncHelper.dealerCustomPricebook;
        insert customPricebook;

        PricebookEntry pbEntry2 = new PricebookEntry();
        pbEntry2.UnitPrice = 50;
        pbEntry2.Product2Id = product.Id;
        pbEntry2.Pricebook2Id = customPricebook.Id;
        insert pbEntry2;
    }
}
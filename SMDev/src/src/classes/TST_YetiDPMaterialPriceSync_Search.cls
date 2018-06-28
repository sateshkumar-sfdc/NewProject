/// enosiX Inc. Generated Apex Model
/// Generated On: 8/24/2017 1:28:25 PM
/// SAP Host: From REST Service On: https://na37.salesforce.com
/// CID: From REST Service On: https://na37.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

@isTest
private class TST_YetiDPMaterialPriceSync_Search
{

    public class MockSBO_YetiDPMaterialPriceSync_Search implements ensx.EnosixFramework.SearchSBOMock
    {
        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            return null;
        }
    }

    @isTest
    static void testSBO()
    {
        ensx.EnosixFramework.setMock(SBO_YetiDPMaterialPriceSync_Search.class, new MockSBO_YetiDPMaterialPriceSync_Search());
        SBO_YetiDPMaterialPriceSync_Search sbo = new SBO_YetiDPMaterialPriceSync_Search();
        System.assertEquals(SBO_YetiDPMaterialPriceSync_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sbo.SearchContext);
        System.assertEquals(null, sbo.execute());

        SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SC sc = new SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SC();
        System.assertEquals(SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SC.class, sc.getType(), 'getType() does not match object type.');


        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        SBO_YetiDPMaterialPriceSync_Search.SEARCHPARAMS childObj = new SBO_YetiDPMaterialPriceSync_Search.SEARCHPARAMS();
        System.assertEquals(SBO_YetiDPMaterialPriceSync_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.FromLastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromLastChangeDate);

        childObj.ToLastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToLastChangeDate);

        childObj.FromChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.FromChangeTime);

        childObj.ToChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.ToChangeTime);

        childObj.PageNumber = 0;
        System.assertEquals(0, childObj.PageNumber);

        childObj.MaxRows = 0;
        System.assertEquals(0, childObj.MaxRows);


    }

    @isTest
    static void testYetiDPMaterialPriceSync_SR()
    {
        SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SR sr = new SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SR();


        System.assertEquals(SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT childObj = new SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT();
        System.assertEquals(SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.Material = 'X';
        System.assertEquals('X', childObj.Material);

        childObj.MaterialDescription = 'X';
        System.assertEquals('X', childObj.MaterialDescription);

        childObj.Amount = 1.5;
        System.assertEquals(1.5, childObj.Amount);

        childObj.FieldCurrency = 'X';
        System.assertEquals('X', childObj.FieldCurrency);

        childObj.CreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

        childObj.EntryTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.EntryTime);

        childObj.ChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ChangeDate);

        childObj.ChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.ChangeTime);

        childObj.Active = 'X';
        System.assertEquals('X', childObj.Active);


    }

}
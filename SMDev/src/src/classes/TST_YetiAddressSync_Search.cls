/// enosiX Inc. Generated Apex Model
/// Generated On: 9/19/2017 10:28:11 AM
/// SAP Host: From REST Service On: https://cs14.salesforce.com
/// CID: From REST Service On: https://cs14.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

@isTest
private class TST_YetiAddressSync_Search
{

    public class MockSBO_YetiAddressSync_Search implements ensx.EnosixFramework.SearchSBOMock
    {
        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            return null;
        }
    }

    @isTest
    static void testSBO()
    {
        ensx.EnosixFramework.setMock(SBO_YetiAddressSync_Search.class, new MockSBO_YetiAddressSync_Search());
        SBO_YetiAddressSync_Search sbo = new SBO_YetiAddressSync_Search();
        System.assertEquals(SBO_YetiAddressSync_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sbo.SearchContext);
        System.assertEquals(null, sbo.execute());

        SBO_YetiAddressSync_Search.YetiAddressSync_SC sc = new SBO_YetiAddressSync_Search.YetiAddressSync_SC();
        System.assertEquals(SBO_YetiAddressSync_Search.YetiAddressSync_SC.class, sc.getType(), 'getType() does not match object type.');


        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        SBO_YetiAddressSync_Search.SEARCHPARAMS childObj = new SBO_YetiAddressSync_Search.SEARCHPARAMS();
        System.assertEquals(SBO_YetiAddressSync_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.FromChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromChangeDate);

        childObj.ToChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToChangeDate);

        childObj.FromChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.FromChangeTime);

        childObj.ToChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.ToChangeTime);

        childObj.MAX_ROWS = 0;
        System.assertEquals(0, childObj.MAX_ROWS);


    }

    @isTest
    static void testYetiAddressSync_SR()
    {
        SBO_YetiAddressSync_Search.YetiAddressSync_SR sr = new SBO_YetiAddressSync_Search.YetiAddressSync_SR();


        System.assertEquals(SBO_YetiAddressSync_Search.YetiAddressSync_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        SBO_YetiAddressSync_Search.SEARCHRESULT childObj = new SBO_YetiAddressSync_Search.SEARCHRESULT();
        System.assertEquals(SBO_YetiAddressSync_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.CustomerNumber = 'X';
        System.assertEquals('X', childObj.CustomerNumber);

        childObj.Street = 'X';
        System.assertEquals('X', childObj.Street);

        childObj.HouseNumber = 'X';
        System.assertEquals('X', childObj.HouseNumber);

        childObj.District = 'X';
        System.assertEquals('X', childObj.District);

        childObj.PostalCode = 'X';
        System.assertEquals('X', childObj.PostalCode);

        childObj.City = 'X';
        System.assertEquals('X', childObj.City);

        childObj.Country = 'X';
        System.assertEquals('X', childObj.Country);

        childObj.Region = 'X';
        System.assertEquals('X', childObj.Region);

        childObj.ChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ChangeDate);

        childObj.ChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.ChangeTime);

        childObj.InsideSalesRep = 'X';
        System.assertEquals('X', childObj.InsideSalesRep);

        childObj.InsideSalesRepName1 = 'X';
        System.assertEquals('X', childObj.InsideSalesRepName1);

        childObj.InsideSalesRepName2 = 'X';
        System.assertEquals('X', childObj.InsideSalesRepName2);

        childObj.OutsideSalesRep = 'X';
        System.assertEquals('X', childObj.OutsideSalesRep);

        childObj.OutsideSalesRepName1 = 'X';
        System.assertEquals('X', childObj.OutsideSalesRepName1);

        childObj.OutsideSalesRepName2 = 'X';
        System.assertEquals('X', childObj.OutsideSalesRepName2);

        childObj.SalesOffice = 'X';
        System.assertEquals('X', childObj.SalesOffice);

        childObj.VKBUR_TEXT = 'X';
        System.assertEquals('X', childObj.VKBUR_TEXT);


    }

}
/// enosiX Inc. Generated Apex Model
/// Generated On: 8/1/2017 2:59:05 PM
/// SAP Host: From REST Service On: https://na3.salesforce.com
/// CID: From REST Service On: https://na3.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

@isTest
private class TST_YetiDeliverySync_Search
{

    public class MockSBO_YetiDeliverySync_Search implements ensx.EnosixFramework.SearchSBOMock
    {
        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            return null;
        }
    }

    @isTest
    static void testSBO()
    {
        ensx.EnosixFramework.setMock(SBO_YetiDeliverySync_Search.class, new MockSBO_YetiDeliverySync_Search());
        SBO_YetiDeliverySync_Search sbo = new SBO_YetiDeliverySync_Search();
        System.assertEquals(SBO_YetiDeliverySync_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sbo.SearchContext);
        System.assertEquals(null, sbo.execute());

        SBO_YetiDeliverySync_Search.YetiDeliverySync_SC sc = new SBO_YetiDeliverySync_Search.YetiDeliverySync_SC();
        System.assertEquals(SBO_YetiDeliverySync_Search.YetiDeliverySync_SC.class, sc.getType(), 'getType() does not match object type.');


        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        SBO_YetiDeliverySync_Search.SEARCHPARAMS childObj = new SBO_YetiDeliverySync_Search.SEARCHPARAMS();
        System.assertEquals(SBO_YetiDeliverySync_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.FromCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

        childObj.ToCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

        childObj.CustomerNumberFrom = 'X';
        System.assertEquals('X', childObj.CustomerNumberFrom);

        childObj.CustomerNumberTo = 'X';
        System.assertEquals('X', childObj.CustomerNumberTo);

        childObj.FromLastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromLastChangeDate);

        childObj.ToLastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToLastChangeDate);

        childObj.LastChangeTimeFrom = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.LastChangeTimeFrom);

        childObj.LastChangeTimeTo = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.LastChangeTimeTo);

        childObj.MAX_ROWS = 0;
        System.assertEquals(0, childObj.MAX_ROWS);


    }

    @isTest
    static void testYetiDeliverySync_SR()
    {
        SBO_YetiDeliverySync_Search.YetiDeliverySync_SR sr = new SBO_YetiDeliverySync_Search.YetiDeliverySync_SR();


        System.assertEquals(SBO_YetiDeliverySync_Search.YetiDeliverySync_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        SBO_YetiDeliverySync_Search.SEARCHRESULT childObj = new SBO_YetiDeliverySync_Search.SEARCHRESULT();
        System.assertEquals(SBO_YetiDeliverySync_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.ShipToParty = 'X';
        System.assertEquals('X', childObj.ShipToParty);

        childObj.ShipToName = 'X';
        System.assertEquals('X', childObj.ShipToName);

        childObj.SoldToParty = 'X';
        System.assertEquals('X', childObj.SoldToParty);

        childObj.SoldToName = 'X';
        System.assertEquals('X', childObj.SoldToName);

        childObj.BillToParty = 'X';
        System.assertEquals('X', childObj.BillToParty);

        childObj.BillToName = 'X';
        System.assertEquals('X', childObj.BillToName);

        childObj.UniqueID = 'X';
        System.assertEquals('X', childObj.UniqueID);

        childObj.ShipDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ShipDate);

        childObj.Site = 'X';
        System.assertEquals('X', childObj.Site);

        childObj.TrackingNumber = 'X';
        System.assertEquals('X', childObj.TrackingNumber);

        childObj.ShipVia = 'X';
        System.assertEquals('X', childObj.ShipVia);

        childObj.ShipMethod = 'X';
        System.assertEquals('X', childObj.ShipMethod);

        childObj.Account = 'X';
        System.assertEquals('X', childObj.Account);

        childObj.SentTo3pl = 'X';
        System.assertEquals('X', childObj.SentTo3pl);

        childObj.PartNumber = 'X';
        System.assertEquals('X', childObj.PartNumber);

        childObj.Uom = 'X';
        System.assertEquals('X', childObj.Uom);

        childObj.Upc = 'X';
        System.assertEquals('X', childObj.Upc);

        childObj.PartDescription = 'X';
        System.assertEquals('X', childObj.PartDescription);

        childObj.Quantity = 1.5;
        System.assertEquals(1.5, childObj.Quantity);

        childObj.QuantityOrdered = 1.5;
        System.assertEquals(1.5, childObj.QuantityOrdered);

        childObj.PackLineNum = 'X';
        System.assertEquals('X', childObj.PackLineNum);

        childObj.NeedByDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.NeedByDate);

        childObj.ShipByDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ShipByDate);

        childObj.Warehouse = 'X';
        System.assertEquals('X', childObj.Warehouse);

        childObj.ErpOrder = 'X';
        System.assertEquals('X', childObj.ErpOrder);

        childObj.CustomerShipment = 'X';
        System.assertEquals('X', childObj.CustomerShipment);

        childObj.DeliveryItemNumber = 'X';
        System.assertEquals('X', childObj.DeliveryItemNumber);

        childObj.SearchResultStatus = 'X';
        System.assertEquals('X', childObj.SearchResultStatus);

        childObj.LastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.LastChangeDate);

        childObj.LastChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.LastChangeTime);

        childObj.Invoice = 'X';
        System.assertEquals('X', childObj.Invoice);


    }

}
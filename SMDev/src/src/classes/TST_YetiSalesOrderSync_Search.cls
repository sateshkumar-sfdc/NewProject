/// enosiX Inc. Generated Apex Model
/// Generated On: 8/1/2017 2:59:05 PM
/// SAP Host: From REST Service On: https://na3.salesforce.com
/// CID: From REST Service On: https://na3.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

@isTest
private class TST_YetiSalesOrderSync_Search
{

    public class MockSBO_YetiSalesOrderSync_Search implements ensx.EnosixFramework.SearchSBOMock
    {
        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            return null;
        }
    }

    @isTest
    static void testSBO()
    {
        ensx.EnosixFramework.setMock(SBO_YetiSalesOrderSync_Search.class, new MockSBO_YetiSalesOrderSync_Search());
        SBO_YetiSalesOrderSync_Search sbo = new SBO_YetiSalesOrderSync_Search();
        System.assertEquals(SBO_YetiSalesOrderSync_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sbo.SearchContext);
        System.assertEquals(null, sbo.execute());

        SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SC sc = new SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SC();
        System.assertEquals(SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SC.class, sc.getType(), 'getType() does not match object type.');


        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        SBO_YetiSalesOrderSync_Search.SEARCHPARAMS childObj = new SBO_YetiSalesOrderSync_Search.SEARCHPARAMS();
        System.assertEquals(SBO_YetiSalesOrderSync_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

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

        childObj.FromChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.FromChangeTime);

        childObj.ToChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.ToChangeTime);

        childObj.MAX_ROWS = 0;
        System.assertEquals(0, childObj.MAX_ROWS);


    }

    @isTest
    static void testYetiSalesOrderSync_SR()
    {
        SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SR sr = new SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SR();


        System.assertEquals(SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        SBO_YetiSalesOrderSync_Search.SEARCHRESULT childObj = new SBO_YetiSalesOrderSync_Search.SEARCHRESULT();
        System.assertEquals(SBO_YetiSalesOrderSync_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.ShipComplete = 'X';
        System.assertEquals('X', childObj.ShipComplete);

        childObj.BillTo = 'X';
        System.assertEquals('X', childObj.BillTo);

        childObj.BillToName1 = 'X';
        System.assertEquals('X', childObj.BillToName1);

        childObj.BillToName2 = 'X';
        System.assertEquals('X', childObj.BillToName2);

        childObj.BillToStreet = 'X';
        System.assertEquals('X', childObj.BillToStreet);

        childObj.BillToCity = 'X';
        System.assertEquals('X', childObj.BillToCity);

        childObj.BillToPostCode = 'X';
        System.assertEquals('X', childObj.BillToPostCode);

        childObj.BillToCountry = 'X';
        System.assertEquals('X', childObj.BillToCountry);

        childObj.DiscountAmount = 1.5;
        System.assertEquals(1.5, childObj.DiscountAmount);

        childObj.ErpOrderNumber = 'X';
        System.assertEquals('X', childObj.ErpOrderNumber);

        childObj.SalesDocumentType = 'X';
        System.assertEquals('X', childObj.SalesDocumentType);

        childObj.Fob = 'X';
        System.assertEquals('X', childObj.Fob);

        childObj.Misc = 'X';
        System.assertEquals('X', childObj.Misc);

        childObj.NeedByDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.NeedByDate);

        childObj.OrderComment = 'X';
        System.assertEquals('X', childObj.OrderComment);

        childObj.OrderDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.OrderDate);

        childObj.OrderHeld = 'X';
        System.assertEquals('X', childObj.OrderHeld);

        childObj.OrderSource = 'X';
        System.assertEquals('X', childObj.OrderSource);

        childObj.OrderStatus = 'X';
        System.assertEquals('X', childObj.OrderStatus);

        childObj.OrderSubtotal = 1.5;
        System.assertEquals(1.5, childObj.OrderSubtotal);

        childObj.OrderTotal = 1.5;
        System.assertEquals(1.5, childObj.OrderTotal);

        childObj.PurchaseOrder = 'X';
        System.assertEquals('X', childObj.PurchaseOrder);

        childObj.ShipBy = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ShipBy);

        childObj.ShipTo = 'X';
        System.assertEquals('X', childObj.ShipTo);

        childObj.ShipToName = 'X';
        System.assertEquals('X', childObj.ShipToName);

        childObj.ShipVia = 'X';
        System.assertEquals('X', childObj.ShipVia);

        childObj.SoldTo = 'X';
        System.assertEquals('X', childObj.SoldTo);

        childObj.SoldToName = 'X';
        System.assertEquals('X', childObj.SoldToName);

        childObj.Subtotal = 1.5;
        System.assertEquals(1.5, childObj.Subtotal);

        childObj.Tax = 1.5;
        System.assertEquals(1.5, childObj.Tax);

        childObj.Terms = 'X';
        System.assertEquals('X', childObj.Terms);

        childObj.DiscountPrice = 1.5;
        System.assertEquals(1.5, childObj.DiscountPrice);

        childObj.ExtPrice = 1.5;
        System.assertEquals(1.5, childObj.ExtPrice);

        childObj.LineComment = 'X';
        System.assertEquals('X', childObj.LineComment);

        childObj.LineNumber = 'X';
        System.assertEquals('X', childObj.LineNumber);

        childObj.LineStatus = 'X';
        System.assertEquals('X', childObj.LineStatus);

        childObj.LineStatusDesc = 'X';
        System.assertEquals('X', childObj.LineStatusDesc);

        childObj.NeedBy = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.NeedBy);

        childObj.Order = 'X';
        System.assertEquals('X', childObj.Order);

        childObj.OrderQuantity = 1.5;
        System.assertEquals(1.5, childObj.OrderQuantity);

        childObj.PartNumber = 'X';
        System.assertEquals('X', childObj.PartNumber);

        childObj.ProductGroup = 'X';
        System.assertEquals('X', childObj.ProductGroup);

        childObj.Product = 'X';
        System.assertEquals('X', childObj.Product);

        childObj.ProductDesc = 'X';
        System.assertEquals('X', childObj.ProductDesc);

        childObj.RequestDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.RequestDate);

        childObj.SalesCategory = 'X';
        System.assertEquals('X', childObj.SalesCategory);

        childObj.TotalShipped = 1.5;
        System.assertEquals(1.5, childObj.TotalShipped);

        childObj.UnitPrice = 1.5;
        System.assertEquals(1.5, childObj.UnitPrice);

        childObj.ShippingAmount = 1.5;
        System.assertEquals(1.5, childObj.ShippingAmount);

        childObj.Upc = 'X';
        System.assertEquals('X', childObj.Upc);

        childObj.CreditHoldStatus = 'X';
        System.assertEquals('X', childObj.CreditHoldStatus);

        childObj.CreditHoldStatusDescription = 'X';
        System.assertEquals('X', childObj.CreditHoldStatusDescription);

        childObj.LastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.LastChangeDate);

        childObj.LastChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.LastChangeTime);


    }

}
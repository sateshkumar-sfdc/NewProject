/// enosiX Inc. Generated Apex Model
/// Generated On: 8/1/2017 2:59:05 PM
/// SAP Host: From REST Service On: https://na3.salesforce.com
/// CID: From REST Service On: https://na3.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

@isTest
private class TST_YetiInvoiceSync_Search
{

    public class MockSBO_YetiInvoiceSync_Search implements ensx.EnosixFramework.SearchSBOMock
    {
        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            return null;
        }
    }

    @isTest
    static void testSBO()
    {
        ensx.EnosixFramework.setMock(SBO_YetiInvoiceSync_Search.class, new MockSBO_YetiInvoiceSync_Search());
        SBO_YetiInvoiceSync_Search sbo = new SBO_YetiInvoiceSync_Search();
        System.assertEquals(SBO_YetiInvoiceSync_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sbo.SearchContext);
        System.assertEquals(null, sbo.execute());

        SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SC sc = new SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SC();
        System.assertEquals(SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SC.class, sc.getType(), 'getType() does not match object type.');


        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        SBO_YetiInvoiceSync_Search.SEARCHPARAMS childObj = new SBO_YetiInvoiceSync_Search.SEARCHPARAMS();
        System.assertEquals(SBO_YetiInvoiceSync_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.FromCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

        childObj.ToCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

        childObj.FromSalesDocumentNumber = 'X';
        System.assertEquals('X', childObj.FromSalesDocumentNumber);

        childObj.ToSalesDocumentNumber = 'X';
        System.assertEquals('X', childObj.ToSalesDocumentNumber);

        childObj.FromLastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromLastChangeDate);

        childObj.ToLastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToLastChangeDate);

        childObj.ChangeTimeFrom = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.ChangeTimeFrom);

        childObj.ChangeTimeTo = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.ChangeTimeTo);

        childObj.MAX_ROWS = 0;
        System.assertEquals(0, childObj.MAX_ROWS);


    }

    @isTest
    static void testYetiInvoiceSync_SR()
    {
        SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SR sr = new SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SR();


        System.assertEquals(SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        SBO_YetiInvoiceSync_Search.SEARCHRESULT childObj = new SBO_YetiInvoiceSync_Search.SEARCHRESULT();
        System.assertEquals(SBO_YetiInvoiceSync_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.InvoiceSalesRep = 'X';
        System.assertEquals('X', childObj.InvoiceSalesRep);

        childObj.InvoiceAmount = 1.5;
        System.assertEquals(1.5, childObj.InvoiceAmount);

        childObj.InvoiceBalance = 1.5;
        System.assertEquals(1.5, childObj.InvoiceBalance);

        childObj.InvoiceDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.InvoiceDate);

        childObj.BillToParty = 'X';
        System.assertEquals('X', childObj.BillToParty);

        childObj.BillToName1 = 'X';
        System.assertEquals('X', childObj.BillToName1);

        childObj.BillToName2 = 'X';
        System.assertEquals('X', childObj.BillToName2);

        childObj.BillToStreet = 'X';
        System.assertEquals('X', childObj.BillToStreet);

        childObj.BillToCity = 'X';
        System.assertEquals('X', childObj.BillToCity);

        childObj.BillToPostalCode = 'X';
        System.assertEquals('X', childObj.BillToPostalCode);

        childObj.BillToCountry = 'X';
        System.assertEquals('X', childObj.BillToCountry);

        childObj.TotalBeforeDiscount = 1.5;
        System.assertEquals(1.5, childObj.TotalBeforeDiscount);

        childObj.Subtotal = 1.5;
        System.assertEquals(1.5, childObj.Subtotal);

        childObj.Tax = 1.5;
        System.assertEquals(1.5, childObj.Tax);

        childObj.ShippingAmount = 1.5;
        System.assertEquals(1.5, childObj.ShippingAmount);

        childObj.DepositBalance = 1.5;
        System.assertEquals(1.5, childObj.DepositBalance);

        childObj.Discount = 1.5;
        System.assertEquals(1.5, childObj.Discount);

        childObj.DueDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.DueDate);

        childObj.FOB = 'X';
        System.assertEquals('X', childObj.FOB);

        childObj.PurchaseOrderNumber = 'X';
        System.assertEquals('X', childObj.PurchaseOrderNumber);

        childObj.SalesOrder = 'X';
        System.assertEquals('X', childObj.SalesOrder);

        childObj.Delivery = 'X';
        System.assertEquals('X', childObj.Delivery);

        childObj.SoldToParty = 'X';
        System.assertEquals('X', childObj.SoldToParty);

        childObj.SoldToName = 'X';
        System.assertEquals('X', childObj.SoldToName);

        childObj.ShipToParty = 'X';
        System.assertEquals('X', childObj.ShipToParty);

        childObj.ShipToName = 'X';
        System.assertEquals('X', childObj.ShipToName);

        childObj.Status = 'X';
        System.assertEquals('X', childObj.Status);

        childObj.Terms = 'X';
        System.assertEquals('X', childObj.Terms);

        childObj.Description = 'X';
        System.assertEquals('X', childObj.Description);

        childObj.ExtPrice = 1.5;
        System.assertEquals(1.5, childObj.ExtPrice);

        childObj.InvoicedQuantity = 1.5;
        System.assertEquals(1.5, childObj.InvoicedQuantity);

        childObj.PackingLineitemNumber = 'X';
        System.assertEquals('X', childObj.PackingLineitemNumber);

        childObj.PackingSlipnumber = 'X';
        System.assertEquals('X', childObj.PackingSlipnumber);

        childObj.PartNumber = 'X';
        System.assertEquals('X', childObj.PartNumber);

        childObj.ProductGroup = 'X';
        System.assertEquals('X', childObj.ProductGroup);

        childObj.UnitPrice = 1.5;
        System.assertEquals(1.5, childObj.UnitPrice);

        childObj.Invoice = 'X';
        System.assertEquals('X', childObj.Invoice);

        childObj.InvoiceItemNumber = 'X';
        System.assertEquals('X', childObj.InvoiceItemNumber);

        childObj.UPC = 'X';
        System.assertEquals('X', childObj.UPC);

        childObj.LastChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.LastChangeDate);

        childObj.LastChangeTime = Time.newInstance(1,1,1,0);
        System.assertEquals(Time.newInstance(1,1,1,0), childObj.LastChangeTime);


    }

}
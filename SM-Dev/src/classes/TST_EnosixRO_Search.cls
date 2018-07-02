/// enosiX Inc. Generated Apex Model
/// Generated On: 1/26/2017 8:46:28 AM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
private class TST_EnosixRO_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixRO_Search sbo = new SBO_EnosixRO_Search();
		
		System.assertEquals(SBO_EnosixRO_Search.class, sbo.getType(), 'getType() does not match object type.');

		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixRO_Search.SEARCHPARAMS childObj = new SBO_EnosixRO_Search.SEARCHPARAMS();
		System.assertEquals(SBO_EnosixRO_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

			childObj.FromSalesDocumentNumber = 'X';
		System.assertEquals('X', childObj.FromSalesDocumentNumber);

		childObj.ToSalesDocumentNumber = 'X';
		System.assertEquals('X', childObj.ToSalesDocumentNumber);

		childObj.SoldToParty = 'X';
		System.assertEquals('X', childObj.SoldToParty);

		childObj.ShipToParty = 'X';
		System.assertEquals('X', childObj.ShipToParty);

		childObj.CustomerPONumber = 'X';
		System.assertEquals('X', childObj.CustomerPONumber);

		childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.SalesDocumentType = 'X';
		System.assertEquals('X', childObj.SalesDocumentType);

		childObj.FromCreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

		childObj.ToCreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

		childObj.OpenOnly = 'X';
		System.assertEquals('X', childObj.OpenOnly);

		childObj.CompletedOnly = 'X';
		System.assertEquals('X', childObj.CompletedOnly);

		childObj.Username = 'X';
		System.assertEquals('X', childObj.Username);

		childObj.SalesDocumentVersionNumber = 'X';
		System.assertEquals('X', childObj.SalesDocumentVersionNumber);

		childObj.YourReference = 'X';
		System.assertEquals('X', childObj.YourReference);

		childObj.ShipToPurchaseOrderNumber = 'X';
		System.assertEquals('X', childObj.ShipToPurchaseOrderNumber);

	}
@isTest
static void testEnosixRO_SR()
{
SBO_EnosixRO_Search.EnosixRO_SR sr = new SBO_EnosixRO_Search.EnosixRO_SR();

System.assertEquals(SBO_EnosixRO_Search.EnosixRO_SR.class, sr.getType(), 'getType() does not match object type.');

System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixRO_Search.SEARCHRESULT childObj = new SBO_EnosixRO_Search.SEARCHRESULT();
		System.assertEquals(SBO_EnosixRO_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

			childObj.SalesDocument = 'X';
		System.assertEquals('X', childObj.SalesDocument);

		childObj.CustomerPONumber = 'X';
		System.assertEquals('X', childObj.CustomerPONumber);

		childObj.CreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

		childObj.SalesDocumentType = 'X';
		System.assertEquals('X', childObj.SalesDocumentType);

		childObj.SalesDocumentTypeDescription = 'X';
		System.assertEquals('X', childObj.SalesDocumentTypeDescription);

		childObj.SoldToParty = 'X';
		System.assertEquals('X', childObj.SoldToParty);

		childObj.SoldToName = 'X';
		System.assertEquals('X', childObj.SoldToName);

		childObj.SoldToCity = 'X';
		System.assertEquals('X', childObj.SoldToCity);

		childObj.SoldToRegion = 'X';
		System.assertEquals('X', childObj.SoldToRegion);

		childObj.ShipToParty = 'X';
		System.assertEquals('X', childObj.ShipToParty);

		childObj.ShipToName = 'X';
		System.assertEquals('X', childObj.ShipToName);

		childObj.ShipToCity = 'X';
		System.assertEquals('X', childObj.ShipToCity);

		childObj.ShipToRegion = 'X';
		System.assertEquals('X', childObj.ShipToRegion);

		childObj.NetTotalValue = 1.5;
		System.assertEquals(1.5, childObj.NetTotalValue);

		childObj.NetTotalTax = 1.5;
		System.assertEquals(1.5, childObj.NetTotalTax);

		childObj.SalesDocumentCurrency = 'X';
		System.assertEquals('X', childObj.SalesDocumentCurrency);

		childObj.OrderStatus = 'X';
		System.assertEquals('X', childObj.OrderStatus);

		childObj.SalesDocumentVersionNumber = 'X';
		System.assertEquals('X', childObj.SalesDocumentVersionNumber);

		childObj.YourReference = 'X';
		System.assertEquals('X', childObj.YourReference);

		childObj.ShipToPurchaseOrderNumber = 'X';
		System.assertEquals('X', childObj.ShipToPurchaseOrderNumber);

	}

}
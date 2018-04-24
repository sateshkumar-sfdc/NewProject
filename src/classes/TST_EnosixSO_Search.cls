/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
private class TST_EnosixSO_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixSO_Search sbo = new SBO_EnosixSO_Search();
		
		System.assertEquals(SBO_EnosixSO_Search.class, sbo.getType(), 'getType() does not match object type.');

		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixSO_Search.SEARCHPARAMS childObj = new SBO_EnosixSO_Search.SEARCHPARAMS();
		System.assertEquals(SBO_EnosixSO_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

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
static void testEnosixSO_SR()
{
SBO_EnosixSO_Search.EnosixSO_SR sr = new SBO_EnosixSO_Search.EnosixSO_SR();

System.assertEquals(SBO_EnosixSO_Search.EnosixSO_SR.class, sr.getType(), 'getType() does not match object type.');

System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixSO_Search.SEARCHRESULT childObj = new SBO_EnosixSO_Search.SEARCHRESULT();
		System.assertEquals(SBO_EnosixSO_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

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

		childObj.NetOrderValue = 1.5;
		System.assertEquals(1.5, childObj.NetOrderValue);

		childObj.TaxAmount = 1.5;
		System.assertEquals(1.5, childObj.TaxAmount);

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
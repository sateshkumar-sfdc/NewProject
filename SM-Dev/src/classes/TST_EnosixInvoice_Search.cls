/// enosiX Inc. Generated Apex Model
/// Generated On: 1/17/2017 3:39:05 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
private class TST_EnosixInvoice_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixInvoice_Search sbo = new SBO_EnosixInvoice_Search();
		
		System.assertEquals(SBO_EnosixInvoice_Search.class, sbo.getType(), 'getType() does not match object type.');

		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixInvoice_Search.SEARCHPARAMS childObj = new SBO_EnosixInvoice_Search.SEARCHPARAMS();
		System.assertEquals(SBO_EnosixInvoice_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

			childObj.FromBillingDocumentNumber = 'X';
		System.assertEquals('X', childObj.FromBillingDocumentNumber);

		childObj.ToBillingDocumentNumber = 'X';
		System.assertEquals('X', childObj.ToBillingDocumentNumber);

		childObj.SalesOrganization = 'X';
		System.assertEquals('X', childObj.SalesOrganization);

		childObj.Payer = 'X';
		System.assertEquals('X', childObj.Payer);

		childObj.SoldToParty = 'X';
		System.assertEquals('X', childObj.SoldToParty);

		childObj.BillingType = 'X';
		System.assertEquals('X', childObj.BillingType);

		childObj.FromBillingDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromBillingDate);

		childObj.ToBillingDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToBillingDate);

		childObj.FromCreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

		childObj.ToCreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

		childObj.CreatedBy = 'X';
		System.assertEquals('X', childObj.CreatedBy);

	}
@isTest
static void testEnosixInvoice_SR()
{
SBO_EnosixInvoice_Search.EnosixInvoice_SR sr = new SBO_EnosixInvoice_Search.EnosixInvoice_SR();

System.assertEquals(SBO_EnosixInvoice_Search.EnosixInvoice_SR.class, sr.getType(), 'getType() does not match object type.');

System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixInvoice_Search.SEARCHRESULT childObj = new SBO_EnosixInvoice_Search.SEARCHRESULT();
		System.assertEquals(SBO_EnosixInvoice_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

			childObj.BillingDocument = 'X';
		System.assertEquals('X', childObj.BillingDocument);

		childObj.BillingType = 'X';
		System.assertEquals('X', childObj.BillingType);

		childObj.BillingTypeDescription = 'X';
		System.assertEquals('X', childObj.BillingTypeDescription);

		childObj.CompanyCode = 'X';
		System.assertEquals('X', childObj.CompanyCode);

		childObj.CompanyCodeName = 'X';
		System.assertEquals('X', childObj.CompanyCodeName);

		childObj.SalesOrganization = 'X';
		System.assertEquals('X', childObj.SalesOrganization);

		childObj.SalesOrgDescription = 'X';
		System.assertEquals('X', childObj.SalesOrgDescription);

		childObj.BillingDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.BillingDate);

		childObj.ShipDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ShipDate);

		childObj.SalesOrderNumber = 'X';
		System.assertEquals('X', childObj.SalesOrderNumber);

		childObj.Payer = 'X';
		System.assertEquals('X', childObj.Payer);

		childObj.PayerName = 'X';
		System.assertEquals('X', childObj.PayerName);

		childObj.SoldToParty = 'X';
		System.assertEquals('X', childObj.SoldToParty);

		childObj.SoldToName = 'X';
		System.assertEquals('X', childObj.SoldToName);

		childObj.ShipToParty = 'X';
		System.assertEquals('X', childObj.ShipToParty);

		childObj.ShipToName = 'X';
		System.assertEquals('X', childObj.ShipToName);

		childObj.TrackingNumber = 'X';
		System.assertEquals('X', childObj.TrackingNumber);

		childObj.NetOrderValue = 1.5;
		System.assertEquals(1.5, childObj.NetOrderValue);

		childObj.TaxAmount = 1.5;
		System.assertEquals(1.5, childObj.TaxAmount);

		childObj.SalesDocumentCurrency = 'X';
		System.assertEquals('X', childObj.SalesDocumentCurrency);

		childObj.CreatedBy = 'X';
		System.assertEquals('X', childObj.CreatedBy);

		childObj.CreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

		childObj.BillingStatus = 'X';
		System.assertEquals('X', childObj.BillingStatus);

		childObj.BillingStatusDescription = 'X';
		System.assertEquals('X', childObj.BillingStatusDescription);

	}

}
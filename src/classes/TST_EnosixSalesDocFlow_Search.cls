/// enosiX Apex Model
/// Generated On: 9/7/2016 10:47:11 AM
/// SAP Host: 
/// CID: 

@isTest
private class TST_EnosixSalesDocFlow_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixSalesDocFlow_Search sbo = new SBO_EnosixSalesDocFlow_Search();
		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixSalesDocFlow_Search.SEARCHPARAMS childObj = new SBO_EnosixSalesDocFlow_Search.SEARCHPARAMS();
			childObj.SalesDocument = 'X';
		System.assertEquals('X', childObj.SalesDocument);

		childObj.CustomerPONumber = 'X';
		System.assertEquals('X', childObj.CustomerPONumber);

		childObj.DocumentCategory = 'X';
		System.assertEquals('X', childObj.DocumentCategory);

		childObj.X_PrecedingDocuments = 'X';
		System.assertEquals('X', childObj.X_PrecedingDocuments);

		childObj.X_SubsequentDocuments = 'X';
		System.assertEquals('X', childObj.X_SubsequentDocuments);

	}
@isTest
static void testEnosixSalesDocFlow_SR()
{
SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SR sr = new SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SR();
System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixSalesDocFlow_Search.SEARCHRESULT childObj = new SBO_EnosixSalesDocFlow_Search.SEARCHRESULT();
			childObj.SalesDocument = 'X';
		System.assertEquals('X', childObj.SalesDocument);

		childObj.ItemNumber = 'X';
		System.assertEquals('X', childObj.ItemNumber);

		childObj.DocumentCategory = 'X';
		System.assertEquals('X', childObj.DocumentCategory);

		childObj.DocumentCategoryText = 'X';
		System.assertEquals('X', childObj.DocumentCategoryText);

		childObj.CustomerNumber = 'X';
		System.assertEquals('X', childObj.CustomerNumber);

		childObj.CreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

		childObj.CreatedBy = 'X';
		System.assertEquals('X', childObj.CreatedBy);

		childObj.DateChanged = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.DateChanged);

		childObj.ChangedBy = 'X';
		System.assertEquals('X', childObj.ChangedBy);

		childObj.X_PrecedingDocuments = 'X';
		System.assertEquals('X', childObj.X_PrecedingDocuments);

		childObj.X_SubsequentDocuments = 'X';
		System.assertEquals('X', childObj.X_SubsequentDocuments);

		childObj.DocumentStatus = 'X';
		System.assertEquals('X', childObj.DocumentStatus);

	}

}
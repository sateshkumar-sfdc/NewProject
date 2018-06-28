/// enosiX Inc. Generated Apex Model
/// Generated On: 10/6/2016 12:57:18 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
private class TST_EnosixStockList_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixStockList_Search sbo = new SBO_EnosixStockList_Search();
		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixStockList_Search.SEARCHPARAMS childObj = new SBO_EnosixStockList_Search.SEARCHPARAMS();
			childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.FromDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromDate);

		childObj.ToDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToDate);

	}
@isTest
static void testEnosixStockList_SR()
{
SBO_EnosixStockList_Search.EnosixStockList_SR sr = new SBO_EnosixStockList_Search.EnosixStockList_SR();
System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixStockList_Search.SEARCHRESULT childObj = new SBO_EnosixStockList_Search.SEARCHRESULT();
			childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.ReceiptRequirementDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ReceiptRequirementDate);

		childObj.MRPElement = 'X';
		System.assertEquals('X', childObj.MRPElement);

		childObj.MRPElementData = 'X';
		System.assertEquals('X', childObj.MRPElementData);

		childObj.ReschedulingDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ReschedulingDate);

		childObj.QtyReceivedReserved = 1.5;
		System.assertEquals(1.5, childObj.QtyReceivedReserved);

		childObj.AvailableQty = 1.5;
		System.assertEquals(1.5, childObj.AvailableQty);

		childObj.AvailableQtyAfterAssignment = 1.5;
		System.assertEquals(1.5, childObj.AvailableQtyAfterAssignment);

		childObj.StorageLocation = 'X';
		System.assertEquals('X', childObj.StorageLocation);

	}

}
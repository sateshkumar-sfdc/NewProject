@isTest
public class MOC_EnosixStockList_Search
{
	public class MockEnosixStockListSuccess implements ENSX.EnosixFramework.SearchSBOMock
	{
		public ENSX.EnosixFramework.SearchResult executeSearch() 
		{
            SBO_EnosixStockList_Search.EnosixStockList_SR search_result = new SBO_EnosixStockList_Search.EnosixStockList_SR();
            
            SBO_EnosixStockList_Search.SEARCHRESULT result = new SBO_EnosixStockList_Search.SEARCHRESULT();
            
			result.Material = 'X';
			result.Plant = 'X';
			result.ReceiptRequirementDate = Date.valueOf('2020-12-31');
			result.MRPElement = 'X';
			result.MRPElementData = 'X';
			result.ReschedulingDate = Date.valueOf('2020-12-31');
			result.QtyReceivedReserved = 1.5;
			result.AvailableQty = 1.5;
			result.AvailableQtyAfterAssignment = 1.5;
			result.StorageLocation = 'X';
			
			search_result.SearchResults.add(result);
			
			search_result.setSuccess(true);
			
			return search_result;
        }
	}

	public class MockEnosixStockListFailure implements ENSX.EnosixFramework.SearchSBOMock
	{
		public ENSX.EnosixFramework.SearchResult executeSearch() 
		{
            SBO_EnosixStockList_Search.EnosixStockList_SR search_result = new SBO_EnosixStockList_Search.EnosixStockList_SR();
            
            SBO_EnosixStockList_Search.SEARCHRESULT result = new SBO_EnosixStockList_Search.SEARCHRESULT();
            
			result.Material = 'X';
			result.Plant = 'X';
			result.ReceiptRequirementDate = Date.valueOf('2020-12-31');
			result.MRPElement = 'X';
			result.MRPElementData = 'X';
			result.ReschedulingDate = Date.valueOf('2020-12-31');
			result.QtyReceivedReserved = 1.5;
			result.AvailableQty = 1.5;
			result.AvailableQtyAfterAssignment = 1.5;
			result.StorageLocation = 'X';
			
			search_result.SearchResults.add(result);
			
			search_result.setSuccess(false);
			
			return search_result;
        }
	}
}
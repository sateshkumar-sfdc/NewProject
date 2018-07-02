@isTest
public class MOC_EnosixWarehouseStock_Search
{
	public class MockEnosixWarehouseStockSuccess implements ENSX.EnosixFramework.SearchSBOMock
	{
		public ENSX.EnosixFramework.SearchResult executeSearch() 
		{
            SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SR search_result = new SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SR();
            
            SBO_EnosixWarehouseStock_Search.SEARCHRESULT result = new SBO_EnosixWarehouseStock_Search.SEARCHRESULT();
            
			result.Material = 'X';
			result.MaterialDescription = 'X';
			result.Plant = 'X';
			result.StorageLocation = 'X';
			result.StorageLocationDescription = 'X';
			result.MaterialType = 'X';
			result.MaterialGroup = 'X';
			result.SpecialStockInd = 'X';
			result.ValuationofSpecialStock = 'X';
			result.SpecialStockNumber = 'X';
			result.DeletionFLag = 'X';
			result.BatchNumber = 'X';
			result.QuantityUOM = 'X';
			result.Currencies = 'X';
			result.UnrestrictedStock = 1.5;
			result.UnrestrictedValue = 1.5;
			result.TransitTransferStock = 1.5;
			result.TransitTransferValue = 1.5;
			result.QualityInspectionStock = 1.5;
			result.QualityInspectionValue = 1.5;
			result.RestrictedStock = 1.5;
			result.RestrictedValue = 1.5;
			result.BlockedStock = 1.5;
			result.BlockedValue = 1.5;
			result.ReturnsStock = 1.5;
			result.ReturnsValue = 1.5;
			result.SystemID = 'X';
			
			search_result.SearchResults.add(result);
			
			search_result.setSuccess(true);
			
			return search_result;
        }
	}

	public class MockEnosixWarehouseStockFailure implements ENSX.EnosixFramework.SearchSBOMock
	{
		public ENSX.EnosixFramework.SearchResult executeSearch() 
		{
            SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SR search_result = new SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SR();
            
            SBO_EnosixWarehouseStock_Search.SEARCHRESULT result = new SBO_EnosixWarehouseStock_Search.SEARCHRESULT();
            
			result.Material = 'X';
			result.MaterialDescription = 'X';
			result.Plant = 'X';
			result.StorageLocation = 'X';
			result.StorageLocationDescription = 'X';
			result.MaterialType = 'X';
			result.MaterialGroup = 'X';
			result.SpecialStockInd = 'X';
			result.ValuationofSpecialStock = 'X';
			result.SpecialStockNumber = 'X';
			result.DeletionFLag = 'X';
			result.BatchNumber = 'X';
			result.QuantityUOM = 'X';
			result.Currencies = 'X';
			result.UnrestrictedStock = 1.5;
			result.UnrestrictedValue = 1.5;
			result.TransitTransferStock = 1.5;
			result.TransitTransferValue = 1.5;
			result.QualityInspectionStock = 1.5;
			result.QualityInspectionValue = 1.5;
			result.RestrictedStock = 1.5;
			result.RestrictedValue = 1.5;
			result.BlockedStock = 1.5;
			result.BlockedValue = 1.5;
			result.ReturnsStock = 1.5;
			result.ReturnsValue = 1.5;
			result.SystemID = 'X';
			
			search_result.SearchResults.add(result);
			
			search_result.setSuccess(false);
			
			return search_result;
        }
	}
}
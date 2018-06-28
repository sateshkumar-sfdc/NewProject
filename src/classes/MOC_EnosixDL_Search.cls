@isTest
public class MOC_EnosixDL_Search
{
	public class MockEnosixDLSuccess implements ensx.EnosixFramework.SearchSBOMock
	{
		public ensx.EnosixFramework.SearchResult executeSearch() 
		{
            SBO_EnosixDL_Search.EnosixDL_SR search_result = new SBO_EnosixDL_Search.EnosixDL_SR();

			SBO_EnosixDL_Search.SEARCHRESULT result = new SBO_EnosixDL_Search.SEARCHRESULT();
					result.Delivery = 'X';
		result.Route = 'X';
		result.Truck = 'X';
		result.BillofLading = 'X';
		result.CreateDate = Date.valueOf('2020-12-31');
		result.DeliveryDate = Date.valueOf('2020-12-31');
		result.PGIDate = Date.valueOf('2020-12-31');
		result.DeliveryType = 'X';
		result.DeliveryTypeText = 'X';
		result.SoldToParty = 'X';
		result.SoldToName = 'X';
		result.SoldToCity = 'X';
		result.SoldToRegion = 'X';
		result.ShipToParty = 'X';
		result.ShipToName = 'X';
		result.ShipToCity = 'X';
		result.ShipToRegion = 'X';
		result.ShippingPoint = 'X';
		result.ShippingConditions = 'X';
		result.DeliveryPriority = 'X';
		result.NetOrderValue = 1.5;
		result.SalesDocumentCurrency = 'X';
		result.DeliveryStatus = 'X';
			search_result.SearchResults.add(result);

			search_result.setSuccess(true);

			return search_result;
        }
	}

	public class MockEnosixDLFailure implements ensx.EnosixFramework.SearchSBOMock
	{
		public ensx.EnosixFramework.SearchResult executeSearch() 
		{
            SBO_EnosixDL_Search.EnosixDL_SR search_result = new SBO_EnosixDL_Search.EnosixDL_SR();

			SBO_EnosixDL_Search.SEARCHRESULT result = new SBO_EnosixDL_Search.SEARCHRESULT();
					result.Delivery = 'X';
		result.Route = 'X';
		result.Truck = 'X';
		result.BillofLading = 'X';
		result.CreateDate = Date.valueOf('2020-12-31');
		result.DeliveryDate = Date.valueOf('2020-12-31');
		result.PGIDate = Date.valueOf('2020-12-31');
		result.DeliveryType = 'X';
		result.DeliveryTypeText = 'X';
		result.SoldToParty = 'X';
		result.SoldToName = 'X';
		result.SoldToCity = 'X';
		result.SoldToRegion = 'X';
		result.ShipToParty = 'X';
		result.ShipToName = 'X';
		result.ShipToCity = 'X';
		result.ShipToRegion = 'X';
		result.ShippingPoint = 'X';
		result.ShippingConditions = 'X';
		result.DeliveryPriority = 'X';
		result.NetOrderValue = 1.5;
		result.SalesDocumentCurrency = 'X';
		result.DeliveryStatus = 'X';
			search_result.SearchResults.add(result);

			search_result.setSuccess(false);

			return search_result;
        }
	}
}
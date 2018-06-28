@isTest
public class MOC_EnosixInvoice_Search
{
	public class MockEnosixInvoiceSuccess implements ensx.EnosixFramework.SearchSBOMock
	{
		public ensx.EnosixFramework.SearchResult executeSearch() 
		{
            SBO_EnosixInvoice_Search.EnosixInvoice_SR search_result = new SBO_EnosixInvoice_Search.EnosixInvoice_SR();

			SBO_EnosixInvoice_Search.SEARCHRESULT result = new SBO_EnosixInvoice_Search.SEARCHRESULT();
					result.BillingDocument = 'X';
		result.BillingType = 'X';
		result.BillingTypeDescription = 'X';
		result.CompanyCode = 'X';
		result.CompanyCodeName = 'X';
		result.SalesOrganization = 'X';
		result.SalesOrgDescription = 'X';
		result.BillingDate = Date.valueOf('2020-12-31');
		result.ShipDate = Date.valueOf('2020-12-31');
		result.SalesOrderNumber = 'X';
		result.Payer = 'X';
		result.PayerName = 'X';
		result.SoldToParty = 'X';
		result.SoldToName = 'X';
		result.ShipToParty = 'X';
		result.ShipToName = 'X';
		result.TrackingNumber = 'X';
		result.NetOrderValue = 1.5;
		result.SalesDocumentCurrency = 'X';
		result.CreatedBy = 'X';
		result.CreateDate = Date.valueOf('2020-12-31');
		result.BillingStatus = 'X';
		result.BillingStatusDescription = 'X';
			search_result.SearchResults.add(result);

			search_result.setSuccess(true);

			return search_result;
        }
	}

	public class MockEnosixInvoiceFailure implements ensx.EnosixFramework.SearchSBOMock
	{
		public ensx.EnosixFramework.SearchResult executeSearch() 
		{
            SBO_EnosixInvoice_Search.EnosixInvoice_SR search_result = new SBO_EnosixInvoice_Search.EnosixInvoice_SR();

			SBO_EnosixInvoice_Search.SEARCHRESULT result = new SBO_EnosixInvoice_Search.SEARCHRESULT();
					result.BillingDocument = 'X';
		result.BillingType = 'X';
		result.BillingTypeDescription = 'X';
		result.CompanyCode = 'X';
		result.CompanyCodeName = 'X';
		result.SalesOrganization = 'X';
		result.SalesOrgDescription = 'X';
		result.BillingDate = Date.valueOf('2020-12-31');
		result.ShipDate = Date.valueOf('2020-12-31');
		result.SalesOrderNumber = 'X';
		result.Payer = 'X';
		result.PayerName = 'X';
		result.SoldToParty = 'X';
		result.SoldToName = 'X';
		result.ShipToParty = 'X';
		result.ShipToName = 'X';
		result.TrackingNumber = 'X';
		result.NetOrderValue = 1.5;
		result.SalesDocumentCurrency = 'X';
		result.CreatedBy = 'X';
		result.CreateDate = Date.valueOf('2020-12-31');
		result.BillingStatus = 'X';
		result.BillingStatusDescription = 'X';
			search_result.SearchResults.add(result);

			search_result.setSuccess(false);

			return search_result;
        }
	}
}
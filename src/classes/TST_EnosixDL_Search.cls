@isTest
private class TST_EnosixDL_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixDL_Search sbo = new SBO_EnosixDL_Search();
		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
			@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixDL_Search.SEARCHPARAMS childObj = new SBO_EnosixDL_Search.SEARCHPARAMS();
			childObj.Route = 'X';
		System.assertEquals('X', childObj.Route);

		childObj.Truck = 'X';
		System.assertEquals('X', childObj.Truck);

		childObj.FromCreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

		childObj.ToCreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

		childObj.DeliveryDateFrom = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.DeliveryDateFrom);

		childObj.DeliveryDateTo = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.DeliveryDateTo);

		childObj.DeliveryFrom = 'X';
		System.assertEquals('X', childObj.DeliveryFrom);

		childObj.DeliveryTo = 'X';
		System.assertEquals('X', childObj.DeliveryTo);

		childObj.SoldToParty = 'X';
		System.assertEquals('X', childObj.SoldToParty);

		childObj.ShipToParty = 'X';
		System.assertEquals('X', childObj.ShipToParty);

		childObj.DeliveryType = 'X';
		System.assertEquals('X', childObj.DeliveryType);

		childObj.ShippingPoint = 'X';
		System.assertEquals('X', childObj.ShippingPoint);

		childObj.ShippingConditions = 'X';
		System.assertEquals('X', childObj.ShippingConditions);

		childObj.DeliveryPriority = 'X';
		System.assertEquals('X', childObj.DeliveryPriority);

		childObj.BillofLading = 'X';
		System.assertEquals('X', childObj.BillofLading);

		childObj.PGIDateFrom = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.PGIDateFrom);

		childObj.PGIDateTo = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.PGIDateTo);

		childObj.Username = 'X';
		System.assertEquals('X', childObj.Username);

		childObj.Open = 'X';
		System.assertEquals('X', childObj.Open);

		childObj.Picked = 'X';
		System.assertEquals('X', childObj.Picked);

		childObj.Packed = 'X';
		System.assertEquals('X', childObj.Packed);

		childObj.PGIed = 'X';
		System.assertEquals('X', childObj.PGIed);

	}
@isTest
static void testEnosixDL_SR()
{
SBO_EnosixDL_Search.EnosixDL_SR sr = new SBO_EnosixDL_Search.EnosixDL_SR();
System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixDL_Search.SEARCHRESULT childObj = new SBO_EnosixDL_Search.SEARCHRESULT();
			childObj.Delivery = 'X';
		System.assertEquals('X', childObj.Delivery);

		childObj.Route = 'X';
		System.assertEquals('X', childObj.Route);

		childObj.Truck = 'X';
		System.assertEquals('X', childObj.Truck);

		childObj.BillofLading = 'X';
		System.assertEquals('X', childObj.BillofLading);

		childObj.CreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

		childObj.DeliveryDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.DeliveryDate);

		childObj.PGIDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.PGIDate);

		childObj.DeliveryType = 'X';
		System.assertEquals('X', childObj.DeliveryType);

		childObj.DeliveryTypeText = 'X';
		System.assertEquals('X', childObj.DeliveryTypeText);

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

		childObj.ShippingPoint = 'X';
		System.assertEquals('X', childObj.ShippingPoint);

		childObj.ShippingConditions = 'X';
		System.assertEquals('X', childObj.ShippingConditions);

		childObj.DeliveryPriority = 'X';
		System.assertEquals('X', childObj.DeliveryPriority);

		childObj.NetOrderValue = 1.5;
		System.assertEquals(1.5, childObj.NetOrderValue);

		childObj.SalesDocumentCurrency = 'X';
		System.assertEquals('X', childObj.SalesDocumentCurrency);

		childObj.DeliveryStatus = 'X';
		System.assertEquals('X', childObj.DeliveryStatus);

	}

}
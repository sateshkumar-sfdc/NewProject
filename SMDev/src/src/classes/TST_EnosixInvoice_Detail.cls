/// enosiX Inc. Generated Apex Model
/// Generated On: 1/17/2017 3:39:05 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_EnosixInvoice_Detail{
	@isTest
	static void testEnosixInvoice(){
		SBO_EnosixInvoice_Detail.EnosixInvoice sbo = new SBO_EnosixInvoice_Detail.EnosixInvoice();
		System.assertEquals(SBO_EnosixInvoice_Detail.EnosixInvoice.class, sbo.getType(), 'getType() does not match object type.');
				sbo.BillingDocument = 'X';
		System.assertEquals('X', sbo.BillingDocument);

		sbo.BillingType = 'X';
		System.assertEquals('X', sbo.BillingType);

		sbo.BillingTypeDescription = 'X';
		System.assertEquals('X', sbo.BillingTypeDescription);

		sbo.CompanyCode = 'X';
		System.assertEquals('X', sbo.CompanyCode);

		sbo.CompanyCodeName = 'X';
		System.assertEquals('X', sbo.CompanyCodeName);

		sbo.SalesOrganization = 'X';
		System.assertEquals('X', sbo.SalesOrganization);

		sbo.SalesOrgDescription = 'X';
		System.assertEquals('X', sbo.SalesOrgDescription);

		sbo.BillingDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), sbo.BillingDate);

		sbo.ShipDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), sbo.ShipDate);

		sbo.SalesOrderNumber = 'X';
		System.assertEquals('X', sbo.SalesOrderNumber);

		sbo.Payer = 'X';
		System.assertEquals('X', sbo.Payer);

		sbo.PayerName = 'X';
		System.assertEquals('X', sbo.PayerName);

		sbo.SoldToParty = 'X';
		System.assertEquals('X', sbo.SoldToParty);

		sbo.SoldToName = 'X';
		System.assertEquals('X', sbo.SoldToName);

		sbo.ShipToParty = 'X';
		System.assertEquals('X', sbo.ShipToParty);

		sbo.ShipToName = 'X';
		System.assertEquals('X', sbo.ShipToName);

		sbo.TrackingNumber = 'X';
		System.assertEquals('X', sbo.TrackingNumber);

		sbo.PaymentMethod = 'X';
		System.assertEquals('X', sbo.PaymentMethod);

		sbo.PaymentMethodDescription = 'X';
		System.assertEquals('X', sbo.PaymentMethodDescription);

		sbo.TermsofPaymentKey = 'X';
		System.assertEquals('X', sbo.TermsofPaymentKey);

		sbo.TermsOfPaymentKeyDesc = 'X';
		System.assertEquals('X', sbo.TermsOfPaymentKeyDesc);

		sbo.NetOrderValue = 1.5;
		System.assertEquals(1.5, sbo.NetOrderValue);

		sbo.TaxAmount = 1.5;
		System.assertEquals(1.5, sbo.TaxAmount);

		sbo.SalesDocumentCurrency = 'X';
		System.assertEquals('X', sbo.SalesDocumentCurrency);

		sbo.CreatedBy = 'X';
		System.assertEquals('X', sbo.CreatedBy);

		sbo.CreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), sbo.CreateDate);

		sbo.BillingStatus = 'X';
		System.assertEquals('X', sbo.BillingStatus);

		sbo.BillingStatusDescription = 'X';
		System.assertEquals('X', sbo.BillingStatusDescription);

		//Test child collections
		System.assertNotEquals(null,sbo.ITEMS);
		System.assertNotEquals(null,sbo.CONDITIONS);
	}

		@isTest
	static void testITEMS()
	{
		SBO_EnosixInvoice_Detail.ITEMS childObj = new SBO_EnosixInvoice_Detail.ITEMS();

		System.assertEquals(SBO_EnosixInvoice_Detail.ITEMS.class,childObj.getType(),'getType() does not match object type.');
			childObj.ItemNumber = 'X';
		System.assertEquals('X', childObj.ItemNumber);

		childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.ItemDescription = 'X';
		System.assertEquals('X', childObj.ItemDescription);

		childObj.BillingQuantity = 1.5;
		System.assertEquals(1.5, childObj.BillingQuantity);

		childObj.SalesUnit = 'X';
		System.assertEquals('X', childObj.SalesUnit);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.PlantDescription = 'X';
		System.assertEquals('X', childObj.PlantDescription);

		childObj.NetItemValue = 1.5;
		System.assertEquals(1.5, childObj.NetItemValue);

		childObj.TaxAmount = 1.5;
		System.assertEquals(1.5, childObj.TaxAmount);

		childObj.SalesDocumentCurrency = 'X';
		System.assertEquals('X', childObj.SalesDocumentCurrency);

List<string> keyFields = new List<string>{ 'POSNR' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testCONDITIONS()
	{
		SBO_EnosixInvoice_Detail.CONDITIONS childObj = new SBO_EnosixInvoice_Detail.CONDITIONS();

		System.assertEquals(SBO_EnosixInvoice_Detail.CONDITIONS.class,childObj.getType(),'getType() does not match object type.');
			childObj.ConditionItemNumber = 'X';
		System.assertEquals('X', childObj.ConditionItemNumber);

		childObj.ConditionType = 'X';
		System.assertEquals('X', childObj.ConditionType);

		childObj.ConditionPricingDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ConditionPricingDate);

		childObj.ConditionBaseValue = 1.5;
		System.assertEquals(1.5, childObj.ConditionBaseValue);

		childObj.Rate = 1.5;
		System.assertEquals(1.5, childObj.Rate);

		childObj.CurrencyKey = 'X';
		System.assertEquals('X', childObj.CurrencyKey);

		childObj.ConditionExchangeRate = 1.5;
		System.assertEquals(1.5, childObj.ConditionExchangeRate);

List<string> keyFields = new List<string>{ 'KPOSN','KSCHL' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
}
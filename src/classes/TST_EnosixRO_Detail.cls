/// enosiX Inc. Generated Apex Model
/// Generated On: 1/26/2017 8:46:28 AM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_EnosixRO_Detail{
	@isTest
	static void testEnosixRO(){
		SBO_EnosixRO_Detail.EnosixRO sbo = new SBO_EnosixRO_Detail.EnosixRO();
		System.assertEquals(SBO_EnosixRO_Detail.EnosixRO.class, sbo.getType(), 'getType() does not match object type.');
				sbo.SalesDocument = 'X';
		System.assertEquals('X', sbo.SalesDocument);

		sbo.SoldToParty = 'X';
		System.assertEquals('X', sbo.SoldToParty);

		sbo.SoldToPartyText = 'X';
		System.assertEquals('X', sbo.SoldToPartyText);

		sbo.CustomerPurchaseOrderNumber = 'X';
		System.assertEquals('X', sbo.CustomerPurchaseOrderNumber);

		sbo.CustomerPurchaseOrderDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), sbo.CustomerPurchaseOrderDate);

		sbo.NetTotalValue = 1.5;
		System.assertEquals(1.5, sbo.NetTotalValue);

		sbo.NetTotalTax = 1.5;
		System.assertEquals(1.5, sbo.NetTotalTax);

		sbo.NetReturnValue = 1.5;
		System.assertEquals(1.5, sbo.NetReturnValue);

		sbo.NetReturnTax = 1.5;
		System.assertEquals(1.5, sbo.NetReturnTax);

		sbo.NetReplacementValue = 1.5;
		System.assertEquals(1.5, sbo.NetReplacementValue);

		sbo.NetReplacementTax = 1.5;
		System.assertEquals(1.5, sbo.NetReplacementTax);

		sbo.SalesDocumentCurrency = 'X';
		System.assertEquals('X', sbo.SalesDocumentCurrency);

		sbo.BillingPlan = 'X';
		System.assertEquals('X', sbo.BillingPlan);

		sbo.OrderReason = 'X';
		System.assertEquals('X', sbo.OrderReason);

		sbo.OrderReasonDescription = 'X';
		System.assertEquals('X', sbo.OrderReasonDescription);

		sbo.ProcessIDNumber = 'X';
		System.assertEquals('X', sbo.ProcessIDNumber);

		//Test child collections
		System.assertNotEquals(null,sbo.SALES);
		System.assertNotEquals(null,sbo.SHIPPING);
		System.assertNotEquals(null,sbo.BILLING);
		System.assertNotEquals(null,sbo.ACCOUNTING);
		System.assertNotEquals(null,sbo.CONDITIONS);
		System.assertNotEquals(null,sbo.ACCOUNT_ASSIGNMENT);
		System.assertNotEquals(null,sbo.PARTNERS);
		System.assertNotEquals(null,sbo.TEXTS);
		System.assertNotEquals(null,sbo.ORDERDATA);
		System.assertNotEquals(null,sbo.STATUS);
		System.assertNotEquals(null,sbo.ADDITIONAL_DATA_A);
		System.assertNotEquals(null,sbo.ITEMS);
		System.assertNotEquals(null,sbo.ITEMS_SCHEDULE);
		System.assertNotEquals(null,sbo.ITEMS_ARM);
		System.assertNotEquals(null,sbo.ITEMS_TEXT);
		System.assertNotEquals(null,sbo.MATERIAL_UOM);
		System.assertNotEquals(null,sbo.CCARD);
		System.assertNotEquals(null,sbo.ITEMS_ACTION);
	}

		@isTest
	static void testSALES()
	{
		SBO_EnosixRO_Detail.SALES childObj = new SBO_EnosixRO_Detail.SALES();

		System.assertEquals(SBO_EnosixRO_Detail.SALES.class,childObj.getType(),'getType() does not match object type.');
			childObj.SalesDocumentType = 'X';
		System.assertEquals('X', childObj.SalesDocumentType);

		childObj.SalesDocumentTypeDescription = 'X';
		System.assertEquals('X', childObj.SalesDocumentTypeDescription);

		childObj.SalesOrganization = 'X';
		System.assertEquals('X', childObj.SalesOrganization);

		childObj.SalesOrganizationName = 'X';
		System.assertEquals('X', childObj.SalesOrganizationName);

		childObj.DistributionChannel = 'X';
		System.assertEquals('X', childObj.DistributionChannel);

		childObj.DistributionChannelName = 'X';
		System.assertEquals('X', childObj.DistributionChannelName);

		childObj.Division = 'X';
		System.assertEquals('X', childObj.Division);

		childObj.DivisionName = 'X';
		System.assertEquals('X', childObj.DivisionName);

		childObj.SalesGroup = 'X';
		System.assertEquals('X', childObj.SalesGroup);

		childObj.SalesGroupName = 'X';
		System.assertEquals('X', childObj.SalesGroupName);

		childObj.SalesOffice = 'X';
		System.assertEquals('X', childObj.SalesOffice);

		childObj.SalesOfficeName = 'X';
		System.assertEquals('X', childObj.SalesOfficeName);

		childObj.CreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

		childObj.EntryTime = Time.newInstance(1,1,1,0);
		System.assertEquals(Time.newInstance(1,1,1,0), childObj.EntryTime);

		childObj.CreatedBy = 'X';
		System.assertEquals('X', childObj.CreatedBy);

		childObj.ValidFrom = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidFrom);

		childObj.ValidTo = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidTo);

		childObj.SalesDocumentVersionNumber = 'X';
		System.assertEquals('X', childObj.SalesDocumentVersionNumber);

		childObj.WarrantyDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.WarrantyDate);

		childObj.OrderReason = 'X';
		System.assertEquals('X', childObj.OrderReason);

		childObj.OrderReasonDescription = 'X';
		System.assertEquals('X', childObj.OrderReasonDescription);

		childObj.AgreedDeliveryTime = 'X';
		System.assertEquals('X', childObj.AgreedDeliveryTime);

		childObj.AgreedDeliveryTimeDescription = 'X';
		System.assertEquals('X', childObj.AgreedDeliveryTimeDescription);

		childObj.SalesDocumentCurrency = 'X';
		System.assertEquals('X', childObj.SalesDocumentCurrency);

		childObj.ExchangeRatePriceDetermination = 1.5;
		System.assertEquals(1.5, childObj.ExchangeRatePriceDetermination);

		childObj.DateforPricingExchangeRate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.DateforPricingExchangeRate);

		childObj.PricingProcedureInPricing = 'X';
		System.assertEquals('X', childObj.PricingProcedureInPricing);

		childObj.PricingProcedureInPricingDesc = 'X';
		System.assertEquals('X', childObj.PricingProcedureInPricingDesc);

		childObj.CustomerGroup = 'X';
		System.assertEquals('X', childObj.CustomerGroup);

		childObj.CustomerGroupName = 'X';
		System.assertEquals('X', childObj.CustomerGroupName);

		childObj.PriceListType = 'X';
		System.assertEquals('X', childObj.PriceListType);

		childObj.PriceListTypeText = 'X';
		System.assertEquals('X', childObj.PriceListTypeText);

		childObj.UsageIndicator = 'X';
		System.assertEquals('X', childObj.UsageIndicator);

		childObj.UsageIndicatorDescription = 'X';
		System.assertEquals('X', childObj.UsageIndicatorDescription);

		childObj.PriceGroup = 'X';
		System.assertEquals('X', childObj.PriceGroup);

		childObj.PriceGroupDescription = 'X';
		System.assertEquals('X', childObj.PriceGroupDescription);

		childObj.SalesDistrict = 'X';
		System.assertEquals('X', childObj.SalesDistrict);

		childObj.SalesDistrictName = 'X';
		System.assertEquals('X', childObj.SalesDistrictName);

		childObj.RequestedDeliveryDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.RequestedDeliveryDate);

		childObj.DeliveryBlock = 'X';
		System.assertEquals('X', childObj.DeliveryBlock);

		childObj.DeliveryBlockDescription = 'X';
		System.assertEquals('X', childObj.DeliveryBlockDescription);

		childObj.BillingBlock = 'X';
		System.assertEquals('X', childObj.BillingBlock);

		childObj.BillingBlockDescription = 'X';
		System.assertEquals('X', childObj.BillingBlockDescription);

		childObj.TermsofPaymentKey = 'X';
		System.assertEquals('X', childObj.TermsofPaymentKey);

		childObj.TermsofPaymentKeyDescription = 'X';
		System.assertEquals('X', childObj.TermsofPaymentKeyDescription);

		childObj.IncotermsPart1 = 'X';
		System.assertEquals('X', childObj.IncotermsPart1);

		childObj.IncotermsPart1Description = 'X';
		System.assertEquals('X', childObj.IncotermsPart1Description);

		childObj.IncotermsPart2 = 'X';
		System.assertEquals('X', childObj.IncotermsPart2);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testSHIPPING()
	{
		SBO_EnosixRO_Detail.SHIPPING childObj = new SBO_EnosixRO_Detail.SHIPPING();

		System.assertEquals(SBO_EnosixRO_Detail.SHIPPING.class,childObj.getType(),'getType() does not match object type.');
			childObj.ShipToParty = 'X';
		System.assertEquals('X', childObj.ShipToParty);

		childObj.ShipToPartyText = 'X';
		System.assertEquals('X', childObj.ShipToPartyText);

		childObj.UnloadingPoint = 'X';
		System.assertEquals('X', childObj.UnloadingPoint);

		childObj.ReceivingPoint = 'X';
		System.assertEquals('X', childObj.ReceivingPoint);

		childObj.DepartmentNumber = 'X';
		System.assertEquals('X', childObj.DepartmentNumber);

		childObj.DepartmentNumberDescription = 'X';
		System.assertEquals('X', childObj.DepartmentNumberDescription);

		childObj.DeliveryBlock = 'X';
		System.assertEquals('X', childObj.DeliveryBlock);

		childObj.DeliveryBlockDescription = 'X';
		System.assertEquals('X', childObj.DeliveryBlockDescription);

		childObj.ShippingConditions = 'X';
		System.assertEquals('X', childObj.ShippingConditions);

		childObj.ShippingConditionsDescription = 'X';
		System.assertEquals('X', childObj.ShippingConditionsDescription);

		childObj.DangerousGoodsMngmntProfile = 'X';
		System.assertEquals('X', childObj.DangerousGoodsMngmntProfile);

		childObj.DangerousGoodsMngmntProfDesc = 'X';
		System.assertEquals('X', childObj.DangerousGoodsMngmntProfDesc);

		childObj.MeansofTransportType = 'X';
		System.assertEquals('X', childObj.MeansofTransportType);

		childObj.MeansofTransportTypDescription = 'X';
		System.assertEquals('X', childObj.MeansofTransportTypDescription);

		childObj.MeansofTransport = 'X';
		System.assertEquals('X', childObj.MeansofTransport);

		childObj.MeansofTransportDescription = 'X';
		System.assertEquals('X', childObj.MeansofTransportDescription);

		childObj.RelevantforPODprocessing = 'X';
		System.assertEquals('X', childObj.RelevantforPODprocessing);

		childObj.CompleteDeliveryDefined = 'X';
		System.assertEquals('X', childObj.CompleteDeliveryDefined);

		childObj.OrderCombinationIndicator = 'X';
		System.assertEquals('X', childObj.OrderCombinationIndicator);

		childObj.DocumentContainsDangerousGoods = 'X';
		System.assertEquals('X', childObj.DocumentContainsDangerousGoods);

		childObj.ShippingType = 'X';
		System.assertEquals('X', childObj.ShippingType);

		childObj.ShippingTypeDescription = 'X';
		System.assertEquals('X', childObj.ShippingTypeDescription);

		childObj.SpecialProcessing = 'X';
		System.assertEquals('X', childObj.SpecialProcessing);

		childObj.SpecialProcessingDescription = 'X';
		System.assertEquals('X', childObj.SpecialProcessingDescription);

		childObj.TotalWeight = 1.5;
		System.assertEquals(1.5, childObj.TotalWeight);

		childObj.WeightUnit = 'X';
		System.assertEquals('X', childObj.WeightUnit);

		childObj.Netweight = 1.5;
		System.assertEquals(1.5, childObj.Netweight);

		childObj.Volume = 1.5;
		System.assertEquals(1.5, childObj.Volume);

		childObj.VolumeUnit = 'X';
		System.assertEquals('X', childObj.VolumeUnit);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testBILLING()
	{
		SBO_EnosixRO_Detail.BILLING childObj = new SBO_EnosixRO_Detail.BILLING();

		System.assertEquals(SBO_EnosixRO_Detail.BILLING.class,childObj.getType(),'getType() does not match object type.');
			childObj.Payer = 'X';
		System.assertEquals('X', childObj.Payer);

		childObj.PayerDisplayText = 'X';
		System.assertEquals('X', childObj.PayerDisplayText);

		childObj.IncotermsPart1 = 'X';
		System.assertEquals('X', childObj.IncotermsPart1);

		childObj.IncotermsPart1Description = 'X';
		System.assertEquals('X', childObj.IncotermsPart1Description);

		childObj.IncotermsPart2 = 'X';
		System.assertEquals('X', childObj.IncotermsPart2);

		childObj.FixedValueDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FixedValueDate);

		childObj.TermsofPaymentKey = 'X';
		System.assertEquals('X', childObj.TermsofPaymentKey);

		childObj.TermsofPaymentKeyDescription = 'X';
		System.assertEquals('X', childObj.TermsofPaymentKeyDescription);

		childObj.AdditionalValueDays = 'X';
		System.assertEquals('X', childObj.AdditionalValueDays);

		childObj.BillingBlock = 'X';
		System.assertEquals('X', childObj.BillingBlock);

		childObj.BillingBlockDescription = 'X';
		System.assertEquals('X', childObj.BillingBlockDescription);

		childObj.InvoiceDates = 'X';
		System.assertEquals('X', childObj.InvoiceDates);

		childObj.InvoiceDatesText = 'X';
		System.assertEquals('X', childObj.InvoiceDatesText);

		childObj.BillingDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.BillingDate);

		childObj.CompanyCodeToBeBilled = 'X';
		System.assertEquals('X', childObj.CompanyCodeToBeBilled);

		childObj.CompanyCodeToBeBilledText = 'X';
		System.assertEquals('X', childObj.CompanyCodeToBeBilledText);

		childObj.DateOnWhichServicesRendered = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.DateOnWhichServicesRendered);

		childObj.AlternativeTaxClassification = 'X';
		System.assertEquals('X', childObj.AlternativeTaxClassification);

		childObj.AltTaxClassificationDescription = 'X';
		System.assertEquals('X', childObj.AltTaxClassificationDescription);

		childObj.TaxDepartureCountry = 'X';
		System.assertEquals('X', childObj.TaxDepartureCountry);

		childObj.TaxDepartureCountryName = 'X';
		System.assertEquals('X', childObj.TaxDepartureCountryName);

		childObj.TaxDestinationCountry = 'X';
		System.assertEquals('X', childObj.TaxDestinationCountry);

		childObj.TaxDestinationCountryName = 'X';
		System.assertEquals('X', childObj.TaxDestinationCountryName);

		childObj.TriangularDeal = 'X';
		System.assertEquals('X', childObj.TriangularDeal);

		childObj.PaymentGuaranteeProcedure = 'X';
		System.assertEquals('X', childObj.PaymentGuaranteeProcedure);

		childObj.PaymentGuaranteeProcedureDesc = 'X';
		System.assertEquals('X', childObj.PaymentGuaranteeProcedureDesc);

		childObj.InternalfinancialDocNumber = 'X';
		System.assertEquals('X', childObj.InternalfinancialDocNumber);

		childObj.DepreciationPercentage = 1.5;
		System.assertEquals(1.5, childObj.DepreciationPercentage);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testACCOUNTING()
	{
		SBO_EnosixRO_Detail.ACCOUNTING childObj = new SBO_EnosixRO_Detail.ACCOUNTING();

		System.assertEquals(SBO_EnosixRO_Detail.ACCOUNTING.class,childObj.getType(),'getType() does not match object type.');
			childObj.AccountAssignmentGroup = 'X';
		System.assertEquals('X', childObj.AccountAssignmentGroup);

		childObj.AccountAssignmentGroupDesc = 'X';
		System.assertEquals('X', childObj.AccountAssignmentGroupDesc);

		childObj.PaymentMethod = 'X';
		System.assertEquals('X', childObj.PaymentMethod);

		childObj.PaymentMethodDescription = 'X';
		System.assertEquals('X', childObj.PaymentMethodDescription);

		childObj.PostingPeriod = 'X';
		System.assertEquals('X', childObj.PostingPeriod);

		childObj.FiscalYear = 'X';
		System.assertEquals('X', childObj.FiscalYear);

		childObj.AssignmentNumber = 'X';
		System.assertEquals('X', childObj.AssignmentNumber);

		childObj.ExchangeRateforFIpostings = 1.5;
		System.assertEquals(1.5, childObj.ExchangeRateforFIpostings);

		childObj.DunningKey = 'X';
		System.assertEquals('X', childObj.DunningKey);

		childObj.DunningKeyText = 'X';
		System.assertEquals('X', childObj.DunningKeyText);

		childObj.DunningBlock = 'X';
		System.assertEquals('X', childObj.DunningBlock);

		childObj.DunningBlockText = 'X';
		System.assertEquals('X', childObj.DunningBlockText);

		childObj.ReferenceDocumentNumber = 'X';
		System.assertEquals('X', childObj.ReferenceDocumentNumber);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testCONDITIONS()
	{
		SBO_EnosixRO_Detail.CONDITIONS childObj = new SBO_EnosixRO_Detail.CONDITIONS();

		System.assertEquals(SBO_EnosixRO_Detail.CONDITIONS.class,childObj.getType(),'getType() does not match object type.');
			childObj.ConditionNumber = 'X';
		System.assertEquals('X', childObj.ConditionNumber);

		childObj.ConditionItemNumber = 'X';
		System.assertEquals('X', childObj.ConditionItemNumber);

		childObj.StepNumber = 'X';
		System.assertEquals('X', childObj.StepNumber);

		childObj.ConditionCounter = 'X';
		System.assertEquals('X', childObj.ConditionCounter);

		childObj.ConditionType = 'X';
		System.assertEquals('X', childObj.ConditionType);

		childObj.ConditionTypeName = 'X';
		System.assertEquals('X', childObj.ConditionTypeName);

		childObj.Rate = 1.5;
		System.assertEquals(1.5, childObj.Rate);

		childObj.RateUnit = 'X';
		System.assertEquals('X', childObj.RateUnit);

		childObj.ConditionPricingUnit = 1.5;
		System.assertEquals(1.5, childObj.ConditionPricingUnit);

		childObj.ConditionUnit = 'X';
		System.assertEquals('X', childObj.ConditionUnit);

		childObj.ConditionValue = 1.5;
		System.assertEquals(1.5, childObj.ConditionValue);

		childObj.CurrencyKey = 'X';
		System.assertEquals('X', childObj.CurrencyKey);

		childObj.CondValueforCumulationFields = 1.5;
		System.assertEquals(1.5, childObj.CondValueforCumulationFields);

		childObj.CondCurrencyforCumulationFlds = 'X';
		System.assertEquals('X', childObj.CondCurrencyforCumulationFlds);

		childObj.ConditionStatistics = 'X';
		System.assertEquals('X', childObj.ConditionStatistics);

		childObj.KRECH = 'X';
		System.assertEquals('X', childObj.KRECH);

		childObj.KMANU = 'X';
		System.assertEquals('X', childObj.KMANU);

List<string> keyFields = new List<string>{ 'KPOSN','STUNR','ZAEHK','KSCHL' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testACCOUNT_ASSIGNMENT()
	{
		SBO_EnosixRO_Detail.ACCOUNT_ASSIGNMENT childObj = new SBO_EnosixRO_Detail.ACCOUNT_ASSIGNMENT();

		System.assertEquals(SBO_EnosixRO_Detail.ACCOUNT_ASSIGNMENT.class,childObj.getType(),'getType() does not match object type.');
			childObj.BusinessArea = 'X';
		System.assertEquals('X', childObj.BusinessArea);

		childObj.WBSElementInternal = 'X';
		System.assertEquals('X', childObj.WBSElementInternal);

		childObj.WBSElement = 'X';
		System.assertEquals('X', childObj.WBSElement);

		childObj.WBSElementDescription = 'X';
		System.assertEquals('X', childObj.WBSElementDescription);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testPARTNERS()
	{
		SBO_EnosixRO_Detail.PARTNERS childObj = new SBO_EnosixRO_Detail.PARTNERS();

		System.assertEquals(SBO_EnosixRO_Detail.PARTNERS.class,childObj.getType(),'getType() does not match object type.');
			childObj.PartnerFunction = 'X';
		System.assertEquals('X', childObj.PartnerFunction);

		childObj.PartnerFunctionName = 'X';
		System.assertEquals('X', childObj.PartnerFunctionName);

		childObj.CustomerNumber = 'X';
		System.assertEquals('X', childObj.CustomerNumber);

		childObj.Vendor = 'X';
		System.assertEquals('X', childObj.Vendor);

		childObj.PersonnelNumber = 'X';
		System.assertEquals('X', childObj.PersonnelNumber);

		childObj.ContactPersonNumber = 'X';
		System.assertEquals('X', childObj.ContactPersonNumber);

		childObj.PartnerName = 'X';
		System.assertEquals('X', childObj.PartnerName);

		childObj.PartnerName2 = 'X';
		System.assertEquals('X', childObj.PartnerName2);

		childObj.HouseNumber = 'X';
		System.assertEquals('X', childObj.HouseNumber);

		childObj.Street = 'X';
		System.assertEquals('X', childObj.Street);

		childObj.City = 'X';
		System.assertEquals('X', childObj.City);

		childObj.PostalCode = 'X';
		System.assertEquals('X', childObj.PostalCode);

		childObj.Region = 'X';
		System.assertEquals('X', childObj.Region);

		childObj.RegionDescription = 'X';
		System.assertEquals('X', childObj.RegionDescription);

		childObj.Country = 'X';
		System.assertEquals('X', childObj.Country);

		childObj.CountryName = 'X';
		System.assertEquals('X', childObj.CountryName);

		childObj.TimeZone = 'X';
		System.assertEquals('X', childObj.TimeZone);

		childObj.TimeZoneText = 'X';
		System.assertEquals('X', childObj.TimeZoneText);

		childObj.TransportationZone = 'X';
		System.assertEquals('X', childObj.TransportationZone);

		childObj.TransportationZoneDescription = 'X';
		System.assertEquals('X', childObj.TransportationZoneDescription);

		childObj.POBox = 'X';
		System.assertEquals('X', childObj.POBox);

		childObj.POBoxPostalCode = 'X';
		System.assertEquals('X', childObj.POBoxPostalCode);

		childObj.CompanyPostalCode = 'X';
		System.assertEquals('X', childObj.CompanyPostalCode);

		childObj.Language = 'X';
		System.assertEquals('X', childObj.Language);

		childObj.LanguageDesc = 'X';
		System.assertEquals('X', childObj.LanguageDesc);

		childObj.TelephoneNumber = 'X';
		System.assertEquals('X', childObj.TelephoneNumber);

		childObj.TelephoneNumberExtension = 'X';
		System.assertEquals('X', childObj.TelephoneNumberExtension);

		childObj.MobileNumber = 'X';
		System.assertEquals('X', childObj.MobileNumber);

		childObj.FaxNumber = 'X';
		System.assertEquals('X', childObj.FaxNumber);

		childObj.FaxNumberExtension = 'X';
		System.assertEquals('X', childObj.FaxNumberExtension);

		childObj.EMailAddress = 'X';
		System.assertEquals('X', childObj.EMailAddress);

		childObj.DefaultCommunicationMethod = 'X';
		System.assertEquals('X', childObj.DefaultCommunicationMethod);

		childObj.DefaultCommunicationMethodDescription = 'X';
		System.assertEquals('X', childObj.DefaultCommunicationMethodDescription);

		childObj.Extension1 = 'X';
		System.assertEquals('X', childObj.Extension1);

		childObj.Extension2 = 'X';
		System.assertEquals('X', childObj.Extension2);

		childObj.AddressNotes = 'X';
		System.assertEquals('X', childObj.AddressNotes);

List<string> keyFields = new List<string>{ 'PARVW','KUNNR','LIFNR','PERNR','PARNR' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testTEXTS()
	{
		SBO_EnosixRO_Detail.TEXTS childObj = new SBO_EnosixRO_Detail.TEXTS();

		System.assertEquals(SBO_EnosixRO_Detail.TEXTS.class,childObj.getType(),'getType() does not match object type.');
			childObj.TextID = 'X';
		System.assertEquals('X', childObj.TextID);

		childObj.TextLanguage = 'X';
		System.assertEquals('X', childObj.TextLanguage);

		childObj.TextIDDescription = 'X';
		System.assertEquals('X', childObj.TextIDDescription);

		childObj.Text = 'X';
		System.assertEquals('X', childObj.Text);

List<string> keyFields = new List<string>{ 'TDID','TDSPRAS' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testORDERDATA()
	{
		SBO_EnosixRO_Detail.ORDERDATA childObj = new SBO_EnosixRO_Detail.ORDERDATA();

		System.assertEquals(SBO_EnosixRO_Detail.ORDERDATA.class,childObj.getType(),'getType() does not match object type.');
			childObj.CustomerPurchaseOrderNumber = 'X';
		System.assertEquals('X', childObj.CustomerPurchaseOrderNumber);

		childObj.CustomerPurchaseOrderDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CustomerPurchaseOrderDate);

		childObj.CustomerPurchaseOrderType = 'X';
		System.assertEquals('X', childObj.CustomerPurchaseOrderType);

		childObj.PurchaseOrderNumberSupplement = 'X';
		System.assertEquals('X', childObj.PurchaseOrderNumberSupplement);

		childObj.LastCustomerContactDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.LastCustomerContactDate);

		childObj.NumberOfContactsFromCustomer = 1.5;
		System.assertEquals(1.5, childObj.NumberOfContactsFromCustomer);

		childObj.OrdererName = 'X';
		System.assertEquals('X', childObj.OrdererName);

		childObj.CollectiveNumber = 'X';
		System.assertEquals('X', childObj.CollectiveNumber);

		childObj.YourReference = 'X';
		System.assertEquals('X', childObj.YourReference);

		childObj.TelephoneNumber = 'X';
		System.assertEquals('X', childObj.TelephoneNumber);

		childObj.ShipToPurchaseOrderNumber = 'X';
		System.assertEquals('X', childObj.ShipToPurchaseOrderNumber);

		childObj.ShipToPODate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ShipToPODate);

		childObj.ShipToPurchaseOrderType = 'X';
		System.assertEquals('X', childObj.ShipToPurchaseOrderType);

		childObj.ShipToCharacter = 'X';
		System.assertEquals('X', childObj.ShipToCharacter);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testSTATUS()
	{
		SBO_EnosixRO_Detail.STATUS childObj = new SBO_EnosixRO_Detail.STATUS();

		System.assertEquals(SBO_EnosixRO_Detail.STATUS.class,childObj.getType(),'getType() does not match object type.');
			childObj.OverallStatusDescription = 'X';
		System.assertEquals('X', childObj.OverallStatusDescription);

		childObj.RejectionStatusDescription = 'X';
		System.assertEquals('X', childObj.RejectionStatusDescription);

		childObj.DeliveryStatusDescription = 'X';
		System.assertEquals('X', childObj.DeliveryStatusDescription);

		childObj.CreditStatusDescription = 'X';
		System.assertEquals('X', childObj.CreditStatusDescription);

		childObj.OveralBlockedStatusDescription = 'X';
		System.assertEquals('X', childObj.OveralBlockedStatusDescription);

		childObj.DataCompleteDescription = 'X';
		System.assertEquals('X', childObj.DataCompleteDescription);

		childObj.HeaderDeliveryDataCompleteDesc = 'X';
		System.assertEquals('X', childObj.HeaderDeliveryDataCompleteDesc);

		childObj.HeaderBillingCompleteDesc = 'X';
		System.assertEquals('X', childObj.HeaderBillingCompleteDesc);

		childObj.ItemDataCompleteDesc = 'X';
		System.assertEquals('X', childObj.ItemDataCompleteDesc);

		childObj.ItemDeliveryDataCompleteDesc = 'X';
		System.assertEquals('X', childObj.ItemDeliveryDataCompleteDesc);

		childObj.ItemBillingDataCompleteDesc = 'X';
		System.assertEquals('X', childObj.ItemBillingDataCompleteDesc);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testADDITIONAL_DATA_A()
	{
		SBO_EnosixRO_Detail.ADDITIONAL_DATA_A childObj = new SBO_EnosixRO_Detail.ADDITIONAL_DATA_A();

		System.assertEquals(SBO_EnosixRO_Detail.ADDITIONAL_DATA_A.class,childObj.getType(),'getType() does not match object type.');
			childObj.CustomerGroup1 = 'X';
		System.assertEquals('X', childObj.CustomerGroup1);

		childObj.CustomerGroup1Description = 'X';
		System.assertEquals('X', childObj.CustomerGroup1Description);

		childObj.CustomerGroup2 = 'X';
		System.assertEquals('X', childObj.CustomerGroup2);

		childObj.CustomerGroup2Description = 'X';
		System.assertEquals('X', childObj.CustomerGroup2Description);

		childObj.CustomerGroup3 = 'X';
		System.assertEquals('X', childObj.CustomerGroup3);

		childObj.CustomerGroup3Description = 'X';
		System.assertEquals('X', childObj.CustomerGroup3Description);

		childObj.CustomerGroup4 = 'X';
		System.assertEquals('X', childObj.CustomerGroup4);

		childObj.CustomerGroup4Description = 'X';
		System.assertEquals('X', childObj.CustomerGroup4Description);

		childObj.CustomerGroup5 = 'X';
		System.assertEquals('X', childObj.CustomerGroup5);

		childObj.CustomerGroup5Description = 'X';
		System.assertEquals('X', childObj.CustomerGroup5Description);

		childObj.CustomerConditionGroup1 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup1);

		childObj.CustomerConditionGroup1Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup1Description);

		childObj.CustomerConditionGroup2 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup2);

		childObj.CustomerConditionGroup2Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup2Description);

		childObj.CustomerConditionGroup3 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup3);

		childObj.CustomerConditionGroup3Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup3Description);

		childObj.CustomerConditionGroup4 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup4);

		childObj.CustomerConditionGroup4Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup4Description);

		childObj.CustomerConditionGroup5 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup5);

		childObj.CustomerConditionGroup5Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup5Description);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testITEMS()
	{
		SBO_EnosixRO_Detail.ITEMS childObj = new SBO_EnosixRO_Detail.ITEMS();

		System.assertEquals(SBO_EnosixRO_Detail.ITEMS.class,childObj.getType(),'getType() does not match object type.');
			childObj.ItemNumber = 'X';
		System.assertEquals('X', childObj.ItemNumber);

		childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.OrderQuantity = 1.5;
		System.assertEquals(1.5, childObj.OrderQuantity);

		childObj.SalesUnit = 'X';
		System.assertEquals('X', childObj.SalesUnit);

		childObj.SalesUnitDescription = 'X';
		System.assertEquals('X', childObj.SalesUnitDescription);

		childObj.ItemDescription = 'X';
		System.assertEquals('X', childObj.ItemDescription);

		childObj.CustomerMaterialNumber = 'X';
		System.assertEquals('X', childObj.CustomerMaterialNumber);

		childObj.ItemCategory = 'X';
		System.assertEquals('X', childObj.ItemCategory);

		childObj.ItemCategoryDescription = 'X';
		System.assertEquals('X', childObj.ItemCategoryDescription);

		childObj.DangerousGoodsIndicator = 'X';
		System.assertEquals('X', childObj.DangerousGoodsIndicator);

		childObj.HigherLevelItemNumber = 'X';
		System.assertEquals('X', childObj.HigherLevelItemNumber);

		childObj.ScheduleLineDate = 'X';
		System.assertEquals('X', childObj.ScheduleLineDate);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.PlantName = 'X';
		System.assertEquals('X', childObj.PlantName);

		childObj.BatchNumber = 'X';
		System.assertEquals('X', childObj.BatchNumber);

		childObj.ConditionType = 'X';
		System.assertEquals('X', childObj.ConditionType);

		childObj.Rate = 1.5;
		System.assertEquals(1.5, childObj.Rate);

		childObj.RateUnit = 'X';
		System.assertEquals('X', childObj.RateUnit);

		childObj.NetItemPrice = 1.5;
		System.assertEquals(1.5, childObj.NetItemPrice);

		childObj.ConditionPricingUnit = 1.5;
		System.assertEquals(1.5, childObj.ConditionPricingUnit);

		childObj.ConditionUnit = 'X';
		System.assertEquals('X', childObj.ConditionUnit);

		childObj.ConditionUnitDescription = 'X';
		System.assertEquals('X', childObj.ConditionUnitDescription);

		childObj.NetTotalValue = 1.5;
		System.assertEquals(1.5, childObj.NetTotalValue);

		childObj.SalesDocumentCurrency = 'X';
		System.assertEquals('X', childObj.SalesDocumentCurrency);

		childObj.ConditionScaleQuantity = 1.5;
		System.assertEquals(1.5, childObj.ConditionScaleQuantity);

		childObj.ReasonForRejection = 'X';
		System.assertEquals('X', childObj.ReasonForRejection);

		childObj.CustomerPurchaseOrderNumber = 'X';
		System.assertEquals('X', childObj.CustomerPurchaseOrderNumber);

		childObj.CustomerPurchaseOrderItemNumber = 'X';
		System.assertEquals('X', childObj.CustomerPurchaseOrderItemNumber);

		childObj.DeliveryBlockStatus = 'X';
		System.assertEquals('X', childObj.DeliveryBlockStatus);

		childObj.DeliveryBlockStatusDescription = 'X';
		System.assertEquals('X', childObj.DeliveryBlockStatusDescription);

		childObj.BillingBlockStatus = 'X';
		System.assertEquals('X', childObj.BillingBlockStatus);

		childObj.BillingBlockStatusDescription = 'X';
		System.assertEquals('X', childObj.BillingBlockStatusDescription);

		childObj.AgreedDeliveryTime = 'X';
		System.assertEquals('X', childObj.AgreedDeliveryTime);

		childObj.AgreedDeliveryTimeDescription = 'X';
		System.assertEquals('X', childObj.AgreedDeliveryTimeDescription);

		childObj.Materialgroup1 = 'X';
		System.assertEquals('X', childObj.Materialgroup1);

		childObj.Materialgroup1Description = 'X';
		System.assertEquals('X', childObj.Materialgroup1Description);

		childObj.Materialgroup2 = 'X';
		System.assertEquals('X', childObj.Materialgroup2);

		childObj.Materialgroup2Description = 'X';
		System.assertEquals('X', childObj.Materialgroup2Description);

		childObj.Materialgroup3 = 'X';
		System.assertEquals('X', childObj.Materialgroup3);

		childObj.Materialgroup3Description = 'X';
		System.assertEquals('X', childObj.Materialgroup3Description);

		childObj.Materialgroup4 = 'X';
		System.assertEquals('X', childObj.Materialgroup4);

		childObj.Materialgroup4Description = 'X';
		System.assertEquals('X', childObj.Materialgroup4Description);

		childObj.Materialgroup5 = 'X';
		System.assertEquals('X', childObj.Materialgroup5);

		childObj.Materialgroup5Description = 'X';
		System.assertEquals('X', childObj.Materialgroup5Description);

		childObj.CustomerConditionGroup1 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup1);

		childObj.CustomerConditionGroup1Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup1Description);

		childObj.CustomerConditionGroup2 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup2);

		childObj.CustomerConditionGroup2Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup2Description);

		childObj.CustomerConditionGroup3 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup3);

		childObj.CustomerConditionGroup3Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup3Description);

		childObj.CustomerConditionGroup4 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup4);

		childObj.CustomerConditionGroup4Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup4Description);

		childObj.CustomerConditionGroup5 = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup5);

		childObj.CustomerConditionGroup5Description = 'X';
		System.assertEquals('X', childObj.CustomerConditionGroup5Description);

		childObj.ProductHierarchyDescription = 'X';
		System.assertEquals('X', childObj.ProductHierarchyDescription);

		childObj.MaterialGroupHierarchy1 = 'X';
		System.assertEquals('X', childObj.MaterialGroupHierarchy1);

		childObj.MaterialGroupHierarchy2 = 'X';
		System.assertEquals('X', childObj.MaterialGroupHierarchy2);

		childObj.Division = 'X';
		System.assertEquals('X', childObj.Division);

		childObj.DivisionName = 'X';
		System.assertEquals('X', childObj.DivisionName);

		childObj.WBSElementInternal = 'X';
		System.assertEquals('X', childObj.WBSElementInternal);

		childObj.WBSElement = 'X';
		System.assertEquals('X', childObj.WBSElement);

		childObj.WBSElementDescription = 'X';
		System.assertEquals('X', childObj.WBSElementDescription);

		childObj.OrderNumber = 'X';
		System.assertEquals('X', childObj.OrderNumber);

		childObj.ProfitCenter = 'X';
		System.assertEquals('X', childObj.ProfitCenter);

		childObj.MaterialPricingGroup = 'X';
		System.assertEquals('X', childObj.MaterialPricingGroup);

		childObj.MaterialPricingGroupDescription = 'X';
		System.assertEquals('X', childObj.MaterialPricingGroupDescription);

		childObj.CustomerGroup = 'X';
		System.assertEquals('X', childObj.CustomerGroup);

		childObj.CustomerGroupName = 'X';
		System.assertEquals('X', childObj.CustomerGroupName);

		childObj.PriceGroup = 'X';
		System.assertEquals('X', childObj.PriceGroup);

		childObj.PriceGroupDescription = 'X';
		System.assertEquals('X', childObj.PriceGroupDescription);

		childObj.PriceListType = 'X';
		System.assertEquals('X', childObj.PriceListType);

		childObj.PriceListTypeText = 'X';
		System.assertEquals('X', childObj.PriceListTypeText);

		childObj.SalesDistrict = 'X';
		System.assertEquals('X', childObj.SalesDistrict);

		childObj.SalesDistrictName = 'X';
		System.assertEquals('X', childObj.SalesDistrictName);

		childObj.CustomerPurchaseOrderDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CustomerPurchaseOrderDate);

		childObj.CustomerPurchaseOrderType = 'X';
		System.assertEquals('X', childObj.CustomerPurchaseOrderType);

		childObj.CustomerPurchaseOrderTypeDesc = 'X';
		System.assertEquals('X', childObj.CustomerPurchaseOrderTypeDesc);

		childObj.ShipToPurchaseOrderNumber = 'X';
		System.assertEquals('X', childObj.ShipToPurchaseOrderNumber);

		childObj.ShipToPODate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ShipToPODate);

		childObj.ShipToPurchaseOrderType = 'X';
		System.assertEquals('X', childObj.ShipToPurchaseOrderType);

		childObj.ShipToPurchaseOrderTypeDesc = 'X';
		System.assertEquals('X', childObj.ShipToPurchaseOrderTypeDesc);

		childObj.ShipToPurchaseOrderItemNumber = 'X';
		System.assertEquals('X', childObj.ShipToPurchaseOrderItemNumber);

		childObj.StorageLocation = 'X';
		System.assertEquals('X', childObj.StorageLocation);

		childObj.StorageLocationDescription = 'X';
		System.assertEquals('X', childObj.StorageLocationDescription);

		childObj.DeliveryPriority = 'X';
		System.assertEquals('X', childObj.DeliveryPriority);

		childObj.DeliveryPriorityDescription = 'X';
		System.assertEquals('X', childObj.DeliveryPriorityDescription);

		childObj.ShippingPoint = 'X';
		System.assertEquals('X', childObj.ShippingPoint);

		childObj.ShippingPointDescription = 'X';
		System.assertEquals('X', childObj.ShippingPointDescription);

		childObj.PartialDelivery = 'X';
		System.assertEquals('X', childObj.PartialDelivery);

		childObj.PartialDeliveryDescription = 'X';
		System.assertEquals('X', childObj.PartialDeliveryDescription);

		childObj.Route = 'X';
		System.assertEquals('X', childObj.Route);

		childObj.RouteDescription = 'X';
		System.assertEquals('X', childObj.RouteDescription);

		childObj.Netweight = 1.5;
		System.assertEquals(1.5, childObj.Netweight);

		childObj.WeightUnit = 'X';
		System.assertEquals('X', childObj.WeightUnit);

		childObj.GrossWeight = 1.5;
		System.assertEquals(1.5, childObj.GrossWeight);

		childObj.Volume = 1.5;
		System.assertEquals(1.5, childObj.Volume);

		childObj.VolumeUnit = 'X';
		System.assertEquals('X', childObj.VolumeUnit);

		childObj.IncotermsPart1 = 'X';
		System.assertEquals('X', childObj.IncotermsPart1);

		childObj.IncotermsPart1Description = 'X';
		System.assertEquals('X', childObj.IncotermsPart1Description);

		childObj.IncotermsPart2 = 'X';
		System.assertEquals('X', childObj.IncotermsPart2);

		childObj.TermsofPaymentKey = 'X';
		System.assertEquals('X', childObj.TermsofPaymentKey);

		childObj.TermsofPaymentKeyDescription = 'X';
		System.assertEquals('X', childObj.TermsofPaymentKeyDescription);

		childObj.BillingBlock = 'X';
		System.assertEquals('X', childObj.BillingBlock);

		childObj.BillingBlockDescription = 'X';
		System.assertEquals('X', childObj.BillingBlockDescription);

		childObj.BillingRelevant = 'X';
		System.assertEquals('X', childObj.BillingRelevant);

		childObj.BillingRelevantDescription = 'X';
		System.assertEquals('X', childObj.BillingRelevantDescription);

		childObj.BillingPlanInHeaderIndicator = 'X';
		System.assertEquals('X', childObj.BillingPlanInHeaderIndicator);

		childObj.OverallStatusDescription = 'X';
		System.assertEquals('X', childObj.OverallStatusDescription);

		childObj.DataCompleteDescription = 'X';
		System.assertEquals('X', childObj.DataCompleteDescription);

		childObj.ExchangeRatePriceDetermination = 1.5;
		System.assertEquals(1.5, childObj.ExchangeRatePriceDetermination);

		childObj.DateforPricingExchangeRate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.DateforPricingExchangeRate);

		childObj.MaterialEntered = 'X';
		System.assertEquals('X', childObj.MaterialEntered);

		childObj.UsageIndicator = 'X';
		System.assertEquals('X', childObj.UsageIndicator);

		childObj.UsageIndicatorDescription = 'X';
		System.assertEquals('X', childObj.UsageIndicatorDescription);

		childObj.PricingReferenceMaterial = 'X';
		System.assertEquals('X', childObj.PricingReferenceMaterial);

		childObj.CostingSheet = 'X';
		System.assertEquals('X', childObj.CostingSheet);

		childObj.CostingSheetDescription = 'X';
		System.assertEquals('X', childObj.CostingSheetDescription);

		childObj.Overheadkey = 'X';
		System.assertEquals('X', childObj.Overheadkey);

		childObj.ReceivingPoint = 'X';
		System.assertEquals('X', childObj.ReceivingPoint);

		childObj.DepartmentNumber = 'X';
		System.assertEquals('X', childObj.DepartmentNumber);

		childObj.DepartmentNumberDescription = 'X';
		System.assertEquals('X', childObj.DepartmentNumberDescription);

		childObj.MaxNumberOfPartialDeliveriesAllowed = 1.5;
		System.assertEquals(1.5, childObj.MaxNumberOfPartialDeliveriesAllowed);

		childObj.OverdeliveryToleranceLimit = 1.5;
		System.assertEquals(1.5, childObj.OverdeliveryToleranceLimit);

		childObj.UnderdeliveryToleranceLimit = 1.5;
		System.assertEquals(1.5, childObj.UnderdeliveryToleranceLimit);

		childObj.FixedValueDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FixedValueDate);

		childObj.AdditionalValueDays = 'X';
		System.assertEquals('X', childObj.AdditionalValueDays);

		childObj.InvoiceDates = 'X';
		System.assertEquals('X', childObj.InvoiceDates);

		childObj.InvoiceDatesText = 'X';
		System.assertEquals('X', childObj.InvoiceDatesText);

		childObj.BillingDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.BillingDate);

		childObj.DateOnWhichServicesRendered = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.DateOnWhichServicesRendered);

		childObj.AccountAssignmentGroup = 'X';
		System.assertEquals('X', childObj.AccountAssignmentGroup);

		childObj.AccountAssignmentGroupDescription = 'X';
		System.assertEquals('X', childObj.AccountAssignmentGroupDescription);

		childObj.ComponentQuantity = 1.5;
		System.assertEquals(1.5, childObj.ComponentQuantity);

		childObj.QuantityUOM = 'X';
		System.assertEquals('X', childObj.QuantityUOM);

		childObj.IUIDRelevant = 'X';
		System.assertEquals('X', childObj.IUIDRelevant);

		childObj.DeliveryBlock = 'X';
		System.assertEquals('X', childObj.DeliveryBlock);

		childObj.DeliveryBlockDescription = 'X';
		System.assertEquals('X', childObj.DeliveryBlockDescription);

List<string> keyFields = new List<string>{ 'POSNR' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testITEMS_SCHEDULE()
	{
		SBO_EnosixRO_Detail.ITEMS_SCHEDULE childObj = new SBO_EnosixRO_Detail.ITEMS_SCHEDULE();

		System.assertEquals(SBO_EnosixRO_Detail.ITEMS_SCHEDULE.class,childObj.getType(),'getType() does not match object type.');
			childObj.ItemNumber = 'X';
		System.assertEquals('X', childObj.ItemNumber);

		childObj.ScheduleLineNumber = 'X';
		System.assertEquals('X', childObj.ScheduleLineNumber);

		childObj.ScheduleLineDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ScheduleLineDate);

		childObj.OrderQuantity = 1.5;
		System.assertEquals(1.5, childObj.OrderQuantity);

		childObj.RoundedQuantity = 1.5;
		System.assertEquals(1.5, childObj.RoundedQuantity);

		childObj.ConfirmedQuantity = 1.5;
		System.assertEquals(1.5, childObj.ConfirmedQuantity);

		childObj.SalesUnit = 'X';
		System.assertEquals('X', childObj.SalesUnit);

		childObj.DeliveryBlock = 'X';
		System.assertEquals('X', childObj.DeliveryBlock);

		childObj.DeliveryBlockDescription = 'X';
		System.assertEquals('X', childObj.DeliveryBlockDescription);

		childObj.DeliveredQuantity = 1.5;
		System.assertEquals(1.5, childObj.DeliveredQuantity);

		childObj.ScheduleLineCategory = 'X';
		System.assertEquals('X', childObj.ScheduleLineCategory);

		childObj.ScheduleLineCategoryDescription = 'X';
		System.assertEquals('X', childObj.ScheduleLineCategoryDescription);

		childObj.PurchaseRequisitionNumber = 'X';
		System.assertEquals('X', childObj.PurchaseRequisitionNumber);

		childObj.PurchaseRequisitionItemNumber = 'X';
		System.assertEquals('X', childObj.PurchaseRequisitionItemNumber);

List<string> keyFields = new List<string>{ 'POSNR','ETENR' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testITEMS_ARM()
	{
		SBO_EnosixRO_Detail.ITEMS_ARM childObj = new SBO_EnosixRO_Detail.ITEMS_ARM();

		System.assertEquals(SBO_EnosixRO_Detail.ITEMS_ARM.class,childObj.getType(),'getType() does not match object type.');
			childObj.ProcessIDNumber = 'X';
		System.assertEquals('X', childObj.ProcessIDNumber);

		childObj.Item = 'X';
		System.assertEquals('X', childObj.Item);

		childObj.ExecutedStepID = 'X';
		System.assertEquals('X', childObj.ExecutedStepID);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.MaterialDescription = 'X';
		System.assertEquals('X', childObj.MaterialDescription);

		childObj.Quantity = 1.5;
		System.assertEquals(1.5, childObj.Quantity);

		childObj.UnitOfMeasure = 'X';
		System.assertEquals('X', childObj.UnitOfMeasure);

		childObj.ReplacementMaterial = 'X';
		System.assertEquals('X', childObj.ReplacementMaterial);

		childObj.ReplaceMaterialDescription = 'X';
		System.assertEquals('X', childObj.ReplaceMaterialDescription);

		childObj.ReplacementQuantity = 1.5;
		System.assertEquals(1.5, childObj.ReplacementQuantity);

		childObj.ReplacementUOM = 'X';
		System.assertEquals('X', childObj.ReplacementUOM);

		childObj.ReplacedQuantity = 1.5;
		System.assertEquals(1.5, childObj.ReplacedQuantity);

		childObj.ReplacedUOM = 'X';
		System.assertEquals('X', childObj.ReplacedUOM);

		childObj.ReturnReason = 'X';
		System.assertEquals('X', childObj.ReturnReason);

		childObj.ReturnReasonDescription = 'X';
		System.assertEquals('X', childObj.ReturnReasonDescription);

		childObj.InspectionCode = 'X';
		System.assertEquals('X', childObj.InspectionCode);

		childObj.InspectionCodeText = 'X';
		System.assertEquals('X', childObj.InspectionCodeText);

		childObj.CustomerRMA = 'X';
		System.assertEquals('X', childObj.CustomerRMA);

		childObj.RefundType = 'X';
		System.assertEquals('X', childObj.RefundType);

		childObj.RefundTypeDescription = 'X';
		System.assertEquals('X', childObj.RefundTypeDescription);

		childObj.RefundCode = 'X';
		System.assertEquals('X', childObj.RefundCode);

		childObj.RefundControl = 'X';
		System.assertEquals('X', childObj.RefundControl);

		childObj.ApprovalBlock = 'X';
		System.assertEquals('X', childObj.ApprovalBlock);

		childObj.CustomerInspectionCode = 'X';
		System.assertEquals('X', childObj.CustomerInspectionCode);

		childObj.ScheduleLineDate = 'X';
		System.assertEquals('X', childObj.ScheduleLineDate);

		childObj.CustomerInspectionCodeText = 'X';
		System.assertEquals('X', childObj.CustomerInspectionCodeText);

		childObj.PayingPlant = 'X';
		System.assertEquals('X', childObj.PayingPlant);

		childObj.InspectionAtCustomerSite = 'X';
		System.assertEquals('X', childObj.InspectionAtCustomerSite);

		childObj.MaterialReceived = 'X';
		System.assertEquals('X', childObj.MaterialReceived);

		childObj.CustomerInspectionText = 'X';
		System.assertEquals('X', childObj.CustomerInspectionText);

		childObj.InspectionText = 'X';
		System.assertEquals('X', childObj.InspectionText);

		childObj.ReturnMaterialNetPrice = 1.5;
		System.assertEquals(1.5, childObj.ReturnMaterialNetPrice);

		childObj.ReturnMaterialTax = 1.5;
		System.assertEquals(1.5, childObj.ReturnMaterialTax);

		childObj.ReplacementMaterialNetPrice = 1.5;
		System.assertEquals(1.5, childObj.ReplacementMaterialNetPrice);

		childObj.ReplacementMaterialTax = 1.5;
		System.assertEquals(1.5, childObj.ReplacementMaterialTax);

		childObj.PriceDifference = 1.5;
		System.assertEquals(1.5, childObj.PriceDifference);

		childObj.TaxDifference = 1.5;
		System.assertEquals(1.5, childObj.TaxDifference);

List<string> keyFields = new List<string>{ 'MSR_ID','ITEM' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testITEMS_TEXT()
	{
		SBO_EnosixRO_Detail.ITEMS_TEXT childObj = new SBO_EnosixRO_Detail.ITEMS_TEXT();

		System.assertEquals(SBO_EnosixRO_Detail.ITEMS_TEXT.class,childObj.getType(),'getType() does not match object type.');
			childObj.ItemNumber = 'X';
		System.assertEquals('X', childObj.ItemNumber);

		childObj.TextID = 'X';
		System.assertEquals('X', childObj.TextID);

		childObj.TextLanguage = 'X';
		System.assertEquals('X', childObj.TextLanguage);

		childObj.TextIDDescription = 'X';
		System.assertEquals('X', childObj.TextIDDescription);

		childObj.Text = 'X';
		System.assertEquals('X', childObj.Text);

List<string> keyFields = new List<string>{ 'POSNR','TDID','TDSPRAS' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testMATERIAL_UOM()
	{
		SBO_EnosixRO_Detail.MATERIAL_UOM childObj = new SBO_EnosixRO_Detail.MATERIAL_UOM();

		System.assertEquals(SBO_EnosixRO_Detail.MATERIAL_UOM.class,childObj.getType(),'getType() does not match object type.');
			childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.AlternateUnitOfMeasure = 'X';
		System.assertEquals('X', childObj.AlternateUnitOfMeasure);

List<string> keyFields = new List<string>{ 'MATNR','MEINH' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testCCARD()
	{
		SBO_EnosixRO_Detail.CCARD childObj = new SBO_EnosixRO_Detail.CCARD();

		System.assertEquals(SBO_EnosixRO_Detail.CCARD.class,childObj.getType(),'getType() does not match object type.');
			childObj.BillingPlan = 'X';
		System.assertEquals('X', childObj.BillingPlan);

		childObj.BillingPlanItem = 'X';
		System.assertEquals('X', childObj.BillingPlanItem);

		childObj.CreditCardType = 'X';
		System.assertEquals('X', childObj.CreditCardType);

		childObj.CreditCardNumber = 'X';
		System.assertEquals('X', childObj.CreditCardNumber);

		childObj.PaymentCardSuffix = 'X';
		System.assertEquals('X', childObj.PaymentCardSuffix);

		childObj.ValidToDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidToDate);

		childObj.CardholderName = 'X';
		System.assertEquals('X', childObj.CardholderName);

		childObj.BillAmount = 1.5;
		System.assertEquals(1.5, childObj.BillAmount);

		childObj.AuthorizedAmount = 1.5;
		System.assertEquals(1.5, childObj.AuthorizedAmount);

		childObj.OrderCurrency = 'X';
		System.assertEquals('X', childObj.OrderCurrency);

		childObj.AuthorizationDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.AuthorizationDate);

		childObj.AuthorizationTime = Time.newInstance(1,1,1,0);
		System.assertEquals(Time.newInstance(1,1,1,0), childObj.AuthorizationTime);

		childObj.AuthorizationNumber = 'X';
		System.assertEquals('X', childObj.AuthorizationNumber);

		childObj.Settlement = 'X';
		System.assertEquals('X', childObj.Settlement);

		childObj.ClearingHouseAuthCode = 'X';
		System.assertEquals('X', childObj.ClearingHouseAuthCode);

		childObj.AuthorizationCheckResponse = 'X';
		System.assertEquals('X', childObj.AuthorizationCheckResponse);

		childObj.StatusFromExternalSystem = 'X';
		System.assertEquals('X', childObj.StatusFromExternalSystem);

		childObj.Preauthorization = 'X';
		System.assertEquals('X', childObj.Preauthorization);

		childObj.AmountChanged = 'X';
		System.assertEquals('X', childObj.AmountChanged);

		childObj.AuthorizationType = 'X';
		System.assertEquals('X', childObj.AuthorizationType);

		childObj.BillingPlanAuthorization = 'X';
		System.assertEquals('X', childObj.BillingPlanAuthorization);

		childObj.ResultCode = 'X';
		System.assertEquals('X', childObj.ResultCode);

		childObj.ResultText = 'X';
		System.assertEquals('X', childObj.ResultText);

List<string> keyFields = new List<string>{ 'CC_TYPE','CC_NUMBER' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testITEMS_ACTION()
	{
		SBO_EnosixRO_Detail.ITEMS_ACTION childObj = new SBO_EnosixRO_Detail.ITEMS_ACTION();

		System.assertEquals(SBO_EnosixRO_Detail.ITEMS_ACTION.class,childObj.getType(),'getType() does not match object type.');
			childObj.ItemNumber = 'X';
		System.assertEquals('X', childObj.ItemNumber);

		childObj.ItemChanged = 'X';
		System.assertEquals('X', childObj.ItemChanged);

		childObj.ItemDeleted = 'X';
		System.assertEquals('X', childObj.ItemDeleted);

		childObj.ItemAdded = 'X';
		System.assertEquals('X', childObj.ItemAdded);

		childObj.PriceOverride = 'X';
		System.assertEquals('X', childObj.PriceOverride);

List<string> keyFields = new List<string>{ 'POSNR' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
}
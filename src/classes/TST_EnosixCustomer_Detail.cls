/// enosiX Inc. Generated Apex Model
/// Generated On: 4/28/17 1:45:59 PM
/// SAP Host: yeti-sfdc-api.enosix.com
/// CID: S4H

@isTest
public with sharing class TST_EnosixCustomer_Detail{
	@isTest
	static void testEnosixCustomer(){
		SBO_EnosixCustomer_Detail.EnosixCustomer sbo = new SBO_EnosixCustomer_Detail.EnosixCustomer();
		System.assertEquals(SBO_EnosixCustomer_Detail.EnosixCustomer.class, sbo.getType(), 'getType() does not match object type.');
				sbo.CustomerNumber = 'X';
		System.assertEquals('X', sbo.CustomerNumber);

		sbo.BPRole = 'X';
		System.assertEquals('X', sbo.BPRole);

		sbo.BPRoleDescription = 'X';
		System.assertEquals('X', sbo.BPRoleDescription);

		sbo.BusinessPartnerCategory = 'X';
		System.assertEquals('X', sbo.BusinessPartnerCategory);

		sbo.BusinessPartnerCategoryDescription = 'X';
		System.assertEquals('X', sbo.BusinessPartnerCategoryDescription);

		sbo.BusinessPartnerType = 'X';
		System.assertEquals('X', sbo.BusinessPartnerType);

		sbo.BusinessPartnerTypeDescription = 'X';
		System.assertEquals('X', sbo.BusinessPartnerTypeDescription);

		sbo.BusinessPartnerGrouping = 'X';
		System.assertEquals('X', sbo.BusinessPartnerGrouping);

		sbo.BusinessPartnerGroupingDesc = 'X';
		System.assertEquals('X', sbo.BusinessPartnerGroupingDesc);

		sbo.Title = 'X';
		System.assertEquals('X', sbo.Title);

		sbo.TitleName = 'X';
		System.assertEquals('X', sbo.TitleName);

		sbo.Name = 'X';
		System.assertEquals('X', sbo.Name);

		sbo.Name2 = 'X';
		System.assertEquals('X', sbo.Name2);

		sbo.SearchTerm1 = 'X';
		System.assertEquals('X', sbo.SearchTerm1);

		sbo.HouseNumber = 'X';
		System.assertEquals('X', sbo.HouseNumber);

		sbo.Street = 'X';
		System.assertEquals('X', sbo.Street);

		sbo.City = 'X';
		System.assertEquals('X', sbo.City);

		sbo.PostalCode = 'X';
		System.assertEquals('X', sbo.PostalCode);

		sbo.Region = 'X';
		System.assertEquals('X', sbo.Region);

		sbo.RegionDescription = 'X';
		System.assertEquals('X', sbo.RegionDescription);

		sbo.Country = 'X';
		System.assertEquals('X', sbo.Country);

		sbo.CountryName = 'X';
		System.assertEquals('X', sbo.CountryName);

		sbo.POBox = 'X';
		System.assertEquals('X', sbo.POBox);

		sbo.POBoxPostalCode = 'X';
		System.assertEquals('X', sbo.POBoxPostalCode);

		sbo.CompanyPostalCode = 'X';
		System.assertEquals('X', sbo.CompanyPostalCode);

		sbo.Language = 'X';
		System.assertEquals('X', sbo.Language);

		sbo.LanguageDesc = 'X';
		System.assertEquals('X', sbo.LanguageDesc);

		sbo.TelephoneNumber = 'X';
		System.assertEquals('X', sbo.TelephoneNumber);

		sbo.TelephoneNumberExtension = 'X';
		System.assertEquals('X', sbo.TelephoneNumberExtension);

		sbo.MobileNumber = 'X';
		System.assertEquals('X', sbo.MobileNumber);

		sbo.FaxNumber = 'X';
		System.assertEquals('X', sbo.FaxNumber);

		sbo.FaxNumberExtension = 'X';
		System.assertEquals('X', sbo.FaxNumberExtension);

		sbo.EMailAddress = 'X';
		System.assertEquals('X', sbo.EMailAddress);

		sbo.Attribute1 = 'X';
		System.assertEquals('X', sbo.Attribute1);

		sbo.Attribute1Description = 'X';
		System.assertEquals('X', sbo.Attribute1Description);

		//Test child collections
		System.assertNotEquals(null,sbo.COMPANY_DATA);
		System.assertNotEquals(null,sbo.SALES_DATA);
		System.assertNotEquals(null,sbo.PAYMENT_DATA);
		System.assertNotEquals(null,sbo.PARTNERS);
		System.assertNotEquals(null,sbo.CREDIT);
		System.assertNotEquals(null,sbo.USER_DEFINED);
	}

		@isTest
	static void testCOMPANY_DATA()
	{
		SBO_EnosixCustomer_Detail.COMPANY_DATA childObj = new SBO_EnosixCustomer_Detail.COMPANY_DATA();

		System.assertEquals(SBO_EnosixCustomer_Detail.COMPANY_DATA.class,childObj.getType(),'getType() does not match object type.');
			childObj.CompanyCode = 'X';
		System.assertEquals('X', childObj.CompanyCode);

		childObj.CompanyCodeDescription = 'X';
		System.assertEquals('X', childObj.CompanyCodeDescription);

		childObj.ReconciliationAccount = 'X';
		System.assertEquals('X', childObj.ReconciliationAccount);

		childObj.TermsofPaymentKey = 'X';
		System.assertEquals('X', childObj.TermsofPaymentKey);

		childObj.TermsOfPaymentDescription = 'X';
		System.assertEquals('X', childObj.TermsOfPaymentDescription);

List<string> keyFields = new List<string>{ 'BUKRS' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testSALES_DATA()
	{
		SBO_EnosixCustomer_Detail.SALES_DATA childObj = new SBO_EnosixCustomer_Detail.SALES_DATA();

		System.assertEquals(SBO_EnosixCustomer_Detail.SALES_DATA.class,childObj.getType(),'getType() does not match object type.');
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

		childObj.SalesDistrict = 'X';
		System.assertEquals('X', childObj.SalesDistrict);

		childObj.SalesDistrictName = 'X';
		System.assertEquals('X', childObj.SalesDistrictName);

		childObj.SalesOffice = 'X';
		System.assertEquals('X', childObj.SalesOffice);

		childObj.SalesOfficeName = 'X';
		System.assertEquals('X', childObj.SalesOfficeName);

		childObj.SalesGroup = 'X';
		System.assertEquals('X', childObj.SalesGroup);

		childObj.SalesGroupName = 'X';
		System.assertEquals('X', childObj.SalesGroupName);

		childObj.DeliveryPlant = 'X';
		System.assertEquals('X', childObj.DeliveryPlant);

		childObj.DeliveryPlantName = 'X';
		System.assertEquals('X', childObj.DeliveryPlantName);

		childObj.PriceGroup = 'X';
		System.assertEquals('X', childObj.PriceGroup);

		childObj.PriceGroupDescription = 'X';
		System.assertEquals('X', childObj.PriceGroupDescription);

		childObj.CustomerPricingProcedure = 'X';
		System.assertEquals('X', childObj.CustomerPricingProcedure);

		childObj.CustomerPricProcedureDesc = 'X';
		System.assertEquals('X', childObj.CustomerPricProcedureDesc);

		childObj.PriceListType = 'X';
		System.assertEquals('X', childObj.PriceListType);

		childObj.PriceListTypeDescription = 'X';
		System.assertEquals('X', childObj.PriceListTypeDescription);

		childObj.StatisticsGroup = 'X';
		System.assertEquals('X', childObj.StatisticsGroup);

		childObj.StatisticsGroupDescription = 'X';
		System.assertEquals('X', childObj.StatisticsGroupDescription);

		childObj.ShippingConditions = 'X';
		System.assertEquals('X', childObj.ShippingConditions);

		childObj.ShippingConditionDescription = 'X';
		System.assertEquals('X', childObj.ShippingConditionDescription);

		childObj.CompleteDeliveryDefined = 'X';
		System.assertEquals('X', childObj.CompleteDeliveryDefined);

		childObj.MaximumNoOfPartialDelivery = 'X';
		System.assertEquals('X', childObj.MaximumNoOfPartialDelivery);

		childObj.TermsofPaymentKey = 'X';
		System.assertEquals('X', childObj.TermsofPaymentKey);

		childObj.TermsOfPaymentDescription = 'X';
		System.assertEquals('X', childObj.TermsOfPaymentDescription);

		childObj.CurrencyKey = 'X';
		System.assertEquals('X', childObj.CurrencyKey);

		childObj.TaxClassification = 'X';
		System.assertEquals('X', childObj.TaxClassification);

		childObj.TaxClassificationDescription = 'X';
		System.assertEquals('X', childObj.TaxClassificationDescription);

		childObj.CustomerGroup1 = 'X';
		System.assertEquals('X', childObj.CustomerGroup1);

		childObj.CustomerGroup1Name = 'X';
		System.assertEquals('X', childObj.CustomerGroup1Name);

		childObj.CustomerBlock = 'X';
		System.assertEquals('X', childObj.CustomerBlock);

List<string> keyFields = new List<string>{ 'VKORG','VTWEG','SPART' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testPAYMENT_DATA()
	{
		SBO_EnosixCustomer_Detail.PAYMENT_DATA childObj = new SBO_EnosixCustomer_Detail.PAYMENT_DATA();

		System.assertEquals(SBO_EnosixCustomer_Detail.PAYMENT_DATA.class,childObj.getType(),'getType() does not match object type.');
			childObj.PaymentCardID = 'X';
		System.assertEquals('X', childObj.PaymentCardID);

		childObj.PaymentCardType = 'X';
		System.assertEquals('X', childObj.PaymentCardType);

		childObj.PaymentCardTypeDesc = 'X';
		System.assertEquals('X', childObj.PaymentCardTypeDesc);

		childObj.CardNumber = 'X';
		System.assertEquals('X', childObj.CardNumber);

		childObj.DefaultPaymentCard = 'X';
		System.assertEquals('X', childObj.DefaultPaymentCard);

		childObj.CreditCardName = 'X';
		System.assertEquals('X', childObj.CreditCardName);

		childObj.CardHolderName = 'X';
		System.assertEquals('X', childObj.CardHolderName);

		childObj.CardCategory = 'X';
		System.assertEquals('X', childObj.CardCategory);

		childObj.CardCategoryDescription = 'X';
		System.assertEquals('X', childObj.CardCategoryDescription);

		childObj.ValidFromDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidFromDate);

		childObj.ValidToDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidToDate);

		childObj.X_RemoveCard = 'X';
		System.assertEquals('X', childObj.X_RemoveCard);

List<string> keyFields = new List<string>{ 'CCARD_ID','CCINS','CCNUM' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testPARTNERS()
	{
		SBO_EnosixCustomer_Detail.PARTNERS childObj = new SBO_EnosixCustomer_Detail.PARTNERS();

		System.assertEquals(SBO_EnosixCustomer_Detail.PARTNERS.class,childObj.getType(),'getType() does not match object type.');
			childObj.SalesOrganization = 'X';
		System.assertEquals('X', childObj.SalesOrganization);

		childObj.DistributionChannel = 'X';
		System.assertEquals('X', childObj.DistributionChannel);

		childObj.Division = 'X';
		System.assertEquals('X', childObj.Division);

		childObj.PartnerFunction = 'X';
		System.assertEquals('X', childObj.PartnerFunction);

		childObj.PartnerFunctionName = 'X';
		System.assertEquals('X', childObj.PartnerFunctionName);

		childObj.PartnerNumber = 'X';
		System.assertEquals('X', childObj.PartnerNumber);

		childObj.PartnerName = 'X';
		System.assertEquals('X', childObj.PartnerName);

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

		childObj.Country = 'X';
		System.assertEquals('X', childObj.Country);

List<string> keyFields = new List<string>{ 'VKORG','VTWEG','SPART','PARVW' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testCREDIT()
	{
		SBO_EnosixCustomer_Detail.CREDIT childObj = new SBO_EnosixCustomer_Detail.CREDIT();

		System.assertEquals(SBO_EnosixCustomer_Detail.CREDIT.class,childObj.getType(),'getType() does not match object type.');
			childObj.CreditLimit = 1.5;
		System.assertEquals(1.5, childObj.CreditLimit);

		childObj.CreditAvailable = 1.5;
		System.assertEquals(1.5, childObj.CreditAvailable);

		childObj.CurrencyKey = 'X';
		System.assertEquals('X', childObj.CurrencyKey);

		childObj.CreditManagmentBlock = 'X';
		System.assertEquals('X', childObj.CreditManagmentBlock);

		childObj.ValidToDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidToDate);

		childObj.ChangeDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ChangeDate);

		childObj.CreditAnalyst = 'X';
		System.assertEquals('X', childObj.CreditAnalyst);

		childObj.CustomerCreditGroup = 'X';
		System.assertEquals('X', childObj.CustomerCreditGroup);

		childObj.ResubmissionDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ResubmissionDate);

		childObj.CalculatedCreditLimit = 1.5;
		System.assertEquals(1.5, childObj.CalculatedCreditLimit);

		childObj.SpecialAttentonRequired = 'X';
		System.assertEquals('X', childObj.SpecialAttentonRequired);

		childObj.LimitIsZero = 'X';
		System.assertEquals('X', childObj.LimitIsZero);

		childObj.CreditBlockReason = 'X';
		System.assertEquals('X', childObj.CreditBlockReason);

		childObj.CreditLimitRequested = 1.5;
		System.assertEquals(1.5, childObj.CreditLimitRequested);

		childObj.AutomaticLimitRequest = 'X';
		System.assertEquals('X', childObj.AutomaticLimitRequest);

		childObj.RequestedValidToDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.RequestedValidToDate);

		childObj.RequestDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.RequestDate);

		childObj.DaysInArrears = 1.5;
		System.assertEquals(1.5, childObj.DaysInArrears);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testUSER_DEFINED()
	{
		SBO_EnosixCustomer_Detail.USER_DEFINED childObj = new SBO_EnosixCustomer_Detail.USER_DEFINED();

		System.assertEquals(SBO_EnosixCustomer_Detail.USER_DEFINED.class,childObj.getType(),'getType() does not match object type.');
			childObj.FIELD = 'X';
		System.assertEquals('X', childObj.FIELD);

		childObj.VALUE = 'X';
		System.assertEquals('X', childObj.VALUE);

List<string> keyFields = new List<string>{ 'FIELD' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
}
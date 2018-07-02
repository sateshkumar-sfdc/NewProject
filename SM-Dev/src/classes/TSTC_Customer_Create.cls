/**
 * test class for Customer Create Controllers
 */
@isTest
public with sharing class TSTC_Customer_Create {

    @isTest static void test_AddBPRoleGroups() {
        List<SelectOption> roleGroupsResult = new List<SelectOption>();
        List<SelectOption> countriesResult = new List<SelectOption>();
        List<SelectOption> regionsResult = new List<SelectOption>();

        List<RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP> roleGroups = new List<RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP>();
        List<RFC_SD_GET_COUNTRIES.ET_OUTPUT> countries = new List<RFC_SD_GET_COUNTRIES.ET_OUTPUT>();
        List<RFC_SD_GET_COUNTRIES.ET_REGIONS> regions = new List<RFC_SD_GET_COUNTRIES.ET_REGIONS>();

        RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP roleGroup = new RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP();
        roleGroup.RLTGR = 'X';
        roleGroup.RLTGRTXT = 'Z';
        roleGroups.add(roleGroup);

        RFC_SD_GET_COUNTRIES.ET_OUTPUT country = new RFC_SD_GET_COUNTRIES.ET_OUTPUT();
        country.LAND1 = 'CX';
        country.LANDX = 'Country X';
        countries.add(country);

        RFC_SD_GET_COUNTRIES.ET_REGIONS region = new RFC_SD_GET_COUNTRIES.ET_REGIONS();
        region.REGIO = 'R1';
        region.LAND1 = 'C2';
        region.BEZEI = 'Region 1';
        regions.add(region);

        Test.startTest();
        CTRL_CustomerCreate.AddBPRoleGroups(roleGroupsResult, roleGroups);
        CTRL_CustomerCreate.AddCountries(countriesResult, countries);
        CTRL_CustomerCreate.AddRegionsForCountry(regionsResult, regions, 'C2');
        Test.stopTest();

        system.assertEquals(1, roleGroupsResult.size());
        system.assertEquals(1, countriesResult.size());
        system.assertEquals(1, regionsResult.size());
    }

    @isTest static void test_addPartnerToCustomer() {
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        SBO_EnosixCustomer_Detail.EnosixCustomer partner = new SBO_EnosixCustomer_Detail.EnosixCustomer();

        Test.startTest();
        CTRL_CustomerCreate.addPartnerToCustomer(customer, partner, 'SH');
        Test.stopTest();
    }

    @isTest static void test_getAccountByAccountId() {
        Test.startTest();
        PageReference pageReference = new PageReference('Page.VFP_CustomerCreate');

        // Insert test data
        Account a1 = new Account();
        a1.Name = 'Mock Create Account';
        insert a1;
        pageReference.getParameters().put('SF_AcctId', a1.Id);
        Test.setCurrentPageReference(pageReference);

        // Lookup by account id
        CTRL_CustomerCreate controller = new CTRL_CustomerCreate();
        Account result1 = controller.getAccount();

        System.assert(a1.Id == result1.Id);
        Test.stopTest();
    }

    @isTest static void test_getAccountByCase() {
        Test.startTest();
        PageReference pageReference = new PageReference('Page.VFP_CustomerCreate');

        // Insert test data
        Account a1 = new Account();
        a1.Name = 'Mock Create Account';
        insert a1;

        Case c = new Case();
        c.AccountId = a1.Id;
        insert c;
        System.assert(c.Id != null);

        pageReference.getParameters().put('SF_CaseId', c.Id);
        Test.setCurrentPageReference(pageReference);
        CTRL_CustomerCreate controller = new CTRL_CustomerCreate();
        Account result1 = controller.getAccount();

        // Test lookup by case id
        UTIL_PageState.current = null;
        System.currentPageReference().getParameters().put('SF_CaseId', c.Id);
        controller = new CTRL_CustomerCreate();
        Account result2 = controller.getAccount();

        Test.stopTest();

        System.assert(a1.Id == result1.Id);
        System.assert(a1.Name == result1.Name);
    }

    @isTest static void testFormattedPhone() {
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        customer.TelephoneNumber = '1234567890';
        customer.TelephoneNumberExtension = '123';

        CTRL_CustomerCreate controller = new CTRL_CustomerCreate();
        controller.cDetail = customer;

        System.assertEquals(controller.FormattedPhone, '1234567890 x123');

    }

    @isTest static void testFormattedFax() {
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        customer.FaxNumber = '1234567890';
        customer.FaxNumberExtension = '123';

        CTRL_CustomerCreate controller = new CTRL_CustomerCreate();
        controller.cDetail = customer;

        System.assertEquals(controller.FormattedFax, '1234567890 x123');
    }
    
    @isTest static void testExtraCodeCover() {
        
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        customer.FaxNumber = '1234567890';
        customer.FaxNumberExtension = '123';
        
        test.startTest();

        CTRL_CustomerCreate controller = new CTRL_CustomerCreate();
        controller.cDetail = customer;
        
        controller.ShowUpdate = true;
        //SBO_Enosixcontroller_Detail.Enosixcontroller obj = controller.parentcontroller;
        //boolean IscontrollerContactEditable = controller.IscontrollerContactEditable;
        //boolean IscontrollerAddressEditable = controller.IscontrollerAddressEditable;
        //controller.initCreateMode();
        //controller.initAddPartner();
        boolean showAddPartnerAction = controller.showAddPartnerAction;
        //controller.showAddPartnerAction();
        Account RefrenceAccount = controller.RefrenceAccount;
        
        controller.gotoCase();
        controller.gotoAccounts();

        
        List<SelectOption> BusinessPartnerTypeOptions =  controller.BusinessPartnerTypeOptions;
        List<SelectOption> BusinessPartnerCategoryOptions =  controller.BusinessPartnerCategoryOptions;

        test.stopTest();
        
        
    }
}
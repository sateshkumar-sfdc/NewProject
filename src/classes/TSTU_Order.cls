@isTest
public with sharing class TSTU_Order {

    @isTest
    static void test_convertOrderDetailToOrderItem()
    {
        Test.startTest();
        List<UTIL_Order.OrderItem> testItem = UTIL_Order.convertOrderDetailToOrderItem(new SBO_EnosixSO_Detail.EnosixSO());
        Test.stopTest();

        system.AssertNotEquals(null, testItem);
    }

    @isTest
    static void test_CopyCustomerInfoToOrder() {
        SBO_EnosixSO_Detail.EnosixSO result = new SBO_EnosixSO_Detail.EnosixSO();
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();

        Test.startTest();

        UTIL_Order.CopyCustomerInfoToOrder(result, customer);

        Test.stopTest();
    }
    @isTest
    static void test_TouchProps() {
        Test.startTest();
        String soldTo = UTIL_Order.SOLD_TO_PARTNER_CODE;
        String shipTo = UTIL_Order.SHIP_TO_PARTNER_CODE;
        Test.stopTest();
    }
    @isTest
    static void test_AddSalesOrganizations() {
        Test.startTest();
        List<SelectOption> selectOptions = new List<SelectOption>();
        List<SBO_EnosixCustomer_Detail.SALES_DATA> salesDataItems = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();
        for (integer i = 0; i < 10; i++) {
            SBO_EnosixCustomer_Detail.SALES_DATA salesData = new SBO_EnosixCustomer_Detail.SALES_DATA();
            salesData.SalesOrganization = 'TESTORG' + string.valueOf(i);
            salesData.SalesOrganizationName = 'TESTORGNAME' + string.valueOf(i);
            salesDataItems.add(salesData);
        }
        UTIL_Order.AddSalesOrganizations(selectOptions, salesDataItems);
        System.assert(selectOptions.size() > 0);
        Test.stopTest();
    }
    @isTest
    static void test_AddDistributionChannels() {
        Test.startTest();
        string testSalesOrg = '1000';
        string invalidSalesOrg = '9999';
        string testDistChannel = 'DIST';
        string invalidDistChannel = 'NO';
        List<SelectOption> selectOptions = new List<SelectOption>();
        List<SBO_EnosixCustomer_Detail.SALES_DATA> salesDataItems = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();
        for (integer i = 0; i < 10; i++) {

            SBO_EnosixCustomer_Detail.SALES_DATA salesData = new SBO_EnosixCustomer_Detail.SALES_DATA();
            salesData.SalesOrganization = 'TESTORG' + string.valueOf(i);
            salesData.SalesOrganizationName = 'TESTORGNAME' + string.valueOf(i);
            salesData.DistributionChannel = math.mod(i, 2) == 0 ? testDistChannel : invalidDistChannel;
            salesData.DistributionChannelName = math.mod(i, 2) == 0 ? 'ValidDistChannel' : 'invalidDistChannel';
            salesData.SalesOrganization = math.mod(i, 2) == 0 ? testSalesOrg : invalidSalesOrg;
            salesDataItems.add(salesData);
        }
        UTIL_Order.AddDistributionChannels(selectOptions, salesDataItems, testSalesOrg);
        System.assert(selectOptions.size() > 0);
        Test.stopTest();
    }
    @isTest
    static void test_AddDistributionDivisions() {
        Test.startTest();
        string testSalesOrg = '1000';
        string invalidSalesOrg = '9999';
        string testDistChannel = 'DIST';
        string invalidDistChannel = 'NO';
        string testDivision = 'DIV';
        List<SelectOption> selectOptions = new List<SelectOption>();
        List<SBO_EnosixCustomer_Detail.SALES_DATA> salesDataItems = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();
        for (integer i = 0; i < 10; i++) {

            SBO_EnosixCustomer_Detail.SALES_DATA salesData = new SBO_EnosixCustomer_Detail.SALES_DATA();
            salesData.SalesOrganization = 'TESTORG' + string.valueOf(i);
            salesData.SalesOrganizationName = 'TESTORGNAME' + string.valueOf(i);
            salesData.DistributionChannel = math.mod(i, 2) == 0 ? testDistChannel : invalidDistChannel;
            salesData.DistributionChannelName = math.mod(i, 2) == 0 ? 'ValidDistChannel' : 'invalidDistChannel';
            salesData.Division = testDivision;
            salesData.DivisionName = testDivision + 'NAME';
            salesData.SalesOrganization = math.mod(i, 2) == 0 ? testSalesOrg : invalidSalesOrg;
            salesDataItems.add(salesData);
        }
        UTIL_Order.AddDistributionDivisions(selectOptions, salesDataItems, testSalesOrg, testDistChannel);
        System.assert(selectOptions.size() > 0);
        Test.stopTest();
    }
    @isTest
    static void test_getOpportunityLineItemsFromOpportunity() {
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP';
        opp.CloseDate = Date.today();
        opp.StageName = 'IsWon';
        upsert opp;
        UTIL_Order.getOpportunityLineItemsFromOpportunity(opp);
        Test.stopTest();
    }
    @isTest
    static void test_getItemFromOrderByItemNumber() {
        Test.startTest();
        string itemToCheck = '10';
        SBO_EnosixSO_Detail.EnosixSO salesOrder = new SBO_EnosixSO_Detail.EnosixSO();
        SBO_EnosixSO_Detail.ITEMS itm = new SBO_EnosixSO_Detail.ITEMS();
        itm.ItemNumber = itemToCheck;
        salesOrder.ITEMS.add(itm);
        SBO_EnosixSO_Detail.ITEMS retrievedItem = UTIL_Order.getItemFromOrderByItemNumber(salesOrder, itemToCheck);
        System.assert(retrievedItem != null);
        Test.stopTest();
    }

    @isTest
    static void test_AddDocTypesOfCategory() {
        Test.startTest();
        List<string> documentCategories = new string[]{
                 '*'
        };
        List<string> documentTypes = new string[]{
                '*'
        };
        List<SelectOption> result = new List<SelectOption>();
        List<RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT> docTypes = new List<RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT>();
        RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT doctype = new RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT();
        doctype.AUART ='AUART';
        doctype.BEZEI='BEZEI';
        doctype.VBTYP = 'VBTYP';
        docTypes.add(docType);
        UTIL_Order.AddDocTypesOfCategory(result,docTypes,documentCategories,documentTypes);
        Test.stopTest();
    }

    @isTest
    static void test_formatSAPDateStringToReadableFormat()
    {
        Test.startTest();
        String formattedSAPDateString = '20991231';
        System.assert(UTIL_Order.formatSAPDateStringToReadableFormat(formattedSAPDateString) == '12/31/2099');
        System.assert(UTIL_Order.formatSAPDateStringToReadableFormat('') == '');
        //too many digits, the format wont be able to parse this, should be blank string
        System.assert(UTIL_Order.formatSAPDateStringToReadableFormat('209912121') == '');

        Test.stopTest();
    }

    @isTest
    static void test_filterItemCategoriesNoMatches()
    {
        UTIL_AppSettings.resourceJson = '{"Order.AllowedItemCategoriesByOrderType":{"foo":["bar"]}}';
        RFC_SD_GET_ORDER_TYPES.RESULT mockResult =
            (RFC_SD_GET_ORDER_TYPES.RESULT)(new MockGetOrderCategoryRfc()).executeFunction();

        Test.startTest();

        List<RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT> result = UTIL_Order.filterItemCategories(
            mockResult, 'nomatch');

        Test.stopTest();

        System.assert(result.size() == 0);
    }

    @isTest
    static void test_filterItemCategoriesMatchesOne()
    {
        UTIL_AppSettings.resourceJson =
            '{"Order.AllowedItemCategoriesByOrderType":{"foo":["widget"]}}';
        RFC_SD_GET_ORDER_TYPES.RESULT mockResult =
            (RFC_SD_GET_ORDER_TYPES.RESULT)(new MockGetOrderCategoryRfc()).executeFunction();

        Test.startTest();

        List<RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT> result = UTIL_Order.filterItemCategories(
            mockResult, 'foo');

        Test.stopTest();

        System.assert(result.size() == 1);
    }

    @isTest
    static void test_filterItemCategoriesMatchesMultiple()
    {
        UTIL_AppSettings.resourceJson =
            '{"Order.AllowedItemCategoriesByOrderType":{"foo":["widget","bar"]}}';
        RFC_SD_GET_ORDER_TYPES.RESULT mockResult =
            (RFC_SD_GET_ORDER_TYPES.RESULT)(new MockGetOrderCategoryRfc()).executeFunction();

        Test.startTest();

        List<RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT> result = UTIL_Order.filterItemCategories(
            mockResult, 'foo');

        Test.stopTest();

        System.assert(result.size() == 2);
    }

    @isTest
    static void test_filterItemCategoriesWildcard()
    {
        UTIL_AppSettings.resourceJson = '{"Order.AllowedItemCategoriesByOrderType":{"foo":["*"]}}';
        RFC_SD_GET_ORDER_TYPES.RESULT mockResult =
            (RFC_SD_GET_ORDER_TYPES.RESULT)(new MockGetOrderCategoryRfc()).executeFunction();

        Test.startTest();

        List<RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT> result = UTIL_Order.filterItemCategories(
            mockResult, 'foo');

        Test.stopTest();

        System.assert(result.size() == 2);
    }

    public class MockGetOrderCategoryRfc implements ENSX.EnosixFramework.RFCMock
    {
        public ENSX.EnosixFramework.FunctionObject executeFunction()
        {
            RFC_SD_GET_ORDER_TYPES.RESULT result = new RFC_SD_GET_ORDER_TYPES.RESULT();

            RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT garbage = new RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT();
            garbage.AUART = 'foo';
            garbage.PSTYV = 'bar';

            RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT ord = new RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT();
            ord.AUART = 'foo';
            ord.PSTYV = 'widget';

            RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT qt = new RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT();
            qt.AUART = 'quote';
            qt.PSTYV = 'widget';

            result.getCollection(RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class).add(garbage);
            result.getCollection(RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class).add(ord);
            result.getCollection(RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class).add(qt);
            result.setSuccess(true);

            return result;
        }
    }

    @isTest
    public static void test_getDisplayCreditCardEntry()
    {
        Test.startTest();

        // Test random char in map which will return true by default since it
        // won't be found.
        System.assert(UTIL_Order.getDisplayCreditCardEntry('*'));

        Test.stopTest();
    }

    @isTest
    public static void test_getDisplayCreditCardSection()
    {
        Test.startTest();

        // Test the same thing with a random char which should also return true.
        System.assert(UTIL_Order.getDisplayCreditCardSection('*'));

        Test.stopTest();
    }

    @isTest
    public static void test_defaultOptionBuilders()
    {
        UTIL_AppSettings.resourceJson = '{}';

        Test.startTest();
        UTIL_SelectOption.OptionBuilder ob1 = UTIL_Order.getShipToOptionBuilder();
        UTIL_SelectOption.OptionBuilder ob2 = UTIL_Order.getCustomerConditionOptionBuilder1();
        UTIL_SelectOption.OptionBuilder ob3 = UTIL_Order.getCustomerConditionOptionBuilder2();
        Test.stopTest();

        System.assert(ob1 instanceof UTIL_Order.PartnerOptionBuilder);
        System.assert(ob2 instanceof UTIL_Order.CustomerConditonOptionBuilder);
        System.assert(ob3 instanceof UTIL_Order.CustomerConditonOptionBuilder);
    }

    @isTest
    public static void test_optionBuilderOverrides()
    {
        UTIL_AppSettings.resourceJson = '{' +
            '"Order.ShipToOptionBuilder": "TSTU_Order.OptionBuilder",' +
            '"Order.CustomerConditionGroupBuilder1": "TSTU_Order.OptionBuilder",' +
            '"Order.CustomerConditionGroupBuilder2": "TSTU_Order.OptionBuilder"' +
        '}';

        Test.startTest();
        UTIL_SelectOption.OptionBuilder ob1 = UTIL_Order.getShipToOptionBuilder();
        UTIL_SelectOption.OptionBuilder ob2 = UTIL_Order.getCustomerConditionOptionBuilder1();
        UTIL_SelectOption.OptionBuilder ob3 = UTIL_Order.getCustomerConditionOptionBuilder2();
        Test.stopTest();

        System.assert(ob1 instanceof OptionBuilder);
        System.assert(ob2 instanceof OptionBuilder);
        System.assert(ob3 instanceof OptionBuilder);
    }

    public class OptionBuilder extends UTIL_SelectOption.OptionBuilder {}
}
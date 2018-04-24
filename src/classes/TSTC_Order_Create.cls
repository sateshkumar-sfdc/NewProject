@isTest
public with sharing class TSTC_Order_Create {

    public class MOC_EnosixSO_Detail implements ENSX.EnosixFramework.DetailSBOGetMock,
            ENSX.EnosixFramework.DetailSBOSaveMock, ENSX.EnosixFramework.DetailSBOCommandMock,
            ENSX.EnosixFramework.DetailSBOInitMock {
        public boolean success = true;

        public void setSuccess(boolean successful) {
            this.success = successful;
        }
        public ENSX.EnosixFramework.DetailObject executeGetDetail(object key) {
            SBO_EnosixSO_Detail.EnosixSO result = new SBO_EnosixSO_Detail.EnosixSO();
            result.setSuccess(success);
            return result;
        }
        public ENSX.EnosixFramework.DetailObject executeSave(ENSX.EnosixFramework.DetailObject obj) {
            SBO_EnosixSO_Detail.EnosixSO result = new SBO_EnosixSO_Detail.EnosixSO();
            result.setSuccess(success);
            return result;
        }
        public ENSX.EnosixFramework.DetailObject executeCommand(string command, ENSX.EnosixFramework.DetailObject obj) {
            SBO_EnosixSO_Detail.EnosixSO result = new SBO_EnosixSO_Detail.EnosixSO();
            result.setSuccess(success);
            return result;
        }
        public  ENSX.EnosixFramework.DetailObject executeInitialize(ENSX.EnosixFramework.DetailObject  initialState){
            SBO_EnosixSO_Detail.EnosixSO result = new SBO_EnosixSO_Detail.EnosixSO();
            result.setSuccess(success);
            return result;
        }
    }
    public class MOC_EnosixCustomer_Detail implements ENSX.EnosixFramework.DetailSBOGetMock {
        public ENSX.EnosixFramework.DetailObject executeGetDetail(object key) {
            SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();
            result.CustomerNumber = 'TESTCUST';
            result.Name = 'Test Customer';
            result.setSuccess(true);
            return result;
        }
    }
    public class MOC_EnosixCustomer_Search implements ENSX.EnosixFramework.SearchSBOMock {
        public ENSX.EnosixFramework.SearchResult executeSearch() {
            SBO_EnosixCustomer_Search.EnosixCustomer_SR search_result = new SBO_EnosixCustomer_Search.EnosixCustomer_SR();
            search_result.setSuccess(true);
            return search_result;
        }
    }
    public class MOC_EnosixMaterial_Search implements ENSX.EnosixFramework.SearchSBOMock {

        public ENSX.EnosixFramework.SearchResult executeSearch() {
            SBO_EnosixMaterial_Search.EnosixMaterial_SR search_result = new SBO_EnosixMaterial_Search.EnosixMaterial_SR();
            search_result.setSuccess(true);
            return search_result;
        }

    }
    public class MOC_RFC_SD_GET_DOC_TYPE_VALUES_ET_OUTPUT implements ENSX.EnosixFramework.RFCMock {
        public ENSX.EnosixFramework.FunctionObject executeFunction() {
            RFC_SD_GET_DOC_TYPE_VALUES.RESULT result = new RFC_SD_GET_DOC_TYPE_VALUES.RESULT();
            RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT sditm = new RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT();
            sditm.AUART = 'SD';
            sditm.BEZEI = 'Standard';
            result.ET_OUTPUT_List.add(sditm);
            for (integer i = 0; i < 20; i++) {
                RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT out = new RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT();
                out.AUART = 'tst' + i;
                out.BEZEI = 'tst' + i;
                result.ET_OUTPUT_List.add(out);
            }
            result.setSuccess(true);
            return result;
        }
    }
    public class MOC_RFC_SD_GET_RETURN_CUSTINSPEC implements ENSX.EnosixFramework.RFCMock {
        public ENSX.EnosixFramework.FunctionObject executeFunction() {
            RFC_SD_GET_RETURN_CUSTINSPEC.RESULT result = new RFC_SD_GET_RETURN_CUSTINSPEC.RESULT();
            result.setSuccess(true);
            return result;
        }
    }
    public class MOC_RFC_SD_GET_CARRIER_LIST implements ENSX.EnosixFramework.RFCMock {
        public ENSX.EnosixFramework.FunctionObject executeFunction() {
            RFC_SD_GET_CARRIER_LIST.RESULT result = new RFC_SD_GET_CARRIER_LIST.RESULT();
            result.setSuccess(true);
            return result;
        }
    }
    public class MOC_RFC_SD_GET_SHIP_INFO implements ENSX.EnosixFramework.RFCMock {
        public ENSX.EnosixFramework.FunctionObject executeFunction() {
            RFC_SD_GET_SHIP_INFO.RESULT result = new RFC_SD_GET_SHIP_INFO.RESULT();
            result.setSuccess(true);
            return result;
        }
    }
    public class MOC_RFC_SD_GET_ORDER_TYPES implements ENSX.EnosixFramework.RFCMock {
        public ENSX.EnosixFramework.FunctionObject executeFunction() {
            RFC_SD_GET_ORDER_TYPES.RESULT result = new RFC_SD_GET_ORDER_TYPES.RESULT();
            result.setSuccess(true);
            return result;
        }
    }


    static CTRL_OrderCreate createOrderController() {
        MOC_EnosixSO_Detail detailMoc = new MOC_EnosixSO_Detail();
        ENSX.EnosixFramework.setMock(SBO_EnosixSO_Detail.class, detailMoc);
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Detail.class, new MOC_EnosixCustomer_Detail());
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Search.class, new MOC_EnosixCustomer_Search());
        ENSX.EnosixFramework.setMock(SBO_EnosixMaterial_Search.class, new MOC_EnosixMaterial_Search());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_TYPE_VALUES.class, new MOC_RFC_SD_GET_DOC_TYPE_VALUES_ET_OUTPUT());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_RETURN_CUSTINSPEC.class, new MOC_RFC_SD_GET_RETURN_CUSTINSPEC());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_CARRIER_LIST.class, new MOC_RFC_SD_GET_CARRIER_LIST());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_SHIP_INFO.class, new MOC_RFC_SD_GET_SHIP_INFO());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_ORDER_TYPES.class, new MOC_RFC_SD_GET_ORDER_TYPES());
        Account a = new Account();
        a.Name = 'TestAccount';
        a.BillingCity = 'Cincinnatti';
        insert a;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName ='Closed Won';
        opp.CloseDate = system.today();
        opp.Account = a;
        insert opp;
        Test.setCurrentPageReference(new PageReference('Page.VFP_OrderCreate'));
        UTIL_PageState.current.opportunityId = opp.Id;
        UTIL_PageState.current.accountId = a.Id;
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        controller.initCreate();
        return controller;
    }
    @isTest
    static void test_init() {
        Test.startTest();
        CTRL_OrderCreate controller = createOrderController();
        controller.init();
        System.assert(controller!=null);
        Test.stopTest();
    }
    @isTest
    static void test_initFromParameters() {
        Test.startTest();
        CTRL_OrderCreate controller = createOrderController();
        controller.initFromParameters();
        System.assert(controller!=null);
        Test.stopTest();
    }

    @isTest
    static void test_CreateController() {
        Test.startTest();
        CTRL_OrderCreate controller = createOrderController();
        Test.stopTest();
        System.assertNotEquals(controller, null);
    }


    @isTest
    static void test_updatePaymentInfo() {
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        controller.selectedPaymentID = '';
        controller.updatePaymentInfo();
    }

    @isTest
    static void test_validateOrder() {
        SBO_EnosixSO_Detail.EnosixSO salesOrder = new SBO_EnosixSO_Detail.EnosixSO();
        Test.startTest();
        boolean result = CTRL_OrderCreate.validateOrder(salesOrder, true);
        Test.stopTest();
        System.assert(false == result);
    }

    @isTest
    static void test_validateNewLineItem() {
        SBO_EnosixSO_Detail.ITEMS item = new SBO_EnosixSO_Detail.ITEMS();
        Test.startTest();
        boolean result = CTRL_OrderCreate.validateNewLineItem(item);
        Test.stopTest();
        System.assert(false == result);
    }

    @isTest
    static void test_getNextItemNumber() {
        CTRL_OrderCreate controller = createOrderController();
        SBO_EnosixSO_Detail.EnosixSO salesOrder = new SBO_EnosixSO_Detail.EnosixSO();
        Test.startTest();
        SBO_EnosixSO_Detail.EnosixSO secondSalesOrder = new SBO_EnosixSO_Detail.EnosixSO();
        controller.init();
        string nextItmNumber = controller.getNextItemNumber(secondSalesOrder);
        System.assert('10' ==nextItmNumber);
        string result = CTRL_OrderCreate.getNextItemNumber(salesOrder, 20);
        System.assert('20' == result);
        Test.stopTest();
    }
    @isTest
    static void test_updatePicklists() {
        CTRL_OrderCreate controller = createOrderController();
        Test.startTest();
        SBO_EnosixSO_Detail.EnosixSO secondSalesOrder = new SBO_EnosixSO_Detail.EnosixSO();
        controller.init();
        controller.updatepicklists();
        Test.stopTest();
    }

    @isTest
    static void test_clearItem() {
        Test.startTest();
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        controller.clearItem();
        Test.stopTest();
        System.assert(controller.newItem != null);
    }

    @isTest
    static void test_getOrderTypes() {
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        Test.startTest();
        System.assert(controller.OrderTypes != null);
        Test.stopTest();
    }

    @isTest
    static void test_getSalesOrganizations() {
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        Test.startTest();
        System.assert(controller.SalesOrganizations != null);
        Test.stopTest();
    }

    @isTest
    static void test_getDistributionChannels() {
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        Test.startTest();
        System.assert(controller.DistributionChannels != null);
        Test.stopTest();
    }

    @isTest
    static void test_getDivisions() {
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        Test.startTest();
        System.assert(controller.Divisions != null);
        Test.stopTest();
    }

    @isTest
    static void test_getSoldToPartners() {
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        Test.startTest();
        System.assert(controller.SoldToPartners != null);
        Test.stopTest();
    }

    @isTest
    static void test_getShipToPartners() {
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        Test.startTest();
        System.assert(controller.ShipToPartners != null);
        Test.stopTest();
    }

    @isTest
    static void test_orderTypeDisabled(){
        CTRL_OrderCreate controller = new CTRL_OrderCreate();
        SBO_EnosixSO_Detail.EnosixSO salesOrder = new SBO_EnosixSO_Detail.EnosixSO();
        salesOrder.ITEMS.add(new SBO_EnosixSO_Detail.ITEMS());
        controller.orderDetail = salesOrder;
        Test.startTest();
        System.assert(controller.isOrderTypeDisabled==true);
        Test.stopTest();
    }

    @isTest
    static void test_fetchOpportunityLineItems(){
   		Test.startTest();
   		Account a  = new Account();
    	a.Name='test acct';
    	insert a;
		Opportunity o = new Opportunity();
		o.AccountId = a.Id;
		o.Name = 'testopp';
		o.Description = 'tst description ASDF';
		o.StageName= 'Needs Analysis';
		o.Amount= 123.23;
		o.Probability = 20;
		o.TotalOpportunityQuantity= 12342;
		o.CloseDate = System.today();
		insert o;

		Product2 newProd = new Product2(Name = 'test product', family = 'test family');
		insert newProd;

		PriceBookEntry pbEntry = new PriceBookEntry(
    		UnitPrice = 300,
    		PriceBook2Id = Test.getStandardPricebookId(),
    		Product2Id = newProd.Id,
    		IsActive = true);
		insert pbEntry ;

		for(integer i = 0; i<10; i++){
			OpportunityLineItem oli = new OpportunityLineItem();
			oli.OpportunityId = o.Id;
			oli.Quantity = (i+1) *10;
			oli.UnitPrice = i*.95;
			oli.Description = 'test Desciption';
            oli.PricebookEntryId = pbEntry.Id;
			insert oli;
		}
		List<OpportunityLineItem> fetchedolis = CTRL_OrderCreate.FetchOpportunityLineItems(o);
		Test.stopTest();
		System.assert(fetchedolis.size()>0);
    }


    @isTest
    static void test_translateOpportunityLineItem(){
    	Test.startTest();
    	Account a  = new Account();
    	a.Name='test acct';
    	insert a;
    	SBO_EnosixMaterial_Detail.EnosixMaterial matDetail = new SBO_EnosixMaterial_Detail.EnosixMaterial();
    	matDetail.Material = 'FG226';
    	SBO_EnosixMaterial_Detail.PLANT_DATA pd = new SBO_EnosixMaterial_Detail.PLANT_DATA();
    	pd.Plant = '1010';
    	pd.SalesOrganization = '1010';
    	pd.DistributionChannel = '10';
    	matDetail.PLANT_DATA.add(pd);
		Opportunity o = new Opportunity();
		o.AccountId = a.Id;
		o.Name = 'testopp';
		o.Description = 'tst description ASDF';
		o.StageName= 'Needs Analysis';
		o.Amount= 123.23;
		o.Probability = 20;
		o.TotalOpportunityQuantity= 12342;
		o.CloseDate = System.today();
		insert o;
		Product2 prod = new Product2();
        UTIL_Product.setProductMaterialField(prod,'FG226');
		prod.Name= 'FIN226,MTO,PD,Batch-Fifo,SerialNo';
		insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry();
		pbe.UnitPrice = 100;
		pbe.Pricebook2Id = pricebookId;
		pbe.Product2Id = prod.Id;
		pbe.UseStandardPrice = false;
		pbe.IsActive = true;
		insert pbe;
		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = o.Id;
		oli.Quantity = 10;
		oli.UnitPrice = .95;
		oli.Description = 'test Desciption';
        oli.PricebookEntryId = pbe.Id;
        insert oli;
		SBO_EnosixSO_Detail.ITEMS itm = CTRL_OrderCreate.TranslateOpportunityLineItem(oli, matDetail.Material, '1010', '10');
		Test.stopTest();
		System.assert(itm != null);
    }
    @isTest
    static void test_finalizeOrderandUpdateOpportunity() {
        Test.startTest();
        Account a = new Account();
        a.Name = 'test acct';
        insert a;
        Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = 'testopp';
        o.Description = 'tst description ASDF';
        o.StageName = 'Needs Analysis';
        o.Probability = 20;
        o.TotalOpportunityQuantity = 12342;
        o.CloseDate = System.today();
        insert o;

        Product2 newProd = new Product2(Name = 'test product', family = 'test family');
        insert newProd;
        PriceBookEntry pbEntry = new PriceBookEntry(
                UnitPrice = 300,
                PriceBook2Id = Test.getStandardPricebookId(),
                Product2Id = newProd.Id,
                IsActive = true);
        insert pbEntry ;
        for(integer i = 0; i<10; i++){
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = o.Id;
            oli.Quantity = (i+1) *10;
            oli.UnitPrice = i*.95;
            oli.Description = 'test Desciption';
            oli.PricebookEntryId = pbEntry.Id;
            insert oli;
        }
        SBO_EnosixSO_Detail.EnosixSO sodets = new SBO_EnosixSO_Detail.EnosixSO();
        sodets.NetOrderValue = 1234.12;
        sodets.SalesDocument = '0012345';
        Opportunity finalizedOpp = CTRL_OrderCreate.FinalizeOrderandUpdateOpportunity(o, sodets);
        System.assert(finalizedOpp != null);
        Test.stopTest();
    }

}
@IsTest
private class TSTC_Return_Order_Create {

    public class MOC_EnosixRO_Detail implements ENSX.EnosixFramework.DetailSBOGetMock,
            ENSX.EnosixFramework.DetailSBOSaveMock, ENSX.EnosixFramework.DetailSBOCommandMock {
        public boolean success = false;

        public void setSuccess(boolean successful) {
            this.success = successful;
        }
        public ENSX.EnosixFramework.DetailObject executeGetDetail(object key) {
            SBO_EnosixRO_Detail.EnosixRO result = new SBO_EnosixRO_Detail.EnosixRO();
            result.setSuccess(success);
            return result;
        }
        public ENSX.EnosixFramework.DetailObject executeSave(ENSX.EnosixFramework.DetailObject obj) {
            SBO_EnosixRO_Detail.EnosixRO result = new SBO_EnosixRO_Detail.EnosixRO();
            result.setSuccess(success);
            return result;
        }
        public ENSX.EnosixFramework.DetailObject executeCommand(string command, ENSX.EnosixFramework.DetailObject obj) {
            SBO_EnosixRO_Detail.EnosixRO result = new SBO_EnosixRO_Detail.EnosixRO();
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
    static CTRL_Return_Order_Create buildTestController() {
        MOC_EnosixRO_Detail detailMoc = new MOC_EnosixRO_Detail();
        ENSX.EnosixFramework.setMock(SBO_EnosixRO_Detail.class, detailMoc);
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Detail.class, new MOC_EnosixCustomer_Detail());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_TYPE_VALUES.class, new MOC_RFC_SD_GET_DOC_TYPE_VALUES_ET_OUTPUT());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_RETURN_CUSTINSPEC.class, new MOC_RFC_SD_GET_RETURN_CUSTINSPEC());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_CARRIER_LIST.class, new MOC_RFC_SD_GET_CARRIER_LIST());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_SHIP_INFO.class, new MOC_RFC_SD_GET_SHIP_INFO());
        Account a = new Account();
        a.Name = 'Acme';
        a.BillingCity = 'Cincinnatti';
        UTIL_Account.setAccountCustomerNumber(a,'TESTCUST');
        insert a;
        Contact con = new Contact();
        con.Email = 'TEST@enosix.com';
        con.LastName = 'LastName';
        con.FirstName = 'FirstName';
        insert con;
        Case c = new Case();
        c.Contact = con;
        c.ENSX_EDM__Return_Order_Number__c = 'TESTCUST';
        c.AccountId = a.Id;
        insert c;
        UTIL_PageState.current.caseId = c.Id;
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        controller.initFromParameters();
        controller.replacementItems = new List<SBO_EnosixRO_Detail.ITEMS_ARM>();
        for(integer i =0;i<10; i++ ){
            SBO_EnosixRO_Detail.ITEMS_ARM arm = new SBO_EnosixRO_Detail.ITEMS_ARM();
            arm.ScheduleLineDate = System.Today().format();
            arm.Item = String.valueOf(i*10);
            arm.Material = 'testmaterial';
            controller.replacementItems.add(arm);
        }
        return controller;
    }

//test class Indexed Item
    @isTest
    static void test_indexItem() {
        Test.startTest();
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        for (integer i = 0; i < 5; i++) {
            CTRL_Return_Order_Create.IndexedItem indexedItem = new CTRL_Return_Order_Create.IndexedItem();
            indexedItem.index = i;
            SBO_EnosixRO_Detail.ITEMS_ARM arm = new SBO_EnosixRO_Detail.ITEMS_ARM();
            arm.ScheduleLineDate = string.valueof(System.Today());
            indexedItem.item = arm;
            indexedItem.formattedScheduleLineDate = DateTime.now().format('MM/dd/yyyy');
            controller.indexedReplacementItems.add(indexedItem);
        }
        Test.stopTest();
    }

    @isTest
    static void test_CreateRMA() {
        Test.startTest();
        MOC_EnosixRO_Detail detailMoc = new MOC_EnosixRO_Detail();
        ENSX.EnosixFramework.setMock(SBO_EnosixRO_Detail.class, detailMoc);
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Detail.class, new MOC_EnosixCustomer_Detail());
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_TYPE_VALUES.class, new MOC_RFC_SD_GET_DOC_TYPE_VALUES_ET_OUTPUT());

        Account a = new Account();
        a.Name = 'Acme';
        a.BillingCity = 'Cincinnatti';
        insert a;
        Case c = new Case();
        c.AccountId = a.Id;
        insert c;
        Test.setCurrentPageReference(new PageReference('Page.VFP_Return_Order_Create'));
        string idParam = 'SF_AcctId';
        System.currentPageReference().getParameters().put(idParam, a.Id);
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();

        controller.initCreate();
        controller.cas = c;
        controller.customerDetail = UTIL_Object_Lookups.GetCustomerForCase(c);
        //fail validation lines
        detailMoc.setSuccess(false);
        controller.createRMA();
        detailMoc.setSuccess(true);

        System.debug('now testing with valid fields.');
        //populate valid fields
        SBO_EnosixRO_Detail.ITEMS_ARM replacearm = new SBO_EnosixRO_Detail.ITEMS_ARM();
        replacearm.Material = 'asddf';
        controller.replacementItems.add(replacearm);
        controller.rmaSaleData.SalesDocumentType = 'SD';
        controller.rmaSaleData.SalesOrganization = '5';
        controller.rmaSaleData.DistributionChannel = 'DC';
        controller.rmaSaleData.Division = 'DIV';
        controller.SoldToPartner.CustomerNumber = '1234';
        controller.ShipToPartner.CustomerNumber = '1234';
        controller.ShipToPartner.EMailAddress = 'test@test.com';
        SBO_EnosixRO_Detail.ITEMS_ARM arm = new SBO_EnosixRO_Detail.ITEMS_ARM();
        arm.Material = 'asddf';
        controller.rmaDetail.ITEMS_ARM.add(arm);
        controller.rmaDetail.CustomerPurchaseOrderNumber = 'PO N';
        controller.rmaDetail.CustomerPurchaseOrderDate = System.Today();
        controller.rmaDetail.OrderReason = 'A Reason';
        //assert the created RMA is not null
        System.assert(controller.createRMA() != null);
        Test.stopTest();
    }
    @isTest
    static void test_GoToCustomerLinkPage() {
        Test.startTest();
        Account a = new Account();
        a.Name = 'Acme';
        a.BillingCity = 'Cincinnatti';
        insert a;
        Case c = new Case();
        c.AccountId = a.Id;
        insert c;
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        System.assert(controller.GoToCustomerLinkPage() != null);
        Test.stopTest();
    }
    @isTest
    static void test_CreateController() {
        Test.startTest();
        Account a = new Account();
        a.Name = 'Acme';
        a.BillingCity = 'Cincinnatti';
        insert a;
        Test.setCurrentPageReference(new PageReference('Page.VFP_Return_Order_Create'));
        string idParam = 'SF_AcctId';
        System.currentPageReference().getParameters().put(idParam, a.Id);
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        Test.stopTest();
        System.assertNotEquals(controller, null);
    }


    @isTest
    static void test_touchAllFieldsAndProperties() {
        Test.startTest();
        CTRL_Return_Order_Create controller = buildTestController();
        controller.initFromParameters();
        Case cse = controller.cas;
        SBO_EnosixRO_Detail.EnosixRO rmaDetail = controller.rmaDetail;
        SBO_EnosixCustomer_Detail.EnosixCustomer customerDetail = controller.customerDetail;
        SBO_EnosixCustomer_Detail.EnosixCustomer shipToCustomer = controller.shipToCustomer;
        SBO_EnosixRO_Detail.SALES rmaSaleData = controller.rmaSaleData;
        RFC_SD_GET_RETURN_CUSTINSPEC.RESULT inspectionResult = controller.inspectionResult;
        String RefundType = controller.RefundType;
        List<SelectOption> ShippingConditions = controller.ShippingConditions;
        List<SelectOption> Carriers = controller.Carriers;
        SBO_EnosixRO_Detail.PARTNERS Carrier = controller.Carrier;
        List<SelectOption> DocumentTypes = controller.DocumentTypes;
        List<SelectOption> RefundTypes = controller.RefundTypes;
        List<SelectOption> OrderReasons = controller.OrderReasons;
        List<SelectOption> ReturnReasons = controller.ReturnReasons;
        List<SelectOption> Divisions = controller.Divisions;
        List<SelectOption> DistributionChannels = controller.DistributionChannels;
        List<SelectOption> SalesOrganizations = controller.SalesOrganizations;
        List<CTRL_Return_Order_Create.IndexedItem> indexedReplacementItems = controller.indexedReplacementItems;
        List<SelectOption> OrderTypes = controller.OrderTypes;
        boolean isOrderCardLimitEnabled = controller.isOrderCardLimitEnabled;
        integer OrderCardsCount = controller.OrderCardsCount;
        List<SBO_EnosixRO_Detail.CCARD> ccards = controller.OrderCards;
        boolean displayEnterCardbutton = controller.displayEnterCardButton;
        boolean displayCapture = controller.displayCaptureCardButton;
        string selectedCustomerCard = controller.selectedCustomerCard;
        List<SBO_EnosixRO_Detail.ITEMS_ARM> replacementItems = controller.replacementItems;
        CB_CardDetailsReceiver cdReceiver = controller.cdReceiver;
        CB_MaterialSearchReceiver msReceiver = controller.msReceiver;
        System.assertNotEquals(CTRL_Return_Order_Create.master_DocumentTypes, null);
        Test.stopTest();
    }

    @isTest
    static void test_validateOrder() {
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        controller.rmaDetail.CustomerPurchaseOrderDate = Date.today();
        Test.startTest();
        boolean result = controller.validateReturnOrder();
        Test.stopTest();
        System.assert(false == result);
    }

    @isTest
    static void test_GoToCreateCustomer() {
        Test.startTest();
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        controller.GoToCreateCustomer();
        Test.stopTest();
    }

    @isTest
    static void test_redirectToCreateCustomer() {
        Test.startTest();
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        Account a = new Account();
        a.Name = 'test';
        upsert a;
        Case c = new Case();
        c.AccountId = a.Id;
        upsert c;
        controller.redirectToCreateCustomer();
        Test.stopTest();
    }

    @isTest
    static void test_redirectToOrderDetail() {
        Test.startTest();
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        PageReference pr = controller.redirectToOrderDetail('TESTERDERID');
        System.assert(pr != null);
        Test.stopTest();
    }

    @isTest
    static void test_returnToCase() {
        Test.startTest();
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        PageReference pr = controller.returnToCase();
        System.assert(pr != null);
        Test.stopTest();
    }
    @isTest
    static void test_removeCard() {
        Test.startTest();
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        Test.setCurrentPageReference(new PageReference('Page.VFP_Return_Order_Create'));
        System.currentPageReference().getParameters().put('cardNumber', 'T4493184340701111');
        string cardNumb = 'T4493184340701111';
        controller.actionRemoveCard();
        Test.stopTest();
    }
    @isTest
    static void test_onInitCardDetails() {
        Test.startTest();
        CTRL_Return_Order_Create controller = new CTRL_Return_Order_Create();
        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept xi = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
        controller.onInitCardDetails(xi);
        Test.stopTest();
    }
    @isTest
    static void test_onReceiveCardDetails() {
        Test.startTest();
        CTRL_Return_Order_Create controller = TSTC_Return_Order_Create.buildTestController();
        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept xi = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
        xi.CardVerificationValue = '1234';
        xi.CreditCardNumber = '4111111111111111';
        xi.ValidToMonth = '12';
        xi.ValidToYear = '2099';
        xi.CreditCardHolder = 'TEST USER';
        xi.RESPONSE.CardVerificationValue = '1234';
        xi.RESPONSE.ValidToYear = '2099';
        xi.RESPONSE.ValidToMonth = '01';
        xi.RESPONSE.CreditCardNumber = '4111111111111111';
        xi.RESPONSE.CreditCardHolder = 'TEST USER';
        xi.RESPONSE.SAPCardType = 'vi';
        controller.onReceiveCardDetails(xi);
        Test.stopTest();
    }


}
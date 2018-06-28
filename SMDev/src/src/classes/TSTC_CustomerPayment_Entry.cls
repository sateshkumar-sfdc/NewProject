@isTest
public with sharing class TSTC_CustomerPayment_Entry {

    @isTest static void test_initDetail() {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerPayment_Entry'));

        Test.startTest();
        // Test with no customerid and verify cDetail is null
        CTRL_CustomerPayment_Entry controller1 = new CTRL_CustomerPayment_Entry();

        mockCustomerGetDetail(null);
        addAccountWithCustomerId('TEST_CUSTID');
        // Init customerid and verify cDetail is filled from mock
        System.currentPageReference().getParameters().put('SAP_CustId', 'TEST_CUSTID');

        UTIL_PageState.current = null;
        CTRL_CustomerPayment_Entry controller2 = new CTRL_CustomerPayment_Entry();
        System.assert(controller2.customerid != null);
        System.assert(controller2.cDetail == null);
        PageReference ref = controller2.initDetail();

        Test.stopTest();

        System.assert(ref == null);
        System.assert(controller2.cDetail != null);
    }

    @isTest static void test_paymentsList() {
        // create test customer data
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        SBO_EnosixCustomer_Detail.PAYMENT_DATA creditCard = new SBO_EnosixCustomer_Detail.PAYMENT_DATA();
        creditCard.PaymentCardType = 'TEST';
        creditCard.CardNumber = 'TESTNUMBER';
        customer.PAYMENT_DATA.add(creditCard);

        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerPayment_Entry'));
        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();
        controller.cDetail = customer;

        Test.startTest();
        System.assert(controller.paymentsList.get(0).PaymentCardType == creditCard.PaymentCardType);
        System.assert(controller.paymentsList.get(0).CardNumber == creditCard.CardNumber);
        Test.stopTest();
    }

    @isTest static void test_getAccount() {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerPayment_Entry'));

        // Insert test data
        Account a1 = new Account();
        a1.Name = 'Mock Detail Account';
        insert a1;

        Account a2 = addAccountWithCustomerId('TEST_CUSTID');

        Account a3 = new Account();
        a3.Name = 'Mock Detail Account3';
        insert a3;

        Case c = new Case();
        c.AccountId = a3.Id;
        insert c;

        Test.startTest();

        // Lookup by account id
        System.currentPageReference().getParameters().put('SF_AcctId', a1.Id);
        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();
        Account result1 = controller.getAccount();

        // Test lookup by customer id
        UTIL_PageState.current = null;
        System.currentPageReference().getParameters().put('SAP_CustId', UTIL_Account.getCustomerNumberFromAccount(a2));
        controller = new CTRL_CustomerPayment_Entry();
        Account result2 = controller.getAccount();

        // Test lookup by case id
        UTIL_PageState.current = null;
        System.currentPageReference().getParameters().put('SF_CaseId', c.Id);
        controller = new CTRL_CustomerPayment_Entry();
        Account result3 = controller.getAccount();

        Test.stopTest();

        System.assert(a1.Id == result1.Id);
        System.assert(a1.Name == result1.Name);
        System.assert(a2.Id == result2.Id);
        System.assert(a2.Name == result2.Name);
        System.assert(a3.Id == result3.Id);
        System.assert(a3.Name == result3.Name);
    }

    @isTest static void test_refreshIdsFromAccount() {
        // Insert test data
        Account a1 = new Account();
        a1.Name = 'Mock Account';
        insert a1;

        Account a2 = addAccountWithCustomerId('TEST_CUSTID');

        System.currentPageReference().getParameters().put('SF_AcctId', a1.Id);
        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();
        System.assert(controller.accountid == a1.Id);

        Test.startTest();

        // null does nothing
        controller.refreshIdsFromAccount(null);
        System.assert(controller.accountid == a1.Id);

        // This should update accountid and customerid properties on controller
        controller.refreshIdsFromAccount(a2);

        Test.stopTest();

        System.assert(controller.accountid == a2.Id);
        System.assert(controller.customerid == UTIL_Account.getCustomerNumberFromAccount(a2));
    }

    @isTest static void test_onReceiveCardDetails() {
        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();

        controller.isAuthorized = true;
        controller.isCaptureButtonVisible = true;

        Test.startTest();
        controller.onReceiveCardDetails(intercept);
        Test.stopTest();

        System.assert(!controller.isCaptureButtonVisible);
        System.assert(controller.isAuthorized == null);
        System.assert(controller.intercept == intercept);
    }

    @isTest static void test_onInitCardDetails() {
        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();

        controller.isAuthorized = true;
        controller.isCaptureButtonVisible = false;
        controller.onReceiveCardDetails(intercept);

        System.assert(controller.intercept == intercept);

        Test.startTest();
        controller.onInitCardDetails(null);
        Test.stopTest();

        System.assert(controller.isCaptureButtonVisible);
        System.assert(controller.isAuthorized == null);
        System.assert(controller.intercept == null);
    }

    @isTest static void test_actionAuthCard() {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerPayment_Entry'));

        mockCustomerGetDetail(null);
        addAccountWithCustomerId('TEST_CUSTID');
        System.currentPageReference().getParameters().put('SAP_CustId', 'TEST_CUSTID');

        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();
        controller.initDetail();
        controller.onInitCardDetails(null);

        Test.startTest();
        // No intercept set, shouldn't add anything
        System.assert(controller.isAuthorized == null);
        controller.actionAuthCard();
        System.assert(controller.isAuthorized == null);

        MockAuthSBO mock = new MockAuthSBO();
        ENSX.EnosixFramework.setMock(ensx.EnosixFramework.DetailSBO.class, mock);

        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = createXiInterceptResponse('T_FAKE_CCNUM');
        controller.onReceiveCardDetails(intercept);

        controller.actionAuthCard();
        System.assert(controller.isAuthorized);

        Test.stopTest();
    }

    @isTest static void test_actionAddCard() {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerPayment_Entry'));

        mockCustomerGetDetail(null);
        addAccountWithCustomerId('TEST_CUSTID');
        System.currentPageReference().getParameters().put('SAP_CustId', 'TEST_CUSTID');

        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();
        controller.initDetail();
        controller.onInitCardDetails(null);

        Test.startTest();
        // No intercept set, shouldn't add anything
        System.assert(controller.cDetail.PAYMENT_DATA.size() == 0);
        controller.actionAddCard();
        System.assert(controller.cDetail.PAYMENT_DATA.size() == 0);

        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = createXiInterceptResponse('T_FAKE_CCNUM');
        controller.onReceiveCardDetails(intercept);

        // Mock save customer again with a card added
        SBO_EnosixCustomer_Detail.EnosixCustomer c = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        SBO_EnosixCustomer_Detail.PAYMENT_DATA paymentData = new SBO_EnosixCustomer_Detail.PAYMENT_DATA();

        paymentData.CardNumber = intercept.RESPONSE.CreditCardNumber;
        paymentData.PaymentCardType = 'VISA';
        paymentData.CardHolderName = 'Test Person';
        paymentData.CardCategory = '01';
        paymentData.ValidFromDate = Date.today();
        paymentData.ValidToDate = Date.newInstance(2099, 1, 1);
        c.PAYMENT_DATA.add(paymentData);
        mockCustomerSave(c);

        // Now with intercept added, this should update the cDetail
        controller.actionAddCard();
        System.assertEquals(2, controller.cDetail.PAYMENT_DATA.size(), 'PAYMENT_DATA record count');

        Test.stopTest();
    }

    @isTest static void test_actionRemoveCard() {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerPayment_Entry'));

        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        SBO_EnosixCustomer_Detail.PAYMENT_DATA creditCard = new SBO_EnosixCustomer_Detail.PAYMENT_DATA();
        creditCard.PaymentCardType = 'TEST';
        creditCard.CardNumber = 'TESTNUMBER';
        customer.PAYMENT_DATA.add(creditCard);

        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();
        controller.onInitCardDetails(null);
        // set the cDetail directly with an existing card number
        controller.cDetail = customer;

        mockCustomerGetDetail(customer);
        mockCustomerSave(customer);

        Test.startTest();
        // No ccnum set, shouldn't add anything
        controller.actionRemoveCard();
        System.assert(controller.cDetail.PAYMENT_DATA.size() == 1);

        // Now with ccnum
        System.currentPageReference().getParameters().put('cardNumber', 'TESTNUMBER');
        controller.actionRemoveCard();

        List<SBO_EnosixCustomer_Detail.PAYMENT_DATA> cards = new List<SBO_EnosixCustomer_Detail.PAYMENT_DATA>();
        controller.cDetail.Payment_Data.copyTo(cards);

        System.assert(cards[0].X_RemoveCard == 'X');

        Test.stopTest();
    }

    @isTest static void testFormattedPhone()
    {
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        customer.TelephoneNumber = '1234567890';
        customer.TelephoneNumberExtension = '123';

        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();
        controller.cDetail = customer;

        System.assertEquals(controller.FormattedPhone,'1234567890 x123');

    }

    @isTest static void testFormattedFax()
    {
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        customer.FaxNumber = '1234567890';
        customer.FaxNumberExtension = '123';

        CTRL_CustomerPayment_Entry controller = new CTRL_CustomerPayment_Entry();
        controller.cDetail = customer;

        System.assertEquals(controller.FormattedFax,'1234567890 x123');
    }

    class TestException extends Exception {}

    // not a real test, just increasing coverage
    @isTest static void test_displayException() {
        Test.startTest();
        CTRL_CustomerPayment_Entry.displayException(null);
        CTRL_CustomerPayment_Entry.displayException(new TestException('msg'));
        Test.stopTest();
    }

    // helper methods to make tests shorter
    //

    static Account addAccountWithCustomerId(string customerId) {
        Account a = new Account();
        a.Name = 'Mock Account for ' + customerId;
        UTIL_Account.setAccountCustomerNumber(a, customerId);
        insert a;
        return a;
    }

    static SBO_EnosixXiIntercept_Detail.EnosixXiIntercept createXiInterceptResponse(string cardNumber) {
        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
        intercept.RESPONSE.CreditCardNumber = cardNumber;
        intercept.RESPONSE.ValidToMonth = '01';
        intercept.RESPONSE.ValidToYear = '2099';
        return intercept;
    }

    public class MockCustomerSBO implements ENSX.EnosixFramework.DetailSBOGetMock, ENSX.EnosixFramework.DetailSBOSaveMock
    {
        SBO_EnosixCustomer_Detail.EnosixCustomer mockReturnData;

        public MockCustomerSBO(SBO_EnosixCustomer_Detail.EnosixCustomer c) {
            if (c == null) c = new SBO_EnosixCustomer_Detail.EnosixCustomer();
            mockReturnData = c;
        }

        public ENSX.EnosixFramework.DetailObject executeGetDetail(object obj) {
            mockReturnData.setSuccess(true);
            return mockReturnData;
        }

        public ENSX.EnosixFramework.DetailObject executeSave(ENSX.EnosixFramework.DetailObject obj) {
            mockReturnData.setSuccess(true);
            return mockReturnData;
        }
    }

    public class MockAuthSBO implements ENSX.EnosixFramework.DetailSBOGetMock
    {
        public ENSX.EnosixFramework.DetailObject executeGetDetail(object obj) {
            SBO_EnosixCCPreauth_Detail.EnosixCCPreauth auth = new SBO_EnosixCCPreauth_Detail.EnosixCCPreauth();
            auth.RESPONSE.AuthorizationResponse = 'A';
            auth.setSuccess(true);
            return auth;
        }
    }

    static void mockCustomerGetDetail(SBO_EnosixCustomer_Detail.EnosixCustomer c) {
        MockCustomerSBO mock = new MockCustomerSBO(c);
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Detail.class, mock);
    }

    static void mockCustomerSave(SBO_EnosixCustomer_Detail.EnosixCustomer c) {
        MockCustomerSBO mock = new MockCustomerSBO(c);
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Detail.class, mock);
    }
}
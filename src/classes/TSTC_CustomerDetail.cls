/**
 * test class for Customer Detail Controller
 */
@isTest
public with sharing class TSTC_CustomerDetail {

    @isTest static void test_getAccount() {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerDetail'));

        // Insert test data
        Account a1 = new Account();
        a1.Name = 'Mock Detail Account';
        insert a1;

        Account a2 = new Account();
        a2.Name = 'Mock Detail Account2';
        UTIL_Account.setAccountCustomerNumber(a2,'TEST_CUSTID');
        insert a2;

        Account a3 = new Account();
        a3.Name = 'Mock Detail Account3';
        insert a3;

        Case c = new Case();
        c.AccountId = a3.Id;
        insert c;

        Test.startTest();

        // Lookup by account id
        UTIL_PageState.current = null;
        System.currentPageReference().getParameters().put('SF_AcctId', a1.Id);
        CTRL_CustomerDetail controller = new CTRL_CustomerDetail();
        Account result1 = controller.getAccount();

        // Test lookup by customer id
        UTIL_PageState.current = null;
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerDetail'));
        System.currentPageReference().getParameters().put('SAP_CustId', UTIL_Account.getCustomerNumberFromAccount(a2));
        controller = new CTRL_CustomerDetail();
        Account result2 = controller.getAccount();

        // Test lookup by case id
        UTIL_PageState.current = null;
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerDetail'));
        System.currentPageReference().getParameters().put('SF_CaseId', c.Id);
        controller = new CTRL_CustomerDetail();
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

        Account a2 = new Account();
        a2.Name = 'Mock Account2';
        UTIL_Account.setAccountCustomerNumber(a2, 'TEST_CUSTID');
        insert a2;

        System.currentPageReference().getParameters().put('SF_AcctId', a1.Id);
        CTRL_CustomerDetail controller = new CTRL_CustomerDetail();
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

    @isTest static void testFormattedPhone()
    {
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        customer.TelephoneNumber = '1234567890';
        customer.TelephoneNumberExtension = '123';

        CTRL_CustomerDetail controller = new CTRL_CustomerDetail();
        controller.cDetail = customer;

        System.assertEquals(controller.FormattedPhone,'1234567890 x123');

    }

    @isTest static void testFormattedFax()
    {
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        customer.FaxNumber = '1234567890';
        customer.FaxNumberExtension = '123';

        CTRL_CustomerDetail controller = new CTRL_CustomerDetail();
        controller.cDetail = customer;

        System.assertEquals(controller.FormattedFax,'1234567890 x123');
    }
}
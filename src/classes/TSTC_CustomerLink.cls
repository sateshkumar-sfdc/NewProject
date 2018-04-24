/**
 * test class for Customer Link Controllers
 */
@isTest
public with sharing class TSTC_CustomerLink {

    @isTest
    static void test_createConstructorAndTouchProperties() {
        Test.startTest();
        Account A = new Account();
        A.Name = 'TESTACCT';
        upsert A;
        Test.setCurrentPageReference(new PageReference('Page.VFP_Customer_Link'));
        System.currentPageReference().getParameters().put('SF_AcctId', A.Id);
        CTRL_CustomerLink cl = new CTRL_CustomerLink();
        System.assert(cl != null);
        Test.stopTest();
    }

    @isTest static void test_getAccount() {
        Test.startTest();
        Account A = new Account();
        A.Name = 'TESTACCT';
        upsert A;
        Test.setCurrentPageReference(new PageReference('Page.VFP_Customer_Link'));
        System.currentPageReference().getParameters().put('SF_AcctId', A.Id);
        CTRL_CustomerLink cl = new CTRL_CustomerLink();
        System.assert(cl != null);
        System.assert(cl.getAccount() != null);
        Test.stopTest();

    }
    @isTest static void test_wildCardSearch() {
        Test.startTest();
        Account A = new Account();
        A.Name = 'TESTACCT';
        upsert A;
        Test.setCurrentPageReference(new PageReference('Page.VFP_Customer_Link'));
        System.currentPageReference().getParameters().put('SF_AcctId', A.Id);
        CTRL_CustomerLink cl = new CTRL_CustomerLink();
        string wildCardString = 'TESTSTRINGTOSEARCH';
        System.assertNotEquals(wildCardString, cl.wildCardSearch(wildCardString, 500));
        Test.stopTest();

    }
    @isTest static void test_LinkAccount() {
        Test.startTest();
        Account A = new Account();
        A.Name = 'TESTACCT';
        upsert A;
        Test.setCurrentPageReference(new PageReference('Page.VFP_Customer_Link'));
        System.currentPageReference().getParameters().put('SF_AcctId', A.Id);
        CTRL_CustomerLink cl = new CTRL_CustomerLink();
        cl.actionLinkAccount();
        Test.stopTest();

    }
    @isTest static void test_GoToCreateCustomer() {
        Test.startTest();
        Account A = new Account();
        A.Name = 'TESTACCT';
        upsert A;
        Test.setCurrentPageReference(new PageReference('Page.VFP_Customer_Link'));
        System.currentPageReference().getParameters().put('SF_AcctId', A.Id);
        CTRL_CustomerLink cl = new CTRL_CustomerLink();
        cl.GoToCreateCustomer();
        Test.stopTest();

    }

    /* TO DO: This should be implemetned once the Search mocks come back online.
    @isTest static void test_searchForCustomersMatchingCriteria(){

    }*/
}
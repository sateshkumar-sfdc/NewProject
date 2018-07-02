@isTest
public with sharing class TSTU_PageFlow
{
    @isTest static void test_redirectTo()
    {
        Test.startTest();
        PageReference page1 = UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_OrderCreate, null);

        UTIL_PageState state = new UTIL_PageState();
        state.accountId = 'a1';
        state.customerId = 'c1';

        PageReference page2 = UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_OrderCreate, state);

        PageReference page3 = UTIL_PageFlow.redirectTo(null, state);
        Test.stopTest();

        System.assert(page1.getParameters().size() == 0);
        System.assert(page1.getUrl() == UTIL_PageFlow.VFP_OrderCreate);

        System.assert(page2.getUrl().startsWith(UTIL_PageFlow.VFP_OrderCreate + '?'));
        System.assert(page2.getParameters().get('SF_AcctId') == 'a1');
        System.assert(page2.getParameters().get('SAP_CustId') == 'c1');

        System.assert(page3 == null);
    }

    @isTest static void test_returnToSavedPageOrDefault()
    {
        Test.startTest();
        // null args return null
        PageReference page1 = UTIL_PageFlow.returnToSavedPageOrDefault(null, null);

        // no return url in state, still null
        UTIL_PageState state = new UTIL_PageState();
        PageReference page2 = UTIL_PageFlow.returnToSavedPageOrDefault(state, null);

        // use default when no return url in state
        PageReference page3 = UTIL_PageFlow.returnToSavedPageOrDefault(state, UTIL_PageFlow.VFP_OrderCreate);

        // use return url when it's set
        state.accountId = 'a1';
        state.saveCustomReturnState(UTIL_PageFlow.VFP_Customer_Link, state);
        PageReference page4 = UTIL_PageFlow.returnToSavedPageOrDefault(state, UTIL_PageFlow.VFP_OrderCreate);
        Test.stopTest();

        System.assert(page1 == null);
        System.assert(page2 == null);
        System.assert(page3.getUrl() == UTIL_PageFlow.VFP_OrderCreate);
        System.assert(page4.getUrl() == UTIL_PageFlow.VFP_Customer_Link + '?SF_AcctId=a1');
    }
}
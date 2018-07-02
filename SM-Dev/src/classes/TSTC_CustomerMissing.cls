@isTest
public with sharing class TSTC_CustomerMissing
{
    @isTest static void test_actionCreateCustomer()
    {
        UTIL_PageState.current.accountId = 'ACCOUNT';
        CTRL_CustomerMissing controller = new CTRL_CustomerMissing();

        Test.startTest();
        PageReference result = controller.actionCreateCustomer();
        Test.stopTest();

        System.assert(result.getUrl().startsWith(UTIL_PageFlow.VFP_CustomerCreate));
        System.assert('ACCOUNT' == result.getParameters().get('SF_AcctId'));
    }

    @isTest static void test_actionLinkCustomer()
    {
        UTIL_PageState.current.accountId = 'ACCOUNT';
        CTRL_CustomerMissing controller = new CTRL_CustomerMissing();

        Test.startTest();
        PageReference result = controller.actionLinkCustomer();
        Test.stopTest();

        System.assert(result.getUrl().startsWith(UTIL_PageFlow.VFP_Customer_Link));
        System.assert('ACCOUNT' == result.getParameters().get('SF_AcctId'));
    }
}
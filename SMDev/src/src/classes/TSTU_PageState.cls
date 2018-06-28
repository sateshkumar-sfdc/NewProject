@isTest
public with sharing class TSTU_PageState
{
    @isTest static void test_current()
    {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerDetail'));
        System.currentPageReference().getParameters().put('SF_AcctId', 'CURRENT_ACCOUNT');
        System.currentPageReference().getParameters().put('Ignored_Param', 'nothing');

        Test.startTest();
        Map<String, String> values = UTIL_PageState.current.values;
        Test.stopTest();

        System.assert(values.get('SF_AcctId') == 'CURRENT_ACCOUNT');
        System.assert(values.containsKey('Ignored_Param') == false);
    }

    @isTest static void test_setCurrentState()
    {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerDetail'));
        System.currentPageReference().getParameters().put('SF_AcctId', '1');

        Test.startTest();

        String ac1 = UTIL_PageState.current.accountId;

        UTIL_PageState newState = new UTIL_PageState();
        newState.accountId = '2';

        UTIL_PageState.setCurrentState(newState);
        String ac2 = UTIL_PageState.current.accountId;

        Test.stopTest();

        System.assert(ac1 == '1');
        System.assert(ac2 == '2');
    }

    @isTest static void test_properties()
    {
        Test.startTest();
        UTIL_PageState state = new UTIL_PageState();

        // test never set property is null
        System.assert(state.accountId == null);

        state.accountId = '1';
        state.addPartnerTo = '2';
        state.caseId = '3';
        state.customerId = '4';
        state.docNum = '5';
        state.itemNum = '6';
        state.opportunityId = '7';
        state.orderNum = '8';
        state.partnerType = '9';
        state.quoteId = '10';
        state.rmaId = '11';
        state.deliveryNum = '12';
        state.deliveryItemNum = '13';
        state.invoiceNum = '14';
        state.materialId = '15';
        state.opportunityProductId = '16';
        state.plantId = '17';
        state.productId = '18';

        System.assert(state.accountId == '1');
        System.assert(state.addPartnerTo == '2');
        System.assert(state.caseId == '3');
        System.assert(state.customerId == '4');
        System.assert(state.docNum == '5');
        System.assert(state.itemNum == '6');
        System.assert(state.opportunityId == '7');
        System.assert(state.orderNum == '8');
        System.assert(state.partnerType == '9');
        System.assert(state.quoteId == '10');
        System.assert(state.rmaId == '11');
        System.assert(state.deliveryNum == '12');
        System.assert(state.deliveryItemNum == '13');
        System.assert(state.invoiceNum == '14');
        System.assert(state.materialId == '15');
        System.assert(state.opportunityProductId == '16');
        System.assert(state.plantId == '17');
        System.assert(state.productId == '18');

        // Test removal of property
        state.accountId = null;
        System.assert(state.values.containsKey('SF_AcctId') == false);

        Test.stopTest();
    }

    @isTest static void test_getPageParams()
    {
        UTIL_PageState state = new UTIL_PageState();
        state.accountId = '1';
        state.caseId = '2';

        Test.startTest();
        Map<String, String> result = state.getPageParams();
        Test.stopTest();

        System.assert(result.size() == 2);
        System.assert(result.get('SF_AcctId') == '1');
        System.assert(result.get('SF_CaseId') == '2');
    }

    @isTest static void test_saveReturnState()
    {
        Test.setCurrentPageReference(new PageReference('Page.VFP_CustomerDetail'));
        System.currentPageReference().getParameters().put('SF_AcctId', 'accid');
        System.currentPageReference().getParameters().put('Ignored_Param', 'nope');

        UTIL_PageState state = new UTIL_PageState();

        System.assert(state.returnToUrl == null);

        Test.startTest();
        state.saveReturnState();
        Test.stopTest();

        System.assert(state.returnToUrl == 'Page.VFP_CustomerDetail?SF_AcctId=accid');
    }

    @isTest static void test_saveCustomReturnState()
    {
        Test.setCurrentPageReference(new PageReference('Page.Ignored'));
        System.currentPageReference().getParameters().put('SF_AcctId', 'ignored');

        UTIL_PageState state1 = new UTIL_PageState();
        UTIL_PageState state2 = new UTIL_PageState();
        state2.accountId = 'accid';
        state2.customerId = 'custid';

        Test.startTest();
        state1.saveCustomReturnState('fakePage', state2);
        state2.saveCustomReturnState('fakePage2', null);
        Test.stopTest();

        System.assert(state1.returnToUrl.startsWith('fakePage'));
        // Query string order is not important, so check params using a
        // PageReference as a help
        PageReference p = new PageReference(state1.returnToUrl);
        System.assert(p.getParameters().get('SF_AcctId') == 'accid');
        System.assert(p.getParameters().get('SAP_CustId') == 'custid');

        System.assert(state2.returnToUrl == 'fakePage2');
    }
}
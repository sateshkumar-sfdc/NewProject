@isTest
public with sharing class TSTC_OpportunityInfo
{
    @isTest static void test_properties()
    {
        Account a = new Account();
        a.Name = 'acct 1';
        insert a;

        Opportunity opp = new Opportunity();
        opp.Name = 'opp 1';
        opp.StageName = 'New';
        opp.CloseDate = Date.today();
        opp.ENSX_EDM__Quote_Number__c = 'TEST-QUOTE';
        insert opp;

        CTRL_OpportunityInfo controller = new CTRL_OpportunityInfo();

        Test.startTest();
        controller.sfAccountId = a.Id;
        controller.sfOpportunityId = opp.Id;

        System.assert(controller.sfAccountId == a.Id);
        System.assert(controller.sfOpportunityId == opp.Id);
        Test.stopTest();

        System.assert(controller.sfAccount.Name == a.Name);
        System.assert(controller.sfOpportunity.Name == opp.Name);
        System.assert(
            controller.sfOpportunity.ENSX_EDM__Quote_Number__c == opp.ENSX_EDM__Quote_Number__c);
    }

    @isTest static void test_redirectToQuoteDetail()
    {
        Opportunity opp = new Opportunity();
        opp.Name = 'opp 1';
        opp.StageName = 'New';
        opp.CloseDate = Date.today();
        opp.ENSX_EDM__Quote_Number__c = 'TEST-QUOTE';
        insert opp;

        CTRL_OpportunityInfo controller = new CTRL_OpportunityInfo();
        controller.sfOpportunityId = opp.Id;

        Test.startTest();
        PageReference result = controller.redirectToQuoteDetail();
        Test.stopTest();

        System.assert(result.getUrl().startsWith(UTIL_PageFlow.VFP_Quote_Detail));
        System.assert('TEST-QUOTE' == result.getParameters().get('SAP_QuoteId'));
    }
}
@IsTest
private class TSTC_Opportunity_QuotePricingRedirect {
    static testMethod void test_ConstructorAndRedirect() {
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP';
        opp.StageName = 'Closed';
        opp.CloseDate = Date.today();
        upsert opp;
        Test.setCurrentPageReference(new PageReference('Page.VFP_Return_Order_Create'));
        string idParam = 'addTo';
        System.currentPageReference().getParameters().put(idParam, opp.Id);
        ApexPages.StandardController std =new ApexPages.StandardController(opp);
        CTRL_Opportunity_QuotePricingRedirect controller = new CTRL_Opportunity_QuotePricingRedirect(std);
        System.assert(controller != null);
        controller.RedirectToCustomOpportunityPage();
        Test.stopTest();
    }
}
@IsTest
private class TSTC_Return_Order_Search {
    @isTest
    static void test_createControllerAndTouchProperties() {
        Test.startTest();
        CTRL_Return_Order_Search controller = new CTRL_Return_Order_Search();
        List<SBO_EnosixRO_Search.SEARCHRESULT> searchResults  = controller.searchResults;
        string soldToParty = controller.soldToParty;
        Test.stopTest();
        System.assert(controller != null);
    }

    @isTest
    static void test_navigateToRMADetail() {
        Test.setCurrentPageReference(new PageReference('Page.VFP_Return_Order_Detail'));
        System.currentPageReference().getParameters().put('SAP_RmaId', 'TESTID');
        Test.startTest();
        CTRL_Return_Order_Search controller = new CTRL_Return_Order_Search();
        controller.navigateToRMADetail();
        Test.stopTest();
        System.assert(controller != null);
    }
}
@IsTest
private class TSTC_Quote_List {
    @isTest
    static void test_createControllerAndTouchProperties() {
        Test.startTest();
        CTRL_Quote_List controller = new CTRL_Quote_List();
        boolean show = controller.showsearch;
        String fromaccount = controller.fromaccount;
        String quotestatus = controller.quotestatus;
        List<SBO_EnosixQuote_Search.SEARCHRESULT> orders = controller.quotes;
        List<SelectOption> orderStatuses = controller.getquotestatuslist();
        Test.stopTest();
        System.assert(controller != null);
    }
}
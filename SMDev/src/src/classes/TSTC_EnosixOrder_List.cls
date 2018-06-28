@IsTest
private class TSTC_EnosixOrder_List {
    @isTest
    static void test_createControllerAndTouchProperties() {
        Test.startTest();
        CTRL_EnosixOrder_List controller = new CTRL_EnosixOrder_List();
        boolean show = controller.showsearch;
        String fromaccount = controller.fromaccount;
        Boolean hasrecords = controller.hasrecords;
        String orderstatus = controller.orderstatus;
        Integer numperpage = controller.numperpage;
        Integer pagenum = controller.pagenum;
        Integer totalpages = controller.totalpages;
        Boolean disableprev = controller.disableprev;
        Boolean disablenext = controller.disablenext;
        List<SBO_EnosixSO_Search.SEARCHRESULT> orders = controller.orders;
        List<SelectOption> orderStatuses = controller.getOrderstatuslist();
        List<SelectOption> numperpages = controller.getNumPerPageOptions();
        Test.stopTest();
        System.assert(controller != null);
    }
}
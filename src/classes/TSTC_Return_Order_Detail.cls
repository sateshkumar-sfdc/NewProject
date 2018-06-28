@IsTest
private class TSTC_Return_Order_Detail {

    @isTest static void test_CreateController() {
        Test.startTest();
        CTRL_Return_Order_Detail ctrl = new CTRL_Return_Order_Detail();
        Test.stopTest();
    }

    @isTest static void test_ItemDetailPage() {
        CTRL_Return_Order_Detail ctrl = new CTRL_Return_Order_Detail();
        Test.startTest();
        ctrl.ItemDetailPage();
        Test.stopTest();
    }

    @isTest static void test_Items() {
        CTRL_Return_Order_Detail ctrl = new CTRL_Return_Order_Detail();
        Test.startTest();
        List<SBO_EnosixRO_Detail.ITEMS> result = ctrl.Items;
        Test.stopTest();

        system.assert(null != result);
    }

    @isTest static void test_Partners() {
        CTRL_Return_Order_Detail ctrl = new CTRL_Return_Order_Detail();
        Test.startTest();
        List<SBO_EnosixRO_Detail.PARTNERS> result = ctrl.Partners;
        Test.stopTest();

        system.assert(null != result);
    }
    @isTest static void test_CCARDS() {
        CTRL_Return_Order_Detail ctrl = new CTRL_Return_Order_Detail();
        Test.startTest();
        List<SBO_EnosixRO_Detail.CCARD> result = ctrl.RMACards;
        Test.stopTest();
    }

    @isTest static void test_SelectedItemSchedule() {
        CTRL_Return_Order_Detail ctrl = new CTRL_Return_Order_Detail();
        Test.startTest();
        List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE> result = ctrl.SelectedItemSchedule;
        Test.stopTest();

        system.assert(null != result);
    }

    @isTest static void test_SelectedConditions() {
        CTRL_Return_Order_Detail ctrl = new CTRL_Return_Order_Detail();
        Test.startTest();
        List<SBO_EnosixRO_Detail.CONDITIONS> result = ctrl.SelectedConditions;
        Test.stopTest();

        system.assert(null != result);
    }
}
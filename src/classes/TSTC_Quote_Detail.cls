@IsTest
private class TSTC_Quote_Detail {

    @isTest static void test_CreateController() {
        Test.startTest();
        CTRL_Quote_Detail ctrl = new CTRL_Quote_Detail();
        Test.stopTest();
    }

    @isTest static void test_ItemDetailPage() {
        CTRL_Quote_Detail ctrl = new CTRL_Quote_Detail();
        Test.startTest();
        ctrl.ItemDetailPage();
        Test.stopTest();
    }

    @isTest static void test_Items() {
        CTRL_Quote_Detail ctrl = new CTRL_Quote_Detail();
        Test.startTest();
        List<UTIL_Order.QuoteItem> result = ctrl.Items;
        Test.stopTest();

        system.assert(null != result);
    }

    @isTest static void test_Partners() {
        CTRL_Quote_Detail ctrl = new CTRL_Quote_Detail();
        Test.startTest();
        List<SBO_EnosixQuote_Detail.PARTNERS> result = ctrl.Partners;
        Test.stopTest();

        system.assert(null != result);
    }
    @isTest static void test_SelectedItemSchedule() {
        CTRL_Quote_Detail ctrl = new CTRL_Quote_Detail();
        Test.startTest();
        List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> result = ctrl.SelectedItemSchedule;
        Test.stopTest();

        system.assert(null != result);
    }

    @isTest static void test_SelectedConditions() {
        CTRL_Quote_Detail ctrl = new CTRL_Quote_Detail();
        Test.startTest();
        List<SBO_EnosixQuote_Detail.CONDITIONS> result = ctrl.SelectedConditions;
        Test.stopTest();

        system.assert(null != result);
    }
}
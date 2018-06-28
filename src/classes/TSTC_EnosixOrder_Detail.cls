/**
 * test class for Order Detail Controller
 */
@isTest
private class TSTC_EnosixOrder_Detail {

    @isTest static void test_CreateController() {
        Test.startTest();
		CTRL_EnosixOrder_Detail ctrl = new CTRL_EnosixOrder_Detail();
		Test.stopTest();
    }

    @isTest static void test_ItemDetailPage() {
    	CTRL_EnosixOrder_Detail ctrl = new CTRL_EnosixOrder_Detail();
        Test.startTest();
		ctrl.ItemDetailPage();
		Test.stopTest();
    }

    @isTest static void test_Items() {
    	CTRL_EnosixOrder_Detail ctrl = new CTRL_EnosixOrder_Detail();
        Test.startTest();
		List<UTIL_Order.OrderItem> result = ctrl.Items;
		Test.stopTest();

		system.assert(null != result);
    }

     @isTest static void test_Partners() {
    	CTRL_EnosixOrder_Detail ctrl = new CTRL_EnosixOrder_Detail();
        Test.startTest();
		List<SBO_EnosixSO_Detail.PARTNERS> result = ctrl.Partners;
		Test.stopTest();

		system.assert(null != result);
    }

    @isTest static void test_SelectedItemSchedule() {
    	CTRL_EnosixOrder_Detail ctrl = new CTRL_EnosixOrder_Detail();
        Test.startTest();
		List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> result = ctrl.SelectedItemSchedule;
		Test.stopTest();

		system.assert(null != result);
    }

     @isTest static void test_SelectedConditions() {
    	CTRL_EnosixOrder_Detail ctrl = new CTRL_EnosixOrder_Detail();
        Test.startTest();
		List<SBO_EnosixSO_Detail.CONDITIONS> result = ctrl.SelectedConditions;
		Test.stopTest();

		system.assert(null != result);
    }
}
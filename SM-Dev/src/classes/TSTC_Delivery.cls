/**
 * test class for Delivery Inquiry Controllers
 */
@isTest
private class TSTC_Delivery {
	@isTest static void testDeliveryList() {
        Account a = new Account(Name = 'uniqueaccountname', BillingCountry = 'US');
        UTIL_Account.setAccountCustomerNumber(a, 'test');
        insert a;

        System.currentPageReference().getParameters().put('SF_AcctId', String.valueOf(a.Id));

        Test.startTest();
        CTRL_DeliveryList dllist = new CTRL_DeliveryList();
        dllist.numperpage = 1;
        dllist.searchDL();
        Test.stopTest();
	}

    @isTest
    static void test_gotoDetailPage() {
        //Create an account to test against.
        Account a = new Account(Name = 'uniqueaccountname', BillingCountry = 'US');
        UTIL_Account.setAccountCustomerNumber(a, 'test');
        insert a;

        Test.setCurrentPageReference(new PageReference('Page.VFP_DeliveryList'));
        System.currentPageReference().getParameters().put('SF_AcctId', string.valueOf(a.Id));
        System.currentPageReference().getParameters().put('deliveryID', string.valueOf(1));
        CTRL_DeliveryList controller = new CTRL_DeliveryList();

        Test.startTest();

        PageReference result1 = controller.gotoDeliveryDetail();
        Test.stopTest();

        System.assertEquals('/apex/VFP_DeliveryDetail?dlnumber=1&SF_AcctId='+string.valueOf(a.Id),result1.getUrl());
    }

	@isTest static void testDeliveryDetail() {
		System.currentPageReference().getParameters().put('dlnumber','1000');
        System.currentPageReference().getParameters().put('SAP_DeliveryItem', '0010');

        CTRL_DeliveryDetail dldetail = new CTRL_DeliveryDetail();

        Test.startTest();
        dldetail.ItemDetailPage();
        Test.stopTest();
	}
}
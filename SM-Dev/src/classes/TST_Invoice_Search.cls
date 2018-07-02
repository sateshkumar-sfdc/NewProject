@isTest
private class TST_Invoice_Search {

    @isTest static void tesInvoiceSearch() {
        
        ensx.EnosixFramework.setMock(SBO_EnosixInvoice_Search.class, new MOC_EnosixInvoice_Search.MockEnosixInvoiceSuccess());

        Account a = new Account(Name = 'uniqueaccountname', BillingCountry = 'US');
        UTIL_Account.setAccountCustomerNumber(a, 'test');
        insert a;

        System.currentPageReference().getParameters().put('customerid',String.valueOf(a.Id));

        Test.startTest();
        CTRL_Invoice_Search invList = new CTRL_Invoice_Search();
        invList.numperpage = 1;
        invList.searchInvoice();
        system.assertEquals(System.currentPageReference().getParameters().get('customerid'),  String.valueOf(a.Id));
        Test.stopTest();
	}
	@isTest static void test_getConditionsForItem() {

		System.currentPageReference().getParameters().put('InvoiceNumber', '12345');
		SBO_EnosixInvoice_Detail.EnosixInvoice invoice = new SBO_EnosixInvoice_Detail.EnosixInvoice();
		Test.startTest();
		CTRL_Invoice_Detail.getConditionsForItem(invoice, '10');
		Test.stopTest();
	}
}
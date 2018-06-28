@isTest
private class TSTC_Customer_Base {
    @isTest static void test_FetchEnosixCustomer() {
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Detail.class, new MOC_EnosixCustomer_Detail.MockEnosixCustomerSuccess());

        Test.startTest();
        SBO_EnosixCustomer_Detail.EnosixCustomer result = CTRL_Customer_Base.FetchEnosixCustomer(null);
        Test.stopTest();

        system.assert(null != result);
    }
}
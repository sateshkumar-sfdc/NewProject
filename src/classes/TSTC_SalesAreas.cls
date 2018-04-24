@IsTest
private class TSTC_SalesAreas {
    @isTest
    static void test_ConstructorAndItems() {
        Test.startTest();
        CTRL_SalesAreas constructor = new CTRL_SalesAreas();
        List<SelectOption> ShippingConditions = constructor.ShippingConditions;
        List<SelectOption> paymentTerms = constructor.paymentTerms;
        List<SelectOption> priceGroups = constructor.priceGroups;
        Test.stopTest();
    }
}
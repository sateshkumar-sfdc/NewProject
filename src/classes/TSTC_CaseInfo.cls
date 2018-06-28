@IsTest
private class TSTC_CaseInfo {
    @isTest
    static void test_caseFunctionality() {
        Test.startTest();
        Case tstCase = new Case();
        tstCase.ENSX_EDM__Return_Order_Number__c = 'TST12345';
        upsert tstCase;
        CTRL_CaseInfo ci  = new CTRL_CaseInfo();
        ci.sfCase = tstCase;
        string id = ci.sfCaseId;
        ci.sfCaseId = tstCase.Id;
        ci.redirectToOrderDetail();
        Test.stopTest();
    }
}
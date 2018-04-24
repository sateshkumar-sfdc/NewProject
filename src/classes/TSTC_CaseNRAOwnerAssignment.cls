@IsTest
private class TSTC_CaseNRAOwnerAssignment {
    @isTest static void testCase() {
        Test.startTest();
        Case tstCase = new Case();
        tstCase.Subject = 'Test nra 1';
        tstCase.Description = 'Test NRA 1';
        insert tstCase;
        
    }
}
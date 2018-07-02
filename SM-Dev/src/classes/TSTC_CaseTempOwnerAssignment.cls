@IsTest
private class TSTC_CaseTempOwnerAssignment {
    
    @isTest static void testCase() {
     Id OutfitterRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Outfitter').getRecordTypeId();
        Test.startTest();
        Case tstCase = new Case();
        tstCase.Subject = 'Test EDIT 1';
        tstCase.Description = 'Test EDIT 1';
        tstCase.Origin = 'Public Email';
        tstCase.RecordTypeId = OutfitterRT;
        insert tstCase;        
    }
    
}
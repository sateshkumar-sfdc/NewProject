@isTest(seeAllData=true)
private class Test_LeadUtil{
    
    /*Test method for LeadUtil.leadAssignment*/ 
    static testMethod void testLeadAssignment() {
                
        //Create test data
        User u = TestDataUtility.newUser('test@yeti.com');
        Lead_Assignment_Rule__c lar = TestDataUtility.newLeadAssignmentRule(u.Id, '2614');
        
        //Test Lead Assignment
        
        Lead l = TestDataUtility.newLead('Test Lead', 'Test Company',  true);
        l.Country = 'AUS';
        l.PostalCode = '2614';
        update l;
        l = [SELECT Id FROM Lead WHERE Id =: l.Id];
       // system.assertEquals(u.Id);
        
                
     }
      

}
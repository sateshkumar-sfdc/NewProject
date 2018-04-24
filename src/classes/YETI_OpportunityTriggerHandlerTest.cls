/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  22rd March 2017
Name          :  YETI_OpportunityTriggerHandlerTest
Description   :  Test Class for YETI_OpportunityTrigger 
*/

@isTest
public class YETI_OpportunityTriggerHandlerTest {
  @testSetup
  static void createTestData(){
    YETI_TestDataFactory testdatafactory = new YETI_TestDataFactory();
    Id shipToRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship to').getRecordTypeId();
    
    // Create account
    Account parentAccount = testdatafactory.createAccount('Parent Account',false);
    parentAccount.RecordTypeId = shipToRecordTypeId;
    
    // Create account2
    Account parentAccount2 = testdatafactory.createAccount('Parent Account2',false);
    parentAccount2.RecordTypeId = shipToRecordTypeId;
    
    insert new List<Account> {
          parentAccount,
          parentAccount2
        };    
        
    // Create child account
    Account childAccount = testdatafactory.createAccount('Child Account1',false);
    childAccount.RecordTypeId = shipToRecordTypeId;
    childAccount.ParentId = parentAccount.Id;
    
    // Create child account2
    Account childAccount2 = testdatafactory.createAccount('Child Account2',false);
    childAccount2.RecordTypeId = shipToRecordTypeId;
    childAccount2.ParentId = parentAccount2.Id;
    insert new List<Account> {
          childAccount,
          childAccount2
        };  
        
    Contact communityUserContact = testdatafactory.createContact(parentAccount.Id,'Child Account',false);
    Contact communityUserContact2 = testdatafactory.createContact(parentAccount2.Id,'Child Account2',false);
    insert new List<Contact> {
          communityUserContact,
          communityUserContact2
        }; 
    
    User commUser1 = testdatafactory.createCommunityUser('childUser1','childUser1',communityUserContact.Id,false);
    User commUser2 = testdatafactory.createCommunityUser('childUser2','childUser2',communityUserContact2.Id,false);
    insert new List<User> {
          commUser1,
          commUser2
        }; 
    
    Opportunity opp = testdatafactory.createOpportunity('Opportunity Test Record',parentAccount.Id,false);
    opp.Ship_to__c = childAccount.Id;
    insert opp;
    
    List<Opportunity> lstOpportunities = testdatafactory.createMultipleOpportunity('Opportunity Test Record',parentAccount.Id,5,true);
    
  }
  
  static testMethod void testOppUpdate() {
    Test.startTest();
      Set<Id> setOppIds = new Set<Id>();
      List<Opportunity> lstOpportunities = [SELECT Id, Name, AccountId FROM Opportunity WHERE Name LIKE '%Opportunity Test Record%'];
      for(Opportunity op : lstOpportunities){
        setOppIds.add(op.Id);
      }
      
      Account acc = [SELECT Id, Name FROM Account WHERE Name =: 'Parent Account2' LIMIT 1];
      List<User> lstUser = [SELECT id,Firstname FROM User WHERE firstname =: 'childUser1' OR firstName=: 'childUser2' Order by firstname];
      User use1 = lstUser[0]; 
      User use2 = lstUser[1];
      
      List<Opportunity> lstOppToUpdate = new List<Opportunity>();
      List<UserRecordAccess> lstUserRecordAccess = [SELECT RecordId, HasReadAccess
                                                      FROM UserRecordAccess WHERE UserId =: use1.Id
                                                      AND RecordId In : setOppIds];
                                                      
      // The users will have access to the opportunity record where Opportunity's account = user's contact's account.
      //system.assertEquals(true,lstUserRecordAccess[0].HasReadAccess);
      for (Opportunity opp : lstOpportunities){
        opp.AccountId = acc.Id;
        opp.Ship_to__c = acc.Id;
        opp.StageName = 'Approved Prebook';
        lstOppToUpdate.add(opp);
      }
      update lstOppToUpdate;
      
      List<UserRecordAccess> lstUserRecordAccessAfterUpdate = [SELECT RecordId, HasReadAccess
                                                              FROM UserRecordAccess WHERE UserId =: use1.Id
                                                              AND RecordId In : setOppIds];
                                                              
      // The users will not have access to the opportunity record where Opportunity's account != user's contact's account.                                                        
      //system.assertEquals(false,lstUserRecordAccessAfterUpdate[0].HasReadAccess);
      
      List<Opportunity> lstOppToUpdateAgain = new List<Opportunity>();
      for (Opportunity opp : lstOppToUpdate){
          opp.StageName = 'Prospecting';
          lstOppToUpdateAgain.add(opp);
      }
      update lstOppToUpdateAgain;
      
      List<UserRecordAccess> lstUserRecordAccessAfterStageUpdate = [SELECT RecordId, HasReadAccess
                                                              FROM UserRecordAccess WHERE UserId =: use2.Id
                                                              AND RecordId In : setOppIds];
                                                              
      // The users will not have access to the opportunity record when opportunity is not in the allowed set of stages.                                                     
      //system.assertEquals(false,lstUserRecordAccessAfterStageUpdate[0].HasReadAccess);
      
    Test.stopTest();
  }

  /*
  private static testmethod void testRejectionWithComment()
    {
        // Generate sample work item using utility method.
        YETI_TestDataFactory testdatafactory = new YETI_TestDataFactory();

        Id testWorkItemId = testdatafactory.generateAndSubmitObject();
        
        // Reject the submitted request, providing a comment.
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Rejecting request with a comment.');
        testRej.setAction('Reject');
        testRej.setWorkitemId(testWorkItemId);
    
        Test.startTest();

        // Process the rejection
        Approval.ProcessResult testRejResult =  Approval.process(testRej);

        Test.stopTest();
        
        // Verify the rejection results
       // System.assert(testRejResult.isSuccess(), 'Rejections that include comments should be permitted');
        //System.assertEquals('Rejected', testRejResult.getInstanceStatus(), 
          'Rejections that include comments should be successful and instance status should be Rejected');
    }
    */
    
    /*
        For this test, create an object for approval, then reject the request, mark the approval status as pending, then
        without a comment explaining why. The rejection should be halted, and
        and an apex page message should be provided to the user.
    */
    private static testmethod void testRejectionWithoutComment()
    {
        // Generate sample work item using utility method.
        YETI_TestDataFactory testdatafactory = new YETI_TestDataFactory();
        Id testWorkItemId = testdatafactory.generateAndSubmitObject();
        
        // Reject the submitted request, without providing a comment.
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('');
        testRej.setAction('Reject');      
        testRej.setWorkitemId(testWorkItemId);
    
        Test.startTest();        

        // Attempt to process the rejection
        try {
          Approval.ProcessResult testRejResult =  Approval.process(testRej);
          //system.assert(false, 'A rejection with no comment should cause an exception');
        }
        catch(DMLException e) {
            system.assertEquals('Please provide a rejection reason before rejecting the record.', 
                                e.getDmlMessage(0), 
              'error message should be Operation Cancelled: Please provide a rejection reason!'); 
        }

        Test.stopTest();
    }
    
    /*
        When an approval is approved instead of rejected, a comment is not required, 
        mark the approval status as pending, then ensure that this functionality still holds together.
    */
    private static testmethod void testApprovalWithoutComment()
    {
        // Generate sample work item using utility method.
        YETI_TestDataFactory testdatafactory = new YETI_TestDataFactory();
        Id testWorkItemId = testdatafactory.generateAndSubmitObject();
        
        // approve the submitted request, without providing a comment.
        Approval.ProcessWorkitemRequest testApp = new Approval.ProcessWorkitemRequest();
        testApp.setComments ('');
        testApp.setAction   ('Approve');
        testApp.setWorkitemId(testWorkItemId);
    
        Test.startTest();        
            // Process the approval
            Approval.ProcessResult testAppResult =  Approval.process(testApp);
        Test.stopTest();
        
        // Verify the approval results
       //System.assert(testAppResult.isSuccess(),                   'Approvals that do not include comments should still be permitted');
       // System.assertEquals('Approved', testAppResult.getInstanceStatus(),         'All approvals should be successful and result in an instance status of Approved');
    }
}
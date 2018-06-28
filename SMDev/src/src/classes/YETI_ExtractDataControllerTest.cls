/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  23rd March 2017
Name          :  YETI_ExtractDataControllerTest
Description   :  Test Class for YETI_ExtractDataController 
*/
@isTest
public class YETI_ExtractDataControllerTest {
  @testSetup
  static void createTestData(){
    YETI_TestDataFactory testdatafactory = new YETI_TestDataFactory();
    // Create account
    Account parentAccount = testdatafactory.createAccount('Parent Account',false);
    insert parentAccount;
    
    Contact communityUserContact = testdatafactory.createContact(parentAccount.Id,'Child Account',true);
    
    User commUser1 = testdatafactory.createCommunityUser('childUser1','childUser1',communityUserContact.Id,true);
  }
  
  static testmethod void testExtractDataController(){
    YETI_TestDataFactory testdatafactory = new YETI_TestDataFactory();
    User use = [SELECT Id,firstname FROM User WHERE firstname =:'childUser1'];
    
    
    
    system.runas(use){
      Account acc = [SELECT Id,name From Account where name = 'parent account' limit 1];
      
      Case cs = testdatafactory.createCase('Test Case',acc.Id, true);
      CaseComment cscmnt = new CaseComment(ParentId = cs.Id, CommentBody = 'Test', IsPublished = true);
      insert cscmnt;
      
      system.assertEquals(true,cscmnt.Id != null);
      
      Id accountId = YETI_ExtractDataController.getAccountId();
      system.assertEquals(true,accountId != null); // To verify that community user has account associated.
      
      Account acct = YETI_ExtractDataController.getAccountDetails();
      system.assertEquals(true,acct.Id == acc.Id); // To verify that the account returned is same as the user's account.
      
      Id recrd  = YETI_ExtractDataController.getRecordIdToRedirect(cs.id);
      System.assertEquals(false ,recrd != null); // To verify that the no approval process returns id as null
      
      YETI_ExtractDataController.getAllCaseComments(cs.id);
      System.assertEquals(false, YETI_ExtractDataController.getAllCaseComments(cs.id).isEmpty()); // To verify Comments are inserted in the case.
      
      YETI_ExtractDataController.changeUserPassword('test@123','test@345','test@345');
      YETI_ExtractDataController.changeUserPassword('test@123','test@345','test@3456');
      
      YETI_ExtractDataController.fetchUserData();
      System.assertEquals(true, YETI_ExtractDataController.fetchUserData() != null);  // To verify profile wrapper has values populated.
      
      YETI_ExtractDataController.updateUserTimeZoneValue('America/Chicago');
      User usee = [SELECT TimeZoneSidKey, Id ,firstname FROM User WHERE firstname =:'childUser1'];
      system.assertEquals(true,usee.TimeZoneSidKey == 'America/Chicago'); // To verify time zone is updated.
    }
  }

}
/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  23rd March 2017
Name          :  YETI_InvoiceTriggerHandlerTest
Description   :  Test Class for YETI_InvoiceTrigger 
*/
@isTest
public class YETI_InvoiceTriggerHandlerTest {
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
    
    // Create account
    Account childAccount = testdatafactory.createAccount('Child Account1',false);
    childAccount.RecordTypeId = shipToRecordTypeId;
    childAccount.ParentId = parentAccount.Id;
    
    // Create account
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
    
    Invoice__c inv = testdatafactory.createInvoice('Invoice Test Recinv',parentAccount.Id,false);
    inv.Ship_to__c = childAccount.Id;
    inv.Sold_to__c = childAccount.Id;
    inv.Bill_to__c = childAccount.Id;
    insert inv;
    
    List<Invoice__c> lstInvoices = testdatafactory.createMultipleInvoice('Invoice Test Recinv',parentAccount.Id,5,true);
    
  }
  
  static testMethod void testOppUpdate() {
    Test.startTest();
      Set<Id> setinvIds = new Set<Id>();
      List<Invoice__c> lstInvoices = [SELECT Id, Name, Ship_To__c, Sold_to__c, Bill_to__c FROM Invoice__c WHERE Name LIKE '%Invoice Test Recinv%'];
      for(Invoice__c inv : lstInvoices){
        setinvIds.add(inv.Id);
      }
      
      Account acc = [SELECT Id, Name FROM Account WHERE Name =: 'Child Account2' LIMIT 1];
      List<User> lstUser = [SELECT id,Firstname FROM User WHERE firstname =: 'childUser1' OR firstName=: 'childUser2' Order by firstname];
      User use1 = lstUser[0]; 
      User use2 = lstUser[1];
      
      List<Invoice__c> lstinvToUpdate = new List<Invoice__c>();
      List<UserRecordAccess> lstUserRecinvAccess = [SELECT RecordId, HasReadAccess
                                                      FROM UserRecordAccess WHERE UserId =: use1.Id
                                                      AND RecordId In : setinvIds];
                                                      
      // The users will have access to the Invoice__c recinv where Invoice__c's account = user's contact's account.
      //system.assertEquals(true,lstUserRecinvAccess[0].HasReadAccess);
      for (Invoice__c inv : lstInvoices){
        inv.Ship_To__c = acc.Id;
        inv.Sold_to__c = acc.Id;
        inv.Bill_to__c = acc.Id;
        
        lstinvToUpdate.add(inv);
      }
      update lstinvToUpdate;
      
      List<UserRecordAccess> lstUserRecinvAccessAfterUpdate = [SELECT RecordId, HasReadAccess
                                                              FROM UserRecordAccess WHERE UserId =: use1.Id
                                                              AND RecordId In : setinvIds];
                                                              
      // The users will not have access to the Invoice__c recinv where Invoice__c's account != user's contact's account.                                                        
      //system.assertEquals(false,lstUserRecinvAccessAfterUpdate[0].HasReadAccess);
      
    Test.stopTest();
  }
}
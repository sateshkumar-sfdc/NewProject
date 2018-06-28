/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  24rd March 2017
Name          :  YETI_OrderTriggerHandlerTest
Description   :  Test Class for YETI_OrderTrigger 
*/
@isTest
public class YETI_OrderTriggerHandlerTest {
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
    
    Order__c ord = testdatafactory.createOrder('Order Test Record',parentAccount.Id,false);
    ord.Bill_To__c = childAccount.Id;
    ord.Sold_To__c = childAccount.Id;
    insert ord;
    
    List<Order__c> lstOrders = testdatafactory.createMultipleOrders('Order Test Record',parentAccount.Id,5,true);
    
  }
  
  static testMethod void testOppUpdate() {
    Test.startTest();
      Set<Id> setOrdIds = new Set<Id>();
      List<Order__c> lstOrders = [SELECT Id, Name, Ship_To__c,Bill_To__c,Sold_To__c FROM Order__c WHERE Name LIKE '%Order Test Record%'];
      for(Order__c ord : lstOrders){
        setOrdIds.add(ord.Id);
      }
      
      Account acc = [SELECT Id, Name FROM Account WHERE Name =: 'Child Account2' LIMIT 1];
      List<User> lstUser = [SELECT id,Firstname FROM User WHERE firstname =: 'childUser1' OR firstName=: 'childUser2' Order by firstname];
      User use1 = lstUser[0]; 
      User use2 = lstUser[1];
      
      List<Order__c> lstOrdToUpdate = new List<Order__c>();
      List<UserRecordAccess> lstUserRecordAccess = [SELECT RecordId, HasReadAccess
                                                      FROM UserRecordAccess WHERE UserId =: use1.Id
                                                      AND RecordId In : setOrdIds];
                                                      
      // The users will have access to the Order__c record where Order__c's account = user's contact's account.
      //system.assertEquals(true,lstUserRecordAccess[0].HasReadAccess);
      for (Order__c ord : lstOrders){
        ord.Ship_To__c = acc.Id;
        ord.Bill_To__c = acc.Id;
        ord.Sold_To__c = acc.Id;
        lstOrdToUpdate.add(ord);
      }
      update lstOrdToUpdate;
      
      List<UserRecordAccess> lstUserRecordAccessAfterUpdate = [SELECT RecordId, HasReadAccess
                                                              FROM UserRecordAccess WHERE UserId =: use1.Id
                                                              AND RecordId In : setOrdIds];
                                                              
      // The users will not have access to the Order__c record where Order__c's account != user's contact's account.                                                        
      //system.assertEquals(false,lstUserRecordAccessAfterUpdate[0].HasReadAccess);
      
    Test.stopTest();
  }
}
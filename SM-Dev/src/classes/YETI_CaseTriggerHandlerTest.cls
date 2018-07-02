/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  23rd March 2017
Name          :  YETI_CaseTriggerHandlerTest
Description   :  Test Class for YETI_CaseTrigger 
*/
@isTest
public class YETI_CaseTriggerHandlerTest {
  @testSetup
  static void createTestData() {
    YETI_TestDataFactory testdatafactory = new YETI_TestDataFactory();
    Id shipToRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship to').getRecordTypeId();

    // Create account
    Account parentAccount = testdatafactory.createAccount('Parent Account', false);
    parentAccount.RecordTypeId = shipToRecordTypeId;

    // Create account2
    Account parentAccount2 = testdatafactory.createAccount('Parent Account2', false);
    parentAccount2.RecordTypeId = shipToRecordTypeId;

    insert new List<Account> {
      parentAccount,
      parentAccount2
    };
    
    // Create account
    Account childAccount = testdatafactory.createAccount('Child Account1', false);
    childAccount.RecordTypeId = shipToRecordTypeId;
    childAccount.ParentId = parentAccount.Id;

    // Create account
    Account childAccount2 = testdatafactory.createAccount('Child Account2', false);
    childAccount2.RecordTypeId = shipToRecordTypeId;
    childAccount2.ParentId = parentAccount2.Id;

    insert new List<Account> {
      childAccount,
      childAccount2
    };

    Contact communityUserContact = testdatafactory.createContact(parentAccount.Id, 'Child Account', false);
    Contact communityUserContact2 = testdatafactory.createContact(parentAccount2.Id, 'Child Account2', false);
    insert new List<Contact> {
      communityUserContact,
      communityUserContact2
    };

    User commUser1 = testdatafactory.createCommunityUser('childUser1', 'childUser1', communityUserContact.Id, false);
    User commUser2 = testdatafactory.createCommunityUser('childUser2', 'childUser2', communityUserContact2.Id, false);
    insert new List<User> {
      commUser1,
      commUser2
    };

    Case cas = testdatafactory.createCase('Case Test Recinv',parentAccount.Id,false);
    cas.AccountId = childAccount.Id;
    cas.Trading_Post_Visible__c = true;
    insert cas;

    Case theCase = null;
    System.runAs(commUser2) {
      theCase = testdatafactory.createCase('Case Test Recinv', null, false);
      theCase.Trading_Post_Visible__c = true;
      insert theCase;
    }

    theCase.AccountId = parentAccount.Id;
    theCase.Trading_Post_Visible__c = false;
    update theCase;

    List<Case> lstCases = testdatafactory.createMultipleCase('Case Test Recinv', parentAccount.Id, 5, true);
  }

  static testMethod void testCaseUpdate() {
    Set<Id> setcasIds = new Set<Id>();
    List<Case> lstCases = [SELECT Id, Subject, AccountId FROM Case WHERE Subject LIKE '%Case Test Recinv%'];
    for(Case cas : lstCases) {
      setcasIds.add(cas.Id);
    }

    Account acc = [SELECT Id, Name FROM Account WHERE Name = :'Child Account2' LIMIT 1];

    List<User> lstUser = [SELECT id,Firstname FROM User WHERE firstname =: 'childUser1' OR firstName=: 'childUser2' Order by firstname];
      User use1 = lstUser[0]; 
      User use2 = lstUser[1];

    // The users will have access to the Case record where Case's account = user's contact's account.
    List<UserRecordAccess> lstUserRecinvAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId = :use1.Id
                                                  AND RecordId IN :setcasIds];
    //system.assertEquals(true,lstUserRecinvAccess[0].HasReadAccess);

    Test.startTest();

    List<Case> lstcasToUpdate = new List<Case>();
    for(Case cas : lstCases) {
      cas.AccountId = acc.Id;
      lstcasToUpdate.add(cas);
    }
    update lstcasToUpdate;

    Test.stopTest();

    // The users will not have access to the Case recinv where Case's account != user's contact's account.               
    List<UserRecordAccess> lstUserRecinvAccessAfterUpdate = [SELECT RecordId, HasReadAccess
                                                              FROM UserRecordAccess WHERE UserId =: use1.Id
                                                              AND RecordId In : setcasIds];
    //system.assertEquals(false,lstUserRecinvAccessAfterUpdate[0].HasReadAccess);
  }
}
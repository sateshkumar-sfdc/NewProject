//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Manager Name: YETI_CaseTriggerHandlerManager
// For Apex Trigger Handler: YETI_CaseTriggerHandler
// For Apex Trigger: YETI_CaseTrigger
// On SObject: Case
// Description: This apex trigger handler manager class implements the following functionalities:
//  1: Initiates case assignment rules for newly created cases since case assignment rules do not work with the Napili template for communities.
//  2: A dealer corporate user must have read access to all cases(Case) associated with partner user's contact account record and
//     its parent account record.
//
// 03rd March 2017    Hemendra Singh Bhati    Original (Task # T-581740) - Please see the task description for more details.
// 14th March 2017    Hemendra Singh Bhati    Modified (Task # T-580530) - Please see the task description for more details.
// 21st March 2017    Hemendra Singh Bhati    Modified (Task # T-586235) - Please see the task description for more details.
//
public without sharing class YETI_CaseTriggerHandlerManager {
  // Private Constants.
  private final Id DEALER_CORPORATE_PROFILE_ID = YETI_FunctionalUtility.DEALER_CORPORATE_PROFILE_ID;

  // Public Data Members.
  // Private Data Members.

  /*
  @method      : initiateCaseAssignmentRules
  @description : This method is used to initiate case assignment rules for newly created cases since case assignment rules do not
                 work with the Napili template for communities.
  @params      : List<Case> newValues
  @returns     : void
  */
  public void initiateCaseAssignmentRules(List<Case> newValues) {
    // Determining case record ids.
    Map<Id, Id> caseIdAndCreatedByIdMap = new Map<Id, Id>();
    for(Case theCase : newValues) {
      caseIdAndCreatedByIdMap.put(theCase.Id, theCase.CreatedById);
    }

    // Determining users with profile named "Dealer - Corporate".
    Set<Id> dealerCorporateUserIdSet = new Set<Id>();
    for(User theUser : [SELECT Id FROM User WHERE Id IN :caseIdAndCreatedByIdMap.values() AND ProfileId = :DEALER_CORPORATE_PROFILE_ID]) {
      dealerCorporateUserIdSet.add(theUser.Id);
    }

    // Initiate case assignment rules only if cases were created by "Dealer - Corporate" profile user.
    if(dealerCorporateUserIdSet.size() > 0) {
      // Instantiating DML options.
      Database.DMLOptions theDMLOptions = new Database.DMLOptions();
      theDMLOptions.AssignmentRuleHeader.useDefaultRule = true;

      // Updating newly created case records.
      List<Case> caseList = new List<Case>();
      for(Case theCase : [SELECT Id FROM Case WHERE Id IN: caseIdAndCreatedByIdMap.keySet() AND CreatedById IN :dealerCorporateUserIdSet]) {
        theCase.setOptions(theDMLOptions);
        caseList.add(theCase);
      }
      update caseList;
    }
  }

  /*
  @method      : deleteCaseShareRecords
  @description : This method is used to delete case share records.
  @params      : String revokeUserIdAndCaseIdsMapString
  @returns     : void
  */
  @future
  private static void deleteCaseShareRecords(String revokeUserIdAndCaseIdsMapString) {
    // Instantiating utility class.
    YETI_FunctionalUtility theUtility = new YETI_FunctionalUtility();

    // Deleting case share records.
    Map<Id, Set<Id>> revokeUserIdAndCaseIdsMap = (Map<Id, Set<Id>>)JSON.deserialize(revokeUserIdAndCaseIdsMapString, Map<Id, Set<Id>>.class);
    if(revokeUserIdAndCaseIdsMap.size() > 0) {
      theUtility.deleteCaseShareRecords(revokeUserIdAndCaseIdsMap);
      System.debug('TRACE: YETI_CaseTriggerHandlerManager - deleteCaseShareRecords - revokeUserIdAndCaseIdsMap - ' + revokeUserIdAndCaseIdsMap);
    }
  }

  /*
  @method      : insertCaseShareRecords
  @description : This method is used to insert case share records.
  @params      : String grantUserIdAndCaseIdsMapString
  @returns     : void
  */
  @future
  private static void insertCaseShareRecords(String grantUserIdAndCaseIdsMapString) {
    // Instantiating utility class.
    YETI_FunctionalUtility theUtility = new YETI_FunctionalUtility();

    // Inserting case share records.
    Map<Id, Set<Id>> grantUserIdAndCaseIdsMap = (Map<Id, Set<Id>>)JSON.deserialize(grantUserIdAndCaseIdsMapString, Map<Id, Set<Id>>.class);
    if(grantUserIdAndCaseIdsMap.size() > 0) {
      theUtility.insertCaseShareRecords(grantUserIdAndCaseIdsMap);
      System.debug('TRACE: YETI_CaseTriggerHandlerManager - insertCaseShareRecords - grantUserIdAndCaseIdsMap - ' + grantUserIdAndCaseIdsMap);
    }
  }

  /*
  @method      : grantRevokeAccessToCaseRecords
  @description : This method is used to grant/revoke access to/from case records for "Dealer - Corporate" profile user
                 with license "Partner Community Login".
  @params      : List<Case> newValues, Map<Id, Case> oldMap, Boolean isInsert
  @returns     : void
  */
  public void grantRevokeAccessToCaseRecords(List<Case> newValues, Map<Id, Case> oldMap, Boolean isInsert) {
    // Initializing data members.
    Set<Id> caseAccountIdsSet = new Set<Id>();
    Map<Id, Set<Id>> grantCaseIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<Id, Set<Id>> revokeCaseIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap = new Map<String, Id>();

    // Determining account ids for newly created/updated cases.
    if(isInsert) {
      for(Case theCase : newValues) {
        // New account id.
        if(theCase.Trading_Post_Visible__c == true && theCase.AccountId != null) {
          caseAccountIdsSet.add(theCase.AccountId);
          if(!grantCaseIdAndAccountIdsMap.containsKey(theCase.Id)) {
            grantCaseIdAndAccountIdsMap.put(theCase.Id, new Set<Id>());
          }
          grantCaseIdAndAccountIdsMap.get(theCase.Id).add(theCase.AccountId);
        }
      }
    }
    else {
      for(Case theCase : newValues) {
        // User changes case account.
        if(oldMap.get(theCase.Id).AccountId != theCase.AccountId && theCase.Trading_Post_Visible__c == true) {
          // Old account id.
          if(oldMap.get(theCase.Id).AccountId != null) {
            caseAccountIdsSet.add(oldMap.get(theCase.Id).AccountId);
            if(!revokeCaseIdAndAccountIdsMap.containsKey(theCase.Id)) {
              revokeCaseIdAndAccountIdsMap.put(theCase.Id, new Set<Id>());
            }
            revokeCaseIdAndAccountIdsMap.get(theCase.Id).add(oldMap.get(theCase.Id).AccountId);
          }

          // New account id.
          if(theCase.AccountId != null) {
            caseAccountIdsSet.add(theCase.AccountId);
            if(!grantCaseIdAndAccountIdsMap.containsKey(theCase.Id)) {
              grantCaseIdAndAccountIdsMap.put(theCase.Id, new Set<Id>());
            }
            grantCaseIdAndAccountIdsMap.get(theCase.Id).add(theCase.AccountId);
          }
        }

        // User changes trading post visible flag.
        if(oldMap.get(theCase.Id).Trading_Post_Visible__c != theCase.Trading_Post_Visible__c) {
          // Old trading post visible flag.
          if(oldMap.get(theCase.Id).Trading_Post_Visible__c == true) {
            if(theCase.AccountId != null) {
              caseAccountIdsSet.add(theCase.AccountId);
              if(!revokeCaseIdAndAccountIdsMap.containsKey(theCase.Id)) {
                revokeCaseIdAndAccountIdsMap.put(theCase.Id, new Set<Id>());
              }
              revokeCaseIdAndAccountIdsMap.get(theCase.Id).add(theCase.AccountId);
            }

            if(oldMap.get(theCase.Id).AccountId != null) {
              caseAccountIdsSet.add(oldMap.get(theCase.Id).AccountId);
              if(!revokeCaseIdAndAccountIdsMap.containsKey(theCase.Id)) {
                revokeCaseIdAndAccountIdsMap.put(theCase.Id, new Set<Id>());
              }
              revokeCaseIdAndAccountIdsMap.get(theCase.Id).add(oldMap.get(theCase.Id).AccountId);
            }
          }

          // New trading post visible flag.
          if(theCase.Trading_Post_Visible__c == true && theCase.AccountId != null) {
            caseAccountIdsSet.add(theCase.AccountId);
            if(!grantCaseIdAndAccountIdsMap.containsKey(theCase.Id)) {
              grantCaseIdAndAccountIdsMap.put(theCase.Id, new Set<Id>());
            }
            grantCaseIdAndAccountIdsMap.get(theCase.Id).add(theCase.AccountId);
          }
        }
      }
    }
    System.debug('TRACE: YETI_CaseTriggerHandlerManager - grantRevokeAccessToCaseRecords - caseAccountIdsSet - ' + caseAccountIdsSet);
    System.debug('TRACE: YETI_CaseTriggerHandlerManager - grantRevokeAccessToCaseRecords - revokeCaseIdAndAccountIdsMap - ' + revokeCaseIdAndAccountIdsMap);
    System.debug('TRACE: YETI_CaseTriggerHandlerManager - grantRevokeAccessToCaseRecords - grantCaseIdAndAccountIdsMap - ' + grantCaseIdAndAccountIdsMap);

    // Instantiating utility class.
    YETI_FunctionalUtility theUtility = new YETI_FunctionalUtility();

    // Determining parent accounts ids.
    if(caseAccountIdsSet.size() > 0) {
      theChildAccountIdsAndItsParentAccountIdMap = theUtility.determineParentAccountIds(caseAccountIdsSet);
      if(theChildAccountIdsAndItsParentAccountIdMap.size() > 0) {
        caseAccountIdsSet.addAll(theChildAccountIdsAndItsParentAccountIdMap.values());
      }
      System.debug('TRACE: YETI_CaseTriggerHandlerManager - grantRevokeAccessToCaseRecords - caseAccountIdsSet - ' + caseAccountIdsSet);
    }

    // Determining partner user ids for account ids filtered above.
    Map<Id, Set<Id>> theAccountIdAndUserIdsMap = new Map<Id, Set<Id>>();
    if(caseAccountIdsSet.size() > 0) {
      theAccountIdAndUserIdsMap = theUtility.extractPartnerUserIds(caseAccountIdsSet);
    }
    System.debug('TRACE: YETI_CaseTriggerHandlerManager - grantRevokeAccessToCaseRecords - theAccountIdAndUserIdsMap - ' + theAccountIdAndUserIdsMap);

    // Granting/revoking access to/from case records filtered above.
    if(theAccountIdAndUserIdsMap.size() > 0) {
      // Initializing data members.
      Id theParentAccountId = null;
      Map<Id, Set<Id>> grantUserIdAndCaseIdsMap = new Map<Id, Set<Id>>();
      Map<Id, Set<Id>> revokeUserIdAndCaseIdsMap = new Map<Id, Set<Id>>();

      // Revoking access from case records filtered above.
      if(revokeCaseIdAndAccountIdsMap.size() > 0) {
        for(Id theCaseId : revokeCaseIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : revokeCaseIdAndAccountIdsMap.get(theCaseId)) {
            // Revoking access from case account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!revokeUserIdAndCaseIdsMap.containsKey(theUserId)) {
                  revokeUserIdAndCaseIdsMap.put(theUserId, new Set<Id>());
                }
                revokeUserIdAndCaseIdsMap.get(theUserId).add(theCaseId);
              }
            }

            // Revoking access from case account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!revokeUserIdAndCaseIdsMap.containsKey(theUserId)) {
                    revokeUserIdAndCaseIdsMap.put(theUserId, new Set<Id>());
                  }
                  revokeUserIdAndCaseIdsMap.get(theUserId).add(theCaseId);
                }
              }
            }
          }
        }
        System.debug('TRACE: YETI_CaseTriggerHandlerManager - grantRevokeAccessToCaseRecords - revokeUserIdAndCaseIdsMap - ' + revokeUserIdAndCaseIdsMap);

        // Revoking case records access.
        if(revokeUserIdAndCaseIdsMap.size() > 0) {
          deleteCaseShareRecords(JSON.serialize(revokeUserIdAndCaseIdsMap));
        }
      }

      // Granting access to case records filtered above.
      if(grantCaseIdAndAccountIdsMap.size() > 0) {
        for(Id theCaseId : grantCaseIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : grantCaseIdAndAccountIdsMap.get(theCaseId)) {
            // Granting access to case account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!grantUserIdAndCaseIdsMap.containsKey(theUserId)) {
                  grantUserIdAndCaseIdsMap.put(theUserId, new Set<Id>());
                }
                grantUserIdAndCaseIdsMap.get(theUserId).add(theCaseId);
              }
            }

            // Granting access to case account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!grantUserIdAndCaseIdsMap.containsKey(theUserId)) {
                    grantUserIdAndCaseIdsMap.put(theUserId, new Set<Id>());
                  }
                  grantUserIdAndCaseIdsMap.get(theUserId).add(theCaseId);
                }
              }
            }
          }
        }
        System.debug('TRACE: YETI_CaseTriggerHandlerManager - grantRevokeAccessToCaseRecords - grantUserIdAndCaseIdsMap - ' + grantUserIdAndCaseIdsMap);

        // Granting case records access.
        if(grantUserIdAndCaseIdsMap.size() > 0) {
          insertCaseShareRecords(JSON.serialize(grantUserIdAndCaseIdsMap));
        }
      }
    }
  }
}
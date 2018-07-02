//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Manager Name: YETI_OpportunityTriggerHandlerManager
// For Apex Trigger Handler: YETI_OpportunityTriggerHandler
// For Apex Trigger: YETI_OpportunityTrigger
// On SObject: Opportunity
// Description: This apex trigger handler manager class implements the following functionalities:
//  1: A dealer corporate user must have read access to all opportunities(Opportunity) associated with partner user's contact account record and
//     its parent account record.
//  2: A dealer should not be able to reject any approval process without comment.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
// 22nd March 2017    Hemendra Singh Bhati    Modified (Task # T-586235) - Please see the task description for more details.
// 23rd March 2017    Rakshit Virmani         Modified (Task # T-587233) - Please see the task description for more details.
//
public without sharing class YETI_OpportunityTriggerHandlerManager {
  // Private Constants.
  // Private Data Members.
  // Public Data Members.

  /*
  @method      : grantRevokeAccessToOpportunityRecords
  @description : This method is used to grant/revoke access to/from opportunity records for "Dealer - Corporate" profile user
                 with license "Partner Community Login".
  @params      : List<Opportunity> newValues, Map<Id, Opportunity> oldMap, Boolean isInsert
  @returns     : void
  */
  public void grantRevokeAccessToOpportunityRecords(List<Opportunity> newValues, Map<Id, Opportunity> oldMap, Boolean isInsert) {
    // Initializing data members.
    Set<Id> opportunityAccountIds = new Set<Id>();
    Set<String> allowedOpportunityStages = new Set<String> {
      'Pending Prebook',
      'Approved Prebook',
      'Finalized Prebook'
    };
    Map<Id, Set<Id>> grantOpportunityIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<Id, Set<Id>> revokeOpportunityIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap = new Map<String, Id>();

    // Processing newly inserted opportunity records.
    if(isInsert) {
      for(Opportunity theOpportunity : newValues) {
        if(allowedOpportunityStages.contains(theOpportunity.StageName)) {
          if(!grantOpportunityIdAndAccountIdsMap.containsKey(theOpportunity.Id)) {
            grantOpportunityIdAndAccountIdsMap.put(theOpportunity.Id, new Set<Id>());
          }

          if(theOpportunity.AccountId != null) {
            opportunityAccountIds.add(theOpportunity.AccountId);
            grantOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(theOpportunity.AccountId);
          }
          if(theOpportunity.Ship_To__c != null) {
            opportunityAccountIds.add(theOpportunity.Ship_To__c);
            grantOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(theOpportunity.Ship_To__c);
          }
        }
      }
    }
    // Processing newly updated opportunity records.
    else {
      for(Opportunity theOpportunity : newValues) {
        // Grant access to opportunity records mapping.
        if(!grantOpportunityIdAndAccountIdsMap.containsKey(theOpportunity.Id)) {
          grantOpportunityIdAndAccountIdsMap.put(theOpportunity.Id, new Set<Id>());
        }

        // Revoke access to opportunity records mapping.
        if(!revokeOpportunityIdAndAccountIdsMap.containsKey(theOpportunity.Id)) {
          revokeOpportunityIdAndAccountIdsMap.put(theOpportunity.Id, new Set<Id>());
        }

        // Opportunity account changed.
        if(oldMap.get(theOpportunity.Id).AccountId != theOpportunity.AccountId && allowedOpportunityStages.contains(theOpportunity.StageName)) {
          // Old opportunity account id.
          if(oldMap.get(theOpportunity.Id).AccountId != null) {
            opportunityAccountIds.add(oldMap.get(theOpportunity.Id).AccountId);
            revokeOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(oldMap.get(theOpportunity.Id).AccountId);
          }

          // New opportunity account id.
          if(theOpportunity.AccountId != null) {
            opportunityAccountIds.add(theOpportunity.AccountId);
            grantOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(theOpportunity.AccountId);
          }
        }

        // Ship to account changed.
        if(oldMap.get(theOpportunity.Id).Ship_To__c != theOpportunity.Ship_To__c && allowedOpportunityStages.contains(theOpportunity.StageName)) {
          // Old ship to account id.
          if(oldMap.get(theOpportunity.Id).Ship_To__c != null) {
            opportunityAccountIds.add(oldMap.get(theOpportunity.Id).Ship_To__c);
            revokeOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(oldMap.get(theOpportunity.Id).Ship_To__c);
          }

          // New ship to account id.
          if(theOpportunity.Ship_To__c != null) {
            opportunityAccountIds.add(theOpportunity.Ship_To__c);
            grantOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(theOpportunity.Ship_To__c);
          }
        }

        // Opportunity stage changed.
        if(oldMap.get(theOpportunity.Id).StageName != theOpportunity.StageName) {
          // New opportunity stage name is not in allowed stage names.
          if(!allowedOpportunityStages.contains(theOpportunity.StageName)) {
            // Revoke opportunity access from account partner users.
            if(theOpportunity.AccountId != null) {
              opportunityAccountIds.add(theOpportunity.AccountId);
              revokeOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(theOpportunity.AccountId);
            }

            // Revoke opportunity access from ship to account partner users.
            if(theOpportunity.Ship_To__c != null) {
              opportunityAccountIds.add(theOpportunity.Ship_To__c);
              revokeOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(theOpportunity.Ship_To__c);
            }
          }

          // New opportunity stage name is in allowed stage names.
          if(allowedOpportunityStages.contains(theOpportunity.StageName)) {
            // Grant opportunity access to account partner users.
            if(theOpportunity.AccountId != null) {
              opportunityAccountIds.add(theOpportunity.AccountId);
              grantOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(theOpportunity.AccountId);
            }

            // Grant opportunity access to ship to account partner users.
            if(theOpportunity.Ship_To__c != null) {
              opportunityAccountIds.add(theOpportunity.Ship_To__c);
              grantOpportunityIdAndAccountIdsMap.get(theOpportunity.Id).add(theOpportunity.Ship_To__c);
            }
          }
        }
      }
    }
    System.debug('TRACE: YETI_OpportunityTriggerHandlerManager - grantRevokeAccessToOpportunityRecords - opportunityAccountIds - ' + opportunityAccountIds);
    System.debug('TRACE: YETI_OpportunityTriggerHandlerManager - grantRevokeAccessToOpportunityRecords - revokeOpportunityIdAndAccountIdsMap - ' + revokeOpportunityIdAndAccountIdsMap);
    System.debug('TRACE: YETI_OpportunityTriggerHandlerManager - grantRevokeAccessToOpportunityRecords - grantOpportunityIdAndAccountIdsMap - ' + grantOpportunityIdAndAccountIdsMap);

    // Instantiating utility class.
    YETI_FunctionalUtility theUtility = new YETI_FunctionalUtility();

    // Determining parent accounts ids.
    if(opportunityAccountIds.size() > 0) {
      theChildAccountIdsAndItsParentAccountIdMap = theUtility.determineParentAccountIds(opportunityAccountIds);
      if(theChildAccountIdsAndItsParentAccountIdMap.size() > 0) {
        opportunityAccountIds.addAll(theChildAccountIdsAndItsParentAccountIdMap.values());
      }
      System.debug('TRACE: YETI_OpportunityTriggerHandlerManager - grantRevokeAccessToOpportunityRecords - opportunityAccountIds - ' + opportunityAccountIds);
    }

    // Determining partner user ids for account ids filtered above.
    Map<Id, Set<Id>> theAccountIdAndUserIdsMap = new Map<Id, Set<Id>>();
    if(opportunityAccountIds.size() > 0) {
      theAccountIdAndUserIdsMap = theUtility.extractPartnerUserIds(opportunityAccountIds);
    }

    // Granting/revoking access to/from opportunity records filtered above.
    if(theAccountIdAndUserIdsMap.size() > 0) {
      // Initializing data members.
      Id theParentAccountId = null;

      // Revoking access from opportunity records filtered above.
      if(revokeOpportunityIdAndAccountIdsMap.size() > 0) {
        Map<Id, Set<Id>> theUserIdAndOpportunityIdsMap = new Map<Id, Set<Id>>();
        for(Id theOpportunityId : revokeOpportunityIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : revokeOpportunityIdAndAccountIdsMap.get(theOpportunityId)) {
            // Revoking access from opportunity account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!theUserIdAndOpportunityIdsMap.containsKey(theUserId)) {
                  theUserIdAndOpportunityIdsMap.put(theUserId, new Set<Id>());
                }
                theUserIdAndOpportunityIdsMap.get(theUserId).add(theOpportunityId);
              }
            }

            // Revoking access from opportunity account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!theUserIdAndOpportunityIdsMap.containsKey(theUserId)) {
                    theUserIdAndOpportunityIdsMap.put(theUserId, new Set<Id>());
                  }
                  theUserIdAndOpportunityIdsMap.get(theUserId).add(theOpportunityId);
                }
              }
            }
          }
        }

        // Revoking access from opportunity records.
        if(theUserIdAndOpportunityIdsMap.size() > 0) {
          theUtility.deleteOpportunityShareRecords(theUserIdAndOpportunityIdsMap);
        }
      }

      // Granting access to opportunity records filtered above.
      if(grantOpportunityIdAndAccountIdsMap.size() > 0) {
        Map<Id, Set<Id>> theUserIdAndOpportunityIdsMap = new Map<Id, Set<Id>>();
        for(Id theOpportunityId : grantOpportunityIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : grantOpportunityIdAndAccountIdsMap.get(theOpportunityId)) {
            // Granting access to opportunity account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!theUserIdAndOpportunityIdsMap.containsKey(theUserId)) {
                  theUserIdAndOpportunityIdsMap.put(theUserId, new Set<Id>());
                }
                theUserIdAndOpportunityIdsMap.get(theUserId).add(theOpportunityId);
              }
            }

            // Granting access to opportunity account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!theUserIdAndOpportunityIdsMap.containsKey(theUserId)) {
                    theUserIdAndOpportunityIdsMap.put(theUserId, new Set<Id>());
                  }
                  theUserIdAndOpportunityIdsMap.get(theUserId).add(theOpportunityId);
                }
              }
            }
          }
        }

        // Granting access to opportunity records.
        if(theUserIdAndOpportunityIdsMap.size() > 0) {
          theUtility.insertOpportunityShareRecords(theUserIdAndOpportunityIdsMap);
        }
      }
    }
  }

  /*
  @method      : makeCommentCompulsory
  @description : This method is used to ensure that the comments are added when a user rejects a record to be approved.
  @params      : List<Opportunity> newValues, Map<Id, Opportunity> oldMap
  @returns     : void
  */
  public void makeCommentCompulsory(List<Opportunity> newValues, Map<Id, Opportunity> oldMap) {
    Map<Id, Opportunity> rejectedStatements = new Map<Id, Opportunity>();
    for(Opportunity inv : newValues) {
      if(oldMap.get(inv.Id).Approval_Status__c != inv.Approval_Status__c && inv.Approval_Status__c == 'Rejected') {
        rejectedStatements.put(inv.Id, inv);
      }
    }

    if(!rejectedStatements.isEmpty()) {
      List<Id> processInstanceIds = new List<Id>();
      for(Opportunity invs : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1)
                              FROM Opportunity WHERE ID IN :rejectedStatements.keySet()]) {
        processInstanceIds.add(invs.ProcessInstances[0].Id);
      }

      // Now that we have the most recent process instances, we can check the most recent process steps for comments.  
      for(ProcessInstance pi : [SELECT TargetObjectId, (SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1)
                                FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC]) {
        if((pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0)) {
          rejectedStatements.get(pi.TargetObjectId).addError(Label.YETI_OpportunityTrigger_RejectionMessageText);
        }
      }
    }
  }
}
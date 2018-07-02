//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Name: YETI_OpportunityTriggerHandler
// For Apex Trigger: YETI_OpportunityTrigger
// On SObject: Opportunity
// Description: This apex trigger handler class implements the following functionalities:
//  1: A dealer corporate user must have read access to all opportunities(Opportunity) associated with partner user's contact account record and
//     its parent account record.
//  2: A dealer should not be able to reject any approval process without comment.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
// 23rd March 2017    Rakshit Virmani         Modified (Task # T-587233) - Please see the task description for more details.
//
public without sharing class YETI_OpportunityTriggerHandler {
  // Private Data Members.
  private Integer batchSize = 0;
  private Boolean isExecuting = false;
  private YETI_OpportunityTriggerHandlerManager theManager = null;

  // Class Default Constructor.
  public YETI_OpportunityTriggerHandler(Boolean isExecuting, Integer size) {
        batchSize = size;
    isExecuting = isExecuting;
    theManager = new YETI_OpportunityTriggerHandlerManager();
  }

  /*
  @method      : onAfterInsertUpdate
  @description : This method is called on after insert/update trigger event.
  @params      : List<Opportunity> newValues, Map<Id, Opportunity> oldMap, Boolean isInsert
  @returns     : void
  */
  public void onAfterInsertUpdate(List<Opportunity> newValues, Map<Id, Opportunity> oldMap, Boolean isInsert) {
    // Grant/revoke access to/from opportunity records for "Dealer - Corporate" profile user with license "Partner Community Login".
    theManager.grantRevokeAccessToOpportunityRecords(newValues, oldMap, isInsert);
  }

  /*
  @method      : onBeforeUpdate
  @description : This method is called on before update trigger event.
  @params      : List<Opportunity> newValues, Map<Id, Opportunity> oldMap
  @returns     : void
  */
  public void onBeforeUpdate(List<Opportunity> newValues, Map<Id, Opportunity> oldMap) {
    // A dealer should not be able to reject any approval process without comment.
    theManager.makeCommentCompulsory(newValues, oldMap);
  }
}
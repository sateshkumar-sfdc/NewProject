//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Name: YETI_CaseTriggerHandler
// For Apex Trigger: YETI_CaseTrigger
// On SObject: Case
// Description: This apex trigger handler class implements the following functionalities:
//  1: Initiates case assignment rules for newly created cases since case assignment rules do not work with the Napili template for communities.
//  2: A dealer corporate user must have read access to all cases(Case) associated with partner user's contact account record and
//     its parent account record.
//
// 03rd March 2017    Hemendra Singh Bhati    Original (Task # T-581740) - Please see the task description for more details.
// 14th March 2017    Hemendra Singh Bhati    Modified (Task # T-580530) - Please see the task description for more details.
//
public without sharing class YETI_CaseTriggerHandler {
  // Private Data Members.
  private Integer batchSize = 0;
  private Boolean isExecuting = false;
  private YETI_CaseTriggerHandlerManager theManager = null;

  // Class Default Constructor.
  public YETI_CaseTriggerHandler(Boolean isExecuting, Integer size) {
		batchSize = size;
    isExecuting = isExecuting;
    theManager = new YETI_CaseTriggerHandlerManager();
  }

  /*
  @method      : onAfterInsertUpdate
  @description : This method is called on after insert/update trigger event.
  @params      : List<Case> newValues, Map<Id, Case> oldMap, Boolean isInsert
  @returns     : void
  */
  public void onAfterInsertUpdate(List<Case> newValues, Map<Id, Case> oldMap, Boolean isInsert) {
    // Initiating case assignment rules for newly created cases.
    if(isInsert) {
      theManager.initiateCaseAssignmentRules(newValues);
    }

    // Grant/revoke access to/from case records for "Dealer - Corporate" profile user with license "Partner Community Login".
    theManager.grantRevokeAccessToCaseRecords(newValues, oldMap, isInsert);
  }
}
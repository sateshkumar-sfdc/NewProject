//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Name: YETI_OrderTriggerHandler
// For Apex Trigger: YETI_OrderTrigger
// On SObject: Order__c
// Description: This apex trigger handler class implements the following functionalities:
//  1: A dealer corporate user must have read access to all orders(Order__c) associated with partner user's contact account record and
//     its parent account record.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
//
public without sharing class YETI_OrderTriggerHandler {
  // Private Data Members.
  private Integer batchSize = 0;
  private Boolean isExecuting = false;
  private YETI_OrderTriggerHandlerManager theManager = null;

  // Class Default Constructor.
  public YETI_OrderTriggerHandler(Boolean isExecuting, Integer size) {
		batchSize = size;
    isExecuting = isExecuting;
    theManager = new YETI_OrderTriggerHandlerManager();
  }

  /*
  @method      : onAfterInsertUpdate
  @description : This method is called on after insert/update trigger event.
  @params      : List<Order__c> newValues, Map<Id, Order__c> oldMap, Boolean isInsert
  @returns     : void
  */
  public void onAfterInsertUpdate(List<Order__c> newValues, Map<Id, Order__c> oldMap, Boolean isInsert) {
    // Grant/revoke access to/from order records for "Dealer - Corporate" profile user with license "Partner Community Login".
    theManager.grantRevokeAccessToOrderRecords(newValues, oldMap, isInsert);
  }
}
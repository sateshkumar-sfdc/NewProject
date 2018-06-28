//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Name: YETI_DeliveryTriggerHandler
// For Apex Trigger: YETI_DeliveryTrigger
// On SObject: Deliveries__c
// Description: This apex trigger handler class implements the following functionalities:
//  1: A dealer corporate user must have read access to all deliveries(Deliveries__c) associated with partner user's contact account record and
//     its parent account record.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
//
public without sharing class YETI_DeliveryTriggerHandler {
  // Private Data Members.
  private Integer batchSize = 0;
  private Boolean isExecuting = false;
  private YETI_DeliveryTriggerHandlerManager theManager = null;

  // Class Default Constructor.
  public YETI_DeliveryTriggerHandler(Boolean isExecuting, Integer size) {
		batchSize = size;
    isExecuting = isExecuting;
    theManager = new YETI_DeliveryTriggerHandlerManager();
  }

  /*
  @method      : onAfterInsertUpdate
  @description : This method is called on after insert/update trigger event.
  @params      : List<Deliveries__c> newValues, Map<Id, Deliveries__c> oldMap, Boolean isInsert
  @returns     : void
  */
  public void onAfterInsertUpdate(List<Deliveries__c> newValues, Map<Id, Deliveries__c> oldMap, Boolean isInsert) {
    // Grant/revoke access to/from deliveries records for "Dealer - Corporate" profile user with license "Partner Community Login".
    theManager.grantRevokeAccessToDeliveryRecords(newValues, oldMap, isInsert);
  }
}
//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Name: YETI_OrderTrigger
// On SObject: Order__c
// Description: This apex trigger implements the following functionalities:
//  1: A dealer corporate user must have read access to all orders(Order__c) associated with partner user's contact account record and
//     its parent account record.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
//
trigger YETI_OrderTrigger on Order__c(after insert, after update) {
  // Determining whether the order trigger is ON or OFF.
  if(YETI_FunctionalUtility.isTriggerActive('YETI_OrderTrigger')) {
    // Instantiating order trigger handler.
    YETI_OrderTriggerHandler theOrderTriggerHandler = new YETI_OrderTriggerHandler(Trigger.isExecuting, Trigger.size);

    // Handling trigger events.
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
      theOrderTriggerHandler.onAfterInsertUpdate(trigger.new, trigger.oldMap, trigger.isInsert);
    }
  }
}
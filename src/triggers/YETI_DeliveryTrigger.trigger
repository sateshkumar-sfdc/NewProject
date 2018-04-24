//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Name: YETI_DeliveryTrigger
// On SObject: Deliveries__c
// Description: This apex trigger implements the following functionalities:
//  1: A dealer corporate user must have read access to all deliveries(Deliveries__c) associated with partner user's contact account record and
//     its parent account record.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
//
trigger YETI_DeliveryTrigger on Deliveries__c(after insert, after update) {
  // Determining whether the delivery trigger is ON or OFF.
  if(YETI_FunctionalUtility.isTriggerActive('YETI_DeliveryTrigger')) {
    // Instantiating delivery trigger handler.
    YETI_DeliveryTriggerHandler theDeliveryTriggerHandler = new YETI_DeliveryTriggerHandler(Trigger.isExecuting, Trigger.size);

    // Handling trigger events.
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
      theDeliveryTriggerHandler.onAfterInsertUpdate(trigger.new, trigger.oldMap, trigger.isInsert);
    }
  }
}
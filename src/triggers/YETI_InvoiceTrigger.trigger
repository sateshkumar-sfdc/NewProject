//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Name: YETI_InvoiceTrigger
// On SObject: Invoice__c
// Description: This apex trigger implements the following functionalities:
//  1: A dealer corporate user must have read access to all invoices(Invoice__c) associated with partner user's contact account record and
//     its parent account record.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
//
trigger YETI_InvoiceTrigger on Invoice__c(after insert, after update) {
  // Determining whether the invoice trigger is ON or OFF.
  if(YETI_FunctionalUtility.isTriggerActive('YETI_InvoiceTrigger')) {
    // Instantiating invoice trigger handler.
    YETI_InvoiceTriggerHandler theInvoiceTriggerHandler = new YETI_InvoiceTriggerHandler(Trigger.isExecuting, Trigger.size);

    // Handling trigger events.
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
      theInvoiceTriggerHandler.onAfterInsertUpdate(trigger.new, trigger.oldMap, trigger.isInsert);
    }
  }
}
//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Name: YETI_OpportunityTrigger
// On SObject: Opportunity
// Description: This apex trigger implements the following functionalities:
//  1: A dealer corporate user must have read access to all opportunities(Opportunity) associated with partner user's contact account record and
//     its parent account record.
//  2: A dealer should not be able to reject any approval process without comment.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
// 23rd March 2017    Rakshit Virmani         Modified (Task # T-587233) - Please see the task description for more details.
//
trigger YETI_OpportunityTrigger on Opportunity(after insert, after update, before update) {
  // Determining whether the opportunity trigger is ON or OFF.
  if(YETI_FunctionalUtility.isTriggerActive('YETI_OpportunityTrigger')) {
    // Instantiating opportunity trigger handler.
    YETI_OpportunityTriggerHandler theOpportunityTriggerHandler = new YETI_OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);

    // Handling trigger events.
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
      theOpportunityTriggerHandler.onAfterInsertUpdate(trigger.new, trigger.oldMap, trigger.isInsert);
    }
    if(trigger.isBefore && trigger.isUpdate) {
      theOpportunityTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
    }
  }
}
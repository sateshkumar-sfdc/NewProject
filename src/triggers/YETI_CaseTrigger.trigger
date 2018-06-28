//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger: YETI_CaseTrigger
// On SObject: Case
// Description: This apex trigger class implements the following functionalities:
//  1: Initiates case assignment rules for newly created cases since case assignment rules do not work with the Napili template for communities.
//  2: A dealer corporate user must have read access to all cases(Case) associated with partner user's contact account record and
//     its parent account record.
//
// 03rd March 2017    Hemendra Singh Bhati    Original (Task # T-581740) - Please see the task description for more details.
// 14th March 2017    Hemendra Singh Bhati    Modified (Task # T-580530) - Please see the task description for more details.
//
trigger YETI_CaseTrigger on Case(after insert, after update) {
  // Determining whether the case trigger is ON or OFF.
  if(YETI_FunctionalUtility.isTriggerActive('YETI_CaseTrigger')) {
    // Instantiating case trigger handler.
    YETI_CaseTriggerHandler theCaseTriggerHandler = new YETI_CaseTriggerHandler(Trigger.isExecuting, Trigger.size);

    // Handling trigger events.
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
      theCaseTriggerHandler.onAfterInsertUpdate(trigger.new, trigger.oldMap, trigger.isInsert);
    }
  }
}
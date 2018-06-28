trigger BeforeCaseTrigger on Case (before Insert) {
    CaseNRAOwnerAssignment.updateOwner(trigger.new);
}
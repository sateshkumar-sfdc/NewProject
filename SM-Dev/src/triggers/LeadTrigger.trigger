trigger LeadTrigger on Lead (before insert, before update) {
        
        if (trigger.isBefore) {
        if (trigger.isInsert) {
            LeadUtil.leadAssignment(Trigger.New);
        }
    }
       
         if (trigger.isUpdate) {
            LeadUtil.leadAssignment(Trigger.New);
            
         
    

}
}
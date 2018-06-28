global class scheduler_OpportunityPermissionSynch  implements Schedulable {
    global void execute(SchedulableContext SC) {
        string s = 'Select Id from Account';
        Batch_OpportunityPermissionSynch  obj = new Batch_OpportunityPermissionSynch(s);
        Database.executeBatch(obj,100);
    }
}
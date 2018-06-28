global class scheduler_CasePermissionSynch  implements Schedulable {
    global void execute(SchedulableContext SC) {
        string s = 'Select Id from Account';
        Batch_CasePermissionSynch  obj = new Batch_CasePermissionSynch(s);
        Database.executeBatch(obj,100);
    }
}
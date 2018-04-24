global class scheduler_OrderPermissionSynch  implements Schedulable {
    global void execute(SchedulableContext SC) {
        string s = 'Select Id from Account';
        Batch_OrderPermissionSynch  obj = new Batch_OrderPermissionSynch(s);
        Database.executeBatch(obj,100);
    }
}
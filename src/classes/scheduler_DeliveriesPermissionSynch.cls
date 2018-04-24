global class scheduler_DeliveriesPermissionSynch  implements Schedulable {
    global void execute(SchedulableContext SC) {
        string s = 'Select Id from Account';
        Batch_DeliveriesPermissionSynch  obj = new Batch_DeliveriesPermissionSynch(s);
        Database.executeBatch(obj,100);
    }
}
global class scheduler_InvoicePermissionSynch  implements Schedulable {
    global void execute(SchedulableContext SC) {
        string s = 'Select Id from Account';
        Batch_InvoicePermissionSynch  obj = new Batch_InvoicePermissionSynch(s);
        Database.executeBatch(obj,100);
    }
}
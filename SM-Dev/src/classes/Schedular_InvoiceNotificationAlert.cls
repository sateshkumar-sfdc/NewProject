global class Schedular_InvoiceNotificationAlert implements Schedulable {

    global void execute(SchedulableContext ctx) {
        Batch_InvoiceNotificationAlert b = new Batch_InvoiceNotificationAlert();
        Database.executebatch(b);
    }
    
}
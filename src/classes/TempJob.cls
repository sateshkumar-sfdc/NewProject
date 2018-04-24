global class TempJob implements Schedulable{
    
    global void execute(SchedulableContext SC) {

      //  List<acSales__Order__c> ordersToRestore = [SELECT Id FROM acSales__Order__c WHERE IsDeleted = true AND LastModifiedDate > 2015-02-05T08:47:00.000Z AND LastModifiedDate < 2015-02-05T09:46:00.000Z LIMIT 10000 ALL ROWS];
        //database.undelete(ordersToRestore,false);

    }

}
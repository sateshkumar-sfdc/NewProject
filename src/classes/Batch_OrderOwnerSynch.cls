//select Id,Name,ownerId,Sold_To__r.OwnerId  from Order__c where  Sold_To__r.Owner.isActive = true
global class Batch_OrderOwnerSynch implements Database.Batchable<sObject>{
    global string query;    
    global Batch_OrderOwnerSynch(string q){
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Order__c> scope){
        for(Order__c i: scope){
            if(i.Sold_To__r.OwnerId <> i.OwnerId){
                i.ownerId = i.Sold_To__r.OwnerId;
            }
        }
        Database.update(scope,false);        
    }    

    global void finish(Database.BatchableContext bc){
    }   
}
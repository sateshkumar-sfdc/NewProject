//select Id,Name,ownerId,Sold_To__r.OwnerId  from deliveries__c where  Sold_To__r.Owner.isActive = true
global class Batch_deliveriesOwnerSynch implements Database.Batchable<sObject>{
    global string query;    
    global Batch_deliveriesOwnerSynch(string q){
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<deliveries__c> scope){
        for(deliveries__c i: scope){
            if(i.Sold_To__r.OwnerId <> i.OwnerId){
                i.ownerId = i.Sold_To__r.OwnerId;
            }
        }
        Database.update(scope,false);        
    }    

    global void finish(Database.BatchableContext bc){
    }   
}
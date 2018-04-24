//select Id,Name,ownerId,Sold_To__r.OwnerId  from Invoice__c where  Sold_To__r.Owner.isActive = true
global class Batch_InvoiceOwnerSynch implements Database.Batchable<sObject>{
    global string query;    
    global Batch_InvoiceOwnerSynch(string q){
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Invoice__c> scope){
        for(Invoice__c i: scope){
            if(i.Sold_To__r.OwnerId <> i.OwnerId){
                i.ownerId = i.Sold_To__r.OwnerId;
            }
        }
        Database.update(scope,false);        
    }    

    global void finish(Database.BatchableContext bc){
    }   
}
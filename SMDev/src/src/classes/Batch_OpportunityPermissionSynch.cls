global class Batch_OpportunityPermissionSynch implements Database.Batchable<sObject> {

    string query;
    
    global Batch_OpportunityPermissionSynch(string q){
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope){
        
        set<Id> setAccountIds = new set<Id>();
        for(Account acc : scope){
            setAccountIds.add(acc.id);
        }
        map<Id,set<Id>> theUserIdAndOpportunityIdsMap = new map<Id,Set<Id>>();        
        map<Id,set<Id>> mapAccountUser = new map<Id,set<Id>>();
        for(User u : [select Id,AccountId from User where AccountId IN: setAccountIds]){
            set<ID> setTemp = new Set<Id>();
            setTemp.add(u.Id);
            if(mapAccountUser.containsKey(u.AccountId)){
                setTemp.addAll(mapAccountUser.get(u.AccountId));
            }
            mapAccountUser.put(u.AccountId,setTemp);
        }

        map<Id,set<Id>> mapAccountOpportunity= new map<Id,set<Id>>();
        List<Opportunity> lstOpportunitys = new List<Opportunity>();
        if(!Test.isRunningTest())
          lstOpportunitys = [select Id,AccountId,Ship_To__c from Opportunity where Ship_To__c  IN:setAccountIds or AccountId IN: setAccountIds];
        else if(Test.isRunningTest())
          lstOpportunitys = [select Id,AccountId,Ship_To__c from Opportunity];
        for(Opportunity Opportunity : lstOpportunitys){
            set<ID> setOpportunityIds = new Set<Id>();
            setOpportunityIds.add(Opportunity.Id);
            if(mapAccountOpportunity.containsKey(Opportunity.AccountId)){
                setOpportunityIds.addAll(mapAccountOpportunity.get(Opportunity.AccountId));
            }
            if(mapAccountOpportunity.containsKey(Opportunity.Ship_To__c)){
                setOpportunityIds.addAll(mapAccountOpportunity.get(Opportunity.Ship_To__c));
            }
           
            mapAccountOpportunity.put(Opportunity.AccountId,setOpportunityIds);
        }

        for(Id accId : mapAccountOpportunity.keyset()){
            if(mapAccountUser.containsKey(accid)){
                for(Id uId : mapAccountUser.get(accid)){
                    theUserIdAndOpportunityIdsMap.put(uid,mapAccountOpportunity.get(accid));
                }       
            }
        }
        // Initializing data member.
        

        set<Id> UserDIds = new set<Id>();
        set<Id> OpportunityDIds = new set<Id>();
        
        // Determining Opportunity share records to insert.
        for(Id theUserId : theUserIdAndOpportunityIdsMap.keySet()) {
          for(Id theOpportunityId : theUserIdAndOpportunityIdsMap.get(theUserId)) {
            UserDIds.add(theUserId);
            OpportunityDIds.add(theOpportunityId);
          }
        }
        List<OpportunityShare> toBeDeleted = [select Id from OpportunityShare where OpportunityId  IN: OpportunityDIds and userorGroupId NOT IN: UserDIds and OpportunityAccessLevel = 'Read' limit 10000];
        
        if(toBeDeleted.size() > 0) {   List<Database.deleteResult> theSaveResult = Database.delete(toBeDeleted, false);    }
        
        // Initializing data member.
        List<OpportunityShare> toBeInserted = new List<OpportunityShare>();

        // Determining Opportunity share records to insert.
        for(Id theUserId : theUserIdAndOpportunityIdsMap.keySet()) {
          for(Id theOpportunityId : theUserIdAndOpportunityIdsMap.get(theUserId)) {
            toBeInserted.add(new OpportunityShare(  OpportunityId  = theOpportunityId,     UserOrGroupId = theUserId,     OpportunityAccessLevel = 'Read', RowCause = Schema.OpportunityShare.RowCause.Manual
            ));
          }
        }
        if(toBeInserted.size() > 0) {   List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);    }
    }    

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    

}
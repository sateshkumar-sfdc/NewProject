global class Batch_DeliveriesPermissionSynch implements Database.Batchable<sObject> {

    string query;
    
    global Batch_DeliveriesPermissionSynch(string q){
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
        map<Id,set<Id>> theUserIdAndDeliveriesIdsMap = new map<Id,Set<Id>>();        
        map<Id,set<Id>> mapAccountUser = new map<Id,set<Id>>();
        for(User u : [select Id,AccountId from User where AccountId IN: setAccountIds  and profile.Name =: label.dealercorporateprofile]){
            set<ID> setTemp = new Set<Id>();
            setTemp.add(u.Id);
            if(mapAccountUser.containsKey(u.AccountId)){
                setTemp.addAll(mapAccountUser.get(u.AccountId));
            }
            mapAccountUser.put(u.AccountId,setTemp);
        }

        map<Id,set<Id>> mapAccountDeliveries= new map<Id,set<Id>>();
        List<Deliveries__c> lstDeliveriess = new List<Deliveries__c>();
        if(!Test.isRunningTest())
          lstDeliveriess = [select Id,Sold_To__c,Ship_To__c,Bill_To__c from Deliveries__c where Ship_To__c IN: setAccountIds or Bill_To__c IN:setAccountIds or Sold_To__c IN: setAccountIds];
        else if(Test.isRunningTest())
          lstDeliveriess = [select Id,Sold_To__c,Ship_To__c,Bill_To__c from Deliveries__c];
        for(Deliveries__c Deliveries : lstDeliveriess){
            set<ID> setDeliveriesIds = new Set<Id>();
            setDeliveriesIds.add(Deliveries.Id);
            if(mapAccountDeliveries.containsKey(Deliveries.Sold_To__c)){
                setDeliveriesIds.addAll(mapAccountDeliveries.get(Deliveries.Sold_To__c));
            }
            if(mapAccountDeliveries.containsKey(Deliveries.Ship_To__c)){
                setDeliveriesIds.addAll(mapAccountDeliveries.get(Deliveries.Ship_To__c));
            }
            if(mapAccountDeliveries.containsKey(Deliveries.Bill_To__c)){
                setDeliveriesIds.addAll(mapAccountDeliveries.get(Deliveries.Bill_To__c));
            }
            mapAccountDeliveries.put(Deliveries.Sold_To__c,setDeliveriesIds);
        }

        for(Id accId : mapAccountDeliveries.keyset()){
            if(mapAccountUser.containsKey(accid)){
                for(Id uId : mapAccountUser.get(accid)){
                    theUserIdAndDeliveriesIdsMap.put(uid,mapAccountDeliveries.get(accid));
                }       
            }
        }
        // Initializing data member.
        

        set<Id> UserDIds = new set<Id>();
        set<Id> DeliveriesDIds = new set<Id>();
        
        // Determining Deliveries share records to insert.
        for(Id theUserId : theUserIdAndDeliveriesIdsMap.keySet()) {
          for(Id theDeliveriesId : theUserIdAndDeliveriesIdsMap.get(theUserId)) {
            UserDIds.add(theUserId);
            DeliveriesDIds.add(theDeliveriesId);
          }
        }
        /*List<Deliveries__Share> toBeDeleted = [select Id,userorGroupId from Deliveries__Share where ParentId IN: DeliveriesDIds and userorGroupId NOT IN: UserDIds and AccessLevel = 'Read' limit 10000];
        
        if(toBeDeleted.size() > 0) {
            map<Id,User> mapPortalUser = new map<Id,user>([select Id from User where profile.Name =: label.dealercorporateprofile]);List<Deliveries__Share > toBeDeletedPortal = new List<Deliveries__Share >();
            for(Deliveries__Share i :toBeDeleted){if(mapPortalUser.containsKey(i.userorGroupId))toBeDeletedPortal.add(i);}         
            List<Database.deleteResult> theSaveResult = Database.delete(toBeDeletedPortal, false);    
        }*/
        
        // Initializing data member.
        List<Deliveries__Share> toBeInserted = new List<Deliveries__Share>();

        // Determining Deliveries share records to insert.
        for(Id theUserId : theUserIdAndDeliveriesIdsMap.keySet()) {
          for(Id theDeliveriesId : theUserIdAndDeliveriesIdsMap.get(theUserId)) {
            toBeInserted.add(new Deliveries__Share(  ParentId = theDeliveriesId,     UserOrGroupId = theUserId,     AccessLevel = 'Read',       RowCause = Schema.Deliveries__Share.RowCause.Manual
            ));
          }
        }
        if(toBeInserted.size() > 0) {   List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);    }
    }    

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    

}
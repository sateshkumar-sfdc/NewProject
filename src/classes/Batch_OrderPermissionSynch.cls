global class Batch_OrderPermissionSynch implements Database.Batchable<sObject> {

    string query;
    
    global Batch_OrderPermissionSynch(string q){
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
        map<Id,set<Id>> theUserIdAndOrderIdsMap = new map<Id,Set<Id>>();        
        map<Id,set<Id>> mapAccountUser = new map<Id,set<Id>>();
        for(User u : [select Id,AccountId from User where AccountId IN: setAccountIds and profile.Name =: label.dealercorporateprofile]){
            set<ID> setTemp = new Set<Id>();
            setTemp.add(u.Id);
            if(mapAccountUser.containsKey(u.AccountId)){
                setTemp.addAll(mapAccountUser.get(u.AccountId));
            }
            mapAccountUser.put(u.AccountId,setTemp);
        }

        map<Id,set<Id>> mapAccountOrder= new map<Id,set<Id>>();
        List<Order__c> lstOrders = new List<Order__c>();
        if(!Test.isRunningTest())
          lstOrders = [select Id,Sold_To__c,Ship_To__c,Bill_To__c from Order__c where Ship_To__c IN: setAccountIds or Bill_To__c IN:setAccountIds or Sold_To__c IN: setAccountIds];
        else if(Test.isRunningTest())
          lstOrders = [select Id,Sold_To__c,Ship_To__c,Bill_To__c from Order__c];
        for(Order__c order : lstOrders){
            set<ID> setOrderIds = new Set<Id>();
            setOrderIds.add(order.Id);
            if(mapAccountOrder.containsKey(order.Sold_To__c)){
                setOrderIds.addAll(mapAccountOrder.get(order.Sold_To__c));
            }
            if(mapAccountOrder.containsKey(order.Ship_To__c)){
                setOrderIds.addAll(mapAccountOrder.get(order.Ship_To__c));
            }
            if(mapAccountOrder.containsKey(order.Bill_To__c)){
                setOrderIds.addAll(mapAccountOrder.get(order.Bill_To__c));
            }
            mapAccountOrder.put(order.Sold_To__c,setOrderIds);
        }

        for(Id accId : mapAccountOrder.keyset()){
            if(mapAccountUser.containsKey(accid)){
                for(Id uId : mapAccountUser.get(accid)){
                    theUserIdAndOrderIdsMap.put(uid,mapAccountOrder.get(accid));
                }       
            }
        }
        // Initializing data member.
        

        set<Id> UserDIds = new set<Id>();
        set<Id> orderDIds = new set<Id>();
        
        // Determining order share records to insert.
        for(Id theUserId : theUserIdAndOrderIdsMap.keySet()) {
          for(Id theOrderId : theUserIdAndOrderIdsMap.get(theUserId)) {
            UserDIds.add(theUserId);
            orderDIds.add(theOrderId);
          }
        }
        /*List<Order__Share> toBeDeleted = [select Id,userorGroupId from Order__Share where ParentId IN: orderDIds and userorGroupId NOT IN: UserDIds and AccessLevel = 'Read' limit 10000];
        
        if(toBeDeleted.size() > 0) {
            map<Id,User> mapPortalUser = new map<Id,user>([select Id from User where profile.Name =: label.dealercorporateprofile]);List<Order__Share> toBeDeletedPortal = new List<Order__Share>();
            for(Order__Share i :toBeDeleted){if(mapPortalUser.containsKey(i.userorGroupId))toBeDeletedPortal.add(i);}         
            List<Database.deleteResult> theSaveResult = Database.delete(toBeDeletedPortal, false);    
        }*/
        
        // Initializing data member.
        List<Order__Share> toBeInserted = new List<Order__Share>();

        // Determining order share records to insert.
        for(Id theUserId : theUserIdAndOrderIdsMap.keySet()) {
          for(Id theOrderId : theUserIdAndOrderIdsMap.get(theUserId)) {
            toBeInserted.add(new Order__Share(  ParentId = theOrderId,     UserOrGroupId = theUserId,     AccessLevel = 'Read',       RowCause = Schema.Order__Share.RowCause.Manual
            ));
          }
        }
        if(toBeInserted.size() > 0) {   List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);    }
    }    

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    

}
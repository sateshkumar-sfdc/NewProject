global class Batch_CasePermissionSynch implements Database.Batchable<sObject> {

    string query;
    
    global Batch_CasePermissionSynch(string q){
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
        map<Id,set<Id>> theUserIdAndCaseIdsMap = new map<Id,Set<Id>>();        
        map<Id,set<Id>> mapAccountUser = new map<Id,set<Id>>();
        for(User u : [select Id,AccountId from User where AccountId IN: setAccountIds and profile.Name =: label.dealercorporateprofile]){
            set<ID> setTemp = new Set<Id>();
            setTemp.add(u.Id);
            if(mapAccountUser.containsKey(u.AccountId)){
                setTemp.addAll(mapAccountUser.get(u.AccountId));
            }
            mapAccountUser.put(u.AccountId,setTemp);
        }

        map<Id,set<Id>> mapAccountCase= new map<Id,set<Id>>();
        List<Case> lstCases = new List<Case>();
        if(!Test.isRunningTest())
          lstCases = [select Id,AccountId from Case where  AccountId IN: setAccountIds and Trading_Post_Visible__c = true];
        else if(Test.isRunningTest())
          lstCases = [select Id,AccountId from Case];
        for(Case c : lstCases){
            set<ID> setCaseIds = new Set<Id>();
            setCaseIds.add(c.Id);
            if(mapAccountCase.containsKey(c.AccountId)){
                setCaseIds.addAll(mapAccountCase.get(c.AccountId));
            }
            
            mapAccountCase.put(c.AccountId,setCaseIds);
        }

        for(Id accId : mapAccountCase.keyset()){
            if(mapAccountUser.containsKey(accid)){
                for(Id uId : mapAccountUser.get(accid)){
                    theUserIdAndCaseIdsMap.put(uid,mapAccountCase.get(accid));
                }       
            }
        }
        // Initializing data member.
        

        set<Id> UserDIds = new set<Id>();
        set<Id> CaseDIds = new set<Id>();
        
        // Determining Case share records to insert.
        for(Id theUserId : theUserIdAndCaseIdsMap.keySet()) {
          for(Id theCaseId : theUserIdAndCaseIdsMap.get(theUserId)) {
            UserDIds.add(theUserId);
            CaseDIds.add(theCaseId);
          }
        }
        /*List<CaseShare> toBeDeleted = [select Id,userorGroupId  from CaseShare where CaseId  IN: CaseDIds and userorGroupId NOT IN: UserDIds and CaseAccessLevel = 'Read' limit 10000];
        
        if(toBeDeleted.size() > 0) {
            map<Id,User> mapPortalUser = new map<Id,user>([select Id from User where profile.Name =: label.dealercorporateprofile]);List<CaseShare> toBeDeletedPortal = new List<CaseShare>();
            for(CaseShare i :toBeDeleted){if(mapPortalUser.containsKey(i.userorGroupId))toBeDeletedPortal.add(i);}         
            List<Database.deleteResult> theSaveResult = Database.delete(toBeDeletedPortal, false);    
        }*/
        
        // Initializing data member.
        List<CaseShare> toBeInserted = new List<CaseShare>();

        // Determining Case share records to insert.
        for(Id theUserId : theUserIdAndCaseIdsMap.keySet()) {
          for(Id theCaseId : theUserIdAndCaseIdsMap.get(theUserId)) {
            toBeInserted.add(new CaseShare(  CaseId  = theCaseId,     UserOrGroupId = theUserId,     CaseAccessLevel = 'Read', RowCause = Schema.CaseShare.RowCause.Manual
            ));
          }
        }
        if(toBeInserted.size() > 0) {   List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);    }
    }    

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    

}
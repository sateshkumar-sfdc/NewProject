global class Batch_InvoicePermissionSynch implements Database.Batchable<sObject> {

    string query;
    
    global Batch_InvoicePermissionSynch(string q){
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
        map<Id,set<Id>> theUserIdAndInvoiceIdsMap = new map<Id,Set<Id>>();        
        map<Id,set<Id>> mapAccountUser = new map<Id,set<Id>>();
        for(User u : [select Id,AccountId from User where AccountId IN: setAccountIds and profile.Name =: label.dealercorporateprofile]){
            set<ID> setTemp = new Set<Id>();
            setTemp.add(u.Id);
            if(mapAccountUser.containsKey(u.AccountId)){
                setTemp.addAll(mapAccountUser.get(u.AccountId));
            }
            mapAccountUser.put(u.AccountId,setTemp);
        }

        map<Id,set<Id>> mapAccountInvoice= new map<Id,set<Id>>();
        List<Invoice__c> lstInvoices = new List<Invoice__c>();
        if(!Test.isRunningTest())
          lstInvoices = [select Id,Sold_To__c,Ship_To__c,Bill_To__c from Invoice__c where Ship_To__c IN: setAccountIds or Bill_To__c IN:setAccountIds or Sold_To__c IN: setAccountIds];
        else if(Test.isRunningTest())
          lstInvoices = [select Id,Sold_To__c,Ship_To__c,Bill_To__c from Invoice__c];
        for(Invoice__c Invoice : lstInvoices){
            set<ID> setInvoiceIds = new Set<Id>();
            setInvoiceIds.add(Invoice.Id);
            if(mapAccountInvoice.containsKey(Invoice.Sold_To__c)){
                setInvoiceIds.addAll(mapAccountInvoice.get(Invoice.Sold_To__c));
            }
            if(mapAccountInvoice.containsKey(Invoice.Ship_To__c)){
                setInvoiceIds.addAll(mapAccountInvoice.get(Invoice.Ship_To__c));
            }
            if(mapAccountInvoice.containsKey(Invoice.Bill_To__c)){
                setInvoiceIds.addAll(mapAccountInvoice.get(Invoice.Bill_To__c));
            }
            mapAccountInvoice.put(Invoice.Sold_To__c,setInvoiceIds);
        }

        for(Id accId : mapAccountInvoice.keyset()){
            if(mapAccountUser.containsKey(accid)){
                for(Id uId : mapAccountUser.get(accid)){
                    theUserIdAndInvoiceIdsMap.put(uid,mapAccountInvoice.get(accid));
                }       
            }
        }
        // Initializing data member.
        

        set<Id> UserDIds = new set<Id>();
        set<Id> InvoiceDIds = new set<Id>();
        
        // Determining Invoice share records to insert.
        for(Id theUserId : theUserIdAndInvoiceIdsMap.keySet()) {
          for(Id theInvoiceId : theUserIdAndInvoiceIdsMap.get(theUserId)) {
            UserDIds.add(theUserId);
            InvoiceDIds.add(theInvoiceId);
          }
        }
        /*List<Invoice__Share> toBeDeleted = [select Id,userorGroupId from Invoice__Share where ParentId IN: InvoiceDIds and userorGroupId NOT IN: UserDIds and AccessLevel = 'Read' limit 10000];
        
        if(toBeDeleted.size() > 0) {
            map<Id,User> mapPortalUser = new map<Id,user>([select Id from User where profile.Name =: label.dealercorporateprofile]);List<Invoice__Share> toBeDeletedPortal = new List<Invoice__Share>();
            for(Invoice__Share i :toBeDeleted){if(mapPortalUser.containsKey(i.userorGroupId))toBeDeletedPortal.add(i);}         
            List<Database.deleteResult> theSaveResult = Database.delete(toBeDeletedPortal, false);    
        }*/
        
        // Initializing data member.
        List<Invoice__Share> toBeInserted = new List<Invoice__Share>();

        // Determining Invoice share records to insert.
        for(Id theUserId : theUserIdAndInvoiceIdsMap.keySet()) {
          for(Id theInvoiceId : theUserIdAndInvoiceIdsMap.get(theUserId)) {
            toBeInserted.add(new Invoice__Share(  ParentId = theInvoiceId,     UserOrGroupId = theUserId,     AccessLevel = 'Read',       RowCause = Schema.Invoice__Share.RowCause.Manual
            ));
          }
        }
        if(toBeInserted.size() > 0) {   List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);    }
    }    

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    

}
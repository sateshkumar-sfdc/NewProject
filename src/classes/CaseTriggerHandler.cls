/*
Name 					- CaseTriggerHandler
Created By 				- Nitish Bansal
Created Date 			- 03/02/2016
Purpose 				- T-479370
*/
public class CaseTriggerHandler {

    // Methods to be executed before record is inserted
    // @param newRecords - List to hold Trigger.new 
    // @return Nothing
    public void beforeRecordInsert(List<Case> newRecords, Map<Id, Case> oldMap){
      //  updateOwnerManager(newRecords, oldMap);
    }

    // Methods to be executed after record is updated
    // @param newRecords - List to hold Trigger.new 
    // @param oldMap - List to hold Trigger.oldMap
    // @return Nothing
    public void beforeRecordUpdate(List<Case> newRecords, Map<Id, Case> oldMap){
      //  updateOwnerManager(newRecords, oldMap);
    }

	// Methods to be executed after record is inserted
    // @param newRecords - List to hold Trigger.new 
    // @return Nothing
	public void afterRecordInsert(List<Case> newRecords){
        createCaseHistory(newRecords);
    }

    // Methods to be executed after record is updated
    // @param newRecords - List to hold Trigger.new 
    // @param oldMap - List to hold Trigger.oldMap
    // @return Nothing
    public void afterRecordUpdate(List<Case> newRecords, Map<Id, Case> oldMap){
        trackResolution(newRecords, oldMap);
    }

    // Method to create a Case History record when a case is inserted which will be used for resolution tracking.
    // @param newRecords - List to hold Trigger.new 
    // @return Nothing
    private void createCaseHistory(List<Case> newRecords){
    	String ownerId;
		Case_History__c caseHistory;
		Set<Id> setOwnerId = new Set<Id>();
		Set<Id> setQueueId = new Set<Id>();
	    Map<Id, User> mapUser = new Map<Id, User>();
	    Map<Id, Group> mapQueue = new Map<Id, Group>();
		List<Case_History__c> listCaseHistory = new List<Case_History__c>();
		for(case c : newRecords){
        	ownerId = c.OwnerId;
	        if(ownerId.startsWith('005')){
                setOwnerId.add(c.OwnerId);
            }
            else{
                setQueueId.add(c.OwnerId);
            }
        }
        /* Fetching Owners details */
        if(setOwnerId.size() > 0){
            mapUser = new Map<Id, User>([Select Id, Email, Name from User where Id IN :setOwnerId]);
        }
        
        if(setQueueId.size() > 0){
            mapQueue = new Map<Id, Group>([Select Id, Name from Group where Id IN :setQueueId]);
        }
        /* Creating Case History */
        for(case c : newRecords){
            ownerId = c.OwnerId;
            caseHistory = new Case_History__c();
            caseHistory.Case__c = c.Id;
            caseHistory.Change_type__c = 'Status';
            if(ownerId.startsWith('005')){
                caseHistory.Owner_Type__c = 'User';
                caseHistory.Owner_name__c = mapUser.get(c.OwnerId).Name;
            }
            else{
                caseHistory.Owner_Type__c = 'Queue';
                caseHistory.Owner_name__c = mapQueue.get(c.OwnerId).Name;
            }
            caseHistory.Owner_id__c = c.OwnerId;
            caseHistory.Start_time__c = DateTime.now();
            caseHistory.New_status__c = c.Status;
            listCaseHistory.add(caseHistory);
        }
        /* Inserting Case History */
        if(listCaseHistory.size() > 0){
        	insert listCaseHistory;
        }
	}

    // Method to create a Case History record  & update existing one when a case is updated to track case resolution time
    // @param newRecords - List to hold Trigger.new 
    // @param oldMap - List to hold Trigger.oldMap 
    // @return Nothing
    private void trackResolution(List<Case> newRecords, Map<Id, Case> oldMap){
        String ownerId;
        Case_History__c caseHistory;
        Set<Id> setOwnerId = new Set<Id>();
        Set<Id> setQueueId = new Set<Id>();
        Map<Id, User> mapUser = new Map<Id, User>();
        Map<Id, Group> mapQueue = new Map<Id, Group>();
        Set<Id> setCaseChangeId = new Set<Id>();
        List<Case_History__c> listCaseHistory = new List<Case_History__c>();
        Set<Id> setSubCaseId = new Set<Id>();
        List<case> listCase = new List<case>();
        Set<Id> setParentCaseId = new Set<Id>();
        
        for(case c : newRecords){
            if((c.OwnerId != oldMap.get(c.Id).OwnerId || c.Status != oldMap.get(c.Id).Status)){
                setCaseChangeId.add(c.Id);
            }
            ownerId = c.OwnerId;
            if(ownerId.startsWith('005')){
                setOwnerId.add(c.OwnerId);
            }
            else{
                setQueueId.add(c.OwnerId);
            }
        }
        
        /* Fetching Owners details */
        if(setOwnerId.size() > 0){
            mapUser = new Map<Id, User>([Select Id, Email, Name from User where Id IN :setOwnerId]);
        }
        if(setQueueId.size() > 0){
            mapQueue = new Map<Id, Group>([Select Id, Name from Group where Id IN :setQueueId]);
        }
        
        /* Updating previous Case History for End time */
        if(setCaseChangeId.size() > 0){
            for(Case c : [Select Id, Status, IsClosed, (Select Id, End_time__c from Create_History__r order by Createddate desc limit 1) from Case where Id IN :setCaseChangeId]){
                if(c.Create_History__r != null && c.Create_History__r.size()>0){
                    caseHistory = new Case_History__c(Id = c.Create_History__r.get(0).Id, End_time__c = DateTime.now());
                    listCaseHistory.add(caseHistory);
                }
            }
        }
        
       /*Creating new case history records */
        for(case c : newRecords){
            ownerId = c.OwnerId;
            if(c.OwnerId != oldMap.get(c.Id).OwnerId){
                caseHistory = new Case_History__c();
                caseHistory.Case__c = c.Id;
                caseHistory.Change_type__c = 'Owner';
                if(ownerId.startsWith('005')){
                    caseHistory.Owner_Type__c = 'User';
                    caseHistory.Owner_name__c = mapUser.get(c.OwnerId).Name;
                }
                else{
                    caseHistory.Owner_Type__c = 'Queue';
                    caseHistory.Owner_name__c = mapQueue.get(c.OwnerId).Name;
                }
                caseHistory.Owner_id__c = c.OwnerId;
                caseHistory.Start_time__c = DateTime.now();
                caseHistory.New_status__c = c.Status;
                listCaseHistory.add(caseHistory);
            }
            else if(c.Status != oldMap.get(c.Id).Status){
                caseHistory = new Case_History__c();
                caseHistory.Case__c = c.Id;
                caseHistory.Change_type__c = 'Status';
                if(ownerId.startsWith('005')){
                    caseHistory.Owner_Type__c = 'User';
                    caseHistory.Owner_name__c = mapUser.get(c.OwnerId).Name;
                }
                else{
                    caseHistory.Owner_Type__c = 'Queue';
                    caseHistory.Owner_name__c = mapQueue.get(c.OwnerId).Name;
                }
                caseHistory.Owner_id__c = c.OwnerId;
                caseHistory.Start_time__c = DateTime.now();
                caseHistory.New_status__c = c.Status;
                listCaseHistory.add(caseHistory);
            }
        }
    
        /* Upserting Case History */
        if(listCaseHistory.size() > 0){
            upsert listCaseHistory;
        }
    }

/*     // Method to update Record Onwer's Manager on a custom field
    // @param newRecords - List to hold Trigger.new 
    // @param oldMap - List to hold Trigger.oldMap 
    // @return Nothing
    private void updateOwnerManager(List<Case> newRecords, Map<Id, Case> oldMap){
        Set<Id> ownerIdSet = new Set<Id>();
        Map<Id, Id> onwerIdToManagerIdMap = new Map<Id, Id>();
        
            for(case c : newRecords){
                if(c.Status == 'Escalated' && oldMap.get(c.Id).Status != c.Status){
                    ownerIdSet.add(oldMap.get(c.Id).OwnerId);
                }
            }
            //Fetching Manger Id's
            for(User u : [Select Id, ManagerId from User where Id in:ownerIdSet]){
                onwerIdToManagerIdMap.put(u.Id, u.ManagerId);
            }
             //Updating case status and Owner
            if(onwerIdToManagerIdMap.size() > 0){
                for(case c : newRecords){
                    if(c.Status == 'Escalated' && oldMap.get(c.Id).Status != c.Status){
                        if(onwerIdToManagerIdMap.get(c.OwnerId) != null){
                            c.OwnerId = onwerIdToManagerIdMap.get(c.OwnerId);
                        }
                    }
                }
            }
     }
*/     
}
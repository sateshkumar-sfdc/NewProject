public class CasePriorityKeyOwnerAssignment{
    
    public static void UpdateOwner(List<Case> lstCase){
        
        List<User> lstNRAUsers = [select Id from User where Name=: Label.NRA_User and IsActive = true];
        Id OutfitterRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Outfitter').getRecordTypeId();
        set<string> setAllowOrigin = new set<string>{'Web','Public Email','Direct Email'};
        string PriorityKeyWords = label.Priority_KeyWords;
        set<string> setPriorityKey = new set<string>();
        if(PriorityKeyWords <> null){
            for(string s : PriorityKeyWords.split(';')){
                setPriorityKey.add(s);
            }
        }

        List<Group> lstPriorityKeyQueue = [select Id from Group where Name=: Label.PriorityKey_Queue];
        for(Case c: lstCase){
            if(
                (lstNRAUsers.size() == 0 || (lstNRAUsers.size()>0 && c.OwnerId <> lstNRAUsers[0].id)) && 
                lstPriorityKeyQueue.size()>0 && 
                OutfitterRT == c.RecordTypeId && 
                setAllowOrigin.contains(c.Origin)
            ){
                boolean isSubject = false;
                boolean isDescription = false;
                for(string s : setPriorityKey){
                    if(c.Subject <> null && (c.Subject).containsIgnoreCase(s)){isSubject = true;break;}
                    if(c.Description <> null && (c.Description).containsIgnoreCase(s)){isDescription = true;break;}
                }
                if(isSubject || isDescription){
                    c.OwnerId = lstPriorityKeyQueue[0].id;
                }
            }
        }
    }
}
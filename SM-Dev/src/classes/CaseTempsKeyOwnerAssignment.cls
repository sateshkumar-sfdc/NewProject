public class CaseTempsKeyOwnerAssignment{
    
    public static void UpdateOwner(List<Case> lstCase){
        
        
        Id OutfitterRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Outfitter').getRecordTypeId();
        set<string> setAllowOrigin = new set<string>{'Web','Public Email','Direct Email'};
        string TempsKeyWords = label.TempAutoRoutingKeywords;
        set<string> setTempsKey = new set<string>();
        if(TempsKeyWords <> null){
            for(string s : TempsKeyWords.split(';')){
                setTempsKey.add(s);
            }
        }

        List<Group> lstTempsKeyQueue = [select Id from Group where Name=: Label.TempKey_Queue ];
        for(Case c: lstCase){
            if(
                 
                lstTempsKeyQueue.size()>0 && 
                OutfitterRT == c.RecordTypeId && 
                setAllowOrigin.contains(c.Origin)
            ){
                boolean isSubject = false;
                boolean isDescription = false;
                for(string s : setTempsKey){
                    if(c.Subject <> null && (c.Subject).containsIgnoreCase(s)){isSubject = true;break;}
                    if(c.Description <> null && (c.Description).containsIgnoreCase(s)){isDescription = true;break;}
                }
                if((isSubject || isDescription) && lstTempsKeyQueue.size()>0){
                    c.OwnerId = lstTempsKeyQueue[0].id;
                }
            }
        }
    }
}
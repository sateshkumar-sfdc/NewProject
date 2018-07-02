public class CaseNRAOwnerAssignment{
    
  /*  public static void UpdateOwner(List<Case> lstCase){
        
        Id OutfitterRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Outfitter').getRecordTypeId();
        Id CorporateSalesRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate Sales').getRecordTypeId();
        Id CanadaAccountRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Canada Account').getRecordTypeId();
        
        set<Id> setAllowRT = new set<Id>{OutfitterRT,CorporateSalesRT,CanadaAccountRT};
        set<string> setAllowOrigin = new set<string>{'Web','Public Email','Direct Email','Mail','Other'};
        
        string NRAWords = label.NRAWords;
        set<string> setNRA = new set<string>();
        if(NRAWords <> null){
            for(string s : NRAWords.split(';')){
                setNRA.add(s);
            }
        }
        
        List<User> lstNRAUsers = [select Id from User where Name=: Label.NRA_User and IsActive = true];
        for(Case c: lstCase){
            if(
                lstNRAUsers.size()>0 && 
                setAllowRT.contains(c.RecordTypeId) && 
                setAllowOrigin.contains(c.Origin)
            ){
                boolean isSubject = false;
                boolean isDescription = false;
                for(string s : setNRA){
                    if(c.Subject <> null && (c.Subject).containsIgnoreCase(s)){isSubject = true;break;}
                    if(c.Description <> null && (c.Description).containsIgnoreCase(s)){isDescription = true;break;}
                }
                if(isSubject || isDescription){
                    c.OwnerId = lstNRAUsers[0].id;
                 //   c.Reason = 'Other';
                 //   c.Case_Sub_Reason__c = 'NRA';
                }
            }
        }
    } */
}
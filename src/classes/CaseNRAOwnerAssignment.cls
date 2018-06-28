public class CaseNRAOwnerAssignment{
    
    public static void UpdateOwner(List<Case> lstCase){
        List<User> lstNRAUsers = [select Id from User where Name=: Label.NRA_User and IsActive = true];
        for(Case c: lstCase){
            if(
                lstNRAUsers.size()>0 && (
                    (c.Subject <> null && ((c.Subject).containsIgnoreCase('NRA') || (c.Subject).containsIgnoreCase('N.R.A.') || (c.Subject).containsIgnoreCase('National Rifle association') || (c.Subject).containsIgnoreCase('Liberal') || (c.Subject).containsIgnoreCase('American')  || (c.Subject).containsIgnoreCase('Snowflake') || (c.Subject).containsIgnoreCase('Politics') || (c.Subject).containsIgnoreCase('Fuck') || (c.Subject).containsIgnoreCase('Second Amendment') || (c.Subject).containsIgnoreCase('2nd Amendment'))) || 
                    (c.Description <> null && ((c.Description).containsIgnoreCase('NRA') || (c.Description).containsIgnoreCase('N.R.A.') || (c.Description).containsIgnoreCase('National Rifle association') || (c.Description).containsIgnoreCase('Liberal') || (c.Description).containsIgnoreCase('American')  || (c.Description).containsIgnoreCase('Snowflake') || (c.Description).containsIgnoreCase('Politics') || (c.Description).containsIgnoreCase('Fuck') || (c.Description).containsIgnoreCase('Second Amendment') || (c.Description).containsIgnoreCase('2nd Amendment')))
                )
            ){
                c.OwnerId = lstNRAUsers[0].id;
            }
        }
    }
}
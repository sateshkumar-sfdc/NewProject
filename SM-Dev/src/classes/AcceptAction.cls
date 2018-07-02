public class AcceptAction{
    @AuraEnabled
    public static string ownerChange(string RecordId){
        try{
            case c = [select Id,OwnerId from Case where Id=: RecordId];
            c.OwnerId = userinfo.getUserId();
            update c;    
            return 'Successfully Updated!!';    
        }
        catch(Exception e){
            return e.getMessage();
        }

    }
}
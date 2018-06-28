public class CreateFeedOnEmailSend
{
    public static void MakeFeed(Map<Id, EmailMessage> newMap)
    {
        Set<Id> parentIds = new Set<Id>();  
        String PREFIX_CASE = Case.SObjectType.getDescribe().getKeyPrefix();    
        map<Id,string> mapEmailbody = new map<Id,string>();
        map<string,string> mapEmailSubject = new map<string,string>();
        
        for (EmailMessage email :newMap.values())
        {
            if(!email.Incoming && ((String)email.ParentId).startsWith(PREFIX_CASE))  
            {
                parentIds.add(email.ParentId);  
                mapEmailbody.put(email.ParentId,email.TEXTBody); 
                mapEmailSubject.put(email.parentId,email.Subject);
            }
        }       
        List<FeedItem> lstFeedItem = new List<FeedItem>();
        for(Id cId : parentIds){
            FeedItem post = new FeedItem();
            post.ParentId = cid;
            //post.RelatedRecordId = mapEmailId.get(cId);
            post.Title ='##->'+ mapEmailSubject.get(cId);
            post.Body = mapEmailbody.get(cId);
            post.Type='EmailMessageEvent';
            post.Visibility = 'AllUsers';       
            lstFeedItem.add(post);
        }        
        insert lstFeedItem;
    }
}
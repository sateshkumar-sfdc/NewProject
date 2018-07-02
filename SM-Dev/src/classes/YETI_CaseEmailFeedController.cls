public without sharing class YETI_CaseEmailFeedController {

    private static Map<Integer, String> monthNames = new Map<Integer, String> {
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'May',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December'
      };
  
    @AuraEnabled
    public static List<CaseEmailFeed> getAllCaseEmailFeed(Id caseId) {
        List<CaseEmailFeed> lstMIT = new List<CaseEmailFeed>();
        map<Id,FeedItem> mapFeedItem = new map<Id,FeedItem>();
        set<string> setNotConsider = new set<string>();
        try{
            for(FeedItem f : [select id,type,Status,title,body,createdById,createdBy.Name,InsertedBy.Name,
            CreatedDate,Visibility  from FeedItem where  parentId =: caseId and type = 'EmailMessageEvent']){
                if(f.Visibility <> 'AllUsers'){
                    setNotConsider.add(f.createdDate+'-'+f.createdById);
                }               
                mapFeedItem.put(f.Id,f);
            }
            for(FeedItem f : mapFeedItem.values()){
                string key = f.createdDate+'-'+f.createdById;
                if(f.title <> null && !setNotConsider.contains(key)){
                    String CreatorId = f.createdById;
                    String CreatorName= f.createdBy.NAme;
                    string FeedActivityDate = monthNames.get((f.CreatedDate).month()) + ' ' + (f.CreatedDate).day() + ', ' + (f.CreatedDate).year()
                                + ' at ' + (f.CreatedDate).hour() + ':' + (f.CreatedDate).minute();
                    String Subject= f.title;
                    //String body = f.body+'#####'+f.Status+'#####'+f.Visibility+'#####'+(f.body).contains('ref:_');
                    String body = f.body;
                    if( body <> null && body.contains('ref:_'))body= body.substring(0,body.indexOf('ref:_'));
                    if( body <> null && body.contains('--------------- Original Message ---------------'))
                        body= body.replace('--------------- Original Message ---------------','<br/><br/>--------------- Original Message ---------------');
                    
                    
                    CaseEmailFeed m = new CaseEmailFeed(CreatorId,CreatorName,FeedActivityDate,Subject,body);
                    lstMIT.add(m);
                }
            }
         }catch(Exception e){
         // user do not have to access others feed
         }
        return lstMIT;
    }
  
  public class CaseEmailFeed {
    @AuraEnabled public String CreatorId;
    @AuraEnabled public String CreatorName;
    @AuraEnabled public string FeedActivityDate;
    @AuraEnabled public String Subject;
    @AuraEnabled public String body;
    

    public CaseEmailFeed(String ci, String cn, string fad, String sub, String b) {
        this.CreatorId =ci;
        this.CreatorName =cn;
        this.FeedActivityDate =fad;
        this.Subject =sub;
        this.body =b;
    }
  }
}
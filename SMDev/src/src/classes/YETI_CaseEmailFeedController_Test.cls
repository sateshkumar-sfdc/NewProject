@isTest
public class YETI_CaseEmailFeedController_Test{
  @isTest static void UNITTest() {      
      
      
        Case casex = new Case(Subject = 'TEST Case1');
        insert casex;
      
        FeedItem post = new FeedItem();
        post.ParentId = casex.id;
        //post.RelatedRecordId = mapEmailId.get(cId);
        post.Title = 'TESTCASEFEED';
        post.Body = 'TEST';
        post.Type='EmailMessageEvent';
        post.Visibility = 'AllUsers';       
        insert post;
            
        //getAllCaseEmailFeed
        List<YETI_CaseEmailFeedController.CaseEmailFeed>  lstCaseEmails = YETI_CaseEmailFeedController.getAllCaseEmailFeed(casex.id);
        
      
      
  }
}
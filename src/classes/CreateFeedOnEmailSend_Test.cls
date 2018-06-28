@isTest
public class CreateFeedOnEmailSend_Test
{
    
    @isTest
    public static void test()
    {
        Case casex = new Case(Subject='test');
        insert casex; 
        
        EmailMessage email_msg = new EmailMessage();
        email_msg.HtmlBody = '<H1>This is a test</H1>';
        email_msg.ParentId = casex.Id;
        email_msg.incoming = false;
        insert email_msg;
        
    }    
}
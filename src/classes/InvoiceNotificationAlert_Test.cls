@isTest
public class InvoiceNotificationAlert_Test{
    @isTest static void UnitTest() {
        Account Acc  = new Account(Name = 'test');
        insert Acc;
        Contact con = new Contact(LastName ='testcontact1',AccountId = Acc.id);
        insert con;
        
        
        Id profId = [SELECT id from profile where name = :Label.YETI_DealerCorporateProfileName LIMIT 1].id;
              
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;

        User tuser = new User(  firstname = 'test',
                lastName = 'testpopopo',
                ContactId = con.id,
                email = uniqueName + '@test' + orgId + '.org',
                Username = uniqueName + '@test' + orgId + '.org',
                EmailEncodingKey = 'ISO-8859-1',
                Alias = uniqueName.substring(18, 23),
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = profId);
        insert tuser;
      
        Date Last1Day = system.today()-1;
        Invoice__c invo = new Invoice__c(Name ='inv1',Ship_To__c = Acc.id,Due_Date__c = Last1Day,status__c = 'Not Completed');
        insert invo;
        
        invo = [select Ship_To__c from Invoice__c where id=: invo.id];
        invo.Ship_To__c = Acc.id;
        update invo;
        system.assertEquals([select Ship_To__c from Invoice__c where id=: invo.id].Ship_To__c,Acc.id);
        
        Test.startTest();
            String CRON_EXP = '0 0 0 3 9 ? 2022';
            String jobId = System.schedule('Schedular_InvoiceNotificationAlert',CRON_EXP, new Schedular_InvoiceNotificationAlert ());

        Test.stopTest();
        
    } 
    
}
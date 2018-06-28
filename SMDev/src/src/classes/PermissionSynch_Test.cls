@isTest
public class PermissionSynch_Test{
    @isTest static void BatchesTest() {
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
      
        Invoice__c invo = new Invoice__c(Name ='inv1',Ship_To__c = Acc.id);
        insert invo;
        
        invo = [select Ship_To__c from Invoice__c where id=: invo.id];
        invo.Ship_To__c = Acc.id;
        update invo;
        system.assertEquals([select Ship_To__c from Invoice__c where id=: invo.id].Ship_To__c,Acc.id);
       
        system.assertNotEquals([select Ship_To__c from Invoice__c where Ship_To__c=:Acc.id],null);
        Order__c ordr = new Order__c(Name ='order test1',Ship_To__c = Acc.id);
        insert ordr;  
        
        ordr = [select Ship_To__c from Order__c where id=: ordr.id];
        ordr.Ship_To__c = Acc.id;
        update ordr;
          
        system.assertEquals([select Ship_To__c from Order__c where id=: ordr.id].Ship_To__c,Acc.id);
        
        Deliveries__c deli = new Deliveries__c(Name ='del1',Sold_To__c = Acc.id);
        insert deli;
        
        deli = [select Ship_To__c from Deliveries__c where id=: deli.id];
        deli.Ship_To__c = Acc.id;
        update deli;
        
        
        system.assertEquals([select Ship_To__c from Deliveries__c where id=: deli.id].Ship_To__c,Acc.id);
        
        case cobj = new case(subject = 'TEST Case 1',AccountId = Acc.id,Trading_Post_Visible__c  = true);
        insert cobj;
        
        Opportunity Oppobj = new Opportunity(Name = 'TEST Opp',AccountId = Acc.id,closeDate = system.today(),StageName = 'Open');
        insert Oppobj;
        
        Test.startTest();
            String sch = '0 0 23 * * ?';
            string q = 'select Id from Account';           
            scheduler_CasePermissionSynch sch_Case = new scheduler_CasePermissionSynch();
            scheduler_OpportunityPermissionSynch sch_Opportunity = new scheduler_OpportunityPermissionSynch();
            scheduler_InvoicePermissionSynch sch_Invoice = new scheduler_InvoicePermissionSynch();
            scheduler_DeliveriesPermissionSynch sch_Deliveries = new scheduler_DeliveriesPermissionSynch();
            scheduler_OrderPermissionSynch sch_Order = new scheduler_OrderPermissionSynch();

            system.schedule('Case Synch', sch, sch_Case);
            system.schedule('Opportunity Synch', sch, sch_Opportunity);
            system.schedule('Invoice Synch', sch, sch_Invoice);
            system.schedule('Deliveries Synch', sch, sch_Deliveries);
            system.schedule('Order Synch', sch, sch_Order);
        Test.stopTest();
        
    } 
    
}
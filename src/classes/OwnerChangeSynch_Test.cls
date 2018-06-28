@isTest
public class OwnerChangeSynch_Test{
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
      
        system.runas(tuser){
            Invoice__c invo = new Invoice__c(Name ='inv1',Sold_To__c = Acc.id);
            insert invo;
            Order__c ordr = new Order__c(Name ='order test1',Sold_To__c = Acc.id);
            insert ordr;  
            Deliveries__c deli = new Deliveries__c(Name ='del1',Sold_To__c = Acc.id);
            insert deli;
            
        
        }
        
        Test.startTest();           
            database.executeBatch(new Batch_InvoiceOwnerSynch('select Id,Name,ownerId,Sold_To__r.OwnerId  from Invoice__c where  Sold_To__r.Owner.isActive = true'));
            database.executeBatch(new Batch_OrderOwnerSynch('select Id,Name,ownerId,Sold_To__r.OwnerId  from Order__c where  Sold_To__r.Owner.isActive = true'));
            database.executeBatch(new Batch_DeliveriesOwnerSynch('select Id,Name,ownerId,Sold_To__r.OwnerId  from Deliveries__c where  Sold_To__r.Owner.isActive = true'));
        Test.stopTest();
        
        
    } 
    
}
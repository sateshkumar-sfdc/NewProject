@isTest
public class BeforeEventTrigger_Test{
  @isTest static void UNITTest() {      
      
      
        Account Acc  = new Account(Name = 'test',ENSX_EDM__SAP_Customer_Number__c = 'test123');
        insert Acc; 
        
        Event t = new Event();
        t.DurationInMinutes = 10;
        t.ActivityDateTime = system.now();
        t.Subject = 'Test_'+Acc.Name+'_SAP';
        t.description ='Tast SAP_Customer_Number Test';
        t.ActivityDate = system.today()+7;
        t.WhatId = Acc.Id;
        insert t; 
        
        t = [select Id,SAP_Customer_Number__c from Event where Id=: t.Id];
        system.assertEquals(t.SAP_Customer_Number__c,'test123');       
      
  }
}
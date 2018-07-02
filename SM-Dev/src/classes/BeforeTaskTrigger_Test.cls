@isTest
public class BeforeTaskTrigger_Test{
  @isTest static void UNITTest() {      
      
      
        Account Acc  = new Account(Name = 'test',ENSX_EDM__SAP_Customer_Number__c = 'test123');
        insert Acc; 
        
        Task t = new Task();
        t.Subject = 'Test_'+Acc.Name+'_SAP';
        t.description ='Tast SAP_Customer_Number Test';
        t.ActivityDate = system.today()+7;
        t.WhatId = Acc.Id;
        insert t; 
        
        t = [select Id,SAP_Customer_Number__c from Task where Id=: t.Id];
        system.assertEquals(t.SAP_Customer_Number__c,'test123');      
      
  }
}
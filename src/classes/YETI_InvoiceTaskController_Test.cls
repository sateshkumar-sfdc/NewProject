@isTest
public class YETI_InvoiceTaskController_Test{
  @isTest static void UNITTest() {      
      
      
        Account Acc  = new Account(Name = 'test');
        insert Acc;        
      
        Date Last1Day = system.today()-1;
        invoice__c inv = new invoice__c(Name ='inv1',Ship_To__c = Acc.id,Due_Date__c = Last1Day,status__c = 'Not Completed');
        insert inv;
        
        inv = [select Ship_To__c from invoice__c where id=: inv.id];
        inv.Ship_To__c = Acc.id;
        update inv;
        system.assertEquals([select Ship_To__c from invoice__c where id=: inv.id].Ship_To__c,Acc.id);
        
        Task t = new Task();
        t.Subject = inv.name+' is not completed after due date';
        t.description ='You have past due invices, click here Past Due invice on the invice table';
        t.ActivityDate = inv.Due_Date__c;//system.today()+7;
        t.WhatId = inv.Id;
        insert t;   
            
        //getIsPostinvices
        boolean flag = YETI_InvoiceTaskController.getIsPostinvoices();
        //getAllinviceTask
        List<YETI_InvoiceTaskController.MyinvoiceTask> lstTasks = YETI_InvoiceTaskController.getAllinvoiceTask();
        
        
      
      
  }
}
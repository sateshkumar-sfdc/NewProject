/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  23rd March 2017
Name          :  Yeti_printInvoiceControllerTest
Description   :  Test Class for Yeti_printinvoice 
*/
@isTest
public class Yeti_printInvoiceControllerTest {
  @testSetup
  static void createTestData(){
    YETI_TestDataFactory ytdf = new YETI_TestDataFactory();
    Account acc = ytdf.createAccount('Test Account', true);
    Invoice__c inv = ytdf.createInvoice('Test Invoice', acc.Id, true);
    List<Invoice_Lines__c> lstInvoiceLines = ytdf.createMultipleInvoiceLines('TestInvoiceLines',inv.Id,10,true);
    lstInvoiceLines[0].Discount__c = 12.00;
    update lstInvoiceLines[0];
    
  }
  
  static testmethod void testPrintInvoicePage(){
    Test.startTest();
      Invoice__c inv = [SELECT Id,Name FROM Invoice__c WHERE Name =: 'Test Invoice' LIMIT 1];
      ApexPages.currentPage().getParameters().put('id',inv.Id);
      Yeti_PrintInvoiceController ypdc = new Yeti_PrintInvoiceController();
      system.assertEquals(true, ApexPages.currentPage().getParameters().get('id') != null);
    Test.stopTest();
  }
}
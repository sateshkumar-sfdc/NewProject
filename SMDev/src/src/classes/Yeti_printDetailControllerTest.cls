/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  23rd March 2017
Name          :  Yeti_printDetailControllerTest
Description   :  Test Class for Yeti_printDetailController 
*/
@isTest
public class Yeti_printDetailControllerTest {
  @testSetup
  static void createTestData(){
    YETI_TestDataFactory ytdf = new YETI_TestDataFactory();
    Account acc = ytdf.createAccount('Test Account', true);
    Order__c ord = ytdf.createOrder('Test Order', acc.Id, true);
    Invoice__c inv = ytdf.createInvoice('Test Invoice', acc.Id, true);
    Deliveries__c shipm = ytdf.createDeliveries('Test Shipment', acc.Id, true);
  }
  
  static testmethod void redirectToPdfTest(){
    Test.startTest();
      Order__c ord = [SELECT Id,Name FROM Order__c WHERE Name =: 'Test Order' LIMIT 1];
      ApexPages.currentPage().getParameters().put('id',ord.Id);
      Yeti_printDetailController ypdc = new Yeti_printDetailController();
      ypdc.redirectToPDFPage();
      system.assertEquals(true, ApexPages.currentPage().getParameters().get('id') != null);
    Test.stopTest();
  }
  
  static testmethod void redirectToPdfTestCase2(){
    Test.startTest();
      Invoice__c inv = [SELECT Id,Name FROM Invoice__c WHERE Name =: 'Test Invoice' LIMIT 1];
      ApexPages.currentPage().getParameters().put('id',inv.Id);
      Yeti_printDetailController ypdc = new Yeti_printDetailController();
      ypdc.redirectToPDFPage();
      system.assertEquals(true, ApexPages.currentPage().getParameters().get('id') != null);
    Test.stopTest();
  }
  
  static testmethod void redirectopdfcase3(){
    Test.startTest();
      Deliveries__c del = [SELECT Id,Name FROM Deliveries__c WHERE Name =: 'Test Shipment' LIMIT 1];
      ApexPages.currentPage().getParameters().put('id',del.Id);
      Yeti_printDetailController ypdc = new Yeti_printDetailController();
      ypdc.redirectToPDFPage();
      system.assertEquals(true, ApexPages.currentPage().getParameters().get('id') != null);
    Test.stopTest();
  }
}
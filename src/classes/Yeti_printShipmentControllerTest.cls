/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  23rd March 2017
Name          :  Yeti_printShipmentControllerTest
Description   :  Test Class for Yeti_printShipmentController 
*/
@isTest
public class Yeti_printShipmentControllerTest {
  @testSetup
  static void createTestData(){
    YETI_TestDataFactory ytdf = new YETI_TestDataFactory();
    Account acc = ytdf.createAccount('Test Account', true);
    Deliveries__c del = ytdf.createDeliveries('Test Delivery', acc.Id, true);
    List<Delivery_Lines__c> lstInvoiceLines = ytdf.createMultipleDeliveryLines('TestOrderLines',del.Id,5,true);
  }
  
  static testmethod void testPrintOrderPage(){
    Test.startTest();
      Deliveries__c inv = [SELECT Id,Name FROM Deliveries__c WHERE Name =: 'Test Delivery' LIMIT 1];
      ApexPages.currentPage().getParameters().put('id',inv.Id);
      Yeti_PrintShipmentController ypdc = new Yeti_PrintShipmentController();
      system.assertEquals(true, ApexPages.currentPage().getParameters().get('id') != null);
    Test.stopTest();
  }
}
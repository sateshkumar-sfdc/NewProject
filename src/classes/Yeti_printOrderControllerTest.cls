/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  23rd March 2017
Name          :  Yeti_printOrderControllerTest
Description   :  Test Class for Yeti_printOrderController 
*/
@isTest
public class Yeti_printOrderControllerTest {
  @testSetup
  static void createTestData(){
    YETI_TestDataFactory ytdf = new YETI_TestDataFactory();
    Account acc = ytdf.createAccount('Test Account', true);
    Order__c ord = ytdf.createOrder('Test Order', acc.Id, true);
    List<Order_Line__c> lstInvoiceLines = ytdf.createMultipleOrderLines('TestOrderLines',ord.Id,5,true);
  }
  
  static testmethod void testPrintOrderPage(){
    Test.startTest();
      Order__c inv = [SELECT Id,Name FROM Order__c WHERE Name =: 'Test Order' LIMIT 1];
      ApexPages.currentPage().getParameters().put('id',inv.Id);
      Yeti_PrintOrderController ypdc = new Yeti_PrintOrderController();
      system.assertEquals(true, ApexPages.currentPage().getParameters().get('id') != null);
    Test.stopTest();
  }
}
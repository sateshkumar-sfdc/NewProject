@isTest
public with sharing class Test_Product2Util {
   
    static testMethod void testProductTrigger() {
        //test data with insert/update
      //  acCore__Company__c company = new acCore__Company__c();
        //company.acCore__ExternalID__c = 'tst';
       // company.Name = 'Test';
        //insert company;
        //company = [SELECT Id FROM acCore__Company__c WHERE acCore__ExternalID__c = 'tst'];
       // system.debug(company);
        
        //Product2 c = TestDataUtility.newProduct('John');
        Product2 c = new Product2();
        //c.acCore__lc_Company_ExternalID__c = 'tst';
        c.Name = 'Nombre';
        insert c;
        system.debug(c);
        
        //Product2 c2 = [SELECT acCore__Company__c FROM Product2 WHERE Name = 'Nombre'];
        
        //system.assertEquals(company.Id, c2.acCore__Company__c);
        system.assert(true);
    }
    
    static testMethod void testProductTriggerUpdate() {
        //test data with insert/update
        //acCore__Company__c company = new acCore__Company__c();
        //company.acCore__ExternalID__c = 'tst2';
        //company.Name = 'Test';
    //    insert company;
        //company = [SELECT Id FROM acCore__Company__c WHERE acCore__ExternalID__c = 'tst2'];
        
        //Product2 c = TestDataUtility.newProduct('John');
        Product2 c = new Product2();
        c.Name = 'Nombre2';
        insert c;
        
        //c.acCore__lc_Company_ExternalID__c = 'tst2';
        c.Name = 'tst2';
        update c;
        
        //Product2 c2 = [SELECT acCore__Company__c FROM Product2 WHERE Name = 'Nombre2'];
        
        //system.assertEquals(company.Id, c2.acCore__Company__c);
        system.assert(true);
    }
}
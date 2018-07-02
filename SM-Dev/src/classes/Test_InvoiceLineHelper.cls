@isTest
public with sharing class Test_InvoiceLineHelper {
  
  
  static testMethod void testSalesTargetLink() {
        
    // Create Test Data for Testing
     //   TestDataGenerator data = new TestDataGenerator();
    //    List<Sales_Target__c> sTarget = data.getSalesTargets(true);
        
     //   system.debug('***** sTarget  :'+sTarget);
        
    //    test.startTest();
      // Create Test Data and match Invoice lines with Sales Target records 
    //  List<acSales__InvoiceLine__c> InvoiceLines = data.getInvoiceLines(true);

   /* test.stopTest();      
    // Check that the Invoice Lines are linking to the Sales Target for user marked "All Others" 
    Sales_Target__c  stCoolersRec = [Select Id from Sales_Target__c where Product_Category__c='Coolers']; 
    
    for (acSales__InvoiceLine__c iLCheck:[Select Id, Sales_Target__c, Product_Category__c from acSales__InvoiceLine__c where Id IN :InvoiceLines]){
      
      system.debug('***** Product Category :'+iLCheck.Product_Category__c);
      system.assertEquals(iLCheck.Sales_Target__c, stCoolersRec.Id);  // Each of the lines should be Linked to the Cooler Sales Target
      
      
    }
    }*/
    
    
 // public static testMethod void testSalesTargetLinkwithNonValidProductCategoryGroup() {

    // Create Test Data for Testing
      //  TestDataGenerator data = new TestDataGenerator();
        
       // List<Sales_Target__c> sTarget = data.getSalesTargets(true);

    // Create Test Data for Current Owner and         
      //  List<acSales__InvoiceLine__c> InvoiceLines = data.getInvoiceLines(true);
        
        
      // Create Test Data and match Invoice lines with Sales Target records 
      // Now go and change ownership of Invoice Record to Not match on Owner
        
      Set<Id> productSetId = new Set<Id>();  

      
      
    /*  for (acSales__InvoiceLine__c il:InvoiceLines){
        productSetId.add(il.acSales__Product__c);
      }*/
      
      
     // List<Product2> updateProductCat = new List<Product2>(); 
      //for(Product2 p:[Select Id, acCore__ProductGroup__c from Product2 Product2 where Id IN :productSetId]){
        //p.acCore__ProductGroup__c = null;   // Remove the PRoduct Group, will mimic the product having a wrong Product Code for Sales Targets
        //updateProductCat.add(p);      // This will Make the Product show up as "Needs to be Classified"
      }
      
      // Update the Invoice Invoice Date to another date out of Sales Target Range --> Map to nothing
     // if (updateProductCat.size() > 0){
       // update updateProductCat;
      //}
      
      // Now go and update the Invoice Lines, the Target Status should be empty, as there is no Salestarget for this new Owner
   /*   test.startTest();  
        update InvoiceLines;
      test.stopTest();*/
      
      
      // Check that the Invoice Lines are linking to the Sales Target for user marked "All Others" 
  /*    Sales_Target__c  stAllOthersRec = [Select Id from Sales_Target__c where Product_Category__c='All Other']; 
      
      for (acSales__InvoiceLine__c iLCheck:[Select Id, Sales_Target__c, Product_Category__c from acSales__InvoiceLine__c where Id IN :InvoiceLines]){
        system.debug('***** Product Category 2 :'+iLCheck.Product_Category__c);
        system.assertEquals(iLCheck.Product_Category__c, 'Needs to be Classified');
      }
    }  */  
    

  
 // public static testMethod void testSalesTargetLinkwithNoOwnerMatch() {


        String anOrgID = (String) Userinfo.getOrganizationId();
        User aDifferentUser = new User( LastName = 'SalesTestUser' + anOrgID
                                    , Email = 'SalesOrderSummaryTestUser@' + anOrgID + 'test.com.dev'
                                    , Username = 'SalesOrderSummaryTestUser@' + anOrgID + 'test.com'
                                    , Alias = 'STestU'
                                    , TimeZoneSidKey = 'America/Los_Angeles'
                                    , LocaleSidKey = 'en_US'
                                    , EmailEncodingKey = 'UTF-8'
                                    , ProfileId = UserInfo.getProfileID()
                                    , LanguageLocaleKey = 'en_US' );
     //   insert aDifferentUser;

    // Create Test Data for Testing
     //   TestDataGenerator data = new TestDataGenerator();
        
     //   List<Sales_Target__c> sTarget = data.getSalesTargets(true);

    // Create Test Data for Current Owner and         
   //     List<acSales__InvoiceLine__c> InvoiceLines = data.getInvoiceLines(true);
        
        
      // Create Test Data and match Invoice lines with Sales Target records 
      // Now go and change ownership of Invoice Record to Not match on Owner
        
      Set<Id> accountSetIds = new Set<Id>();  

      
  /*    for (acSales__InvoiceLine__c il:InvoiceLines){
        accountSetIds.add(il.acSales__ShipToAccount__c);
      }
      */
      
    /*  List<Account> updateAccountList = new List<Account>(); 
      for(Account a:[Select Id, OwnerId from Account where Id IN :accountSetIds]){
        a.OwnerId = aDifferentUser.Id;
        
        updateAccountList.add(a);
      }*/
      
      // Update the Invoice Owner Fields
  /*    if (updateAccountList.size() > 0){
        update updateAccountList;
      }*/
      
      // Now go and update the Invoice Lines, the Target Status should be empty, as there is no Salestarget for this new Owner
   /*   test.startTest();  
        update InvoiceLines;
      test.stopTest();
      */
      // Check each record to see if No Sales Target should be linked or not //
      
  /*    for (acSales__InvoiceLine__c iLCheck:InvoiceLines){
        system.assertEquals(iLCheck.Sales_Target__c, NULL);  // Each of the lines should be empty as no Sales Targets Exists
      }
    }*/


//  public static testMethod void testSalesTargetLinkwithNoDates() {

    Date todaysCurrentDate =date.today();

    // Create Test Data for Testing
      //  TestDataGenerator data = new TestDataGenerator();
        
    //    List<Sales_Target__c> sTarget = data.getSalesTargets(true);

    // Create Test Data for Current Owner and         
      //  List<acSales__InvoiceLine__c> InvoiceLines = data.getInvoiceLines(true);
        
        
      // Create Test Data and match Invoice lines with Sales Target records 
      // Now go and change ownership of Invoice Record to Not match on Owner
        
    //  Set<Id> invoiceSetIds = new Set<Id>();  

      
  /*    for (acSales__InvoiceLine__c il:InvoiceLines){
        invoiceSetIds.add(il.acSales__Invoice__c);
      }*/
      
      
    /*  List<acSales__Invoice__c> updateInvoicesList = new List<acSales__Invoice__c>(); 
      
      for(acSales__Invoice__c a:[Select Id, acSales__InvoiceDate__c from acSales__Invoice__c where Id IN :invoiceSetIds]){
        a.acSales__InvoiceDate__c = todaysCurrentDate.addMonths(-4);
        
        updateInvoicesList.add(a);
      }*/
      
      // Update the Invoice Invoice Date to another date out of Sales Target Range --> Map to nothing
    //  if (updateInvoicesList.size() > 0){
    //    update updateInvoicesList;
    //  }
      
      // Now go and update the Invoice Lines, the Target Status should be empty, as there is no Salestarget for this new Owner
   /*   test.startTest();  
        update InvoiceLines;
      test.stopTest();*/
      
      // Check each record to see if No Sales Target should be linked or not //
      
    //  for (acSales__InvoiceLine__c iLCheck:InvoiceLines){
      //  system.assertEquals(iLCheck.Sales_Target__c, NULL);  // Each of the lines should be empty as no Sales Targets Exists
     // }
   
}
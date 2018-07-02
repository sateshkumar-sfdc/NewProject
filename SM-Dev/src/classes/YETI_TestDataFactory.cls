/*
// (c) 2017 Appirio, Inc.
//
// Class Name : YETI_TestDataFactory
// Description: This class is used for test data creation

// 21th March 2017    Rakshit Virmani
*/

@isTest
public class YETI_TestDataFactory {
  
  // Method to create account 
  public Account createAccount(String accName,Boolean isInsert){
    Account ac = new Account(name =accName) ;
    if(isInsert)
      insert ac; 
    return ac;
  }
  
  // Method to create Contact
  public Contact createContact(Id AccId, String contactName ,Boolean isInsert){
    Contact con = new Contact(LastName =contactName,AccountId = AccId);
    if(isInsert)
      insert con; 
    return con;
  }
  
  // Method to create Case
  public case createCase(String caseName,Id accId, Boolean isInsert){
    Case cs = new Case(Subject =caseName, AccountId = accId);
    if(isInsert)
      insert cs;
    return cs;
  }
  
  // Method to create Order
  public Order__c createOrder(String orderName,Id accId, Boolean isInsert){
    Order__c ordr = new Order__c(Name =orderName,Ship_To__c = accId);
    if(isInsert)
      insert ordr;
    return ordr;
  }
  
  // Method to create Invoice
  public Invoice__c createInvoice(String invoiceName,Id accId, Boolean isInsert){
    Invoice__c invo = new Invoice__c(Name =invoiceName,Ship_To__c = accId);
    if(isInsert)
      insert invo;
    return invo;
  }
  
  // Method to create Shipment
  public Deliveries__c createDeliveries(String deliveryName,Id accId, Boolean isInsert){
    Deliveries__c deli = new Deliveries__c(Name =deliveryName,Ship_To__c = accId);
    if(isInsert)
      insert deli;
    return deli;
  }
  
  // Method to create Opportunity
  public Opportunity createOpportunity(String opportunityName,Id accId, Boolean isInsert){
    Opportunity opp = new Opportunity(Name =opportunityName,AccountId = accId, StageName='Pending Prebook', CloseDate = Date.Today());
    if(isInsert)
      insert opp;
    return opp;
  }
  
  // Method to create multiple opportunities
  public List<Opportunity> createMultipleOpportunity(String opportunityNAme, Id accId, Integer count, Boolean isInsert){
    List<Opportunity> lstOpportunities = new List<Opportunity> ();
    for (Integer i=0 ; i < count ; i++){
      Opportunity opp = new Opportunity(Name =opportunityName+i,AccountId = accId, StageName='Pending Prebook', CloseDate = Date.Today());
      lstOpportunities.add(opp);
    }
    
    if(isInsert)
      insert lstOpportunities;
      
    return lstOpportunities;
  }
  
  // Method to create multiple cases
  public List<case> createMultipleCase(String caseSubject, Id accId, Integer count, Boolean isInsert){
    List<case> lstCases = new List<case> ();
    for (Integer i=0 ; i < count ; i++){
      Case cs = new Case(Subject =caseSubject, AccountId = accId);
      cs.Trading_Post_Visible__c = true;
      lstCases.add(cs);
    }
    
    if(isInsert)
      insert lstCases;
      
    return lstCases;
  }
  
  // Method to create multiple invoice
  public List<Invoice__c> createMultipleInvoice(String invoiceName, Id accId, Integer count, Boolean isInsert){
    List<Invoice__c> lstInvoices = new List<Invoice__c> ();
    for (Integer i=0 ; i < count ; i++){
      Invoice__c invo = new Invoice__c(Name =invoiceName,Ship_To__c = accId);
      lstInvoices.add(invo);
    }
    
    if(isInsert)
      insert lstInvoices;
      
    return lstInvoices;
  }
  
  // Method to create multiple deliveries
  public List<Deliveries__c> createMultipleDelivery(String deliveryName, Id accId, Integer count, Boolean isInsert){
    List<Deliveries__c> lstDeliveries = new List<Deliveries__c> ();
    for (Integer i=0 ; i < count ; i++){
      Deliveries__c deli = new Deliveries__c(Name =deliveryName,Ship_To__c = accId);
      lstDeliveries.add(deli);
    }
    
    if(isInsert)
      insert lstDeliveries;
      
    return lstDeliveries;
  }
  
  // Method to create multiple orders
  public List<Order__c> createMultipleOrders(String orderName, Id accId, Integer count, Boolean isInsert){
    List<Order__c> lstOrders = new List<Order__c> ();
    for (Integer i=0 ; i < count ; i++){
      Order__c ordr = new Order__c(Name =orderName,Ship_To__c = accId);
      lstOrders.add(ordr);
    }
    
    if(isInsert)
      insert lstOrders;
      
    return lstOrders;
  }
  
  // Method to create Invoice Line 
  public List<Invoice_Lines__c> createMultipleInvoiceLines(String invLinesName, Id invId, Integer count, Boolean isInsert){
    List<Invoice_Lines__c> lstInvLines = new List<Invoice_Lines__c> ();
    for (Integer i=0 ; i < count ; i++){
      Invoice_Lines__c invLines = new Invoice_Lines__c(Name =invLinesName,Invoice__c = invId);
      lstInvLines.add(invLines);
    }
    
    if(isInsert)
      insert lstInvLines;
      
    return lstInvLines;
  }
  
  // Method to create Order Lines
  public List<Order_Line__c> createMultipleOrderLines(String ordLinesName, Id ordId, Integer count, Boolean isInsert){
    List<Order_Line__c> lstOrdLines = new List<Order_Line__c> ();
    for (Integer i=0 ; i < count ; i++){
      Order_Line__c ordLines = new Order_Line__c(Name =ordLinesName,Order_Details__c = ordId);
      lstOrdLines.add(ordLines);
    }
    
    if(isInsert)
      insert lstOrdLines;
      
    return lstOrdLines;
  }
  
  // Method to create Delivery Lines
  public List<Delivery_Lines__c> createMultipleDeliveryLines(String delLinesName, Id delId, Integer count, Boolean isInsert){
    List<Delivery_Lines__c> lstDelLines = new List<Delivery_Lines__c> ();
    for (Integer i=0 ; i < count ; i++){
      Delivery_Lines__c delLines = new Delivery_Lines__c(Name =delLinesName,Deliveries__c = delId);
      lstDelLines.add(delLines);
    }
    
    if(isInsert)
      insert lstDelLines;
      
    return lstDelLines;
  }
  
  

  // Method to create community user
  public User createCommunityUser(String firstNme, String lastNme,Id ContactId,Boolean isInsert){
    Id profId = [SELECT id from profile where name = :Label.YETI_DealerCorporateProfileName LIMIT 1].id;
              
    String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
    
    User tuser = new User(  firstname = firstNme,
                            lastName = lastNme,
                            ContactId = ContactId,
                            email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org',
                            EmailEncodingKey = 'ISO-8859-1',
                            Alias = uniqueName.substring(18, 23),
                            TimeZoneSidKey = 'America/Los_Angeles',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US',
                            ProfileId = profId);
    if(isInsert)
      insert tuser;
    return tuser;
  }
  
  
  // Utility method for creating single object, and submitting for approval.
  // The method should return the Id of the work item generated as a result of the submission.
  
  public Id generateAndSubmitObject() {
        // Create a sample Opportunity object and then submit it for approval.
        Account acc = createAccount('Test Account', true);
        Contact cn = createContact(acc.Id,'Test Contact', true);
        Opportunity opp = createOpportunity('Test Opportunity',acc.Id,true );
        
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        User use = createCommunityUser('TestUser','TestUser',cn.Id,true);
        
        testReq.setObjectId(opp.Id);
        testReq.setNextApproverIds(new Id[] {use.Id});
        
        Approval.ProcessResult reqResult = Approval.process(testReq);
        
        System.assert(reqResult.isSuccess(),'Unable to submit new invoice statement record for approval');
        
        return reqResult.getNewWorkitemIds()[0];
    }
    
    // Utility method for creating Approval.ProcessResult
    // The method should return the Approval.ProcessResult.
    public Approval.ProcessResult createProcessInstance(Id recordId){
        if([select count() from ProcessInstance where targetobjectid=:recordId] < 1){       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(recordId);

            //Submit the approval request
            Approval.ProcessResult result = Approval.process(req);
            return result;
        }
        return null;
    }
}
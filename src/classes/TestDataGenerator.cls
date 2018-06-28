public class TestDataGenerator {
 
      //Always allow for the creation of one or more users
      public List<User> users;
      public Map<String,List<User>> profileToUserMap;      

      public List<Account> accounts;   // Remove replace with Account Test Methods for preexisting test methods
      public List<Contact> contacts;
      public List<Opportunity> opportunities; 
      public Pricebook2 pricebook;
      public List<Product2> products;
      public List<PricebookEntry> pricebookEntries;
      
     // public List<acCore__ProductGroup__c> productGroup;
      
      
     // public List<Sales_Target__c> salesTargets;
  //    public List<acSales__Invoice__c> invoices;
   //   public List<acSales__InvoiceLine__c> invoiceLines;
      
      
      //public List<OpportunityLineItem> opportunityLineItems;
      public List<Lead> leads;
      public List<Case> cases;

      
      public List<Asset> assets;
      
      public Integer userNum;
      public Integer accountNum;
      public Integer contactNum;
      public Integer opptyNum;
      public Integer opptyLineItemNum;
      public Integer productNum;
      public Integer pricebookEntryNum;
      public Integer leadNum;
      public Integer caseNum;
      public Integer assetNum;
      
  //    public Integer salesTargetNum;
     // public Integer invoiceNum;
      //public Integer invoiceLineNum;

      
      public TestDataGenerator(){
            userNum = 5;
            //accountNum = 6;
            contactNum = 6;
            opptyNum = 3;
            opptyLineItemNum = opptyNum * 20;
            productNum = 10;
            pricebookEntryNum = productNum;
            leadNum = 5;
            caseNum = 5;
            assetNum = 5;

          //  salesTargetNum=10;
          //  invoiceNum=10;
          //  invoiceLineNum=10;
      }
      

      
      public Map<String,List<User>> getProfileToUserMap(List<String> profileNames) {
            System.debug('*** getProfileToUserMap');
            getUsers(profileNames);
            return profileToUserMap;
      } 
      
      //A user need a profile
      public List<User> getUsers(List<String> profileNames){
            System.debug('*** getUsers');
            if(users == null) {
                  users = new List<User>();
                  
                  //There are 3 classes of users, create at least one of each
                  if(profileNames == null || profileNames.size() == 0) {
                        profileNames = new List<String>();
                        profileNames.add('Standard User');        
                  }
                  
                  System.debug('*** profileNames: ' + profileNames);
                  
                  Map<Id,Profile> profileMap;               
                  try {       
                        profileMap = new Map<Id,Profile>([select id, Name from profile where name IN :profileNames]);
                  } catch (Exception exp) {
                        //Can not test exceptions
                        System.debug('*** Could not find profiles: ' + exp.getMessage());                        
                  }
                  
                  if(profileMap == null || profileMap.size() == 0) {
                        profileMap = new Map<Id,Profile>([select id, Name from profile where name = 'Standard User']);
                  }
                  
                  System.debug('*** profileMap: ' + profileMap);
                  
                  //Untested - this should never happen, just 3x checking
                  if(profileMap == null || profileMap.size() == 0) {
                        System.assert(false,'Could not find profiles');
                        return null;
                  }
                                                      
                  if(userNum == null || userNum < profileMap.size()) {
                        userNum = profileMap.size();
                  }
                              
                  for(Integer i = 0; i < userNum; i++) {
                        Integer profilePosition = Math.mod(i,profileMap.size());
                        Integer random = Math.random().intValue();
                        User u = getUser(profileMap.values()[profilePosition], 'User' + i.format() + random.format());
                        users.add(u);                                   
                  }
                  
                  System.debug('*** inserting users');
                  insert users;
                  
                  //Now build the user map
                  profileToUserMap = new Map<String,List<User>>();
                  
                  for(User u : users) {
                        if(profileToUserMap.containsKey(profileMap.get(u.ProfileId).Name)) {
                              profileToUserMap.get(profileMap.get(u.ProfileId).Name).add(u);
                        } else {
                              List<User> tmpUsers = new List<User>();
                              tmpUsers.add(u);
                              profileToUserMap.put(profileMap.get(u.ProfileId).Name,tmpUsers);
                        }
                  }
            }           
            return users;
      }
      
      public User getUser(Profile p, String uniqueName){
            System.debug('*** getUser');
                        
            String orgId = (String)Userinfo.getOrganizationId();        
            String uniqueEmail = uniqueName + '@' + orgId + '.net.test';
            
            User u = new User(alias = 'standt', 
                              email=uniqueEmail,
                              emailencodingkey='UTF-8', 
                              lastname='Testing', 
                              languagelocalekey='en_US',
                              localesidkey='en_US', 
                              profileid = p.Id,
                              timezonesidkey='America/Los_Angeles',
                              username=uniqueEmail);
            return u;
      }
      
    
    /* public List<acSales__Invoice__c> getInvoices(Boolean xCommit) {
            
            Date todaysCurrentDate =date.today();
            
            if(Invoices == null) {
                  Invoices = new List<acSales__Invoice__c>();
                  for(Integer i = 0; i < invoiceNum; i++) {
                        acSales__Invoice__c si = new acSales__Invoice__c();
                        si.Name = 'Invoices - '+i;
                       // si.acSales__SoldToAccount__c = getAccounts(true)[0].Id;
                        si.acSales__InvoiceDate__c = todaysCurrentDate;
                               
                        Invoices.add(si);
                  }
                  
                  // Loop through and create Parent Accounts
                  if(xCommit) insert Invoices;
            }
            
            if(xCommit && Invoices.size() > 0 && Invoices[0].Id == null) insert Invoices;                                            
            
            return Invoices;
      }
       */    
  /*  public List<acSales__InvoiceLine__c> getInvoiceLines(Boolean xCommit) {
            
            Date todaysCurrentDate =date.today();
            
            List<Product2> productList = getProducts(true);
            List<Product2> refreshedList = new List<Product2>();
             
            // Request the Products 
            for (Product2 p:[Select Id, Name, Product_Category__c from Product2 Where Id IN: productList]){
                refreshedList.add(p);
            }
            
            
            if(InvoiceLines == null) {
                  InvoiceLines = new List<acSales__InvoiceLine__c>();
                  for(Integer i = 0; i < invoiceLineNum; i++) {
                        acSales__InvoiceLine__c sil = new acSales__InvoiceLine__c();
                        
                        sil.Name = 'Invoices - '+i;
                        sil.acSales__Invoice__c = getInvoices(true)[i].Id;
                     //   sil.acSales__ShipToAccount__c = getAccounts(true)[0].Id;
                        sil.acSales__Product__c = refreshedList[i].Id;
                        
                        
                        InvoiceLines.add(sil);
                  }
                  
                  // Loop through and create Parent Accounts
                  if(xCommit) insert InvoiceLines;
            }
            
            if(xCommit && InvoiceLines.size() > 0 && InvoiceLines[0].Id == null) insert InvoiceLines;                                            
            
            return InvoiceLines;
      }
                
*/
            
  /*    public List<Account> getAccounts(Boolean xCommit) {
    
            //Use another Class for checking data
            //TestDataUtility td = new TestDataUtility();

            // Only run if there are No accounts to use
            if(accounts == null) {

                accounts = new List<Account>();

                //Create test data
                Id customerRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Account' LIMIT 1].Id;
                Id shipToRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Ship to' LIMIT 1].Id;
                //Connect_Settings__c cs = TestDataUtility.newConnectSettings();
                //acCore__FOB__c fob = TestDataUtility.newFOB('Test FOB', 'TEST');
                //acCore__Company__c company = TestDataUtility.newCompany('Test Company', 'TEST');
                //acCore__CustomerGroup__c custGroup = TestDataUtility.newCustomerGroup('Test CustGroup', 'TEST');
                //acCore__SalesTerritory__c territory = TestDataUtility.newSalesTerritory('Test Territory', 'TEST');
                //acCore__FOB__c fobNew = TestDataUtility.newFOB('Test FOB New', 'TESTN');
                //acCore__Company__c companyNew = TestDataUtility.newCompany('Test Company New', 'TESTN');
                //acCore__CustomerGroup__c custGroupNew = TestDataUtility.newCustomerGroup('Test CustGroup New', 'TESTN');
                //acCore__SalesTerritory__c territoryNew = TestDataUtility.newSalesTerritory('Test Territory New', 'TESTN');
                
                Account customer = TestDataUtility.newAccount('Test Customer', 'Account', null);
                customer.RecordTypeId = customerRecordTypeId;
                customer.AccountNumber = 'AcctNum';
                customer.BillingStreet = '65 Enterprise Dr';
                customer.BillingCity = 'Aliso Viejo';
                customer.BillingState = 'CA';
                customer.BillingPostalCode = '92656';
                customer.BillingCountry = 'USA';
                customer.Website = 'www.alttechsolutions.com';
                customer.Description = 'Desc';
                //customer.acCore__AccountFOB__c = fob.Id;
                //customer.acCore__Company__c = company.Id;
                customer.acCore__CreditHold__c = False;
                customer.acCore__CreditLimit__c = 1000;
                customer.acCore__CreditTerms__c = 'N30';
                //customer.acCore__CustomerGroup__c = custGroup.Id;
                customer.acCore__DiscountPercent__c = 20;
                customer.acCore__Global__c = False;
                customer.acCore__NoContact__c = False;
                //customer.acCore__SalesTerritory__c = territory.Id;
                //Yeti Custom Fields        
                customer.Billing_Name__c = 'Billing Name';
                update customer;
                
                Account shipTo = new Account(Name = 'Test ShipTo', ParentId = customer.Id, RecordTypeId = shipToRecordTypeId);
                
                //Test sync between Customer and ShipTo Fields when ShipTo is inserted
                TriggerHelper.setAccountTrigger_UpdateShipToFireStatus(false);
                insert shipTo;
                                 
                system.debug('***** shipTo  :'+shipTo);
                accounts.add(shipTo);
            }
                  */
            // if(xCommit) insert accounts;
             //if(xCommit && accounts.size() > 0 && accounts[0].Id == null) insert accounts;

      //     return accounts;
             
            // return accounts;

            /*
            if(accounts == null) {
                  accounts = new List<Account>();
                  for(Integer i = 0; i < accountNum; i++) {
                        Account a = new Account();
                        a.Name = 'Test ' + i;   
                        a.BillingState = 'TX';       
                        a.BillingCountry = 'US';
                               
                        accounts.add(a);
                  }
                  
                  // Loop through and create Parent Accounts
                  if(xCommit) insert accounts;
            }
            
            if(xCommit && accounts.size() > 0 && accounts[0].Id == null) insert accounts;                                            
            
            return accounts;
            */
               
      public List<Contact> getContacts(Boolean xCommit) {
            if(contacts == null) {
                  contacts = new List<Contact>();
                  for(Integer i = 0; i < contactNum; i++) {
                        Contact c = new Contact();
                        
                        c.FirstName = 'First ' + i;
                        c.LastName = 'Last ' + i;
                        c.MailingState = 'TX';
                        c.MailingCountry ='US';
                        c.Email = 'mmmmm@salesforce.com';
                  //      Integer j = Math.mod(i,getAccounts(true).size());
                   //     c.Account = getAccounts(true)[j];
                        
                        contacts.add(c);
                  }
                  if(xCommit) insert contacts;
            }
            
            if(xCommit && contacts.size() > 0 && contacts[0].Id == null) insert contacts;
            
            return contacts;
      }
      
      
      
      public Pricebook2 getPricebook(Boolean xCommit) {
            if(pricebook == null) {
                  pricebook = new Pricebook2();
                  pricebook.IsActive = true;
                  pricebook.Name = 'Test Pricebook';
                  if(xCommit) insert pricebook;
            }
            
            if(xCommit && pricebook.Id == null) insert pricebook;                         
            
            return pricebook;
      }
      
      
      // Also Create Product Groups to Associate with this product 
      public List<Product2> getProducts(Boolean xCommit) {
            
           /*  if (productGroup == null){
               
                productGroup = new List<acCore__ProductGroup__c>();
                
                // Create the same number of product Groups as products test
                for(Integer i = 0; i < productNum; i++) {
                    acCore__ProductGroup__c pg = new acCore__ProductGroup__c();
                    pg.Name = 'Tundra '+i;
                    pg.acCore__ExternalID__c ='Tundra '+i; 
                    pg.acCore__GroupDescription__c ='Tundra '+i; 
                    productGroup.add(pg);
                }
                if(xCommit) insert productGroup;
               
            }
            if(xCommit && productGroup.size() > 0 && productGroup[0].Id == null) insert productGroup;   
            
            
            if(products == null) {
                  products = new List<Product2>();
                  for(Integer i = 0; i < productNum; i++) {
                    
                        // Create Cooler Products
                        Product2 p = new Product2();
                        p.IsActive = true;
                        p.Name = 'Test Product ' + i;
                        p.ProductCode = 'TestPCode ' + i;
                        
                      //  p.acCore__ProductGroup__c = productGroup[0].Id; // Assign a Tundra Cooler Product Group to the Product
                         
                        products.add(p);
                  }
                  if(xCommit) insert products;
            }
            
            if(xCommit && products.size() > 0 && products[0].Id == null) insert products;              
            
            return products;
             */
             return null;
      }
      
      
      
      public List<PricebookEntry> getPricebookEntries(Boolean xCommit) {
            if(pricebookEntries == null) {
                  pricebookEntries = new List<PricebookEntry>();
                  List<PricebookEntry> stdPricebookEntries = new List<PricebookEntry>();
                  
                  Pricebook2 standardPB = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
                  for(Integer i = 0; i < pricebookEntryNum; i++) {
                        PricebookEntry pbeStd = new PricebookEntry();
                        pbeStd.IsActive = true;
                        pbeStd.Pricebook2Id = standardPB.Id;
                        System.assertNotEquals(null, pbeStd.Pricebook2Id,standardPB);
                        
                        Integer j = Math.mod(i, getProducts(true).size());
                        pbeStd.Product2Id = getProducts(true)[j].Id;
                        System.assertNotEquals(null, pbeStd.Product2Id,getProducts(true)[j]);
                        
                        pbeStd.UnitPrice = i;
                        pbeStd.UseStandardPrice = false;
                        stdPricebookEntries.add(pbeStd);
                        
                        PricebookEntry pbe = new PricebookEntry();
                        pbe.IsActive = true;
                        pbe.Pricebook2Id = getPricebook(true).Id;
                        System.assertNotEquals(null, pbe.Pricebook2Id,getPricebook(true));
                                                
                        pbe.Product2Id = pbeStd.Product2Id;
                        System.assertNotEquals(null, pbe.Product2Id,pbeStd);
                        
                        pbe.UnitPrice = i;
                        pbe.UseStandardPrice = false;
                        pricebookEntries.add(pbe);
                  }
                  insert stdPricebookEntries;
                  if(xCommit) insert pricebookEntries;
            }
            
            if(xCommit && pricebookEntries.size() > 0 && pricebookEntries[0].Id == null) insert pricebookEntries;          
            
            return pricebookEntries;
      }
      
      
      /*
      public List<Opportunity> getOpportunities(Boolean xCommit) {
            if(opportunities == null) {
                  opportunities = new List<Opportunity>();
                  for(Integer i = 0; i < opptyNum; i++) {
                        Opportunity o = new Opportunity();
                        o.Name = 'Test ' + i;
                        o.CloseDate = Date.today().addDays(1);
                        o.StageName = '01-New';
                        Integer j = Math.mod(i,getAccounts(true).size());
                        o.Account = getAccounts(true)[j];
                        //o.Pricebook2Id = getPricebook(true).Id;
                        opportunities.add(o);
                  }
                  if(xCommit) insert opportunities;
            }
            
            if(xCommit && opportunities.size() > 0 && opportunities[0].Id == null) insert opportunities;
            
            return opportunities;
      }
      */
      
      
      /*
      public List<OpportunityLineItem> getOpportunityLineItems(Boolean xCommit) {
            if(opportunityLineItems == null) {
                  opportunityLineItems = new List<OpportunityLineItem>();
                  for(Integer i = 0; i < opptyLineItemNum; i++) {
                        OpportunityLineItem oli = new OpportunityLineItem();
                        
                        Integer j = Math.mod(i,getOpportunities(true).size());
                        oli.OpportunityId = getOpportunities(true)[j].Id;
                        
                        Integer k = Math.mod(i,getPricebookEntries(true).size());                     
                        oli.PricebookEntryId = getPricebookEntries(true)[k].Id;
                        
                        oli.Quantity = i + 1;
                        
                        oli.UnitPrice = getPricebookEntries(true)[k].UnitPrice;
                                          
                        opportunityLineItems.add(oli);                        
                  }
                  if(xCommit) insert opportunityLineItems;
            }
            
            if(xCommit && opportunityLineItems.size() > 0 && opportunityLineItems[0].Id == null) insert opportunityLineItems;
                        
            return opportunityLineItems;
      }
      */
      
      /*
      public List<Lead> getLeads(Boolean xCommit) {
            if(leads == null) {
                  leads = new List<Lead>();
                  for(Integer i = 0; i < leadNum; i++) {
                        Lead lead = new Lead();
                        lead.FirstName = 'First ' + i;
                        lead.LastName = 'Last ' + i;
                        lead.Email = 'email' + i + '@test.com';
                        lead.Phone = '555-555-555' + i;
                        lead.Company = 'Test Company' + i;
                        lead.State ='TX';
                        lead.Country='US';
                        
                        //  lead.Accept_Lead_Date__c=system.today()-34;
                        
                        
                  //      Integer j = Math.mod(i,getAccounts(true).size());
                  //      Account a = getAccounts(true)[j];                     
                        //lead.Company = a.Name;
                        
                        lead.Company = 'First ' + i;
                        
                        leads.add(lead);
                  }
                  if(xCommit) insert leads;
            }
            
            if(xCommit && leads.size() > 0 && leads[0].Id == null) insert leads;
            
            return leads;
      }
      */
 public List<Case> getCases(Boolean xCommit) {
    if(cases == null) {
      cases = new List<Case>();
      for(Integer i = 0; i < caseNum; i++) {
        Case c = new Case();
        c.Subject = 'Test Case ' + i;
        c.Origin = 'Phone';
        
     /*  Integer j = Math.mod(i,getAccounts(true).size());
    //    Account a = getAccounts(true)[j];        
        Contact contact = getContacts(true)[j];
        c.AccountId = a.Id;
        c.ContactId = c.Id;
        c.Status = 'New';
        c.Description = 'Description Text Test';
        //c.Project__c = project.Id;
        //c.AccountId = a.Id;
        //c.ContactId = contact.Id;
        //c.ContactID__c = contact.Id;
        */
        
        cases.add(c);
      }
      if(xCommit)  insert cases;
    }
    
    if(xCommit && cases.size() > 0 && cases[0].Id == null) insert cases;
    
    return cases;
  }      
  

  /*
    public List<Asset> getAssets(Boolean xCommit) {
        if(assets == null) {
          assets = new List<Asset>();
          List<Account> accountList = getAccounts(true);

          
          for(Integer i = 0; i < assetNum; i++) {
            Asset aa = new Asset();
            aa.Name = 'Test'+i;
            aa.AccountId = accountList[0].Id;
            
            assets.add(aa);
          }
          if(xCommit)  insert assets;
    }
    
    if(xCommit && assets.size() > 0 && assets[0].Id == null) insert assets;
    
    return assets;
  } 
 
   
      public void initAllTestData() {
//              getCaseSettings();
     //       getSalesTargets(true);
            getUsers(null);
            //getLeads(true);
            //getAccounts(true);

            getPricebook(true);
            getProducts(true);
            
            getInvoiceLines(true); // This produces test data for Invoice Lines, Invoices, Accounts and Products for testing
            getContacts(true);
            getCases(true);
            //getOrders(true);
            //getItems(true);
            
            //getOpportunities(true);
            //getOpportunityLineItems(true); 
        
            //getAssets(true);

            
      }
 
}
*/ }
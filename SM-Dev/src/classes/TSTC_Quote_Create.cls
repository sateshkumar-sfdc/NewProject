@isTest
public with sharing class TSTC_Quote_Create {

    
   
    @isTest
    static void test_CreateController(){
    	Test.startTest();
    	Account a = new Account();
	    	a.Name='Acme';
	    	a.BillingCity='Cincinnatti';
	    	insert a; 
		Test.setCurrentPageReference(new PageReference('Page.VFP_Quote_Create'));
    	string idParam = 'SF_AcctId';
		System.currentPageReference().getParameters().put(idParam, a.Id);
		CTRL_Quote_Create controller = new CTRL_Quote_Create();
    	Test.stopTest();
    	System.assertNotEquals(controller, null);
    }
    
    //@isTest
    static void test_initCreate(){
    	Test.startTest();
    	Account a = new Account();
	    	a.Name='Acme';
	    	a.BillingCity='Cincinnatti';
	    	insert a; 
		Test.setCurrentPageReference(new PageReference('Page.VFP_QuoteCreate'));
    	string idParam = 'SF_AcctId';
		System.currentPageReference().getParameters().put(idParam, a.Id);
		CTRL_Quote_Create controller = new CTRL_Quote_Create();
		controller.initCreate();
    	Test.stopTest();
    	System.assertNotEquals(controller, null);
    }
    
 	@isTest
    static void test_validateQuote(){
    	SBO_EnosixQuote_Detail.EnosixQuote salesQuote = new SBO_EnosixQuote_Detail.EnosixQuote();
    	Test.startTest();
    	boolean result = CTRL_Quote_Create.validateQuote(salesQuote, true);
		Test.stopTest();
		System.assert(false == result);
    }
  
    @isTest
    static void test_validateNewLineItem(){
    	SBO_EnosixQuote_Detail.ITEMS item = new SBO_EnosixQuote_Detail.ITEMS();
    	Test.startTest();
    	boolean result = CTRL_Quote_Create.validateNewLineItem(item);
		Test.stopTest();
		System.assert(false == result);
    }
    
    @isTest
    static void test_getNextItemNumber(){
    	SBO_EnosixQuote_Detail.EnosixQuote salesQuote = new SBO_EnosixQuote_Detail.EnosixQuote();
    	Test.startTest();
    	string result = CTRL_Quote_Create.getNextItemNumber(salesQuote, 20);
		Test.stopTest();
		System.assert('20' == result);
    }
    
    @isTest
    static void test_clearItem(){
    	Test.startTest();
    	CTRL_Quote_Create controller = new CTRL_Quote_Create();
    	controller.clearItem();
		Test.stopTest();
		System.assert(controller.newItem!=null);
    }
    
    @isTest
    static void test_getOrderTypes(){
    	CTRL_Quote_Create controller = new CTRL_Quote_Create();
    	Test.startTest();
		System.assert(controller.OrderTypes!=null);
		Test.stopTest();
    }
    
    @isTest
    static void test_getSalesOrganizations(){
    	CTRL_Quote_Create controller = new CTRL_Quote_Create();
    	Test.startTest();
		System.assert(controller.SalesOrganizations!=null);
		Test.stopTest();
    }
    
    @isTest
    static void test_getDistributionChannels(){
    	CTRL_Quote_Create controller = new CTRL_Quote_Create();
    	Test.startTest();
		System.assert(controller.DistributionChannels!=null);
		Test.stopTest();
    }
    
    @isTest
    static void test_getDivisions(){
    	CTRL_Quote_Create controller = new CTRL_Quote_Create();
    	Test.startTest();
		System.assert(controller.Divisions!=null);
		Test.stopTest();
    }
    
    @isTest
    static void test_getSoldToPartners(){
    	CTRL_Quote_Create controller = new CTRL_Quote_Create();
    	Test.startTest();
		System.assert(controller.SoldToPartners!=null);
		Test.stopTest();
    }
    
    @isTest
    static void test_getShipToPartners(){
    	CTRL_Quote_Create controller = new CTRL_Quote_Create();
    	Test.startTest();
		System.assert(controller.ShipToPartners!=null);
		Test.stopTest();
    }
    
    /*
    @isTest
    static void test_fetchOpportunityLineItems(){
   		Test.startTest();
   		Account a  = new Account();
    	a.Name='test acct';
    	insert a;
		Opportunity o = new Opportunity();
		o.AccountId = a.Id;
		o.Name = 'testopp';
		o.Description = 'tst description ASDF';
		o.StageName= 'Needs Analysis';
		o.Amount= 123.23;
		o.Probability = 20;
		o.TotalOpportunityQuantity= 12342;
		o.CloseDate = System.today();
		insert o;
		
		Product2 newProd = new Product2(Name = 'test product', family = 'test family');
		insert newProd;

		PriceBookEntry pbEntry = new PriceBookEntry(
    		UnitPrice = 300,
    		PriceBook2Id = Test.getStandardPricebookId(),
    		Product2Id = newProd.Id,
    		IsActive = true);
		insert pbEntry ;
		
		for(integer i = 0; i<10; i++){
			OpportunityLineItem oli = new OpportunityLineItem();
			oli.OpportunityId = o.Id;
			oli.Quantity = (i+1) *10;
			oli.UnitPrice = i*.95;
			oli.Description = 'test Desciption';
			insert oli;
		}
		List<OpportunityLineItem> fetchedolis = CTRL_Quote_Create.FetchOpportunityLineItems(o);
		Test.stopTest();
		System.assert(fetchedolis.size()>0);
    }
    
    
    @isTest
    static void test_translateOpportunityLineItem(){
    	Test.startTest();
    	Account a  = new Account();
    	a.Name='test acct';
    	insert a;
    	SBO_EnosixMaterial_Detail.EnosixMaterial matDetail = new SBO_EnosixMaterial_Detail.EnosixMaterial();
    	matDetail.Material = 'FG226';
    	SBO_EnosixMaterial_Detail.PLANT_DATA pd = new SBO_EnosixMaterial_Detail.PLANT_DATA();
    	pd.Plant = '1010';
    	pd.SalesOrganization = '1010';
    	pd.DistributionChannel = '10';
    	matDetail.PLANT_DATA.add(pd);
		Opportunity o = new Opportunity();
		o.AccountId = a.Id;
		o.Name = 'testopp';
		o.Description = 'tst description ASDF';
		o.StageName= 'Needs Analysis';
		o.Amount= 123.23;
		o.Probability = 20;
		o.TotalOpportunityQuantity= 12342;
		o.CloseDate = System.today();
		insert o;
		Product2 prod = new Product2();
		prod.ProductCode = 'FG226';
		prod.Name= 'FIN226,MTO,PD,Batch-Fifo,SerialNo';
		insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry();
		pbe.UnitPrice = 100;
		pbe.Pricebook2Id = pricebookId;
		pbe.Product2Id = prod.Id;
		pbe.UseStandardPrice = false;
		pbe.IsActive = true;
		insert pbe;
		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = o.Id;
		oli.Quantity = 10;
		oli.UnitPrice = .95;
		oli.Description = 'test Desciption';
		insert oli;
		SBO_EnosixQuote_Detail.ITEMS itm = CTRL_Quote_Create.TranslateOpportunityLineItem(oli,matDetail.Material, '1010','10');
		Test.stopTest();
		System.assert(itm != null);
    }
    */
    @isTest
    static void test_finalizeQuoteandUpdateOpportunity(){
		Test.startTest();
		Account a  = new Account();
    	a.Name='test acct';
    	insert a;
		Opportunity o = new Opportunity();
		o.AccountId = a.Id;
		o.Name = 'testopp';
		o.Description = 'tst description ASDF';
		o.StageName= 'Needs Analysis';
		o.Probability = 20;
		o.TotalOpportunityQuantity= 12342;
		o.CloseDate = System.today();
		insert o;
		SBO_EnosixQuote_Detail.EnosixQuote  sodets = new SBO_EnosixQuote_Detail.EnosixQuote ();
		sodets.NetOrderValue = 1234.12;
		sodets.SalesDocument = '0012345';
    	Opportunity finalizedOpp = CTRL_Quote_Create.FinalizeQuoteandUpdateOpportunity(o, sodets);
		System.assert(finalizedOpp!=null);
		Test.stopTest();
    }
    
}
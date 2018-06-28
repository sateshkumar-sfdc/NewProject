public class CreditCardSelectCon {
	
	private ApexPages.StandardController sc;
	public Opportunity opp {get;set;}
	public List<Wrapper> wrappers {get;set;}
	public Boolean allowEntry {get;set;}
	private static final Credit_Card_Settings__c settings = Credit_Card_Settings__c.getOrgDefaults();
	public Id clickedCCId {get;set;}
	public Id accountid {get;set;}

	public CreditCardSelectCon(ApexPages.StandardController controller) {
		
		system.debug('In Controller constructor');
		
		this.sc = controller;
		allowEntry = true;
		
		opp = (Opportunity)controller.getRecord();
		accountId = [SELECT AccountId FROM Opportunity WHERE Id =: opp.Id].AccountId;
		wrappers = new List<Wrapper>();
		for (Credit_Card__c cc : [SELECT Id, Chase_Profile_Id__c, Credit_Card_Type__c, Credit_Card_Number__c, Credit_Card_Name__c, Expiration_Month__c, Expiration_Year__c FROM Credit_Card__c WHERE Active__c = true AND Expired__c = false AND Account__c =: accountId ORDER BY Credit_Card_Type__c]) {
			Wrapper w = new Wrapper(cc);
			wrappers.add(w);
		}
		if (wrappers.isEmpty()) {
			ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.INFO, 'No Available credit cards, please enter new card');
			ApexPages.addMessage(message);
		}
		if (!settings.Allow_Multiple_Cards__c && !wrappers.isEmpty()) {
			allowEntry = false;
		}
	}
	
	public void unSelectCC() {
		for(Wrapper w : wrappers) {
			if (w.selected && w.creditCard.Id <> clickedCCId) {
				w.selected = false;
			}
		}
	}
	
	
	public PageReference onContinue(){
		
		//get selected credit card id
		Id ccId;
		String ccProfileId;
		String ccNum;
		String ccType;
		String ccMonth;
		String ccYear;
		
		for (Wrapper w : wrappers) {
			if (w.selected) {
				ccId = w.creditCard.Id;
				ccProfileId = w.creditCard.Chase_Profile_Id__c;
				ccNum = w.creditCard.Credit_Card_Number__c.right(4);
				ccType = w.creditCard.Credit_Card_Type__c;
				ccMonth = w.creditCard.Expiration_Month__c;
				ccYear = w.creditCard.Expiration_Year__c;
				break;
			}
		}
		
		//if none selected throw error
		if (ccId == null) {
			ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a credit card before continuing');
			ApexPages.addMessage(message);
			return null;
		}
		
		//update opp with selected credit card
		opp.Credit_Card__c = ccId;
		opp.Chase_Profile_Id__c = ccProfileId;
		opp.Credit_Card_Number__c = ccNum;
		opp.Credit_Card_Type__c = ccType;
		opp.Credit_Card_Name__c = 
		opp.Credit_Card_Expiration_Month__c = ccMonth;
		opp.Credit_Card_Expiration_Year__c = ccYear;

		try {
			update opp;
		}
		catch (Exception e) {
			ApexPages.addMessages(e);
			return null;
		}
		
		return new PageReference('/' + opp.Id);
		
	}
	
	//this method will need to be updated to only use productions accountId element Id when the sandboxes are refreshed
	public PageReference onNew() {
		string acctIdParam;
		if (URL.getSalesforceBaseUrl().getHost().left(4).equalsignorecase('c.cs')) {
			acctIdParam = 'CF00N19000000GPbb_lkid'; //BackupProd
			//acctIdParam = 'CF00N19000000GA9x_lkid'; //Dev
		}
		else {
			acctIdParam = 'CF00Ni000000FUGTm_lkid'; //Production
		}
		return new PageReference('/apex/addCreditCard?' + acctIdParam + '=' + accountId + '&scontrolCaching=1&sfdc.override=1&oppId=' + opp.Id);
	}
	
	
	Public class Wrapper {
		public Credit_Card__c creditCard {get;set;}
		public Boolean selected {get;set;}
		
		public Wrapper(Credit_Card__c cc) {
			system.debug('In wrapper constructor');
			this.creditCard = cc;
			this.selected = false;
		}
	}
	
}
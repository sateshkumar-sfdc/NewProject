public class CreditCardEntryCon {
	
	private ApexPages.StandardController sc;	
	private static final Credit_Card_Settings__c settings = Credit_Card_Settings__c.getOrgDefaults();
	public Id oppId;
	public Credit_Card__c creditCard {get;set;}
	public List<Credit_Card__c> creditCards {get;set;}
	public Boolean activeCards {get;set;}
	public Boolean multCardsAllowed {get;set;}
	public Boolean editMode {get;set;}
	public Boolean fromOpp {get;set;}
	public Boolean saveToAccount {get;set;}

	public CreditCardEntryCon(ApexPages.StandardController controller) {
		
		//controller and misc field setup (need to add fields for edit mode)
		List<String> fieldsToAdd = new List<String>{'Account__c', 'Chase_Profile_Id__c', 'Active__c', 'Address1__c', 'Address2__c', 'City__c', 'Country__c', 'Credit_Card_Name__c', 'Credit_Card_Number__c', 'Credit_Card_Type__c', 'Email__c', 'Expiration_Month__c', 'Expiration_Year__c', 'Phone__c', 'State__c', 'Zip__c'};
		this.sc = controller;
		multCardsAllowed = settings.Allow_Multiple_Cards__c;
		
		if (!Test.isRunningTest()) {
			this.sc.addFields(fieldsToAdd);
		}
		creditCard = (Credit_Card__c)controller.getRecord();
		
		//edit credit card?
		if (ApexPages.currentPage().getParameters().get('Id') != null) {
			editMode = true;
			read();
		}
		else {
			editMode = false;
		}
		
		//add new credit card from Opp?
		if (ApexPages.currentPage().getParameters().get('oppId') != null) {
			fromOpp = true;
			oppId = ApexPages.currentPage().getParameters().get('oppId');
		}
		else {
			fromOpp = false;
		}
		
		//any active cards?
		activeCards = false;
		creditCards = [SELECT Chase_Profile_Id__c, Active__c, Id FROM Credit_Card__c WHERE Account__c =: creditCard.Account__c AND Active__c = true];
		if (!creditCards.isEmpty()) {
			activeCards = true;
		}
		
		//hardcode data - country, active (if only one card is allowed)
		if(creditCard.Country__c == '' || creditCard.Country__c == null) {
			creditCard.Country__c = 'US';
		}
		
	}
	
	public PageReference addCard() {
		
		try {
			//set card to active
			creditCard.Active__c = true;
			
			//return and display errors if input validation fails
			if(!validInput('C')) {
				return null;
			}
			
			//add profile
			String result = OrbitalGateway.profileRequest(creditCard, 'C', 'Y');
			
			//display gateway error if any
			if (result <> 'success') {
				creditCard.addError(result);
				return null;
			}
			
			saveCardToAccount('C');
				
			return new PageReference('/' + creditCard.Account__c);
			
		}
		
		catch (Exception e) {
			ApexPages.addMessages(e);
			return null;
		}
		
	}
	
	public PageReference updateCard() {
		
		try {
			//return and display errors if input validation fails
			if(!validInput('U')) {
				return null;
			}
			
			//update profile
			String result = OrbitalGateway.profileRequest(creditCard, 'U', 'Y');
			
			//display gateway error if any
			if (result <> 'success') {
				creditCard.addError(result);
				return null;
			}
			
			saveCardToAccount('U');
				
			return new PageReference('/' + creditCard.Account__c);
			
		}
		
		catch (Exception e) {
				ApexPages.addMessages(e);
				return null;
		}
		
	}
	
	public PageReference addCardFromOpp() {
		
		try {
			//return and display errors if input validation fails
			if(!validInput('C')) {
				return null;
			}
			
			//add profile
			String result = OrbitalGateway.profileRequest(creditCard, 'C', 'N');
			
			//display gateway error if any
			if (result <> 'success') {
				creditCard.addError(result);
				return null;
			}
				
			Opportunity o = new Opportunity(Id = oppId, Chase_Profile_Id__c = creditCard.Chase_Profile_Id__c, Credit_Card_Type__c = creditCard.Credit_Card_Type__c, Credit_Card_Number__c = creditCard.Credit_Card_Number__c.right(4), Credit_Card_Name__c = creditCard.Credit_Card_Name__c, Credit_Card_Expiration_Year__c = creditCard.Expiration_Year__c, Credit_Card_Expiration_Month__c = creditCard.Expiration_Month__c);
			update o;
			return new PageReference('/' + oppId);
			
		}
		
		catch (Exception e) {
				ApexPages.addMessages(e);
				return null;
		}
		
		
	}
	
	public PageReference addCardFromOppAndSave() {
		
		
		try {
			//return and display errors if input validation fails
			if(!validInput('C')) {
				return null;
			}
			
			//add profile
			String result = OrbitalGateway.profileRequest(creditCard, 'C', 'Y');
			
			//display gateway error if any
			if (result <> 'success') {
				creditCard.addError(result);
				return null;
			}
			
			Id creditCardId = saveCardToAccount('C');
				
			Opportunity o = new Opportunity(Id = oppId, Credit_Card__c = creditCardId, Chase_Profile_Id__c = creditCard.Chase_Profile_Id__c, Credit_Card_Type__c = creditCard.Credit_Card_Type__c, Credit_Card_Number__c = creditCard.Credit_Card_Number__c.right(4), Credit_Card_Name__c = creditCard.Credit_Card_Name__c, Credit_Card_Expiration_Year__c = creditCard.Expiration_Year__c, Credit_Card_Expiration_Month__c = creditCard.Expiration_Month__c);
			update o;
			return new PageReference('/' + oppId);
			
		}
		
		catch (Exception e) {
			ApexPages.addMessages(e);
			return null;
		}
		
	}
	
	private Id saveCardToAccount(String modType) {
		
		//clone to prevent fields from being cleared if validations stop save
		Credit_Card__c ccToUpsert = creditCard.clone();
		
		ccToUpsert.Credit_Card_Number__c = CreditCardUtil.maskCard(ccToUpsert);
		
		//clear specific fields (retreived from Chase later when needed)
		ccToUpsert.Address1__c = '';
		ccToUpsert.Address2__c = '';
		ccToUpsert.City__c = '';
		ccToUpsert.State__c = '';
		ccToUpsert.Zip__c = '';
		ccToUpsert.Country__c = '';
		ccToUpsert.Email__c = null;
		ccToUpsert.Phone__c = '';
		ccToUpsert.Security_Code__c = null;
		
		//insert SF credit card record and deactive other card if needed
		List<Credit_Card__c> ccsToUpsert = new List<Credit_Card__c>();
		ccsToUpsert.add(ccToUpsert);
		
		if (!multCardsAllowed && activeCards && modType == 'C') {
			for (Credit_Card__c cc : creditCards) {
				if (cc.Active__c && cc.Chase_Profile_Id__c != ccToUpsert.Chase_Profile_Id__c) {
					cc.Active__c = false;
					ccsToUpsert.add(cc);
				}
			}
		}
		upsert ccsToUpsert Chase_Profile_Id__c;
		
		Id creditCardId = [SELECT Id FROM Credit_Card__c WHERE Chase_Profile_Id__c = : ccToUpsert.Chase_Profile_Id__c LIMIT 1].Id;
		
		return creditCardId;
		
	}
	
	public PageReference cancel() {
		if (oppId != null) {
			return new PageReference('/' + oppId);
		}
		else {
			return new PageReference('/' + creditCard.Account__c);
		}
	}
	
	private void read() {
		
		try {
			
			//read profile
			String result = OrbitalGateway.profileRequest(creditCard, 'R', '');
			
			//display gateway error if any
			if (result <> 'success') {
				ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, result);
				ApexPages.addMessage(message);
			}
			
		}
		
		catch (Exception e) {
			ApexPages.addMessages(e);
		}
		
	}
	
	private Boolean validInput(String modType) {
		
		Boolean validNum = true;
		Boolean validExp = true;
		Boolean validSecCode = true;//validSecCode();
		Boolean validZip = true;
		
		if (modType <> 'U') {
			validNum = validNum();
		}
		
		validExp = validExp();
		validSecCode = true;//validSecCode();
		validZip = validZip();
		
		if (!validNum || !validExp || !validSecCode || !validZip) {
			return false;
		}
		else {
			return true;
		}
		
		
	}
	
	private Boolean validNum() {
		
		Boolean validResults = true;
		
		if (creditCard.Credit_Card_Type__c == 'AMEX' && (creditCard.Credit_Card_Number__c.substring(0,1) <> '3' || creditCard.Credit_Card_Number__c.length() <> 15)) {
			creditCard.Credit_Card_Number__c.addError ('Enter a valid 15 digit AMEX credit card number');
			validResults = false;
		}
		else if (creditCard.Credit_Card_Type__c == 'VISA' && (creditCard.Credit_Card_Number__c.substring(0,1) <> '4' || creditCard.Credit_Card_Number__c.length() <> 16)) {
			creditCard.Credit_Card_Number__c.addError ('Enter a valid 16 digit Visa credit card number');
			validResults = false;
		}
		else if (creditCard.Credit_Card_Type__c == 'MC' && (creditCard.Credit_Card_Number__c.substring(0,1) <> '5' || creditCard.Credit_Card_Number__c.length() <> 16)) {
			creditCard.Credit_Card_Number__c.addError ('Enter a valid 16 digit Mastercard credit card number');
			validResults = false;
		}
		else if (creditCard.Credit_Card_Type__c == 'DISC' && (creditCard.Credit_Card_Number__c.substring(0,1) <> '6' || creditCard.Credit_Card_Number__c.length() <> 16)) {
			creditCard.Credit_Card_Number__c.addError ('Enter a valid 16 digit Discover credit card number');
			validResults = false;
		}
		
		return validResults;
	}
	
	private Boolean validExp() {
		
		Boolean validResults = true;
		
		if (Integer.valueOf(creditCard.Expiration_Year__c) < System.today().year()) {
			creditCard.Expiration_Year__c.addError ('Enter a valid year');
			validResults = false;
		}
		else if (Integer.valueOf(creditCard.Expiration_Year__c) == System.today().year() && Integer.valueOf(creditCard.Expiration_Month__c) < System.today().month()) {
			creditCard.Expiration_Month__c.addError ('Enter a valid month');
			validResults = false;
		}
		
		return validResults;

	}
	
	/*
	private Boolean validSecCode() {
		Boolean validResults = true;
		
		if ((creditCard.Credit_Card_Type__c == 'VISA' || creditCard.Credit_Card_Type__c == 'MC' || creditCard.Credit_Card_Type__c == 'DISC') && creditCard.Security_Code__c < 100) {
			creditCard.Security_Code__c.addError ('Enter a valid 3 digit security code');
			validResults = false;
		}
		else if (creditCard.Credit_Card_Type__c == 'AMEX' && creditCard.Security_Code__c < 1000) {
			creditCard.Security_Code__c.addError ('Enter a valid 4 digit security code');
			validResults = false;
		}
		
		return validResults;
	}*/
	
	private Boolean validZip() {
		Boolean validResults = true;
		
		if (!creditCard.Zip__c.isNumeric() || creditCard.Zip__c.length() <> 5) {
			creditCard.Zip__c.addError ('Enter a valid 5 digit zip');
			validResults = false;
		}
		
		return validResults;
	}
	
}
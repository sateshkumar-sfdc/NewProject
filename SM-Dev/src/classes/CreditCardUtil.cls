/*
* -----------------------------------------------------------
* Apex Class Name: CreditCardUtil
* -----------------------------------------------------------
* Description: This class contains methods to peform operations
* assoicated with the CreditCard and related objects.
* -----------------------------------------------------------
* Created by: Jeff Rogers, Alternative Technology Solutions.
* Created on: 20134-10-23
* Last Modified by: 
* Last Date Modified:
* Modification Log:
* 1 - 
*/

public class CreditCardUtil{
	
	private static final Credit_Card_Settings__c settings = Credit_Card_Settings__c.getOrgDefaults();
    
    //The updateOpps method updates pending opportunties with new credit card info
	//Trigger Context: After Insert, After Update
    public static void updateOpps(List<Credit_Card__c> creditCards, Map<Id,Credit_Card__c> oldCCMap) {

    	//only process if multiple active credit cards are not allowed
    	if (!settings.Allow_Multiple_Cards__c) {
	    	
    		Map<Id,Credit_Card__c> accountToActiveProfiles = new Map<Id,Credit_Card__c>();
    		Set<String> activeProfileIds = new Set<String>();
	    	Set<Id> accountIds = new Set<Id>();
	    	
	    	for (Credit_Card__c cc: creditCards) {
	    	//handle inserted credit cards
		    	if (oldCCMap == null) {
	    			if (cc.Active__c) {
	    				accountToActiveProfiles.put(cc.Account__c, cc);
	    				activeProfileIds.add(cc.Chase_Profile_Id__c);
	    				accountIds.add(cc.Account__c);
	    			}
		    	}
		    	//handle updated credit cards
		    	else {
	    			if ((cc.Active__c && !oldCCMap.get(cc.Id).Active__c) || (cc.Credit_Card_Name__c != oldCCMap.get(cc.Id).Credit_Card_Name__c) || (cc.Expiration_Year__c != oldCCMap.get(cc.Id).Expiration_Year__c) || (cc.Expiration_Month__c != oldCCMap.get(cc.Id).Expiration_Month__c)) {
	    				accountToActiveProfiles.put(cc.Account__c, cc);
	    				activeProfileIds.add(cc.Chase_Profile_Id__c);
	    				accountIds.add(cc.Account__c);
	    			}
		    	}
	    	}
	    	
	    	//update opps
	    	List<Opportunity> oppsToUpdate = [SELECT Id, AccountId, Chase_Profile_Id__c, Credit_Card__c, Credit_Card_Type__c, Credit_Card_Number__c, Credit_Card_Name__c, Credit_Card_Expiration_Year__c, Credit_Card_Expiration_Month__c FROM Opportunity WHERE AccountId IN : accountIds AND Chase_Profile_Id__c != '' AND Send_To_ERP__c = false AND Sales_Order__c = ''];
	    	for (Opportunity o : oppsToUpdate) {
	    		if (accountToActiveProfiles.containsKey(o.AccountId)) {
	    			o.Credit_Card__c = accountToActiveProfiles.get(o.AccountId).Id;
	    			o.Chase_Profile_Id__c = accountToActiveProfiles.get(o.AccountId).Chase_Profile_Id__c;
	    			o.Credit_Card_Type__c = accountToActiveProfiles.get(o.AccountId).Credit_Card_Type__c;
	    			o.Credit_Card_Number__c = accountToActiveProfiles.get(o.AccountId).Credit_Card_Number__c.right(4);
	    			o.Credit_Card_Name__c = accountToActiveProfiles.get(o.AccountId).Credit_Card_Type__c;
	    			o.Credit_Card_Expiration_Year__c = accountToActiveProfiles.get(o.AccountId).Expiration_Year__c;
	    			o.Credit_Card_Expiration_Month__c = accountToActiveProfiles.get(o.AccountId).Expiration_Month__c;
	    		}
	    	}
	    	
	    	if (!oppsToUpdate.isEmpty()) {
	    		update oppsToUpdate;
	    	}
    	}
    	
    }
    
    
    //The deactivateCCs method updates existing cards when a new active card is inserted (and multiple active cards are not allowed)
	//Trigger Context: After Insert
    public static void deactivateCCs() {

    	//only process if multiple active credit cards are not allowed
    	if (!settings.Allow_Multiple_Cards__c) {
    		/*
    		Map<Id,List<Credit_Card__c>> accountIdToCreditCards = new Map<Id,List<Credit_Card__c>>();
    		Set<Id> accountIds = new Set<Id>();
    		for (Credit_Card__c cc : creditCards) {
    			accountIds.add(cc.Account__c);
    		}*/
    		
    		//get accounts with multiple active cards
    		Set<Id> accountIds = new Set<Id>();
    		List<AggregateResult> ar = [SELECT Account__c, Count(Id) FROM Credit_Card__c WHERE Active__c = true GROUP BY Account__c HAVING Count(Id) > 1];
    		for (AggregateResult result : ar) {
    			accountIds.add(String.valueOf(result.get('Account__c')));
    		}
    		
    		//get credit cards to deactiveate (order by chase profile id DESC so we do not deactive the first/newest)
    		Id accountId;
    		List<Credit_Card__c> creditCards = [SELECT Id, Account__c, Chase_Profile_Id__c, Active__c FROM Credit_Card__c WHERE Account__c IN : accountIds AND Active__c = true ORDER BY Account__c, Chase_Profile_Id__c DESC];
    		List<Credit_Card__c> ccsToDeactivate = new List<Credit_Card__c>();
    		for (Credit_Card__c cc : creditCards) {
    			if (cc.Account__c == accountId) {
    				cc.Active__c = false;
    				ccsToDeactivate.add(cc);
    			}
    			accountId = cc.Account__c;
    		}
    		
    		if (!ccsToDeactivate.isEmpty()) {
    			update ccsToDeactivate;
    		}
    	}
    	
    }
    
    
    public static string maskCard(Credit_Card__c card) {
		
    	String ccNum;
    	
		if (card.Credit_Card_Type__c == 'AMEX') {
			ccNum = '***********' + card.Credit_Card_Number__c.right(4);
		}
		else {
			ccNum = '************' + card.Credit_Card_Number__c.right(4);
		}
		
		return ccNum;
		
	}
    
}
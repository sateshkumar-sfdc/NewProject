public class SoldToAccount {
    
    @AuraEnabled
    public static Account getSoldToAccount(Id recId){
        Account acc;
        acc = [SELECT Name, Email__c, Phone,CompanyCode__c, 
                           SalesOrg__c, DistributionChannel__c, Division__c,
                           SalesOffice__c,SalesGroup__c, SalesDistrict__c,
                           PaymentTerms__c,PriceList__c,PricingGroup__c,
                           PriceProcedure__c, ShippingCondition__c,
                           CustomerShipAccount__c,BillingStreet,
                           BillingCity,BillingState,BillingPostalCode,
                           BillingCountry, CustomerNumber__c,CurrencyIsoCode,
               			   ShippingCity,ShippingCountry,ShippingPostalCode,
               			    ShippingState,ShippingStreet,OriginSource__c 
               				FROM Account 
                           WHERE id=: recId LIMIT 1];
        System.debug('Account test Business'+acc);
        return acc;
        
    }
    
    @AuraEnabled
    public static Id saveShipTo(Account ac, Id recId){
       system.debug('accout--'+ac+'--RecId--'+recId);
        String accountRecordTypeName = CommonUtil.getRecordTypeName('Account', 'Ship To', '');     
        Id accRectypeId = RecordTypeSelectionController.getRecTypeIdAccount('Account',accountRecordTypeName,'');
        Account acc = new Account();
        acc = ac;
        acc.ParentId = recId;
        acc.RecordTypeId = accRectypeId;
        String Name = acc.Name;
        String accType = 'ShipTo';
       	String shipToCustomerNumber = AccountService.actuallCallOut(acc,Name,accType);
        if(shipToCustomerNumber !=null && shipToCustomerNumber!='')
        {
            acc.ShipToCustomerNumebr__c = shipToCustomerNumber;
            
            insert acc;
            
        	return acc.Id;
        }
        else 
        {
            return null;
        }
                      
    }

}
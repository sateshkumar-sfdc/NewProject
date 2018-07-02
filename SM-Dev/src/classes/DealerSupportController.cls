public with sharing class DealerSupportController {

    
    

     
    @AuraEnabled
    public static wDealerCase getNewCase(){
        
        user cuser = [select Id,Name,ContactId from user where Id =: userinfo.getUserId()];
        Contact ccontact = [select Id,Name,AccountId,Account.Name from Contact where Id =: cuser.ContactId];
        
        /*case c = new case();
        c.OwnerId = cuser.Id;
        c.Status = 'New';
        c.AccountId = cuser.AccountId;
        c.contactId = cuser.CpntactId;*/        
        
        wDealerCase obj = new wDealerCase();
        obj.CaseOwnerId = cuser.Id;
        obj.CaseOwnerName = cuser.Name; 
        obj.AccountId= ccontact.AccountId;
        obj.AccountName= ccontact.Account.Name;        
        obj.Status= 'New';
        obj.ContactId= cuser.ContactId; 
        obj.ContactName= ccontact.Name;        
        obj.Priority='Medium';       
        obj.TradingPostVisible = false;
        obj.CaseCurrency='USD';
        obj.Subject='';
        obj.Description=''; 
        obj.CaseOrigin='Trading Post';
        return obj;
    }
    
    @AuraEnabled
    public static string saveNewCase(string cobj){
        
        try{
            wDealerCase obj = (wDealerCase)JSON.deserialize(cobj,wDealerCase.class);
            case c = new case();
            c.OwnerId = obj.CaseOwnerId;
            c.AccountId = obj.AccountId;
            c.contactId = obj.ContactId;
            c.Status = obj.Status;
            c.contactId = obj.ContactId;
            c.Priority = obj.Priority;
            c.Trading_Post_Visible__c = obj.TradingPostVisible;
            c.CurrencyIsoCode = obj.CaseCurrency;
            c.Subject = obj.Subject;
            c.Description = obj.Description;
            c.Origin = obj.CaseOrigin;
            insert c;
            
            return 'Successfully Case Created!';
        }catch(Exception e){
            system.debug('->'+e.getMessage()+'---'+e.getLineNumber());
        }
        return '';
        
    }
    
}
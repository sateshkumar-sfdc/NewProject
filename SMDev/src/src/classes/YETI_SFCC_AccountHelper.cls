public class YETI_SFCC_AccountHelper {
    
    //VARIABLES INITIALIZATION
    Map<Id, Account> newAccountsMap = (Map<Id, Account>)Trigger.newMap;
    Map<Id, Account> oldAccountsMap = (Map<Id, Account>)Trigger.oldMap;
    List<Account> newAccountsList = (List<Account>)Trigger.new;
    
    public void createSfccAccountMain(){
        system.debug('YETI_SFCC_AccountHelper YETI_SFCC_AccountHelper YETI_SFCC_AccountHelper YETI_SFCC_AccountHelper');
        Account acc = newAccountsList[0];
        String name = String.isNotBlank(acc.Name) ? (acc.Name) : (String.isNotBlank(acc.FirstName) ? (acc.FirstName+acc.LastName) : acc.LastName);
        createSfccAccount(name, acc.Email__c, name, acc.Id);
    }
    
    @future(callout=true)
    public Static void createSfccAccount(String login, String email, String name, String accid){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('customer');
        gen.writeStartObject();
        gen.writeStringField('login', login);
        gen.writeStringField('email', email);
        gen.writeStringField('last_name', name);
        gen.writeEndObject();
        String payload = gen.getAsString();
        
        String accessToken = String.valueOf(YETI_SFCC_Token.getToken().get('access_token'));
        
        if(String.isNotBlank(accessToken)){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://dev09-na-yeti.demandware.net/s/Yeti_US/dw/shop/v18_6/customers');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            request.setHeader('Content-Type','application/json;charset=UTF-8');
            //request.setHeader('payload', payload);
            request.setBody(payload);
            request.setMethod('POST');
            HttpResponse response = http.send(request);
            system.debug('response.getStatusCode() => '+response.getStatusCode());
            system.debug('createSfccAccount body => '+response.getBody());
            if (response.getStatusCode() == 200) {
                system.debug('createSfccAccount Success body => '+response.getBody());
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                // Cast the values in the 'animals' key as a list
                String customer_id = String.valueOf(results.get('customer_id'));
                String customer_no = String.valueOf(results.get('customer_no'));
                if(String.isNotBlank(accid)){
                    Account acc = [SELECT Id, SFCC_Customer_Id__c, SFCC_Customer_No__c FROM Account WHERE Id=:accid LIMIT 1];
                    acc.SFCC_Customer_Id__c = customer_id;
                    acc.SFCC_Customer_No__c = customer_no;
                    update acc;
                }
            }
            else{
                system.debug('createSfccAccount Error body => '+response.getBody());
                //return 'Error => '+response.getBody();
            }
        }
    }

}
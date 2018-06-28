public class YETI_SFCC_AccountService {
    
    @AuraEnabled
    public Static String resetAccountPassword(String eml){
        
        //Account acc = [SELECT Id, Name, Email__c FROM Account WHERE Id=:accId];
        String accessToken = String.valueOf(YETI_SFCC_Token.getToken().get('access_token'));
        
        if(String.isNotBlank(String.valueOf(eml)) && String.isNotBlank(accessToken)){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Account_Reset_Password/'+String.valueOf(eml)+'/password_reset');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            request.setHeader('Content-Type','application/json;charset=UTF-8');
            request.setMethod('POST');
            HttpResponse response = http.send(request);
            system.debug('response.getStatusCode() => '+response.getStatusCode());
            system.debug('resetAccountPassword body => '+response.getBody());
            if (response.getStatusCode() == 200) {
                system.debug('resetAccountPassword Success body => '+response.getBody());
                return response.getBody();
            }
            else{
                system.debug('resetAccountPassword Error body => '+response.getBody());
                return 'Error => '+response.getBody();
            }
        }
        return null;
    }

}
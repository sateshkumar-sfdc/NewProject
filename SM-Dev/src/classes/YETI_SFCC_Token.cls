public class YETI_SFCC_Token {
    
    @AuraEnabled
    public Static Map<String, Object> getToken(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Get_SFCC_Token');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Basic dmVua2F0YS5rb2xsdXJpQHlldGkuY29tOldlbGNvbWVAMjM0OmFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYQ==');
        request.setMethod('POST');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            system.debug('Success body => '+response.getBody());
            return (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        }
        else{
            system.debug('Error body => '+response.getBody());
            return new Map<String,Object>{'Error'=>response.getBody()};
        }
    }

}
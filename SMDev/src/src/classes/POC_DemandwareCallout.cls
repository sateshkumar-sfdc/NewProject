public class POC_DemandwareCallout {
    
    @AuraEnabled
    public Static String getTestData(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://dev03-na-yeti.demandware.net/s/Yeti_US/dw/shop/v18_6/product_search?client_id=21d8f00b-53d0-44fa-993d-7a2bb464e171&q=YRAM30&&expand=prices,availability,images');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            system.debug('c c c c c c c c c c c => '+response.getBody());
            return response.getBody();
        }
        else{
            return 'Error';
        }
    }
    
}
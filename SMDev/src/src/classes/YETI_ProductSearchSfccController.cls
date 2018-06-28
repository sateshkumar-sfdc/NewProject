public class YETI_ProductSearchSfccController {
    
    @AuraEnabled
    public Static String getSearchedProducts(String searchText){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endPoint = 'http://dev03-na-yeti.demandware.net/s/Yeti_US/dw/shop/v18_6/product_search?client_id=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa&q='+searchText+'&expand=prices,availability,images';
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            system.debug('Searched Products Response => '+response.getBody());
            return response.getBody();
        }
        else{
            return 'Error';
        }
    }

}
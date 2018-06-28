public with sharing class LT_DeliveryLineController {
    
    @AuraEnabled
    public static Delivery_Lines__c getDelivery(Id lineid) {
        system.debug('lineid:'+lineid);
        Delivery_Lines__c dl = [select Id,Deliveries__c,Deliveries__r.Name from Delivery_Lines__c where id =: lineid];  
        system.debug('dl:'+dl);      
        return dl;
    }
}
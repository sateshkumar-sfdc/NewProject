public with sharing class LT_OrderLineController {

    
    @AuraEnabled
    public static Order_Line__c getOrderDetail(Id orderId) {
        
        system.debug('--->'+orderId);
        order_line__c ol;
        
            ol = [select Id,Order_Details__c,Order_Details__r.Name from order_line__c where id =: orderId];
       
        return ol;
    }
}
public class OrderLineItemsController_YETI {
    
    @AuraEnabled
    public static List<OrderItem> getLineItems(Id recId){
       
        system.debug('productid-->' + recId);
        Id recordId = '8010t000001APRjAAO'; 
        return [select Product2.Name, AvailableQuantity,UnitPrice from OrderItem where OrderId =: recId ];
    }

}
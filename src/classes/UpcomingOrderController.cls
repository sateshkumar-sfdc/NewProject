public with sharing class UpcomingOrderController{
    @AuraEnabled
    public static List<Order__c>  getUpcomingOrders(){
        return [select Id,Name,PurchaseOrder__c,Need_By_Date__c,Order_Status__c from Order__c where (Order_Status__c <> 'Completed' or Order_Status__c <> 'Canceled') and Need_By_Date__c  <> null order by Need_By_Date__c  desc limit 5 ];
    }    
}
@isTest
public class LT_Controllers_Test{
    @isTest static void InvoiceTest() {
        Account Acc  = new Account(Name = 'test');
        insert Acc;

        Invoice__c invo = new Invoice__c(Name ='inv1',Ship_To__c = Acc.id);
        insert invo;
        
        Invoice_Lines__c invLines = new Invoice_Lines__c(Name ='invline1',Invoice__c = invo.Id);
        insert invLines;
        
        Invoice_Lines__c result = LT_InvoiceLineController.getInvoice(invLines.id);
    }
    @isTest static void OrderLineTest() {
        Account Acc  = new Account(Name = 'test Acc');
        insert Acc;

        Order__c ordr = new Order__c(Name ='order test1',Ship_To__c = Acc.id);
        insert ordr;
        
        Order_Line__c ordLines = new Order_Line__c(Name ='orderline1',Order_Details__c = ordr.id);
        insert ordLines;
        
        Order_Line__c result = LT_OrderLineController.getOrderDetail(ordLines.id);
    }
    @isTest static void DeliveryLineTest() {
        Account Acc  = new Account(Name = 'test');
        insert Acc;

        Deliveries__c deli = new Deliveries__c(Name ='del 1',Ship_To__c = Acc.id);
        insert deli;
        
        Delivery_Lines__c delLines = new Delivery_Lines__c(Name ='delline1',Deliveries__c = deli.id);
        insert delLines;
        
        Delivery_Lines__c result = LT_DeliveryLineController.getDelivery(delLines.id);
    }
    
}
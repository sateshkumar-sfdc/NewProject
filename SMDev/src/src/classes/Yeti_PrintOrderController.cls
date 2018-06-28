/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  11 March 2017
Name          :  Yeti_PrintOrderController
Description   :  Controller for Yeti_PrintOrder.page 
Original Task :  T-584752
*/
public with sharing class Yeti_PrintOrderController {
  public list<Order_Line__c> lstOrderLines{get;set;}
  public list<Order__c> lstOrders{get;set;}
  private Id orderId;
  public boolean showDiscount{get;set;}
  //controls how many quote line items are displayed on page 1
  private static Integer FIRST_BREAK = 12;
  //controls how many quote line items are displayed on subsequent pages
  private static Integer SUBSEQ_BREAKS = 32;
  public List<List<order_line__c>> pageBrokenOrderLines {get;private set;}
  
  //Constructor 
  public Yeti_PrintOrderController(){
    lstOrderLines = new list<Order_Line__c>();
    lstOrders = new list<Order__c>();
    orderId = apexpages.currentpage().getparameters().get('id');
    showDiscount = false;
    pageBrokenOrderLines = new List<List<order_line__c>>();
    
    if (orderId != null){
       lstOrders =      [SELECT Bill_To__c,Case__c,CreatedById,CreatedDate,Discount_Amount__c,Downgrade__c,EP_Order_Type__c,FOB__c,
                        Id,Line_Total__c,Misc__c,Name,Need_By_Date__c,Old_Process__c,Open_Line_Total__c,Ship_To__r.ShippingStreet,Ship_To__r.ShippingCity,Ship_To__r.ShippingState,
                        Ship_To__r.ShippingCountry,Ship_To__r.ShippingPostalCode,Bill_To__r.BillingStreet,Bill_To__r.BillingCity,Bill_To__r.BillingState,Bill_To__r.BillingCountry,
                        Bill_To__r.BillingPostalCode,Open_Line_Unit_Total__c,Order_Comment__c,Order_Date__c,Order_Held__c,Order_Source__c,Order_Status__c,Order_Subtotal__c,
                        Order_Total__c,Order_Type__c,PurchaseOrder__c,RMA_Number__c,SAP_Customer_Number__c,Ship_By__c,Ship_Complete__c,Ship_To__c,Ship_Via__c,Sold_To__c,Sub_Total__c,
                        Tax__c,Terms__c,Upgrade_Charge__c,Grand_Total__c,Shipping_Amount__c,
                        Sold_To__r.Inside_SR_Name__c,Sold_To__r.Inside_Rep_Phone__c,Sold_To__r.Inside_Rep_Email__c,Sold_To__r.Outside_SR_Name__c,Sold_To__r.Outside_Rep_Phone__c,Sold_To__r.Outside_Rep_Email__c,
                        (SELECT DiscountPrice__c,Ext_Price__c,Last_Change_Date__c,Last_Change_Time__c,Line_Comment__c,Line_Number__c,Line_Status__c,Name,Need_By_Date__c,
                        Need_By__c,Order_Details__c,Order_Line__c,Order_Number__c,Order_Quantity__c,Part_Number__c,Product_Description__c,
                        Product_Group__c,Product__c,Request_Date__c,Sales_Category__c,Ship_By__c,Total_Shipped__c,Unit_Price__c,UPC__c FROM Order_Details__r)
                        FROM Order__c
                        WHERE Id =: orderId];
                        
        if(!lstOrders.isEmpty() && !lstOrders[0].Order_Details__r.isEmpty()){

            List<order_line__c> lstOrderLines = new List<order_line__c>();
            Integer counter = 0;
            boolean firstBreakFound = false;
            boolean setSubSeqBreak = false;       
            Integer breakPoint = FIRST_BREAK;
            
            for(order_line__c invLineItem : lstOrders[0].Order_Details__r){
              if(invLineItem.DiscountPrice__c > 0.00 || invLineItem.DiscountPrice__c < 0.00){
                showDiscount = true;
              }
              if(counter <= breakPoint){
                lstOrderLines.add(invLineItem);
                counter++;
              }
              if(counter == breakPoint){
                if (!firstBreakFound){
                  firstBreakFound = true;
                  setSubSeqBreak = true;
                }
                counter = 0;
                pageBrokenOrderLines.add(lstOrderLines);
                lstOrderLines = new List<order_line__c>();
              }
              if(setSubSeqBreak){
                breakPoint = SUBSEQ_BREAKS;
                setSubSeqBreak = false;
              }
            }
            if(!lstOrderLines.isEmpty())
              pageBrokenOrderLines.add(lstOrderLines);
            }
        }
      }
}
/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  14 March 2017
Name          :  Yeti_PrintShipmentController
Description   :  Controller for Yeti_PrintShipment.page 
Original Task :  T-585055
*/
public with sharing class Yeti_PrintShipmentController {
  public list<Delivery_Lines__c> lstDeliveryLines{get;set;}
  public list<Deliveries__c> lstDeliveries{get;set;}
  public List<String> lstTrackNumList{get;set;}
  private Id shipmentId;
  
  //controls how many quote line items are displayed on page 1
  private static Integer FIRST_BREAK = 9;
  //controls how many quote line items are displayed on subsequent pages
  private static Integer SUBSEQ_BREAKS = 32;
  public List<List<Delivery_Lines__c>> pageBrokenDeliveryLines {get;private set;}
  
  //Constructor 
  public Yeti_PrintShipmentController(){
    lstDeliveryLines = new list<Delivery_Lines__c>();
    lstDeliveries = new list<Deliveries__c>();
    shipmentId = apexpages.currentpage().getparameters().get('id');
    pageBrokenDeliveryLines = new List<List<Delivery_Lines__c>>();
    lstTrackNumList = new List<String>();
    
    if (shipmentId != null){
       lstDeliveries = [SELECT Account__c,Bill_To__c,CreatedById,CreatedDate,ERP_Order__c,Id,IsDeleted,Name,Need_By_Date__c,OwnerId,SAP_Customer_Number__c,Sent_To_3PL__c,
                        Ship_Date__c,Ship_To_Party__c,Ship_To__c,Site__c,Sold_To__c,SystemModstamp,Tracking_Number__c,Unique_ID__c,Warehouse__c,Ship_To__r.ShippingStreet,
                        Ship_To__r.ShippingState,Ship_To__r.ShippingCountry,Ship_To__r.ShippingCity,Ship_To__r.ShippingPostalCode,Order__r.Order_Status__c,Order__r.Order_date__c,
                        Order_Date__c,Sold_To__r.Inside_SR_Name__c,Sold_To__r.Inside_Rep_Phone__c,Sold_To__r.Inside_Rep_Email__c,Sold_To__r.Outside_SR_Name__c,Sold_To__r.Outside_Rep_Phone__c,
                        Sold_To__r.Outside_Rep_Email__c,Status_c__c,Order__r.PurchaseOrder__c,Shipping_Method__c,order__r.Name,
                        (SELECT Deliveries__c,ERP_Order__c,Id, Last_Change_Time__c,Name,Need_By_Date__c,Pack_Line_Num__c,Part_Description__c,Part_Number__c,Quantity__c,
                        Ship_By_Date__c,Ship_Via__c,SystemModstamp,UOM__c,Warehouse__c,QTY_Ordered__c,QTY_Shipped__c,UPC__c FROM Delivery_Lines10__r)
                        FROM Deliveries__c
                        WHERE Id =: shipmentId];
                        
      if(String.isNotBlank(lstDeliveries[0].Tracking_Number__c)) {       List<String> lstString = new List<String>();      lstString = lstDeliveries[0].Tracking_Number__c.split(',');        Integer counter = 0;    for (String st : lstString){      String s = st;         if(math.mod(counter,2) != 0){          s = s + ',' + st;            lstTrackNumList.add(s);}      counter++;}
      }
    }

    if(!lstDeliveries.isEmpty() && !lstDeliveries[0].Delivery_Lines10__r.isEmpty()){
      List<Delivery_Lines__c> lstDeliveriesLines = new List<Delivery_Lines__c>();
        Integer counter = 0;
        boolean firstBreakFound = false;
        boolean setSubSeqBreak = false;       
        Integer breakPoint = FIRST_BREAK;
        
        for(Delivery_Lines__c invLineItem : lstDeliveries[0].Delivery_Lines10__r){
          if(counter <= breakPoint){
            lstDeliveriesLines.add(invLineItem);
            counter++;
          }
          if(counter == breakPoint){         if (!firstBreakFound){       firstBreakFound = true;        setSubSeqBreak = true;        }        counter = 0;        pageBrokenDeliveryLines.add(lstDeliveriesLines);       lstDeliveriesLines = new List<Delivery_Lines__c>();
          }
          if(setSubSeqBreak){        breakPoint = SUBSEQ_BREAKS;        setSubSeqBreak = false;
          }
        }
        if(!lstDeliveriesLines.isEmpty())
          pageBrokenDeliveryLines.add(lstDeliveriesLines);
    
      }
    }
}
/*
Author        :  Rakshit Virmani (Appirio)
Created Date  :  14 March 2017
Name          :  Yeti_PrintInvoiceController
Description   :  Controller for Yeti_printinvoice.page 
Original Task :  T-585056
*/

public with sharing class Yeti_PrintInvoiceController {
  public list<Order_Line__c> lstOrderLineItems{get;set;}
  public list<Invoice__c> lstInvoice{get;set;}
  private Id invoiceId;
  public boolean showDiscount{get;set;}
  public List<String> lstTrackingNumbers{get;set;}
  
  //controls how many quote line items are displayed on page 1
  private static Integer FIRST_BREAK = 7;
  //controls how many quote line items are displayed on subsequent pages
  private static Integer SUBSEQ_BREAKS = 32;
  public List<List<Invoice_Lines__c>> pageBrokenInvoiceLines {get;private set;}

  
  
  //Constructor 
  public Yeti_PrintInvoiceController(){
    lstOrderLineItems = new list<Order_Line__c>();
    lstInvoice = new list<Invoice__c>();
    invoiceId = apexpages.currentpage().getparameters().get('id');
    showDiscount = false;
    pageBrokenInvoiceLines = new List<List<Invoice_Lines__c>>();
    lstTrackingNumbers = new List<String>();
    
    if (invoiceId != null){
      lstInvoice = [SELECT Bill_To__c,Bill_To__r.BillingAddress,Bill_To__r.BillingStreet,Bill_To__r.BillingCity,Bill_To__r.BillingState,Bill_To__r.BillingCountry,
                    Bill_To__r.BillingPostalCode,Ship_To__r.ShippingStreet,Ship_To__r.ShippingCity,Ship_To__r.ShippingState,Ship_To__r.ShippingCountry,Ship_To__r.ShippingPostalCode,
                    Deliveries__r.Tracking_Number__c,Deliveries__r.Name,Deliveries__r.Ship_Date__c,CreatedById,CreatedDate,Deliveries__c,Deposit_Balance__c,Due_Date__c,FOB__c,Id,
                    Invoice_Amount__c,Invoice_Balance__c,Invoice_Date__c,Name,Packing_Slip_ID__c,PO__c,Sales_Order__c,SAP_Customer_Number__c,Deliveries__r.Shipping_Method__c,Order__r.FOB__c,
                    Shipping_Date__c,Ship_To__c,Sold_To__c,Status__c,Terms__c,Order__r.Ship_via__c,Sub_Total__c,Shipping_Amount__c,Tax__c,Total_Before_Discount__c,Discount__c,
                    Sold_To__r.Inside_SR_Name__c,Sold_To__r.Inside_Rep_Phone__c,Sold_To__r.Inside_Rep_Email__c,Sold_To__r.Outside_SR_Name__c,Sold_To__r.Outside_Rep_Phone__c,Sold_To__r.Outside_Rep_Email__c,
                    Sold_To__r.IsPersonAccount,Ship_To__r.IsPersonAccount,Bill_To__r.IsPersonAccount,
                    (SELECT Name,Description__c,Ext_Price__c,Id,Invoice__c,Last_Change_Time__c,Order_Quantity__c,Packing_Line__c,
                    Packing_Slip__c,Part_Number__c,PO__c,Sales_Order__c,Unit_Price__c,Discount__c,UPC__c,Subtotal__c FROM Invoice_Lines__r)
                    FROM Invoice__c 
                    WHERE Id = : invoiceId]; 

        if(String.isNotBlank(lstInvoice[0].Deliveries__r.Tracking_Number__c)) {
          List<String> lstString = new List<String>();
          lstString = lstInvoice[0].Deliveries__r.Tracking_Number__c.split(',');
          Integer counter = 0;
          for (String st : lstString){
            String s = st; 
            if(math.mod(counter,2) != 0){
              s = s + ',' + st;
              lstTrackingNumbers.add(s);
            }
            counter++;
          }
        }

        if(!lstInvoice.isEmpty() && !lstInvoice[0].Invoice_Lines__r.isEmpty()){
          List<Invoice_Lines__c> lstInvoiceLines = new List<Invoice_Lines__c>();
          Integer counter = 0;
          boolean firstBreakFound = false;
          boolean setSubSeqBreak = false;       
          Integer breakPoint = FIRST_BREAK;
          
          for(Invoice_Lines__c invLineItem : lstInvoice[0].Invoice_Lines__r){
            if(invLineItem.Discount__c > 0.00 || invLineItem.Discount__c < 0.00){
              showDiscount = true;
            }
            if(counter <= breakPoint){
              lstInvoiceLines.add(invLineItem);
              counter++;
            }
            if(counter == breakPoint){
              if (!firstBreakFound){
                firstBreakFound = true;
                setSubSeqBreak = true;
              }
              counter = 0;
              pageBrokenInvoiceLines.add(lstInvoiceLines);
              lstInvoiceLines = new List<Invoice_Lines__c>();
            }
            if(setSubSeqBreak){
              breakPoint = SUBSEQ_BREAKS;
              setSubSeqBreak = false;
            }
          }
          if(!lstInvoiceLines.isEmpty())
            pageBrokenInvoiceLines.add(lstInvoiceLines);
        }
    }
  }
}
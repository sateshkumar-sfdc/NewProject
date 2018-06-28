public with sharing class Yeti_printDetailController {
    private Id recordID;
    private String sObjName;
    public Yeti_printDetailController(){
        recordID = ApexPages.currentPage().getParameters().get('Id');
        sObjName = recordID.getSObjectType().getDescribe().getName();
    }
    
    public pageReference redirectToPDFPage(){
        if(sObjName.contains('Order__c')){
          pageReference pg = new pageReference('/apex/yeti_printorder?id='+recordID);
          return pg;  
        }
        if(sObjName.contains('Invoice__c')){
           pageReference pg = new pageReference('/apex/yeti_printinvoice?id='+recordID);
           return pg;  
        }
        if(sObjName.contains('Deliveries__c')){
           pageReference pg = new pageReference('/apex/yeti_printshipment?id='+recordID);
            return pg;  
        }
        else {
            return null;
        }
    }
}
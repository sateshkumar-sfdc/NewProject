public with sharing class LT_InvoiceLineController {
    
    @AuraEnabled
    public static Invoice_Lines__c getInvoice(Id lineid) {
        Invoice_Lines__c il = [select Id,Invoice__c,Invoice__r.Name from Invoice_Lines__c where id =: lineid];       
        return il;
    }
}
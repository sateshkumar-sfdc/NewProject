public with sharing class YETI_InvoiceTaskController {

    @AuraEnabled
    public static boolean getIsPostInvoices() {
        
        List<Invoice__c> lstInvoice = [select Id from Invoice__c where Due_Date__c <: System.Today() and Invoice_Balance__c <> null and OwnerId =: userinfo.getuserid() limit 1];
        if(lstInvoice.size() > 0){
            return true;
        }
        return false;
    }
        
     @AuraEnabled
    public static List<MyInvoiceTask> getAllInvoiceTask() {
        List<MyInvoiceTask> lstMIT = new List<MyInvoiceTask>();
        
        //for(Task t : [select Id,Subject,Status,Description,ActivityDate,whatId,OwnerId from Task where createdBy.Id =: userinfo.getUserId()]){
        for(Task t : [select Id,Subject,Status,Description,ActivityDate,whatId,OwnerId from Task where OwnerId =: userinfo.getUserId()]){
            if(t.whatId <> null && t.whatId.getSObjectType() == Invoice__c.getSObjectType())
            {
                String invoiceid = t.whatId;
                String invoiceheading= t.Subject;
                date taskduedate= t.ActivityDate;
                String taskstatus= t.Status;
                String taskcomment= t.Description;
                MyInvoiceTask m = new MyInvoiceTask(invoiceid,invoiceheading,taskduedate,taskstatus,taskcomment);
                lstMIT.add(m);
            }
        }
        return lstMIT;
    }
  
  public class MyInvoiceTask {
    @AuraEnabled public String invoiceid;
    @AuraEnabled public String invoiceheading;
    @AuraEnabled public Date taskduedate;
    @AuraEnabled public String taskstatus;
    @AuraEnabled public String taskcomment;

    public MyInvoiceTask(String iid, String ih, Date tdd, String ts, String tc) {
        invoiceid = iid;
        invoiceheading = ih;
        taskduedate = tdd;
        taskstatus = ts;
        taskcomment = tc;
    }
  }
}
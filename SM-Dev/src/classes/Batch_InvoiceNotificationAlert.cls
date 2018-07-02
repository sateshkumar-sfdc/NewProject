global class Batch_InvoiceNotificationAlert implements Database.Batchable<sObject>, Database.Stateful{  

    global set<Id> setInvoices;
    global Batch_InvoiceNotificationAlert(){
        setInvoices = new set<Id>();
    }
    global Database.QueryLocator start(Database.BatchableContext info){
        
        Date Last1Day = system.today()-1;
        string Query = 'select Id,Name,Sold_To__c,OwnerId,Due_Date__c,Status__c from Invoice__c where Due_Date__c =: Last1Day and Status__c = \'Not Completed\'' ; 
        return Database.getQueryLocator(Query);
    }     
    
    global void execute(Database.BatchableContext info, List<Invoice__c> scope)
    {    
        set<Id> setAccountIds = new set<Id>();
        for(Invoice__c inv : scope){
            if(inv.Sold_To__c <> null){
                setAccountIds.add(inv.Sold_To__c);
            }
        }
        map<Id,Id> mapUser = new map<Id,Id>();
        for(User u : [select Id,AccountID from User where AccountID IN: setAccountIds]){
            mapUser.put(u.AccountID,u.Id);
        }
        
        List<Task> lstTask = new List<Task>();
        for(Invoice__c inv : scope){
            Task t = new Task();
            t.Subject = inv.name+' is not completed after due date';
            t.description ='You have past due invoices, click here Past Due Invoice on the Invoice table';
            t.ActivityDate = inv.Due_Date__c;//system.today()+7;
            t.WhatId = inv.Id;
            Id TaskOwner = inv.OwnerId;
            if(mapUser.containsKey(inv.Sold_To__c)){
                TaskOwner = mapUser.get(inv.Sold_To__c);
            }
            t.OwnerId = TaskOwner;
            lstTask.add(t); 
            setInvoices.add(inv.Id);            
        }
        
        if(lstTask.size()>0){
            database.insert(lstTask,false);
        }
    }       
    
    global void finish(Database.BatchableContext info)
    {         
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'aneesh.kommidi@yeti.com' };
        
        message.subject = 'Invoice NotificationAlert: '+system.today();
        message.HTMLBody = getEmailBody();
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    } 
    public string getEmailBody(){
        string str = 'Hi,';
        str += '<br/><p>Invoice list which is not Completed yet after duedate of invoice: <br/>';
        str += '<table style="font-family: arial, sans-serif;   border-collapse: collapse;  width: 100%;">';
        str += '<tr>';
        str += '<th style="border: 1px solid #dddddd;  text-align: left; padding: 8px;">Invoice</th>';
        str += '<th style="border: 1px solid #dddddd;  text-align: left; padding: 8px;">DueDate</th>';
        str += '<th style="border: 1px solid #dddddd;  text-align: left; padding: 8px;">Status</th>';
        str += '<th style="border: 1px solid #dddddd;  text-align: left; padding: 8px;">Owner</th>';
        str += '</tr>';
        for(Invoice__c inv : [select Id,Name,Owner.Name,Due_Date__c,Status__c from Invoice__c where id IN: setInvoices]){
            str += '<tr>';
            str += '<td style="border: 1px solid #dddddd;  text-align: left; padding: 8px;">'+inv.Name+'</td>';
            str += '<td style="border: 1px solid #dddddd;  text-align: left; padding: 8px;">'+inv.Due_Date__c+'</td>';
            str += '<td style="border: 1px solid #dddddd;  text-align: left; padding: 8px;">'+inv.Status__c+'</td>';
            str += '<td style="border: 1px solid #dddddd;  text-align: left; padding: 8px;">'+inv.Owner.Name+'</td>';
            str += '</tr>';
        }       
        str += '</table>';
        str += '</p><br/>';
        str += '<p>Thanks</p>';
        
        return str;
    }
}
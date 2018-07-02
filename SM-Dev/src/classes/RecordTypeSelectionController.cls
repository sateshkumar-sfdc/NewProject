public with sharing class RecordTypeSelectionController {
    public static Map<Id, String> recordtypemap {get;set;}
         
   @AuraEnabled        
    public static List<RecordType> fetchRecordTypeValues(string object_name){
        Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(object_name);
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        List<Schema.RecordTypeInfo> recordtypes = sobject_describe.getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        List<RecordType> rtNames = new List<RecordType>();
        for(RecordTypeInfo rt : recordtypes){
            system.debug('Test--'+rt.getName()+rt.isAvailable());
            if(rt.isAvailable() == true & rt.getName() != 'Master')
            {
             system.debug('Test--'+rt.getName()+rt.getRecordTypeId());
            rtNames.add(new RecordType(Id = rt.getRecordTypeId(),Name = rt.getName()));   
            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
                }
        }        
        //return recordtypemap.values();
        return rtNames;
    }
    
    @AuraEnabled
    public static Id getRecTypeIdAccount(String obj,String recordTypeLabel,String type){
        List<RecordType> recId = new List<RecordType>();
        try{
        if(type != null && type != '' && type == 'Consumer Account')
        {
             recId = [SELECT Id FROM RecordType WHERE SobjectType =: obj AND DeveloperName =: recordTypeLabel AND IsPersonType =: true LIMIT 1];
        }
        else
        {
            recId = [SELECT Id FROM RecordType WHERE SobjectType=: obj AND DeveloperName=: recordTypeLabel LIMIT 1];
        }
		
        return recId[0].Id; }
         catch (Exception ex) {
            return null;
        }
    }  
    
    @AuraEnabled
    public static Id getRecTypeId(String obj,String recordTypeLabel){
        list<RecordType> recId = new List<RecordType>();
        try{
        recId = [SELECT Id FROM RecordType WHERE SobjectType=: obj AND DeveloperName=: recordTypeLabel LIMIT 1];
         return recId[0].Id;
        } catch (Exception ex) {
            return Null;
        }
    }    


}
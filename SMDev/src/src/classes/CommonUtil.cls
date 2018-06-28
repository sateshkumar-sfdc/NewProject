/*
*************************************************************
** Name: CommonUtil	 		    	   					   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose: 											   **
** This is a common utility controller,referred in various **
** applications to perform some common functions like      **
** referring custom metadata and other common functions    **
*************************************************************
** History:                                                **
*************************************************************
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Sumanth Anumukonda 04/16/2018 INITIAL DEVELOPMENT **
** 2.0 -                                                   **
*************************************************************
*/

public with sharing class CommonUtil {
    @AuraEnabled
    public static string getCommonMetaData(string metadataName){	
        try{
        Common_Setting__mdt commonSettingMdt = [SELECT Label,Value__c,DeveloperName FROM Common_Setting__mdt WHERE DeveloperName =:metadataName limit 1];
        if(commonSettingMdt!=null){
        String value = commonSettingMdt.value__c;
        return value;
            }
        else 
            return null;
        }
     	catch(exception e){
         return null;
        }
    	}
    
    @AuraEnabled
    public static string getRecordTypeName(String obj, string objType, String country){
        try{
        SObjectRecordTypeMap__mdt sObjType = [SELECT RecordType_DeveloperName__c FROM SObjectRecordTypeMap__mdt WHERE Object__c =:obj AND Type__c =:objType AND Country__c =:country limit 1];
        if(sObjType!=null){
        String value = sObjType.RecordType_DeveloperName__c;
            system.debug('rec dev name--->'+value);
        return value;
            }
        else 
            return null;
        }
     	catch(exception e){
         return null;
        }
}
    // This method gets the current Logged in user data and passes to the components where its referred from. //
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        try{
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                      FROM User Where id =: userInfo.getUserId()];
        return oUser;
        }
        catch(exception e){
         return null;
        }
        
    }
    
    //This methods returns the pick list vaues using the schema class to the component where it is called from. 
    //params : Object name and the pick list field which we want to retrieve. 
    @AuraEnabled
    public static List<string> getPickValues(string object_name, String field_name) {
        try{
        List<String> options = new List<String>(); //new list for holding all of the picklist options
        system.debug('op-->'+object_name+field_name);
        Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(object_name); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(a.getLabel()); 
        }
        system.debug('options---'+options);
        return options; //return the List
            }
        catch(exception e){
         return null;
        }
        
    }    
}
public with sharing class SeedDataProcessorApex {
	
    // This list has the data from SeeddataKeyValues__c Object, 3rd object data from seedData JSON structure. (Actuall Raw Data)
    public static List<SeeddataKeyValues__c> seedDataKeyValuesList = new List<SeeddataKeyValues__c>();  
    // This map has the the Key value pairs from the SeeddataKeyValues__c Object with fieldname__c as key and list<SeeddataKeyValues__c> related to that Fieldname as values. 3rd object data from seedData JSON structure.
    Public static map<string, list<SeeddataKeyValues__c>> seedDataKeyValuesMap = new map<string,list<SeeddataKeyValues__c>>();
    // This map has the the Key value pairs from the SeeddataKeyValues__c Object with fieldname__c+FieldValue__c as key and SeeddataKeyValues__c record related to that Fieldname+FieldValue as values. 3rd object data from seedData JSON
    Public static map<string, SeeddataKeyValues__c> seedDataKeyFieldValuesMap = new map<string,SeeddataKeyValues__c>();
    // This list has the data from Seeddata_Acc_Seq_Data__c object, 1st object from the Seed Data JSON structure. (Sequence Name and sequence Values to be looked into for actuall pattern)
    public static List<Seeddata_Acc_Seq_Data__c> seedDataAccSeqDataList = new List<Seeddata_Acc_Seq_Data__c>();
    // This Map has the Key value pairs from the Seeddata_Acc_Seq_Data__c with AccountSequenceName__c as Key and List<AccountSequenceData__c> related to the AccountSequenceName__c as Values.
    Public static map<string, list<string>> seedDataAccSeqDataMap = new map<string,list<string>>();
    // This List has the data from the Seeddata_Acc_Seq_fields__c object, 2nd object from the SeedData JSON service. (Data pattern Mapping structure).
    public static List<Seeddata_Acc_Seq_fields__c> seedDataAccSeqFieldsList = new List<Seeddata_Acc_Seq_fields__c>();  
    // This Map has the data from the Seeddata_Acc_Seq_fields__c with KEYFIELDNAME__c as a Key and AccountSequenceName__c as a Value,(This is to tell us that for a required field which Account sequence data we need to look into from the 1st table of Seed Data JSON).
    Public static map<string,string> seedDataAccSeqFieldsMap = new map<string,string>();
    // This Map has the data from the Seeddata_Acc_Seq_fields__c with the KEYFIELDNAME__c as Key and its position in the dependency structure, which is the AccountSequenceDescription__c, (This tells us which part of the Account sequence data to look into for the actuall data from the 1st object of JSON-Seeddata_Acc_Seq_Data__c)
    Public static map<string, Integer> SeedDataFieldNamePositionMap = new map<string,Integer>();
    
    @AuraEnabled
    public static SeedDataWrapper getRawSeedData()
    {
        
        seedDataKeyValuesList = [SELECT Id,FieldName__c,FieldValue__c,FieldDescription__c FROM SeeddataKeyValues__c];
        seedDataAccSeqDataList = [SELECT Id,AccountSequenceData__c,AccountSequenceName__c FROM Seeddata_Acc_Seq_Data__c  ];
        seedDataAccSeqFieldsList = [SELECT Id,KEYFIELDNAME__c,AccountSequenceName__c,AccountSequenceDescription__c FROM Seeddata_Acc_Seq_fields__c];
        if(seedDataKeyValuesList.size()>0)
        {
            for(SeeddataKeyValues__c SDKV : seedDataKeyValuesList)
            {
                if(seedDataKeyValuesMap.containsKey(SDKV.FieldName__c))
                {seedDataKeyValuesMap.get(SDKV.FieldName__c).add(SDKV);}
                 else
                { seedDataKeyValuesMap.put(SDKV.FieldName__c, new list<SeeddataKeyValues__c>{SDKV});}
                
                seedDataKeyFieldValuesMap.put(SDKV.FieldName__c+SDKV.FieldValue__c, SDKV);
                
            }
        }
        system.debug('Test for map 1-->'+seedDataKeyFieldValuesMap);
        if(seedDataAccSeqDataList.size()>0)
        {
            for(Seeddata_Acc_Seq_Data__c SDASD : seedDataAccSeqDataList)
            {
                if(seedDataAccSeqDataMap.containsKey(SDASD.AccountSequenceName__c))
        {seedDataAccSeqDataMap.get(SDASD.AccountSequenceName__c).add(SDASD.AccountSequenceData__c);}
         else
         { seedDataAccSeqDataMap.put(SDASD.AccountSequenceName__c, new List<string>{SDASD.AccountSequenceData__c});}
            }
        }
        if(seedDataAccSeqFieldsList.size()>0)
        {
            for(Seeddata_Acc_Seq_fields__c SDASF : seedDataAccSeqFieldsList)
            {
                seedDataAccSeqFieldsMap.put(SDASF.KEYFIELDNAME__c,SDASF.AccountSequenceName__c);
                if(SDASF.KEYFIELDNAME__c == 'SALES_OFFICE' || SDASF.KEYFIELDNAME__c == 'SALES_GROUP' || SDASF.KEYFIELDNAME__c == 'PLANT')
                {
                    String seedDataDesc = SDASF.AccountSequenceDescription__c;
                    String[] seedDataDescArray = seedDataDesc.split('-');
                    for(String s : seedDataDescArray)
                       {
                           SeedDataFieldNamePositionMap.put(s,seedDataDescArray.Indexof(s));
                       }
                    system.debug('pos-->'+SeedDataFieldNamePositionMap);
                }
            }
        }
        system.debug('Test for object'+SeedDataFieldNamePositionMap);
        SeedDataWrapper dataWrapper = new SeedDataWrapper();
        dataWrapper.seedDataKeyValuesMap_wrapper = seedDataKeyValuesMap;
        dataWrapper.seedDataKeyFieldValuesMap_wrapper = seedDataKeyFieldValuesMap;
        dataWrapper.seedDataAccSeqDataMap_wrapper = seedDataAccSeqDataMap;
        dataWrapper.seedDataAccSeqFieldsMap_wrapper = seedDataAccSeqFieldsMap;
        dataWrapper.SeedDataFieldNamePositionMap_wrapper = SeedDataFieldNamePositionMap;
        return dataWrapper;
    }
    
    public class SeedDataWrapper{
       
        @AuraEnabled Public map<string, list<SeeddataKeyValues__c>> seedDataKeyValuesMap_wrapper {get;set;}
        @AuraEnabled Public  map<string, SeeddataKeyValues__c> seedDataKeyFieldValuesMap_wrapper {get;set;}
        @AuraEnabled Public map<string, list<string>> seedDataAccSeqDataMap_wrapper {get;set;}     
        @AuraEnabled Public map<string,string> seedDataAccSeqFieldsMap_wrapper {get;set;}     
        @AuraEnabled Public map<string, Integer> SeedDataFieldNamePositionMap_wrapper {get;set;}

    }
}
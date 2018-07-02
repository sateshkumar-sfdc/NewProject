public with sharing class CreateCustomerController {
    Public static map<string, List<string>> PV_ACC_SEQ_DATA_ResultsMap = new map<string,List<string>>();
    //  Public static map<string, List<AccountSeedDataResponse.Item_Z>> PV_FIELD_TO_ACC_SEQ_ResultsMap = new map<string,List<AccountSeedDataResponse.Item_Z>>(); 
    Public static map<string, AccountSeedDataResponse.Item_Y> PV_KEY_VALUES_ResultsMap = new map<string,AccountSeedDataResponse.Item_Y>();
    Public static map<string, List<AccountSeedDataResponse.Item_Y>> PV_KEY_VALUESMap = new map<string,List<AccountSeedDataResponse.Item_Y>>();
    // Sales Org and values Map.
    Public static map<string, List<AccountSeedDataResponse.Item_Y>> SALES_ORGResultsMap = new map<string,List<AccountSeedDataResponse.Item_Y>>(); 
    // Key_FIELDNAME and ACC_SEQ_NAME Map
    Public static map<string, string> KEY_FIELDNAME_ACC_SEQ_NAMEMap =  new map<string,string>();
    //map for Key_FIELDNAME and its position in ACC_SEQ_DESCR
    Public static map<string, Integer> KEY_FIELDNAME_PositionMap = new map<string,Integer>();   
    @AuraEnabled
    public static List<string> getPickValues(string object_name, String field_name) {
       /* List<String> options = new List<String>(); //new list for holding all of the picklist options
        system.debug('op-->'+object_name+field_name);
        Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(object_name); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(a.getLabel()); 
        }
        system.debug('options---'+options);*/
        return CommonUtil.getPickValues(object_name, field_name); //return the List
    }    
    @AuraEnabled
    public static Id saveAccount(Account ac, String recType, String fname, String lname, boolean saveAndSync)
    {
        string country;
        string contactType; 
        string currencyValue;
        try{
           
            system.debug('Account object-->'+ac+recType+fname+lname);
            system.debug('Account object country-->'+ac.BillingCountry);
            if(ac.BillingCountry == 'US' || ac.BillingCountry == 'USA')
            {
                country = 'US';
                currencyValue = 'USD';
            }
            else if(ac.BillingCountry == 'CAD' || ac.BillingCountry == 'CANADA' || ac.BillingCountry == 'CA')
            {
                country = 'CANADA';
                currencyValue = 'CAD';
            }
            system.debug(recType+'-->'+country);
            String accountRecordTypeName = CommonUtil.getRecordTypeName('Account', recType, country);     
            Id accRectypeId = RecordTypeSelectionController.getRecTypeIdAccount('Account',accountRecordTypeName,recType);
            system.debug('acc rec devname-->'+accountRecordTypeName+'accrec Id-->'+accRectypeId);
            Account acc;
            acc = new Account();
            acc = ac;
            acc.RecordTypeId = accRectypeId;
            acc.CurrencyIsoCode = currencyValue;
            string accType = 'SoldTo';
            if(recType == 'Business Account'){
                 if(saveAndSync == true)
            {
                ac.CustomerNumber__c = AccountService.actuallCallOut(ac, ac.Name,accType);
            }
                upsert acc;
                String contactRecordTypeName = CommonUtil.getRecordTypeName('Contact', country, country);
                Id conRectypeId = RecordTypeSelectionController.getRecTypeId('Contact',contactRecordTypeName);
                Contact con = new Contact(FirstName = fname, LastName = lname, Phone = ac.Phone, Email = ac.Email__c, AccountId = acc.Id, RecordTypeId = conRectypeId,Primary_Contact__c = true);
                insert con;
            }
            else{
                if(saveAndSync == true)
            {
                ac.CustomerNumber__c = AccountService.actuallCallOut(ac, fname+' '+lname,accType);
            }
                acc.FirstName = fname;
                acc.LastName = lname;
                acc.PersonEmail = ac.Email__c;
                insert acc;
            }
            return acc.Id;   
        }
        catch(Exception e)
        {
            system.debug('error'+e);
            return null;
        }
    }    
    @AuraEnabled
    public static SeedDataWrapper getAccountSeedData()
    {  
        String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_SEED_DATA','', 'GET');
        system.debug(JsonResponse);
        AccountSeedDataResponse wrapper = (AccountSeedDataResponse)JSON.deserialize(JsonResponse, AccountSeedDataResponse.class);
        system.debug(wrapper);
        for(AccountSeedDataResponse.Item Item : (wrapper.PV_ACC_SEQ_DATA).item)
        {if(PV_ACC_SEQ_DATA_ResultsMap.containsKey(Item.ACC_SEQ_NAME))
        {PV_ACC_SEQ_DATA_ResultsMap.get(Item.ACC_SEQ_NAME).add(Item.ACC_SEQ_DATA);}
         else
         { PV_ACC_SEQ_DATA_ResultsMap.put(Item.ACC_SEQ_NAME, new List<string>{Item.ACC_SEQ_DATA});}
        }
                /* for(AccountSeedDataResponse.Item_Z Item : (wrapper.PV_FIELD_TO_ACC_SEQ).item)
        {if(PV_FIELD_TO_ACC_SEQ_ResultsMap.containsKey(Item.KEY_FIELDNAME))
        {PV_FIELD_TO_ACC_SEQ_ResultsMap.get(Item.KEY_FIELDNAME).add(Item);               }
        else
        {PV_FIELD_TO_ACC_SEQ_ResultsMap.put(Item.KEY_FIELDNAME, new List<AccountSeedDataResponse.Item_Z>{Item});}
        }*/
                //Fetching PV_KEY_VALUES and their list of values
        for(AccountSeedDataResponse.Item_Y Item : (wrapper.PV_KEY_VALUES).item)
        {   
            PV_KEY_VALUES_ResultsMap.put(Item.FIELDNAME+Item.FIELDVALUE, Item);
        }
        // Fetching Sales Org Values // 
        for(AccountSeedDataResponse.Item_Y Item : (wrapper.PV_KEY_VALUES).item)
        {   IF(Item.FIELDNAME == 'SALESORG'){
            if(SALES_ORGResultsMap.containsKey(Item.FIELDNAME))
            {SALES_ORGResultsMap.get(Item.FIELDNAME).add(Item); }
            else
            {SALES_ORGResultsMap.put(Item.FIELDNAME, new List<AccountSeedDataResponse.Item_Y>{Item});}
        }
        }
        for(AccountSeedDataResponse.Item_Y Item : (wrapper.PV_KEY_VALUES).item)
        { 
            if(PV_KEY_VALUESMap.containsKey(Item.FIELDNAME))
            {PV_KEY_VALUESMap.get(Item.FIELDNAME).add(Item); }
            else
            {PV_KEY_VALUESMap.put(Item.FIELDNAME, new List<AccountSeedDataResponse.Item_Y>{Item});}        
        }
        // Fetching KEY_FIELDNAME and ACC_SEQ_NAME values Map. 
        for(AccountSeedDataResponse.Item_Z Item : (wrapper.PV_FIELD_TO_ACC_SEQ).item)
        {
            KEY_FIELDNAME_ACC_SEQ_NAMEMap.put(Item.KEY_FIELDNAME, Item.ACC_SEQ_NAME);
        }
        system.debug('Test map====>1'+KEY_FIELDNAME_ACC_SEQ_NAMEMap);
        // Map of KEY_FIELDNAME and position in ACC_SEQ_NAME.
        // map<string, Integer> KEY_FIELDNAME_PositionMap = new map<string,Integer>();
        for(AccountSeedDataResponse.Item_Z Item : (wrapper.PV_FIELD_TO_ACC_SEQ).item)
        {
            if(Item.KEY_FIELDNAME == 'SALES_OFFICE' || Item.KEY_FIELDNAME == 'SALES_GROUP')
            {
                String ACC_SEQ_DESCR_Str = Item.ACC_SEQ_DESCR;
                String[] ACC_SEQ_DESCR_Str_Array = ACC_SEQ_DESCR_Str.split('-');
                system.debug('Split Array-->'+ACC_SEQ_DESCR_Str_Array);
                for(string s : ACC_SEQ_DESCR_Str_Array )
                {
                    KEY_FIELDNAME_PositionMap.put(s,ACC_SEQ_DESCR_Str_Array.Indexof(s));
                }
            }
            system.debug('value position-->'+KEY_FIELDNAME_PositionMap);
        }
        //  system.debug(PV_ACC_SEQ_DATA_ResultsMap);
        List<AccountSeedDataResponse.Item_Y> result = SALES_ORGResultsMap.get('SALESORG');
        SeedDataWrapper dataWrapper = new SeedDataWrapper();
        dataWrapper.ACC_SEQ_NAME_DATA_Result = PV_ACC_SEQ_DATA_ResultsMap;
        dataWrapper.NAMEVALUE_ITEM_Result = PV_KEY_VALUES_ResultsMap;
        dataWrapper.NAME_ITEM_RESULT = PV_KEY_VALUESMap;
        dataWrapper.SALES_ORG_RESULT = SALES_ORGResultsMap;
        dataWrapper.KEY_FIELDNAME_ACC_SEQ_NAME_RESULT = KEY_FIELDNAME_ACC_SEQ_NAMEMap;
        dataWrapper.KEY_FIELDNAME_POSITION_RESULT = KEY_FIELDNAME_PositionMap;
        system.debug('wrapper'+dataWrapper);
        return dataWrapper;
        //return result;
    }
    @AuraEnabled
    Public static List<AccountSeedDataResponse.Item_Y> getAccountDstrChanData()
    {
        system.debug('Test Mapping vLUES');
        List<AccountSeedDataResponse.Item_Y> result = PV_KEY_VALUESMap.get('PAYT_TERMS');
        return result;
    }
    @AuraEnabled
    public static List<AccountSeedDataResponse.Item_Y> getSeedValues(string controlling, string dep, string wrap)
    {
        system.debug('test fro internal error'+controlling+dep);
        SeedDataWrapper wrapData = (SeedDataWrapper)JSON.deserialize(wrap, SeedDataWrapper.class);
        system.debug('Test map====>1231'+wrapData.ACC_SEQ_NAME_DATA_Result);
        system.debug('Test map====>1232'+wrapData.KEY_FIELDNAME_ACC_SEQ_NAME_RESULT);
        system.debug('Test map====>1233'+wrapData.KEY_FIELDNAME_POSITION_RESULT);
        system.debug('Test map====>1234'+wrapData.NAMEVALUE_ITEM_Result);
        string Acc_Seq_Name = wrapData.KEY_FIELDNAME_ACC_SEQ_NAME_RESULT.get(dep);
        Integer valuePosition = wrapData.KEY_FIELDNAME_POSITION_RESULT.get(dep);
        List<String> ACC_SEQ_DATA_Values = wrapData.ACC_SEQ_NAME_DATA_Result.get(Acc_Seq_Name);
        Set <AccountSeedDataResponse.Item_Y> returnDependantList = new Set<AccountSeedDataResponse.Item_Y>();
        for(String s : ACC_SEQ_DATA_Values)
        {
            if(s.contains(controlling))
            {
                string value = s.split('-')[valuePosition];
                AccountSeedDataResponse.Item_Y dependantItem = wrapData.NAMEVALUE_ITEM_Result.get(dep+value);
                returnDependantList.add(dependantItem);
            }
        }
        List<AccountSeedDataResponse.Item_Y> returnList = new List<AccountSeedDataResponse.Item_Y>();
        returnList.addAll(returnDependantList);
        system.debug('Test returnlist'+returnList);
        return returnList;
    }   
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
       // User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
       //               FROM User Where id =: userInfo.getUserId()];
       
        return CommonUtil.fetchUser();
    }
    
     @AuraEnabled
    public static Account getAccount(Id recId){
        Account acc = SoldToAccount.getSoldToAccount(recId);
        return acc;
    }
    
    
    public class SeedDataWrapper{
        // @AuraEnabled public string fieldname {get;set;}
        @AuraEnabled Public map<string, List<string>> ACC_SEQ_NAME_DATA_Result {get;set;}
        @AuraEnabled Public map<string, AccountSeedDataResponse.Item_Y> NAMEVALUE_ITEM_Result {get;set;}
        @AuraEnabled Public map<string, List<AccountSeedDataResponse.Item_Y>> NAME_ITEM_RESULT {get;set;}
        // Sales Org and values Map.
        @AuraEnabled Public map<string, List<AccountSeedDataResponse.Item_Y>> SALES_ORG_RESULT {get;set;}
        // Key_FIELDNAME and ACC_SEQ_NAME Map
        @AuraEnabled Public map<string, string> KEY_FIELDNAME_ACC_SEQ_NAME_RESULT {get;set;}
        //map for Key_FIELDNAME and its position in ACC_SEQ_DESCR
        @AuraEnabled Public map<string, Integer> KEY_FIELDNAME_POSITION_RESULT {get;set;} 
    }
}
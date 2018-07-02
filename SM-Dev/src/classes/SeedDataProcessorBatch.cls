global class SeedDataProcessorBatch implements Database.Batchable<string>, Database.Stateful, Database.AllowsCallouts  {
//global boolean bReRun = false; //will be used to determine if batch has to re-run in case there are more that 10K of records
global Iterable<string> start(Database.BatchableContext ctx) {
    return new list<String> { 'Seeddata_Acc_Seq_Data__c','Seeddata_Acc_Seq_fields__c','SeeddataKeyValues__c'}; //list of strings with my object names
}
global void execute(Database.BatchableContext ctx, list<string> lstsObjectName) {
    list<sObject> lstDeleteRecords = new list<sObject>();
    list<sObject> insertRecords = new list<sObject>();
    String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_SEED_DATA','', 'GET');
    system.debug(JsonResponse);
    if(JsonResponse != null && JsonResponse!='')
    {
        datetime dt = System.now();
    	system.Debug('Current Date'+dt);
    	for(string strObjectName : lstsObjectName) {
        for(sObject objsObject : database.query('Select Id,CreatedDate from ' + strObjectName+' Where CreatedDate <: dt')) {
          //  if(lstDeleteRecords.size() < 9998)
                lstDeleteRecords.add(objsObject);
           /* else {
                bReRun = true;
                break;
            }*/
        }
    }
    system.debug('Deleted Records'+lstDeleteRecords.size());
    }
    AccountSeedDataResponse wrapper = (AccountSeedDataResponse)JSON.deserialize(JsonResponse, AccountSeedDataResponse.class);
    
      for(AccountSeedDataResponse.Item_Z Itm_z : wrapper.PV_FIELD_TO_ACC_SEQ.Item)
    {
        Seeddata_Acc_Seq_fields__c Acc_Seq_Fields = new Seeddata_Acc_Seq_fields__c();
        Acc_Seq_Fields.AccountSequenceDescription__c =  Itm_z.ACC_SEQ_DESCR;
        Acc_Seq_Fields.AccountSequenceName__c =  Itm_z.ACC_SEQ_NAME;
		Acc_Seq_Fields.KEYFIELDNAME__c =  Itm_z.KEY_FIELDNAME;
        insertRecords.add(Acc_Seq_Fields);
    }
    
    for(AccountSeedDataResponse.Item Itm : wrapper.PV_ACC_SEQ_DATA.Item)
    {
          	Seeddata_Acc_Seq_Data__c Acc_Seq_Data = new Seeddata_Acc_Seq_Data__c();
            Acc_Seq_Data.AccountSequenceData__c =  Itm.ACC_SEQ_DATA;
            Acc_Seq_Data.AccountSequenceName__c =  Itm.ACC_SEQ_NAME;
        	insertRecords.add(Acc_Seq_Data);
    }
    
     for(AccountSeedDataResponse.Item_Y Itm_y : wrapper.PV_KEY_VALUES.Item)
    {
       
        SeeddataKeyValues__c PV_KEY_VALUES = new SeeddataKeyValues__c();
        PV_KEY_VALUES.FieldDescription__c =  Itm_y.FIELDDESCR;
        PV_KEY_VALUES.FieldName__c =  Itm_y.FIELDNAME;
        PV_KEY_VALUES.FieldValue__c = Itm_y.FIELDVALUE; 
        insertRecords.add(PV_KEY_VALUES);
    }

   
    system.debug('Inserted Records'+insertRecords.size());
   
    if(insertRecords.size()>0)
        insert insertRecords;
    
        if(lstDeleteRecords.size()>0)
        delete lstDeleteRecords;
}
global void finish(Database.BatchableContext ctx) {
    system.debug('batch finished');
 //   if(bReRun) {
//         Database.executebatch(new DeleteRecords());
    }
}
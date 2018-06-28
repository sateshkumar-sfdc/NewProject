global class SeedDataProcessorBatch implements Database.Batchable<string>, Database.Stateful  {
//global boolean bReRun = false; //will be used to determine if batch has to re-run in case there are more that 10K of records
global Iterable<string> start(Database.BatchableContext ctx) {
    return new list<String> { 'Seeddata_Acc_Seq_Data__c'}; //list of strings with my object names
}
global void execute(Database.BatchableContext ctx, list<string> lstsObjectName) {
    list<sObject> lstDeleteRecords = new list<sObject>();
    for(string strObjectName : lstsObjectName) {
        for(sObject objsObject : database.query('Select Id from ' + strObjectName )) {
          //  if(lstDeleteRecords.size() < 9998)
                lstDeleteRecords.add(objsObject);
           /* else {
                bReRun = true;
                break;
            }*/
        }
    }
    lstDeleteRecords.sort();
    delete lstDeleteRecords;
}
global void finish(Database.BatchableContext ctx) {
    system.debug('batch finished');
 //   if(bReRun) {
//         Database.executebatch(new DeleteRecords());
    }
}
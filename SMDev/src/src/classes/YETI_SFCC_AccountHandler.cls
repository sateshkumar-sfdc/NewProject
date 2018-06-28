public class YETI_SFCC_AccountHandler {
    
    YETI_SFCC_AccountHelper YETI_SFCC_AccountHelper = new YETI_SFCC_AccountHelper();
    
    public YETI_SFCC_AccountHandler(){
        if(Trigger.isBefore && Trigger.isInsert){
            beforeInsertTrigger();
        }
        if(Trigger.isBefore && Trigger.isUpdate){
            beforeUpdateTrigger();
        }
        if(Trigger.isAfter && Trigger.isInsert){
            afterInsertTrigger();
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            afterUpdateTrigger();
        }
    }
    
    public void beforeInsertTrigger(){}
    
    public void beforeUpdateTrigger(){}
    
    public void afterInsertTrigger(){
        system.debug('YETI_SFCC_AccountHandler YETI_SFCC_AccountHandler YETI_SFCC_AccountHandler YETI_SFCC_AccountHandler');
        YETI_SFCC_AccountHelper.createSfccAccountMain();
    }
    
    public void afterUpdateTrigger(){
        
    }

}
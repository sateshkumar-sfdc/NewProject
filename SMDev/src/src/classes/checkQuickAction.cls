public class checkQuickAction {
    @AuraEnabled
    public static list<Account> getStatus(){
        return [select name, id from Account limit 2000];
    }

}
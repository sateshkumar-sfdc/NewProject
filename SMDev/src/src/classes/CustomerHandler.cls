public with sharing class CustomerHandler {

     @AuraEnabled
    public static Id saveAccount(Account ac)
    {
        try{
        system.debug('Account object-->'+ac);
        Account acc = ac;
        insert acc;
        return acc.Id;
            }
        catch(Exception e)
        {
            return null;
        }
        
    }
}
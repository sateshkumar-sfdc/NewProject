public class UTIL_DealerPortal
{
    // getAccountFromCurrentUser()
    //
    // Gets an account object linked to the current user. If none found,
    // returns null.
    public static Account getAccountFromCurrentUser()
    {
        Account acct = null;

        try
        {
            List<User> users = Database.query('SELECT SAP_Customer_Number__c FROM User WHERE Username = \'' + UserInfo.getUserName() + '\' LIMIT 1');
            if (users.size() > 0)
            {
                String sapCustomerNumber = (String) users[0].get('SAP_Customer_Number__c');
                if (sapCustomerNumber.length() > 0)
                {
                    List<Account> accounts = Database.query('SELECT Id, Name, BillingCity, Phone, BillingStreet, BillingPostalCode, BillingState, BillingCountry, CreatedDate, ParentId, ENSX_EDM__SAP_Customer_Number__c FROM Account WHERE ENSX_EDM__SAP_Customer_Number__c =:sapCustomerNumber LIMIT 1');
                    if (accounts.size() > 0)
                    {
                        acct = accounts[0];
                    }
                }
            }
        }
        catch (Exception ex)
        {
            System.debug('*** DEBUG: Exception in UTIL_DealerPortal.getAccountFromCurrentUser(): ' + ex.getMessage());
        }

        return acct;
    }
}
// UTIL_YetiCustomerTouchedEventHandler
//
//
// Updates Yeti specific fields on Account with the Inside Sales Rep & Outside Sales Rep.
// Depends on the Yeti Reporting Objects package declared in the Yeti bulktest org.
//
// Declared "without sharing" so that it runs in the system context so it has the permissions
// to change the Account owner to the Outside Sales Rep user.
public without sharing class UTIL_YetiCustomerTouchedEventHandler implements I_EventHandler
{
    public void run(Map<String, object> context)
    {
        System.debug('UTIL_YetiCustomerTouchedEventHandler: ' + context.get('EventName'));

        SBO_EnosixCustomer_Detail.EnosixCustomer customer =
                (SBO_EnosixCustomer_Detail.EnosixCustomer)
                        context.get('SBO_EnosixCustomer_Detail.EnosixCustomer');

        if (null == customer)
        {
            return;
        }

        Boolean isAccountChanged = false;
        UTIL_YetiCustomExceptions.YetiMissingOutsideRepUserException delayedMissingOutsideRepUserException = null;

        // If there is no account, assigning this query result to an Account object will throw
        Account sfAccount = null;
        try
        {
            List<Account> sfAccounts = Database.query('SELECT Id, OwnerId, Inside_Sales_Rep__c, Inside_Sales_Rep_Text__c, '
                + 'Outside_Sales_Rep__c, Outside_Sales_Rep_Text__c FROM Account '
                + 'WHERE ENSX_EDM__SAP_Customer_Number__c = \'' + customer.CustomerNumber + '\' LIMIT 1');
            sfAccount = sfAccounts[0];
        }
        catch (Exception ex)
        {
            // No account found, log the exception and give up now
            System.debug(ex);
            return;
        }

        List<SBO_EnosixCustomer_Detail.PARTNERS> allPartners =
                new List<SBO_EnosixCustomer_Detail.PARTNERS>();
        customer.PARTNERS.copyTo(allPartners);

        for (SBO_EnosixCustomer_Detail.PARTNERS p : allPartners)
        {
            if ('ZI' == p.PartnerFunction)
            {
                System.debug('Inside Sales Rep: ' + p.PartnerName + ' (' + p.PartnerNumber + ')');
                // Inside Sales Rep
                if (sfAccount.get('Inside_Sales_Rep__c') != p.PartnerNumber
                    || sfAccount.get('Inside_Sales_Rep_Text__c') != p.PartnerName)
                {
                    sfAccount.put('Inside_Sales_Rep__c', p.PartnerNumber);
                    sfAccount.put('Inside_Sales_Rep_Text__c', p.PartnerName);
                    isAccountChanged = true;
                }
            }
            else if ('Z0' == p.PartnerFunction)
            {
                System.debug('Outside Sales Rep: ' + p.PartnerName + ' (' + p.PartnerNumber + ')');

                // Outside Sales Rep
                if (sfAccount.get('Outside_Sales_Rep__c') != p.PartnerNumber
                    || sfAccount.get('Outside_Sales_Rep_Text__c') != p.PartnerName)
                {
                    sfAccount.put('Outside_Sales_Rep__c', p.PartnerNumber);
                    sfAccount.put('Outside_Sales_Rep_Text__c', p.PartnerName);
                    isAccountChanged = true;
                }

                // Update the Account Owner
                List<User> sfUser = Database.query('SELECT Id FROM User WHERE SAP_Rep__c = \'' + p.PartnerNumber + '\' LIMIT 1');
                if (1 == sfUser.size() && sfAccount.OwnerId != sfUser[0].Id)
                {
                    System.debug('Updating Account Owner');
                    // System level permission (i.e. "without sharing") required to change Owner
                    sfAccount.OwnerId = sfUser[0].Id;
                    isAccountChanged = true;
                }
                else if (0 == sfUser.size())
                {
                    // Delay throwing exception until after saving the Account
                    delayedMissingOutsideRepUserException =
                        new UTIL_YetiCustomExceptions.YetiMissingOutsideRepUserException(String.format(
                            'Unable to find Salesforce User with Outside Sales Rep # {0} ({1})',
                            new List<String> {p.PartnerNumber, p.PartnerName}
                    ));
                }
            }
        }

        if (isAccountChanged)
        {
            update sfAccount;
        }

        // Delay throwing exception until after saving the Account so the fields that can be synced are saved
        if (null != delayedMissingOutsideRepUserException)
        {
            throw delayedMissingOutsideRepUserException;
        }
    }
}
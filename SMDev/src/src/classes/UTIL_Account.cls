public with sharing class UTIL_Account
{
    public static String CustomerFieldName
    {
        get
        {
            return (String)UTIL_AppSettings.getValue(
                'Account.CustomerFieldName', 'ENSX_EDM__SAP_Customer_Number__c');
        }
    }

    public static Account getAccountFromId(Id value)
    {
        Account result = null;

        if (null != value)
        {
            result = Database.query('Select Name, BillingCity, Phone, RecordTypeId, RecordType.Name, BillingStreet, BillingPostalCode, BillingState, BillingCountry, CreatedDate, ParentId, AccountNumber, ' + UTIL_Account.CustomerFieldName + ' FROM Account WHERE Id = :value LIMIT 1');
        }
        return result;
    }

    public static Account getAccountFromOpportunity(Opportunity opp)
    {
        if (null != opp)
        {
            return getAccountFromId(opp.AccountId);
        }
        return null;
    }

    public static String getCustomerNumberFromAccount(Account account)
    {
        String custFieldName = UTIL_Account.CustomerFieldName;
        return (String) account.get(custFieldName);
    }

    public static void setAccountCustomerNumber(Account account, string customerNumber)
    {
        string customerField = UTIL_Account.CustomerFieldName;
        account.put(customerField, customerNumber);
    }
}
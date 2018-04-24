public with sharing class UTIL_YetiSyncHelper
{
    private static Account notFoundAccount = null;

    // createSalesOrderIdMap()
    //
    // Looks up Order for the given Order IDs and creates a map
    public static Map<String, String> createSalesOrderIdMap(Set<String> salesOrderNumbers)
    {
        Map<String, String> result = new Map<String, String>();
        List<Order__c> salesOrders = [SELECT Id, Name
            FROM Order__c WHERE Name IN :salesOrderNumbers];
        for (Order__c salesOrder : salesOrders)
        {
            result.put(salesOrder.Name, salesOrder.Id);
        }
        return result;
    }

    // createDeliveryIdMap()
    //
    // Looks up Deliveries for the given Deliveries IDs and creates a map
    public static Map<String, String> createDeliveryIdMap(Set<String> deliveriesNumbers)
    {
        Map<String, String> result = new Map<String, String>();
        List<Deliveries__c> deliveries = [SELECT Id, Name
            FROM Deliveries__c WHERE Name IN :deliveriesNumbers];
        for (Deliveries__c delivery : deliveries)
        {
            result.put(delivery.Name, delivery.Id);
        }
        return result;
    }

    // createInvoiceIdMap()
    //
    // Looks up Invoices for the given Invoice IDs and creates a map
    public static Map<String, String> createInvoiceIdMap(Set<String> invoiceNumbers)
    {
        Map<String, String> result = new Map<String, String>();
        List<Invoice__c> invoices = [SELECT Id, Name
            FROM Invoice__c WHERE Name IN :invoiceNumbers];
        for (Invoice__c invoice : invoices)
        {
            result.put(invoice.Name, invoice.Id);
        }
        return result;
    }

    // getNotFoundAccountId()
    //
    // Get the Not Found Account Id for the sync process
    public static string getNotFoundAccountId(List<sObject> errors)
    {
        if (null == notFoundAccount)
        {
            Map<String, String> result = new Map<String, String>();
            List<Account> accounts = [SELECT Id, Name
                FROM Account WHERE Name = 'NOT_FOUND' LIMIT 1];
            if (accounts.size() > 0)
            {
                notFoundAccount = accounts[0];
            }
            else
            {
                try
                {
                    notFoundAccount = new Account();
                    notFoundAccount.Name = 'NOT_FOUND';
                    insert notFoundAccount;
                }
                catch (Exception e)
                {
                    notFoundAccount = null;
                    UTIL_SyncHelper.addLog(
                        errors, 'ERROR', 'Could not find or create NOT_FOUND account');
                    return '';
                }
            }
        }
        return notFoundAccount.Id;
    }

    // buildAddress()
    //
    // build the address text block
    public static String buildAddress(String name1, String name2, String street, String city, String postalCode, String country)
    {
        String address = '';
        if (String.isNotBlank(name1)) { address = name1 + ' '; }
        if (String.isNotBlank(name2)) { address += name2; }
        address = address.trim();
        if (String.isNotBlank(address) && String.isNotBlank(street)) { address += '\n'; }
        if (String.isNotBlank(street)) { address += street; }
        String addressLine = '';
        if (String.isNotBlank(city)) { addressLine += city; }
        if (String.isNotBlank(addressLine) && String.isNotBlank(postalCode)) { addressLine += ', '; }
        if (String.isNotBlank(postalCode)) { addressLine += postalCode; }
        if (String.isNotBlank(addressLine) && String.isNotBlank(country)) { addressLine += ', '; }
        if (String.isNotBlank(country)) { addressLine += country; }
        if (String.isNotBlank(address) && String.isNotBlank(addressLine)) { address += '\n'; }
        if (String.isNotBlank(addressLine)) { address += addressLine; }
        return address;
    }
    
    // getCustomPricebook()
    //
    // Get the custom pricebook by it's name set in the AppSettings
    public static Pricebook2 getCustomPricebook()
    {
        Pricebook2 pricebook = null;    
        String pricebookName = dealerCustomPricebook;
        if (String.isNotBlank(pricebookName))
        {
            try
            {
                pricebook = Database.query('SELECT Id, Name FROM Pricebook2 WHERE Name = :pricebookName LIMIT 1');
            }
            catch (Exception ex)
            {
                System.debug(ex);
            }
        }
        return pricebook;
    }

    // Get custom pricebook name
    public static String dealerCustomPricebook
    {
        get
        {
            return (String)UTIL_AppSettings.getValue('Pricebook.Dealer', '');
        }
    }
}
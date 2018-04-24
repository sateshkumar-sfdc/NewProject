public class UTIL_YetiPartnerAddedEventHandler implements I_EventHandler
{
    public void run(Map<String, object> context)
    {
        System.debug('UTIL_YetiPartnerAddedEventHandler');
        SBO_EnosixCustomer_Detail.EnosixCustomer createdCustomer = 
          (SBO_EnosixCustomer_Detail.EnosixCustomer) context.get('SBO_EnosixCustomer_Detail.EnosixCustomer');
        Account acct = (Account) context.get('Account');
        if (createdCustomer != null)
        {
          try
          {
            RecordType rt;
            try
            {
              List<RecordType> rts = Database.query('SELECT Id, Name FROM RecordType WHERE Name = \'Ship To\' LIMIT 1');
              rt = rts[0];
            }
            catch (Exception ex)
            {
                throw new UTIL_YetiCustomExceptions.RecordTypeMissingException('RecordType named "Ship To" not found.');
            }

            Account a = new Account();
            a.Name = createdCustomer.Name + ' - ' + createdCustomer.City;
            a.put('ENSX_EDM__SAP_Customer_Number__c', createdCustomer.CustomerNumber);
            a.ShippingState = createdCustomer.Region;
            a.ShippingCity = createdCustomer.City;
            a.ShippingStreet = createdCustomer.Street;
            if (acct != null)
            {
                a.ParentId = acct.Id;
                a.Parent = acct;
            }
            a.RecordTypeId = rt.Id;
            a.Phone = createdCustomer.TelephoneNumber;
            a.ShippingPostalCode = createdCustomer.PostalCode;
            upsert a;
          }
          catch (Exception ex)
          {
            throw ex;
          }
        }
    }
}
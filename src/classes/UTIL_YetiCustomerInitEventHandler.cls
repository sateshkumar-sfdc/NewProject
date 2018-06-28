public class UTIL_YetiCustomerInitEventHandler implements I_EventHandler
{
    public void run(Map<String, object> context)
    {
        System.debug('UTIL_YetiCustomerInitEventHandler');
        SBO_EnosixCustomer_Detail.EnosixCustomer createdCustomer = 
            (SBO_EnosixCustomer_Detail.EnosixCustomer) context.get('SBO_EnosixCustomer_Detail.EnosixCustomer');
        Account acct = (Account) context.get('Account');
        if (createdCustomer != null)
        {
            try
            {
                List<Account> fetchedAccounts = Database.query('SELECT RecordTypeId FROM Account WHERE Id = \'' + acct.Id + '\' LIMIT 1');
                Account fetchedAccount = fetchedAccounts[0];
                RecordType rt = null;
                if (fetchedAccount.RecordTypeId == null)
                {
                    List<RecordType> rts = Database.query('SELECT Name, DeveloperName FROM RecordType WHERE DeveloperName = \'Account1\' LIMIT 1');
                    rt = rts[0];
                }
                else
                {
                    List<RecordType> rts = Database.query('SELECT Name, DeveloperName FROM RecordType WHERE Id = \'' + fetchedAccount.RecordTypeId + '\' LIMIT 1');
                    rt = rts[0];
                }

                if (null != rt)
                {
                    SBO_EnosixCustomer_Detail.USER_DEFINED ud = new SBO_EnosixCustomer_Detail.USER_DEFINED();
                    ud.Field = 'AccountRecordType';
                    ud.VALUE = String.valueOf(rt.DeveloperName);
                    createdCustomer.USER_DEFINED.add(ud);
                }
            }
            catch (Exception e)
            {
                System.debug(e.getMessage());
                throw e;
            }
        }
    }
}
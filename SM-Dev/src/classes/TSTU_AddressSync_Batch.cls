@isTest
public class TSTU_AddressSync_Batch
{
    class MockSearch implements ensx.EnosixFramework.SearchSBOMock
    {
        Boolean isSuccess;
        public MockSearch(Boolean isSuccess)
        {
            this.isSuccess = isSuccess;
        }

        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            SBO_YetiAddressSync_Search.YetiAddressSync_SR searchResult =
                new SBO_YetiAddressSync_Search.YetiAddressSync_SR();

            if (isSuccess)
            {
                SBO_YetiAddressSync_Search.SEARCHRESULT result = new SBO_YetiAddressSync_Search.SEARCHRESULT();
                result.CustomerNumber = '1';
                result.Street = 'Street';
                result.HouseNumber = '1000';
                result.PostalCode = '90210';
                result.City = 'Beverly Hills';
                result.Country = 'US';
                result.Region = 'CA';
                result.InsideSalesRep = '00078';
                result.OutsideSalesRep = '00078';
                result.ChangeDate = Date.today();
                result.ChangeTime = Datetime.now().time();

                searchResult.SearchResults.add(result);
                SBO_YetiAddressSync_Search.SEARCHRESULT result2 = new SBO_YetiAddressSync_Search.SEARCHRESULT();
                result2.CustomerNumber = '2';
                result2.Street = 'Next St';
                result2.HouseNumber = '2000';
                result2.PostalCode = '90210';
                result2.City = 'Beverly Hills';
                result2.Country = 'US';
                result2.Region = 'CA';
                result2.InsideSalesRep = '00045';
                result2.OutsideSalesRep = '00078';
                result2.ChangeDate = Date.today();
                result2.ChangeTime = Datetime.now().time();
                searchResult.SearchResults.add(result2);
            }

            searchResult.setSuccess(isSuccess);
            return searchResult;
        }
    }

    @isTest public static void executeTest()
    {
        List<String> allIds = new List<String>();

        ENSX.EnosixFramework.setMock(SBO_YetiAddressSync_Search.class, new MockSearch(true));

        createNewAccounts();
        createNewUsers();

        Test.startTest();
        for (Integer i = 0; i < 2; i++)
        {
            UTIL_AddressSync_Batch sync = new UTIL_AddressSync_Batch();
            sync.setBatchParam(null);
            String schedId = Database.executeBatch(sync);
            allIds.add(schedId);
        }
        Test.stopTest();

        //ID in API is of 15 didgits
        for (Integer i =0; i< 2; i++)
        {
            System.assertEquals(15, allIds[i].length());
        }

        // Verify all Accounts with the same SAP Customer Number are updated
        for (Account a : Database.query('SELECT Id, Name, ShippingPostalCode FROM Account WHERE ENSX_EDM__SAP_Customer_Number__c = \'1\''))
        {
            System.assertEquals('90210', a.get('ShippingPostalCode'), a.Name + ' ShippingPostalCode not updated');
        }
    }

    private static void createNewAccounts()
    {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Test Cust 1', ENSX_EDM__SAP_Customer_Number__c = '1'));
        accounts.add(new Account(Name = 'Duplicate of Test Cust 1', ENSX_EDM__SAP_Customer_Number__c = '1'));
        insert accounts;
    }

    private static void createNewUsers()
    {
        List<User> users = new List<User>();
        users.add(new User(
            Username = 'TestUserSync1@test.com',
            LastName = 'Dole',
            Alias = 'Alien',
            CommunityNickname = 'Mouse',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE UserLicense.LicenseDefinitionKey = 'SFDC' LIMIT 1].Id,
            Email = 'TestSyncUser@test.com', 
            SAP_Rep__c = '00078'));
        
        insert users;
    }
}
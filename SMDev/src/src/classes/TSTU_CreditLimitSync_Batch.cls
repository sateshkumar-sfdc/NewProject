@isTest
public class TSTU_CreditLimitSync_Batch
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
            SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SR searchResult =
                new SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SR();

            if (isSuccess)
            {
                SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT result = new SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT();
                result.CustomerNumber = '1';
                result.CreditLimit = 1000;
                result.TotalCreditExposure = 10000;
                result.HorizonDate = Date.today();
                searchResult.SearchResults.add(result);
                SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT result2 = new SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT();
                result2.CustomerNumber = '2';
                result2.CreditLimit = 2000;
                result2.TotalCreditExposure = 10002;
                result2.HorizonDate = Date.today();
                searchResult.SearchResults.add(result2);
            }

            searchResult.setSuccess(isSuccess);
            return searchResult;
        }
    }

    @isTest public static void executeTest()
    {
        List<String> allIds = new List<String>();

        ENSX.EnosixFramework.setMock(SBO_YetiCustCreditLimitSync_Search.class, new MockSearch(true));

        insert new Account(Name = 'Test Cust 1', ENSX_EDM__SAP_Customer_Number__c = '1');
        insert new Account(Name = 'Duplicate of Test Cust 1', ENSX_EDM__SAP_Customer_Number__c = '1');

        Test.startTest();
        for (Integer i = 0; i < 2; i++)
        {
            String schedId = Database.executeBatch(new UTIL_CreditLimitSync_Batch());
            allIds.add(schedId);
        }
        Test.stopTest();

        //ID in API is of 15 didgits
        for (Integer i =0; i< 2; i++)
        {
            System.assertEquals(15, allIds[i].length());
        }

        // Verify all Accounts with the same SAP Customer Number are updated
        for (Account a : Database.query('SELECT Id, Name, Limit__c FROM Account WHERE ENSX_EDM__SAP_Customer_Number__c = \'1\''))
        {
            System.assertEquals(1000, a.get('Limit__c'), a.Name + ' Limit__c not updated');
        }
    }
}
@IsTest
private class TSTU_Account
{
    @isTest
    static void test_getAccountFromId()
    {
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'TestAccount';
        upsert acct;
        Account fetched = UTIL_Account.getAccountFromId(acct.Id);
        System.assertEquals(acct.Name, fetched.Name);
        System.assertEquals(acct.Id, fetched.Id);
        Test.stopTest();
    }

    @isTest
    static void test_getCustomerNumberFromAccount()
    {
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'TestAccount';
        String testCustNumber = 'TESTCUST';
        UTIL_Account.setAccountCustomerNumber(acct, testCustNumber);
        System.assertEquals(UTIL_Account.getCustomerNumberFromAccount(acct), testCustNumber);
        Test.stopTest();
    }

    @isTest
    static void test_getAccountFromOpportunity()
    {
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'TestAccount';
        upsert acct;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.Account = acct;
        opp.StageName = 'Closed Won';
        opp.CloseDate = Date.today();
        upsert opp;
        Account fetched = UTIL_Account.getAccountFromOpportunity(opp);
        Test.stopTest();
    }
}
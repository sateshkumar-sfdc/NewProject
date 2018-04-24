@isTest
public with sharing class TSTU_SyncHelper
{
    private static Account createTestAccount()
    {
        Account testAccount = new Account();
        testAccount.Name = 'test';
        testAccount.put(UTIL_Account.CustomerFieldName, 'testId');
        upsert testAccount;
        return testAccount;
    }

    @isTest
    public static void testGetLastDateFromTable()
    {
        Account acct = createTestAccount();

        Test.startTest();
        DateTime tst = UTIL_SyncHelper.getLastDateFromTable('CreatedDate','Account');
        tst = UTIL_SyncHelper.getLastDateFromTable('test', 'Account');
        Test.stopTest();
    }

    @isTest
    public static void testGetMatchingRecords()
    {
        Account acct = createTestAccount();

        Test.startTest();
        List<SObject> recs = UTIL_SyncHelper.getMatchingRecords('invalid table', new Set<String>());
        recs = UTIL_SyncHelper.getMatchingRecords('Account', new Set<String>{acct.Id});
        Test.stopTest();
    }

    @isTest
    public static void testCreateAccountIdMap()
    {
        Account acct = createTestAccount();

        Test.startTest();
        Map<String, String> mp = UTIL_SyncHelper.createAccountIdMap(new Set<String>{(String) acct.get(UTIL_Account.CustomerFieldName)});
        Test.stopTest();
    }

    @isTest
    public static void testCreateAccountMap()
    {
        Account acct = createTestAccount();

        Test.startTest();
        Map<String, Account> mp = UTIL_SyncHelper.createAccountMap(new Set<String>{(String) acct.get(UTIL_Account.CustomerFieldName)});
        Test.stopTest();
    }

    @isTest
    public static void testCreateSObject()
    {
        Test.startTest();
        SObject obj = UTIL_SyncHelper.createSObject('Bad Object');
        obj = UTIL_SyncHelper.createSObject('Account');
        Test.stopTest();
    }

    @isTest
    public static void testAddLog()
    {
        Test.startTest();
        UTIL_SyncHelper.addLog(new List<sObject>(), 'Error', 'Test');
        Test.stopTest();
    }

    @isTest
    public static void testPrintJobInfo()
    {
        Test.startTest();
        UTIL_SyncHelper.printJobInfo(new List<String>{'Error', 'Test'});
        Test.stopTest();
    }

    @isTest
    public static void testDebugLogResultMessages()
    {
        Test.startTest();
        ENSX.EnosixFramework.Message message = new ENSX.EnosixFramework.Message(ENSX.EnosixFramework.MessageType.Error, 'Test');
        UTIL_SyncHelper.debugLogResultMessages(new List<ENSX.EnosixFramework.Message> {message});
        Test.stopTest();
    }

    @isTest
    public static void testGetPickListEntriesForFieldAndValueByLabel()
    {
        Test.startTest();
        List<Schema.PicklistEntry> pickListEntries = UTIL_SyncHelper.getPicklistEntriesForField('Account', 'Type');
        String val = UTIL_SyncHelper.getPicklistValueByLabel(pickListEntries, pickListEntries[0].getLabel());
        Test.stopTest();
    }

    @isTest
    public static void testTestSchedulables()
    {
        Test.startTest();
        UTIL_SyncHelper.testSchedulables(new Set<Schedulable> {new MockSchedulable()});
        Test.stopTest();
    }

    public class MockSchedulable implements Schedulable
    {
        public void execute(SchedulableContext sc) {}
    }
}
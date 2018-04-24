@isTest
public class TSTU_TruncateTable_Batch
{
    @isTest public static void test_truncate()
    {
        insert new Account(Name='Test Account');
        Database.executeBatch(new UTIL_TruncateTable_Batch('Account'), 2000);
    }
}
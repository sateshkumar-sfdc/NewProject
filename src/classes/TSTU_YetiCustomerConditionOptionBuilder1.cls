@isTest
public with sharing class TSTU_YetiCustomerConditionOptionBuilder1
{
    @isTest
    public static void test_UTIL_YetiCustomerConditionOptionBuilder1()
    {
        Test.startTest();
        UTIL_YetiCustomerConditionOptionBuilder1 yccob = new UTIL_YetiCustomerConditionOptionBuilder1();
        RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP p = new RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP();
        p.KDKGR = 'Z3';
        Boolean result = yccob.isItemDisplayed(p);
        Test.stopTest();
    }
}
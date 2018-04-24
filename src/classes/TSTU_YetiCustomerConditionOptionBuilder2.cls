@isTest
public with sharing class TSTU_YetiCustomerConditionOptionBuilder2
{
    @isTest
    public static void test_isItemDisplayed()
    {      
        Test.startTest();
        UTIL_YetiCustomerConditionOptionBuilder2 yccob = new UTIL_YetiCustomerConditionOptionBuilder2();
        RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP p = new RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP();
        p.KDKGR = '1';
        Boolean result = yccob.isItemDisplayed(p);
        Test.stopTest();
    }
}
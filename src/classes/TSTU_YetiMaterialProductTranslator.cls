@isTest
public with sharing class TSTU_YetiMaterialProductTranslator
{
    @isTest
    public static void test_YetiMaterialProductTranslator()
    {
        UTIL_YetiMaterialProductTranslator xlator = new UTIL_YetiMaterialProductTranslator();

        Test.startTest();
        String param = 'PRODUCT ATTRIBUTE 1';
        String expected = 'Standard Product';
        System.assert(xlator.translate(param) == expected);
        Test.stopTest();
    }
}
@isTest
public with sharing class TSTU_YetiShipToOptionBuilder
{
    @isTest
    public static void test_getItemValue()
    {
            UTIL_YetiShipToOptionBuilder builder = new UTIL_YetiShipToOptionBuilder();
            SBO_EnosixCustomer_Detail.PARTNERS p = new SBO_EnosixCustomer_Detail.PARTNERS();
            p.PartnerNumber = '1';

            Test.startTest();
            System.assert(builder.getItemValue(p) == '1');
            Test.stopTest();
    }

    @isTest
    public static void test_getItemDescription()
    {
        UTIL_YetiShipToOptionBuilder builder = new UTIL_YetiShipToOptionBuilder();
        SBO_EnosixCustomer_Detail.PARTNERS p = new SBO_EnosixCustomer_Detail.PARTNERS();
        p.PartnerName = 'test';

        Test.startTest();
        System.assert(builder.getItemDescription(p) == 'test');
        Test.stopTest();
    }

    @isTest
    public static void test_getItemLabel()
    {
        UTIL_YetiShipToOptionBuilder builder = new UTIL_YetiShipToOptionBuilder();
        SBO_EnosixCustomer_Detail.PARTNERS p = new SBO_EnosixCustomer_Detail.PARTNERS();
        p.PartnerNumber = '1';
        p.PartnerName = 'test';
        p.Street = '123 Sesame Street';
        p.City = 'nowhere';
        p.Region = 'north america';
        p.PostalCode = '45342';

        String expected = p.PartnerNumber + ' - ';
        expected += p.PartnerName + ' - ';
        expected += p.Street + ' ';
        expected += p.City + ', ';
        expected += p.Region + ' ';
        expected += p.PostalCode;

        Test.startTest();
        System.assert(builder.getItemLabel(p) == expected);
        Test.stopTest();
    }
}
@isTest
public with sharing class TSTU_YetiCustomExceptions
{
    @isTest
    public static void test_RecordTypeMissingException()
    {
        Test.startTest();

        Boolean thrown = false;
        try
        {
            throw new UTIL_YetiCustomExceptions.RecordTypeMissingException();
        }
        catch (UTIL_YetiCustomExceptions.RecordTypeMissingException ex)
        {
            thrown = true;
        }

        System.assert(thrown);
        Test.stopTest();
    }

    @isTest
    public static void test_ShipToAccountMissingException()
    {
        Test.startTest();

        Boolean thrown = false;
        try
        {
            throw new UTIL_YetiCustomExceptions.ShipToAccountMissingException();
        }
        catch (UTIL_YetiCustomExceptions.ShipToAccountMissingException ex)
        {
            thrown = true;
        }

        System.assert(thrown);
        Test.stopTest();
    }

    @isTest
    public static void test_ParentIdShipToMismatchException()
    {
        Test.startTest();

        Boolean thrown = false;
        try
        {
            throw new UTIL_YetiCustomExceptions.ParentIdShipToMismatchException();
        }
        catch (UTIL_YetiCustomExceptions.ParentIdShipToMismatchException ex)
        {
            thrown = true;
        }

        System.assert(thrown);
        Test.stopTest();
    }

    @isTest
    public static void test_YetiMissingOutsideRepUserException()
    {
        Test.startTest();

        Boolean thrown = false;
        try
        {
            throw new UTIL_YetiCustomExceptions.YetiMissingOutsideRepUserException();
        }
        catch (UTIL_YetiCustomExceptions.YetiMissingOutsideRepUserException ex)
        {
            thrown = true;
        }

        System.assert(thrown);
        Test.stopTest();
    }
}
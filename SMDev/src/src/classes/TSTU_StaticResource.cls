/**
 * Created by erikpilgrim on 10/28/16.
 */

@isTest
public with sharing class TSTU_StaticResource
{
    private static String getStringResourceName()
    {
        List<StaticResource> sr = [SELECT Name FROM StaticResource WHERE ContentType = 'application/javascript' LIMIT 1];
        return sr[0].Name;
    }

    @isTest
    public static void test_getResourceUrl()
    {
        String name = getStringResourceName();
        Test.startTest();
        String url = UTIL_StaticResource.getResourceUrl(name);
        Test.stopTest();
    }

    @isTest
    public static void test_getStringResourceContents()
    {
        String name = getStringResourceName();
        Test.startTest();
        String contents = UTIL_StaticResource.getStringResourceContents(name);
        Test.stopTest();
    }
}
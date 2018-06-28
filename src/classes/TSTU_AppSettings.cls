@isTest
public class TSTU_AppSettings
{
    static final string TEST_JSON =
        '{"list1":["FERT","ZERT"],"set1":["A","*"],"bool1":false,' +
        '"dec1":1234.1234,"map1":{"Name":"Test Name"},"bools":[true,false,true],' +
        '"str1":"test string","atype":"Account","ttype":"TSTU_AppSettings.TestType"}';

    public class TestType {}

    @isTest static void test_validJSON()
    {
        Boolean isJsonValid = false;

        Test.startTest();
        try
        {
            String x = (String)UTIL_AppSettings.getValue('x');
            isJsonValid = true;
        }
        catch (Exception ex)
        {
            isJsonValid = false;
        }
        Test.stopTest();

        System.assert(isJsonValid == true, 'Failure parsing EnsxAppSettings JSON resource');
    }

    @isTest static void test_noJSON()
    {
        UTIL_AppSettings.resourceJson = '{}';
        Test.startTest();
        Boolean b1 = (Boolean)UTIL_AppSettings.getValue('bool1', true);
        Boolean b2 = (Boolean)UTIL_AppSettings.getValue('bool2', false);
        Boolean b3 = (Boolean)UTIL_AppSettings.getValue('bool3');
        Test.stopTest();

        System.assert(b1 == true);
        System.assert(b2 == false);
        System.assert(b3 == null);
    }

    @isTest static void test_getValue()
    {
        UTIL_AppSettings.resourceJson = TEST_JSON;

        Test.startTest();
        String s0 = (String)UTIL_AppSettings.getValue('str0');
        String s1 = (String)UTIL_AppSettings.getValue('str1');
        String s2 = (String)UTIL_AppSettings.getValue('str1', 'DEFAULT');
        String s3 = (String)UTIL_AppSettings.getValue('str3', 'DEFAULT');
        Boolean b1 = (Boolean)UTIL_AppSettings.getValue('bool1');
        Decimal d1 = (Decimal)UTIL_AppSettings.getValue('dec1');
        Test.stopTest();

        System.assert(s0 == null);
        System.assert(s1 == 'test string');
        System.assert(s2 == s1);
        System.assert(s3 == 'DEFAULT');
        System.assert(b1 == false);
        System.assert(d1 == 1234.1234);
    }

    @isTest static void test_getList()
    {
        UTIL_AppSettings.resourceJson = TEST_JSON;

        Test.startTest();
        List<String> s1 = (List<String>)UTIL_AppSettings.getList('list1', String.class);
        List<String> s2 = (List<String>)UTIL_AppSettings.getList('list1', String.class, new List<String>());
        List<Boolean> b1 = (List<Boolean>)UTIL_AppSettings.getList('bools', Boolean.class);
        List<String> none = (List<String>)UTIL_AppSettings.getList('listnone', String.class);
        List<String> empty = (List<String>)UTIL_AppSettings.getList('listnone', String.class, new List<String>());
        Test.stopTest();

        System.assert(s1.get(0) == 'FERT');
        System.assert(s1.get(1) == 'ZERT');
        System.assert(s2 == s1);
        System.assert(b1.get(0) == true);
        System.assert(b1.get(1) == false);
        System.assert(b1.get(2) == true);
        System.assert(none == null);
        System.assert(empty.isEmpty());
    }

    @isTest static void test_getSet()
    {
        UTIL_AppSettings.resourceJson = TEST_JSON;

        Test.startTest();
        Set<String> s1 = (Set<String>)UTIL_AppSettings.getSet('set1', String.class);
        Set<String> s2 = (Set<String>)UTIL_AppSettings.getSet('set1', String.class, new Set<String>());
        Set<Boolean> b1 = (Set<Boolean>)UTIL_AppSettings.getSet('bools', Boolean.class);
        Set<String> none = (Set<String>)UTIL_AppSettings.getSet('setnone', String.class);
        Set<String> empty = (Set<String>)UTIL_AppSettings.getSet('setnone', String.class, new Set<String>());
        Test.stopTest();

        System.assert(s1.containsAll(new List<String>{'*', 'A'}));
        System.assert(s2 == s1);
        System.assert(b1.containsAll(new List<Boolean>{true, false}));
        System.assert(none == null);
        System.assert(empty.isEmpty());
    }

    @isTest static void test_getMap()
    {
        UTIL_AppSettings.resourceJson = TEST_JSON;

        Test.startTest();
        Map<String, String> m1 = (Map<String, String>)UTIL_AppSettings.getMap(
            'map1', String.class, String.class);

        Map<String, String> m2 = (Map<String, String>)UTIL_AppSettings.getMap(
            'map1', String.class, String.class, new Map<String, String>());

        Map<String, String> none = (Map<String, String>)UTIL_AppSettings.getMap(
            'mapnone', String.class, String.class);

        Map<String, Boolean> empty = (Map<String, Boolean>)UTIL_AppSettings.getMap(
            'mapnone', String.class, Boolean.class, new Map<String, Boolean>());

        Test.stopTest();

        System.assert(m1.get('Name') == 'Test Name');
        System.assert(m2 == m1);
        System.assert(none == null);
        System.assert(empty.isEmpty());
    }

    @isTest static void test_getSObject()
    {
        UTIL_AppSettings.resourceJson = TEST_JSON;

        Account defaultAccount = new Account();

        Test.startTest();
        Account a1 = (Account)UTIL_AppSettings.getSObject('map1', Account.class);
        Account a2 = (Account)UTIL_AppSettings.getSObject('map1', Account.class, new Account());
        Account none = (Account)UTIL_AppSettings.getSObject('none', Account.class);
        Account def = (Account)UTIL_AppSettings.getSObject('none', Account.class, defaultAccount);
        Test.stopTest();

        System.assert(a1.Name == 'Test Name');
        System.assert(a2 == a1);
        System.assert(none == null);
        System.assert(def == defaultAccount);
    }

    @isTest static void test_getInstance()
    {
        UTIL_AppSettings.resourceJson = TEST_JSON;

        Test.startTest();
        Object aObj = UTIL_AppSettings.getInstance('atype', Object.class);
        Object tObj = UTIL_AppSettings.getInstance('ttype', Object.class);
        Object defaultTObj = UTIL_AppSettings.getInstance('none', TestType.class);
        Test.stopTest();

        System.assert(aObj instanceof Account);
        System.assert(tObj instanceof TestType);
        System.assert(defaultTObj instanceof TestType);
    }
}
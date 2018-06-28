@isTest
public with sharing class TSTU_Object_Lookups
{
    public class MOC_EnosixCustomer_Detail implements ENSX.EnosixFramework.DetailSBOGetMock
    {
        public ENSX.EnosixFramework.DetailObject executeGetDetail(object key)
        {
            SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();
            result.setSuccess(false);
            return result;
        }
    }

    public class MOC_EnosixMaterial_Detail implements ENSX.EnosixFramework.DetailSBOGetMock
    {
        public ENSX.EnosixFramework.DetailObject executeGetDetail(object key)
        {
            SBO_EnosixMaterial_Detail.EnosixMaterial result = new SBO_EnosixMaterial_Detail.EnosixMaterial();
            result.setSuccess(false);
            return result;
        }
    }

    private static Case createTestCase()
    {
        Case testCase = new Case();
        upsert testCase;
        return testCase;
    }

    private static Opportunity createTestOpp()
    {
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = 'test';
        testOpportunity.StageName = 'test';
        testOpportunity.CloseDate = DateTime.Now().Date();

        PriceBook2 testPriceBook = new PriceBook2();
        testPriceBook.Name = 'Test';
        upsert testPriceBook;

        testOpportunity.Pricebook2Id = testPriceBook.Id;
        upsert testOpportunity;
        return testOpportunity;
    }

    @isTest
    public static void test_getCaseById()
    {
        Case testCase = createTestCase();

        Test.startTest();
        Case result = UTIL_Object_Lookups.getCaseById('bad Id');
        result = UTIL_Object_Lookups.getCaseById(testCase.Id);
        Test.stopTest();
    }

    @isTest
    public static void test_getOpportunityById()
    {
        Opportunity testOpportunity = createTestOpp();

        Test.startTest();
        Opportunity opp = UTIL_Object_Lookups.getOpportunityById('bad Id');
        opp = UTIL_Object_Lookups.getOpportunityById(testOpportunity.Id);
        Test.stopTest();
    }

    @isTest
    public static void test_getOpportunityPriceBook()
    {
        Opportunity testOpportunity = createTestOpp();

        Test.startTest();
        PriceBook2 pb = UTIL_Object_Lookups.getOpportunityPriceBook(testOpportunity);

        testOpportunity.Pricebook2Id = testOpportunity.Id;
        pb = UTIL_Object_Lookups.getOpportunityPriceBook(testOpportunity);
        Test.stopTest();
    }

    @isTest
    public static void test_getStandardPricebook()
    {
        Test.startTest();
        PriceBook2 pb = UTIL_Object_Lookups.getStandardPriceBook();
        Test.stopTest();
    }

    @isTest
    public static void test_getProductById()
    {
        Opportunity testOpportunity = createTestOpp();

        Test.startTest();
        Product2 prod = UTIL_Object_Lookups.getProductById(testOpportunity.Id);
        Test.stopTest();
    }

    @isTest
    public static void test_getProductByProductCode()
    {
        Test.startTest();
        Product2 prod = UTIL_Object_Lookups.getProductByProductCode('');
        Test.stopTest();
    }

    @isTest
    public static void test_getProductByMaterialField()
    {
        Test.startTest();
        Product2 prod = UTIL_Object_Lookups.getProductByMaterialField('');
        Test.stopTest();
    }

    @isTest
    public static void test_getAccountById()
    {
        Opportunity testOpportunity = createTestOpp();

        Test.startTest();
        Account acct = UTIL_Object_Lookups.getAccountById(testOpportunity.Id);
        Test.stopTest();
    }

    @isTest
    public static void test_getAccountByCustomerId()
    {
        Opportunity testOpportunity = createTestOpp();

        Test.startTest();
        Account acct = UTIL_Object_Lookups.getAccountByCustomerId(testOpportunity.Id);
        Test.stopTest();
    }

    @isTest
    public static void test_getCustomerForCase()
    {
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Detail.class, new MOC_EnosixCustomer_Detail());

        Account testAccount = new Account();
        testAccount.Name = 'test';
        upsert testAccount;

        Case testCase = createTestCase();
        testCase.AccountId = testAccount.Id;

        Test.startTest();
        SBO_EnosixCustomer_Detail.EnosixCustomer cust = UTIL_Object_Lookups.GetCustomerForCase(testCase);

        testAccount.put(UTIL_Account.CustomerFieldName,'test');
        upsert testAccount;
        cust = UTIL_Object_Lookups.GetCustomerForCase(testCase);
        Test.stopTest();
    }

    @isTest
    public static void test_getMaterialFromMaterialNumber()
    {
        ENSX.EnosixFramework.setMock(SBO_EnosixMaterial_Detail.class, new MOC_EnosixMaterial_Detail());

        Test.startTest();
        SBO_EnosixMaterial_Detail.EnosixMaterial mat = UTIL_Object_Lookups.getMaterialFromMaterialNumber('');
        Test.stopTest();
    }
}
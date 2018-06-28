@isTest
public with sharing class TSTU_YetiCustomEvents
{
    //TODO
    //Get the code coderage up for all the methods
    @isTest
    public static void test_YetiCustomerInitEventHandler()
    {
        Test.startTest();
        UTIL_YetiCustomerInitEventHandler evt = new UTIL_YetiCustomerInitEventHandler();
        String evtName = 'UTIL_YetiCustomerInitEventHandler';
        UTIL_Event.registerEventHandler(evtName, evt);

        SBO_EnosixCustomer_Detail.EnosixCustomer cust = new SBO_EnosixCustomer_Detail.EnosixCustomer();

        Account testAcct = new Account();
        testAcct.Name = 'test_test';
        // TODO we should execute the event twice, but the second one should
        // have the RecordTypeId set on the account.
        upsert testAcct;

        Map<String, object> params = new Map<String, object>();
        params.put('SBO_EnosixCustomer_Detail.EnosixCustomer', cust);
        params.put('Account', testAcct);

        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(evtName, params);
        Test.stopTest();
    }

    @isTest
    public static void test_YetiCustomerTouchedEventHandler()
    {
        Test.startTest();
        UTIL_YetiCustomerTouchedEventHandler evt = new UTIL_YetiCustomerTouchedEventHandler();
        String evtName = 'UTIL_YetiCustomerTouchedEventHandler';
        UTIL_Event.registerEventHandler(evtName, evt);

        SBO_EnosixCustomer_Detail.EnosixCustomer cust = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        cust.CustomerNumber = 'Fake';

        Account testAcct = new Account();
        testAcct.Name = 'test_test';
        testAcct.put('ENSX_EDM__SAP_Customer_Number__c', cust.CustomerNumber);
        testAcct.put('Inside_Sales_Rep__c', '0');

        Map<String, object> params = new Map<String, object>();
        params.put('EventName', UTIL_Event.CUSTOMER_INITIALIZING);
        params.put('SBO_EnosixCustomer_Detail.EnosixCustomer', cust);

        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(evtName, params);
        Test.stopTest();
    }

    @isTest
    public static void test_YetiOpportunityQuotePricingInitializedEventHandler()
    {
        Test.startTest();
        UTIL_YetiOppQuotePriceInitEvtHandler evt = new UTIL_YetiOppQuotePriceInitEvtHandler();
        String evtName = 'UTIL_YetiOppQuotePriceInitEvtHandler';
        UTIL_Event.registerEventHandler(evtName, evt);

        SBO_EnosixQuote_Detail.EnosixQuote quote = new SBO_EnosixQuote_Detail.EnosixQuote();
        SBO_EnosixQuote_Detail.PARTNERS part = new SBO_EnosixQuote_Detail.PARTNERS();
        part.PartnerFunction = UTIL_Order.SHIP_TO_PARTNER_CODE;
        quote.PARTNERS.add(part);

        Account testShip = new Account();
        testShip.Name = 'test_ship';
        testShip.put('ENSX_EDM__SAP_Customer_Number__c', '100');
        upsert testShip;

        Opportunity opp = new Opportunity();
        opp.Name = 'test_test';
        opp.AccountId = testShip.Id;
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        upsert opp;

        Map<String, object> params = new Map<String, object>();
        params.put('SBO_EnosixQuote_Detail.EnosixQuote', quote);
        params.put('Opportunity', opp);

        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(evtName, params);
        Test.stopTest();
    }

    @isTest
    public static void test_YetiOpportunityQuotePricingUpdatedEventHandler()
    {
        Test.startTest();
        UTIL_YetiOppQuotePriceUpdatedEvtHandler evt = new UTIL_YetiOppQuotePriceUpdatedEvtHandler();
        String evtName = 'UTIL_YetiOppQuotePriceUpdatedEvtHandler';
        UTIL_Event.registerEventHandler(evtName, evt);

        SBO_EnosixQuote_Detail.EnosixQuote quote = new SBO_EnosixQuote_Detail.EnosixQuote();
        SBO_EnosixQuote_Detail.PARTNERS part = new SBO_EnosixQuote_Detail.PARTNERS();
        part.PartnerFunction = UTIL_Order.SHIP_TO_PARTNER_CODE;
        quote.PARTNERS.add(part);

        Account testShip = new Account();
        testShip.Name = 'test_ship';
        testShip.put('ENSX_EDM__SAP_Customer_Number__c', '100');
        upsert testShip;

        Opportunity opp = new Opportunity();
        opp.Name = 'test_test';
        opp.AccountId = testShip.Id;
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        upsert opp;

        Map<String, object> params = new Map<String, object>();
        params.put('SBO_EnosixQuote_Detail.EnosixQuote', quote);
        params.put('Opportunity', opp);

        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(evtName, params);
        Test.stopTest();
    }

    @isTest
    public static void test_YetiOrderInitializedEventHandler()
    {
        Test.startTest();
        UTIL_YetiOrderInitializedEventHandler evt = new UTIL_YetiOrderInitializedEventHandler();
        String evtName = 'UTIL_YetiOrderInitializedEventHandler';
        UTIL_Event.registerEventHandler(evtName, evt);

        SBO_EnosixSO_Detail.EnosixSO so = new SBO_EnosixSO_Detail.EnosixSO();
        SBO_EnosixQuote_Detail.PARTNERS part = new SBO_EnosixQuote_Detail.PARTNERS();
        part.PartnerFunction = UTIL_Order.SHIP_TO_PARTNER_CODE;
        so.PARTNERS.add(part);

        Account testShip = new Account();
        testShip.Name = 'test_ship';
        testShip.put('ENSX_EDM__SAP_Customer_Number__c', '100');
        upsert testShip;

        Opportunity opp = new Opportunity();
        opp.Name = 'test_test';
        opp.AccountId = testShip.Id;
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        opp.put('Need_By_Date__c', Date.today());
        opp.put('PO_Number__c', '100');
        upsert opp;

        Map<String, object> params = new Map<String, object>();
        params.put('SBO_EnosixSO_Detail.EnosixSO', so);
        params.put('Opportunity', opp);

        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(evtName, params);
        Test.stopTest();
    }

    @isTest
    public static void test_YetiPartnerAddedEventHandler()
    {
        Test.startTest();
        UTIL_YetiPartnerAddedEventHandler evt = new UTIL_YetiPartnerAddedEventHandler();
        String evtName = 'UTIL_YetiPartnerAddedEventHandler';
        UTIL_Event.registerEventHandler(evtName, evt);

        SBO_EnosixCustomer_Detail.EnosixCustomer cust = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        cust.Name = 'Joe Schmo';
        cust.City = 'Nowhere';
        cust.Region = 'North America';
        cust.Street = '123 Sesame St.';
        cust.CustomerNumber = '100';
        cust.TelephoneNumber = '937-551-5555';
        cust.PostalCode = '45342';

        Account testAcct = new Account();
        testAcct.Name = 'test_acct';
        upsert testAcct;

        Map<String, object> params = new Map<String, object>();
        params.put('SBO_EnosixCustomer_Detail.EnosixCustomer', cust);
        params.put('Account', testAcct);

        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(evtName, params);
        Test.stopTest();
    }

    @isTest
    public static void test_YetiQuoteInitializedEventHandler()
    {
        Test.startTest();
        UTIL_YetiQuoteInitializedEventHandler evt = new UTIL_YetiQuoteInitializedEventHandler();
        String evtName = 'UTIL_YetiQuoteInitializedEventHandler';
        UTIL_Event.registerEventHandler(evtName, evt);

        SBO_EnosixQuote_Detail.EnosixQuote quote = new SBO_EnosixQuote_Detail.EnosixQuote();
        SBO_EnosixQuote_Detail.PARTNERS part = new SBO_EnosixQuote_Detail.PARTNERS();
        part.PartnerFunction = UTIL_Order.SHIP_TO_PARTNER_CODE;
        quote.PARTNERS.add(part);

        Account testShip = new Account();
        testShip.Name = 'test_ship';
        testShip.put('ENSX_EDM__SAP_Customer_Number__c', '100');
        upsert testShip;

        Opportunity opp = new Opportunity();
        opp.Name = 'test_test';
        opp.AccountId = testShip.Id;
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        opp.put('Need_By_Date__c', Date.today());
        opp.put('PO_Number__c', '100');
        upsert opp;

        Map<String, object> params = new Map<String, object>();
        params.put('SBO_EnosixQuote_Detail.EnosixQuote', quote);
        params.put('Opportunity', opp);

        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(evtName, params);
        Test.stopTest();
    }
}
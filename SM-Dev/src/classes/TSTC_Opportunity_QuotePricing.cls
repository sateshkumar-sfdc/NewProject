@isTest
public with sharing class TSTC_Opportunity_QuotePricing {
    @isTest
    static void test_CreateControllerAndTouchProperties() {
        Test.startTest();
        CTRL_Opportunity_QuotePricing controller = new CTRL_Opportunity_QuotePricing();
        Opportunity opp = controller.opp;
        CB_MaterialSearchReceiver receiver = controller.receiver;
        Double netOpportunityPrice = controller.netOpportunityPrice;
        SBO_EnosixCustomer_Detail.EnosixCustomer customer = controller.selectedSAPCustomer;
        Test.stopTest();
        System.assertNotEquals(controller, null);
    }
    @isTest
    static void test_ValidateOpp() {
        Test.startTest();
        CTRL_Opportunity_QuotePricing controller = new CTRL_Opportunity_QuotePricing();
        controller.opp.Name = 'TEST OPP';
        controller.opp.CloseDate = Date.today().addDays(31);
        SBO_EnosixQuote_Detail.ITEMS itm = new SBO_EnosixQuote_Detail.ITEMS();
        itm.OrderQuantity = 123;
        itm.ItemNumber = '123';
        itm.Material = 'test';
        UTIL_Order.QuoteItem quoteItem =
            new UTIL_Order.QuoteItem(itm, new List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE>());
        controller.displayedMaterialItems.add(quoteItem);
        controller.ValidateOpportunity();
        Test.stopTest();
    }
    @isTest
    static void test_CreateOpportiyLineItemFromMaterialSearchPriceEstimate() {
        Test.startTest();
        CTRL_Opportunity_QuotePricing controller = new CTRL_Opportunity_QuotePricing();
        controller.opp.Name = 'TEST OPP';
        controller.opp.CloseDate = Date.today().addDays(31);
        controller.opp.StageName ='Closed';
        upsert controller.opp;
        SBO_EnosixQuote_Detail.ITEMS itm = new SBO_EnosixQuote_Detail.ITEMS();
        itm.OrderQuantity = 123;
        itm.ItemNumber = '123';
        itm.ItemDescription = 'TEST DESC';
        itm.Material = 'test';
        String currencyIsoCode = 'USD';
        Product2 prod2 = CTRL_Opportunity_QuotePricing.createProductFromItem(itm);
        String pbID = Test.getStandardPricebookId();

        Pricebook2 pb = new Pricebook2();
        pb.Name = 'testPB';
        pb.Description = 'asdf';
        pb.Id = pbId;
        PricebookEntry pbe = CTRL_Opportunity_QuotePricing.createEntryForProduct(pb, prod2.Id, currencyIsoCode);

        controller.CreateOpportiyLineItemFromMaterialSearchPriceEstimate(itm, pbe);
        Test.stopTest();
    }
    @isTest
    static void test_AddAndRemoveItemToQuote() {
        Test.startTest();
        CTRL_Opportunity_QuotePricing controller = new CTRL_Opportunity_QuotePricing();
        controller.opp.Name = 'TEST OPP';
        controller.opp.CloseDate = Date.today().addDays(31);
        SBO_EnosixQuote_Detail.ITEMS itm = new SBO_EnosixQuote_Detail.ITEMS();
        itm.OrderQuantity = 123;
        itm.ItemNumber = '123';
        itm.Material = 'test';

        controller.quoteDetail.ITEMS.add(itm);
//        controller.addItemToOrder(itm);
        system.assert(controller.displayedMaterialItems.size() > 0);
//        SBO_EnosixQuote_Detail.ITEMS fetchItm = controller.displayedMaterialItems.get(0);
//        CTRL_Opportunity_QuotePricing.getNextItemNumber(controller.quoteDetail, 10);
        CTRL_Opportunity_QuotePricing.removeItemfromQuoteWithItemNumber(controller.quoteDetail, '123');
        Test.stopTest();
    }

}
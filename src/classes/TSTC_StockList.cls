/**
 * Created by erikpilgrim on 10/10/16.
 */

@IsTest
private class TSTC_StockList {
    static testMethod void testConstruction() {
        System.Test.startTest();
        CTRL_StockList stockList = new CTRL_StockList();
        string plantName = stockList.PlantName;
        string oppId = stockList.OpportunityId;
        string matSearch = stockList.Material;
        stockList.dl = new SBO_EnosixStockList_Search();

        System.Test.stopTest();
    }

    static testMethod void testBackInventory() {
        System.Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.VFP_StockList'));
        CTRL_StockList stockList = new CTRL_StockList();
        stockList.OpportunityId = 'testOpportunity';
        stockList.Material = 'testMaterial';
        stockList.backInventory();
        System.Test.stopTest();
    }

    static testMethod void testUpdatePaginatedResult() {
        System.Test.startTest();
        CTRL_StockList stockList = new CTRL_StockList();

        stockList.updatePaginatedResult();
        System.Test.stopTest();
    }
}
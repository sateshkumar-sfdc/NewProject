@IsTest
private class TSTC_InventoryList {
    static testMethod void testConstruction() {
        System.Test.startTest();
        CTRL_InventoryList inventoryList = new CTRL_InventoryList();
        inventoryList.ews = new SBO_EnosixWarehouseStock_Search();
        string plantName = inventoryList.PlantName;
        Opportunity oppInst = inventoryList.Opportunity;
        string oppProdId = inventoryList.OpportunityProductId;
        string matSearch = inventoryList.MaterialSearchQuery;
        string matSearchParam = inventoryList.MaterialSearchParam;
        List<SelectOption> selectOpts  = inventoryList.plants;
        System.Test.stopTest();

    }

    static testMethod void testGoToStockListPage() {
        System.Test.startTest();
        CTRL_InventoryList inventoryList = new CTRL_InventoryList();
        Test.setCurrentPageReference(new PageReference('Page.VFP_InventoryList'));
        System.currentPageReference().getParameters().put('material', 'testMaterialId');
        System.currentPageReference().getParameters().put('plant', 'testPlantId');
        inventoryList.goToStockListPage();
        System.Test.stopTest();
    }

    static testMethod void testBackOpportunity() {
        System.Test.startTest();
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'testName';
        opportunity.StageName = 'asdf';
        opportunity.CloseDate = Date.today();
        upsert opportunity;
        Test.setCurrentPageReference(new PageReference('Page.VFP_InventoryList'));
        CTRL_InventoryList inventoryList = new CTRL_InventoryList();
        inventoryList.Opportunity = opportunity;
        inventoryList.backOpportunity();
        System.Test.stopTest();
    }

    static testMethod void testbackMaterial() {
        System.Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.VFP_InventoryList'));
        CTRL_InventoryList inventoryList = new CTRL_InventoryList();
        inventoryList.OpportunityProductId = 'testOpportunityProductId';
        inventoryList.backMaterial();
        System.Test.stopTest();
    }
    static testMethod void testUpdatePaginatedResult() {
        System.Test.startTest();
        CTRL_InventoryList inventoryList = new CTRL_InventoryList();

        inventoryList.updatePaginatedResult();
        System.Test.stopTest();
    }
}
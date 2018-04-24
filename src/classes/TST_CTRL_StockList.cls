/**
 * test class for CTRL_StockList Controllers
 */
@isTest
private class TST_CTRL_StockList {

    @isTest static void myUnitTest() {
    	System.currentPageReference().getParameters().put('materialId','1000');
        CTRL_StockList cont = new CTRL_StockList();
        cont.PlantName = 'plant';
        cont.Material= '1000';
        cont.searchSL();
        cont.backInventory();
        cont.updatePaginatedResult();
        
    }
}
/**
 * test class for CTRL_InventoryList Controllers
 */
@isTest
public class TST_CTRL_InventoryList {

    @isTest static void myUnitTest() {
    	Account testAcct = new account(Name = 'test');
    	insert testAcct;

    	Opportunity test = new Opportunity( Name = 'Test Usage',
                              AccountId = testAcct.Id,
                              StageName = 'New',
                              CloseDate = System.today(),
                              Type = 'New Business - Add',
                              Amount = 555888555);

  		insert  test;
    	System.currentPageReference().getParameters().put('materialId','1000');
        CTRL_InventoryList cont = new CTRL_InventoryList();
        cont.PlantName = '';
        cont.MaterialSearchQuery= '1000';
        cont.searchEWS();
        cont.updatePaginatedResult();

        System.currentPageReference().getParameters().put('opportunityid',test.id);
        cont.backOpportunity();

    }
}
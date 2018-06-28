@isTest(seealldata=true)
public class YETI_OrderOnceController_Test{
  @isTest static void UNITTest() {      
      
      Account Acc  = new Account(Name = 'test');
      insert Acc;
      
      //Intialization
      OrderOnceController.wOrderOnce  wobj = OrderOnceController.Intialization();
      System.assertNotEquals(wobj,null);
      
      //searchOrderOnce
      wobj.strShipTo = 'TEST';
      OrderOnceController.wOrderOnce  sobj = OrderOnceController.searchOrderOnce(JSON.serialize(wobj));
      //System.assertEquals(wobj,null);      
      
      //getShipToAccount
      List<OrderOnceController.wSearchAccount> lstSearchedAccount = OrderOnceController.getShipToAccount(JSON.serialize(sobj));
      //System.assertEquals(wobj,null);  
      
      //getFilteredProducts
      OrderOnceController.wOrderOnce  fobj = OrderOnceController.getFilteredProducts(JSON.serialize(sobj),'test','');
      //System.assertEquals(wobj,null);
      
      //getNewOpportunity
      OrderOnceController.wOrderOnce  nobj = OrderOnceController.getNewOpportunity(JSON.serialize(sobj));
      System.assertNotEquals(nobj.oppObj ,null); 
      nobj.oppObj.closeDate = system.today();
      nobj.oppObj.Name = 'Test';
      
      //saveOrderOnce
      OrderOnceController.wOrderOnce  updateobj = OrderOnceController.saveOrderOnce(JSON.serialize(nobj));
      //System.assertNotEquals(nobj.oppObj ,null); 
      
      string pbid;
      for(OrderOnceController.wLineItem w : updateobj.lstAvaiLine){
            pbid = w.pbeid;break;            
      }
      //removeShipToItem
      OrderOnceController.wOrderOnce  removeobj = OrderOnceController.removeShipToItem(JSON.serialize(nobj),pbid);
      
      //saveOpportunity
      OrderOnceController.wOrderOnce  saveobj = OrderOnceController.saveOpportunity(JSON.serialize(nobj),'Submit');
      
      
  }
}
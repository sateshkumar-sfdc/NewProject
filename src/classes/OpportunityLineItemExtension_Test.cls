@isTest(seeAllData=true)
public class OpportunityLineItemExtension_Test{
  @isTest static void UNITTest() {      
      
      Account Acc  = new Account(Name = 'test');
      insert Acc;
      
      Opportunity opp = new Opportunity(Name='Test Opp',AccountId = Acc.Id, CloseDate = system.today(), StageName = 'Prospecting');
      insert opp;
     
      //getAllOpportunity
      List<Opportunity> lstopp = OpportunityLineItemExtension.getAllOpportunity();
      //System.assertEquals(wobj,null);      
      
      //getNewOpportunity
      OpportunityLineItemExtension.wNewOpportunity  nobj = OpportunityLineItemExtension.getNewOpportunity();
      //System.assertEquals(wobj,null);  
      
      //getOpportunityLineItems
      OpportunityLineItemExtension.wOpportunity  wobj = OpportunityLineItemExtension.getOpportunityLineItems(opp.id);
    
      
      //getFilteredProducts
      OpportunityLineItemExtension.wOpportunity  searchObj = OpportunityLineItemExtension.getFilteredProducts(JSON.serialize(wobj),'test','');
      
      
      string PriceBookEntryId;
      for(OpportunityLineItemExtension.wOpportunityLine w : searchObj.lstAvaiLine){
            PriceBookEntryId = w.PriceBookEntryId;break;            
      }
      
      //getRefreshOpportunityLineItems
      OpportunityLineItemExtension.wOpportunity  refreshobj = OpportunityLineItemExtension.getRefreshOpportunityLineItems(JSON.serialize(wobj),PriceBookEntryId );
      
      
      
      
      //saveOpportunity
      string result = OpportunityLineItemExtension.saveOpportunity(JSON.serialize(refreshobj));
      
      //saveProducts
      OpportunityLineItemExtension.saveProducts(JSON.serialize(refreshobj),'Save');
      
      //getRemoveOpportunityLineItems
      OpportunityLineItemExtension.wOpportunity  removeobj = OpportunityLineItemExtension.getRemoveOpportunityLineItems(JSON.serialize(wobj),PriceBookEntryId);
      
      
      
      
  }
}
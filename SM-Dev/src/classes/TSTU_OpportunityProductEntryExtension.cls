@isTest
public class TSTU_OpportunityProductEntryExtension{
    public static testMethod void UNITTest() {      

        Account Acc  = new Account(Name = 'test');
        insert Acc;

        Pricebook2 Cpricebook = new Pricebook2(Name='Corporate');
        insert Cpricebook;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId = Acc.Id, CloseDate = system.today(), StageName = 'Prospecting',pricebook2Id = Cpricebook.id);
        insert opp;
        
        Product2 newProd = new Product2(Name = 'test product', family = 'test family');
        insert newProd;
    
        PriceBookEntry s_pbEntry = new PriceBookEntry(
        UnitPrice = 300,
        PriceBook2Id = Test.getStandardPricebookId(),
        Product2Id = newProd.Id,
        IsActive = true);
        insert s_pbEntry ;
        
        PriceBookEntry pbEntry = new PriceBookEntry(
        UnitPrice = 300,
        PriceBook2Id = Cpricebook.Id,
        Product2Id = newProd.Id,
        IsActive = true);
        insert pbEntry ;

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Discount_Percent__c = '5';
        oli.Quantity = 10;
        oli.UnitPrice = 95;
        oli.Description = 'test Desciption';
        oli.PricebookEntryId = pbEntry.Id;
        insert oli;
        
        
        PageReference pageRef = Page.opportunityProductEntry;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(opp.Id));
        ApexPages.currentPage().getParameters().put('productId', String.valueOf(pbEntry.Id));
        ApexPages.currentPage().getParameters().put('colorId', '1');
        ApexPages.currentPage().getParameters().put('colorVal', 'true');
            
        
        ApexPages.StandardController scon = new ApexPages.StandardController(opp);
        opportunityProductEntryExtension cont = new opportunityProductEntryExtension(scon);
        cont.toCalc = pbEntry.Id;
        cont.toUnselect = pbEntry.Id; 
        
        opportunityProductEntryExtension.PBEWrap w = new opportunityProductEntryExtension.PBEWrap(pbEntry,null);
        cont.oncolorChangeAction();
        
        cont.addToShoppingCart();
        cont.onSave();
        
        cont.priceBookCheck();
        cont.getChosenCurrency();
        cont.changePricebook();
        cont.calcTotalPrice();
        cont.getGrandTotal();
        cont.getProductCategoryOptions();
        cont.removeFromShoppingCart();
        cont.onCancel();
        
        PreQuotePricingController pcont = new PreQuotePricingController(scon );
        pcont.ActionOnLoad();

        
    }
}
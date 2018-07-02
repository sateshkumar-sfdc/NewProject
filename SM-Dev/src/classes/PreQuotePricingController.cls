public class PreQuotePricingController{

    public PreQuotePricingController(ApexPages.StandardController controller) {

    }

    
    public pagereference ActionOnLoad(){
        string oppId = apexpages.currentpage().getparameters().get('id');
        string url = '/apex/VFP_Opportunity_QuotePricing?SF_OppId='+oppId;
        string Pricebooks = label.SystemPricebook;
        
        if(Pricebooks <> null){
            set<string> setPriceBookNames = new set<string>();
            for(string s : Pricebooks.split(';')){
                setPriceBookNames.add(s);
            }
            List<Opportunity> lstOpp = [select Id,Pricebook2.Name from Opportunity where Id =: oppId and Pricebook2.Name IN: setPriceBookNames];
            if(lstOpp.size()>0)url = '/apex/opportunityProductEntry?id='+oppId;
        }
    
        system.debug('PATH:'+url);
        pagereference pg = new pagereference(url);
        pg.setredirect(true);
        return pg;
        
    }
}
public with sharing class opportunityProductRedirectExtension {

    Id oppId;

    // we are extending the OpportunityLineItem controller, so we query to get the parent OpportunityId
    public opportunityProductRedirectExtension(ApexPages.StandardController controller) {
        oppId = [select Id, OpportunityId from OpportunityLineItem where Id = :controller.getRecord().Id limit 1].OpportunityId;
    }
    
    // then we redirect to our desired page with the Opportunity Id in the URL
    public pageReference redirect(){
        return new PageReference('/apex/opportunityProductEntry?id=' + oppId);
    }

}
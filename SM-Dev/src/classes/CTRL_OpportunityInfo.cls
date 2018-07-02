public with sharing class CTRL_OpportunityInfo {
    public Opportunity sfOpportunity { get; set; }
    public Account sfAccount { get; set; }

    public string sfOpportunityId {
        get {
            return this.sfOpportunity.Id;
        }
        set {
            this.sfOpportunity = UTIL_Object_Lookups.getOpportunityById(value);
        }
    }

    public string sfAccountId {
        get {
            return this.sfAccount.Id;
        }
        set {
            this.sfAccount = UTIL_Object_Lookups.getAccountById( value );
        }
    }

    public PageReference redirectToQuoteDetail() {
        UTIL_PageState.current.quoteId = sfOpportunity.ENSX_EDM__Quote_Number__c;
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_Quote_Detail, UTIL_PageState.current);
    }
}
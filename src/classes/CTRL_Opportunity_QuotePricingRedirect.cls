public with sharing class CTRL_Opportunity_QuotePricingRedirect
{
    string oppId { get; set; }

    public CTRL_Opportunity_QuotePricingRedirect(ApexPages.StandardController controller) {
        // NOTE: Since this maybe should use UTIL_PageState, but it's kinda weird,
        // so I'm leaving it for now
        Map<String, String> params = System.currentPageReference().getParameters();
        if (params.containsKey('addTo')) {
            this.oppId = params.get('addTo');

        } else {
            string ret = params.get('retURL');
            this.oppId = ret.replace('/','');
        }
    }

    public PageReference RedirectToCustomOpportunityPage() {
        UTIL_PageState.current.opportunityId = this.oppId;
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_Opportunity_QuotePricing, UTIL_PageState.current);
    }
}
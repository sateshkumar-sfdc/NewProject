public with sharing class CTRL_CaseInfo {
    public Case sfCase { get; set; }

    public string sfCaseId {
        get {
            return this.sfCase.id;
        }
        set {
            this.sfCase = UTIL_Object_Lookups.getCaseById(value);
        }
    }

    public PageReference redirectToOrderDetail() {
        UTIL_PageState.current.rmaId = sfCase.ENSX_EDM__Return_Order_Number__c;
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_Return_Order_Detail, UTIL_PageState.current);
    }
}
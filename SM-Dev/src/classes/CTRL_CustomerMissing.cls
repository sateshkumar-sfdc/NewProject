// Widget to show the "Click here to create a customer" box
public with sharing class CTRL_CustomerMissing
{
    public String accountId { get; private set; }

    public CTRL_CustomerMissing()
    {
        this.accountId = UTIL_PageState.current.lookupAccountId();
    }

    public PageReference actionCreateCustomer()
    {
        UTIL_PageState.current.accountId = this.accountId;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_CustomerCreate, UTIL_PageState.current);
    }

    public PageReference actionLinkCustomer()
    {
        UTIL_PageState.current.accountId = this.accountId;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_Customer_Link, UTIL_PageState.current);
    }
}
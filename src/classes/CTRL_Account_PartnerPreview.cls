public with sharing class CTRL_Account_PartnerPreview extends CTRL_CustomerDetail
{
    public CTRL_Account_PartnerPreview(ApexPages.StandardController controller)
    {
        if (null != controller)
        {
            this.a = UTIL_Object_Lookups.getAccountById(((Account)controller.getRecord()).ID);
            String customerid = UTIL_Account.getCustomerNumberFromAccount(a);
            system.debug('customerid: ' + customerid);
            if (string.isNotEmpty(customerid))
            {
                this.cDetail = UTIL_Customer.fetchEnosixCustomer(customerId);
            }
        }
    }

    public String PartnerPreviewTitle
    {
        get
        {
            return (String)UTIL_AppSettings.getValue('Account.PartnerPreviewTitle', 'SAP Partners');
        }
    }

    public List<SBO_EnosixCustomer_Detail.PARTNERS> PartnerPreviewList
    {
        get
        {
            List<SBO_EnosixCustomer_Detail.PARTNERS> result = new List<SBO_EnosixCustomer_Detail.PARTNERS>();

            if (null != this.cDetail)
            {
                List<SBO_EnosixCustomer_Detail.PARTNERS> allPartners = new List<SBO_EnosixCustomer_Detail.PARTNERS>();
                this.cDetail.PARTNERS.copyTo(allPartners);

                // default filters is null
                Set<String> partnerFunctionsToInclude = (Set<String>)UTIL_AppSettings.getSet(
                    'Account.PartnerPreviewFunctionFilter', String.class);

                for (SBO_EnosixCustomer_Detail.PARTNERS p : allPartners)
                {
                    if (null == partnerFunctionsToInclude || partnerFunctionsToInclude.contains(p.PartnerFunction))
                    {
                        result.add(p);
                    }
                }
            }

            return result;
        }
    }
}
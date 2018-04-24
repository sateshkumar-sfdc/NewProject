public with sharing class UTIL_Customer
{
    public static Set<string> allowedClientTypes
    {
        get
        {
            return (Set<String>)UTIL_AppSettings.getSet(
                'Customer.AllowedClientTypes', String.class, new Set<String>{'*'});
        }
    }

    public static SBO_EnosixCustomer_Detail.EnosixCustomer fetchEnosixCustomer(String id)
    {
        SBO_EnosixCustomer_Detail sbo = new SBO_EnosixCustomer_Detail();
        SBO_EnosixCustomer_Detail.EnosixCustomer result = sbo.getDetail(id);

        if (!result.isSuccess())
        {
        	ENSX.EnosixFramework.displayResultMessages(
                result, ENSX.EnosixFramework.MessageType.INFO);
        }

        return result;
    }

    // Helper method to save customer record. Returns updated customer if successful,
    // otherwise displays errors and returns null
    public static SBO_EnosixCustomer_Detail.EnosixCustomer saveCustomer(
        SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        SBO_EnosixCustomer_Detail sbo = new SBO_EnosixCustomer_Detail();
        SBO_EnosixCustomer_Detail.EnosixCustomer result = null;

        try
        {
            result = sbo.save(customer);
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }

        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(
                result, ENSX.EnosixFramework.MessageType.INFO);
            return null;
        }

        return result;
    }

    public static PageReference redirectToEditCustomer()
    {
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_Customer_Edit, UTIL_PageState.current);
    }

    public static PageReference redirectToDisplayCustomer()
    {
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_CustomerDetail, UTIL_PageState.current);
    }

    public static PageReference redirectToCreateCustomer()
    {
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_CustomerCreate, UTIL_PageState.current);
    }
}
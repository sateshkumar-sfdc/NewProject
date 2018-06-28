// This class is a helper class to make it easier to navigate between pages
public class UTIL_PageFlow
{
    public static final String VFP_CreditCardEntry_Test = '/apex/VFP_CreditCardEntry_Test';
    public static final String VFP_CustomerCreate = '/apex/VFP_CustomerCreate';
    public static final String VFP_CustomerDetail = '/apex/VFP_CustomerDetail';
    public static final String VFP_CustomerPayment_Entry = '/apex/VFP_CustomerPayment_Entry';
    public static final String VFP_Customer_Edit = '/apex/VFP_Customer_Edit';
    public static final String VFP_Customer_Link = '/apex/VFP_Customer_Link';
    public static final String VFP_DeliveryDetail = '/apex/VFP_DeliveryDetail';
    public static final String VFP_DeliveryList = '/apex/VFP_DeliveryList';
    public static final String VFP_DocFlow_Search = '/apex/VFP_DocFlow_Search';
    public static final String VFP_EnosixMaterial_Detail = '/apex/VFP_EnosixMaterial_Detail';
    public static final String VFP_InventoryList = '/apex/VFP_InventoryList';
    public static final String VFP_Invoice_Detail = '/apex/VFP_Invoice_Detail';
    public static final String VFP_Invoice_Search = '/apex/VFP_Invoice_Search';
    public static final String VFP_MaterialSearch_Test = '/apex/VFP_MaterialSearch_Test';
    public static final String VFP_OppProd_QuotePricing_Redirect = '/apex/VFP_OppProd_QuotePricing_Redirect';
    public static final String VFP_Opportunity_QuotePricing = '/apex/VFP_Opportunity_QuotePricing';
    public static final String VFP_Opportunity_QuotePricing_Redirect = '/apex/VFP_Opportunity_QuotePricing_Redirect';
    public static final String VFP_OrderCreate = '/apex/VFP_OrderCreate';
    public static final String VFP_OrderDetail = '/apex/VFP_OrderDetail';
    public static final String VFP_OrderList = '/apex/VFP_OrderList';
    public static final String VFP_Quote_Detail = '/apex/VFP_Quote_Detail';
    public static final String VFP_Return_Order_Create = '/apex/VFP_Return_Order_Create';
    public static final String VFP_Return_Order_Detail = '/apex/VFP_Return_Order_Detail';
    public static final String VFP_Return_Order_Search = '/apex/VFP_Return_Order_Search';
    public static final String VFP_StockList = '/apex/VFP_StockList';

    // redirectTo()
    //
    // Return a fully configured PageReference to simplify navigation
    // to another page while maintaining page state properties
    // If pageName is null, return null which simplifies caller logic in some cases
    public static PageReference redirectTo(String pageName, UTIL_PageState state)
    {
        PageReference result = null;

        if (null == pageName)
            return null;

        if (UTIL_PageFlow.isPageAvailable(pageName))
        {
            result = new PageReference(pageName);
            result.setRedirect(true);
            if (null != state)
            {
                result.getParameters().putAll(state.getPageParams());
            }
        }
        else
        {
            String errorMessage = 'Page "' + pageName + '" is not available. Navigation failed';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
        }

        return result;
    }

    // returnToSavedPageOrDefault()
    //
    // Constructs PageRefrence to return to the previous state as stored in the
    // page state. If one isn't stored, go to the defaultPageName using the
    // params from state.
    // If no return state is stored, and defaultPageName is null, returns null
    public static PageReference returnToSavedPageOrDefault(
        UTIL_PageState state, String defaultPageName)
    {
        if (null != state && null != state.returnToUrl)
        {
            PageReference p = new PageReference(state.returnToUrl);
            p.setRedirect(true);
            return p;
        }
        if (null != defaultPageName)
        {
            return UTIL_PageFlow.redirectTo(defaultPageName, state);
        }
        return null;
    }

    // TODO: Some sort of config check to see if customer gets the given page
    private static Boolean isPageAvailable(String pageName)
    {
        return true;
    }
}
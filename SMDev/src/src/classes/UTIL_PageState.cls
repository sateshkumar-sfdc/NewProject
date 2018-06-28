// This class manages all interaction with the query string and keeps track of
// which IDs are available for the current page such as customer, account, case,
// etc.
//
// If you need to add a new query string param:
//  1) Add a strongly typed param name at the top
//     (i.e. private static final String SF_AcctId)
//  2) Add the new name to the allParams list
//
//  3) Add a property with a developer-friendly name
//     (i.e. public String accountId)
public class UTIL_PageState
{
    private static final String SAP_AddPartnerTo = 'SAP_AddPartnerTo';
    private static final String SAP_CustId = 'SAP_CustId';
    private static final String SAP_DeliveryNum = 'dlnumber';
    private static final String SAP_DeliveryItem = 'SAP_DeliveryItem';
    private static final String SAP_DocNum = 'SAP_DocNum';
    private static final String SAP_InvoiceNum = 'InvoiceNumber';
    private static final String SAP_ItemNum = 'itemnumber';
    private static final String SAP_OrderNum = 'ordernumber';
    private static final String SAP_PartnerType = 'SAP_PartnerType';
    private static final String SAP_QuoteId = 'SAP_QuoteId';
    private static final String SAP_RmaId = 'SAP_RmaId';

    private static final String SF_AcctId = 'SF_AcctId';
    private static final String SF_CaseId = 'SF_CaseId';
    private static final String SF_MatId = 'SF_MatId';
    private static final String SF_OppId = 'SF_OppId';
    private static final String SF_OppProdId = 'SF_OppProdId';
    private static final String SF_PlantId = 'SF_PlantId';
    private static final String SF_ProductId = 'SF_ProductId';

    private static final String ENSX_ReturnTo = 'ENSX_ReturnTo';

    // This stores the actual query params
    @testVisible
    private Map<String, String> values;

    private static final List<String> allParams = new List<String> {
        SAP_AddPartnerTo,
        SAP_CustId,
        SAP_DeliveryNum,
        SAP_DeliveryItem,
        SAP_DocNum,
        SAP_InvoiceNum,
        SAP_ItemNum,
        SAP_OrderNum,
        SAP_PartnerType,
        SAP_QuoteId,
        SAP_RmaId,
        SF_AcctId,
        SF_CaseId,
        SF_MatId,
        SF_OppId,
        SF_OppProdId,
        SF_PlantId,
        SF_ProductId
    };

    // ctor()
    public UTIL_PageState()
    {
        this.values = new Map<String, String>();
    }

    // UTIL_PageState.current
    //
    // Returns page state with the current url params set
    // This can be overridden by calling UTIL_PageState.setCurrentState()
    public static UTIL_PageState current
    {
        get
        {
            if (null == UTIL_PageState.current)
            {
                Map<String, String> unfilteredParams = ApexPages.currentPage().getParameters();
                UTIL_PageState.current = new UTIL_PageState();
                for (String p : UTIL_PageState.allParams)
                {
                    UTIL_PageState.current.propSet(p, unfilteredParams.get(p));
                }
            }
            return UTIL_PageState.current;
        }
    }

    // UTIL_PageState.setCurrentState()
    //
    // Override the UTIL_PageState.current
    public static void setCurrentState(UTIL_PageState state)
    {
        UTIL_PageState.current = state;
    }

    // lookupAccountId()
    //
    // Calculate the SF account ID by doing lookups of state query values
    public String lookupAccountId()
    {
        String result = this.accountId;

        if (null == result && null != this.caseId)
        {
            Case c = UTIL_Object_Lookups.getCaseById(this.caseId);
            if (null != c) result = c.AccountId;
        }

        if (null == result && null != this.opportunityId)
        {
            Opportunity o = UTIL_Object_Lookups.getOpportunityById(this.opportunityId);
            if (null != o) result = o.AccountId;
        }

        if (null == result && null != this.customerId)
        {
            Account a = UTIL_Object_Lookups.getAccountByCustomerId(this.customerId);
            if (null != a) result = a.Id;
        }

        return result;
    }

    // saveReturnState()
    //
    // NOTE: This is not static. Call it on a specific page state.
    // i.e. UTIL_PageState.current.saveReturnState()
    public void saveReturnState()
    {
        String path = ApexPages.currentPage().getUrl().split('\\?', 2)[0];
        PageReference page = new PageReference(path);
        UTIL_PageState.setPageParamsFromState(page, UTIL_PageState.current);
        this.returnToUrl = page.getUrl();
        System.debug('UTIL_PageState::saveReturnState - ' + this.returnToUrl);
    }

    // saveCustomReturnState()
    //
    // Like saveReturnState(), except instead of remembering the current  url,
    // we construct a custom url from a pageName, and params from a page state
    public void saveCustomReturnState(String pageName, UTIL_PageState params)
    {
        PageReference returnPage = new PageReference(pageName);
        UTIL_PageState.setPageParamsFromState(returnPage, params);
        this.returnToUrl = returnPage.getUrl();
        System.debug('UTIL_PageState::saveCustomReturnState - ' + this.returnToUrl);
    }

    // Here are all the state properties that can be set
    // If the value is set to null, we remove it from the query string
    public String accountId
    {
        get { return this.propGet(SF_AcctId); }
        set { this.propSet(SF_AcctId, value); }
    }

    public String addPartnerTo
    {
        get { return this.propGet(SAP_AddPartnerTo); }
        set { this.propSet(SAP_AddPartnerTo, value); }
    }

    public String caseId
    {
        get { return this.propGet(SF_CaseId); }
        set { this.propSet(SF_CaseId, value); }
    }

    public String customerId
    {
        get { return this.propGet(SAP_CustId); }
        set { this.propSet(SAP_CustId, value); }
    }

    public String deliveryNum
    {
        get { return this.propGet(SAP_DeliveryNum); }
        set { this.propSet(SAP_DeliveryNum, value); }
    }

    public String deliveryItemNum
    {
        get { return this.propGet(SAP_DeliveryItem); }
        set { this.propSet(SAP_DeliveryItem, value); }
    }

    public String invoiceNum
    {
        get { return this.propGet(SAP_InvoiceNum); }
        set { this.propSet(SAP_InvoiceNum, value); }
    }

    public String docNum
    {
        get { return this.propGet(SAP_DocNum); }
        set { this.propSet(SAP_DocNum, value); }
    }

    public String itemNum
    {
        get { return this.propGet(SAP_ItemNum); }
        set { this.propSet(SAP_ItemNum, value); }
    }

    public String materialId
    {
        get { return this.propGet(SF_MatId); }
        set { this.propSet(SF_MatId, value); }
    }

    public String opportunityId
    {
        get { return this.propGet(SF_OppId); }
        set { this.propSet(SF_OppId, value); }
    }

    public String opportunityProductId
    {
        get { return this.propGet(SF_OppProdId); }
        set { this.propSet(SF_OppProdId, value); }
    }

    public String orderNum
    {
        get { return this.propGet(SAP_OrderNum); }
        set { this.propSet(SAP_OrderNum, value); }
    }

    public String partnerType
    {
        get { return this.propGet(SAP_PartnerType); }
        set { this.propSet(SAP_PartnerType, value); }
    }

    public String plantId
    {
        get { return this.propGet(SF_PlantId); }
        set { this.propSet(SF_PlantId, value); }
    }

    public String productId
    {
        get { return this.propGet(SF_ProductId); }
        set { this.propSet(SF_ProductId, value); }
    }

    public String quoteId
    {
        get { return this.propGet(SAP_QuoteId); }
        set { this.propSet(SAP_QuoteId, value); }
    }

    public String rmaId
    {
        get { return this.propGet(SAP_RmaId); }
        set { this.propSet(SAP_RmaId, value); }
    }

    // This property should probably be ignored except by UTIL_PageFlow
    // Call UTIL_PageFlow.returnToSavedPageOrDefault(pageState, null)
    public String returnToUrl
    {
        get { return this.propGet(ENSX_ReturnTo); }
        private set { this.propSet(ENSX_ReturnTo, value); }
    }


    // getPageParams()
    //
    // Returns the state as a "query string" map of page parameters
    // ready to be attached to a PageReference. This should probably only be
    // used by UTIL_PageFlow
    public Map<String, String> getPageParams()
    {
        return this.values;
    }

    // Helpers to shorten the property definitions
    private String propGet(String key)
    {
        if (!this.values.containsKey(key))
            return null;
        return this.values.get(key);
    }

    private void propSet(String key, String value)
    {
        if (null == value && this.values.containsKey(key))
        {
            this.values.remove(key);
        }
        else
        {
            this.values.put(key, value);
        }
    }

    private static void setPageParamsFromState(PageReference page, UTIL_PageState state)
    {
        if (null == state) return;

        for (String p : UTIL_PageState.allParams)
        {
            String value = state.propGet(p);
            if (null != value)
            {
                page.getParameters().put(p, value);
            }
        }
    }
}
/**
 * controller to display sales order listings and quote listings (NOTE: QUOTE AND SO share the same search controller!!!)
 *
 * if account id is passed in, from account = true, then do not show the search section
 *
 * if coming from a salesforce tab, show search section
 */
public with sharing class CTRL_EnosixOrder_List {

    public Boolean showsearch { get; private set; }   // if this request come from the customer account page, hide search fields
    public String fromaccount { get; private set; }   // if this is true, then show the Back to Account button
    public Boolean hasrecords { get; private set; }   // if this is true, we have records in the grid

    public SBO_EnosixSO_Search os { get; set; }

    public Transient List<SBO_EnosixSO_Search.SEARCHRESULT> fullorders { get; private set; }  // non-paginated
    public List<SBO_EnosixSO_Search.SEARCHRESULT> orders { get; private set; } // paginated
    private string accountId { get; set; }
    private string customerId { get; set; }

    public String orderstatus { get; set; }

    // pagination use
    public Integer numperpage { get; set; }
    public Integer pagenum { get; private set; }  // current page number
    public Integer totalpages { get; private set; }
    public Boolean disableprev { get; private set; }  // at the first page, disable previous arrows
    public Boolean disablenext { get; private set; }  // at the end of the page, disable next arrows

    public CTRL_EnosixOrder_List() {
        /** init for pagination */
        numperpage = 10;    // set default number of records to display per page
        hasrecords = false;
        pagenum = 1;
        disableprev = true;
        disablenext = true;
        fullorders = new List<SBO_EnosixSO_Search.SEARCHRESULT>();
        orders = new List<SBO_EnosixSO_Search.SEARCHRESULT>();
        // first check to see if coming from customer page
        // if coming in from account page, lookup the accountid in the cross reference object: account_to_sap
        // add the button on account page: Sales Orders, SAP Information
        this.customerId = UTIL_PageState.current.accountId;

        os = new SBO_EnosixSO_Search();
        showsearch = true;  // for now still show the search page

        //initSW();
        // set quote/order types


        if (!Test.isRunningTest()) {
            this.Init();
        }
    }

    void Init() {
        if (customerid != null) {

            fromaccount = customerid;

            Account a = UTIL_Account.getAccountFromId(customerid);

            if (null == a) {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'SAP Customer Number not set on account.'));
                return;
            } else {

                // run search
                os.SearchContext.SEARCHPARAMS.SoldToParty = UTIL_Account.getCustomerNumberFromAccount(a);
            }

            if (ordertypes != null && !ordertypes.isEmpty()) os.SearchContext.SEARCHPARAMS.SalesDocumentType = ordertypes[0].getValue();

            searchSO();

        }
        this.orderTypesmaster = UTIL_Order.getOrderTypes('EnosixSO');
    }

    /**
     * handles the searching of quote and display data in the grid
     * @return [description]
     */
    public void searchSO() {
        hasrecords = false;

        runSearch();
        doPagination();
    }

    boolean runSearch() {
        if (orderstatus != null && orderstatus == 'open') {
            os.SearchContext.SEARCHPARAMS.OpenOnly = 'X';
        } else if (orderstatus != null && orderstatus == 'complete') {
            os.SearchContext.SEARCHPARAMS.CompletedOnly = 'X';
        }

        // if (Test.isRunningTest()) EnosixFramework.setMock(EnosixFramework.SearchSBOMock.class, new TestMockUtils.MockSBO_EnosixSO_Search());
        SBO_EnosixSO_Search.EnosixSO_SR searchResult = os.execute();

        if (searchResult.isSuccess()) {
            fullorders = searchResult.getResults();
            // determine total number of pages
            totalpages = Integer.valueOf(Math.ceil(Double.valueOf(fullorders.size()) / Double.valueOf(numperpage)));

            if (fullorders != null && !fullorders.isEmpty()) {
                hasrecords = true;
                return true;
            }
        } else {
            orders = null;
            ENSX.EnosixFramework.displayResultMessages(searchResult, ENSX.EnosixFramework.MessageType.INFO);
        }

        return false;
    }

    /**
     * pagination use, based on what the pagination parameters are, perform pagination work
     */
    public void doPagination() {

        // handle pagination action, actions are: first, prev, next, end
        String action = System.currentPageReference().getParameters().get('action');
        if (action != null) {
            if (action == 'first') pagenum = 1; else if (action == 'prev') pagenum--; else if (action == 'next') pagenum++; else if (action == 'end') pagenum = totalpages;
        }


        if (null == fullorders) {
            runSearch();
        }


        disableprev = (pagenum == 1 ? true : false);
        disablenext = (pagenum == totalpages ? true : false);

        // determine the start record based on numperpage and pagenum
        Integer startofpage = (pagenum - 1) * numperpage;


        // if full orders size is greater than paginated restriction, add portion of it to orders
        if (fullorders.size() > numperpage) {
            orders = new List<SBO_EnosixSO_Search.SEARCHRESULT>();
            for (Integer i = startofpage; i < (numperpage + startofpage); i++) {
                if (i >= fullorders.size()) break;
                orders.add(fullorders.get(i));
            }
        } else orders = fullorders;


    }

    /** update number of records to display per page */
    public void updateNumPerPage() {
        try {
            numperpage = Integer.valueOf(System.currentPageReference().getParameters().get('numperpage'));
        } catch (Exception e) {
            numperpage = 10;
        }
        pagenum = 1;    // everytime we update num per page, we reset page number to 1, salesforce default behavior
        doPagination();
    }

    RFC_SD_GET_ORDER_TYPES.RESULT orderTypesMaster;

    @testVisible
    static void AddOrderTypes(List<SelectOption> result, List<RFC_SD_GET_ORDER_TYPES.ET_VALUES> orderTypes) {
        Set<string> values = new Set<string>();
        for (RFC_SD_GET_ORDER_TYPES.ET_VALUES orderType : orderTypes) {
            if (String.isNotBlank(orderType.Value) && !values.contains(orderType.Value)) {
                result.add(new SelectOption(orderType.Value, orderType.Description));
                values.add(orderType.Value);
            }
        }
    }

    public List<SelectOption> OrderTypes {
        get {
            List<SelectOption> result = new List<SelectOption>();
            result.add(new SelectOption('', 'All'));
            if (null != orderTypesMaster) {
                AddOrderTypes(result, orderTypesMaster.ET_VALUES_List);
            }
            return result;
        }
    }

    /**
     * helper method to populate order status picklist, it is static for now
    */
    public List<SelectOption> getOrderstatuslist() {
        List<SelectOption> orderstatuslist = new List<SelectOption>();
        orderstatuslist.add(new SelectOption('', 'All'));
        orderstatuslist.add(new SelectOption('open', 'Open Orders Only'));
        orderstatuslist.add(new SelectOption('complete', 'Completed Orders Only'));
        return orderstatuslist;
    }


    public List<SelectOption> getNumPerPageOptions() {
        List<SelectOption> numperpageoptions = new List<SelectOption>();
        numperpageoptions.add(new SelectOption('5', '5'));
        numperpageoptions.add(new SelectOption('10', '10'));
        numperpageoptions.add(new SelectOption('25', '25'));
        numperpageoptions.add(new SelectOption('50', '50'));
        numperpageoptions.add(new SelectOption('100', '100'));
        numperpageoptions.add(new SelectOption('200', '200'));
        return numperpageoptions;
    }
    public PageReference navigateToOrderDetail() {
        UTIL_PageState.current.orderNum = System.currentPageReference().getParameters().get('orderId');
        return UTIL_PageFlow.redirectTo(
                UTIL_PageFlow.VFP_OrderDetail, UTIL_PageState.current);
    }
}
public with sharing class CTRL_Return_Order_Search extends CTRL_BasePager {
    public List<SBO_EnosixRO_Search.SEARCHRESULT> fullSearchResults { get; set; }
    public List<SBO_EnosixRO_Search.SEARCHRESULT> searchResults { get; set; }
    public string soldToParty { get; set; }

    public CTRL_Return_Order_Search() {
        fullSearchResults = new List<SBO_EnosixRO_Search.SEARCHRESULT>();
        searchResults = new List<SBO_EnosixRO_Search.SEARCHRESULT>();
    }

    public void init() {
        String casID = UTIL_PageState.current.caseId;
        if (string.isNotBlank(casID)) {
            Case cas = UTIL_Object_Lookups.getCaseById(casID);
            if (null != cas) {
                SBO_EnosixCustomer_Detail.EnosixCustomer customerDetail = UTIL_Object_Lookups.GetCustomerForCase(cas);
                if (null != customerDetail.CustomerNumber) {
                    soldToParty = customerDetail.CustomerNumber;
                    this.searchForReturnOrders();
                    return;
                }
            } else {
                System.debug('case was null');
            }
        }
    }
    public void searchForReturnOrders() {
        this.hasrecords = false;
        this.runSearch();
        this.doPagination();

    }
    public override void runSearch() {
        SBO_EnosixRO_Search searchSBO = new SBO_EnosixRO_Search();
        if (this.soldToParty != null & this.soldToParty != '')
            searchSBO.SearchContext.SEARCHPARAMS.SoldToParty = this.soldToParty;

        SBO_EnosixRO_Search.EnosixRO_SR sr = searchSBO.execute();

        if (sr.isSuccess()) {
            this.fullSearchResults = sr.getResults();
            setTotalPages(this.fullSearchResults.size());

        } else {
            setTotalPages(0);
            searchResults = null;
            ENSX.EnosixFramework.displayResultMessages(sr, ENSX.EnosixFramework.MessageType.INFO);
        }
    }
    public PageReference navigateToRMADetail() {
        UTIL_PageState.current.rmaId = System.currentPageReference().getParameters().get('rmaId');
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_Return_Order_Detail, UTIL_PageState.current);
    }
    public void updateperPage() {
        pagenum = 1;    // everytime we update num per page, we reset page number to 1, salesforce default behavior
        //Without setting total pages, the pagination doesnt disable the buttons properly
        setTotalPages(this.fullSearchResults.size());
        doPagination();
    }
    public override void updatePaginatedResult() {
        if (this.fullSearchResults.size() > this.numperpage) {
            this.searchResults = new List<SBO_EnosixRO_Search.SEARCHRESULT>();
            System.debug('start of page= ' + this.startofpage);
            for (Integer i = this.startofpage; i < (this.numperpage + this.startofpage); i++) {
                if (i >= fullSearchResults.size()) break;
                searchResults.add(fullSearchResults.get(i));
            }
        } else {
            this.searchResults = this.fullSearchResults;
        }
    }

}
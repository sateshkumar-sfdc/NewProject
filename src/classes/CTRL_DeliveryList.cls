/**
 * controller to display sales order listings and quote listings (NOTE: QUOTE AND SO share the same search controller!!!)
 *
 * if account id is passed in, from account = true, then do not show the search section
 *
 * if coming from a salesforce tab, show search section
 */
public with sharing class CTRL_DeliveryList extends CTRL_BasePager {

    public Boolean showsearch {get; private set;}   // if this request come from the customer account page, hide search fields
    public String fromaccount {get; private set;}   // if this is true, then show the Back to Account button

    public SBO_EnosixDL_Search dl {get; set;}
    public List<SBO_EnosixDL_Search.SEARCHRESULT> fulldls {get; private set;}  // non-paginated
    public List<SBO_EnosixDL_Search.SEARCHRESULT> dls {get; private set;}  // paginated

    public CTRL_DeliveryList() {
        super(true);    // set true if full result is transient

        // first check to see if coming from customer page
        // if coming in from account page, lookup the accountid in the cross reference object: account_to_sap
        // add the button on account page: Sales Orders, SAP Information
        String accountId = UTIL_PageState.current.accountId;

        dl = new SBO_EnosixDL_Search();
        showsearch = true;  // for now still show the search page

        if (accountId != null) {

            fromaccount = accountId;

            Account a = UTIL_Account.getAccountFromId(accountId);

            // run search
            dl.SearchContext.SEARCHPARAMS.SoldToParty = UTIL_Account.getCustomerNumberFromAccount(a);

            searchDL();

        }
    }

    public void searchDL() {
        runSearch();
        doPagination();
    }

    /**
     * following two methods are needed to get pagination working
     */

    /**
     * set the result objects for the list view
     * @return [description]
     */
    public override void updatePaginatedResult() {

        if (fulldls.size() > numperpage) {
            dls = new List<SBO_EnosixDL_Search.SEARCHRESULT>();
            for (Integer i = startofpage; i < (numperpage + startofpage); i++) {
                if (i >= fulldls.size()) break;
                dls.add(fulldls.get(i));
            }
        } else dls = fulldls;

    }

    /**
     * handles the searching of dl and display data in the grid
     * @return [description]
     */
    public override void runSearch() {

        if (Test.isRunningTest()) ensx.EnosixFramework.setMock(ensx.EnosixFramework.SearchSBO.class, new MOC_EnosixDL_Search.MockEnosixDLSuccess());
        SBO_EnosixDL_Search.EnosixDL_SR searchResult = dl.execute();
        system.debug('searchResult: ' + searchResult);

        if (searchResult.isSuccess()) {
            fulldls = searchResult.getResults();

            // determine total number of pages
            setTotalPages(fulldls.size());

        } else {
            setTotalPages(0);
            dls = null;
            ensx.EnosixFramework.displayResultMessages(searchResult, ensx.EnosixFramework.MessageType.INFO);
        }

    }

    public PageReference gotoDeliveryDetail() {
        String deliveryId = System.currentPageReference().getParameters().get('deliveryID');
        UTIL_PageState.current.deliveryNum = deliveryId;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_DeliveryDetail, UTIL_PageState.current);
    }
}
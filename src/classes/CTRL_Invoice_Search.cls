public with sharing class CTRL_Invoice_Search extends CTRL_BasePager {

    public Boolean showsearch {get; private set;}   // if this request come from the customer account page, hide search fields
    public String fromaccount {get; private set;}   // if this is true, then show the Back to Account button

    public SBO_EnosixInvoice_Search invoicesearch {get; set;}
    public List<SBO_EnosixInvoice_Search.SEARCHRESULT> fulldls {get; private set;}  // non-paginated
    public List<SBO_EnosixInvoice_Search.SEARCHRESULT> invoiceSearchList {get; private set;}  // paginated

    public CTRL_Invoice_Search() {
        super(true);    // set true if full result is transient

        // first check to see if coming from customer page
        // if coming in from account page, lookup the accountid in the cross reference object: account_to_sap
        // add the button on account page: Sales Orders, SAP Information
        String accountId = UTIL_PageState.current.accountId;

        invoicesearch = new SBO_EnosixInvoice_Search();
        showsearch = true;  // for now still show the search page

        if (accountId != null) {

            fromaccount = accountId;

            Account a = UTIL_Account.getAccountFromId(accountId);

            // run search
            invoicesearch.SearchContext.SEARCHPARAMS.SoldToParty = UTIL_Account.getCustomerNumberFromAccount(a);

            searchInvoice();

        }
    }

    public void searchInvoice() {
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
            invoiceSearchList = new List<SBO_EnosixInvoice_Search.SEARCHRESULT>();
            for (Integer i = startofpage; i < (numperpage + startofpage); i++) {
                if (i >= fulldls.size()) break;
                invoiceSearchList.add(fulldls.get(i));
            }
        } else invoiceSearchList = fulldls;

    }

    /**
     * handles the searching of dl and display data in the grid
     * @return [description]
     */
    public override void runSearch() {
        SBO_EnosixInvoice_Search.EnosixInvoice_SR searchResult = invoiceSearch.execute();

        if (searchResult.isSuccess()) {
            fulldls = searchResult.getResults();

            // determine total number of pages
            setTotalPages(fulldls.size());

        } else {
            setTotalPages(0);
            invoiceSearchList = null;
            ensx.EnosixFramework.displayResultMessages(searchResult, ensx.EnosixFramework.MessageType.INFO);
        }
    }


}
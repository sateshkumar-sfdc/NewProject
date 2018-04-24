/**
 * controller to display sales quote listings and quote listings
 *
 * if account id is passed in, from account = true, then do not show the search section
 *
 * if coming from a salesforce tab, show search section
 */
public with sharing class CTRL_Quote_List extends CTRL_BasePager {

    public Boolean showsearch { get; private set; }   // if this request come from the customer account page, hide search fields
    public String fromaccount { get; private set; }   // if this is true, then show the Back to Account button

    public SBO_EnosixQuote_Search os { get; set; }

    public Transient List<SBO_EnosixQuote_Search.SEARCHRESULT> fullquotes { get; private set; }  // non-paginated
    public List<SBO_EnosixQuote_Search.SEARCHRESULT> quotes { get; private set; } // paginated
    private string accountId { get; set; }
    private string customerId { get; set; }

    public String quotestatus { get; set; }

    public CTRL_Quote_List() {
        super(true);    // set true if full result is transient
        // first check to see if coming from customer page
        // if coming in from account page, lookup the accountid in the cross reference object: account_to_sap
        // add the button on account page: Quotes, SAP Information
        // TODO: Rename this to accountId
        this.customerId = UTIL_PageState.current.accountId;

        os = new SBO_EnosixQuote_Search();
        showsearch = true;  // for now still show the search page

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

            searchQuote();
        }
    }

    /**
     * handles the searching of quote and display data in the grid
     * @return [description]
     */
    public void searchQuote() {
        hasrecords = false;

        runSearch();
        doPagination();
    }

    public override void runSearch() {
        if (quotestatus != null && quotestatus == 'open') {
            os.SearchContext.SEARCHPARAMS.OpenOnly = 'X';
        } else if (quotestatus != null && quotestatus == 'complete') {
            os.SearchContext.SEARCHPARAMS.CompletedOnly = 'X';
        }

        SBO_EnosixQuote_Search.EnosixQuote_SR searchResult = os.execute();

        if (searchResult.isSuccess()) {
            fullquotes = searchResult.getResults();

            setTotalPages(fullquotes.size());

        } else {
            setTotalPages(0);
            quotes = null;
            ENSX.EnosixFramework.displayResultMessages(searchResult, ENSX.EnosixFramework.MessageType.INFO);
        }
    }

    /**
     * set the result objects for the list view
     * @return [description]
     */
    public override void updatePaginatedResult() {
        //quotes = fullquotes;
        system.debug('Full quotes:' + fullquotes.size());
        system.debug('numperpage:' + numperpage);
        if (fullquotes.size() > numperpage) {
            quotes = new List<SBO_EnosixQuote_Search.SEARCHRESULT>();
            for (Integer i = startofpage; i < (numperpage + startofpage); i++) {
                if (i >= fullquotes.size()) break;
                quotes.add(fullquotes.get(i));
            }
        } else quotes = fullquotes;
    }

    /**
     * helper method to populate order status picklist, it is static for now
    */
    public List<SelectOption> getquotestatuslist() {
        List<SelectOption> quotestatuslist = new List<SelectOption>();
        quotestatuslist.add(new SelectOption('', 'All'));
        quotestatuslist.add(new SelectOption('open', 'Open Quotes Only'));
        quotestatuslist.add(new SelectOption('complete', 'Completed Quotes Only'));
        return quotestatuslist;
    }
    public PageReference navigateToQuoteDetail() {
        UTIL_PageState.current.quoteId = System.currentPageReference().getParameters().get('quoteId');
        return UTIL_PageFlow.redirectTo(
                UTIL_PageFlow.VFP_Quote_Detail, UTIL_PageState.current);
    }
}
public with sharing class CTRL_CustomerLink
{
    // Account refrenced from url parameter acctId
    public Account a {get; set;}
    public String accountid {get; private set;}

    public List<SBO_EnosixCustomer_Search.SEARCHRESULT> matching_customers {get; private set;}

    public final SBO_EnosixCustomer_Search search {get; private set;}

    //Search parameter bindings
    public string customerName { get; set; }
    public string postalCode { get; set; }
    public string phoneNumber { get; set; }
    public string email { get; set; }

    //Maximum length of a field in the Search SBO
    private final integer MAX_LENGTH_CUSTOMERNAME = 25;
    private final integer MAX_LENGTH_PHONENUMBER = 30;
    private final integer MAX_LENGTH_EMAIL = 241;

    @testVisible
    private Account getAccount() {
        Account result = null;

        result = UTIL_Object_Lookups.getAccountById(this.accountid);
        return result;
    }

    //ctor
    public CTRL_CustomerLink()
    {
        this.accountid = UTIL_PageState.current.accountId;
        a = getAccount();

        this.matching_customers = new List<SBO_EnosixCustomer_Search.SEARCHRESULT>();
        this.search = new SBO_EnosixCustomer_Search();

        if (!Test.isRunningTest()) {
            init();
        }
    }

    private void init()
    {
        //By default we're going to perform a lookup based upon a provided account ID
        customerName = a.Name;
        postalCode = a.BillingPostalCode;
        phoneNumber = a.Phone;
        searchForCustomersMatchingCriteria();
    }

    //Wraps a string in wildcard characters for passing back to SAP
    @testVisible
    private string wildCardSearch(string fieldValue, integer maxLength)
    {
        //If the field value is too long, pre-pending the search
        //term with * will actually cause the search to fail due to the way
        //SAP truncates the search term.
        //In the case where the value is too long, SAP automatically switches to
        //a wildcard search making these unnecessary.
        if (!fieldValue.startsWith('*') && fieldValue.length() < maxLength)
            fieldValue = '*' + fieldValue;
        //No need to trim the trailing *, as it will automatically be trimmed.
        if (!fieldValue.endsWith('*'))
            fieldValue += '*';
        return fieldValue;
    }

    public void actionCustomerSearch()
    {
        searchForCustomersMatchingCriteria();
    }

    @testVisible
    private void searchForCustomersMatchingCriteria()
    {
        matching_customers = new List<SBO_EnosixCustomer_Search.SEARCHRESULT>();

        search.SearchContext.SEARCHPARAMS.CustomerName =
            string.isNotBlank(customerName) ? wildCardSearch(customerName, MAX_LENGTH_CUSTOMERNAME) : customerName;

        // Phone Number does not support wild card search from the front-end.
        // It does it's own wildcarding on the backend.
        search.SearchContext.SEARCHPARAMS.TelephoneNumber = phoneNumber;

        search.SearchContext.SEARCHPARAMS.EmailAddress =
            string.isNotBlank(email) ? wildCardSearch(email, MAX_LENGTH_EMAIL) : email;

        // Postal code does not support wild card search
        search.SearchContext.SEARCHPARAMS.PostalCode = postalCode;

        SBO_EnosixCustomer_Search.EnosixCustomer_SR searchResult = search.execute();

        if (!searchResult.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(searchResult, ENSX.EnosixFramework.MessageType.INFO);
        }
        else
        {
            matching_customers = searchResult.getResults();
        }
    }

    /***************************************************************************
    Page Navigation Methods
    ***************************************************************************/
    public PageReference actionLinkAccount()
    {
        String linkedCustomerNumber = System.currentPageReference().getParameters().get('linkedCustomerNumber');

        //If there was a customer to link to, redirect to the customer details
        if (null == linkedCustomerNumber)
        {
            return null;
        }

        // Providing the Customer detail object for the CUSTOMER_LINKED event requires a
        // callout but callouts cannot be made after DML modifications.
        // Only make the callout if there's a handler registered for the event.
        SBO_EnosixCustomer_Detail.EnosixCustomer linkedCustomer = null;
        if (UTIL_Event.isEnosixEventHandlerRegistered(UTIL_Event.CUSTOMER_LINKED))
        {
            linkedCustomer = UTIL_Customer.fetchEnosixCustomer(linkedCustomerNumber);
        }

        UTIL_Account.setAccountCustomerNumber(this.a, linkedCustomerNumber);

        Account linkAccount = new Account(ID = a.ID);
        UTIL_Account.setAccountCustomerNumber(linkAccount, linkedCustomerNumber);
        upsert linkAccount;

        if (!UTIL_Event.executeEvent(UTIL_Event.CUSTOMER_LINKED, new Map<String, object> {
                'SBO_EnosixCustomer_Detail.EnosixCustomer' => linkedCustomer
            }).isSuccess)
        {
            return null;
        }

        UTIL_PageState.current.accountId = a.id;
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_CustomerDetail, UTIL_PageState.current);
    }

    public PageReference GoToCreateCustomer() {
        return UTIL_Customer.redirectToCreateCustomer();
    }
}
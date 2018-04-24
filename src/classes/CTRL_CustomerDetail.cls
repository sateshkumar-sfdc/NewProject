public virtual with sharing class CTRL_CustomerDetail
{
    // Account refrenced from url parameter acctId
    public Account a { get; set; }

    public String customerid { get; private set; }
    public String accountid { get; private set; }
    public String caseid { get; private set; }
    public String opportunityid { get; private set; }
    @testVisible
    public SBO_EnosixCustomer_Detail.EnosixCustomer cDetail { get; protected set; }
    public boolean showCompanyInfo { get { return CompanyList.size() > 0; } }
    public boolean showSalesAreas { get { return SalesAreaList.size() > 0; } }
    public boolean hasAccount { get { return String.isNotBlank(accountid); } }

    private Set<String> shipToParentPartnerTypes
    {
        get
        {
            return (Set<String>)UTIL_AppSettings.getSet(
                'Customer.ShipToParentPartnerTypes', String.class, new Set<String>{'*'});
        }
    }

    public Boolean showShipToCreate
    {
        get
        {
            if (shipToParentPartnerTypes.contains('*')
                || shipToParentPartnerTypes.contains(cDetail.BusinessPartnerType))
            {
                    return true;
            }

            return false;
        }
    }

    public List<SBO_EnosixCustomer_Detail.COMPANY_DATA> CompanyList {
        get {
            List<SBO_EnosixCustomer_Detail.COMPANY_DATA> result = new List<SBO_EnosixCustomer_Detail.COMPANY_DATA>();

            if (null != this.cDetail) {
                this.cDetail.COMPANY_DATA.copyTo(result);
            }

            return result;
        }
    }


    public List<SBO_EnosixCustomer_Detail.SALES_DATA> SalesAreaList {
        get {
            List<SBO_EnosixCustomer_Detail.SALES_DATA> result = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();

            if (null != this.cDetail) {
                this.cDetail.SALES_DATA.copyTo(result);
            }

            return result;
        }
    }

    public List<SBO_EnosixCustomer_Detail.CREDIT> CreditList {
        get {
            List<SBO_EnosixCustomer_Detail.CREDIT> result = new List<SBO_EnosixCustomer_Detail.CREDIT>();

            if (null != this.cDetail) {
                // cDetail.CREDIT used to be a collection, but is now just one row (a struct),
                // but treating this as a list is easier than refactoring the view
                result.add(this.cDetail.CREDIT);
            }

            return result;
        }
    }

    public List<SBO_EnosixCustomer_Detail.PARTNERS> PartnerList {
        get {
            List<SBO_EnosixCustomer_Detail.PARTNERS> result = new List<SBO_EnosixCustomer_Detail.PARTNERS>();

            if (null != this.cDetail) {
                this.cDetail.PARTNERS.copyTo(result);
            }

            return result;
        }
    }

    @testVisible
    private Account getAccount() {
        Account result = null;

        // Lookup by page params caseId, then customerId, then accountId
        if (this.caseid != null) {
            Case sfCase = UTIL_Object_Lookups.getCaseById(this.caseid);
            result = UTIL_Object_Lookups.getAccountById(sfCase.AccountId);
        } else if (this.accountid != null && this.customerid != null) {
            result = UTIL_Object_Lookups.getAccountById(this.accountid);
        } else if (this.customerid != null) {
            result = UTIL_Object_Lookups.getAccountByCustomerId(this.customerid);
        } else {
            result = UTIL_Object_Lookups.getAccountById(this.accountid);
        }
        return result;
    }

    @testVisible
    public string FormattedPhone {
        get {
            return UTIL_ViewHelper.formatPhoneForDisplay(this.cDetail.TelephoneNumber, this.cDetail.TelephoneNumberExtension);
        }
    }

    @testVisible
    public string FormattedFax {
        get {
            return UTIL_ViewHelper.formatPhoneForDisplay(this.cDetail.FaxNumber, this.cDetail.FaxNumberExtension);
        }
    }

    @testVisible
    private void refreshIdsFromAccount(Account account) {
        if (null != account) {
            this.accountid = account.id;
            UTIL_PageState.current.accountId = this.accountid;

            if (null == this.customerid) {
                this.customerid = UTIL_Account.getCustomerNumberFromAccount(account);
                UTIL_PageState.current.customerId = this.customerid;
            }
        }
    }

    //ctor
    public CTRL_CustomerDetail() {
        this.accountid = UTIL_PageState.current.accountId;
        this.caseid = UTIL_PageState.current.caseId;
        this.customerid = UTIL_PageState.current.customerId;
        this.opportunityid = UTIL_PageState.current.opportunityId;
        this.a = getAccount();
        if ((this.accountid == null || this.accountid == '') && this.a != null)
        {
            this.accountid = a.Id;
        }
        refreshIdsFromAccount(this.a);
    }

    public System.PageReference initDetail() {
        system.debug('initDetail');
        system.debug('customerid: ' + this.customerid);
        if( string.isNotEmpty(this.customerid) ){
            this.cDetail = UTIL_Customer.fetchEnosixCustomer(this.customerId);
        }
        return null;
    }

    public PageReference GoToCreateCustomer() {
        return UTIL_Customer.redirectToCreateCustomer();
    }

    public PageReference actionAddShipTo() {
        UTIL_PageState state = new UTIL_PageState();
        state.partnerType = 'SH';
        if (null != cDetail) state.addPartnerTo = cDetail.CustomerNumber;
        if (null != a) state.accountId = a.Id;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_CustomerCreate, state);
    }

    public PageReference updateSAPCustomer() {
        return UTIL_Customer.redirectToEditCustomer();
    }

    public PageReference gotoCustomerPage() {
        String selectedCustomerId = System.currentPageReference().getParameters().get('selectedCustomerId');

        UTIL_PageState.current.customerId = selectedCustomerId;
        UTIL_PageState.current.accountId = this.accountId;

        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_CustomerDetail, UTIL_PageState.current);
    }

    public PageReference GoToCustomerLinkPage() {
        UTIL_PageState.current.accountId = this.accountId;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_Customer_Link, UTIL_PageState.current);
    }

}
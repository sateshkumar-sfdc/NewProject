public with sharing class CTRL_CustomerCreate
{
    // Account refrenced from url parameter acctId
    public Account a { get; set; }

    public boolean has_sap_customer { get; set; }
    public boolean showCreateCustomerAction { get; private set; }

    private final SBO_EnosixCustomer_Detail EnosixCustomer_Detail = new SBO_EnosixCustomer_Detail();
    public boolean ShowUpdate { get; set; }
    boolean isInitialized { get; set; }

    public String customerid { get; private set; }
    public String accountid { get; private set; }
    public String caseid { get; private set; }
    //ID fo the customer to which we're adding a partner
    public String addPartnerToId { get; private set; }
    //Customer being created
    @testVisible
    public SBO_EnosixCustomer_Detail.EnosixCustomer cDetail
    {
        get;
        protected set;
    }

    // The customer that the new customer will be applyed to
    public SBO_EnosixCustomer_Detail.EnosixCustomer parentCustomer { get; private set; }

    public Boolean IsCustomerContactEditable
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Customer.IsContactEditable', false);
        }
    }

    public Boolean IsCustomerAddressEditable
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Customer.IsAddressEditable', false);
        }
    }

    @testVisible
    private Account getAccount()
    {
        if (this.caseid != null)
        {
            Case sfCase = UTIL_Object_Lookups.getCaseById(this.caseid);
            this.accountid = sfCase.AccountId;
        }
        return UTIL_Object_Lookups.getAccountById(this.accountid);
    }

    @testVisible
    public string FormattedPhone
    {
        get
        {
            return UTIL_ViewHelper.formatPhoneForDisplay(this.cDetail.TelephoneNumber, this.cDetail.TelephoneNumberExtension);
        }
    }

    @testVisible
    public string FormattedFax
    {
        get
        {
            return UTIL_ViewHelper.formatPhoneForDisplay(this.cDetail.FaxNumber, this.cDetail.FaxNumberExtension);
        }
    }

    //ctor
    public CTRL_CustomerCreate()
    {
        this.isInitialized = false;
        this.accountid = UTIL_PageState.current.accountId;
        this.caseid = UTIL_PageState.current.caseId;
        this.customerid = UTIL_PageState.current.customerId;
        this.a = getAccount();
        this.addPartnerToId = UTIL_PageState.current.addPartnerTo;

        if (!Test.isRunningTest())
        {
            initRfcData();
        }
    }

    public void initRfcData()
    {
        this.bpRoleTypes = getRoleTypes();
        this.salesAreaMaster = UTIL_SalesArea.getSalesAreaMaster();
        this.officeMaster = getOfficeMaster();
        this.priceMaster = getPriceMaster();
        this.shippingMaster = getShippingMaster();
        this.countries = getCountries();
    }

    public PageReference initCreateMode()
    {

        //If no account was foud on iniitalization, break.
        //A custom link is displayed to redirect either back to the Case
        //or redirect to the account page so that an account can be created first.
        if (this.a == null)
            return null;

        this.cDetail = createCustomerDetail(this.a, this.caseid);

        if (null != addPartnerToId)
        {
            return initAddPartner();
        }

        showCreateCustomerAction = true;
        return null;
    }


    /*
    * customer create for adding as a sold to partner type
    * This will initialse a new custom that will be saved and then
    *   added as a ship to on the calling cutomer detail screen.
    * After comletion re-direct back to the calling customer detail.
    */
    public PageReference initAddPartner()
    {
        this.parentCustomer = UTIL_Customer.fetchEnosixCustomer(addPartnerToId);

        if (null == this.parentCustomer)
        {
            string errorMessage = String.format('SAP Customer {0} not found.', new string[] {addPartnerToId});
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }

        this.cDetail.BusinessPartnerType = UTIL_PageState.current.partnerType;
        this.cDetail = commandApplyEdits(this.cDetail);

        showAddPartnerAction = true;

        return null;
    }

    // enables the Add partner action button
    public boolean showAddPartnerAction { get; private set; }

    static void copySalesAreasFromCustomer(
            SBO_EnosixCustomer_Detail.EnosixCustomer srcCustomer,
            SBO_EnosixCustomer_Detail.EnosixCustomer destCustomer)
    {

        List<SBO_EnosixCustomer_Detail.SALES_DATA> salesAreas = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();

        srcCustomer.SALES_DATA.copyTo(salesAreas);

        //for(SBO_EnosixCustomer_Detail.SALES_DATA salesArea : salesAreas) {
        //  destCustomer.SALES_DATA.add(salesArea);
        //}

        destCustomer.BusinessPartnerCategory = srcCustomer.BusinessPartnerCategory;
        destCustomer.BusinessPartnerType = srcCustomer.BusinessPartnerType;
        destCustomer.BPRole = srcCustomer.BPRole;


    }

    public PageReference initEdit()
    {

        string customerNumber = UTIL_PageState.current.customerId;

        if (string.isBlank(customerNumber) && null != this.a)
        {
            customerNumber = UTIL_Account.getCustomerNumberFromAccount(this.a);
        }

        if (string.isBlank(customerNumber))
        {
            return UTIL_Customer.redirectToCreateCustomer();
        }

        this.cDetail = UTIL_Customer.fetchEnosixCustomer(customerNumber);

        return null;
    }


    public Account RefrenceAccount
    {
        get
        {
            return a;
        }
    }

    public SBO_EnosixCustomer_Detail.EnosixCustomer NewCustomer
    {
        get
        {
            return this.cDetail;
        }
    }

    class CustomerCreateSalesAreas implements DS_SalesArea
    {
        private CTRL_CustomerCreate parent;
        private SBO_EnosixCustomer_Detail.SALES_DATA salesData;

        public void updateSalesArea(SBO_EnosixCustomer_Detail.SALES_DATA salesData)
        {
            if (this.parent.cDetail.SALES_DATA.size() > 0)
            {
                this.parent.cDetail.SALES_DATA.remove(this.parent.cDetail.SALES_DATA.get(0));
                this.parent.cDetail.SALES_DATA.add(salesData);
            }
            else
            {
                this.parent.cDetail.SALES_DATA.add(salesData);
            }
            this.parent.updateDetail();
        }
        public CustomerCreateSalesAreas(CTRL_CustomerCreate parent, SBO_EnosixCustomer_Detail.SALES_DATA salesData)
        {
            this.parent = parent;
            this.salesData = salesData;
        }

        public SBO_EnosixCustomer_Detail.SALES_DATA getSALES_DATA()
        {

            return this.salesData;
        }

        public RFC_SD_GET_SALES_AREAS.RESULT getSalesAreas()
        {

            return this.parent.salesAreaMaster;
        }

        public RFC_SD_GET_GROUP_OFFICE.RESULT getGroupOffice()
        {
            return this.parent.officeMaster;
        }

        public RFC_SD_GET_PRICING_STAT.RESULT getPricingStat()
        {
            return this.parent.priceMaster;
        }

        public RFC_SD_GET_SHIP_INFO.RESULT getShipInfo()
        {
            return this.parent.shippingMaster;
        }
    }

    public List<DS_SalesArea> DS_SalesAreas
    {
        get
        {
            List<DS_SalesArea> result = new List<DS_SalesArea>();
            List<SBO_EnosixCustomer_Detail.SALES_DATA> cDetailSalesData = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();

            this.cDetail.SALES_DATA.copyTo(cDetailSalesData);

            for (SBO_EnosixCustomer_Detail.SALES_DATA item : cDetailSalesData)
            {
                result.add(new CustomerCreateSalesAreas(this, item));
            }

            return result;
        }
    }

    class CustomerCreateCompanyCode implements DS_CompanyCode
    {
        private CTRL_CustomerCreate parent;
        private SBO_EnosixCustomer_Detail.COMPANY_DATA companyData;


        public CustomerCreateCompanyCode(CTRL_CustomerCreate parent, SBO_EnosixCustomer_Detail.COMPANY_DATA companyData)
        {
            this.parent = parent;
            this.companyData = companyData;
        }

        public SBO_EnosixCustomer_Detail.COMPANY_DATA getCOMPANY_DATA()
        {
            return this.companyData;
        }

        public RFC_SD_GET_SHIP_INFO.RESULT getShipInfo()
        {
            return this.parent.shippingMaster;
        }
    }

    public List<DS_CompanyCode> CompanyCodes
    {
        get
        {
            List<DS_CompanyCode> result = new List<DS_CompanyCode>();
            List<SBO_EnosixCustomer_Detail.COMPANY_DATA> cDetailCompanyData = new List<SBO_EnosixCustomer_Detail.COMPANY_DATA>();

            this.cDetail.COMPANY_DATA.copyTo(cDetailCompanyData);

            for (SBO_EnosixCustomer_Detail.COMPANY_DATA item : cDetailCompanyData)
            {
                result.add(new CustomerCreateCompanyCode(this, item));
            }

            return result;
        }
    }

    SBO_EnosixCustomer_Detail.EnosixCustomer createCustomerDetail(Account account, string caseId)
    {
        SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        if (!UTIL_Event.executeEvent(UTIL_Event.CUSTOMER_INITIALIZING, new Map<String, object>
        {
                'SBO_EnosixCustomer_Detail.EnosixCustomer' => result,
                'Account' => account
        }).isSuccess)
        {
            return null;
        }
        // Account to SAP Customer Mapping
        result.Name = account.Name;
        result.City = account.BillingCity;
        result.Street = account.BillingStreet;
        result.TelephoneNumber = account.Phone;
        result.PostalCode = account.BillingPostalCode;

        SBO_EnosixCustomer_Detail.USER_DEFINED userDefinedData = new SBO_EnosixCustomer_Detail.USER_DEFINED();
        userDefinedData.FIELD = 'SF_RECORD_TYPE';
        userDefinedData.VALUE = account.RecordType.Name;
        result.USER_DEFINED.clear();        
        result.USER_DEFINED.add(userDefinedData);

        result.Country = UTIL_ViewHelper.getValueForSelectOptionByValueOrLabel(
            this.CountryOptions,
            account.BillingCountry
        );
        if (result.Country == '') result.Country = 'US';
            result.Region = UTIL_ViewHelper.getValueForSelectOptionByValueOrLabel(
            this.getRegionOptionsForCountry(result.Country),
            account.BillingState
        );

        result.SearchTerm1 = account.Name;

        if (caseId != null)
        {
            // If we have a case ID, this is a Return Order customer
            result = commandInitForReturn(result);
        }
        else if (null != addPartnerToId)
        {
            //Partner being added to an existing customer
            result = commandInitForShipTo(result);
        }
        else
        {
            // Normal order customer
            result = commandInitForOrder(result);
        }
        // This is a work around for a page flow issue:
        // - On init, updating the customer detail causes DS_SalesAreas to change
        // which causes the CMP_SalesAreas component to redraw, which in turn calls
        // this controller's updateDetail() method, calling commandApplyEdits().
        //
        // The problem is that the commandApplyEdits command again changes DS_SalesAreas,
        // which should refresh the component display again, but it does not.
        // To work around this, we just call commandApplyEdits() here, earlier in
        // the page cycle to make sure the screen renders the proper data.
        result = commandApplyEdits(result);
        if (!UTIL_Event.executeEvent(UTIL_Event.CUSTOMER_INITIALIZED, new Map<String, object>
        {
                'SBO_EnosixCustomer_Detail.EnosixCustomer' => result,
                'Account' => account
        }).isSuccess)
        {
            return null;
        }
        return result;
    }

    @TestVisible
    SBO_EnosixCustomer_Detail.EnosixCustomer callCommand(string command, SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        SBO_EnosixCustomer_Detail EnosixCustomer_Detail = new SBO_EnosixCustomer_Detail();

        SBO_EnosixCustomer_Detail.EnosixCustomer result = EnosixCustomer_Detail.command(command, customer);
        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }
        return result;
    }

    @TestVisible
    SBO_EnosixCustomer_Detail.EnosixCustomer commandApplyEdits(SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        return callCommand('CMD_APPLY_EDITS', customer);
    }

    @TestVisible
    SBO_EnosixCustomer_Detail.EnosixCustomer commandInitForOrder(SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        return callCommand('CMD_INIT_FOR_ORDER', customer);
    }

    @TestVisible
    SBO_EnosixCustomer_Detail.EnosixCustomer commandInitForReturn(SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        return callCommand('CMD_INIT_FOR_RETURN', customer);
    }

    @TestVisible
    SBO_EnosixCustomer_Detail.EnosixCustomer commandInitForShipTo(SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        return callCommand('CMD_INIT_FOR_SHIP_TO', customer);
    }

    RFC_SD_GET_COUNTRIES.RESULT countries;
    public List<SelectOption> CountryOptions
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();
            AddCountries(result, countries.ET_OUTPUT_List);
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }

    public List<SelectOption> RegionOptions
    {
        get
        {
            return getRegionOptionsForCountry(NewCustomer.Country);
        }
    }

    private List<SelectOption> getRegionOptionsForCountry(String country)
    {
        List<SelectOption> result = new List<SelectOption>();
        System.debug('RegionOptions - for country: ' + country);
        AddRegionsForCountry(result, countries.ET_REGIONS_List, country);
        UTIL_ViewHelper.sortOptionsByLabel(result);
        result.add(0, new SelectOption('', 'Select One...'));
        return result;
    }

    RFC_SD_GET_COUNTRIES.RESULT getCountries()
    {
        RFC_SD_GET_COUNTRIES rfc = new RFC_SD_GET_COUNTRIES();
        RFC_SD_GET_COUNTRIES.RESULT result = rfc.execute();
        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }

        return result;
    }

    // BP Type Dropdown
    RFC_SD_GET_BP_ROLE_TYPE.RESULT bpRoleTypes;
    public List<SelectOption> BusinessPartnerCategoryOptions
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();

            if (null != bpRoleTypes)
            {
                for (RFC_SD_GET_BP_ROLE_TYPE.ET_BP_CATEGORY bpCat : bpRoleTypes.Categories)
                {
                    result.add(new SelectOption(bpCat.Category, bpCat.Description));
                }
            }
            result.sort();
            return result;
        }
    }


    public List<SelectOption> BusinessPartnerTypeOptions
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();

            if (null != bpRoleTypes)
            {
                for (RFC_SD_GET_BP_ROLE_TYPE.ET_BP_TYPE bpType : bpRoleTypes.Types)
                {
                    if (UTIL_Customer.allowedClientTypes.contains(bpType.Type)
                        || UTIL_Customer.allowedClientTypes.contains('*'))
                    {
                        result.add(new SelectOption(bpType.Type, bpType.Description));
                    }
                }
            }
            result.sort();
            return result;
        }
    }
    /*
    public List<SelectOption> BusinessPartnerRoleOptions {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (null != bpRoleTypes) {
                for (RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE bpRole : bpRoleTypes.Roles) {
                    if (string.isNotBlank(BusinessPartnerCategory)) {
                        integer partnerType = integer.valueOf(BusinessPartnerCategory);
                        boolean shouldAdd =
                            (partnerType == 1 && bpRole.ForPerson)||
                            (partnerType == 2 && bpRole.ForOrg)||
                            (partnerType == 3 && bpRole.ForGroup);
                        if (shouldAdd) {
                            result.add(new SelectOption(bpRole.Role, bpRole.Description));
                        }
                    }
                 }
            }
            result.sort();
            return result;
        }
    }
    */
    public List<SelectOption> BPRoleGroups
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();
            result.add(new SelectOption('', 'Select a Value'));
            AddBPRoleGroups(result, bpRoleTypes.ET_BP_ROLE_GROUP_List);
            return result;
        }
    }


    RFC_SD_GET_BP_ROLE_TYPE.RESULT getRoleTypes()
    {
        RFC_SD_GET_BP_ROLE_TYPE rfc = new RFC_SD_GET_BP_ROLE_TYPE();
        RFC_SD_GET_BP_ROLE_TYPE.RESULT result = rfc.execute();

        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }

        return result;
    }

    RFC_SD_GET_SALES_AREAS.RESULT salesAreaMaster;

    RFC_SD_GET_GROUP_OFFICE.RESULT officeMaster;
    RFC_SD_GET_GROUP_OFFICE.RESULT getOfficeMaster()
    {

        RFC_SD_GET_GROUP_OFFICE rfc = new RFC_SD_GET_GROUP_OFFICE();
        RFC_SD_GET_GROUP_OFFICE.RESULT result = rfc.execute();
        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }
        return result;
    }

    RFC_SD_GET_PRICING_STAT.RESULT priceMaster;
    RFC_SD_GET_PRICING_STAT.RESULT getPriceMaster()
    {

        RFC_SD_GET_PRICING_STAT rfc = new RFC_SD_GET_PRICING_STAT();
        RFC_SD_GET_PRICING_STAT.RESULT result = rfc.execute();
        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }
        return result;
    }

    RFC_SD_GET_SHIP_INFO.RESULT shippingMaster;
    RFC_SD_GET_SHIP_INFO.RESULT getShippingMaster()
    {

        RFC_SD_GET_SHIP_INFO rfc = new RFC_SD_GET_SHIP_INFO();
        RFC_SD_GET_SHIP_INFO.RESULT result = rfc.execute();
        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }
        return result;
    }

    static string pickFirst(List<SelectOption> options)
    {
        if (options.size() <= 0) return '';

        SelectOption firstOption = options.get(0);
        if (null != firstOption)
        {
            return firstOption.getValue();
        }
        return '';
    }

    public void updateDetail()
    {
        try
        {
            this.cDetail = this.commandApplyEdits(this.cDetail);
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    public void BeginUpdate()
    {
        this.ShowUpdate = true;
    }

    public boolean ValidateFields()
    {
        boolean result = true;
        string errorMessage = '';

        if (string.isBlank(NewCustomer.Name))
        {
            result = false;
            errorMessage = 'Name is required';
        }

        if ('1' == NewCustomer.BusinessPartnerCategory && string.isBlank(NewCustomer.Name2))
        {
            result = false;
            errorMessage = 'Name2 is required';
        }

        if (string.isBlank(NewCustomer.Street))
        {
            result = false;
            errorMessage = 'Street is required';
        }

        if (string.isBlank(NewCustomer.City))
        {
            result = false;
            errorMessage = 'City is required';
        }

        if (string.isBlank(NewCustomer.Region))
        {
            result = false;
            errorMessage = 'Region is required';
        }

        if (string.isBlank(NewCustomer.PostalCode))
        {
            result = false;
            errorMessage = 'PostalCode is required';
        }

        if (string.isBlank(NewCustomer.BPRole))
        {
            result = false;
            errorMessage = 'BP Role is required';
        }

        if (!result)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, errorMessage));
        }

        return result;
    }

    static void displayException(Exception e)
    {
        if (null == e) return;

        ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());

        ApexPages.addMessage(message);
    }

    public PageReference actionReturnToCustomer()
    {
        return redirectToCustomerDetail(this.parentCustomer);
    }

     /**
     * action called by the Add SAP Partner to Customer button
     */
    public PageReference actionAddSAPPartner()
    {

        if (!ValidateFields()) return null;

        SBO_EnosixCustomer_Detail sbo = new SBO_EnosixCustomer_Detail();

        SBO_EnosixCustomer_Detail.EnosixCustomer result = null;

        try
        {
            result = sbo.save(this.cDetail);
        }
        catch (Exception e)
        {
            displayException(e);
            return null;
        }

        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
            return null;
        }

        // Update the displayed customer information
        this.cDetail = result;

        if (!addPartnerToCustomer(this.parentCustomer, this.cDetail, 'SH'))
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Add partner to customer failed'));
            return null;
        }
        try
        {
            result = sbo.save(this.parentCustomer);
        }
        catch (Exception e)
        {
            displayException(e);
            return null;
        }

        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
            return null;
        }

        if (!UTIL_Event.executeEvent(UTIL_Event.PARTNER_ADDED, new Map<String, object>
        {
                'SBO_EnosixCustomer_Detail.EnosixCustomer' => this.cDetail,
                'Account' => this.a
        }).isSuccess)
        {
            return null;
        }

        if (!UTIL_Event.executeEvent(UTIL_Event.CUSTOMER_CREATED, new Map<String, object>
        {
                'SBO_EnosixCustomer_Detail.EnosixCustomer' => this.cDetail
        }).isSuccess)
        {
            return null;
        }

        return redirectToCustomerDetail(this.parentCustomer);

    }

    /**
     * create new SAP Customer # for this account
     */
    public PageReference createSAPCustomer()
    {
        if (!ValidateFields()) return null;

        SBO_EnosixCustomer_Detail sbo = new SBO_EnosixCustomer_Detail();
        try
        {
            SBO_EnosixCustomer_Detail.EnosixCustomer result = sbo.save(this.cDetail);
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);

            if (result.isSuccess())
            {
                cDetail = result;
                UTIL_Account.setAccountCustomerNumber(a, this.cDetail.CustomerNumber);

                Account linkAccount = new Account(ID = a.ID);
                UTIL_Account.setAccountCustomerNumber(linkAccount, this.cDetail.CustomerNumber);
                upsert linkAccount;

                if (!UTIL_Event.executeEvent(UTIL_Event.CUSTOMER_CREATED, new Map<String, object>
                {
                        'SBO_EnosixCustomer_Detail.EnosixCustomer' => this.cDetail
                }).isSuccess)
                {
                    return null;
                }

                //redirect to customer Detail
                return UTIL_Customer.redirectToDisplayCustomer();
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }

    @TestVisible
    private static PageReference redirectToCustomerDetail(SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        UTIL_PageState.current.customerId = customer.CustomerNumber;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_CustomerDetail, UTIL_PageState.current);
    }

    @testVisible
    public PageReference gotoCase()
    {
        return UTIL_PageFlow.redirectTo('/' + this.caseId, null);
    }

    @testVisible
    public PageReference gotoAccounts()
    {
        return UTIL_PageFlow.redirectTo('/001/o', null);
    }


    @TestVisible
    private static SBO_EnosixCustomer_Detail.SALES_DATA findMatchingSalesArea(
            SBO_EnosixCustomer_Detail.EnosixCustomer customer,
            SBO_EnosixCustomer_Detail.EnosixCustomer newPartner)
    {

        List<SBO_EnosixCustomer_Detail.SALES_DATA> customerSalesAreas = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();
        List<SBO_EnosixCustomer_Detail.SALES_DATA> partnerSalesAreas = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();

        if (null != customerSalesAreas)
        {
            customer.SALES_DATA.copyTo(customerSalesAreas);
        }

        if (null != partnerSalesAreas)
        {
            newPartner.SALES_DATA.copyTo(partnerSalesAreas);
        }

        for (SBO_EnosixCustomer_Detail.SALES_DATA customerSalesArea : customerSalesAreas)
        {
            for (SBO_EnosixCustomer_Detail.SALES_DATA partnerSalesArea : partnerSalesAreas)
            {
                if (
                        customerSalesArea.SalesOrganization == partnerSalesArea.SalesOrganization
                                &&
                                customerSalesArea.DistributionChannel == partnerSalesArea.DistributionChannel
                                &&
                                customerSalesArea.Division == partnerSalesArea.Division
                        )
                {
                    return customerSalesArea;
                }
            }
        }
        return null;
    }

    @TestVisible
    private static boolean addPartnerToCustomer(
            SBO_EnosixCustomer_Detail.EnosixCustomer customer,
            SBO_EnosixCustomer_Detail.EnosixCustomer newPartner,
            string function
    )
    {

        SBO_EnosixCustomer_Detail.PARTNERS partner = new SBO_EnosixCustomer_Detail.PARTNERS();

        SBO_EnosixCustomer_Detail.SALES_DATA salesArea = findMatchingSalesArea(customer, newPartner);

        if (null == salesArea)
        {

            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'No matching sales area for partner.'));

            return false;
        }

        partner.SalesOrganization = salesArea.SalesOrganization;
        partner.DistributionChannel = salesArea.DistributionChannel;
        partner.Division = salesArea.Division;
        partner.PartnerFunction = function;
        partner.PartnerNumber = newPartner.CustomerNumber;
        partner.PartnerName = newPartner.Name;
        customer.PARTNERS.add(partner);

        return true;
    }

    public PageReference actionUpdateSapCustomer()
    {
        PageReference result = null;
        SBO_EnosixCustomer_Detail sbo = new SBO_EnosixCustomer_Detail();
        try
        {
            SBO_EnosixCustomer_Detail.EnosixCustomer saveResult = sbo.save(this.cDetail);
            ENSX.EnosixFramework.displayResultMessages(saveResult, ENSX.EnosixFramework.MessageType.INFO);

            if (saveResult.isSuccess())
            {
                this.cDetail = saveResult;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'SAP Customer Updated'));

                if (UTIL_Event.executeEvent(UTIL_Event.CUSTOMER_UPDATED, new Map<String, object>
                {
                        'SBO_EnosixCustomer_Detail.EnosixCustomer' => this.cDetail
                }).isSuccess)
                {
                    result = UTIL_Customer.redirectToDisplayCustomer();
                }
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return result;
    }

    public PageReference actionDisplaySapCustomer()
    {
        return UTIL_Customer.redirectToDisplayCustomer();
    }

    @TestVisible
    private static void AddBPRoleGroups(List<SelectOption> result, List<RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP> roleGroups)
    {
        Set<string> values = new Set<string>();
        for (RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP roleGroup : roleGroups)
        {
            if (String.isNotBlank(roleGroup.RLTGR) && !values.contains(roleGroup.RLTGR))
            {
                result.add(new SelectOption(roleGroup.RLTGR, roleGroup.RLTGRTXT));
                values.add(roleGroup.RLTGR);
            }
        }
    }

    @TestVisible
    private static void AddCountries(List<SelectOption> result, List<RFC_SD_GET_COUNTRIES.ET_OUTPUT> countries)
    {
        for (RFC_SD_GET_COUNTRIES.ET_OUTPUT country : countries)
        {
            result.add(new SelectOption(country.LAND1, country.LANDX));
        }
    }

    @TestVisible
    private static void AddRegionsForCountry(
            List<SelectOption> result,
            List<RFC_SD_GET_COUNTRIES.ET_REGIONS> regions,
            string selectedCountry)
    {
        for (RFC_SD_GET_COUNTRIES.ET_REGIONS region : regions)
        {
            if (selectedCountry == region.LAND1 && string.isNotBlank(region.REGIO))
            {
                result.add(new SelectOption(region.REGIO, region.BEZEI));
            }
        }
    }
}
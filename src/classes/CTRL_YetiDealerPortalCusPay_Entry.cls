public with sharing class CTRL_YetiDealerPortalCusPay_Entry implements CB_CardDetailsReceiver
{
    // TODOS:
    // - Somehow factor out a bunch of the logic duplicated from Customer Detail / Create pages
    // - Consider getting rid of page init trigger and just load data in the constructor
    //    (improved test mocks help this one)

    // Account refrenced from url parameter acctId
    public Account a { get; set; }
    public String customerid {get; private set;}
    public String accountid {get; private set;}
    public String caseid {get; private set;}

    @testVisible
    public SBO_EnosixCustomer_Detail.EnosixCustomer cDetail { get; protected set; }

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

    public CB_CardDetailsReceiver receiver { get; private set; }
    public Boolean isCaptureButtonVisible { get; set; }
    public Boolean isAuthorized { get; set; }
    public Boolean isAuthorizedVisible { get; set; }
    public SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept { get; private set; }
    public Boolean canDisplayPage { get; private set; }

    // ctor
    public CTRL_YetiDealerPortalCusPay_Entry()
    {
        receiver = this;

        this.isCaptureButtonVisible = false;
        this.isAuthorizedVisible = false;
        this.accountid = UTIL_PageState.current.accountId;
        if (null == this.accountid)
        {
            canDisplayPage = false;
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'SAP Customer number not set up for User.  Please contact support.'));
        }
        else
        {
            canDisplayPage = true;
            this.caseid = UTIL_PageState.current.caseId;
            this.customerid = UTIL_PageState.current.customerId;
            this.a = getAccount();
            refreshIdsFromAccount(this.a);
        }
    }

    // This is called as the page inits.
    public System.PageReference initDetail()
    {
        if (string.isNotEmpty(this.customerid))
        {
            this.cDetail = UTIL_Customer.fetchEnosixCustomer(this.customerId);
            if (null == this.cDetail)
            {
                canDisplayPage = false;
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Customer not configured as SAP Customer.'));
            }
        }
        return null;
    }

    public List<SBO_EnosixCustomer_Detail.PAYMENT_DATA> paymentsList
    {
        get
        {
            List<SBO_EnosixCustomer_Detail.PAYMENT_DATA> result = new List<SBO_EnosixCustomer_Detail.PAYMENT_DATA>();
            if (null != this.cDetail)
            {
                this.cDetail.PAYMENT_DATA.copyTo(result);
            }

            return result;
        }
    }

    @testVisible
    private Account getAccount()
    {
        return UTIL_Object_Lookups.getAccountById(this.accountid);
    }

    @testVisible
    private void refreshIdsFromAccount(Account account)
    {
        if (null != account)
        {
            this.accountid = account.id;
            this.customerid = UTIL_Account.getCustomerNumberFromAccount(account);
            if (String.isEmpty(this.customerid))
            {
                canDisplayPage = false;
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Account not configured as SAP Customer.'));
            }
        }
    }

    public void onReceiveCardDetails(SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept)
    {
        this.isCaptureButtonVisible = false;
        this.intercept = intercept;
        this.isAuthorized = null;
        this.isAuthorizedVisible = false;
    }

    public void onInitCardDetails(SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept)
    {
        this.isCaptureButtonVisible = true;
        this.intercept = null;
        this.isAuthorized = null;
        this.isAuthorizedVisible = false;
    }

    public void actionAuthCard()
    {
        if (null == this.intercept || null == this.cDetail)
        {
            return;
        }

        this.isAuthorized = authorizePayment(this.intercept.RESPONSE);
        this.isAuthorizedVisible = true;
    }

    public void actionAddCard()
    {
        if (null == this.intercept || null == this.cDetail)
        {
            return;
        }
        
        addPaymentMethod(intercept.RESPONSE);
        this.isAuthorized = null;
        this.isAuthorizedVisible = false;
        this.intercept = null;
    }

    public void actionRemoveCard()
    {
        String cardNumber = System.currentPageReference().getParameters().get('cardNumber');
        if (string.isBlank(cardNumber) || null == this.cDetail)
        {
            return;
        }

        SBO_EnosixCustomer_Detail.EnosixCustomer result = removeCardFromCustomer(cardNumber);
        if (result != null)
        {
            this.cDetail = result;
        }
    }

    public void actionSelectDefault()
    {
        String cardNumber = System.currentPageReference().getParameters().get('cardNumber');
        if (String.isBlank(cardNumber) || null == this.cDetail)
        {
            return;
        }
        SBO_EnosixCustomer_Detail.EnosixCustomer result = selectDefaultCard(cardNumber);
        System.debug('Result: ' + result);
        if (result != null)
        {
            this.cDetail = result;
        }
    }

    @testVisible
    private void addPaymentMethod(SBO_EnosixXiIntercept_Detail.RESPONSE details)
    {
        // Get a fresh copy of customer so we don't edit the one already displayed in the page
        SBO_EnosixCustomer_Detail.EnosixCustomer editCustomer =
            UTIL_Customer.fetchEnosixCustomer(this.customerId);

        UTIL_PaymentCards.addCardToCustomer(details, editCustomer);

        SBO_EnosixCustomer_Detail.EnosixCustomer result = UTIL_Customer.saveCustomer(editCustomer);
        if (result != null)
        {
            // Update the displayed customer information
            this.cDetail = result;
        }
    }

    @testVisible
    private boolean authorizePayment(SBO_EnosixXiIntercept_Detail.RESPONSE details)
    {
        // TODO: Rewrite this to use command version instead of getDetail version
        SBO_EnosixCCPreauth_Detail sbo = new SBO_EnosixCCPreauth_Detail();
        SBO_EnosixCCPreauth_Detail.EnosixCCPreauth preauth = new SBO_EnosixCCPreauth_Detail.EnosixCCPreauth();

        // Construct a datetime of the exp date
        DateTime validTo = DateTime.newInstance(
            integer.valueOf(details.ValidToYear),
            integer.valueOf(details.ValidToMonth),
            1
        );

        // TYPE/NUM/CCV/MMYYYY
        String authString = string.format('{0}/{1}/{2}/{3}', new String[]{
            details.SAPCardType,
            details.CreditCardNumber,
            details.CardVerificationValue,
            validTo.format('MMYYYY')
        });

        SBO_EnosixCCPreauth_Detail.EnosixCCPreauth result = null;
        try
        {
            result = sbo.getDetail(authString);
        }
        catch (Exception e)
        {
            System.debug('showing auth problem as exception');
            displayException(e);
            return false;
        }

        if (!result.isSuccess())
        {
            System.debug('showing auth problem as no success');
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
            return false;
        }

        if ('A' != result.RESPONSE.AuthorizationResponse)
        {
            System.debug('showing auth problem as not authorized');
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.INFO, result.RESPONSE.ResultCodeText);
            return false;
        }

        return true;
    }

    @testVisible
    private SBO_EnosixCustomer_Detail.EnosixCustomer removeCardFromCustomer(string cardNumber)
    {
        // Get a fresh copy of customer so we don't edit the one already displayed in the page
        SBO_EnosixCustomer_Detail.EnosixCustomer editCustomer =
            UTIL_Customer.fetchEnosixCustomer(this.customerId);

        if (!UTIL_PaymentCards.removeCardFromCustomer(editCustomer, cardNumber))
        {
            return null;
        }

        SBO_EnosixCustomer_Detail.EnosixCustomer result = UTIL_Customer.saveCustomer(editCustomer);
        return result;
    }

    private SBO_EnosixCustomer_Detail.EnosixCustomer selectDefaultCard(String cardNumber)
    {
        SBO_EnosixCustomer_Detail.EnosixCustomer editCustomer =
            UTIL_Customer.fetchEnosixCustomer(this.customerId);

        selectDefaultPaymentCard(editCustomer, cardNumber);   
        SBO_EnosixCustomer_Detail.EnosixCustomer result = UTIL_Customer.saveCustomer(editCustomer);
        return result;
    }

    // TODO Might need to move this method to UTIL_PaymentCards in PDE
    // Just like the other methods
    private void selectDefaultPaymentCard(SBO_EnosixCustomer_Detail.EnosixCustomer customer, String cardNumber)
    {
        List<SBO_EnosixCustomer_Detail.PAYMENT_DATA> cards = new List<SBO_EnosixCustomer_Detail.PAYMENT_DATA>();

        customer.PAYMENT_DATA.copyTo(cards);

        for (SBO_EnosixCustomer_Detail.PAYMENT_DATA card : cards) { 
            card.DefaultPaymentCard = '';           
            if (cardNumber == card.CardNumber) {
                card.DefaultPaymentCard = 'X';  
            }        
        }
    }

    @testVisible
    static void displayException(Exception e)
    {
        if (null == e) return;
        ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
        ApexPages.addMessage(message);
    }
}
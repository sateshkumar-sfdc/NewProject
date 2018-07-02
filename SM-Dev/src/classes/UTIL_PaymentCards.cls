public class UTIL_PaymentCards {

  /* Adds a captured tokenized payment card from paymetric to a sales order */
    public static void addCardToOrder(
            SBO_EnosixXiIntercept_Detail.RESPONSE response,
            SBO_EnosixSO_Detail.EnosixSO order, Decimal cardLimit) {

        SBO_EnosixSO_Detail.CCARD card = new SBO_EnosixSO_Detail.CCARD();

        card.CreditCardType = response.SAPCardType;
        card.CreditCardNumber = response.CreditCardNumber;
        card.ValidToDate = Date.newInstance(
                integer.valueOf(response.ValidToYear),
                integer.valueOf(response.ValidToMonth),
                1);
        card.PaymentCardSuffix = response.CardVerificationValue;
        card.CardHolderName = response.CreditCardHolder;
        if (UTIL_Order.isCardLimitEnabled)
        {
            card.BillAmount = cardLimit;
        }
        order.CCARD.add(card);
    }

  /* Removes a payment card from a sales order */
    public static boolean removeCardFromOrder(
            SBO_EnosixSO_Detail.EnosixSO order, string cardNumber) {

        List<SBO_EnosixSO_Detail.CCARD> cards = new List<SBO_EnosixSO_Detail.CCARD>();

        order.CCARD.copyTo(cards);

        for (SBO_EnosixSO_Detail.CCARD card : cards) {
            if (cardNumber == card.CreditCardNumber) {
                order.CCARD.remove(card);
                return true;
            }
        }

        return false;
    }
    /* Adds a captured tokenized payment card from paymetric to a quote */
    public static void addCardToQuote(
            SBO_EnosixXiIntercept_Detail.RESPONSE response,
            SBO_EnosixQuote_Detail.EnosixQuote quote, Decimal cardLimit) {
        SBO_EnosixQuote_Detail.CCARD card = new SBO_EnosixQuote_Detail.CCARD();

        card.CreditCardType = response.SAPCardType;
        card.CreditCardNumber = response.CreditCardNumber;
        card.ValidToDate = Date.newInstance(
                integer.valueOf(response.ValidToYear),
                integer.valueOf(response.ValidToMonth),
                1);
        card.PaymentCardSuffix = response.CardVerificationValue;
        card.CardHolderName = response.CreditCardHolder;
        if (UTIL_Order.isCardLimitEnabled)
        {
            card.BillAmount = cardLimit;
        }
        quote.CCARD.add(card);
    }

  /* Removes a payment card from a sales order */
    public static boolean removeCardFromQuote(
            SBO_EnosixQuote_Detail.EnosixQuote quote, string cardNumber) {

        List<SBO_EnosixQuote_Detail.CCARD> cards = new List<SBO_EnosixQuote_Detail.CCARD>();

        quote.CCARD.copyTo(cards);

        for (SBO_EnosixQuote_Detail.CCARD card : cards) {
            if (cardNumber == card.CreditCardNumber) {
                quote.CCARD.remove(card);
                return true;
            }
        }

        return false;
    }

    public static void addCardToReturnOrder(SBO_EnosixXiIntercept_Detail.RESPONSE response, SBO_EnosixRO_Detail.EnosixRO order, Decimal cardLimit) {

        SBO_EnosixRO_Detail.CCARD card = new SBO_EnosixRO_Detail.CCARD();

        card.CreditCardType = response.SAPCardType;
        card.CreditCardNumber = response.CreditCardNumber;
        card.ValidToDate = Date.parse(response.ValidToMonth + '/01/' + response.ValidToYear);
        card.PaymentCardSuffix = response.CardVerificationValue;
        card.CardHolderName = response.CreditCardHolder;
        if (UTIL_Order.isCardLimitEnabled)
        {
            card.BillAmount = cardLimit;
        }
        order.CCARD.add(card);
    }

    public static boolean removeCardFromReturnOrder(
            SBO_EnosixRO_Detail.EnosixRO order, string cardNumber) {

        List<SBO_EnosixRO_Detail.CCARD> cards = new List<SBO_EnosixRO_Detail.CCARD>();

        order.CCARD.copyTo(cards);

        for (SBO_EnosixRO_Detail.CCARD card : cards) {
            if (cardNumber == card.CreditCardNumber) {
                order.CCARD.remove(card);
                return true;
            }
        }

        return false;
    }

    public static void addCustomerCardToOrder(
        SBO_EnosixCustomer_Detail.PAYMENT_DATA payment,
        SBO_EnosixSO_Detail.EnosixSO order,
        Decimal cardLimit)
    {
        SBO_EnosixSO_Detail.CCARD card = new SBO_EnosixSO_Detail.CCARD();

        card.CreditCardType = payment.PaymentCardType;
        card.CreditCardNumber = payment.CardNumber;
        card.ValidToDate = payment.ValidToDate;
        card.CardHolderName = payment.CardHolderName;
        if (UTIL_Order.isCardLimitEnabled)
        {
            card.BillAmount = cardLimit;
        }
        order.CCARD.add(card);
    }
    public static void addCustomerCardToQuote(
            SBO_EnosixCustomer_Detail.PAYMENT_DATA payment,
            SBO_EnosixQuote_Detail.EnosixQuote quote,
        Decimal cardLimit)
    {
        SBO_EnosixQuote_Detail.CCARD card = new SBO_EnosixQuote_Detail.CCARD();

        card.CreditCardType = payment.PaymentCardType;
        card.CreditCardNumber = payment.CardNumber;
        card.ValidToDate = payment.ValidToDate;
        card.CardHolderName = payment.CardHolderName;
        if (UTIL_Order.isCardLimitEnabled)
        {
            card.BillAmount = cardLimit;
        }
        quote.CCARD.add(card);
    }

    public static void addCustomerCardToReturnOrder(
        SBO_EnosixCustomer_Detail.PAYMENT_DATA payment,
        SBO_EnosixRO_Detail.EnosixRO order,
        Decimal cardLimit)
    {
        SBO_EnosixRO_Detail.CCARD card = new SBO_EnosixRO_Detail.CCARD();

        card.CreditCardType = payment.PaymentCardType;
        card.CreditCardNumber = payment.CardNumber;
        card.ValidToDate = payment.ValidToDate;
        card.CardHolderName = payment.CardHolderName;
        if (UTIL_Order.isCardLimitEnabled)
        {
            card.BillAmount = cardLimit;
        }
        order.CCARD.add(card);
    }

    public static void addCardToCustomer(
        SBO_EnosixXiIntercept_Detail.RESPONSE response,
        SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        SBO_EnosixCustomer_Detail.PAYMENT_DATA paymentData = new SBO_EnosixCustomer_Detail.PAYMENT_DATA();

        paymentData.CardNumber = response.CreditCardNumber;
        paymentData.PaymentCardType = response.SAPCardType;
        paymentData.CardHolderName = response.CreditCardHolder;
        paymentData.CardCategory = '01';
        paymentData.ValidFromDate = Date.today();
        paymentData.ValidToDate = Date.newInstance(
            integer.valueOf(response.ValidToYear),
            integer.valueOf(response.ValidToMonth),
            1
        );
        customer.PAYMENT_DATA.add(paymentData);
    }

    public static boolean removeCardFromCustomer(
            SBO_EnosixCustomer_Detail.EnosixCustomer customer, string cardNumber) {

        List<SBO_EnosixCustomer_Detail.PAYMENT_DATA> cards = new List<SBO_EnosixCustomer_Detail.PAYMENT_DATA>();

        customer.PAYMENT_DATA.copyTo(cards);

        for (SBO_EnosixCustomer_Detail.PAYMENT_DATA card : cards) {
            if (cardNumber == card.CardNumber) {
                card.X_RemoveCard = 'X';
                return true;
            }
        }

        return false;
    }

  /* Constructs the IFrame url using the access token information */
    public static string getPaymetricTargetUrl(
            SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept) {

        if (null == intercept) {
            return '';
        }

        string result = string.format('{0}/view/iframe/{1}/{2}/True', new string[]{
                intercept.XiInterceptURL,
                intercept.MerchantGUID,
                intercept.AccessToken
        });

        return result;
    }

  /* Retrieves the card details from paymetric using the access token */
    public static SBO_EnosixXiIntercept_Detail.EnosixXiIntercept getCardInfo(
            SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept
    ) {

        SBO_EnosixXiIntercept_Detail sbo = new SBO_EnosixXiIntercept_Detail();

        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = sbo.command('CMD_ENCRYPT_CCARD', intercept);

        if (!result.IsSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
            return intercept;
        }

        return result;

    }

  /* Loads the default paramets from the sap configuration */
    public static SBO_EnosixXiIntercept_Detail.EnosixXiIntercept initEnosixXiIntercept() {
        SBO_EnosixXiIntercept_Detail sbo = new SBO_EnosixXiIntercept_Detail();

        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();

        result = sbo.initialize(result);

        if (!result.IsSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }

        return result;

    }

  /* Retrieves an access token 'session' from the paymetric service */
    public static SBO_EnosixXiIntercept_Detail.EnosixXiIntercept getAccessToken(
            SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept) {

        SBO_EnosixXiIntercept_Detail sbo = new SBO_EnosixXiIntercept_Detail();

        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = sbo.command('CMD_ACCESS_TOKEN', intercept);

        if (!result.IsSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }
        return result;
    }

    // Returns SelectOptions of PAYMENT_DATA for a fully initialized customer detail object
    public static List<SelectOption> getPaymentCardSelectOptionsForCustomer(
        SBO_EnosixCustomer_Detail.EnosixCustomer customerDetail)
    {
            List<SBO_EnosixCustomer_Detail.PAYMENT_DATA> items = new List<SBO_EnosixCustomer_Detail.PAYMENT_DATA>();
            customerDetail.PAYMENT_DATA.copyTo(items);

            PaymentCardOptionBuilder optionBulder = new PaymentCardOptionBuilder();
            return UTIL_SelectOption.buildOptionsFromList(optionBulder, items);
    }

    class PaymentCardOptionBuilder extends UTIL_SelectOption.OptionBuilder {
        public override string getItemValue(object item){
            return ((SBO_EnosixCustomer_Detail.PAYMENT_DATA)item).CardNumber;
        }

        public override string getItemDescription(object item) {
            SBO_EnosixCustomer_Detail.PAYMENT_DATA card = (SBO_EnosixCustomer_Detail.PAYMENT_DATA)item;
            return string.format('{0} - {1}', new string[]{card.PaymentCardType, card.CardNumber});
        }

        // don't allow base classes to display KEY - Desc. We need only Des. for the formatting
        // to appear correct
        public override string getItemLabel(object item) {
            return getItemDescription(item);
        }
    }
}
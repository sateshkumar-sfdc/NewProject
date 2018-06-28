public with sharing class CTRL_Quote_Detail {

    // Sales Order Detail
    public SBO_EnosixQuote_Detail.EnosixQuote quoteDetail { get; private set; }

    // Selected Line Item
    public SBO_EnosixQuote_Detail.ITEMS SelectedItem { get; private set; }

    public string OpportunityID { get; private set; }

    public CTRL_Quote_Detail() {
        if (!Test.isRunningTest()) {
            init();
        }
    }

    public void init() {
        if (null != UTIL_PageState.current.quoteId)
            this.quoteDetail = getQuoteFromOrderNumber(UTIL_PageState.current.quoteId);

        this.opportunityID = UTIL_PageState.current.opportunityId;

        // Select line item from item number parameter
        if (null != this.quoteDetail && null != UTIL_PageState.current.itemNum)
            this.SelectedItem = getItemFromOrderByItemNumber(
                this.quoteDetail, UTIL_PageState.current.itemNum);
    }

    // Item select action
    public void ItemDetailPage() {
        String itemnumber = System.currentPageReference().getParameters().get('itemnumber');
        this.SelectedItem = getItemFromOrderByItemNumber(this.quoteDetail, itemnumber);
    }

    // Item list
    public List<UTIL_Order.QuoteItem> Items {
        get
        {
            return UTIL_Order.convertQuoteDetailToQuoteItem(this.quoteDetail);
        }
    }

    // Partners list
    public List<SBO_EnosixQuote_Detail.PARTNERS> Partners {
        get {
            List<SBO_EnosixQuote_Detail.PARTNERS> result = new List<SBO_EnosixQuote_Detail.PARTNERS>();

            if (null != this.quoteDetail) {
                this.quoteDetail.PARTNERS.copyTo(result);
            }

            return result;
        }
    }

    // Selected item schedule list
    public List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> SelectedItemSchedule {
        get {
            List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> result = new List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE>();

            if (null != this.quoteDetail) {
                addSelectedItemsSchedule(result, this.quoteDetail, this.SelectedItem);
            }

            return result;
        }
    }

    // Selected item pricing conditions list
    public List<SBO_EnosixQuote_Detail.CONDITIONS> SelectedConditions {
        get {
            List<SBO_EnosixQuote_Detail.CONDITIONS> result = new List<SBO_EnosixQuote_Detail.CONDITIONS>();

            addSelectedConditions(result, this.quoteDetail, this.SelectedItem);

            return result;
        }
    }

    // Credit Card Details
    public List<SBO_EnosixQuote_Detail.CCARD> PaymentCards {
        get {
            List<SBO_EnosixQuote_Detail.CCARD> result = new List<SBO_EnosixQuote_Detail.CCARD>();

            if (null != this.quoteDetail) {
                this.quoteDetail.CCARD.copyTo(result);
            }

            return result;
        }
    }

    @testVisible
    private static SBO_EnosixQuote_Detail.EnosixQuote getQuoteFromOrderNumber(string orderNumber) {
        SBO_EnosixQuote_Detail sbo = new SBO_EnosixQuote_Detail();

        SBO_EnosixQuote_Detail.EnosixQuote result = sbo.getDetail(orderNumber);

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
        }

        return result;
    }

    @testVisible
    private static SBO_EnosixQuote_Detail.ITEMS getItemFromOrderByItemNumber(SBO_EnosixQuote_Detail.EnosixQuote salesOrder, string itemNumber) {
        List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();

        if (null != salesOrder) {
            salesOrder.ITEMS.copyTo(items);
        }

        for (SBO_EnosixQuote_Detail.ITEMS item : Items) {
            if (itemNumber == item.ItemNumber) {
                return item;
            }
        }

        return null;
    }

    @testVisible
    private static void addSelectedItemsSchedule(List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> result, SBO_EnosixQuote_Detail.EnosixQuote salesOrder, SBO_EnosixQuote_Detail.ITEMS item) {
        if (null == result || null == salesOrder || null == item) return;

        List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> schedules = new List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE>();

        salesOrder.ITEMS_SCHEDULE.copyTo(schedules);

        for (SBO_EnosixQuote_Detail.ITEMS_SCHEDULE schedule : schedules) {
            if (schedule.ItemNumber == item.ItemNumber) {
                result.add(schedule);
            }
        }
    }

    @testVisible
    private static void addSelectedConditions(List<SBO_EnosixQuote_Detail.CONDITIONS> result, SBO_EnosixQuote_Detail.EnosixQuote salesOrder, SBO_EnosixQuote_Detail.ITEMS item) {
        if (null == result || null == salesOrder || null == item) return;

        List<SBO_EnosixQuote_Detail.CONDITIONS> conditions = new List<SBO_EnosixQuote_Detail.CONDITIONS>();

        salesOrder.CONDITIONS.copyTo(conditions);

        for (SBO_EnosixQuote_Detail.CONDITIONS condition : conditions) {
            if (condition.ConditionItemNumber == item.ItemNumber) {
                result.add(condition);
            }
        }
    }

    public PageReference gotoCustomerPage() {
        String selectedCustomerId = System.currentPageReference().getParameters().get('selectedCustomerId');
        UTIL_PageState.current.customerId = selectedCustomerId;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_CustomerDetail, UTIL_PageState.current);
    }
}
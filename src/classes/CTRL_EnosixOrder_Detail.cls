/**
 * OrderDetail page controller class displays sales order detail section + the item listing section
 *
 * this page is also used by QuoteDetail page
 *
 * This controller also handles the item detail page displaying and item detail editing as well.
 * Because Item detail information is retrieved in the same webservice call, keeping controller in the same class prevents us from calling the webservice again
 *
 */
public with sharing class CTRL_EnosixOrder_Detail {

    // Sales Order Detail
    public SBO_EnosixSO_Detail.EnosixSO orderDetail { get; private set; }

    // Selected Line Item
    public SBO_EnosixSO_Detail.ITEMS SelectedItem { get; private set; }

    public string OpportunityID { get; private set; }

    public CTRL_EnosixOrder_Detail() {
        if (!Test.isRunningTest()) {
            init();
        }
    }

    public void init() {
        if (null != UTIL_PageState.current.orderNum) {
            this.orderDetail = getSalesOrderFromOrderNumber(UTIL_PageState.current.orderNum);
        }
        if (null != UTIL_PageState.current.opportunityId) {
            this.opportunityID = UTIL_PageState.current.opportunityId;
        }

        // Select line item from item number parameter
        if (null != this.orderDetail && UTIL_PageState.current.itemNum != null) {
            this.SelectedItem = getItemFromOrderByItemNumber(this.orderDetail, UTIL_PageState.current.itemNum);
        }
    }

    // Item select action
    public void ItemDetailPage() {
        String itemnumber = System.currentPageReference().getParameters().get('itemnumber');
        this.SelectedItem = getItemFromOrderByItemNumber(this.orderDetail, itemnumber);
    }

    // Item list
    public List<UTIL_Order.OrderItem> Items {
        get 
        {
                return UTIL_Order.convertOrderDetailToOrderItem(this.orderDetail);
        }
    }

    // Partners list
    public List<SBO_EnosixSO_Detail.PARTNERS> Partners {
        get {
            List<SBO_EnosixSO_Detail.PARTNERS> result = new List<SBO_EnosixSO_Detail.PARTNERS>();

            if (null != this.orderDetail) {
                this.orderDetail.PARTNERS.copyTo(result);
            }

            return result;
        }
    }

    // Selected item schedule list
    public List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> SelectedItemSchedule {
        get {
            List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> result = new List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE>();

            if (null != this.orderDetail) {
                addSelectedItemsSchedule(result, this.orderDetail, this.SelectedItem);
            }

            return result;
        }
    }

    // Selected item pricing conditions list
    public List<SBO_EnosixSO_Detail.CONDITIONS> SelectedConditions {
        get {
            List<SBO_EnosixSO_Detail.CONDITIONS> result = new List<SBO_EnosixSO_Detail.CONDITIONS>();

            addSelectedConditions(result, this.orderDetail, this.SelectedItem);

            return result;
        }
    }

    // Credit Card Details
    public List<SBO_EnosixSO_Detail.CCARD> PaymentCards {
        get {
            List<SBO_EnosixSO_Detail.CCARD> result = new List<SBO_EnosixSO_Detail.CCARD>();

            if (null != this.orderDetail) {
                this.orderDetail.CCARD.copyTo(result);
            }

            return result;
        }
    }

    @testVisible
    private static SBO_EnosixSO_Detail.EnosixSO getSalesOrderFromOrderNumber(string orderNumber) {
        SBO_EnosixSO_Detail sbo = new SBO_EnosixSO_Detail();

        SBO_EnosixSO_Detail.EnosixSO result = sbo.getDetail(orderNumber);

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
        }

        return result;
    }

    @testVisible
    private static SBO_EnosixSO_Detail.ITEMS getItemFromOrderByItemNumber(SBO_EnosixSO_Detail.EnosixSO salesOrder, string itemNumber) {
        List<SBO_EnosixSO_Detail.ITEMS> items = new List<SBO_EnosixSO_Detail.ITEMS>();

        if (null != salesOrder) {
            salesOrder.ITEMS.copyTo(items);
        }

        for (SBO_EnosixSO_Detail.ITEMS item : Items) {
            if (itemNumber == item.ItemNumber) {
                return item;
            }
        }

        return null;
    }

    @testVisible
    private static void addSelectedItemsSchedule(List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> result, SBO_EnosixSO_Detail.EnosixSO salesOrder, SBO_EnosixSO_Detail.ITEMS item) {
        if (null == result || null == salesOrder || null == item) return;

        List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> schedules = new List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE>();

        salesOrder.ITEMS_SCHEDULE.copyTo(schedules);

        for (SBO_EnosixSO_Detail.ITEMS_SCHEDULE schedule : schedules) {
            if (schedule.ItemNumber == item.ItemNumber) {
                result.add(schedule);
            }
        }
    }

    @testVisible
    private static void addSelectedConditions(List<SBO_EnosixSO_Detail.CONDITIONS> result, SBO_EnosixSO_Detail.EnosixSO salesOrder, SBO_EnosixSO_Detail.ITEMS item) {
        if (null == result || null == salesOrder || null == item) return;

        List<SBO_EnosixSO_Detail.CONDITIONS> conditions = new List<SBO_EnosixSO_Detail.CONDITIONS>();

        salesOrder.CONDITIONS.copyTo(conditions);

        for (SBO_EnosixSO_Detail.CONDITIONS condition : conditions) {
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

    public PageReference goToOpportunityPage() {
        return UTIL_PageFlow.redirectTo('/' + opportunityID, null);
    }

    public PageReference goToCreateOrderPage() {
        UTIL_PageState.current.opportunityId = OpportunityID;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_OrderCreate, UTIL_PageState.current);
    }
}
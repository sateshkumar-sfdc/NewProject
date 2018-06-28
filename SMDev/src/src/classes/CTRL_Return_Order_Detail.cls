public with sharing class CTRL_Return_Order_Detail {

    public class ITEM {
        public SBO_EnosixRO_Detail.ITEMS returnItem { get; private set; }
        public SBO_EnosixRO_Detail.ITEMS_ARM replaceItem { get; private set; }

        public ITEM ( SBO_EnosixRO_Detail.ITEMS selectedItem, SBO_EnosixRO_Detail.ITEMS_ARM replacementItem )
        {
            returnItem = selectedItem;
            replaceItem = replacementItem;
        }
    }

    // Sales Order Detail
    public SBO_EnosixRO_Detail.EnosixRO returnOrderDetail { get; private set; }
    public SBO_EnosixRO_Detail.SALES rmaSaleData {
        get {
            return returnOrderDetail.SALES;
        }
        set {
            SBO_EnosixRO_Detail.SALES sales = returnOrderDetail.SALES;
            sales = value;
        }
    }

    public SBO_EnosixRO_Detail.ITEMS_ARM SelectedReplacmentItem { get; private set; }

    // Selected Line Item
    public SBO_EnosixRO_Detail.ITEMS SelectedItem { get; private set; }

    public CTRL_Return_Order_Detail() {
        if (!Test.isRunningTest()) {
            init();
        }
    }
    public void init() {
        if (string.isNotBlank(UTIL_PageState.current.rmaId))
            this.returnOrderDetail = UTIL_Order.getReturnOrderForId(UTIL_PageState.current.rmaId);
    }

    public List<ITEM> DisplayItems {
        get {
            system.debug('Getting Display Items');
            List<ITEM> result = new List<ITEM>();
            List<SBO_EnosixRO_Detail.ITEMS_ARM> items_arm_list = new List<SBO_EnosixRO_Detail.ITEMS_ARM>();
            List<SBO_EnosixRO_Detail.ITEMS> items = this.Items;

            if (null != this.returnOrderDetail) {
                this.returnOrderDetail.ITEMS_ARM.copyTo(items_arm_list);
            }

            for(SBO_EnosixRO_Detail.ITEMS item : items)
            {
                system.debug('Item Number:' + item.ItemNumber);
                system.debug('Material Description:' + item.Material);
                SBO_EnosixRO_Detail.ITEMS_ARM returnItem = new SBO_EnosixRO_Detail.ITEMS_ARM();
                system.debug('Looking For Matching Item');
                for(SBO_EnosixRO_Detail.ITEMS_ARM item_arm : items_arm_list)
                {

                    system.debug('Item Arm Number:' + item_arm.Item);

                    if(item.ItemNumber == item_arm.Item)
                    {
                        system.debug('Found Matching Item');
                        system.debug('Replacment Material:' + item_arm.ReplacementMaterial );
                        system.debug('Replacement Material Description:' + item_arm.ReplaceMaterialDescription);
                        returnItem = item_arm;
                    }
                }
                ITEM newItem = new ITEM(item,returnItem);
                system.debug('Item Number:' + newItem.returnItem.ItemNumber);
                system.debug('Replacement Material:' + newItem.replaceItem.ReplacementMaterial);
                system.debug('Replacement Material Description:' + newItem.replaceItem.ReplaceMaterialDescription);
                result.add(newItem);
            }

            return result;
        }
    }

    // Item list
    public List<SBO_EnosixRO_Detail.ITEMS> Items {
        get {
            List<SBO_EnosixRO_Detail.ITEMS> result = new List<SBO_EnosixRO_Detail.ITEMS>();

            if (null != this.returnOrderDetail) {
                this.returnOrderDetail.ITEMS.copyTo(result);
            }

            return result;
        }
    }

    // Partners list
    public List<SBO_EnosixRO_Detail.PARTNERS> Partners {
        get {
            List<SBO_EnosixRO_Detail.PARTNERS> result = new List<SBO_EnosixRO_Detail.PARTNERS>();

            if (null != this.returnOrderDetail) {
                this.returnOrderDetail.PARTNERS.copyTo(result);
            }

            return result;
        }
    }
    public List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE> SelectedItemSchedule {
        get {
            List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE> result = new List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE>();

            if (null != this.returnOrderDetail) {
                addSelectedItemsSchedule(result, this.returnOrderDetail, this.SelectedItem);
            }

            return result;
        }
    }
    public List<SBO_EnosixRO_Detail.CCARD> RMACards {
        get {
            List<SBO_EnosixRO_Detail.CCARD> result = new List<SBO_EnosixRO_Detail.CCARD>();

            if (null != this.returnOrderDetail) {
                this.returnOrderDetail.CCARD.copyTo(result);
            }

            return result;
        }
    }

    // Selected item pricing conditions list
    public List<SBO_EnosixRO_Detail.CONDITIONS> SelectedConditions {
        get {
            List<SBO_EnosixRO_Detail.CONDITIONS> result = new List<SBO_EnosixRO_Detail.CONDITIONS>();

            addSelectedConditions(result, this.returnOrderDetail, this.SelectedItem);

            return result;
        }
    }
    public PageReference gotoCustomerPage() {
        String selectedCustomerId = System.currentPageReference().getParameters().get('selectedCustomerId');
        UTIL_PageState.current.customerId = selectedCustomerId;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_CustomerDetail, UTIL_PageState.current);
    }

    public PageReference gotoCase() {
        return UTIL_PageFlow.redirectTo('/' + UTIL_PageState.current.caseId, null);
    }

    // Item select action
    public void ItemDetailPage() {
        String itemnumber = System.currentPageReference().getParameters().get('itemnumber');
        this.SelectedItem = getItemFromOrderByItemNumber(this.returnOrderDetail, itemnumber);
        this.SelectedReplacmentItem = getReplacementItemFromOrderByItemNumber(this.returnOrderDetail,itemnumber);
    }
    @testVisible
    private static SBO_EnosixRO_Detail.ITEMS getItemFromOrderByItemNumber(SBO_EnosixRO_Detail.EnosixRO salesOrder, string itemNumber) {
        List<SBO_EnosixRO_Detail.ITEMS> items = new List<SBO_EnosixRO_Detail.ITEMS>();

        if (null != salesOrder) {
            salesOrder.ITEMS.copyTo(items);
        }

        for (SBO_EnosixRO_Detail.ITEMS item : Items) {
            if (itemNumber == item.ItemNumber) {
                return item;
            }
        }

        return null;
    }

    @testVisible
    private static SBO_EnosixRO_Detail.ITEMS_ARM getReplacementItemFromOrderByItemNumber(SBO_EnosixRO_Detail.EnosixRO salesOrder, string itemNumber) {
        List<SBO_EnosixRO_Detail.ITEMS_ARM> replacement_items = new List<SBO_EnosixRO_Detail.ITEMS_ARM>();

        if (null != salesOrder) {
            salesOrder.ITEMS_ARM.copyTo(replacement_items);
        }

        for (SBO_EnosixRO_Detail.ITEMS_ARM item : replacement_items) {
            if (itemNumber == item.Item) {
                return item;
            }
        }

        return null;
    }

    @testVisible
    private static void addSelectedItemsSchedule(List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE> result, SBO_EnosixRO_Detail.EnosixRO salesOrder, SBO_EnosixRO_Detail.ITEMS item) {
        if (null == result || null == salesOrder || null == item) return;

        List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE> schedules = new List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE>();

        salesOrder.ITEMS_SCHEDULE.copyTo(schedules);

        for (SBO_EnosixRO_Detail.ITEMS_SCHEDULE schedule : schedules) {
            if (schedule.ItemNumber == item.ItemNumber) {
                result.add(schedule);
            }
        }
    }
    @testVisible
    private static void addSelectedConditions(List<SBO_EnosixRO_Detail.CONDITIONS> result, SBO_EnosixRO_Detail.EnosixRO salesOrder, SBO_EnosixRO_Detail.ITEMS item) {
        if (null == result || null == salesOrder || null == item) return;

        List<SBO_EnosixRO_Detail.CONDITIONS> conditions = new List<SBO_EnosixRO_Detail.CONDITIONS>();

        salesOrder.CONDITIONS.copyTo(conditions);

        for (SBO_EnosixRO_Detail.CONDITIONS condition : conditions) {
            if (condition.ConditionItemNumber == item.ItemNumber) {
                result.add(condition);
            }
        }
    }
}
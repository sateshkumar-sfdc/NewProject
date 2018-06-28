// This is a clone of CTRL_Return_Order_Create from PDE v2.1.2
// Added ATP date to display on the line items

public with sharing class CTRL_Return_Order_Create
    implements CB_CardDetailsReceiver, CB_MaterialSearchReceiver
{
    private final SelectOption defaultOrderType = new SelectOption('ZARM', 'Default Order Type');
    private final SelectOption defaultDistributionChannel = new SelectOption('10', 'Default Distribution');
    private final SelectOption defaultDivision = new SelectOption('00', 'Default Division');
    private final SelectOption defaultSalesOrganization = new SelectOption('1010', 'Default Sales Organization');

    private SelectOption caseCustomerSelectOption;
    public Case cas { get; set; }
    public string accountId { get {return cas != null && cas.AccountId != null ? string.valueOf(cas.AccountId) : '';} }
    public Boolean hasAccount{ get { return String.isNotEmpty(accountId); } }
    public String RefundType { get; set; }
    public SBO_EnosixRO_Detail.EnosixRO rmaDetail { get; set; }
    public SBO_EnosixCustomer_Detail.EnosixCustomer customerDetail { get; set; }

    public SBO_EnosixCustomer_Detail.SALES_DATA customerSalesArea
    {
        get
        {
            return (SBO_EnosixCustomer_Detail.SALES_DATA) customerDetail.SALES_DATA.get(0);
        }
    }

    public SBO_EnosixCustomer_Detail.EnosixCustomer shipToCustomer { get; set; }

    public SBO_EnosixRO_Detail.SALES rmaSaleData {
        get {
            return rmaDetail.SALES;
        }
        set {
            SBO_EnosixRO_Detail.SALES sales = rmaDetail.SALES;
            sales = value;
        }
    }

    public List<SBO_EnosixRO_Detail.ITEMS_ARM> replacementItems { get; set; }
    public List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE> itemSchedules { get; set; }

    // wraps replacementItems with to add an index and a date formatting helper
    @testVisible
    class IndexedItem
    {
        public Integer index { get; set; }
        public SBO_EnosixRO_Detail.ITEMS_ARM item { get; set; }  
        public SBO_EnosixRO_Detail.ITEMS_SCHEDULE itemSchedule { get; set; }

        public String atpDate
        {
            get
            {
                try
                {
                    String result = DateTime.newInstance(
                        itemSchedule.ScheduleLineDate.year(),
                        itemSchedule.ScheduleLineDate.month(),
                        itemSchedule.ScheduleLineDate.day()
                    ).format('MM/dd/YYYY');
                    return result;
                }
                catch (Exception ex)
                {
                    System.debug(ex);
                    return '';
                }                
            }
            set;
        }

        public String formattedScheduleLineDate
        {
            get
            {
                try
                {
                    String result = String.format('{0}/{1}/{2}', new String[] {
                        item.ScheduleLineDate.substring(4, 6),
                        item.ScheduleLineDate.substring(6, 8),
                        item.ScheduleLineDate.substring(0, 4)
                    });
                    System.debug('View wants date. Converting ' +
                        item.ScheduleLineDate + ' to ' + result);
                    return result;
                }
                catch (Exception ex)
                {
                    System.debug(ex);
                    return '';
                }
            }
            set
            {
                item.ScheduleLineDate = String.format('{0}{1}{2}', new String[] {
                    value.substring(6, 10),
                    value.substring(0, 2),
                    value.substring(3, 5)
                });
                System.debug('View sending date: Converting ' + value + ' to ' +
                    item.ScheduleLineDate);
            }
        }
    }

    // same list as replacementItems, but wrapped with the IndexItem helper
    public List<IndexedItem> indexedReplacementItems
    {
        get
        {
            Integer index = 0;
            List<IndexedItem> result = new List<IndexedItem>();
            Map<String, SBO_EnosixRO_Detail.ITEMS_SCHEDULE> mapSchedules = 
                new Map<String, SBO_EnosixRO_Detail.ITEMS_SCHEDULE>();

            for (SBO_EnosixRO_Detail.ITEMS_SCHEDULE schedule : this.itemSchedules)
            {
                mapSchedules.put(String.valueOf(Integer.valueOf(schedule.ItemNumber)), schedule);
            }

            for (SBO_EnosixRO_Detail.ITEMS_ARM item : this.replacementItems)
            {
                IndexedItem r = new IndexedItem();
                r.index = index++;
                r.item = item;
                if (mapSchedules.containsKey(item.Item))
                {
                    r.itemSchedule = mapSchedules.get(item.Item);
                }
                result.add(r);
            }
            return result;
        }
    }

    public Boolean isCreditCardEntryDisplayed
    {
        get
        {
            return UTIL_Order.getDisplayCreditCardEntry(this.rmaDetail.SALES.SalesDocumentType);
        }
    }

    public Boolean isCreditCardSectionDisplayed
    {
        get
        {
            return UTIL_Order.getDisplayCreditCardSection(this.rmaDetail.SALES.SalesDocumentType);
        }
    }

    public RFC_SD_GET_RETURN_CUSTINSPEC.RESULT inspectionResult { get; set; }

    @testVisible
    private RFC_SD_GET_DOC_TYPE_VALUES.RESULT docTypeMaster;
    private RFC_SD_GET_CARRIER_LIST.RESULT carrierMaster;
    private RFC_SD_GET_SHIP_INFO.RESULT shippingMaster;

    public CTRL_Return_Order_Create() {
        cas = new Case();
        rmaDetail = new SBO_EnosixRO_Detail.EnosixRO();
        rmaSaleData = new SBO_EnosixRO_Detail.SALES();
        this.saveCapturedCard = false;
        this.itemSchedules = new List<SBO_EnosixRO_Detail.ITEMS_SCHEDULE>();
        this.replacementItems = new List<SBO_EnosixRO_Detail.ITEMS_ARM>();
        if (!Test.isRunningTest()) {
            this.initFromParameters();
        }
    }

    private static List<string> master_DocumentCategoryTypes {
        get {
            return new string[]{
                    'H'
                    , '*'
            };
        }
    }
    @testVisible
    private static List<string> master_DocumentTypes {
        get {
            return new string[]{
                    'ZRE' // customer Return
                    , 'CBRE' // Dealer return
                    , 'ZUE' //upgrade / exchange
                    , '*'
            };
        }
    }

    public List<SelectOption> OrderTypes {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.docTypeMaster) {
                UTIL_Order.AddDocTypesOfCategory(result, docTypeMaster.ET_OUTPUT_List, master_DocumentCategoryTypes, master_DocumentTypes);
            }
            //UTIL_ViewHelper.addSelectOption(result, this.defaultOrderType);
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }

    public List<SelectOption> SalesOrganizations {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.customerDetail) {
                UTIL_Order.AddSalesOrganizations(result, UTIL_Order.getSalesDataListFromCustomer(this.customerDetail));
            }
            //UTIL_ViewHelper.addSelectOption(result, this.defaultSalesOrganization);
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }
    public List<SelectOption> DistributionChannels {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.customerDetail && null != this.rmaSaleData) {
                List<SBO_EnosixCustomer_Detail.SALES_DATA> sd = UTIL_Order.getSalesDataListFromCustomer(this.customerDetail);
                UTIL_Order.AddDistributionChannels(result, sd, this.rmaSaleData.SalesOrganization);
            }
            //UTIL_ViewHelper.addSelectOption(result, this.defaultDistributionChannel);
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }

    public List<SelectOption> Divisions {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.customerDetail && null != this.rmaSaleData) {
                UTIL_Order.AddDistributionDivisions(result, UTIL_Order.getSalesDataListFromCustomer(this.customerDetail), this.rmaSaleData.SalesOrganization, this.rmaSaleData.DistributionChannel);
            }
            //UTIL_ViewHelper.addSelectOption(result, this.defaultDivision);
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }
    public List<SelectOption> ReturnReasons {
        get {
            List<SelectOption> returnReasons = new List<SelectOption>();
            if (this.inspectionResult != null) {
                for (RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON rsn : this.inspectionResult.ET_RETURN_REASON_List) {
                    {
                        string o_lable = (rsn.BEZEI <> null)?rsn.BEZEI:'--None--';
                        string o_value = (rsn.RET_REASON <> null)?rsn.RET_REASON:'none';
                        returnReasons.add(new SelectOption(o_value , o_lable ));
                   //   returnReasons.add(new SelectOption(rsn.RET_REASON, rsn.BEZEI));
                    }
                }
            }
            UTIL_ViewHelper.sortOptionsByLabel(returnReasons);
            return returnReasons;
        }
    }
    public List<SelectOption> OrderReasons {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (this.inspectionResult != null) {
                for (RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON rsn : this.inspectionResult.ET_ORDER_REASON_List) {
                    {
                        string value = rsn.AUGRU;
                        string label = string.Format('{0} - {1}', new string[]{
                                rsn.AUGRU, rsn.BEZEI
                        });
                        result.add(new SelectOption(value, label));
                    }
                }
            }
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }

    public List<SelectOption> RefundTypes {
        get {
            List<SelectOption> refundTypes = new List<SelectOption>();
            if (this.inspectionResult != null) {
                for (RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE rsn : this.inspectionResult.ET_REFUND_TYPE_List) {
                    string value = rsn.REFUND_TYPE;
                    if (null == value) {
                        value = '';
                    }
                    if (string.isNotEmpty(rsn.REFUND_TYPE_TEXT)) {
                        refundTypes.add(new SelectOption(value, rsn.REFUND_TYPE_TEXT));
                    }
                }
            }
            UTIL_ViewHelper.sortOptionsByLabel(refundTypes);
            return refundTypes;
        }
    }

    public List<SelectOption> DocumentTypes {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.docTypeMaster) {
                UTIL_Order.AddDocTypesOfCategory(result, docTypeMaster.ET_OUTPUT_List, null, new string[]{
                        'H'
                });
            }
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }

    public SBO_EnosixRO_Detail.PARTNERS SoldToPartner {
        get {
            return UTIL_Order.getPartnerFromReturnOrder(this.rmaDetail, UTIL_Order.SOLD_TO_PARTNER_CODE, true);
        }
    }

    public SBO_EnosixRO_Detail.PARTNERS ShipToPartner {
        get {
            return UTIL_Order.getPartnerFromReturnOrder(this.rmaDetail, UTIL_Order.SHIP_TO_PARTNER_CODE, true);
        }
    }

    public SBO_EnosixRO_Detail.PARTNERS Carrier {
        get {
            return UTIL_Order.getPartnerFromReturnOrder(this.rmaDetail, UTIL_Order.CARRIER_PARTNER_CODE, true);
        }
    }

    public List<SelectOption> SoldToPartners {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.rmaDetail && null != this.customerDetail && null != this.rmaSaleData) {
                UTIL_Order.AddPartners(result, UTIL_Order.getCustomerPartners(this.customerDetail, UTIL_Order.SOLD_TO_PARTNER_CODE), this.rmaSaleData.SalesOrganization, this.rmaSaleData.DistributionChannel, this.rmaSaleData.Division);
            }
            UTIL_ViewHelper.addSelectOption(result, this.caseCustomerSelectOption);
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }

    public List<SelectOption> ShipToPartners
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();

            if (null != this.rmaDetail && null != this.customerDetail && null != this.rmaSaleData)
            {
                result = UTIL_SelectOption.buildOptionsFromList(
                    UTIL_Order.getShipToOptionBuilder(),
                    UTIL_Order.getPartnersByOrgChannelDivision(
                        UTIL_Order.getCustomerPartners(
                            this.customerDetail,
                            UTIL_Order.SHIP_TO_PARTNER_CODE
                        ),
                        this.rmaSaleData.SalesOrganization,
                        this.rmaSaleData.DistributionChannel,
                        this.rmaSaleData.Division
                    )
                );
            }
            UTIL_ViewHelper.addSelectOption(result, this.caseCustomerSelectOption);
            UTIL_ViewHelper.sortOptionsByLabel(result);
            return result;
        }
    }

    public Boolean isShipToPartnerAddressDisplayed
    {
        get
        {
            return UTIL_Order.isShipToPartnerAddressDisplayed;
        }
    }

    // List of carriers
    public List<SelectOption> Carriers {
        get
        {
            UTIL_Order.CarrierOptionBuilder optionBulder = new UTIL_Order.CarrierOptionBuilder();
            return UTIL_SelectOption.buildOptionsFromList(
                optionBulder, this.carrierMaster.ET_OUTPUT_List);
        }
    }

    //Built List of shipping conditions
    public List<SelectOption> ShippingConditions {
        get
        {
            List<SelectOption> result = Util_SelectOption.buildOptionsFromList(
                    new UTIL_ShippingInfo.ShippingConditionOptionBuilder(),
                    UTIL_ShippingInfo.filterShippingConditions(this.shippingMaster));

            return result;
        }
    }

    public void UpdateShipToPartner() {
        shipToCustomer = UTIL_Customer.fetchEnosixCustomer(ShipToPartner.CustomerNumber);
    }

    public void initFromParameters() {
        docTypeMaster = UTIL_Order.getDocTypeMaster();
        //carrierMaster = UTIL_Order.getCarriers();
        shippingMaster = UTIL_ShippingInfo.getShippingMaster();

        RFC_SD_GET_RETURN_CUSTINSPEC insp = new RFC_SD_GET_RETURN_CUSTINSPEC();
        this.inspectionResult = insp.execute();
        if (null != UTIL_PageState.current.caseId) {
            this.cas = UTIL_Object_Lookups.getCaseById(UTIL_PageState.current.caseId);
            if (null != this.cas) {
                // If there is no customer data, just stop here
                this.customerDetail = UTIL_Object_Lookups.GetCustomerForCase(this.cas);
                if (null == this.customerDetail.CustomerNumber) {
                    return;
                }

                if (this.cas.ENSX_EDM__Product_del__c != null && string.isNotEmpty(this.cas.ENSX_EDM__Product_del__c)) {
//                    Product2 product2 = UTIL_Object_Lookups.getProductByProductCode(this.cas.ENSX_EDM__Product_del__c);
//                    if (product2 != null && product2.ENSX_EDM__Material__c != null) {
//                        setSelectedReturnMaterialFromString(product2.ENSX_EDM__Material__c);
//                    }
                } else {
                    //ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'The associated Case object doesn\'t have an associated Product/Material for SAP lookup'));
                }

                this.shipToCustomer = this.customerDetail;
                this.ShipToPartner.EMailAddress = this.cas.Contact.Email;
                if (customerDetail.CustomerNumber != null) {
                    this.caseCustomerSelectOption = new SelectOption(this.customerDetail.CustomerNumber, this.customerDetail.Name);
                }
                this.rmaDetail.SoldToParty = this.customerDetail.CustomerNumber;
                SBO_EnosixRO_Detail ro = new SBO_EnosixRO_Detail();
                this.rmaDetail = ro.command('CMD_INIT_RETURN_ORDER', this.rmaDetail);
                carrierMaster = UTIL_Order.getCarriers(this.rmaSaleData.SalesOrganization);
                
            } else {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'No Case Id Provided, or no Case record could be found for the provided Id'));
            }
        }

    }

    public PageReference redirectToCreateCustomer() {
        UTIL_PageState.current.caseId = this.cas.Id;
        UTIL_PageState.current.accountId = this.cas.AccountId;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_CustomerCreate, UTIL_PageState.current);
    }

    public PageReference GoToCreateCustomer() {
        return redirectToCreateCustomer();
    }

    public PageReference GoToCustomerLinkPage() {
        UTIL_PageState.current.accountId = this.cas.AccountId;
        UTIL_PageState.current.caseId = this.cas.Id;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_Customer_Link, UTIL_PageState.current);
    }

    public void initCreate() {
        //set defaults
        this.rmaDetail.CustomerPurchaseOrderDate = Date.today();
        this.rmaDetail.SALES.RequestedDeliveryDate = Date.today();

        if (this.cas != null) {
            this.rmaDetail.CustomerPurchaseOrderNumber = 'RMA-' + this.cas.CaseNumber;
        }
        displayCaptureCardButton = false;
        displayEnterCardButton = true;
        SBO_EnosixRO_Detail enosixRODetail = new SBO_EnosixRO_Detail();
        RFC_SD_GET_DOC_TYPE_VALUES docRFC = new RFC_SD_GET_DOC_TYPE_VALUES();
        this.docTypeMaster = docRFC.execute();
        this.SoldToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(SoldToPartners);
        this.ShipToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(ShipToPartners);
        UpdateShipToPartner();
    }

    public boolean validateReturnOrder() {
        boolean validated = true;
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(rmaSaleData.SalesDocumentType, 'Order Type');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(rmaSaleData.SalesOrganization, 'Sales Organization');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(rmaSaleData.DistributionChannel, 'Distribution Channel');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(rmaSaleData.Division, 'Division');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(SoldToPartner.CustomerNumber, 'Sold To');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(ShipToPartner.CustomerNumber, 'Ship To');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(ShipToPartner.EMailAddress, 'Customer Email');
        if (rmaDetail.ITEMS_ARM.size() <= 0) {
            validated = false;
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'There must be at least one returned item'));
        }
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(rmaDetail.CustomerPurchaseOrderNumber, 'PO Number');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(rmaDetail.CustomerPurchaseOrderDate.format(), 'PO Date');
//        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(replacementItem.ReturnReason, 'Return Reason');
        //validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(replacementItem.RefundType, 'Refund Type');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(rmaDetail.OrderReason, 'Order Reason');

        return validated;
    }

    public PageReference redirectToOrderDetail(string orderId) {
        UTIL_PageState.current.rmaId = orderId;
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_Return_Order_Detail, UTIL_PageState.current);
    }

    public PageReference returnToCase() {
        return UTIL_PageFlow.redirectTo('/' + this.cas.Id, null);
    }

    // Clear rmaDetail items and replace them with the user-edited items,
    // Accounting for the items current refund type. Doing this late,
    // allows the user to switch refund type back and forth without losing
    // the material/quantity they entered for replacement
    private void replaceItems(SBO_EnosixRO_Detail.EnosixRO rmaDetail,
        List<SBO_EnosixRO_Detail.ITEMS_ARM> replacementItems)
    {
        //Clear the list for Item Schedules
        rmaDetail.ITEMS_SCHEDULE.clear();
        this.itemSchedules.clear();
        rmaDetail.ITEMS_ARM.clear();
        for (SBO_EnosixRO_Detail.ITEMS_ARM item : replacementItems)
        {
            SBO_EnosixRO_Detail.ITEMS_ARM newItem = new SBO_EnosixRO_Detail.ITEMS_ARM();
            newItem.Item = getNextItemNumber(rmaDetail);
            newItem.InspectionCodeText = 'X';
            newItem.Quantity = item.Quantity;
            newItem.Material = item.Material;
            newItem.ReturnReason = item.ReturnReason;
            newItem.RefundType = item.RefundType;
            newItem.PriceDifference = item.PriceDifference;
            newItem.TaxDifference = item.TaxDifference;

            if ('1' == newItem.RefundType)
            {
                newItem.ReplacementMaterial = item.ReplacementMaterial;
                newItem.ReplacementQuantity = item.ReplacementQuantity;
                newItem.ReplacedQuantity = 0;
                newItem.ScheduleLineDate = item.ScheduleLineDate;
            }

            rmaDetail.ITEMS_ARM.add(newItem);

            // This is a bit weird - We update the cloned item item number so that it matches
            // By doing this, we can then clone over the calculated fields after simulate
            item.Item = newItem.Item;
        }
    }

    // replacePrices()
    //
    // After simulate, we need to copy the price difference info over from the RMA items
    // back onto the replace items that are displayed on the screen.
    private void replacePrices(
        SBO_EnosixRO_Detail.EnosixRO rmaDetail,
        List<SBO_EnosixRO_Detail.ITEMS_ARM> replacementItems)
    {
        // First map items by item number so we can easily update them later
        Map<String, SBO_EnosixRO_Detail.ITEMS_ARM> itemMap =
            new Map<String, SBO_EnosixRO_Detail.ITEMS_ARM>();
        for (SBO_EnosixRO_Detail.ITEMS_ARM item : replacementItems)
        {
            String itemNumber = String.valueOf(Integer.valueOf(item.Item));
            itemMap.put(itemNumber, item);
        }

        // Now use the map to copy price info from rma to replacementItems
        List<SBO_EnosixRO_Detail.ITEMS_ARM> items = new List<SBO_EnosixRO_Detail.ITEMS_ARM>();
        rmaDetail.ITEMS_ARM.copyTo(items);
        for (SBO_EnosixRO_Detail.ITEMS_ARM item : items)
        {
            String itemNumber = String.valueOf(Integer.valueOf(item.Item));
            SBO_EnosixRO_Detail.ITEMS_ARM replacementItem = itemMap.get(itemNumber);
            if (replacementItem != null)
            {
                replacementItem.ReturnMaterialNetPrice = item.ReturnMaterialNetPrice;
                replacementItem.ReturnMaterialTax = item.ReturnMaterialTax;
                replacementItem.ReplacementMaterialNetPrice = item.ReplacementMaterialNetPrice;
                replacementItem.ReplacementMaterialTax = item.ReplacementMaterialTax;
                replacementItem.PriceDifference = item.PriceDifference;
                replacementItem.TaxDifference = item.TaxDifference;
            }
        }
    }

    public PageReference createRMA() {
        SBO_EnosixRO_Detail sbo = new SBO_EnosixRO_Detail();
        this.replaceItems(this.rmaDetail, this.replacementItems);
        if (validateReturnOrder()) {
            rmaDetail.SoldToParty = customerDetail.CustomerNumber;
            //Graham
            list<SBO_EnosixRO_Detail.PARTNERS> partners = new list<SBO_EnosixRO_Detail.PARTNERS>();
            if (rmaDetail.PARTNERS != null) {
                rmaDetail.PARTNERS.copyTo(partners);
                for (SBO_EnosixRO_Detail.PARTNERS partner : partners) if ('NONE' == partner.CustomerNumber) rmaDetail.PARTNERS.remove(partner);
            } //Graham
            SBO_EnosixRO_Detail.EnosixRO result = sbo.save(rmaDetail);
            if (!result.isSuccess()) {
                if (null == result.getMessages() || 0 == result.getMessages().size())
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Order creation failed'));
                ENSX.EnosixFramework.displayResultMessages(result, ensx.EnosixFramework.MessageType.INFO);
                return null;
            }
            this.rmaDetail = result;
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Order was Successfully Saved.'));
            this.cas.ENSX_EDM__Return_Order_Number__c = rmaDetail.SalesDocument;
            upsert this.cas;
            return redirectToOrderDetail(rmaDetail.SalesDocument);
        } else {
            System.debug('validation failed on RMA Create.');
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Validation Failed'));
            return null;
        }
    }
    
    public void updateReturnInformation() {
        if (null != this.rmaDetail) {
//            this.materialSearchResults = searchForMaterialsBySalesArea(this.orderDetail.Sales.SalesOrganization, this.orderDetail.Sales.DistributionChannel);
        } else {
            System.debug('updateReturnInformation - rmaDetail is null ');
        }
    }

    public void SimulateOrderAndUpdateRO() {
        SBO_EnosixRO_Detail sbo = new SBO_EnosixRO_Detail();
        this.replaceItems(this.rmaDetail, this.replacementItems);         
        
        SBO_EnosixRO_Detail.EnosixRO simulatedOrder = sbo.command('CMD_SIMULATE_RO', this.rmaDetail);

        if (simulatedOrder.isSuccess())
        {            
            simulatedOrder.ITEMS_SCHEDULE.copyTo(this.itemSchedules);            
            this.rmaDetail = simulatedOrder;
            this.replacePrices(this.rmaDetail, this.replacementItems);
        }
        ensx.EnosixFramework.displayResultMessages(simulatedOrder, ensx.EnosixFramework.MessageType.INFO);
    }
      /* Begin Credt Card Entry */

    public boolean isOrderCardLimitEnabled { get {return UTIL_Order.isCardLimitEnabled;} }
    public CB_CardDetailsReceiver cdReceiver { get {return this;} }
    public Decimal CardLimit { get; set; }
    public boolean saveCapturedCard { get; set; }

    public void onReceiveCardDetails(SBO_EnosixXiIntercept_Detail.EnosixXiIntercept details) {

        displayCaptureCardButton = false;
        displayEnterCardButton = true;

        if (!isOrderCardLimitEnabled) {
            this.CardLimit = null;
        }
        UTIL_PaymentCards.addCardToReturnOrder(details.RESPONSE, this.rmaDetail, this.CardLimit);

        if (this.saveCapturedCard) {
            this.addCardToCustomer(details.RESPONSE);
        }

        this.SimulateOrderAndUpdateRO();
        this.CardLimit = Decimal.valueOf('0.0');
    }

    private void addCardToCustomer(SBO_EnosixXiIntercept_Detail.RESPONSE details) {
        // Get a fresh copy of customer so we don't edit the one already displayed in the page
        SBO_EnosixCustomer_Detail.EnosixCustomer editCustomer =
                UTIL_Customer.fetchEnosixCustomer(this.customerDetail.CustomerNumber);

        UTIL_PaymentCards.addCardToCustomer(details, editCustomer);

        SBO_EnosixCustomer_Detail.EnosixCustomer result = UTIL_Customer.saveCustomer(editCustomer);
        if (result != null) {
            // Update the displayed customer information
            this.customerDetail = result;
        }
    }

    public boolean displayEnterCardButton { get; private set; }
    public boolean displayCaptureCardButton { get; private set; }
    public string selectedCustomerCard { get; set; }

    public void onInitCardDetails(SBO_EnosixXiIntercept_Detail.EnosixXiIntercept details) {
        displayCaptureCardButton = true;
        displayEnterCardButton = false;
    }


    public List<SBO_EnosixRO_Detail.CCARD> OrderCards {
        get {
            List<SBO_EnosixRO_Detail.CCARD> result = new List<SBO_EnosixRO_Detail.CCARD>();

            if (null != this.rmaDetail) {
                this.rmaDetail.CCARD.copyTo(result);
            }

            return result;
        }
    }

    public integer OrderCardsCount {
        get {
            return OrderCards.size();
        }
    }

    public void actionRemoveCard() {
        String cardNumber = System.currentPageReference().getParameters().get('cardNumber');

        if (string.isBlank(cardNumber) || null == this.rmaDetail) {
            return;
        }

        if (UTIL_PaymentCards.removeCardFromReturnOrder(this.rmaDetail, cardNumber)) {
            this.SimulateOrderAndUpdateRO();
        }
    }

    public void actionAddCardFromCustomer() {
        if (string.isBlank(selectedCustomerCard) || null == this.rmaDetail) {
            return;
        }

        SBO_EnosixCustomer_Detail.PAYMENT_DATA card = null;

        List<SBO_EnosixCustomer_Detail.PAYMENT_DATA> cards = new List<SBO_EnosixCustomer_Detail.PAYMENT_DATA>();
        this.customerDetail.PAYMENT_DATA.copyTo(cards);
        for (SBO_EnosixCustomer_Detail.PAYMENT_DATA c : cards) {
            if (c.CardNumber == this.selectedCustomerCard) {
                card = c;
                break;
            }
        }

        if (card != null) {
            if (!isOrderCardLimitEnabled) {
                this.CardLimit = null;
            }
            UTIL_PaymentCards.addCustomerCardToReturnOrder(card, this.rmaDetail, this.CardLimit);
            this.SimulateOrderAndUpdateRO();
            this.CardLimit = Decimal.valueOf('0.0');
        }
    }

    public List<SelectOption> CustomerPaymentCards {
        get {
            return UTIL_PaymentCards.getPaymentCardSelectOptionsForCustomer(this.customerDetail);
        }
    }
    private RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT getOrderMasterData(string orderTypeKey) {
        for (RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT orderType : this.docTypeMaster.ET_OUTPUT_List) {
            if (orderType.AUART == orderTypeKey)
                return orderType;
        }

        system.Debug('Was unable to locate Master Data matching key: ' + orderTypeKey);
        return null;
    }

    string getNextItemNumber(SBO_EnosixRO_Detail.EnosixRO returnOrder) {
        //Default increment if nothing has been configured.
        Integer itemIncrement = 10;

        RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT orderMasterData = getOrderMasterData(returnOrder.Sales.SalesDocumentType);

        if (null != orderMasterData && string.isNotBlank(orderMasterData.INCPO))
            itemIncrement = Integer.valueOf(orderMasterData.INCPO);

        return getNextItemNumber(returnOrder, itemIncrement);
    }

    @testVisible
    static string getNextItemNumber(SBO_EnosixRO_Detail.EnosixRO returnOrder, Integer poIncrement) {
        List<SBO_EnosixRO_Detail.ITEMS_ARM> items = new List<SBO_EnosixRO_Detail.ITEMS_ARM>();

        if (null != returnOrder) {
            returnOrder.ITEMS_ARM.copyTo(items);
        }

        integer max = 0;

        for (SBO_EnosixRO_Detail.ITEMS_ARM item : items) {
            integer itemNumber = integer.valueOf(item.Item);
            max = Math.max(max, itemNumber);
        }

        return string.ValueOf(max + poIncrement);
    }

    /* End Credt Card Entry */

    public List<String> defaultReturnOrderMaterialTypes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'ReturnOrder.DefaultMaterialTypes', String.class, new List<String>{ 'FERT' });
        }
    }

    public List<String> defaultReturnOrderProductAttributes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'ReturnOrder.DefaultMaterialProductAttributes', String.class, new List<String>{ });
        }
    }

    public Boolean isReturnOrderMaterialAutoSearchEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('ReturnOrder.IsMaterialAutoSearchEnabled', true);
        }
    }

    public Boolean isRmaSingleRefundTypeEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('ReturnOrder.IsSingleRefundTypeEnabled', false);
        }
    }

    public CB_MaterialSearchReceiver msReceiver { get { return this; } }
    public Integer currentItemIndex { get; set; }

    public Boolean isRefundTypeDisabled
    {
        get
        {
            // Disable header refund type if there are items and single type is enabled
            return this.isRmaSingleRefundTypeEnabled && this.replacementItems.size() > 0;
        }
    }

    public String refundTypeLabel
    {
        get
        {
            if (this.isRmaSingleRefundTypeEnabled)
                return 'Refund Type:';
            return 'Default Refund Type:';
        }
    }

    public void actionSetPickIndex() {
        // no body - assignTo already did the work updating currentItemIndex
        System.debug('currentItemIndex = ' + String.valueOf(currentItemIndex));
    }

    public void onReceiveMaterialSearchResults(string id, List<CTRL_MaterialSearch.MaterialSearchResult> results) {
        if ('returnMaterials' == id) {
            addReturnMaterialsAsItems(results);
        }
        else if ('editReplacementMaterial' == id) {
            editReplacementMaterial(results.get(0));
        }
    }

    private void addReturnMaterialsAsItems(List<CTRL_MaterialSearch.MaterialSearchResult> materials) {
        for (CTRL_MaterialSearch.MaterialSearchResult material : materials) {
            SBO_EnosixRO_Detail.ITEMS_ARM item = new SBO_EnosixRO_Detail.ITEMS_ARM();

            item.Quantity = material.quantity;
            item.Material = material.material.Material;
            item.MaterialDescription = material.material.MaterialDescription;
            item.RefundType = this.RefundType;
            item.ReplacementMaterial = item.Material;
            item.ReplaceMaterialDescription = item.MaterialDescription;
            item.ReplacementQuantity = item.Quantity;
            item.ScheduleLineDate = DateTime.newInstance(
                this.rmaDetail.Sales.RequestedDeliveryDate.year(),
                this.rmaDetail.Sales.RequestedDeliveryDate.month(),
                this.rmaDetail.Sales.RequestedDeliveryDate.day()
            ).format('YYYYMMdd');

            replacementItems.add(item);                      
        }
        SimulateOrderAndUpdateRO();
    }

    private void editReplacementMaterial(CTRL_MaterialSearch.MaterialSearchResult material) {
        System.debug('changing replacement material for index: ' + this.currentItemIndex);
        SBO_EnosixRO_Detail.ITEMS_ARM item = this.replacementItems.get(this.currentItemIndex);
        item.ReplacementMaterial = material.material.Material;
        item.ReplaceMaterialDescription = material.material.MaterialDescription;
        SimulateOrderAndUpdateRO();
    }

    public void removeRMAItem() {
        Integer index = Integer.valueOf(System.currentPageReference().getParameters().get('index'));
        this.replacementItems.remove(index);
    }
}
public with sharing class CTRL_OrderCreate implements CB_CardDetailsReceiver, CB_MaterialSearchReceiver {

    public SBO_EnosixCustomer_Detail.SALES_DATA customerSalesData {
        get {
            return (SBO_EnosixCustomer_Detail.SALES_DATA) customerDetail.SALES_DATA.get(0);
        }
        set {
            SBO_EnosixCustomer_Detail.SALES_DATA paymnt = (SBO_EnosixCustomer_Detail.SALES_DATA) customerDetail.SALES_DATA.get(0);
            paymnt = value;
        }
    }

    public SBO_EnosixCustomer_Detail.COMPANY_DATA companyData {
        get {
            return (SBO_EnosixCustomer_Detail.COMPANY_DATA) customerDetail.COMPANY_DATA.get(0);
        }
        set {
            SBO_EnosixCustomer_Detail.COMPANY_DATA codata = (SBO_EnosixCustomer_Detail.COMPANY_DATA) customerDetail.COMPANY_DATA.get(0);
            codata = value;
        }
    }

    public SBO_EnosixSO_Detail.EnosixSO orderDetail { get; set; }

    public boolean opportunityClosed
    {
        get
        {
            return this.orderOpportunity!=null && this.orderOpportunity.StageName.contains('Closed');
        }
    }

    public Opportunity orderOpportunity { get; private set; }
    public SBO_EnosixCustomer_Detail.EnosixCustomer customerDetail { get; private set; }
    public SBO_EnosixCustomer_Detail.EnosixCustomer shipToCustomer { get; set; }
    public SBO_EnosixSO_Detail.ITEMS newItem { get; set; }
    // vars for the direct order entry
    public Account orderAccount { get; private set; }

    //Disable editing the order type once materials are added.
    public Boolean isOrderTypeDisabled
    {
        get
        {
            return this.orderDetail.ITEMS.size() > 0;
        }
    }

    List<SBO_EnosixCustomer_Detail.PAYMENT_DATA> paymentDataItems { get; set; }
    public string selectedPaymentID { get; set; }

    //This is a hardcode default. For testing in the PDT it's Sandard Order, in the client system this needs to be altered.
    public static string pickDefaultOrderType(List<SelectOption> options) {
        if (options.size() <= 0) return '';

        for (SelectOption option : options) {
            if (option.getValue() == 'OR')
            {
                return option.getValue();
            }                
        }
        return '';
    }

    public List<UTIL_Order.OrderItem> displayedMaterialItems {
        get
        {
            return UTIL_Order.convertOrderDetailToOrderItem(orderDetail);
        }
    }

    public List<SelectOption> paymentDataSelections { get; set; }

    public List<SelectOption> CustomerConditions1
    {
        get
        {
            return UTIL_SelectOption.buildOptionsFromList(
                    UTIL_Order.getCustomerConditionOptionBuilder1(),
                    UTIL_Order.getConditionGroups(),
                    true
            );
        }
    }

    public List<SelectOption> CustomerConditions2
    {
        get
        {
            return UTIL_SelectOption.buildOptionsFromList(
                    UTIL_Order.getCustomerConditionOptionBuilder2(),
                    UTIL_Order.getConditionGroups(),
                    true
            );
        }
    }

    public Boolean isCreditCardEntryDisplayed
    {
        get
        {
            return UTIL_Order.getDisplayCreditCardEntry(this.orderDetail.SALES.SalesDocumentType);
        }
    }

    public Boolean isCreditCardSectionDisplayed
    {
        get
        {
            return UTIL_Order.getDisplayCreditCardSection(this.orderDetail.SALES.SalesDocumentType);
        }
    }

    /**
     * called from Opportunity detail button, creating a new order from scratch
     * @return [description]
     */
    public CTRL_OrderCreate() {
        //Blank initialization to prevent test failures.
        orderDetail = new SBO_EnosixSO_Detail.EnosixSO();

        displayCaptureCardButton = false;
        displayEnterCardButton = true;
        saveCapturedCard = false;

        initFromParameters();

        if (!Test.isRunningTest()) {
            init();
        }

        clearItem();

        paymentDataItems = new List<SBO_EnosixCustomer_Detail.PAYMENT_DATA>();
    }

    @testVisible
    private void init() {
        //Init the order from SAP and populate defaults.
        SBO_EnosixSO_Detail.EnosixSO so = new SBO_EnosixSO_Detail.EnosixSO();

        if (!UTIL_Event.executeEvent(UTIL_Event.ORDER_INITIALIZING, new Map<String, object> {
                'SBO_EnosixSO_Detail.EnosixSO'=> so,
                'Opportunity'=> orderOpportunity
        }).isSuccess)
        {
            return;
        }

        orderDetail = (new SBO_EnosixSO_Detail()).initialize(so);

        //Load master data from RFCs
        this.docTypeMaster = UTIL_Order.getDocTypeMaster();
        //this.carrierMaster = UTIL_Order.getCarriers();
        this.shippingMaster = UTIL_ShippingInfo.getShippingMaster();
        this.orderMaster = UTIL_Order.getOrderTypes('EnosixSO');

        if (null != this.orderAccount) {
            string customerId = UTIL_Account.getCustomerNumberFromAccount(this.orderAccount);
            System.debug('customerId =');
            System.debug(customerId);
            if (!string.isBlank(customerId)) {
                this.customerDetail = UTIL_Customer.fetchEnosixCustomer(customerId);

                if (null == this.customerSalesData) {
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING,
                            'This Account/SAP customer is not configured for order creation'));
                }
            }
        }

        // Copy over the customer Info
        if (null != this.customerDetail) {
            UTIL_Order.CopyCustomerInfoToOrder(this.orderDetail, this.customerDetail);
        }

        this.orderDetail.ORDERDATA.CustomerPurchaseOrderDate = System.today();
        this.orderDetail.Sales.RequestedDeliveryDate = System.today();

        this.orderDetail.Sales.SalesOrganization = UTIL_ViewHelper.pickFirst(SalesOrganizations);
        this.carrierMaster = UTIL_Order.getCarriers(this.orderDetail.Sales.SalesOrganization);
        this.orderDetail.Sales.DistributionChannel = UTIL_ViewHelper.pickFirst(DistributionChannels);
        this.orderDetail.Sales.Division = UTIL_ViewHelper.pickFirst(Divisions);

        this.SoldToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(SoldToPartners);
        this.ShipToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(ShipToPartners);

        UpdateShipToPartner();
        this.orderDetail.Sales.SalesDocumentType = pickDefaultOrderType(OrderTypes);

        updateSalesAreas();        
        initializeOpportunity();
        if (!UTIL_Event.executeEvent(UTIL_Event.ORDER_INITIALIZED, new Map<String, object> {
                'SBO_EnosixSO_Detail.EnosixSO'=> this.orderDetail,
                'Opportunity'=> this.orderOpportunity
        }).isSuccess)
        {
            return;
        }
    }

    private void initializeOpportunity()
    {
        if (null == this.orderOpportunity)
        {
            return;
        }

        this.orderDetail.CustomerPurchaseOrderNumber = this.orderOpportunity.Name;

        List<OpportunityLineItem> lineItems = FetchOpportunityLineItems(this.orderOpportunity);
        Set<Id> productIdList = new Set<Id>();
        for (OpportunityLineItem lineItem : lineItems)
        {
            if (lineItem.Product2 != null)
            {
                productIdList.add(lineItem.Product2.Id);
            }
        }
        Map<Id, String> productSAPMaterailNumberList = UTIL_Product.getSAPMaterialNumbersFromProductList(productIdList);

        for (OpportunityLineItem lineItem : lineItems)
        {
            string materialNumber = productSAPMaterailNumberList.get(lineItem.Product2.Id);
            SBO_EnosixSO_Detail.ITEMS item = 
                TranslateOpportunityLineItem(lineItem, materialNumber, 
                    this.orderDetail.Sales.SalesOrganization, 
                    this.orderDetail.Sales.DistributionChannel);
            item.ItemNumber = getNextItemNumber(this.orderDetail);
            orderDetail.ITEMS.add(item);
            SBO_EnosixSO_Detail.ITEMS_ACTION action = new SBO_EnosixSO_Detail.ITEMS_ACTION();
            action.ItemNumber = item.ItemNumber;
            action.ItemAdded = 'X';
            this.orderDetail.ITEMS_ACTION.add(action);
        }
        this.SoldToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(SoldToPartners);
        this.ShipToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(ShipToPartners);

        UpdateShipToPartner();
        this.SimulateOrderAndUpdateSO();

        this.orderDetail.Sales.SalesDocumentType = pickDefaultOrderType(OrderTypes);
    }

    private SBO_EnosixMaterial_Search.EnosixMaterial_SR materialSearchResults;
    private RFC_SD_GET_DOC_TYPE_VALUES.RESULT docTypeMaster;
    private RFC_SD_GET_CARRIER_LIST.RESULT carrierMaster;
    private RFC_SD_GET_SHIP_INFO.RESULT shippingMaster;
    private RFC_SD_GET_ORDER_TYPES.RESULT ordermaster;

    /*
    * Page Actions
    */

    public void updateSalesAreas() {
        if (null != this.orderDetail) {
            this.materialSearchResults = UTIL_Material.searchForMaterialsBySalesArea(this.orderDetail.Sales.SalesOrganization, this.orderDetail.Sales.DistributionChannel);
        }
    }

    public void clearItem() {
        this.newItem = new SBO_EnosixSO_Detail.ITEMS();

        if (null != this.orderDetail) {
            //this.newItem.ScheduleLineDate = this.orderDetail.Sales.RequestedDeliveryDate;
        }

        this.selectedMaterialDetail = null;
    }

    /*
    * Initialize the Account and Opportunity records based on the passed parameters to the Page
    */
    public void initFromParameters() {
        if (null != UTIL_PageState.current.opportunityId)
        {
            this.orderOpportunity = UTIL_Object_Lookups.getOpportunityById(
                UTIL_PageState.current.opportunityId);
            if (null != this.orderOpportunity)
            {
                this.orderAccount = UTIL_Object_Lookups.getAccountById(
                    this.orderOpportunity.AccountId);
            }                
        }

        if (null == this.orderAccount)
        {
            this.orderAccount = UTIL_Object_Lookups.getAccountById(UTIL_PageState.current.accountId);
        }
            
        if (null != this.orderAccount)
        {
            UTIL_PageState.current.accountId = this.orderAccount.Id;
        }            
    }

    /*
    * Pick Lists
    */

    private static List<string> master_DocumentCategoryTypes {
        get {
            return (List<String>)UTIL_AppSettings.getList(
                'Order.DocumentCategoryTypes', String.class, new List<String>{ '*' });
        }
    }

    private static List<string> master_DocumentTypes {
        get {
            return (List<String>)UTIL_AppSettings.getList(
                'Order.DocumentTypes', String.class, new List<String>{ 'OR' });
        }
    }

    public List<SelectOption> OrderTypes {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.docTypeMaster) {
                UTIL_Order.AddDocTypesOfCategory(result, docTypeMaster.ET_OUTPUT_List, master_DocumentCategoryTypes, master_DocumentTypes);
            }
            result.sort();
            return result;
        }
    }

    public List<SelectOption> SalesOrganizations {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.customerDetail) {
                UTIL_Order.AddSalesOrganizations(result, UTIL_Order.getSalesDataListFromCustomer(this.customerDetail));
            }

            return result;
        }
    }

    public List<SelectOption> DistributionChannels {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.customerDetail && null != this.orderDetail) {
                UTIL_Order.AddDistributionChannels(result, UTIL_Order.getSalesDataListFromCustomer(this.customerDetail), this.orderDetail.Sales.SalesOrganization);
            }

            return result;
        }
    }

    public List<SelectOption> Divisions {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (null != this.customerDetail && null != this.orderDetail) {
                UTIL_Order.AddDistributionDivisions(result, UTIL_Order.getSalesDataListFromCustomer(this.customerDetail), this.orderDetail.Sales.SalesOrganization, this.orderDetail.Sales.DistributionChannel);
            }

            return result;
        }
    }

    public List<SelectOption> SoldToPartners {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.customerDetail && null != this.orderDetail) {
                UTIL_Order.AddPartners(result, UTIL_Order.getCustomerPartners(this.customerDetail, UTIL_Order.SOLD_TO_PARTNER_CODE),
                        this.orderDetail.Sales.SalesOrganization, this.orderDetail.Sales.DistributionChannel, this.orderDetail.Sales.Division);
            }

            return result;
        }
    }

    public List<SelectOption> ShipToPartners
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();

            if (null != this.customerDetail && null != this.orderDetail)
            {
                result = UTIL_SelectOption.buildOptionsFromList(
                    UTIL_Order.getShipToOptionBuilder(),
                    UTIL_Order.getPartnersByOrgChannelDivision(
                        UTIL_Order.getCustomerPartners(
                            this.customerDetail,
                            UTIL_Order.SHIP_TO_PARTNER_CODE
                        ),
                        this.orderDetail.Sales.SalesOrganization,
                        this.orderDetail.Sales.DistributionChannel,
                        this.orderDetail.Sales.Division
                    )
                );
            }
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
                UTIL_ShippingInfo.filterShippingConditions(this.shippingMaster)
            );

            return result;
        }
    }

    //Built List of shipping conditions
    public List<SelectOption> ItemCategories
    {
        get
        {
            List<SelectOption> result = Util_SelectOption.buildOptionsFromList(
                new UTIL_Order.ItemCategoryOptionBuilder(),
                UTIL_Order.filterItemCategories(this.orderMaster, orderDetail.Sales.SalesDocumentType)
            );

            return result;
        }
    }

    public SBO_EnosixSO_Detail.PARTNERS SoldToPartner {
        get {
            return UTIL_Order.getPartnerFromOrder(this.orderDetail, UTIL_Order.SOLD_TO_PARTNER_CODE, true);
        }
    }

    public SBO_EnosixSO_Detail.PARTNERS ShipToPartner {
        get {
            return UTIL_Order.getPartnerFromOrder(this.orderDetail, UTIL_Order.SHIP_TO_PARTNER_CODE, true);
        }
    }

    public SBO_EnosixSO_Detail.PARTNERS Carrier {
        get {
            return UTIL_Order.getPartnerFromOrder(this.orderDetail, UTIL_Order.CARRIER_PARTNER_CODE, true);
        }
    }

    public void UpdateShipToPartner() {
        shipToCustomer = UTIL_Customer.fetchEnosixCustomer(ShipToPartner.CustomerNumber);
    }

    public List<SelectOption> Materials {
        get {
            List<SelectOption> result = new List<SelectOption>();

            result.add(new SelectOption('', 'Select a Material'));

            if (null != this.materialSearchResults) {
                UTIL_Material.addMaterialsFromSearchResultsToSelectOptions(this.materialSearchResults, result);
            }

            return result;
        }
    }

    public List<SelectOption> PlantSelections {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (null != this.selectedMaterialDetail && null != this.orderDetail) {
                AddPlantsFromMaterialDetail(result, this.selectedMaterialDetail, this.orderDetail.Sales.SalesOrganization, this.orderDetail.Sales.DistributionChannel);
            }

            return result;
        }
    }

    public void initCreate() {
        paymentDataSelections = getCreditItems();
    }

    /**
     * called from the new button on opportunity Order SAP related list
     * @param  stdController [description]
     * @return               [description]
     */
    public void SimulateOrderAndUpdateSO() {
        SBO_EnosixSO_Detail enosixSODetail = new SBO_EnosixSO_Detail();

        SBO_EnosixSO_Detail.EnosixSO simulatedOrder = enosixSODetail.command('CMD_SIMULATE_ORDER', orderDetail);
        if (simulatedOrder.isSuccess()) {
            system.debug('simulated order was a success');
            this.orderDetail = simulatedOrder;
        }

        ensx.EnosixFramework.displayResultMessages(simulatedOrder, ensx.EnosixFramework.MessageType.INFO);
    }

    @testVisible
    private static SBO_EnosixSO_Detail.EnosixSO simulateOrder(SBO_EnosixSO_Detail.EnosixSO salesOrder) {
        SBO_EnosixSO_Detail sbo = new SBO_EnosixSO_Detail();

        SBO_EnosixSO_Detail.EnosixSO result = sbo.command('CMD_SIMULATE_ORDER', salesorder);

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ensx.EnosixFramework.MessageType.INFO);
            return salesOrder;
        }

        return result;
    }

    private SBO_EnosixMaterial_Detail.EnosixMaterial selectedMaterialDetail;

    @testVisible
    private static void AddPlantsFromMaterialDetail(List<SelectOption> result, SBO_EnosixMaterial_Detail.EnosixMaterial material, string salesOrganization, string distributionChannel) {
        Set<string> values = new Set<string>();
        List<SBO_EnosixMaterial_Detail.PLANT_DATA> plantData = new List<SBO_EnosixMaterial_Detail.PLANT_DATA>();

        if (null != material) {
            material.PLANT_DATA.copyTo(plantData);
        }

        for (SBO_EnosixMaterial_Detail.PLANT_DATA plant : plantData) {
            if (!values.contains(plant.Plant) && plant.SalesOrganization.equalsIgnoreCase(salesOrganization) && plant.DistributionChannel.equalsIgnoreCase(distributionChannel)) {
                result.add(new SelectOption(plant.Plant, plant.Name));
                values.add(plant.Plant);
            }
        }
    }


    public void singleMaterialSelected()
    {
        if (null != this.newItem) {
            selectedMaterialDetail = UTIL_Material.getMaterialFromMaterialNumber(newItem.Material);
            this.newItem.Plant = UTIL_ViewHelper.pickFirst(PlantSelections);
            this.newItem.OrderQuantity = 1;
        }
    }

    public List<string> defaultOrderMaterialTypes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'Order.DefaultMaterialTypes', String.class, new List<String>{ 'FERT' });
        }
    }

    public List<string> defaultOrderProductAttributes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'Order.DefaultMaterialProductAttributes', String.class, new List<String>{ });
        }
    }

    public boolean isOrderMaterialAutoSearchEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Order.IsMaterialAutoSearchEnabled', true);
        }
    }

    public CB_MaterialSearchReceiver msReceiver { get { return this; } }

    public void onReceiveMaterialSearchResults(string id, List<CTRL_MaterialSearch.MaterialSearchResult> results) {
        addSelectedMaterialsAsItems(results);
    }

    public void addSelectedMaterialsAsItems(List<CTRL_MaterialSearch.MaterialSearchResult> materials) {
        List<SBO_EnosixSO_Detail.ITEMS> items = new List<SBO_EnosixSO_Detail.ITEMS>();

        // Validate all items first
        for (CTRL_MaterialSearch.MaterialSearchResult material : materials) {
            SBO_EnosixSO_Detail.ITEMS item = new SBO_EnosixSO_Detail.ITEMS();
            item.Material = material.material.Material;
            item.OrderQuantity = material.quantity;
            item.ScheduleLineDate = UTIL_Order.formatReadableDateToSAPString(material.scheduleDate);

            System.debug('item: ' + item);
            if (!validateNewLineItem(item))
            {
                return;
            }                

            items.add(item);
        }

        // Now that all the data is validated, we can actually add the items
        for (SBO_EnosixSO_Detail.ITEMS item : items) {
            addItemToOrder(item);
        }
        this.SimulateOrderAndUpdateSO();
    }

    public PageReference displayOrder() {
        UTIL_PageState.current.orderNum = this.orderDetail.SalesDocument;
        if (null != this.orderOpportunity){
            UTIL_PageState.current.opportunityId = this.orderOpportunity.Id;
        }
            
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_OrderDetail, UTIL_PageState.current);
    }

    public PageReference redirectToCreateCustomer() {
        return UTIL_Customer.redirectToCreateCustomer();
    }

    public PageReference redirectToQuoteDetail() {
        UTIL_PageState.current.quoteId = orderOpportunity.ENSX_EDM__Quote_Number__c;
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_Quote_Detail, UTIL_PageState.current);
    }

    /**
     * methods for creating a whole new order
     */

    public PageReference createNewOrder() {

        if (!validateOrder(this.OrderDetail)) {
            return null;
        }

        removeAllScheduleLinesFromOrder(this.OrderDetail);

        SBO_EnosixSO_Detail sbo = new SBO_EnosixSO_Detail();

        SBO_EnosixSO_Detail.EnosixSO result = sbo.save(orderDetail);
        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ensx.EnosixFramework.MessageType.INFO);
            return null;
        }

        system.debug('createOrder isSuccess');
        this.orderDetail = result;
        if (orderOpportunity != null) {
            this.orderOpportunity = FinalizeOrderandUpdateOpportunity(this.orderOpportunity, this.orderDetail);
        }
        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Order was Successfully Saved.'));

        return displayOrder();
    }

    @testVisible
    private static void removeAllScheduleLinesFromOrder(SBO_EnosixSO_Detail.EnosixSO salesOrder) {
        List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> schedule_lines = new List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE>();

        if (null != salesOrder) {
            salesOrder.ITEMS_SCHEDULE.copyTo(schedule_lines);

            for (SBO_EnosixSO_Detail.ITEMS_SCHEDULE item : schedule_lines) {
                salesOrder.ITEMS_SCHEDULE.remove(item);
            }
        }
    }

    private boolean validateOrder(SBO_EnosixSO_Detail.EnosixSO salesOrder) {
        return validateOrder(salesOrder, isPONumberRequired(salesOrder.Sales.SalesDocumentType));
    }

    @testVisible
    private static boolean validateOrder(SBO_EnosixSO_Detail.EnosixSO salesOrder, boolean poNumRequired) {
        boolean validated = true;

        SBO_EnosixSO_Detail.PARTNERS soldToPartner = UTIL_Order.getPartnerFromOrder(salesOrder, UTIL_Order.SOLD_TO_PARTNER_CODE, true);
        SBO_EnosixSO_Detail.PARTNERS shipToPartner = UTIL_Order.getPartnerFromOrder(salesOrder, UTIL_Order.SHIP_TO_PARTNER_CODE, true);
        SBO_EnosixSO_Detail.PARTNERS carrier = UTIL_Order.getPartnerFromOrder(salesOrder, UTIL_Order.CARRIER_PARTNER_CODE, true);
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(salesOrder.Sales.SalesOrganization, 'Sales Organization');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(salesOrder.Sales.DistributionChannel, 'DistributionChannel');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(salesOrder.Sales.Division, 'Division');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(soldToPartner.CustomerNumber, 'Sold To');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(shipToPartner.CustomerNumber, 'Ship To');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(carrier.CustomerNumber, 'Carrier');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(salesOrder.Sales.SalesOrganization, 'Sales Organization');
        if (string.isEmpty(salesOrder.CustomerPurchaseOrderNumber) && poNumRequired) {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'A PO Number is required'));
            validated = false;
        }

        if (string.isNotBlank(salesOrder.CustomerPurchaseOrderNumber)
                && salesOrder.ORDERDATA.CustomerPurchaseOrderDate == null) {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'A PO Date is required'));
            validated = false;
        }

        return validated;
    }

    private RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT getOrderMasterData(string orderTypeKey) {
        for (RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT orderType : this.docTypeMaster.ET_OUTPUT_List) {
            if (orderType.AUART == orderTypeKey)
                return orderType;
        }

        system.Debug('Was unable to locate Master Data matching key: ' + orderTypeKey);
        return null;
    }

    private boolean isPONumberRequired(string salesOrderType) {
        return getOrderMasterData(salesOrderType).X_PONUM_REQUIRED == 'X';
    }

    @testVisible
    private static boolean validateNewLineItem(SBO_EnosixSO_Detail.ITEMS item) {
        boolean result = true;

        if (string.isBlank(item.Material)) {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Material is required'));
            result = false;
        }

        if (0 > item.OrderQuantity) {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Quantity is invalid'));
            result = false;
        }

        return result;
    }

    public void addItem() {
        if (null == this.newItem || null == this.orderDetail) {
            return;
        }

        if (validateNewLineItem(newItem)) {
            addItemToOrder(this.newItem);
            this.clearItem();
            this.SimulateOrderAndUpdateSO();
        }
    }

    public void addItemToOrder(SBO_EnosixSO_Detail.ITEMS item) {
        item.ItemNumber = getNextItemNumber(this.orderDetail);

        orderDetail.ITEMS.add(item);
        SBO_EnosixSO_Detail.ITEMS_ACTION action = new SBO_EnosixSO_Detail.ITEMS_ACTION();
        action.ItemNumber = item.ItemNumber;
        action.ItemAdded = 'X';

        this.orderDetail.ITEMS_ACTION.add(action);
    }

    public void removeItem() {
        String i = System.currentPageReference().getParameters().get('i');

        removeItemfromOrderWithItemNumber(orderDetail, i);

        this.OrderDetail = simulateOrder(this.OrderDetail);
    }

    @testVisible
    static void removeItemfromOrderWithItemNumber(SBO_EnosixSO_Detail.EnosixSO salesOrder, string itemNumber) {
        List<SBO_EnosixSO_Detail.ITEMS> items = new List<SBO_EnosixSO_Detail.ITEMS>();

        if (null != salesOrder) {
            salesOrder.ITEMS.copyTo(items);
        }

        for (SBO_EnosixSO_Detail.ITEMS item : items) {
            if (item.ItemNumber == itemNumber) {
                if (null != salesOrder) {
                    salesOrder.ITEMS.remove(item);
                    system.debug('Item ' + itemNumber + ' found, and removed.');
                }
                break;
            }
        }

        List<SBO_EnosixSO_Detail.ITEMS_ACTION> items_action = new List<SBO_EnosixSO_Detail.ITEMS_ACTION>();
        if (null != salesOrder) {
            salesOrder.ITEMS_ACTION.copyTo(items_action);
        }

        for (SBO_EnosixSO_Detail.ITEMS_ACTION item_action : items_action) {
            if (item_action.ItemNumber == itemNumber) {
                if (null != salesOrder) {
                    salesOrder.ITEMS_ACTION.remove(item_action);
                    system.debug('Item action' + itemNumber + ' found, and removed.');
                }
                break;
            }
        }
    }

    @testVisible
    string getNextItemNumber(SBO_EnosixSO_Detail.EnosixSO salesOrder) {
        //Default increment if nothing has been configured.
        Integer itemIncrement = 10;

        RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT orderMasterData = getOrderMasterData(salesOrder.Sales.SalesDocumentType);

        if (null != orderMasterData && string.isNotBlank(orderMasterData.INCPO)){
            itemIncrement = Integer.valueOf(orderMasterData.INCPO);
        }            

        return getNextItemNumber(salesOrder, itemIncrement);
    }

    @testVisible
    static string getNextItemNumber(SBO_EnosixSO_Detail.EnosixSO salesOrder, Integer poIncrement) {
        List<SBO_EnosixSO_Detail.ITEMS> items = new List<SBO_EnosixSO_Detail.ITEMS>();

        if (null != salesOrder) {
            salesOrder.ITEMS.copyTo(items);
        }

        integer max = 0;

        for (SBO_EnosixSO_Detail.ITEMS item : items) {
            integer itemNumber = integer.valueOf(item.ItemNumber);
            max = Math.max(max, itemNumber);
        }

        return string.ValueOf(max + poIncrement);
    }

    public void updatepicklists() {
        this.newItem.Material = UTIL_ViewHelper.pickFirst(this.materials);
        SimulateOrderAndUpdateSO();
    }

    private static SBO_EnosixMaterial_Search.EnosixMaterial_SR searchForMaterialsBySalesArea(string salesOrginization, string distributionChannel) {
        SBO_EnosixMaterial_Search sbo = new SBO_EnosixMaterial_Search();

        sbo.SearchContext.SEARCHPARAMS.SalesOrganization = salesOrginization;
        sbo.SearchContext.SEARCHPARAMS.DistributionChannel = distributionChannel;

        SBO_EnosixMaterial_Search.EnosixMaterial_SR result = sbo.execute();

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
        }

        return result;
    }

    private static void AddMaterialsFromSearchResults(List<SelectOption> result, SBO_EnosixMaterial_Search.EnosixMaterial_SR searchResult) {
        List<SBO_EnosixMaterial_Search.SEARCHRESULT> searchResults = searchResult.getResults();
        Set<string> values = new Set<string>();
        for (SBO_EnosixMaterial_Search.SEARCHRESULT sr : searchResults) {
            if (!values.contains(sr.Material)) {
                result.add(new SelectOption(sr.Material, sr.MaterialDescription));
                values.add(sr.Material);
            }
        }
    }


    public List<SelectOption> getCreditItems() {
        List<SelectOption> rs = new List<SelectOption>();
        rs.add(new SelectOption('', 'Select a Card'));
        for (SBO_EnosixCustomer_Detail.PAYMENT_DATA pd : paymentDataItems) {
            string lastfour = pd.CardNumber.substring(pd.CardNumber.length() - 4, pd.CardNumber.length());
            rs.add(new SelectOption(pd.PaymentCardID, pd.CreditCardName + '- ' + lastfour + ' (' + pd.PaymentCardTypeDesc + ') '));
            if (pd.CreditCardName == 'X') {
                selectedPaymentID = pd.PaymentCardID;
            }
        }
        return rs;
    }

    public void updatePaymentInfo() {
        SBO_EnosixCustomer_Detail.PAYMENT_DATA payment = new SBO_EnosixCustomer_Detail.PAYMENT_DATA();
        for (SBO_EnosixCustomer_Detail.PAYMENT_DATA pd : paymentDataItems) {
            if (selectedPaymentID == pd.PaymentCardID) {
                payment = pd;
                break;
            }
        }
        SBO_EnosixSO_Detail.CCARD ccard = new SBO_EnosixSO_Detail.CCARD();
        ccard.CreditCardType = payment.PaymentCardType;
        ccard.CreditCardNumber = payment.CardNumber;
        List<SBO_EnosixSO_Detail.CCARD> orderCards = new List<SBO_EnosixSO_Detail.CCARD>();
        orderDetail.CCARD.copyTo(orderCards);
        orderCards.clear();
        orderCards.add(ccard);
    }

    public static List<OpportunityLineItem> FetchOpportunityLineItems(Opportunity opp) {
        system.debug('fetchopportunitylineitems for opp:' + opp.Id);

        List<OpportunityLineItem> lst = new List<OpportunityLineItem>();
        lst = [
                SELECT Id, OpportunityId, SortOrder, PricebookEntryId, Product2Id, Product2.Name, Name,
                        Quantity, TotalPrice, UnitPrice, ListPrice, ServiceDate, Description
                FROM OpportunityLineItem
                WHERE OpportunityId = :opp.Id
        ];
        return lst;
    }

    @testVisible
    private static SBO_EnosixSO_Detail.ITEMS TranslateOpportunityLineItem(
        OpportunityLineItem oppLine, string materialNumber, string salesOrg, string distributionChannel)
    {
        SBO_EnosixSO_Detail.ITEMS item = new SBO_EnosixSO_Detail.ITEMS();
        if (null != materialNumber)
        {
            item.Material = materialNumber;
            if (oppLine.ServiceDate != null)
            {
                item.ScheduleLineDate = String.valueOf(oppLine.ServiceDate).Replace('-', '');
            }
            item.OrderQuantity = oppLine.Quantity;
        }
        else
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,
                'Material Detail information could not be derived from the provided Product - ' + oppLine.Name
            ));
        }
        return item;
    }

    public static Opportunity FinalizeOrderandUpdateOpportunity(Opportunity opp, SBO_EnosixSO_Detail.EnosixSO orderDets) {
        List<SBO_EnosixSO_Detail.ITEMS> orderItems = new List<SBO_EnosixSO_Detail.ITEMS>();
        orderDets.ITEMS.copyTo(orderItems);
        if (opp.HasOpportunityLineItem) {
            List<OpportunityLineItem> oppItems = FetchOpportunityLineItems(opp);
            List<OpportunityLineItem> updatedOppItems = new List<OpportunityLineItem>();
            for (OpportunityLineItem oppItem : oppItems) {
                for (SBO_EnosixSO_Detail.ITEMS itm : orderItems) {
                    if (itm.Material == oppItem.Product2.Name && itm.OrderQuantity == oppItem.Quantity) {
                        oppItem.UnitPrice = itm.NetItemPrice;
                        oppItem.Quantity = itm.OrderQuantity;
                        updatedOppItems.add(oppItem);
                    }
                    // TODO: Add Checking if product is not found!
                }
            }
            upsert updatedOppItems;
        }
        opp.Amount = orderDets.NetOrderValue;
        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.CloseDate = System.today();

        //Cast strip off the leading 0's Could also be done with the string.replaceFirst(regex) method.
        //Issue arises from teh fact that SalesDocument can be longer than the max length of ENSX_EDM__OrderNumber__c
        //SAP should always automatically assign this a value, but this'll prevent issues with unit-tests potentially missing it.
        if (string.isNotEmpty(orderDets.SalesDocument))
        {
            opp.ENSX_EDM__OrderNumber__c = string.valueOf(integer.valueOf(orderDets.SalesDocument));
        }
            
        try
        {
            upsert opp;
        }
        catch (Exception ex)
        {
            ApexPages.addMessages(ex);
            return null;
        }
        return opp;
    }

   /* Begin Credt Card Entry */

    public boolean isOrderCardLimitEnabled { get { return UTIL_Order.isCardLimitEnabled; } }
    public CB_CardDetailsReceiver cdReceiver { get { return this; } }
    public Decimal CardLimit { get; set; }
    public boolean saveCapturedCard { get; set; }

    public void onReceiveCardDetails(SBO_EnosixXiIntercept_Detail.EnosixXiIntercept details) {

        displayCaptureCardButton = false;
        displayEnterCardButton = true;

        if (!isOrderCardLimitEnabled)
        {
            this.CardLimit = null;
        }
        UTIL_PaymentCards.addCardToOrder(details.RESPONSE, this.orderDetail, this.CardLimit);

        if (this.saveCapturedCard)
        {
            this.addCardToCustomer(details.RESPONSE);
        }

        this.SimulateOrderAndUpdateSO();
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

    public List<SBO_EnosixSO_Detail.CCARD> OrderCards {
        get {
        List<SBO_EnosixSO_Detail.CCARD> result = new List<SBO_EnosixSO_Detail.CCARD>();

        if (null != this.orderDetail) {
            this.orderDetail.CCARD.copyTo(result);
        }

        return result;
        }
    }

    public integer OrderCardsCount {
        get { return OrderCards.size(); }
    }

    public void actionRemoveCard() {
        String cardNumber = System.currentPageReference().getParameters().get('cardNumber');

        if (string.isBlank(cardNumber) || null == this.orderDetail) {
        return;
        }

        if (UTIL_PaymentCards.removeCardFromOrder(this.orderDetail, cardNumber)) {
        this.SimulateOrderAndUpdateSO();
        }
    }

    public void actionAddCardFromCustomer() {
        if (string.isBlank(selectedCustomerCard) || null == this.orderDetail) {
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
            if (!isOrderCardLimitEnabled)
            {
                this.CardLimit = null;
            }
            UTIL_PaymentCards.addCustomerCardToOrder(card, this.orderDetail, this.CardLimit);
            this.SimulateOrderAndUpdateSO();
            this.CardLimit = Decimal.valueOf('0.0');
        }
    }

    public List<SelectOption> CustomerPaymentCards {
        get {
            if (null == this.customerDetail)
            {
                return new List<SelectOption>();
            }
            return UTIL_PaymentCards.getPaymentCardSelectOptionsForCustomer(this.customerDetail);
        }
    }
   /* End Credt Card Entry */

}
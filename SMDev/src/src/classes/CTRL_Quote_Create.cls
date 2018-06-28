public with sharing class CTRL_Quote_Create implements CB_CardDetailsReceiver, CB_MaterialSearchReceiver {

    private SBO_EnosixMaterial_Detail.EnosixMaterial selectedMaterialDetail;
	public boolean opportunityClosed
    {
        get
        {
            return orderOpportunity.StageName.contains('Closed');
        }
    }
    public Opportunity orderOpportunity { get; private set; }
    public SBO_EnosixCustomer_Detail.EnosixCustomer customerDetail { get; private set; }
    public SBO_EnosixCustomer_Detail.EnosixCustomer shipToCustomer { get; set; }
    public SBO_EnosixQuote_Detail.ITEMS newItem { get; set; }
    public SBO_EnosixQuote_Detail.EnosixQuote quoteDetail { get; set; }

    // vars for the direct order entry
    public Account orderAccount { get; private set; }

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

    //This is a hardcode default. For testing in the PDT it's Sandard Order, in the client system this needs to be altered.
    public static string pickDefaultOrderType(List<SelectOption> options) {
        if (options.size() <= 0) return '';

        for (SelectOption option : options) {
            if (option.getValue() == 'QT')
            {
                return option.getValue();
            }                
        }
        return '';
    }

    public List<UTIL_Order.QuoteItem> displayedMaterialItems {
        get
        {
            return UTIL_Order.convertQuoteDetailToQuoteItem(quoteDetail);
        }
    }

    public List<SelectOption> paymentDataSelections { get; set; }


	/**
	 * called from Opportunity detail button, creating a new order from scratch
	 * @return [description]
	 */
    public CTRL_Quote_Create() {

        quoteDetail = new SBO_EnosixQuote_Detail.EnosixQuote();

        displayCaptureCardButton = false;
        displayEnterCardButton = true;

        initFromParameters();

        if (!Test.isRunningTest()) {
            init();
        }

        clearItem();
    }

    private void init() {

        this.docTypeMaster = UTIL_Order.getDocTypeMaster();
        this.orderMaster = UTIL_Order.getOrderTypes('EnosixQuote');

        if (null != this.orderAccount) {
            string customerId = UTIL_Account.getCustomerNumberFromAccount(this.orderAccount);
            if (string.isBlank(customerId)) {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,
                        'This account is not configured with an SAP customer'));
            } else {
                this.customerDetail = UTIL_Customer.fetchEnosixCustomer(customerId);

                if (null == this.customerSalesData) {
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING,
                            'This Account/SAP customer is not configured for Quote creation'));
                }
            }

        }

        // Copy over the customer Info
        if (null != this.customerDetail) {
            UTIL_Order.CopyCustomerInfoToQuote(this.quoteDetail, this.customerDetail);
        }

        this.quoteDetail.Sales.RequestedDeliveryDate = date.today();

        this.quoteDetail.Sales.SalesOrganization = UTIL_ViewHelper.pickFirst(SalesOrganizations);
        this.quoteDetail.Sales.DistributionChannel = UTIL_ViewHelper.pickFirst(DistributionChannels);
        this.quoteDetail.Sales.Division = UTIL_ViewHelper.pickFirst(Divisions);

        this.SoldToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(SoldToPartners);
        this.ShipToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(ShipToPartners);
        UpdateShipToPartner();
        this.quoteDetail.Sales.SalesDocumentType = pickDefaultOrderType(OrderTypes);
        this.quoteDetail.SALES.ValidFrom = Date.today();
        this.quoteDetail.SALES.ValidTo = Date.today();

        updateSalesAreas();
        initializeOpportunity();
        if (!UTIL_Event.executeEvent(UTIL_Event.QUOTE_INITIALIZED, new Map<String, object> {
            'SBO_EnosixQuote_Detail.EnosixQuote' => this.quoteDetail,
            'Opportunity' => this.orderOpportunity
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

        this.quoteDetail.CustomerPurchaseOrderNumber = this.orderOpportunity.Name;
        this.quoteDetail.ORDERDATA.CustomerPurchaseOrderDate = System.today();

        this.quoteDetail.Sales.RequestedDeliveryDate = System.today();

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
            SBO_EnosixQuote_Detail.ITEMS item = TranslateOpportunityLineItem(lineItem, materialNumber, this.quoteDetail.Sales.SalesOrganization, this.quoteDetail.Sales.DistributionChannel);
            item.ItemNumber = getNextItemNumber(this.quoteDetail);
            quoteDetail.ITEMS.add(item);
            SBO_EnosixQuote_Detail.ITEMS_ACTION action = new SBO_EnosixQuote_Detail.ITEMS_ACTION();
            action.ItemNumber = item.ItemNumber;
            action.ItemAdded = 'X';
            this.quoteDetail.ITEMS_ACTION.add(action);
        }
        this.SoldToPartner.CustomerNumber = UTIL_ViewHelper.pickFirst(SoldToPartners);
        UpdateShipToPartner();
        this.SimulateOrderAndUpdateQuote();

        this.quoteDetail.Sales.SalesDocumentType = pickDefaultOrderType(OrderTypes);
    }


    private SBO_EnosixMaterial_Search.EnosixMaterial_SR materialSearchResults;
    private RFC_SD_GET_DOC_TYPE_VALUES.RESULT docTypeMaster;
    private RFC_SD_GET_ORDER_TYPES.RESULT orderMaster;

   	/*
   	* Page Actions
   	*/

    public void updateSalesAreas() {
        if (null != this.quoteDetail) {
            this.materialSearchResults = UTIL_Material.searchForMaterialsBySalesArea(this.quoteDetail.Sales.SalesOrganization, this.quoteDetail.Sales.DistributionChannel);
        }
    }

    public void clearItem() {
        this.newItem = new SBO_EnosixQuote_Detail.ITEMS();

        if (null != this.quoteDetail) {
            //this.newItem.ScheduleLineDate = this.quoteDetail.Sales.RequestedDeliveryDate;
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
            return new string[]{
                    'B'
                    //, '*'
            };
        }
    }

    private static List<string> master_DocumentTypes {
        get {
            return new string[]{
                    'QT'
                    //, 'CBFD'
                    //,'*'
            };
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
            if (null != this.customerDetail && null != this.quoteDetail) {
                UTIL_Order.AddDistributionChannels(result, UTIL_Order.getSalesDataListFromCustomer(this.customerDetail), this.quoteDetail.Sales.SalesOrganization);
            }

            return result;
        }
    }

    public List<SelectOption> Divisions {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (null != this.customerDetail && null != this.quoteDetail) {
                UTIL_Order.AddDistributionDivisions(result, UTIL_Order.getSalesDataListFromCustomer(this.customerDetail), this.quoteDetail.Sales.SalesOrganization, this.quoteDetail.Sales.DistributionChannel);
            }

            return result;
        }
    }

    public List<SelectOption> SoldToPartners {
        get {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.customerDetail && null != this.quoteDetail) {
                UTIL_Order.AddPartners(result, UTIL_Order.getCustomerPartners(this.customerDetail, UTIL_Order.SOLD_TO_PARTNER_CODE),
                        this.quoteDetail.Sales.SalesOrganization, this.quoteDetail.Sales.DistributionChannel, this.quoteDetail.Sales.Division);
            }

            return result;
        }
    }

    public List<SelectOption> ShipToPartners
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();

            if (null != this.customerDetail && null != this.quoteDetail)
            {
                result = UTIL_SelectOption.buildOptionsFromList(
                    UTIL_Order.getShipToOptionBuilder(),
                    UTIL_Order.getPartnersByOrgChannelDivision(
                        UTIL_Order.getCustomerPartners(
                            this.customerDetail,
                            UTIL_Order.SHIP_TO_PARTNER_CODE
                        ),
                        this.quoteDetail.Sales.SalesOrganization,
                        this.quoteDetail.Sales.DistributionChannel,
                        this.quoteDetail.Sales.Division
                    )
                );
            }
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
                UTIL_Order.filterItemCategories(this.orderMaster, quoteDetail.Sales.SalesDocumentType)
            );

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

    public Boolean isCreditCardEntryDisplayed
    {
        get
        {
            return UTIL_Order.getDisplayCreditCardEntry(this.quoteDetail.SALES.SalesDocumentType);
        }
    }

    public Boolean isCreditCardSectionDisplayed
    {
        get
        {
            return UTIL_Order.getDisplayCreditCardSection(this.quoteDetail.SALES.SalesDocumentType);
        }
    }

    public SBO_EnosixQuote_Detail.PARTNERS SoldToPartner {
        get {
            return UTIL_Order.getPartnerFromQuote(this.quoteDetail, UTIL_Order.SOLD_TO_PARTNER_CODE, true);
        }
    }

    public SBO_EnosixQuote_Detail.PARTNERS ShipToPartner {
        get {
            return UTIL_Order.getPartnerFromQuote(this.quoteDetail, UTIL_Order.SHIP_TO_PARTNER_CODE, true);
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

            if (null != this.selectedMaterialDetail && null != this.quoteDetail) {
                AddPlantsFromMaterialDetail(result, this.selectedMaterialDetail, this.quoteDetail.Sales.SalesOrganization, this.quoteDetail.Sales.DistributionChannel);
            }

            return result;
        }
    }

    public PageReference initCreate() {
        return null;
    }

	/**
	 * called from the new button on opportunity Order SAP related list
	 * @param  stdController [description]
	 * @return               [description]
	 */
    public void SimulateOrderAndUpdateQuote() {
        SBO_EnosixQuote_Detail enosixQuoteDetail = new SBO_EnosixQuote_Detail();

        SBO_EnosixQuote_Detail.EnosixQuote simulatedQuote = enosixQuoteDetail.command('CMD_SIMULATE_QUOTE', quoteDetail);
        if (simulatedQuote.isSuccess()) {
            system.debug('simulated order was a success');
            this.quoteDetail = simulatedQuote;
        }
        ensx.EnosixFramework.displayResultMessages(simulatedQuote, ensx.EnosixFramework.MessageType.INFO);
    }

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

    public void singleMaterialSelected() {
        if (null != this.newItem) {
            selectedMaterialDetail = UTIL_Material.getMaterialFromMaterialNumber(newItem.Material);
            this.newItem.Plant = UTIL_ViewHelper.pickFirst(PlantSelections);
            this.newItem.OrderQuantity = 1;
        }
    }

    public List<string> defaultQuoteMaterialTypes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'Quote.DefaultMaterialTypes', String.class, new List<String>{ 'FERT' });
        }
    }

    public List<string> defaultQuoteProductAttributes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'Quote.DefaultMaterialProductAttributes', String.class, new List<String>{ });
        }
    }

    public boolean isQuoteMaterialAutoSearchEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Quote.IsMaterialAutoSearchEnabled', true);
        }
    }

    public CB_MaterialSearchReceiver msReceiver { get { return this; } }

    public void onReceiveMaterialSearchResults(string id, List<CTRL_MaterialSearch.MaterialSearchResult> results) {
        addSelectedMaterialsAsItems(results);
    }

    public void addSelectedMaterialsAsItems(List<CTRL_MaterialSearch.MaterialSearchResult> materials) {
        List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();

        // Validate all items first
        for (CTRL_MaterialSearch.MaterialSearchResult material : materials) {
            SBO_EnosixQuote_Detail.ITEMS item = new SBO_EnosixQuote_Detail.ITEMS();
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
        for (SBO_EnosixQuote_Detail.ITEMS item : items) {
            addItemToOrder(item);
        }
        this.SimulateOrderAndUpdateQuote();
    }

    public PageReference displayQuote() {
        if (null != this.orderOpportunity)
        {
            UTIL_PageState.current.quoteId = this.orderOpportunity.ENSX_EDM__Quote_Number__c;
        }
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_Quote_Detail, UTIL_PageState.current);
    }

    public PageReference redirectToCreateCustomer() {
        return UTIL_Customer.redirectToCreateCustomer();
    }

	/**
	 * methods for creating a whole new order
	 */

    public PageReference createNewQuote() {

        if (!validateQuote(this.quoteDetail)) {
            return null;
        }

        removeAllScheduleLinesFromOrder(this.quoteDetail);
        System.debug(this.quoteDetail);
        System.debug(this.quoteDetail.Sales.SalesDocumentType);

        SBO_EnosixQuote_Detail sbo = new SBO_EnosixQuote_Detail();

        SBO_EnosixQuote_Detail.EnosixQuote result = sbo.save(quoteDetail);
        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ensx.EnosixFramework.MessageType.INFO);
            return null;
        }

        this.quoteDetail = result;
        if (orderOpportunity != null) {

            this.orderOpportunity = FinalizeQuoteandUpdateOpportunity(this.orderOpportunity, this.quoteDetail);
        }
        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Order was Successfully Saved.'));

        return displayQuote();
    }

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

    @testVisible
    private static void removeAllScheduleLinesFromOrder(SBO_EnosixQuote_Detail.EnosixQuote quote) {
        List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> schedule_lines = new List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE>();

        if (null != quote) {
            quote.ITEMS_SCHEDULE.copyTo(schedule_lines);

            for (SBO_EnosixQuote_Detail.ITEMS_SCHEDULE item : schedule_lines) {
                quote.ITEMS_SCHEDULE.remove(item);
            }
        }
    }

    private boolean validateQuote(SBO_EnosixQuote_Detail.EnosixQuote quote) {
        return validateQuote(quote, isPONumberRequired(quote.Sales.SalesDocumentType));
    }

    @testVisible
    private static boolean validateQuote(SBO_EnosixQuote_Detail.EnosixQuote quote, boolean poNumRequired) {
        boolean validated = true;

        SBO_EnosixQuote_Detail.PARTNERS soldToPartner = UTIL_Order.getPartnerFromQuote(quote, UTIL_Order.SOLD_TO_PARTNER_CODE, true);
        SBO_EnosixQuote_Detail.PARTNERS shipToPartner = UTIL_Order.getPartnerFromQuote(quote, UTIL_Order.SHIP_TO_PARTNER_CODE, true);
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(quote.Sales.SalesOrganization, 'Sales Organization');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(quote.Sales.DistributionChannel, 'DistributionChannel');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(quote.Sales.Division, 'Division');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(soldToPartner.CustomerNumber, 'Sold To');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(shipToPartner.CustomerNumber, 'Ship To');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(quote.Sales.SalesOrganization, 'Sales Organization');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(String.valueOf(quote.Sales.ValidFrom), 'Valid From');
        validated = validated && UTIL_ViewHelper.validateStringPropertyIsNotBlank(String.valueOf(quote.Sales.ValidTo), 'Valid To');

        if (string.isEmpty(quote.CustomerPurchaseOrderNumber) && poNumRequired) {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'A PO Number is required'));
            validated = false;
        }

        if (string.isNotBlank(quote.CustomerPurchaseOrderNumber)
                && quote.ORDERDATA.CustomerPurchaseOrderDate == null) {
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

    private boolean isPONumberRequired(string quoteType) {
        return getOrderMasterData(quoteType).X_PONUM_REQUIRED == 'X';
    }

    @testVisible
    private static boolean validateNewLineItem(SBO_EnosixQuote_Detail.ITEMS item) {
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

        if (null == this.newItem || null == this.quoteDetail) {
            return;
        }

        if (validateNewLineItem(newItem)) {
            addItemToOrder(this.newItem);
            this.clearItem();
        }
    }

    public void addItemToOrder(SBO_EnosixQuote_Detail.ITEMS item) {
        item.ItemNumber = getNextItemNumber(this.quoteDetail);

        quoteDetail.ITEMS.add(item);
        SBO_EnosixQuote_Detail.ITEMS_ACTION action = new SBO_EnosixQuote_Detail.ITEMS_ACTION();
        action.ItemNumber = item.ItemNumber;
        action.ItemAdded = 'X';

        this.quoteDetail.ITEMS_ACTION.add(action);
    }

    public void removeItem() {
        String i = System.currentPageReference().getParameters().get('i');

        removeItemfromOrderWithItemNumber(quoteDetail, i);

        SimulateOrderAndUpdateQuote();
    }

    @testVisible
    static void removeItemfromOrderWithItemNumber(SBO_EnosixQuote_Detail.EnosixQuote quote, string itemNumber) {
        List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();

        if (null != quote) {
            quote.ITEMS.copyTo(items);
        }

        for (SBO_EnosixQuote_Detail.ITEMS item : items) {
            if (item.ItemNumber == itemNumber) {
                if (null != quote) {
                    quote.ITEMS.remove(item);
                    system.debug('Item ' + itemNumber + ' found, and removed.');
                }
                break;
            }
        }

        List<SBO_EnosixQuote_Detail.ITEMS_ACTION> items_action = new List<SBO_EnosixQuote_Detail.ITEMS_ACTION>();
        if (null != quote) {
            quote.ITEMS_ACTION.copyTo(items_action);
        }

        for (SBO_EnosixQuote_Detail.ITEMS_ACTION item_action : items_action) {
            if (item_action.ItemNumber == itemNumber) {
                if (null != quote) {
                    quote.ITEMS_ACTION.remove(item_action);
                    system.debug('Item action' + itemNumber + ' found, and removed.');
                }
                break;
            }
        }
    }

    string getNextItemNumber(SBO_EnosixQuote_Detail.EnosixQuote quote) {
        //Default increment if nothing has been configured.
        Integer itemIncrement = 10;

        RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT orderMasterData = getOrderMasterData(quote.Sales.SalesDocumentType);

        if (null != orderMasterData && string.isNotBlank(orderMasterData.INCPO))
            itemIncrement = Integer.valueOf(orderMasterData.INCPO);

        return getNextItemNumber(quote, itemIncrement);
    }

    @testVisible
    static string getNextItemNumber(SBO_EnosixQuote_Detail.EnosixQuote quote, Integer poIncrement) {
        List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();

        if (null != quote) {
            quote.ITEMS.copyTo(items);
        }

        integer max = 0;

        for (SBO_EnosixQuote_Detail.ITEMS item : items) {
            integer itemNumber = integer.valueOf(item.ItemNumber);
            max = Math.max(max, itemNumber);
        }

        return string.ValueOf(max + poIncrement);
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
    private static SBO_EnosixQuote_Detail.ITEMS TranslateOpportunityLineItem(OpportunityLineItem oppLine, string materialNumber, string salesOrg, string distributionChannel)
    {
        SBO_EnosixQuote_Detail.ITEMS item = new SBO_EnosixQuote_Detail.ITEMS();
        if (null != materialNumber)
        {
            item.Material = materialNumber;
            if (oppLine.ServiceDate != null)
            {
                item.ScheduleLineDate = dateToSapStringFormat(oppLine.ServiceDate);
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

    // dateToSapStringFormat()
    //
    // Convert input from Date to YYYYMMDD String
    public static String dateToSapStringFormat(Date d)
    {
        Datetime dt = Datetime.newInstance(d, Datetime.now().time());
        return dt.format('yyyyMMdd');
    }

    public static Opportunity FinalizeQuoteandUpdateOpportunity(Opportunity opp, SBO_EnosixQuote_Detail.EnosixQuote quoteDetails) {
        List<SBO_EnosixQuote_Detail.ITEMS> orderItems = new List<SBO_EnosixQuote_Detail.ITEMS>();
        quoteDetails.ITEMS.copyTo(orderItems);
        if (opp.HasOpportunityLineItem) {
            List<OpportunityLineItem> oppItems = FetchOpportunityLineItems(opp);
            List<OpportunityLineItem> updatedOppItems = new List<OpportunityLineItem>();
            for (OpportunityLineItem oppItem : oppItems) {
                for (SBO_EnosixQuote_Detail.ITEMS itm : orderItems) {
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
        opp.ENSX_EDM__Quote_Number__c = quoteDetails.SalesDocument;
        opp.Amount = quoteDetails.NetOrderValue;
        opp.CloseDate = System.today();

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
        UTIL_PaymentCards.addCardToQuote(details.RESPONSE, this.quoteDetail, this.CardLimit);

        if (this.saveCapturedCard)
        {
            this.addCardToCustomer(details.RESPONSE);
        }

        this.SimulateOrderAndUpdateQuote();
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

    public List<SBO_EnosixQuote_Detail.CCARD> QuoteCards {
        get {
            //todo replace this type
            List<SBO_EnosixQuote_Detail.CCARD> result = new List<SBO_EnosixQuote_Detail.CCARD>();

            if (null != this.quoteDetail) {
                this.quoteDetail.CCARD.copyTo(result);
            }

            return result;
        }
    }

    public integer QuoteCardsCount {
        get { return QuoteCards.size(); }
    }

    public void actionRemoveCard() {
        String cardNumber = System.currentPageReference().getParameters().get('cardNumber');

        if (string.isBlank(cardNumber) || null == this.quoteDetail) {
            return;
        }

        if (UTIL_PaymentCards.removeCardFromQuote(this.quoteDetail, cardNumber)) {
            this.SimulateOrderAndUpdateQuote();
        }
    }

    public void actionAddCardFromCustomer() {
        if (string.isBlank(selectedCustomerCard) || null == this.quoteDetail) {
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
            UTIL_PaymentCards.addCustomerCardToQuote(card,
                    this.quoteDetail, this.CardLimit);
            this.SimulateOrderAndUpdateQuote();
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
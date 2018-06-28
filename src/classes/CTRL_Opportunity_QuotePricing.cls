public with sharing class CTRL_Opportunity_QuotePricing implements CB_MaterialSearchReceiver
{
    public Opportunity opp { get; set; }

    public List<string> defaultOpportunityMaterialTypes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'Opportunity.DefaultMaterialTypes', String.class, new List<String>{ 'FERT' });
        }
    }

    public List<string> defaultOpportunityProductAttributes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'Opportunity.DefaultMaterialProductAttributes', String.class, new List<String>{ });
        }
    }

    public boolean isOpportunityMaterialAutoSearchEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Opportunity.IsMaterialAutoSearchEnabled', true);
        }
    }

    public boolean isOpportunitySalesInfoEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Opportunity.IsSalesInfoEnabled', true);
        }
    }

    public boolean isOpportunityATPEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Opportunity.IsAtpEnabled', true);
        }
    }

    public CB_MaterialSearchReceiver receiver { get {return this;} }

    public SBO_EnosixCustomer_Detail.EnosixCustomer selectedSAPCustomer { get; set; }

    public Pricebook2 opportunityPriceBook { get; private set; }

    private boolean isValidMaterials = true;

    public boolean canQuotePrices
    {
        get
        {
            return null != this.opp && null != this.opportunityPriceBook && null != selectedSAPCustomer && isValidMaterials;
        }
    }

    //ctor
    public CTRL_Opportunity_QuotePricing()
    {
        this.opp = this.getOpportunityForParameters();
        this.opportunityPriceBook = UTIL_Object_Lookups.getOpportunityPriceBook(this.opp);

        Pricebook2 standardPricebook = UTIL_Object_Lookups.getStandardPriceBook();

        if (null == this.opportunityPriceBook || this.opportunityPriceBook.Id != standardPricebook.Id)
        {
            this.opportunityPriceBook = standardPricebook;
        }

        this.quoteDetail = new SBO_EnosixQuote_Detail.EnosixQuote();

        if (!Test.isRunningTest())
        {
            this.initOpportunityQuotePricing();
        }
    }

    /* List of line items displayed */
    public List<UTIL_Order.QuoteItem> displayedMaterialItems
    {
        get
        {
            return UTIL_Order.convertQuoteDetailToQuoteItem(this.quoteDetail);
        }
    }

    /* Quote Total */
    public Decimal netOpportunityPrice
    {
        get
        {
            Decimal result = 0.0;

            if (null != this.quoteDetail)
            {
                result = this.quoteDetail.NetOrderValue;
            }
            return result;
        }
    }

    /*
    public List<SelectOption> stageSelectOptions {
        get {
            List<SelectOption> options = new List<SelectOption>();
            if (this.opportunityStages != null) {
                for (OpportunityStage os :opportunityStages) {
                    if (os.MasterLabel != null)
                        options.add(new SelectOption(os.MasterLabel, os.MasterLabel));
                }
            }
            return options;
        }
    }
    */
    public SBO_EnosixQuote_Detail.EnosixQuote quoteDetail { get; set; }
    public SBO_EnosixQuote_Detail.SALES salesData
    {
        get
        {
            if (quoteDetail == null) return null;
            return quoteDetail.SALES;
        }
    }
    @testVisible
    private static List<string> master_DocumentCategoryTypes
    {
        get
        {
            return new string[]
            {
                    'B'
                    , '*'
            };
        }
    }
    @testVisible
    private static List<string> master_DocumentTypes
    {
        get
        {
            return new string[]
            {
                    'QT'
                    //,'*'
            };
        }
    }
    private RFC_SD_GET_DOC_TYPE_VALUES.RESULT docTypeMaster;

    public List<SelectOption> OrderTypes
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.docTypeMaster)
            {
                UTIL_Order.AddDocTypesOfCategory(result, docTypeMaster.ET_OUTPUT_List, master_DocumentCategoryTypes, master_DocumentTypes);
            }
            result.sort();
            return result;
        }
    }

    public List<SelectOption> SalesOrganizations
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.selectedSAPCustomer)
            {
                UTIL_Order.AddSalesOrganizations(result, UTIL_Order.getSalesDataListFromCustomer(this.selectedSAPCustomer));
            }

            return result;
        }
    }

    public List<SelectOption> DistributionChannels
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.selectedSAPCustomer && null != this.quoteDetail)
            {
                UTIL_Order.AddDistributionChannels(result, UTIL_Order.getSalesDataListFromCustomer(this.selectedSAPCustomer), this.salesData.SalesOrganization);
            }

            return result;
        }
    }

    public List<SelectOption> Divisions
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();

            if (null != this.selectedSAPCustomer && null != this.quoteDetail)
            {
                UTIL_Order.AddDistributionDivisions(result, UTIL_Order.getSalesDataListFromCustomer(this.selectedSAPCustomer), this.salesData.SalesOrganization, this.salesData.DistributionChannel);
            }

            return result;
        }
    }

    public List<SelectOption> SoldToPartners
    {
        get
        {
            List<SelectOption> result = new List<SelectOption>();
            if (null != this.selectedSAPCustomer && null != this.quoteDetail)
            {
                UTIL_Order.AddPartners(result, UTIL_Order.getCustomerPartners(this.selectedSAPCustomer, UTIL_Order.SOLD_TO_PARTNER_CODE),
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

            if (null != this.selectedSAPCustomer && null != this.quoteDetail)
            {
                result = UTIL_SelectOption.buildOptionsFromList(
                        UTIL_Order.getShipToOptionBuilder(),
                        UTIL_Order.getPartnersByOrgChannelDivision(
                                UTIL_Order.getCustomerPartners(
                                        this.selectedSAPCustomer,
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

    public Boolean isShipToPartnerAddressDisplayed
    {
        get
        {
            return UTIL_Order.isShipToPartnerAddressDisplayed;
        }
    }

    public SBO_EnosixQuote_Detail.PARTNERS SoldToPartner
    {
        get
        {
            return UTIL_Order.getPartnerFromQuote(this.quoteDetail, UTIL_Order.SOLD_TO_PARTNER_CODE, true);
        }
    }

    public SBO_EnosixQuote_Detail.PARTNERS ShipToPartner
    {
        get
        {
            return UTIL_Order.getPartnerFromQuote(this.quoteDetail, UTIL_Order.SHIP_TO_PARTNER_CODE, true);
        }
    }

    private void TranslateOpportunityLineItemsAndAddToQuote(List<OpportunityLineItem> lineItems)
    {
        List<SBO_EnosixQuote_Detail.ITEMS> itms = new List<SBO_EnosixQuote_Detail.ITEMS>();
        Decimal total = 0.0;
        Set<Id> productIdList = new Set<Id>();
        for (OpportunityLineItem oli: lineItems)
        {
            if (oli.Product2 != null)
            {
                productIdList.add(oli.Product2.Id);
            }
        }
        Map<Id, String> productSAPMaterailNumberList = UTIL_Product.getSAPMaterialNumbersFromProductList(productIdList);

        for (OpportunityLineItem oli: lineItems)
        {
            SBO_EnosixQuote_Detail.ITEMS itm = new SBO_EnosixQuote_Detail.ITEMS();
            itm.NetItemPrice = oli.UnitPrice;
            itm.OrderQuantity = oli.Quantity;
            itm.ItemDescription = oli.Description;
            itm.Material = productSAPMaterailNumberList.get(oli.Product2.Id);
            itm.NetOrderValue = oli.UnitPrice * oli.Quantity;
            if (null != oli.ServiceDate)
                itm.ScheduleLineDate = oli.ServiceDate.format();
            itms.add(itm);
            total = total + itm.NetOrderValue;
        }
        this.addItemsToQuote(itms);

        this.quoteDetail.NetOrderValue = total;
    }
    private Opportunity getOpportunityForParameters()
    {
        if (null != UTIL_PageState.current.opportunityId)
        {
            return UTIL_Object_Lookups.getOpportunityById(UTIL_PageState.current.opportunityId);
        }
        else
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'No Opportunity Id Provided'));
            return new Opportunity();
        }
    }
    private RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT getOrderMasterData(string orderTypeKey)
    {
        for (RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT orderType : this.docTypeMaster.ET_OUTPUT_List)
        {
            if (orderType.AUART == orderTypeKey)
                return orderType;
        }
        system.Debug('Was unable to locate Master Data matching key: ' + orderTypeKey);
        return null;
    }

    public void onReceiveMaterialSearchResults(string id, List<CTRL_MaterialSearch.MaterialSearchResult> results)
    {
        for (CTRL_MaterialSearch.MaterialSearchResult msr : results)
        {
            SBO_EnosixQuote_Detail.ITEMS itm = new SBO_EnosixQuote_Detail.ITEMS();
            itm.Material = msr.material.Material;
            itm.ItemDescription = msr.material.MaterialDescription;
            itm.ScheduleLineDate = msr.scheduleDate;
            itm.OrderQuantity = msr.quantity;
            itm.ItemNumber = getNextItemNumber(quoteDetail);
            quoteDetail.Items.add(itm);

            SBO_EnosixQuote_Detail.ITEMS_ACTION act = new SBO_EnosixQuote_Detail.ITEMS_ACTION();
            act.ItemAdded = 'X';
            act.ItemNumber = itm.ItemNumber;
            quoteDetail.ITEMS_ACTION.add(act);
        }

        this.SimulateOpportunityQuote();
    }

    public void initOpportunityQuotePricing()
    {
        if (this.salesData.SalesDocumentType == null || this.salesData.SalesDocumentType == '')
        {
            this.salesData.SalesDocumentType = CTRL_Opportunity_QuotePricing.master_DocumentTypes.get(0);
        }
        this.docTypeMaster = UTIL_Order.getDocTypeMaster();
        //if the current selected Account doesnt have a customer number, select the default customer for simulation
        this.selectedSAPCustomer = getEnosixCustomerFromOpportunity(this.opp);

        if (null == this.selectedSAPCustomer)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Opportunity account not configured as SAP Customer.'));
        }

        this.salesData.SalesOrganization = UTIL_ViewHelper.pickFirst(this.SalesOrganizations);
        this.salesData.DistributionChannel = UTIL_ViewHelper.pickFirst(this.DistributionChannels);
        this.salesData.Division = UTIL_ViewHelper.pickFirst(this.Divisions);
        this.TranslateOpportunityLineItemsAndAddToQuote(UTIL_Order.getOpportunityLineItemsFromOpportunity(this.opp));

        if (!UTIL_Event.executeEvent(UTIL_Event.OPPORTUNITY_QUOTEPRICING_INITIALIZING, new Map<String, object>
        {
                'SBO_EnosixQuote_Detail.EnosixQuote' => this.quoteDetail,
                'Opportunity' => opp
        }).isSuccess)
        {
            return;
        }

        this.SimulateOpportunityQuote();

        if (!UTIL_Event.executeEvent(UTIL_Event.OPPORTUNITY_QUOTEPRICING_INITIALIZED, new Map<String, object>
        {
                'SBO_EnosixQuote_Detail.EnosixQuote' => this.quoteDetail,
                'Opportunity' => opp
        }).isSuccess)
        {
            return;
        }
    }

    private static SBO_EnosixCustomer_Detail.EnosixCustomer getEnosixCustomerFromOpportunity(Opportunity opp)
    {
        Account a = UTIL_Account.getAccountFromOpportunity(opp);
        string custNumb = UTIL_Account.getCustomerNumberFromAccount(a);
        if (string.isNotEmpty(custNumb))
        {
            return UTIL_Customer.fetchEnosixCustomer(custNumb);
        }
        return null;
    }

    public void SimulateOpportunityQuote()
    {
        if (this.quoteDetail.ITEMS.size() > 0)
        {

            SBO_EnosixQuote_Detail sbo = new SBO_EnosixQuote_Detail();

            if (null != ShipToPartner && String.isNotBlank(ShipToPartner.CustomerNumber))
            {
                quoteDetail.SoldToParty = ShipToPartner.CustomerNumber;
            }
            else if (null != this.selectedSAPCustomer)
            {
                quoteDetail.SoldToParty = this.selectedSAPCustomer.CustomerNumber;
                ShipToPartner.CustomerNumber = quoteDetail.SoldToParty;
            }

            this.SoldToPartner.CustomerNumber = quoteDetail.SoldToParty;

            SBO_EnosixQuote_Detail.EnosixQuote result = sbo.command('CMD_SIMULATE_QUOTE', quoteDetail);
            if (result.isSuccess())
            {
                quoteDetail = result;
            }
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages

            isValidMaterials = true;
            List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();
            if (null != quoteDetail)
            {
                quoteDetail.ITEMS.copyTo(items);
            }
            for (SBO_EnosixQuote_Detail.ITEMS item : items)
            {
                if (null == item.NetItemPrice)
                {
                    isValidMaterials = false;
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '"' + item.ItemDescription + '" material missing Item Price in SAP'));
                }
            }
        }
    }

    public boolean ValidateOpportunity()
    {
        boolean valid = true;
        if (this.quoteDetail.ITEMS.size() == 0)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'There must be at least one Material added to the Opportunity'));
            valid = false;
        }
        return valid;
    }

    public void updateSalesAreas()
    {
        if (null != this.quoteDetail)
        {
        }
    }
    public PageReference UpdateOpportunity()
    {
        if (ValidateOpportunity())
        {
            //get first top PriceBook
            if (!this.addQuoteLineItemsToOpportunityFromPriceBook(this.displayedMaterialItems, this.opp, this.opportunityPriceBook))
            {
                return null;
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

            if (!UTIL_Event.executeEvent(UTIL_Event.OPPORTUNITY_QUOTEPRICING_UPDATED, new Map<String, object>
            {
                    'SBO_EnosixQuote_Detail.EnosixQuote' => this.quoteDetail,
                    'Opportunity' => opp
            }).isSuccess)
            {
                return null;
            }

            return UTIL_PageFlow.redirectTo('/' + opp.Id, null);
        }
        return null;
    }

    public void removeItem()
    {
        String i = System.currentPageReference().getParameters().get('i');
        this.removeItemfromOrderWithItemNumber(this.quoteDetail, i);
        this.SimulateOpportunityQuote();

    }
    @testVisible
    private void removeItemfromOrderWithItemNumber(SBO_EnosixQuote_Detail.EnosixQuote quoteDetail, string itemNumber)
    {
        List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();

        if (null != quoteDetail)
        {
            quoteDetail.ITEMS.copyTo(items);
        }
        SBO_EnosixQuote_Detail.ITEMS itemToRemove = null;
        for (SBO_EnosixQuote_Detail.ITEMS item: items)
        {
            if (item.ItemNumber == itemNumber)
            {
                if (null != quoteDetail)
                {
                    itemToRemove = item;
                }
                break;
            }
        }
        if (null == itemToRemove)
        {
            return;
        }

        quoteDetail.ITEMS.remove(itemToRemove);

        List<SBO_EnosixQuote_Detail.ITEMS_ACTION> items_action = new List<SBO_EnosixQuote_Detail.ITEMS_ACTION>();
        if (null != quoteDetail)
        {
            quoteDetail.ITEMS_ACTION.copyTo(items_action);
        }

        for (SBO_EnosixQuote_Detail.ITEMS_ACTION item_action : items_action)
        {
            if (item_action.ItemNumber == itemNumber)
            {
                if (null != quoteDetail)
                {
                    quoteDetail.ITEMS_ACTION.remove(item_action);
                    system.debug('Item action' + itemNumber + ' found, and removed.');
                }
                break;
            }
        }
    }
    public void addSelectedMaterialsAsItems(List<CTRL_MaterialSearch.MaterialSearchResult> materials)
    {
        List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();
        // Validate all items first
        for (CTRL_MaterialSearch.MaterialSearchResult material : materials)
        {
            SBO_EnosixQuote_Detail.ITEMS item = new SBO_EnosixQuote_Detail.ITEMS();
            item.Material = material.material.Material;
            item.OrderQuantity = material.quantity;
            items.add(item);
        }
        this.addItemsToQuote(items);
        this.SimulateOpportunityQuote();
    }
    public void addItemsToQuote(List<SBO_EnosixQuote_Detail.ITEMS> items)
    {
        // Now that all the data is validated, we can actually add the items
        for (SBO_EnosixQuote_Detail.ITEMS item :items)
        {
            item.ItemNumber = getNextItemNumber(this.quoteDetail);

            quoteDetail.ITEMS.add(item);
            SBO_EnosixQuote_Detail.ITEMS_ACTION action = new SBO_EnosixQuote_Detail.ITEMS_ACTION();
            action.ItemNumber = item.ItemNumber;
            action.ItemAdded = 'X';

            this.quoteDetail.ITEMS_ACTION.add(action);
        }
    }
    string getNextItemNumber(SBO_EnosixQuote_Detail.EnosixQuote quoteDetail)
    {
        //Default increment if nothing has been configured.
        Integer itemIncrement = 10;
        RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT orderMasterData = getOrderMasterData(quoteDetail.Sales.SalesDocumentType);
        if (null != orderMasterData && string.isNotBlank(orderMasterData.INCPO))
            itemIncrement = Integer.valueOf(orderMasterData.INCPO);
        return getNextItemNumber(quoteDetail, itemIncrement);
    }

    @testVisible
    static string getNextItemNumber(SBO_EnosixQuote_Detail.EnosixQuote quoteDetail, Integer poIncrement)
    {
        List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();

        if (null != quoteDetail)
        {
            quoteDetail.ITEMS.copyTo(items);
        }

        integer max = 0;

        for (SBO_EnosixQuote_Detail.ITEMS item : items)
        {
            integer itemNumber = integer.valueOf(item.ItemNumber);
            max = Math.max(max, itemNumber);
        }

        return string.ValueOf(max + poIncrement);
    }
    @testVisible
    static void removeItemfromQuoteWithItemNumber(SBO_EnosixQuote_Detail.EnosixQuote quoteDetail, string itemNumber)
    {
        List<SBO_EnosixQuote_Detail.ITEMS> items = new List<SBO_EnosixQuote_Detail.ITEMS>();

        if (null != quoteDetail)
        {
            quoteDetail.ITEMS.copyTo(items);
        }

        for (SBO_EnosixQuote_Detail.ITEMS item : items)
        {
            if (item.ItemNumber == itemNumber)
            {
                if (null != quoteDetail)
                {
                    quoteDetail.ITEMS.remove(item);
                }
                break;
            }
        }

        List<SBO_EnosixQuote_Detail.ITEMS_ACTION> items_action = new List<SBO_EnosixQuote_Detail.ITEMS_ACTION>();
        if (null != quoteDetail)
        {
            quoteDetail.ITEMS_ACTION.copyTo(items_action);
        }

        for (SBO_EnosixQuote_Detail.ITEMS_ACTION item_action : items_action)
        {
            if (item_action.ItemNumber == itemNumber)
            {
                if (null != quoteDetail)
                {
                    quoteDetail.ITEMS_ACTION.remove(item_action);
                }
                break;
            }
        }
    }

    @testVisible
    private static Product2 createProductFromItem(SBO_EnosixQuote_Detail.ITEMS item)
    {
        Product2 result = new Product2();
        System.debug(item.ItemDescription);
        System.debug(item.Material);
        result.Description = item.ItemDescription;
        result.Name = item.Material;
        result.ProductCode = item.Material;
        result.IsActive = true;
        UTIL_Product.setProductMaterialField(result, item.Material);
        System.debug('createProductFromItem');
        System.debug(item);
        System.debug(result);
        return result;
    }

    @testVisible
    private static PricebookEntry createEntryForProduct(Pricebook2 pricebook, Id productId, String currencyIsoCode)
    {
        PricebookEntry result = 
            new PricebookEntry(
                Pricebook2Id = pricebook.Id, 
                Product2Id = productId, 
                UnitPrice = 0, 
                IsActive = true, 
                UseStandardPrice = false,
                CurrencyIsoCode = currencyIsoCode);

        return result;
    }

    private void deleteOpportunityLineItems(String oppId)
    {
        List<OpportunityLineItem> oppItems = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :oppId];
        delete oppItems;
    }

    private boolean addQuoteLineItemsToOpportunityFromPriceBook(List<UTIL_Order.QuoteItem> materials, Opportunity opp, Pricebook2 pb2)
    {
        Map<Id, PricebookEntry> pricebookEntries = UTIL_Pricebook.getEntriesForPricebook(pb2, opp.CurrencyIsoCode);
        Map<string, Id> materialToProductIdMap = UTIL_Product.getMaterialToProductIdMap();

        this.deleteOpportunityLineItems(this.opp.Id);
        String oppCurrency = opp.CurrencyIsoCode;
        this.opp.Pricebook2Id = pb2.Id;

        try
        {
            upsert this.opp;
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return false;
        }

        List<Product2> productList = new List<Product2>();
        List<PricebookEntry> entryList = new List<PricebookEntry>();
        List<OpportunityLineItem> lineItemList = new List<OpportunityLineItem>();

        for (UTIL_Order.QuoteItem msr: materials)
        {
            String materialNumber = msr.item.Material;
            if (!materialToProductIdMap.containsKey(materialNumber))
            {
                Product2 product = createProductFromItem(msr.item);
                productList.add(product);
                materialToProductIdMap.put(materialNumber, null);
            }
        }
        try
        {
            upsert productList;
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return false;
        }

        for (Product2 product : productList)
        {
            String materialNumber = product.Name;
            materialToProductIdMap.put(materialNumber, product.Id);
        }
        
        for (UTIL_Order.QuoteItem msr: materials)
        {
            String materialNumber = msr.item.Material;
            Id productId = materialToProductIdMap.get(materialNumber);
            PricebookEntry entry = pricebookEntries.get(productId);
           
            if (null == entry || (oppCurrency != entry.CurrencyIsoCode))
            {
                entry = createEntryForProduct(pb2, productId, oppCurrency);
                entryList.add(entry);
            }
            else if (!entry.IsActive)
            {
                entry.IsActive = true;
                entryList.add(entry);
            }
        }
        try
        {
            upsert entryList;
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return false;
        }

        for (PricebookEntry entry : entryList)
        {
            Id productId = entry.Product2Id;
            pricebookEntries.put(productId, entry);
        }
        for (UTIL_Order.QuoteItem msr: materials)
        {
            String materialNumber = msr.item.Material;
            Id productId = materialToProductIdMap.get(materialNumber);
            PricebookEntry entry = pricebookEntries.get(productId);
            // Create matching opportunity item from quote
            OpportunityLineItem lineItem = this.createOpportiyLineItemFromMaterialSearchPriceEstimate(msr.item, entry);
            lineItemList.add(lineItem);
        }
        try
        {
            upsert lineItemList;
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return false;
        }
        opp.OpportunityLineItems.addAll(lineItemList);
        return true;
    }

    @testVisible
    private OpportunityLineItem createOpportiyLineItemFromMaterialSearchPriceEstimate(
            SBO_EnosixQuote_Detail.ITEMS msr,
            PricebookEntry pbitem)
    {
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Opportunity = this.opp;
        oli.OpportunityId = this.opp.Id;
        oli.PricebookEntry = pbitem;
        oli.PricebookEntryId = pbitem.Id;
        oli.Description = msr.ItemDescription;
        oli.Quantity = msr.OrderQuantity;
        oli.UnitPrice = msr.NetItemPrice;
        try
        {
            if (!String.isBlank(msr.ScheduleLineDate))
                oli.ServiceDate = Date.parse(msr.ScheduleLineDate);
        }
        catch (Exception e)
        {
            /* ignore date parse failure */
        }
        return oli;
    }
}
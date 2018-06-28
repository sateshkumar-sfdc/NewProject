public with sharing class CTRL_MaterialSearch
{
    public boolean isOnLoadComplete { get; set; }
    public string material { get; set; }
    public string productHierarchy { get; set; }
    public string searchDescription { get; set; }
    @testVisible
    public List<MaterialSearchResult> searchResults { get; private set; }

    // These booleans track if all assignTo props are set so we can trigger
    // the initial default save and auto-search when it's ready. This prevents
    // search and other onload settings from happening multiple times which
    // prevents slow loads and checkbox flicker
    private boolean isComponentIdSet = false;
    private boolean isSearchReceiverSet = false;
    private boolean isMultiSelectEnabledSet = false;
    private boolean isScheduleDateEnabledSet = false;
    private boolean isAutoSearchEnabledSet = false;
    private boolean isSearchOnClearEnabledSet = false;
    private boolean isQuantityEnabledSet = false;
    private boolean isSalesOrgSet = false;
    private boolean isDistChannelSet = false;
    private boolean isDefaultMaterialSet = false;
    private boolean isDefaultHierarchySet = false;
    private boolean isDefaultDescriptionSet = false;
    private boolean isDefaultTypesSet = false;
    private boolean isDefaultAttributesSet = false;
    private boolean isListHeightSet = false;

    public CTRL_MaterialSearch()
    {
        this.isOnLoadComplete = false;
        this.rfcSearchOptions = getSearchOptions();
    }

    public string componentId
    {
        get;
        set
        {
            this.componentId = value;
            this.isComponentIdSet = true;
            loadIfReady();
        }
    }

    public CB_MaterialSearchReceiver searchReceiver
    {
        get;
        set
        {
            this.searchReceiver = value;
            this.isSearchReceiverSet = true;
            loadIfReady();
        }
    }

    public boolean isMultiSelectEnabled
    {
        get;
        set
        {
            this.isMultiSelectEnabled = value;
            this.isMultiSelectEnabledSet = true;
            loadIfReady();
        }
    }

    public boolean isScheduleDateEnabled
    {
        get;
        set
        {
            this.isScheduleDateEnabled = value;
            this.isScheduleDateEnabledSet = true;
            loadIfReady();
        }
    }

    public boolean isAutoSearchEnabled
    {
        get;
        set
        {
            this.isAutoSearchEnabled = value;
            this.isAutoSearchEnabledSet = true;
            loadIfReady();
        }
    }

    public boolean isSearchOnClearEnabled
    {
        get;
        set
        {
            this.isSearchOnClearEnabled = value;
            this.isSearchOnClearEnabledSet = true;
            loadIfReady();
        }
    }

    public boolean isQuantityEnabled
    {
        get;
        set
        {
            this.isQuantityEnabled = value;
            this.isQuantityEnabledSet = true;
            loadIfReady();
        }
    }

    public string salesOrg
    {
        get;
        set
        {
            this.salesOrg = value;
            this.isSalesOrgSet = true;
            loadIfReady();
        }
    }

    public string distChannel
    {
        get;
        set
        {
            this.distChannel = value;
            this.isDistChannelSet = true;
            loadIfReady();
        }
    }

    public string defaultMaterialNumber
    {
        get;
        set
        {
            this.defaultMaterialNumber = value;
            this.isDefaultMaterialSet = true;
            loadIfReady();
        }
    }

    public string defaultHierarchy
    {
        get;
        set
        {
            this.defaultHierarchy = value;
            this.isDefaultHierarchySet = true;
            loadIfReady();
        }
    }

    public string defaultDescription
    {
        get;
        set
        {
            this.defaultDescription = value;
            this.isDefaultDescriptionSet = true;
            loadIfReady();
        }
    }

    public List<string> defaultTypes
    {
        get;
        set
        {
            this.defaultTypes = value;
            this.isDefaultTypesSet = true;
            loadIfReady();
        }
    }

    public List<string> defaultAttributes
    {
        get;
        set
        {
            this.defaultAttributes = value;
            this.isDefaultAttributesSet = true;
            loadIfReady();
        }
    }

    public List<string> materialTypes
    {
        get;
        set
        {
            // If you don't do this, then Salesforce will get angry when you
            // check the checkboxes
            this.materialTypes = value;
            if (null == value)
            {
                this.materialTypes = new List<string>();
            }
        }
    }

    public List<string> productAttributes
    {
        get;
        set
        {
            // If you don't do this, then Salesforce will get angry when you
            // check the checkboxes
            this.productAttributes = value;
            if (null == value)
            {
                this.productAttributes = new List<string>();
            }
        }
    }

    public string listHeight
    {
        get;
        set
        {
            this.listHeight = value;
            this.isListHeightSet = true;
            loadIfReady();
        }
    }

    private void loadIfReady()
    {
        if (!this.isOnLoadComplete &&
                this.isComponentIdSet &&
                this.isSearchReceiverSet &&
                this.isMultiSelectEnabledSet &&
                this.isScheduleDateEnabledSet &&
                this.isAutoSearchEnabledSet &&
                this.isSearchOnClearEnabledSet &&
                this.isQuantityEnabledSet &&
                this.isSalesOrgSet &&
                this.isDistChannelSet &&
                this.isDefaultMaterialSet &&
                this.isDefaultHierarchySet &&
                this.isDefaultDescriptionSet &&
                this.isDefaultTypesSet &&
                this.isDefaultAttributesSet &&
            this.isListHeightSet )
        {
            loadDefaults();
        }
    }

    public void loadDefaults()
    {
        System.debug('loadDefaults: ' + this.componentId);
        this.material = this.defaultMaterialNumber;
        this.productHierarchy = this.defaultHierarchy;
        this.searchDescription = this.defaultDescription;
        this.materialTypes = this.defaultTypes;
        this.productAttributes = this.defaultAttributes;

        // If we have never auto-searched, do it
        if (!this.isOnLoadComplete && this.isAutoSearchEnabled)
            actionSearch();
        // If we have auto-searched, but isSearchOnClearEnabled, do it anyway
        else if (this.isOnLoadComplete && this.isAutoSearchEnabled && this.isSearchOnClearEnabled)
            actionSearch();

        this.isOnLoadComplete = true;
    }

    public void actionSearch()
    {
        String description = this.searchDescription;
        if (null == description) description = '';
        if (!description.startsWith('*')) description = '*' + description;
        if (!description.endsWith('*')) description += '*';
        System.debug('searching for: ' + this.productHierarchy + ' - ' + description);

        SBO_EnosixMaterial_Search sbo = new SBO_EnosixMaterial_Search();
        sbo.SearchContext.SEARCHPARAMS.MaterialDescription = description;

        if (String.isNotBlank(this.material)) {
            sbo.SearchContext.SEARCHPARAMS.MaterialNumberFrom = this.material;
        }
        if (String.isNotBlank(this.productHierarchy)) {
            sbo.SearchContext.SEARCHPARAMS.ProductHierarchy = this.productHierarchy;
        }
        if (String.isNotBlank(this.salesOrg)) {
            sbo.SearchContext.SEARCHPARAMS.SalesOrganization = this.salesOrg;
        }
        if (String.isNotBlank(this.distChannel)) {
            sbo.SearchContext.SEARCHPARAMS.DistributionChannel = this.distChannel;
        }

        if (null != materialTypes) {
            for (String s : materialTypes) {
                SBO_EnosixMaterial_Search.MATERIAL_TYPE t =
                        new SBO_EnosixMaterial_Search.MATERIAL_TYPE();
                t.MaterialType = s;
                sbo.SearchContext.MATERIAL_TYPE.add(t);
            }
        }

        if (null != productAttributes) {
            for (string s : productAttributes) {
                SBO_EnosixMaterial_Search.PRODUCT_ATTRIB a =
                        new SBO_EnosixMaterial_Search.PRODUCT_ATTRIB();
                a.ProductAttribute = s;
                sbo.SearchContext.PRODUCT_ATTRIB.add(a);
            }
        }

        SBO_EnosixMaterial_Search.EnosixMaterial_SR result = sbo.execute();
        if (!result.isSuccess())
        {
            searchResults = null;
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
            System.debug('Search failed');
        }
        else
        {
            searchResults = new List<MaterialSearchResult>();
            for (SBO_EnosixMaterial_Search.SEARCHRESULT sr : result.getResults())
            {
                searchResults.add(materialSearchResultFromSR(
                    sr, this.isQuantityEnabled, this.isScheduleDateEnabled));
            }

            System.debug('Search success - materials found: ' + searchResults.size());
        }
    }

    public void actionSendResultsToReceiver()
    {
        List<MaterialSearchResult> result = new List<MaterialSearchResult>();
        for (MaterialSearchResult m : searchResults)
        {
            if (m.isSelected)
            {
                if (this.isQuantityEnabled && m.quantity != Math.floor(m.quantity))
                {
                    ApexPages.addMessage(
                            new Apexpages.Message(
                                    ApexPages.Severity.ERROR,
                                    'Quantity ' + m.quantity.format() + ' must be a whole number'
                            ));
                    return;
                }

                result.add(m);
            }
        }
        searchReceiver.onReceiveMaterialSearchResults(componentId, result);
        clearSearch();
    }

    public void actionSendSingleResultToReceiver()
    {
        String selectedMaterial = System.currentPageReference().getParameters().get('selectedMaterial');

        for (MaterialSearchResult m : searchResults)
        {
            if (m.material.Material == selectedMaterial)
            {
                if (this.isQuantityEnabled && m.quantity != Math.floor(m.quantity))
                {
                    ApexPages.addMessage(
                        new Apexpages.Message(
                            ApexPages.Severity.ERROR,
                            'Quantity ' + m.quantity.format() + ' must be a whole number'
                        ));
                    return;
                }

                List<MaterialSearchResult> result = new List<MaterialSearchResult>();
                result.add(m);
                searchReceiver.onReceiveMaterialSearchResults(componentId, result);
                clearSearch();
                return;
            }
        }
    }

    public string tableWrapperStyle
    {
        get
        {
            if (this.isListHeightSet && string.isNotBlank(this.listHeight))
            {
                return 'overflow: scroll; max-height: ' + this.listHeight + ';';
            }
            return '';
        }
    }

    @testVisible
    private void clearSearch()
    {
        searchResults = null;
        loadDefaults();
    }

    // init product hierarchy and other search option values
    RFC_MM_GET_PROD_HIERARCHY.RESULT getSearchOptions()
    {
        RFC_MM_GET_PROD_HIERARCHY rfc = new RFC_MM_GET_PROD_HIERARCHY();
        // Only get 3 levels of product hierarchy
        rfc.Params.IV_LEVEL_NUMBER = '3';
        RFC_MM_GET_PROD_HIERARCHY.RESULT result = rfc.execute();
        System.debug('RFC Results:');
        System.debug(result);

        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }

        return result;
    }

    // product hierarchy dropdown
    RFC_MM_GET_PROD_HIERARCHY.RESULT rfcSearchOptions;
    public List<SelectOption> productHierarchiesList
    {
        get
        {
            ProductHierarchyOptionBuilder optionBulder = new ProductHierarchyOptionBuilder();
            return UTIL_SelectOption.buildOptionsFromList(
                    optionBulder, this.rfcSearchOptions.ET_PROD_HIERARCHY_List);
        }
    }

    // material type checkboxes
    public List<SelectOption> materialTypesList
    {
        get
        {
            MaterialTypeOptionBuilder optionBulder = new MaterialTypeOptionBuilder();
            return UTIL_SelectOption.buildOptionsFromList(
                    optionBulder, this.rfcSearchOptions.ET_MATERIAL_TYPE_List);
        }
    }

    // product attribute checkboxes
    public List<SelectOption> productAttributesList
    {
        get
        {
            ProductAttributeOptionBuilder optionBulder = new ProductAttributeOptionBuilder();
            return UTIL_SelectOption.buildOptionsFromList(
                    optionBulder, this.rfcSearchOptions.ET_PRODUCT_ATTRIB_List);
        }
    }

    // This helps build select options for product hierarchy dropdown
    class ProductHierarchyOptionBuilder extends UTIL_SelectOption.OptionBuilder
    {
        public override string getItemValue(object item)
        {
            return ((RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY) item).PRODH;
        }

        // item label indented by STUFE spaces
        public override string getItemDescription(object item)
        {
            string result = '';
            integer spaces = integer.valueOf(((RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY) item).STUFE) - 1;
            for (integer i = 0; i < spaces; i++) {
                result += '- ';
            }
            result += ((RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY) item).VTEXT;
            return result;
        }

        // don't allow base classes to display KEY - Desc. We need only Des. for the formatting
        // to appear correct
        public override string getItemLabel(object item)
        {
            return getItemDescription(item);
        }
    }

    // This helps build select options for the material type checkboxes
    class MaterialTypeOptionBuilder extends UTIL_SelectOption.OptionBuilder
    {
        public override string getItemValue(object item)
        {
            return ((RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE) item).MTART;
        }

        public override string getItemDescription(object item)
        {
            return ((RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE) item).MTBEZ;
        }

        // We don't want KEY - Desc on this one either
        public override string getItemLabel(object item)
        {
            return getItemDescription(item);
        }
    }

    // This helps build select options for the attribute checkboxes
    // Since there is no description field in the SBO, all methods return the
    // same thing
    class ProductAttributeOptionBuilder extends UTIL_SelectOption.OptionBuilder
    {
        private ProductAttributeTranslator translator
        {
            get
            {
                return (ProductAttributeTranslator)UTIL_AppSettings.getInstance(
                    'MaterialSearch.ProductAttributeTranslator', ProductAttributeTranslator.class);
            }
        }

        public override String getItemValue(object item)
        {
            return ((RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB) item).PRODUCT_ATTRIB;
        }

        public override String getItemDescription(object item)
        {
            return translator.translate(getItemValue(item));
        }

        public override String getItemLabel(object item)
        {
            return translator.translate(getItemValue(item));
        }
    }

    // Overridable translator class. The default implementation does nothing.
    // Use UTIL_AppSettings.getInstance() to replace this with a version that
    // actually does do some translations.
    public virtual class ProductAttributeTranslator
    {
        // base implementation just returns the argument
        public virtual String translate(String sapAttribute)
        {
            return sapAttribute;
        }
    }

    // This "subclass" adds fields to the search result object which are needed
    // to facilate selecting list items and adjusting their quantities
    public class MaterialSearchResult
    {
        public SBO_EnosixMaterial_Search.SEARCHRESULT material { get; set; }
        public decimal quantity { get; set; }
        public string scheduleDate { get; set; }
        public boolean isSelected { get; set; }
    }

    public static MaterialSearchResult materialSearchResultFromSR(
        SBO_EnosixMaterial_Search.SEARCHRESULT sr,
        Boolean isQuantityEnabled,
        Boolean isScheduleDateEnabled)
    {
        MaterialSearchResult m = new MaterialSearchResult();
        m.material = sr;
        m.scheduleDate = '';
        m.isSelected = false;
        if (isQuantityEnabled)
        {
            m.quantity = 1;
        }

        return m;
    }
}
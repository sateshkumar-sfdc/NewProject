public with sharing class CTRL_InventoryList extends CTRL_BasePager implements  CB_MaterialSearchReceiver{
    public SBO_EnosixWarehouseStock_Search ews { get; set; }

    public List<SBO_EnosixWarehouseStock_Search.SEARCHRESULT> fullews { get; private set; }  // non-paginated
    public List<SBO_EnosixWarehouseStock_Search.SEARCHRESULT> ewsList { get; private set; }  // paginated
    private RFC_MM_GET_PLANT_VALUES_S4.RESULT plantValues { get; set; }
    // picklists
    public List<SelectOption> plants {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('All', 'All'));
            if (plantValues != null) {
                for (RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT ev : plantValues.ET_OUTPUT_List) {
                    if (ev.WERKS != null && ev.WERKS_NAME != null)
                        options.add(new SelectOption(ev.WERKS, ev.WERKS_NAME));
                }
            }
            UTIL_ViewHelper.sortOptionsByLabel(options);
            return options;
        }
    }
    public string PlantName { get; set; }
    public Opportunity Opportunity { get; set; }
    public string OpportunityProductId { get; set; }
    public string MaterialSearchQuery { get; set; }
    public string MaterialSearchParam { get; set; }
    public CTRL_InventoryList() {
        ews = new SBO_EnosixWarehouseStock_Search();
        fullews = new List<SBO_EnosixWarehouseStock_Search.SEARCHRESULT>();
        ewsList = new List<SBO_EnosixWarehouseStock_Search.SEARCHRESULT>();
        if (!System.Test.isRunningTest()) {
            this.initFromParameters();
        }
    }
    public void initFromParameters() {
        PlantName = 'All';
        if (null != UTIL_PageState.current.opportunityId)
            Opportunity = UTIL_Object_Lookups.getOpportunityById(UTIL_PageState.current.opportunityId);
        OpportunityProductId = UTIL_PageState.current.opportunityProductId;
        MaterialSearchQuery = MaterialSearchParam = UTIL_PageState.current.materialId;

        if (null != MaterialSearchQuery)
            searchEWS();

        RFC_MM_GET_PLANT_VALUES_S4 pl = new RFC_MM_GET_PLANT_VALUES_S4();
        this.plantValues = pl.execute();

    }

    public PageReference backOpportunity() {
        if (null !=  Opportunity)
            return UTIL_PageFlow.redirectTo('/' + Opportunity.Id, null);
        //return to Opportunities landing if there isnt an id available
        return UTIL_PageFlow.redirectTo('/006', null);
    }

    public PageReference backMaterial() {
        if (this.OpportunityProductId != null) {
            return UTIL_PageFlow.redirectTo('/' + this.OpportunityProductId, null);
        }
        return null;

    }

    public PageReference goToStockListPage() {
        UTIL_PageState.current.materialId =
            System.currentPageReference().getParameters().get('material');
        UTIL_PageState.current.plantId =
            System.currentPageReference().getParameters().get('plant');

        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_StockList, UTIL_PageState.current);
    }

    public List<String> defaultInventoryMaterialTypes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'Inventory.DefaultMaterialTypes', String.class, new List<String>{ 'FERT' });
        }
    }

    public List<String> defaultInventoryProductAttributes
    {
        get
        {
            return (List<String>)UTIL_AppSettings.getList(
                'Inventory.DefaultMaterialProductAttributes', String.class, new List<String>{ });
        }
    }

    public Boolean isInventoryMaterialAutoSearchEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Inventory.IsMaterialAutoSearchEnabled', true);
        }
    }

    public CB_MaterialSearchReceiver msReceiver { get { return this; } }

    public void onReceiveMaterialSearchResults(string id, List<CTRL_MaterialSearch.MaterialSearchResult> results) {
        CTRL_MaterialSearch.MaterialSearchResult result = results.get(0);
        this.MaterialSearchQuery = result.material.Material;
        this.searchEWS();
    }

    public string sendSalesOrganizationToMaterialSearch(string id) {

        return  '';
    }

    public string sendDistributionChannelToMaterialSearch(string id) {
        return '';
    }

    public override void updatePaginatedResult() {

        if (fullews.size() > numperpage) {
            ewsList = new List<SBO_EnosixWarehouseStock_Search.SEARCHRESULT>();
            for (Integer i = startofpage; i < (numperpage + startofpage); i++) {
                if (i >= fullews.size()) break;
                ewsList.add(fullews.get(i));
            }
        } else ewsList = fullews;

    }

    public void searchEWS() {
        if (ews == null)
            ews = new SBO_EnosixWarehouseStock_Search();

        SBO_EnosixWarehouseStock_Search.MATERIALSEARCH ms = new SBO_EnosixWarehouseStock_Search.MATERIALSEARCH();
        ms.Sign = 'I';
        ms.Option = 'EQ';
        if (MaterialSearchQuery != null || String.isNotEmpty(MaterialSearchQuery)) {
            ms.Low = MaterialSearchQuery;
        }

        ews.SearchContext.MATERIALSEARCH.add(ms);

        if (PlantName != null && PlantName != 'All') {
            SBO_EnosixWarehouseStock_Search.PLANTSEARCH ps = new SBO_EnosixWarehouseStock_Search.PLANTSEARCH();

            ps.Sign = 'I';
            ps.Option = 'EQ';
            ps.Low = PlantName;

            ews.SearchContext.PLANTSEARCH.add(ps);
        }

        runSearch();
        doPagination();
    }

    public override void runSearch() {

        if (Test.isRunningTest()) ensx.EnosixFramework.setMock(ensx.EnosixFramework.SearchSBO.class, new MOC_EnosixWarehouseStock_Search.MockEnosixWarehouseStockSuccess());
        SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SR searchResult = ews.execute();

        if (searchResult.isSuccess()) {
            fullews = searchResult.getResults();
        } else {
            fullews = new List<SBO_EnosixWarehouseStock_Search.SEARCHRESULT>();
        }

        if (fullews.size() > 0) {
            // determine total number of pages
            setTotalPages(fullews.size());
        } else {
            setTotalPages(0);
            ewsList = new List<SBO_EnosixWarehouseStock_Search.SEARCHRESULT>();
            ensx.EnosixFramework.displayResultMessages(searchResult, ensx.EnosixFramework.MessageType.INFO);
        }
    }

}
public with sharing class CTRL_StockList extends CTRL_BasePager {

    public SBO_EnosixStockList_Search dl { get; set; }
    public List<SBO_EnosixStockList_Search.SEARCHRESULT> fulldls { get; private set; }  // non-paginated
    public List<SBO_EnosixStockList_Search.SEARCHRESULT> dls { get; private set; }  // paginated

    // picklists
    public List<SelectOption> plants {
        get {
            List<SelectOption> plntLSelectOptions = new List<SelectOption>();
            plntLSelectOptions.add(new SelectOption('*', 'All'));
            RFC_MM_GET_PLANT_VALUES_S4 pl = new RFC_MM_GET_PLANT_VALUES_S4();
            RFC_MM_GET_PLANT_VALUES_S4.RESULT pl_result = pl.execute();
            for (RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT ev : pl_result.ET_OUTPUT_List) {
                if (ev.WERKS != null && ev.WERKS_NAME != null)
                    plntLSelectOptions.add(new SelectOption(ev.WERKS, ev.WERKS_NAME));
            }
            return plntLSelectOptions;

        }
    }
    public string PlantName { get; set; }
    public string OpportunityId { get; set; }
    public string Material { get; set; }

    public CTRL_StockList() {
        fulldls = new  List<SBO_EnosixStockList_Search.SEARCHRESULT>();
        dls = new List<SBO_EnosixStockList_Search.SEARCHRESULT>();
        if (!test.isRunningTest()) {
            initFromParameters();
        }
    }
    public void initFromParameters() {
        Material = UTIL_PageState.current.materialId;
        OpportunityId = UTIL_PageState.current.opportunityId;
        PlantName = UTIL_PageState.current.plantId;

        if (null == PlantName)
            PlantName = '*';

        searchSL();

    }

    public PageReference backInventory() {
        return UTIL_PageFlow.redirectTo(UTIL_PageFlow.VFP_InventoryList, UTIL_PageState.current);
    }

    public void searchSL() {
        dl = new SBO_EnosixStockList_Search();

        dl.SearchContext.SEARCHPARAMS.Material = Material;
        dl.SearchContext.SEARCHPARAMS.Plant = PlantName;    //PlantId;

        runSearch();
        doPagination();
    }

    /**
     * set the result objects for the list view
     * @return [description]
     */
    public override void updatePaginatedResult() {

        if (fulldls.size() > numperpage) {
            dls = new List<SBO_EnosixStockList_Search.SEARCHRESULT>();
            for (Integer i = startofpage; i < (numperpage + startofpage); i++) {
                if (i >= fulldls.size()) break;
                dls.add(fulldls.get(i));
            }
        } else dls = fulldls;

    }

    /**
     * handles the searching of dl and display data in the grid
     * @return [description]
     */
    public override void runSearch() {


        if (Test.isRunningTest()) ensx.EnosixFramework.setMock(ensx.EnosixFramework.SearchSBO.class, new MOC_EnosixStockList_Search.MockEnosixStockListSuccess());
        SBO_EnosixStockList_Search.EnosixStockList_SR searchResult = dl.execute();
        system.debug('searchResult: ' + searchResult);

        if (searchResult.isSuccess()) {
            fulldls = searchResult.getResults();
        } else {
            fulldls = new List<SBO_EnosixStockList_Search.SEARCHRESULT>();
        }

        if (fulldls.size() > 0) {
            // determine total number of pages
            setTotalPages(fulldls.size());

        } else {
            setTotalPages(0);
            dls = new List<SBO_EnosixStockList_Search.SEARCHRESULT>();
            ensx.EnosixFramework.displayResultMessages(searchResult, ensx.EnosixFramework.MessageType.INFO);
        }

    }


}
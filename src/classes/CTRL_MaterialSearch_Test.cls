public with sharing class CTRL_MaterialSearch_Test implements CB_MaterialSearchReceiver {
    public List<CTRL_MaterialSearch.MaterialSearchResult> searchResults { get; set; }
    public CB_MaterialSearchReceiver receiver { get; set; }
    public List<string> defaultMaterialTypes { get; set; }
    public List<string> defaultProductAttributes { get; set; }

    public CTRL_MaterialSearch_Test() {
        defaultMaterialTypes = (List<String>)UTIL_AppSettings.getList(
                'Order.DefaultMaterialTypes', String.class, new List<String>{ 'FERT' });
        defaultProductAttributes = new List<string> { 'Product attribute 2' };
        receiver = this;
    }

    public void onReceiveMaterialSearchResults(string id, List<CTRL_MaterialSearch.MaterialSearchResult> results) {
        this.searchResults = results;
        System.debug('receiving Material Search Results ');
    }
}
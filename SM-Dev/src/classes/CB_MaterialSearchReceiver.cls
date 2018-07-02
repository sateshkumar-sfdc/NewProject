public interface CB_MaterialSearchReceiver {
    // By passing the id of the component to the caller, it can implement different handlers if
    // there is more than one copy of the component on the page
    void onReceiveMaterialSearchResults(string id, List<CTRL_MaterialSearch.MaterialSearchResult> results);
}
@isTest
public with sharing class TSTC_MaterialSearch_Test {
    @isTest static void test_ctor() {
        Test.startTest();
        CTRL_MaterialSearch_Test controller = new CTRL_MaterialSearch_Test();
        Test.stopTest();
        System.assert(controller.receiver == controller);
    }

    @isTest static void test_onReceiveMaterialSearchResults() {
        CTRL_MaterialSearch_Test controller = new CTRL_MaterialSearch_Test();
        List<CTRL_MaterialSearch.MaterialSearchResult> testResults = new List<CTRL_MaterialSearch.MaterialSearchResult>();
        CTRL_MaterialSearch.MaterialSearchResult m = new CTRL_MaterialSearch.MaterialSearchResult();
        m.quantity = 1.0;
        m.isSelected = true;
        testResults.add(m);

        Test.startTest();
        controller.onReceiveMaterialSearchResults(null, testResults);
        Test.stopTest();

        System.assert(controller.searchResults.size() == 1);
        System.assert(controller.searchResults.get(0) == m);
    }
}
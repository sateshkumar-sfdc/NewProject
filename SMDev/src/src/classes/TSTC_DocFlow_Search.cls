@isTest
public with sharing class TSTC_DocFlow_Search {
    class MockSearch implements ensx.EnosixFramework.SearchSBOMock {
        Boolean isSuccess;
        public MockSearch(Boolean isSuccess) {
            this.isSuccess = isSuccess;
        }

        public ensx.EnosixFramework.SearchResult executeSearch()
        {
            SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SR searchResult =
                new SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SR();

            if (isSuccess) {
                SBO_EnosixSalesDocFlow_Search.SEARCHRESULT result = new SBO_EnosixSalesDocFlow_Search.SEARCHRESULT();
                result.SalesDocument = 'MOCK';
                searchResult.SearchResults.add(result);
            }

            searchResult.setSuccess(isSuccess);
            return searchResult;
        }
    }

    @isTest
    static void test_CreateController() {
        MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess mockRfc = new MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess();
        ENSX.EnosixFramework.setMock(SBO_EnosixSalesDocFlow_Search.class, new MockSearch(true));
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_CATEG_VALUES.class, mockRfc);

        Test.setCurrentPageReference(new PageReference('Page.VFP_DocFlow_Search'));

        Test.startTest();

        // no query
        CTRL_DocFlow_Search controller1 = new CTRL_DocFlow_Search();

        // reset page state
        UTIL_PageState.current = null;

        // with query
        System.currentPageReference().getParameters().put('SAP_DocNum', '1');
        CTRL_DocFlow_Search controller2 = new CTRL_DocFlow_Search();

        Test.stopTest();

        System.assert(controller1 != null);
        System.assert(controller1.salesDocNum == null);

        System.assert(controller2 != null);
        System.assert(controller2.salesDocNum == '1');
    }

    @isTest
    static void test_SearchParamProperties() {
        MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess mockRfc = new MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess();
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_CATEG_VALUES.class, mockRfc);
        Test.startTest();
        CTRL_DocFlow_Search controller = new CTRL_DocFlow_Search();
        controller.salesDocNum = '1';
        controller.customerPoNum = '1';
        controller.docCategory = 'C';
        Test.stopTest();
    }

    @isTest
    static void test_DocCategoryOptions() {
        MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess mockRfc = new MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess();
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_CATEG_VALUES.class, mockRfc);

        Test.startTest();

        CTRL_DocFlow_Search controller = new CTRL_DocFlow_Search();
        List<SelectOption> options = controller.docCategoryOptions;

        Test.stopTest();

        //System.assert(1 == options.size());
    }

    @isTest
    static void test_SearchSuccess() {
        MockSearch mockSearch = new MockSearch(true);
        MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess mockRfc = new MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess();
        ENSX.EnosixFramework.setMock(SBO_EnosixSalesDocFlow_Search.class, mockSearch);
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_CATEG_VALUES.class, mockRfc);

        Test.startTest();

        CTRL_DocFlow_Search controller = new CTRL_DocFlow_Search();
        controller.search();
        Test.stopTest();

        System.assert(1 == controller.searchResults.size());
        System.assert('MOCK' == controller.searchResults[0].SalesDocument);
    }

    @isTest
    static void test_SearchFailure() {
        MockSearch mockSearch = new MockSearch(false);
        MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess mockRfc = new MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess();
        ENSX.EnosixFramework.setMock(SBO_EnosixSalesDocFlow_Search.class, mockSearch);
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_CATEG_VALUES.class, mockRfc);

        Test.startTest();

        CTRL_DocFlow_Search controller = new CTRL_DocFlow_Search();
        controller.search();
        Test.stopTest();

        System.assert(0 == controller.searchResults.size());
    }

    @isTest
    static void test_gotoDetailPage() {
        MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess mockRfc = new MOC_SD_GET_DOC_CATEG_VALUES.MockSuccess();
        ENSX.EnosixFramework.setMock(RFC_SD_GET_DOC_CATEG_VALUES.class, mockRfc);
        Test.setCurrentPageReference(new PageReference('Pag.VFP_DocFlow_Search'));

        Test.startTest();

        CTRL_DocFlow_Search controller = new CTRL_DocFlow_Search();

        System.currentPageReference().getParameters().put('selectedDocCategory', 'C');
        System.currentPageReference().getParameters().put('selectedDocNum', '1');
        PageReference result1 = controller.gotoDetailPage();

        // reset page state
        UTIL_PageState.current = null;

        System.currentPageReference().getParameters().put('selectedDocCategory', 'H');
        System.currentPageReference().getParameters().put('selectedDocNum', '2');
        PageReference result2 = controller.gotoDetailPage();

        UTIL_PageState.current = null;

        System.currentPageReference().getParameters().put('selectedDocCategory', 'M');
        System.currentPageReference().getParameters().put('selectedDocNum', '3');
        PageReference result3 = controller.gotoDetailPage();

        UTIL_PageState.current = null;

        System.currentPageReference().getParameters().put('selectedDocCategory', 'J');
        System.currentPageReference().getParameters().put('selectedDocNum', '4');
        PageReference result4 = controller.gotoDetailPage();

        UTIL_PageState.current = null;

        System.currentPageReference().getParameters().put('selectedDocCategory', 'X');
        System.currentPageReference().getParameters().put('selectedDocNum', '5');
        PageReference result5 = controller.gotoDetailPage();

        Test.stopTest();

        System.assert(result1.getUrl() == '/apex/VFP_OrderDetail?ordernumber=1');
        System.assert(result2.getUrl() == '/apex/VFP_Return_Order_Detail?SAP_RMAId=2');
        System.assert(result3.getUrl() == '/apex/VFP_Invoice_Detail?InvoiceNumber=3');
        System.assert(result4.getUrl() == '/apex/VFP_DeliveryDetail?dlnumber=4');
        System.assert(result5 == null);
    }
}
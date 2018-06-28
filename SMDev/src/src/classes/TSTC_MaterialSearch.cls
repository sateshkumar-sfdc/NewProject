@isTest
public with sharing class TSTC_MaterialSearch {
    @isTest static void test_properties() {
        // add coverage, not really testing anything
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);

        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();
        Test.startTest();
        controller.componentId = '1';
        controller.defaultMaterialNumber = '1';
        controller.material = '1';
        controller.defaultHierarchy = '1';
        controller.productHierarchy = '1';
        controller.defaultDescription = 'desc';
        controller.searchDescription = 'desc';
        controller.defaultTypes = new List<string> { '1', '2' };
        controller.materialTypes = new List<string> { '1', '2' };
        controller.defaultAttributes = new List<string> { '1', '2' };
        controller.productAttributes = new List<string> { '1', '2' };
        controller.salesOrg = 'SALES';
        controller.distChannel = 'DIST';
        controller.isMultiSelectEnabled = true;
        controller.isScheduleDateEnabled = true;
        controller.isAutoSearchEnabled = true;
        controller.isSearchOnClearEnabled = true;
        controller.isQuantityEnabled = true;
        Test.stopTest();
    }

    @isTest static void test_loadDefaults() {
        // Verify auto search
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        MockSearch mockSBO = new MockSearch();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);
        ENSX.EnosixFramework.setMock(SBO_EnosixMaterial_Search.class, mockSBO);

        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();

        MockReceiver receiver = new MockReceiver();
        controller.searchReceiver = receiver;


        Test.startTest();

        controller.defaultMaterialNumber = 'material';
        controller.defaultHierarchy = 'hierarchy';
        controller.defaultDescription = 'description';
        controller.defaultTypes = new List<string> { '1', '2' };
        controller.defaultAttributes = new List<string> { '3', '4' };
        controller.isScheduleDateEnabled = false;
        controller.isAutoSearchEnabled = false;
        controller.isSearchOnClearEnabled = false;
        controller.isQuantityEnabled = true;
        controller.loadDefaults();
        System.assert(null == controller.searchResults);
        System.assert('material' == controller.material);
        System.assert('hierarchy' == controller.productHierarchy);
        System.assert('description' == controller.searchDescription);

        controller.isAutoSearchEnabled = true;
        controller.isSearchOnClearEnabled = true;
        controller.loadDefaults();
        System.assert(controller.searchResults.size() == 1);
        System.assert(controller.searchResults.get(0).material.Material == 'MOCK');

        Test.stopTest();
    }

    @isTest static void test_loadIfReady() {
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);

        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();

        MockReceiver receiver = new MockReceiver();

        Test.startTest();

        // loadDefaults() should be called only after all attr properties are set
        controller.componentId = '1';
        controller.searchReceiver = receiver;
        controller.isMultiSelectEnabled = true;
        controller.isScheduleDateEnabled = true;
        controller.isAutoSearchEnabled = false;
        controller.isSearchOnClearEnabled = false;
        controller.isQuantityEnabled = false;
        controller.salesOrg = 'org';
        controller.distChannel = 'dist';
        controller.defaultMaterialNumber = 'material';
        controller.defaultHierarchy = 'hierarchy';
        controller.defaultDescription = 'desc';
        controller.defaultTypes = new List<string> { '1', '2' };
        controller.listHeight = '';

        System.assert(!controller.isOnLoadComplete);
        System.assert(null == controller.productHierarchy);

        // This should trigger loadIfReady() to call loadDefaults()
        controller.defaultAttributes = new List<string> { '1', '2' };

        System.assert(controller.isOnLoadComplete);
        System.assert(controller.defaultHierarchy == controller.productHierarchy);

        Test.stopTest();
    }

    @isTest static void test_actionSearch() {
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);

        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();
        controller.isScheduleDateEnabled = false;
        controller.isQuantityEnabled = false;

        MockReceiver receiver = new MockReceiver();
        controller.searchReceiver = receiver;

        MockSearch mockSBO = new MockSearch();
        ENSX.EnosixFramework.setMock(SBO_EnosixMaterial_Search.class, mockSBO);

        Test.startTest();
        // Search without hierarchy first
        controller.searchDescription = 'desc';
        controller.actionSearch();

        System.assert(controller.searchResults.size() == 1);
        System.assert(controller.searchResults.get(0).material.Material == 'MOCK');

        // Search again with hierarchy just to add coverage
        controller.productHierarchy = '1';
        controller.actionSearch();
        System.assert(controller.searchResults.size() == 1);
        System.assert(controller.searchResults.get(0).material.Material == 'MOCK');
        Test.stopTest();
    }

    @isTest static void test_actionSendResultsToReceiver() {
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);
        MockSearch mockSBO = new MockSearch();
        ENSX.EnosixFramework.setMock(ENSX.EnosixFramework.SBO_EnosixMaterial_Search.class, mockSBO);

        PageReference pageReference = new PageReference('Page.VFP_MaterialSearch_Test');
        pageReference.getParameters().put('selectedMaterial', 'MOCK');
        Test.setCurrentPageReference(pageReference);

        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();
        controller.searchResults = new List<CTRL_MaterialSearch.MaterialSearchResult>();
        controller.isScheduleDateEnabled = true;
        controller.isMultiSelectEnabled = true;
        controller.isQuantityEnabled = true;
        controller.isAutoSearchEnabled = false;
        controller.isSearchOnClearEnabled = false;

        SBO_EnosixMaterial_Search.SEARCHRESULT material = new SBO_EnosixMaterial_Search.SEARCHRESULT();
        material.Material = 'MOCK';
        CTRL_MaterialSearch.MaterialSearchResult m1 = new CTRL_MaterialSearch.MaterialSearchResult();
        m1.material = material;
        m1.quantity = 1.0;
        m1.isSelected = false;
        controller.searchResults.add(m1);

        CTRL_MaterialSearch.MaterialSearchResult m2 = new CTRL_MaterialSearch.MaterialSearchResult();
        m2.material = material;
        m2.quantity = 2.0;
        m2.isSelected = true;
        controller.searchResults.add(m2);

        MockReceiver receiver = new MockReceiver();
        controller.searchReceiver = receiver;

        Test.startTest();
        controller.actionSendResultsToReceiver();
        Test.stopTest();
        System.debug(controller.searchResults);
        System.debug(receiver.searchResults);

        System.assert(receiver.searchResults.size() == 1);
        System.assert(receiver.searchResults.get(0).quantity == 2.0);
    }

    @isTest static void test_clearSearch() {
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);
        MockSearch mockSBO = new MockSearch();
        ENSX.EnosixFramework.setMock(ENSX.EnosixFramework.SBO_EnosixMaterial_Search.class, mockSBO);

        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();
        controller.searchResults = new List<CTRL_MaterialSearch.MaterialSearchResult>();
        controller.isAutoSearchEnabled = false;
        controller.isSearchOnClearEnabled = false;

        CTRL_MaterialSearch.MaterialSearchResult m1 = new CTRL_MaterialSearch.MaterialSearchResult();
        m1.quantity = 1.0;
        m1.isSelected = false;
        controller.searchResults.add(m1);

        controller.defaultMaterialNumber = 'blank';
        controller.defaultHierarchy = 'blank';
        controller.defaultDescription = 'blank';
        controller.defaultTypes = new List<string>();
        controller.defaultAttributes = new List<string>();
        controller.productHierarchy = 'not empty';
        controller.searchDescription = 'not empty';
        controller.materialTypes = new List<string> { '1', '2' };
        controller.productAttributes = new List<string> { '1', '2' };

        Test.startTest();
        controller.clearSearch();
        Test.stopTest();

        System.assert(controller.searchResults == null);
        System.assert(controller.material == controller.defaultMaterialNumber);
        System.assert(controller.productHierarchy == controller.defaultHierarchy);
        System.assert(controller.searchDescription == controller.defaultDescription);
        System.assert(controller.materialTypes.size() == 0);
        System.assert(controller.productAttributes.size() == 0);
    }

    @isTest static void test_productHierarchiesList() {
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);
        MockSearch mockSBO = new MockSearch();
        ENSX.EnosixFramework.setMock(ENSX.EnosixFramework.SBO_EnosixMaterial_Search.class, mockSBO);

        Test.startTest();
        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();
        List<SelectOption> options = controller.productHierarchiesList;
        Test.stopTest();

        System.assert(options.size() == 2);
        System.assert(options.get(0).getLabel() == 'Hierarchy 1');
        System.assert(options.get(1).getLabel() == '- Hierarchy 2');
    }

    @isTest static void test_materialTypesList() {
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);
        MockSearch mockSBO = new MockSearch();
        ENSX.EnosixFramework.setMock(ENSX.EnosixFramework.SBO_EnosixMaterial_Search.class, mockSBO);

        Test.startTest();
        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();
        List<SelectOption> options = controller.materialTypesList;
        Test.stopTest();

        System.assert(options.size() == 2);
        System.assert(options.get(0).getLabel() == 'Material Type 1');
        System.assert(options.get(1).getLabel() == 'Material Type 2');
    }

    @isTest static void test_productAttributesList() {
        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);
        MockSearch mockSBO = new MockSearch();
        ENSX.EnosixFramework.setMock(ENSX.EnosixFramework.SBO_EnosixMaterial_Search.class, mockSBO);

        Test.startTest();
        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();
        List<SelectOption> options = controller.productAttributesList;
        Test.stopTest();

        System.assert(options.size() == 2);
        System.assert(options.get(0).getLabel() == 'PA1');
        System.assert(options.get(1).getLabel() == 'PA2');
    }

    @isTest static void test_productAttributesListTranslation()
    {
        UTIL_AppSettings.resourceJson =
            '{"MaterialSearch.ProductAttributeTranslator": "TSTC_MaterialSearch.TestTranslator"}';

        MockProductHierarchyRfc mock = new MockProductHierarchyRfc();
        ENSX.EnosixFramework.setMock(RFC_MM_GET_PROD_HIERARCHY.class, mock);
        MockSearch mockSBO = new MockSearch();
        ENSX.EnosixFramework.setMock(ENSX.EnosixFramework.SBO_EnosixMaterial_Search.class, mockSBO);

        Test.startTest();
        CTRL_MaterialSearch controller = new CTRL_MaterialSearch();
        List<SelectOption> options = controller.productAttributesList;
        Test.stopTest();

        System.assert(options.size() == 2);
        System.assert(options.get(0).getLabel() == 'CHANGED');
        System.assert(options.get(1).getLabel() == 'CHANGED');
    }

    public class TestTranslator extends CTRL_MaterialSearch.ProductAttributeTranslator
    {
        public override String translate(String sapAttribute)
        {
            return 'CHANGED';
        }
    }

    public class MockSearch implements ensx.EnosixFramework.SearchSBOMock {
        public ensx.EnosixFramework.SearchResult executeSearch() {
            SBO_EnosixMaterial_Search.EnosixMaterial_SR searchResult = new SBO_EnosixMaterial_Search.EnosixMaterial_SR();

            SBO_EnosixMaterial_Search.SEARCHRESULT result = new SBO_EnosixMaterial_Search.SEARCHRESULT();
            result.Material = 'MOCK';
            searchResult.SearchResults.add(result);

            searchResult.setSuccess(true);
            return searchResult;
        }
    }

    public class MockProductHierarchyRfc implements ensx.EnosixFramework.RFCMock {
        public ensx.EnosixFramework.FunctionObject executeFunction() {
            RFC_MM_GET_PROD_HIERARCHY.RESULT funcObj =
                new RFC_MM_GET_PROD_HIERARCHY.RESULT();

            RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY ph1 =
                new RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY();
            ph1.PRODH = 'PH1';
            ph1.VTEXT = 'Hierarchy 1';
            ph1.STUFE = '1';

            RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY ph2 =
                new RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY();
            ph2.PRODH = 'PH2';
            ph2.VTEXT = 'Hierarchy 2';
            ph2.STUFE = '2';

            RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE mt1 =
                new RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE();
            mt1.MTART = 'ZMT1';
            mt1.MTBEZ = 'Material Type 1';

            RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE mt2 =
                new RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE();
            mt2.MTART = 'ZMT2';
            mt2.MTBEZ = 'Material Type 2';

            RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB pa1 =
                new RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB();
            pa1.PRODUCT_ATTRIB = 'PA1';

            RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB pa2 =
                new RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB();
            pa2.PRODUCT_ATTRIB = 'PA2';

            funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class).add(ph1);
            funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class).add(ph2);
            funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class).add(mt1);
            funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class).add(mt2);
            funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class).add(pa1);
            funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class).add(pa2);
            funcObj.setSuccess(true);

            return funcObj;
        }
    }

    public class MockReceiver implements CB_MaterialSearchReceiver {
        public List<CTRL_MaterialSearch.MaterialSearchResult> searchResults { get; set; }
        public void onReceiveMaterialSearchResults(string id, List<CTRL_MaterialSearch.MaterialSearchResult> results) {
            this.searchResults = results;
        }
    }
}
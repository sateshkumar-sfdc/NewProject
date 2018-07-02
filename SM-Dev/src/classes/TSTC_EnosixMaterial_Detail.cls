@isTest
private class TSTC_EnosixMaterial_Detail {

@isTest
	static void testControllerAndParams(){
		Test.startTest();
		CTRL_EnosixMaterial_Detail controller = new CTRL_EnosixMaterial_Detail();
		controller.materialDetail = new SBO_EnosixMaterial_Detail.EnosixMaterial();
		controller.materialNumber = 'TESTMATERIALNUMBER';
		controller.SF_ProductId = 'ProdID';
		System.assert(controller.ProductMaterialField != null);
		Test.stopTest();
	}
	@isTest
	static void testGetMaterialNumberFromPageParameters(){
		Test.startTest();
		Test.setCurrentPageReference(new PageReference('Page.VFP_OrderCreate'));
    	System.currentPageReference().getParameters().put('SF_ProductId', 'ProductId');
    	System.currentPageReference().getParameters().put('SF_MatId', 'MATERIALID');
		CTRL_EnosixMaterial_Detail controller = new CTRL_EnosixMaterial_Detail();
		string matId = controller.getMaterialNumberFromPageParameters();
		System.assert(matId != null);
		Test.stopTest();
	}
		@isTest
	static void testGetMaterialNumberFromPageParametersWithoutMaterialParameter(){
		Test.startTest();
		Product2 prod = new Product2();
		prod.Name= 'ProductName';
		prod.ProductCode = 'TESTPRODCODE';
		insert prod;
		Test.setCurrentPageReference(new PageReference('Page.VFP_OrderCreate'));
    	System.currentPageReference().getParameters().put('SF_ProductId', prod.Id);
		CTRL_EnosixMaterial_Detail controller = new CTRL_EnosixMaterial_Detail();
		string matId = controller.getMaterialNumberFromPageParameters();
		System.assert(matId != null);
		Test.stopTest();
	}
	@isTest
	static void testGetMaterialNumberFromProduct(){
		Test.startTest();
		Product2 prod = new Product2();
		prod.Name= 'ProductName';
		prod.ProductCode = 'TESTPRODCODE';
		insert prod;
		CTRL_EnosixMaterial_Detail controller = new CTRL_EnosixMaterial_Detail();
		string matId = controller.getMaterialNumberFromProduct(prod);
		System.assert(matId != null);
		Test.stopTest();
	}
	@isTest
	static void testGetMaterialNumberFromProductId(){
		Test.startTest();
		Product2 prod = new Product2();
		prod.ProductCode = 'TESTPRODCODE';
		prod.Name= 'ProductNameForTest';
		insert prod;
		CTRL_EnosixMaterial_Detail controller = new CTRL_EnosixMaterial_Detail();
		Product2 resProd = controller.getProductFromProductId(prod.Id);
		System.assert(resProd != null);
		Test.stopTest();
	}
}
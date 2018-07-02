/// enosiX Inc. Generated Apex Model
/// Generated On: 1/12/2017 2:37:35 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
private class TST_EnosixMaterial_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixMaterial_Search sbo = new SBO_EnosixMaterial_Search();
		
		System.assertEquals(SBO_EnosixMaterial_Search.class, sbo.getType(), 'getType() does not match object type.');

		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixMaterial_Search.SEARCHPARAMS childObj = new SBO_EnosixMaterial_Search.SEARCHPARAMS();
		System.assertEquals(SBO_EnosixMaterial_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

			childObj.MaterialNumberFrom = 'X';
		System.assertEquals('X', childObj.MaterialNumberFrom);

		childObj.MaterialNumberTo = 'X';
		System.assertEquals('X', childObj.MaterialNumberTo);

		childObj.MaterialDescription = 'X';
		System.assertEquals('X', childObj.MaterialDescription);

		childObj.SalesOrganization = 'X';
		System.assertEquals('X', childObj.SalesOrganization);

		childObj.DistributionChannel = 'X';
		System.assertEquals('X', childObj.DistributionChannel);

		childObj.MaterialGroup = 'X';
		System.assertEquals('X', childObj.MaterialGroup);

		childObj.ProductHierarchy = 'X';
		System.assertEquals('X', childObj.ProductHierarchy);

		childObj.CrossPlantMaterialStatus = 'X';
		System.assertEquals('X', childObj.CrossPlantMaterialStatus);

		childObj.FromCreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

		childObj.ToCreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

		childObj.FromChangeDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromChangeDate);

		childObj.ToChangeDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToChangeDate);

	}
	@isTest
	static void testMATERIAL_TYPE(){
	SBO_EnosixMaterial_Search.MATERIAL_TYPE childObj = new SBO_EnosixMaterial_Search.MATERIAL_TYPE();
		System.assertEquals(SBO_EnosixMaterial_Search.MATERIAL_TYPE.class, childObj.getType(),'getType() does not match object type.');

			childObj.MaterialType = 'X';
		System.assertEquals('X', childObj.MaterialType);

	}
	@isTest
	static void testPRODUCT_ATTRIB(){
	SBO_EnosixMaterial_Search.PRODUCT_ATTRIB childObj = new SBO_EnosixMaterial_Search.PRODUCT_ATTRIB();
		System.assertEquals(SBO_EnosixMaterial_Search.PRODUCT_ATTRIB.class, childObj.getType(),'getType() does not match object type.');

			childObj.ProductAttribute = 'X';
		System.assertEquals('X', childObj.ProductAttribute);

	}
@isTest
static void testEnosixMaterial_SR()
{
SBO_EnosixMaterial_Search.EnosixMaterial_SR sr = new SBO_EnosixMaterial_Search.EnosixMaterial_SR();

System.assertEquals(SBO_EnosixMaterial_Search.EnosixMaterial_SR.class, sr.getType(), 'getType() does not match object type.');

System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixMaterial_Search.SEARCHRESULT childObj = new SBO_EnosixMaterial_Search.SEARCHRESULT();
		System.assertEquals(SBO_EnosixMaterial_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

			childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.MaterialDescription = 'X';
		System.assertEquals('X', childObj.MaterialDescription);

		childObj.MaterialType = 'X';
		System.assertEquals('X', childObj.MaterialType);

		childObj.MaterialTypeDescription = 'X';
		System.assertEquals('X', childObj.MaterialTypeDescription);

		childObj.MaterialGroup = 'X';
		System.assertEquals('X', childObj.MaterialGroup);

		childObj.SalesOrganization = 'X';
		System.assertEquals('X', childObj.SalesOrganization);

		childObj.DistributionChannel = 'X';
		System.assertEquals('X', childObj.DistributionChannel);

		childObj.ProductHierarchy = 'X';
		System.assertEquals('X', childObj.ProductHierarchy);

		childObj.ProductHierarchyDescription = 'X';
		System.assertEquals('X', childObj.ProductHierarchyDescription);

		childObj.CrossPlantMaterialStatus = 'X';
		System.assertEquals('X', childObj.CrossPlantMaterialStatus);

		childObj.MaterialStatusDescription = 'X';
		System.assertEquals('X', childObj.MaterialStatusDescription);

		childObj.CreationDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreationDate);

		childObj.ChangeDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ChangeDate);

		childObj.AlternateUnitOfMeasure = 'X';
		System.assertEquals('X', childObj.AlternateUnitOfMeasure);

		childObj.NumeratorForConversion = 1.5;
		System.assertEquals(1.5, childObj.NumeratorForConversion);

		childObj.DenominatorForConversion = 1.5;
		System.assertEquals(1.5, childObj.DenominatorForConversion);

		childObj.Quotient = 1.5;
		System.assertEquals(1.5, childObj.Quotient);

	}

}
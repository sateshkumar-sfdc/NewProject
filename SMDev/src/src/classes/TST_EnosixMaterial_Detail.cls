/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_EnosixMaterial_Detail{
	@isTest
	static void testEnosixMaterial(){
		SBO_EnosixMaterial_Detail.EnosixMaterial sbo = new SBO_EnosixMaterial_Detail.EnosixMaterial();
		System.assertEquals(SBO_EnosixMaterial_Detail.EnosixMaterial.class, sbo.getType(), 'getType() does not match object type.');
				sbo.Material = 'X';
		System.assertEquals('X', sbo.Material);

		sbo.MaterialDescription = 'X';
		System.assertEquals('X', sbo.MaterialDescription);

		sbo.MaterialDescriptionUpperCase = 'X';
		System.assertEquals('X', sbo.MaterialDescriptionUpperCase);

		//Test child collections
		System.assertNotEquals(null,sbo.BASIC_DATA_1);
		System.assertNotEquals(null,sbo.BASIC_DATA_2);
		System.assertNotEquals(null,sbo.PLANT_DATA);
	}

		@isTest
	static void testBASIC_DATA_1()
	{
		SBO_EnosixMaterial_Detail.BASIC_DATA_1 childObj = new SBO_EnosixMaterial_Detail.BASIC_DATA_1();

		System.assertEquals(SBO_EnosixMaterial_Detail.BASIC_DATA_1.class,childObj.getType(),'getType() does not match object type.');
			childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.QuantityUOM = 'X';
		System.assertEquals('X', childObj.QuantityUOM);

		childObj.OldMaterialNumber = 'X';
		System.assertEquals('X', childObj.OldMaterialNumber);

		childObj.Division = 'X';
		System.assertEquals('X', childObj.Division);

		childObj.AllocationDeterminationProcedure = 'X';
		System.assertEquals('X', childObj.AllocationDeterminationProcedure);

		childObj.CrossPlantMaterialStatus = 'X';
		System.assertEquals('X', childObj.CrossPlantMaterialStatus);

		childObj.OverrideChangeNumbers = 'X';
		System.assertEquals('X', childObj.OverrideChangeNumbers);

		childObj.MaterialGroup = 'X';
		System.assertEquals('X', childObj.MaterialGroup);

		childObj.ExternalMaterialGroup = 'X';
		System.assertEquals('X', childObj.ExternalMaterialGroup);

		childObj.Laboratory = 'X';
		System.assertEquals('X', childObj.Laboratory);

		childObj.CrossPlantStatusValidDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CrossPlantStatusValidDate);

		childObj.GeneralItemCategoryGroup = 'X';
		System.assertEquals('X', childObj.GeneralItemCategoryGroup);

		childObj.AuthorizationGroup = 'X';
		System.assertEquals('X', childObj.AuthorizationGroup);

		childObj.GrossWeight = 1.5;
		System.assertEquals(1.5, childObj.GrossWeight);

		childObj.WeightUnit = 'X';
		System.assertEquals('X', childObj.WeightUnit);

		childObj.Netweight = 1.5;
		System.assertEquals(1.5, childObj.Netweight);

		childObj.Volume = 1.5;
		System.assertEquals(1.5, childObj.Volume);

		childObj.VolumeUnit = 'X';
		System.assertEquals('X', childObj.VolumeUnit);

		childObj.SizeDimensions = 'X';
		System.assertEquals('X', childObj.SizeDimensions);

		childObj.EANUPC = 'X';
		System.assertEquals('X', childObj.EANUPC);

		childObj.EANUPCCategory = 'X';
		System.assertEquals('X', childObj.EANUPCCategory);

		childObj.MaterialGroupPackagingMaterials = 'X';
		System.assertEquals('X', childObj.MaterialGroupPackagingMaterials);

		childObj.ReferenceMaterialPackedInSameWay = 'X';
		System.assertEquals('X', childObj.ReferenceMaterialPackedInSameWay);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testBASIC_DATA_2()
	{
		SBO_EnosixMaterial_Detail.BASIC_DATA_2 childObj = new SBO_EnosixMaterial_Detail.BASIC_DATA_2();

		System.assertEquals(SBO_EnosixMaterial_Detail.BASIC_DATA_2.class,childObj.getType(),'getType() does not match object type.');
			childObj.ANSIISODescription = 'X';
		System.assertEquals('X', childObj.ANSIISODescription);

		childObj.CADIndicator = 'X';
		System.assertEquals('X', childObj.CADIndicator);

		childObj.BasicMaterial = 'X';
		System.assertEquals('X', childObj.BasicMaterial);

		childObj.IntrastatDataTransportMedium = 'X';
		System.assertEquals('X', childObj.IntrastatDataTransportMedium);

		childObj.DangerousGoodsIndicator = 'X';
		System.assertEquals('X', childObj.DangerousGoodsIndicator);

		childObj.DangerousGoodsPackagingStatus = 'X';
		System.assertEquals('X', childObj.DangerousGoodsPackagingStatus);

		childObj.PackagingCode = 'X';
		System.assertEquals('X', childObj.PackagingCode);

		childObj.EnvironmentallyRelevant = 'X';
		System.assertEquals('X', childObj.EnvironmentallyRelevant);

		childObj.InBulkIndicator = 'X';
		System.assertEquals('X', childObj.InBulkIndicator);

		childObj.HighlyViscousIndicator = 'X';
		System.assertEquals('X', childObj.HighlyViscousIndicator);

		childObj.NonDMSDocumentNumber = 'X';
		System.assertEquals('X', childObj.NonDMSDocumentNumber);

		childObj.NonDMSDocumentType = 'X';
		System.assertEquals('X', childObj.NonDMSDocumentType);

		childObj.NonDMSDocumentVersion = 'X';
		System.assertEquals('X', childObj.NonDMSDocumentVersion);

		childObj.NonDMSDocumentPageNumber = 'X';
		System.assertEquals('X', childObj.NonDMSDocumentPageNumber);

		childObj.NonDMSDocumentChangeNumber = 'X';
		System.assertEquals('X', childObj.NonDMSDocumentChangeNumber);

		childObj.NonDMSDocumentPageFormat = 'X';
		System.assertEquals('X', childObj.NonDMSDocumentPageFormat);

		childObj.NonDMSDocumentNumberOfSheets = 'X';
		System.assertEquals('X', childObj.NonDMSDocumentNumberOfSheets);

		childObj.CrossPlantConfigurableMaterial = 'X';
		System.assertEquals('X', childObj.CrossPlantConfigurableMaterial);

		childObj.ConfigurableMaterial = 'X';
		System.assertEquals('X', childObj.ConfigurableMaterial);

		childObj.GlobalDataSyncIndicator = 'X';
		System.assertEquals('X', childObj.GlobalDataSyncIndicator);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testPLANT_DATA()
	{
		SBO_EnosixMaterial_Detail.PLANT_DATA childObj = new SBO_EnosixMaterial_Detail.PLANT_DATA();

		System.assertEquals(SBO_EnosixMaterial_Detail.PLANT_DATA.class,childObj.getType(),'getType() does not match object type.');
			childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.Name = 'X';
		System.assertEquals('X', childObj.Name);

		childObj.SalesOrganization = 'X';
		System.assertEquals('X', childObj.SalesOrganization);

		childObj.VKORG_TEXT = 'X';
		System.assertEquals('X', childObj.VKORG_TEXT);

		childObj.DistributionChannel = 'X';
		System.assertEquals('X', childObj.DistributionChannel);

		childObj.VTWEG_TEXT = 'X';
		System.assertEquals('X', childObj.VTWEG_TEXT);

List<string> keyFields = new List<string>{ 'WERKS','VKORG','VTWEG' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
}
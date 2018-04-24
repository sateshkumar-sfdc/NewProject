/// enosiX Inc. Generated Apex Model
/// Generated On: 10/6/2016 12:57:18 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
private class TST_EnosixWarehouseStock_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixWarehouseStock_Search sbo = new SBO_EnosixWarehouseStock_Search();
		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixWarehouseStock_Search.SEARCHPARAMS childObj = new SBO_EnosixWarehouseStock_Search.SEARCHPARAMS();
			childObj.X_SpecialStock = 'X';
		System.assertEquals('X', childObj.X_SpecialStock);

		childObj.X_DisplayBatchStock = 'X';
		System.assertEquals('X', childObj.X_DisplayBatchStock);

		childObj.X_DisplayNoZeroStockLines = 'X';
		System.assertEquals('X', childObj.X_DisplayNoZeroStockLines);

		childObj.MAXROWS = 0;
		System.assertEquals(0, childObj.MAXROWS);

	}
	@isTest
	static void testMATERIALSEARCH(){
	SBO_EnosixWarehouseStock_Search.MATERIALSEARCH childObj = new SBO_EnosixWarehouseStock_Search.MATERIALSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

		childObj.High = 'X';
		System.assertEquals('X', childObj.High);

	}
	@isTest
	static void testMATDESCSEARCH(){
	SBO_EnosixWarehouseStock_Search.MATDESCSEARCH childObj = new SBO_EnosixWarehouseStock_Search.MATDESCSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

	}
	@isTest
	static void testPLANTSEARCH(){
	SBO_EnosixWarehouseStock_Search.PLANTSEARCH childObj = new SBO_EnosixWarehouseStock_Search.PLANTSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

		childObj.High = 'X';
		System.assertEquals('X', childObj.High);

	}
	@isTest
	static void testSTORAGELOCSEARCH(){
	SBO_EnosixWarehouseStock_Search.STORAGELOCSEARCH childObj = new SBO_EnosixWarehouseStock_Search.STORAGELOCSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

		childObj.High = 'X';
		System.assertEquals('X', childObj.High);

	}
	@isTest
	static void testBATCHSEARCH(){
	SBO_EnosixWarehouseStock_Search.BATCHSEARCH childObj = new SBO_EnosixWarehouseStock_Search.BATCHSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

		childObj.High = 'X';
		System.assertEquals('X', childObj.High);

	}
	@isTest
	static void testMATERIALTYSEARCH(){
	SBO_EnosixWarehouseStock_Search.MATERIALTYSEARCH childObj = new SBO_EnosixWarehouseStock_Search.MATERIALTYSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

		childObj.High = 'X';
		System.assertEquals('X', childObj.High);

	}
	@isTest
	static void testMATERIALGRPSEARCH(){
	SBO_EnosixWarehouseStock_Search.MATERIALGRPSEARCH childObj = new SBO_EnosixWarehouseStock_Search.MATERIALGRPSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

		childObj.High = 'X';
		System.assertEquals('X', childObj.High);

	}
	@isTest
	static void testSPECIALSTKTYSEARCH(){
	SBO_EnosixWarehouseStock_Search.SPECIALSTKTYSEARCH childObj = new SBO_EnosixWarehouseStock_Search.SPECIALSTKTYSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

		childObj.High = 'X';
		System.assertEquals('X', childObj.High);

	}
	@isTest
	static void testPOSTINGDTSEARCH(){
	SBO_EnosixWarehouseStock_Search.POSTINGDTSEARCH childObj = new SBO_EnosixWarehouseStock_Search.POSTINGDTSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.Low);

		childObj.High = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.High);

	}
	@isTest
	static void testMOVEMENTTYSEARCH(){
	SBO_EnosixWarehouseStock_Search.MOVEMENTTYSEARCH childObj = new SBO_EnosixWarehouseStock_Search.MOVEMENTTYSEARCH();
			childObj.Sign = 'X';
		System.assertEquals('X', childObj.Sign);

		childObj.Option = 'X';
		System.assertEquals('X', childObj.Option);

		childObj.Low = 'X';
		System.assertEquals('X', childObj.Low);

		childObj.High = 'X';
		System.assertEquals('X', childObj.High);

	}
@isTest
static void testEnosixWarehouseStock_SR()
{
SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SR sr = new SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SR();
System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixWarehouseStock_Search.SEARCHRESULT childObj = new SBO_EnosixWarehouseStock_Search.SEARCHRESULT();
			childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.MaterialDescription = 'X';
		System.assertEquals('X', childObj.MaterialDescription);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.StorageLocation = 'X';
		System.assertEquals('X', childObj.StorageLocation);

		childObj.StorageLocationDescription = 'X';
		System.assertEquals('X', childObj.StorageLocationDescription);

		childObj.MaterialType = 'X';
		System.assertEquals('X', childObj.MaterialType);

		childObj.MaterialGroup = 'X';
		System.assertEquals('X', childObj.MaterialGroup);

		childObj.SpecialStockInd = 'X';
		System.assertEquals('X', childObj.SpecialStockInd);

		childObj.ValuationofSpecialStock = 'X';
		System.assertEquals('X', childObj.ValuationofSpecialStock);

		childObj.SpecialStockNumber = 'X';
		System.assertEquals('X', childObj.SpecialStockNumber);

		childObj.DeletionFLag = 'X';
		System.assertEquals('X', childObj.DeletionFLag);

		childObj.BatchNumber = 'X';
		System.assertEquals('X', childObj.BatchNumber);

		childObj.QuantityUOM = 'X';
		System.assertEquals('X', childObj.QuantityUOM);

		childObj.Currencies = 'X';
		System.assertEquals('X', childObj.Currencies);

		childObj.UnrestrictedStock = 1.5;
		System.assertEquals(1.5, childObj.UnrestrictedStock);

		childObj.UnrestrictedValue = 1.5;
		System.assertEquals(1.5, childObj.UnrestrictedValue);

		childObj.TransitTransferStock = 1.5;
		System.assertEquals(1.5, childObj.TransitTransferStock);

		childObj.TransitTransferValue = 1.5;
		System.assertEquals(1.5, childObj.TransitTransferValue);

		childObj.QualityInspectionStock = 1.5;
		System.assertEquals(1.5, childObj.QualityInspectionStock);

		childObj.QualityInspectionValue = 1.5;
		System.assertEquals(1.5, childObj.QualityInspectionValue);

		childObj.RestrictedStock = 1.5;
		System.assertEquals(1.5, childObj.RestrictedStock);

		childObj.RestrictedValue = 1.5;
		System.assertEquals(1.5, childObj.RestrictedValue);

		childObj.BlockedStock = 1.5;
		System.assertEquals(1.5, childObj.BlockedStock);

		childObj.BlockedValue = 1.5;
		System.assertEquals(1.5, childObj.BlockedValue);

		childObj.ReturnsStock = 1.5;
		System.assertEquals(1.5, childObj.ReturnsStock);

		childObj.ReturnsValue = 1.5;
		System.assertEquals(1.5, childObj.ReturnsValue);

		childObj.SystemID = 'X';
		System.assertEquals('X', childObj.SystemID);

	}

}
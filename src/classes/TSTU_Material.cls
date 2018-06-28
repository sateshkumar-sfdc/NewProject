@isTest
public class TSTU_Material {

  public class MOC_searchForMaterialsBySalesArea implements ENSX.EnosixFramework.SearchSBOMock {

    public ensx.EnosixFramework.SearchResult executeSearch() {
      SBO_EnosixMaterial_Search.EnosixMaterial_SR search_result = new SBO_EnosixMaterial_Search.EnosixMaterial_SR();
      search_result.setSuccess(false);
      return search_result;
    }

  }

  @isTest
  static void test_searchForMaterialsBySalesArea() {
    MOC_searchForMaterialsBySalesArea moc = new MOC_searchForMaterialsBySalesArea();

    ENSX.EnosixFramework.setMock(SBO_EnosixMaterial_Search.class, moc);

    Test.startTest();
    SBO_EnosixMaterial_Search.EnosixMaterial_SR result = UTIL_Material.searchForMaterialsBySalesArea('1', '2');
    Test.stopTest();

    System.assert(null != result);

  }


  public class MOC_getMaterialFromMaterialNumber implements ENSX.EnosixFramework.DetailSBOGetMock {
    public ENSX.EnosixFramework.DetailObject executeGetDetail(object key) {
      SBO_EnosixMaterial_Detail.EnosixMaterial result = new SBO_EnosixMaterial_Detail.EnosixMaterial();
      result.setSuccess(false);
      return result;
    }
  }

  @isTest
  static void test_getMaterialFromMaterialNumber() {
    MOC_getMaterialFromMaterialNumber moc = new MOC_getMaterialFromMaterialNumber();

    ENSX.EnosixFramework.setMock(SBO_EnosixMaterial_Detail.class, moc);

    Test.startTest();
    SBO_EnosixMaterial_Detail.EnosixMaterial result = UTIL_Material.getMaterialFromMaterialNumber('1');
    Test.stopTest();

    System.assert(null != result);

  }

  @isTest
  static void test_addMaterialsFromSearchResultsToSelectOptions() {
    SBO_EnosixMaterial_Search.EnosixMaterial_SR searchResult = new SBO_EnosixMaterial_Search.EnosixMaterial_SR();

    SBO_EnosixMaterial_Search.SEARCHRESULT sr1 = new SBO_EnosixMaterial_Search.SEARCHRESULT();
    sr1.MaterialDescription = 'foo';
    searchResult.SearchResults.add(sr1);

    SBO_EnosixMaterial_Search.SEARCHRESULT sr2 = new SBO_EnosixMaterial_Search.SEARCHRESULT();
    sr2.Material = '1';
    sr2.MaterialDescription = 'bar';
    searchResult.SearchResults.add(sr2);

    List<SelectOption> result = new List<SelectOption>();

    Test.startTest();
    UTIL_Material.addMaterialsFromSearchResultsToSelectOptions(searchResult, result);
    Test.stopTest();

    System.assert(1 == result.size());
  }

  @isTest
  static void test_getPlantsMatchingSalesAreaFromMaterialDetail() {
    SBO_EnosixMaterial_Detail.EnosixMaterial material = new SBO_EnosixMaterial_Detail.EnosixMaterial();

    SBO_EnosixMaterial_Detail.PLANT_DATA plant = new SBO_EnosixMaterial_Detail.PLANT_DATA();
    plant.SalesOrganization = '01';
    plant.DistributionChannel = '02';
    material.PLANT_DATA.add(plant);

    Test.startTest();
    List<SBO_EnosixMaterial_Detail.PLANT_DATA> result = UTIL_Material.getPlantsMatchingSalesAreaFromMaterialDetail(material, '01', '02');
    Test.stopTest();

    System.assert(1 == result.size());

  }

  @isTest
  static void test_addPlantsToSelectOptions() {
    List<SBO_EnosixMaterial_Detail.PLANT_DATA> plants = new List<SBO_EnosixMaterial_Detail.PLANT_DATA>();
    List<SelectOption> result = new List<SelectOption>();

    SBO_EnosixMaterial_Detail.PLANT_DATA plant1 = new SBO_EnosixMaterial_Detail.PLANT_DATA();
    plant1.SalesOrganization = '01';
    plant1.DistributionChannel = '02';
    plants.add(plant1);

    SBO_EnosixMaterial_Detail.PLANT_DATA plant2 = new SBO_EnosixMaterial_Detail.PLANT_DATA();
    plant2.Plant = '01';
    plant2.Name = '01';
    plants.add(plant2);

    Test.startTest();
    UTIL_Material.addPlantsToSelectOptions(plants, result);
    Test.stopTest();

    System.assert(1 == result.size());

  }

}
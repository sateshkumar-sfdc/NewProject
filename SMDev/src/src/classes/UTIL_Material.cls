public class UTIL_Material {

  /* Searches for materials by sales area information */
  public static SBO_EnosixMaterial_Search.EnosixMaterial_SR searchForMaterialsBySalesArea (
      string salesOrginization
    , string distributionChannel
    ) {

    SBO_EnosixMaterial_Search sbo = new SBO_EnosixMaterial_Search();

    sbo.SearchContext.SEARCHPARAMS.SalesOrganization = salesOrginization;
    sbo.SearchContext.SEARCHPARAMS.DistributionChannel = distributionChannel;

    SBO_EnosixMaterial_Search.EnosixMaterial_SR result = sbo.execute();

    if (!result.isSuccess()) {
      ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
    }

    return result;
  }

  /* Returns a material detail SBO from SAP */
  public static SBO_EnosixMaterial_Detail.EnosixMaterial getMaterialFromMaterialNumber (
    string materialNumber
    ) {

    SBO_EnosixMaterial_Detail sbo = new SBO_EnosixMaterial_Detail();

    SBO_EnosixMaterial_Detail.EnosixMaterial result = sbo.getDetail(materialNumber);

    if (!result.isSuccess()) {
       ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
    }

    return result;

  }

  /* */
  public static void addMaterialsFromSearchResultsToSelectOptions (
      SBO_EnosixMaterial_Search.EnosixMaterial_SR searchResult
    , List<SelectOption> result
    ) {

    if (null == searchResult || null == result) return;

    List<SBO_EnosixMaterial_Search.SEARCHRESULT> searchResults = searchResult.getResults();

    Set<string> values = new Set<string>();

    for (SBO_EnosixMaterial_Search.SEARCHRESULT sr : searchResults) {
      string value = sr.Material;

      if (!values.contains(value) && string.isNotBlank(value)) {
         result.add(new SelectOption(value, sr.MaterialDescription));
         values.add(value);
      }

    }
  }

  static boolean plantMatchesSalesArea (
      SBO_EnosixMaterial_Detail.PLANT_DATA plant
    , string salesOrganization
    , string distributionChannel
    ) {
      return salesOrganization == plant.SalesOrganization && distributionChannel == plant.DistributionChannel;
  }

  /* */
  public static List<SBO_EnosixMaterial_Detail.PLANT_DATA> getPlantsMatchingSalesAreaFromMaterialDetail (
      SBO_EnosixMaterial_Detail.EnosixMaterial material
    , string salesOrganization
    , string distributionChannel
  ) {

    List<SBO_EnosixMaterial_Detail.PLANT_DATA> result = new List<SBO_EnosixMaterial_Detail.PLANT_DATA>();
    List<SBO_EnosixMaterial_Detail.PLANT_DATA> plants = new List<SBO_EnosixMaterial_Detail.PLANT_DATA>();

    if (null != material) {
      material.PLANT_DATA.copyTo(plants);
    }

    for (SBO_EnosixMaterial_Detail.PLANT_DATA plant : plants) {
      if ( plantMatchesSalesArea(plant, salesOrganization, distributionChannel) ) {
        result.add(plant);
      }
    }

    return result;

  }

  /* */
  public static void addPlantsToSelectOptions (
      List<SBO_EnosixMaterial_Detail.PLANT_DATA> plants
    , List<SelectOption> result
    ) {

    if ( null == plants ||  null == result ) return;

    Set<string> values = new Set<string>();

    for (SBO_EnosixMaterial_Detail.PLANT_DATA plant : plants) {
      string value = plant.Plant;
      string description = plant.Name;
      if ( !values.contains(value) && string.isNotBlank(value) && string.isNotBlank(description) ) {
        result.add(new SelectOption(value, description));
        values.add(value);
      }
    }
  }

}
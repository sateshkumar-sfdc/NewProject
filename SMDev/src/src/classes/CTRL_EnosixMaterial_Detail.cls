public with sharing class CTRL_EnosixMaterial_Detail {

    public SBO_EnosixMaterial_Detail.EnosixMaterial materialDetail { get;  set;}
    public string materialnumber;
    public string SF_ProductId {get; set;}
    public string ProductMaterialField = 'ProductCode';
    private string materialParameter = 'SF_MatId';
    private string productParameter ='SF_ProductId';

    // Is there a reason we are using init() action instead of doing this in the constructor?
	public void init() {
 		materialnumber = getMaterialNumberFromPageParameters();
	 	this.materialDetail = getMaterialFromMaterialNumber(materialnumber);
	}

	// Determine the material number by inspecting the page parameters
	@TestVisible
	private string getMaterialNumberFromPageParameters() {
        SF_ProductId = UTIL_PageState.current.productId;

        String materialId = UTIL_PageState.current.materialId;
        if (!String.isBlank(materialId)) return materialId;

        product2 prod = getProductFromProductId(SF_ProductId);
        return getMaterialNumberFromProduct(prod);
	}

	@TestVisible
	private SBO_EnosixMaterial_Detail.EnosixMaterial getMaterialFromMaterialNumber(string materialNumber) {

		SBO_EnosixMaterial_Detail.EnosixMaterial result = null;

		SBO_EnosixMaterial_Detail sbo = new SBO_EnosixMaterial_Detail();

		result = sbo.getDetail(materialnumber);

		if (!result.isSuccess()) {
			ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
		}
		return result;
	}

	public String getMaterialNumberFromProduct(product2 product) {
        string  result = null;
        string productID = product.Id;
        Product2 prod = Database.query('SELECT ' + ProductMaterialField +  ' FROM Product2 WHERE Id = :productID LIMIT 1');
	    result = (string)prod.get(ProductMaterialField);
        if(result==null || string.isEmpty(result))
        {
        	ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR , 'The Product record does not have Associated Material Information.'));
        }
        return result;
	}

	public product2 getProductFromProductId(string productId) {

		product2 prod = [SELECT  Id, ProductCode FROM Product2 WHERE Id = :productId];
		return prod;
	}

}
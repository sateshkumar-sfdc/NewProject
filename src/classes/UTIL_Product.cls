public class UTIL_Product
{
    // The material number field on SF Product2 table
    public static String MaterialFieldName
    {
        get
        {
            return (String)UTIL_AppSettings.getValue(
                'Product.MaterialFieldName', 'ENSX_EDM__Material__c');
        }
    }

    // getMaterialToProductIdMap()
    //
    // Returns a map of Material Number => Product2.Id
    public static Map<String, Id> getMaterialToProductIdMap()
    {
        Map<String, Id> result = new Map<String, Id>();

        String materialField = UTIL_Product.MaterialFieldName;

        List<Product2> items = Database.query(
            'SELECT Id, ' + materialField + ' FROM Product2 WHERE ' +
            materialField + ' != NULL AND IsActive = True'
        );

        for (Product2 item : items)
        {
            String materialNumber = String.valueOf(item.get(materialField));
            result.put(materialNumber, item.Id);
        }

        return result;
    }

    // setProductMaterialField()
    //
    // Sets the material number field of the given product
    public static void setProductMaterialField(Product2 product, String materialNumber)
    {
        String materialField = UTIL_Product.MaterialFieldName;
        if (null != product)
        {
            product.put(materialField, materialNumber);
        }
    }

    // getSAPMaterialNumbersFromProductList()
    //
    // Returns the SAP material number for a given product.
    public static Map<Id, String> getSAPMaterialNumbersFromProductList(Set<Id> productIdList)
    {
        String materialField = UTIL_Product.MaterialFieldName;
        List<Product2> productList = Database.query(
            'SELECT Id, ' + materialField + ' FROM Product2 where Id IN :productIdList');
        for (Product2 product : productList)
        {
            String materialNumber = (String) product.get(materialField);
            if (!cache_getSAPMaterialNumberFromProduct.containsKey(product.Id))
            {
                cache_getSAPMaterialNumberFromProduct.put(product.Id, materialNumber);
            }
        }

        return cache_getSAPMaterialNumberFromProduct;
    }

    private static Map<Id, String> cache_getSAPMaterialNumberFromProduct = new Map<Id, String>();
}
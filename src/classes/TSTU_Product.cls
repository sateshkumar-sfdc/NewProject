/*
*Test class for UTIL_Product
*/
@isTest
public class TSTU_Product
{
    @isTest
    public static void test_getSAPMaterialNumbersFromProductList()
    {
        Test.startTest();

        // Create a fake product and do an insert
        Product2 product1 = new Product2();
        product1.IsActive = true;
        product1.Name = 'FakeProd';
        product1.ProductCode = '2WJD83';
        String materialFieldValue = '12345';
        UTIL_Product.setProductMaterialField(product1, materialFieldValue);
        insert product1;

        SET<Id> testIds = new SET<Id>();
        testIds.add(product1.Id);
        MAP<Id, String> result2 = UTIL_Product.getSAPMaterialNumbersFromProductList(testIds);
        System.assertEquals(materialFieldValue, result2.get(product1.Id));

        UTIL_Product.getMaterialToProductIdMap();

        Test.stopTest();
    }
}
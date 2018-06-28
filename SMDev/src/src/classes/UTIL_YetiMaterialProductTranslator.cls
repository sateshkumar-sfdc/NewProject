public class UTIL_YetiMaterialProductTranslator extends CTRL_MaterialSearch.ProductAttributeTranslator
{
    public override String translate(String sapAttribute)
    {
        // Removing the risk of changes in capitalization SAP side breaking the translation
        if (sapAttribute.ToUpperCase() == 'PRODUCT ATTRIBUTE 1')
            return 'Standard Product';

        return sapAttribute;
    }
}
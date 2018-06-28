public class UTIL_Instances
{
    //List of keys that are exposed for customer configuration.
    public static String ShipToBuilder = 'ShipToDropdownBuilder';
    public static String CustomerConditionGroupBuilder1 = 'CustomerConditionGroupBuilder1';
    public static String CustomerConditionGroupBuilder2 = 'CustomerConditionGroupBuilder2';

    //Maps configuration points to custom object types
    //This is the "default" implementation for every call site.
    //To override this for a customer UtiL_OrgAppSettings will need to provide an
    //override of the fetchObjectInstance(string) method that recalls a custom object based
    //upon one of the key configuration points above.
    private static Map<string,Type> instanceMap = new Map<string,Type>{
            UTIL_Instances.ShipToBuilder => UTIL_Order.PartnerOptionBuilder.class,
            UTIL_Instances.CustomerConditionGroupBuilder1 => UTIL_Order.CustomerConditonOptionBuilder.class,
            UTIL_Instances.CustomerConditionGroupBuilder2 => UTIL_Order.CustomerConditonOptionBuilder.class
    };

    public static object getInstance(string instanceName)
    {
        Type objectType = instanceMap.get(instanceName);

        if(null != objectType)
            return objectType.newInstance();
        return null;
    }
}
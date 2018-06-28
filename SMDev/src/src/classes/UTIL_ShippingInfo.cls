/* utility class for Sales Area information */
// TODO: I think this class shouldn't exist. These methods could go in UTIL_Order, right?
public class UTIL_ShippingInfo
{
    @testVisible
    public static RFC_SD_GET_SHIP_INFO.RESULT getShippingMaster() {
        RFC_SD_GET_SHIP_INFO rfc = new RFC_SD_GET_SHIP_INFO();

        RFC_SD_GET_SHIP_INFO.RESULT result = rfc.execute();

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
        }

        return result;
    }

    @testVisible
    public static List<RFC_SD_GET_SHIP_INFO.ET_SHIP_COND> filterShippingConditions(
        RFC_SD_GET_SHIP_INFO.RESULT shippingConditionMaster)
    {
        List<RFC_SD_GET_SHIP_INFO.ET_SHIP_COND> filteredList = new List<RFC_SD_GET_SHIP_INFO.ET_SHIP_COND>();

        if (null != shippingConditionMaster)
        {
            for (RFC_SD_GET_SHIP_INFO.ET_SHIP_COND shippingCondition : shippingConditionMaster.ET_SHIP_COND_List)
            {
                if (allowedShippingConditions.contains(shippingCondition.VSBED)
                    || allowedShippingConditions.contains('*'))
                {
                    filteredList.add(shippingCondition);
                }
            }
        }

        return filteredList;
    }

    private static Set<String> allowedShippingConditions
    {
        get
        {
            return (Set<String>)UTIL_AppSettings.getSet(
                'Order.AllowedShippingConditions', String.class, new Set<String>{'*'});
        }
    }

    public class ShippingConditionOptionBuilder extends UTIL_SelectOption.OptionBuilder
    {
        public override string getItemValue(object item){
            return ((RFC_SD_GET_SHIP_INFO.ET_SHIP_COND)item).VSBED;
        }

        public override string getItemLabel(object item) {
            return string.format('{0} - {1}', new string[]{getItemValue(item), getItemDescription(item)});
        }

        public override string getItemDescription(object item) {
            return ((RFC_SD_GET_SHIP_INFO.ET_SHIP_COND)item).VTEXT;
        }
    }
}
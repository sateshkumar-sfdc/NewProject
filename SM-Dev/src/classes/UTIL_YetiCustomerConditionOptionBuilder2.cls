// This helps build select options for the Customer Condition 1 dropdowns
public class UTIL_YetiCustomerConditionOptionBuilder2 extends UTIL_Order.CustomerConditonOptionBuilder
{
    public override Boolean isItemDisplayed(object item)
    {
        // Show items that are only numeric - pattern matches one or more digits
        return Pattern.matches('^[0-9]+$', getItemValue(item));
    }
}
// This helps build select options for the Customer Condition 1 dropdowns
public class UTIL_YetiCustomerConditionOptionBuilder1 extends UTIL_Order.CustomerConditonOptionBuilder
{
    private Set<String> displayedFilter = new Set<String> { 'Z3' };

    public override Boolean isItemDisplayed(object item)
    {
        return displayedFilter.contains(getItemValue(item));
    }
}
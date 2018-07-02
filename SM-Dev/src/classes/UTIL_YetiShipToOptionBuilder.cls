// This builds a drop down list of ship to customers
// Displayed Field is: Customer Number - Customer Name - Street City, Region Postalcode
public class UTIL_YetiShipToOptionBuilder extends UTIL_SelectOption.OptionBuilder
{

    public override String getItemValue(object item)
    {
        return ((SBO_EnosixCustomer_Detail.PARTNERS) item).PartnerNumber;
    }

    public override String getItemDescription(object item)
    {
        return ((SBO_EnosixCustomer_Detail.PARTNERS) item).PartnerName;
    }

    public override String getItemLabel(object item)
    {
        SBO_EnosixCustomer_Detail.PARTNERS p = (SBO_EnosixCustomer_Detail.PARTNERS) item;
        return String.Format(
                '{0} - {1} - {2} {3}, {4} {5}',
                new List<String>
                {
                        p.PartnerNumber,
                        p.PartnerName,
                        p.Street,
                        p.City,
                        p.Region,
                        p.PostalCode
                }
        );
    }
}
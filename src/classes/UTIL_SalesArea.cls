/* utility class for Sales Area information */
public class UTIL_SalesArea {

  /*
    Gets the sales area master data
  */
  public static RFC_SD_GET_SALES_AREAS.RESULT getSalesAreaMaster() {
    RFC_SD_GET_SALES_AREAS rfc = new RFC_SD_GET_SALES_AREAS();

    RFC_SD_GET_SALES_AREAS.RESULT result = rfc.execute();

    UTIL_Error.displayResultErrors(result);

    return result;
  }

  public static boolean isSales_Area(object item) {
    return item instanceof RFC_SD_GET_SALES_AREAS.ET_SALES_AREA;
  }

  public static RFC_SD_GET_SALES_AREAS.ET_SALES_AREA asSales_Area(object item) {
    return (RFC_SD_GET_SALES_AREAS.ET_SALES_AREA)item;
  }

  public class SalesOrganization_OptionBuilder extends UTIL_SelectOption.OptionBuilder {

    public override string getItemValue(object item) {
      if ( isSales_Area(item) )
      {
        return asSales_Area(item).SalesOrganization;
      }
      return super.getItemValue(item);
    }

    public override string getItemDescription(object item) {
      if (isSales_Area(item))
      {
        return asSales_Area(item).SalesOrganizationName;
      }
      return super.getItemDescription(item);
    }

    //This dropdown only needs to display the description for the Label
    public override string getItemLabel(object item) {
      //Comment out this block for debugging
      if(isSales_Area(item))
      {
          return getItemDescription(item);
      }
      return super.getItemLabel(item);
    }
  }

  //Provides methods for restricting the distribution channel
  //and Division options. Both of those have a restriction
  //based upon the currently selected sales area.
  public interface DistributionChannel_Filter {
    string getSelectedSalesOrganization();
  }

  public class DistributionChannel_OptionBuilder extends UTIL_SelectOption.OptionBuilder {

    private DistributionChannel_Filter filter;

    public DistributionChannel_OptionBuilder (
      DistributionChannel_Filter filter
    ) {
      this.filter = filter;
    }

    public override boolean isItemDisplayed(object item) {

      if (isSales_Area(item)) {
        string salesOrg = filter.getSelectedSalesOrganization();
        string itemOrg = asSales_Area(item).SalesOrganization;
        return salesOrg.equals( itemOrg );
      }

      return super.isItemDisplayed(item);
    }

    public override string getItemValue(object item) {
      if (isSales_Area(item)) {
        return asSales_Area(item).DistributionChannel;
      }
      return super.getItemValue(item);
    }

    public override string getItemDescription(object item) {
      if (isSales_Area(item)) {
        return asSales_Area(item).DistributionChannelName;
      }
      return super.getItemDescription(item);
    }

    //This dropdown only needs to display the description for the Label
    public override string getItemLabel(object item) {
      //Comment out this block for debugging
      if(isSales_Area(item))
      {
          return getItemDescription(item);
      }
      return super.getItemLabel(item);
    }
  }

  //Provides methods for restricting the division drop down lists
  //Division is restricted both by the currently selected distribution channel
  //and the sales area. (see super interface.)
  public interface Division_Filter extends DistributionChannel_Filter {
    string getSelectedDistributionChannel();
  }

  public class Division_OptionBuilder extends UTIL_SelectOption.OptionBuilder {
    private Division_Filter filter;

    public Division_OptionBuilder (
      Division_Filter filter
    ) {
      this.filter = filter;
    }

    public override boolean isItemDisplayed(object item) {

      if (isSales_Area(item)) {

        string salesOrg = filter.getSelectedSalesOrganization();
        string itemOrg = asSales_Area(item).SalesOrganization;
        string salesChannel = filter.getSelectedDistributionChannel();
        string itemChannel = asSales_Area(item).DistributionChannel;

        return salesOrg.equals( itemOrg ) && salesChannel.equals( itemChannel ) ;
      }

      return super.isItemDisplayed(item);
    }

    public override string getItemValue(object item) {
      if (isSales_Area(item)) {
        return asSales_Area(item).Division;
      }
      return super.getItemValue(item);
    }

    public override string getItemDescription(object item) {
      if (isSales_Area(item)) {
        return asSales_Area(item).DivisionName;
      }
      return super.getItemDescription(item);
    }

    //This dropdown only needs to display the description for the Label
    public override string getItemLabel(object item) {
      //Comment out this block for debugging
      if(isSales_Area(item))
      {
          return getItemDescription(item);
      }
      return super.getItemLabel(item);
    }
  }
}
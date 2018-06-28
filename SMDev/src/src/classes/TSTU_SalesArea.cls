/*
* Test cases for sales area utility class
*/
@isTest
public class TSTU_SalesArea {

  class MOC_getSalesAreaMaster implements ENSX.EnosixFramework.RFCMock {
    public ENSX.EnosixFramework.FunctionObject executeFunction() {
      RFC_SD_GET_SALES_AREAS.RESULT result = new RFC_SD_GET_SALES_AREAS.RESULT();
      result.setSuccess(false);
      return result;
    }
  }

  @isTest
  public static void test_getSalesAreaMaster() {
    ENSX.EnosixFramework.setMock(RFC_SD_GET_SALES_AREAS.class, new MOC_getSalesAreaMaster());

    Test.startTest();
    RFC_SD_GET_SALES_AREAS.RESULT result = UTIL_SalesArea.getSalesAreaMaster();
    Test.stopTest();
  }

  @isTest
  public static void test_isSales_Area() {
    Test.startTest();
    boolean result = UTIL_SalesArea.isSales_Area(new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA());
    Test.stopTest();
    System.assertEquals(true, result);
  }

  @isTest
  public static void test_asSales_Area() {
    Test.startTest();
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA result = UTIL_SalesArea.asSales_Area(new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA());
    Test.stopTest();
    System.assertNotEquals(null, result);
  }

  @isTest
  public static void test_SalesOrganization_OptionBuilder_getItemValue() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.SalesOrganization = 'org1';
    UTIL_SalesArea.SalesOrganization_OptionBuilder builder = new UTIL_SalesArea.SalesOrganization_OptionBuilder();
    Test.startTest();
    string result = builder.getItemValue(item);
    Test.stopTest();
    System.assertEquals('org1', result);
  }

  @isTest
  public static void test_SalesOrganization_OptionBuilder_getItemDescription() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.SalesOrganizationName = 'name1';
    UTIL_SalesArea.SalesOrganization_OptionBuilder builder = new UTIL_SalesArea.SalesOrganization_OptionBuilder();
    Test.startTest();
    string result = builder.getItemDescription(item);
    Test.stopTest();
    System.assertEquals('name1', result);
  }

  @isTest
  public static void test_SalesOrganization_OptionBuilder_getItemLabel() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.SalesOrganizationName = 'name1';
    UTIL_SalesArea.SalesOrganization_OptionBuilder builder = new UTIL_SalesArea.SalesOrganization_OptionBuilder();
    Test.startTest();
    string result = builder.getItemLabel(item);
    Test.stopTest();
    System.assertEquals('name1', result);
  }

  class Test_DistributionChannel_Filter implements UTIL_SalesArea.DistributionChannel_Filter {
    public string getSelectedSalesOrganization(){
      return 'org1';
    }
  }

  @isTest
  public static void test_DistributionChannel_OptionBuilder_isItemDisplayed() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.SalesOrganizationName = 'org1';
    UTIL_SalesArea.DistributionChannel_OptionBuilder builder = new UTIL_SalesArea.DistributionChannel_OptionBuilder(
      new Test_DistributionChannel_Filter()
      );

    Test.startTest();
    boolean result = builder.isItemDisplayed(item);
    Test.stopTest();
    System.assertEquals(false, result);
  }

  @isTest
  public static void test_DistributionChannel_OptionBuilder_getItemValue() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.DistributionChannel = 'dc1';
    UTIL_SalesArea.DistributionChannel_OptionBuilder builder = new UTIL_SalesArea.DistributionChannel_OptionBuilder(
      new Test_DistributionChannel_Filter()
      );

    Test.startTest();
    string result = builder.getItemValue(item);
    Test.stopTest();
    System.assertEquals('dc1', result);
  }

  @isTest
  public static void test_DistributionChannel_OptionBuilder_getItemDescription() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.DistributionChannelName = 'dc1-name';
    UTIL_SalesArea.DistributionChannel_OptionBuilder builder = new UTIL_SalesArea.DistributionChannel_OptionBuilder(
      new Test_DistributionChannel_Filter()
      );

    Test.startTest();
    string result = builder.getItemDescription(item);
    Test.stopTest();
    System.assertEquals('dc1-name', result);
  }

  @isTest
  public static void test_DistributionChannel_OptionBuilder_getItemLabel() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.DistributionChannelName = 'dc1-name';
    UTIL_SalesArea.DistributionChannel_OptionBuilder builder = new UTIL_SalesArea.DistributionChannel_OptionBuilder(
      new Test_DistributionChannel_Filter()
      );

    Test.startTest();
    string result = builder.getItemLabel(item);
    Test.stopTest();
    System.assertEquals('dc1-name', result);
  }

  class Test_Division_Filter implements UTIL_SalesArea.Division_Filter {
    public string getSelectedSalesOrganization() {
      return 'org1';
    }
    public string getSelectedDistributionChannel() {
      return 'dc1';
    }
  }

  @isTest
  public static void test_Division_OptionBuilder_isItemDisplayed() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.SalesOrganizationName = 'org1';
    item.DistributionChannel = 'dc1';
    UTIL_SalesArea.Division_OptionBuilder builder = new UTIL_SalesArea.Division_OptionBuilder(
      new Test_Division_Filter()
      );

    Test.startTest();
    boolean result = builder.isItemDisplayed(item);
    Test.stopTest();
    System.assertEquals(false, result);
  }

  @isTest
  public static void test_Division_OptionBuilder_getItemValue() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.Division = 'd1';
    UTIL_SalesArea.Division_OptionBuilder builder = new UTIL_SalesArea.Division_OptionBuilder(
      new Test_Division_Filter()
      );

    Test.startTest();
    string result = builder.getItemValue(item);
    Test.stopTest();
    System.assertEquals('d1', result);
  }

  @isTest
  public static void test_Division_OptionBuilder_getItemDescription() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.DivisionName = 'd1-name';
    UTIL_SalesArea.Division_OptionBuilder builder = new UTIL_SalesArea.Division_OptionBuilder(
      new Test_Division_Filter()
      );

    Test.startTest();
    string result = builder.getItemDescription(item);
    Test.stopTest();
    System.assertEquals('d1-name', result);
  }

  @isTest
  public static void test_Division_OptionBuilder_getItemLabel() {
    RFC_SD_GET_SALES_AREAS.ET_SALES_AREA item = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();
    item.DivisionName = 'd1-name';
    UTIL_SalesArea.Division_OptionBuilder builder = new UTIL_SalesArea.Division_OptionBuilder(
      new Test_Division_Filter()
      );

    Test.startTest();
    string result = builder.getItemLabel(item);
    Test.stopTest();
    System.assertEquals('d1-name', result);
  }
}
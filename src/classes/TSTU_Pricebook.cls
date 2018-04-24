/*
* Test cases for price book utility class
*/
@isTest
public class TSTU_Pricebook
{
  @isTest
  public static void test_getEntriesForPricebook() {
    Pricebook2 pricebook = new Pricebook2(Name='test');

    upsert pricebook;

    Test.startTest();
    Map<Id, PricebookEntry> result = UTIL_Pricebook.getEntriesForPricebook(pricebook, 'USD');
    Test.stopTest();

    system.assertNotEquals(null, result);
  }
}
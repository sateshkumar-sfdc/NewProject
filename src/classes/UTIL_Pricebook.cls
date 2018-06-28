public class UTIL_Pricebook
{
  public static Map<Id, PricebookEntry> getEntriesForPricebook(Pricebook2 priceBook, String currencyCode) {
    Map<Id, PricebookEntry> result = new Map<Id, PricebookEntry>();

    if (null != priceBook) {
      List<PricebookEntry> items = [SELECT Id, Name, UnitPrice,IsActive,Product2Id,Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id =: priceBook.Id AND CurrencyIsoCode =: currencyCode];

      for (PricebookEntry item : items) {
        result.put(item.Product2Id, item);
      }

    }

    return result;
  }

}
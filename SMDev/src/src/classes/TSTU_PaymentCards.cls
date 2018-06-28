@isTest
public with sharing class TSTU_PaymentCards {

  @isTest
  static void test_addCardToOrder(){
    SBO_EnosixXiIntercept_Detail.RESPONSE response = new SBO_EnosixXiIntercept_Detail.RESPONSE();
    response.CreditCardNumber = '123456789012';
    response.ValidToYear = '2017';
    response.ValidToMonth = '12';

    SBO_EnosixSO_Detail.EnosixSO order = new SBO_EnosixSO_Detail.EnosixSO();

    Test.startTest();
    UTIL_PaymentCards.addCardToOrder(response, order, 1);
    Test.stopTest();

    System.assert(1 == order.CCARD.size());
  }

  @isTest
  static void test_removeCardFromOrder(){

    SBO_EnosixSO_Detail.CCARD card = new SBO_EnosixSO_Detail.CCARD();
    card.CreditCardNumber = '123456789012';

    SBO_EnosixSO_Detail.EnosixSO order = new SBO_EnosixSO_Detail.EnosixSO();
    order.CCARD.add(card);

    Test.startTest();
    boolean result = UTIL_PaymentCards.removeCardFromOrder(order, '123456789012');
    Test.stopTest();

    System.assert(true == result);
    System.assert(0 == order.CCARD.size());
  }

  @isTest
  static void test_getPaymetricTargetUrl() {
    SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
    intercept.XiInterceptURL = '0';
    intercept.MerchantGUID = '1';
    intercept.AccessToken = '2';

    Test.startTest();
    string result = UTIL_PaymentCards.getPaymetricTargetUrl(intercept);
    Test.stopTest();

    System.assertEquals('0/view/iframe/1/2/True', result);
  }

  class MOC_getCardInfo implements ENSX.EnosixFramework.DetailSBOCommandMock {
    public ENSX.EnosixFramework.DetailObject executeCommand(
      string command, ENSX.EnosixFramework.DetailObject obj
      ) {
      System.assertEquals('CMD_ENCRYPT_CCARD', command);

      SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
      result.setSuccess(false);
      return result;
    }
  }

  @isTest
  static void test_getCardInfo() {
    SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
    ENSX.EnosixFramework.setMock(SBO_EnosixXiIntercept_Detail.class, new MOC_getCardInfo());

    Test.startTest();
    SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = UTIL_PaymentCards.getCardInfo(intercept);
    Test.stopTest();

    System.assertNotEquals(null, result);
  }

  class MOC_getAccessToken implements ENSX.EnosixFramework.DetailSBOCommandMock {
    public ENSX.EnosixFramework.DetailObject executeCommand(
      string command, ENSX.EnosixFramework.DetailObject obj
      ) {
      System.assertEquals('CMD_ACCESS_TOKEN', command);

      SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
      result.setSuccess(false);
      return result;
    }
  }

  @isTest
  static void test_getAccessToken() {
    SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
    ENSX.EnosixFramework.setMock(SBO_EnosixXiIntercept_Detail.class, new MOC_getAccessToken());

    Test.startTest();
    SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = UTIL_PaymentCards.getAccessToken(intercept);
    Test.stopTest();

    System.assertNotEquals(null, result);
  }

  class MOC_initEnosixXiIntercept implements ENSX.EnosixFramework.DetailSBOInitMock {
    public ENSX.EnosixFramework.DetailObject executeInitialize(
      ENSX.EnosixFramework.DetailObject obj
      ) {

      SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
      result.setSuccess(false);
      return result;
    }
  }

  @isTest
  static void test_initEnosixXiIntercept() {
    SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
    ENSX.EnosixFramework.setMock(SBO_EnosixXiIntercept_Detail.class, new MOC_initEnosixXiIntercept());

    Test.startTest();
    SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = UTIL_PaymentCards.initEnosixXiIntercept();
    Test.stopTest();

    System.assertNotEquals(null, result);
  }

}
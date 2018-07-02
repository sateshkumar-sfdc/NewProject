@isTest
public with sharing class TSTC_CreditCardEntry {

    @isTest
    static void test_getHostUrl() {

        Test.startTest();
        string result = CTRL_CreditCardEntry.getHostUrl();
        Test.stopTest();

        System.assert(string.isNotBlank(result));
    }

    @isTest
    static void test_constructorAndProperties() {
        Test.startTest();
        CTRL_CreditCardEntry controller = new CTRL_CreditCardEntry();
        controller.init();
        CB_CardDetailsReceiver cardDetailsReceiver = controller.cardDetailsReceiver;
        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept = controller.intercept;
        string parent = controller.parentRerender;
        string jssub = controller.jsSubmitMethodName ;
        string js = controller.jsInitMethodName;
        Test.stopTest();
    }
}
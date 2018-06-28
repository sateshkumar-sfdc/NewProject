/*
Author        :  Aneesh Reddy
Created Date  :  18th jan 2018
Name          :  UpcomingOrderController
Description   :  Test Class for UpcomingOrderController
*/
@isTest
public class UpcomingOrderControllerTest{
  static testmethod void UnitTest(){
    Test.startTest();
      UpcomingOrderController.getUpcomingOrders();
    Test.stopTest();
  }
}
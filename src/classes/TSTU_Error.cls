/*
* Test cases for the error utility class
*/
@isTest
public class TSTU_Error {
  class Result_displayResultErrors implements ENSX.EnosixFramework.Result {
    public boolean isSuccess_Called { get; set;}

    public boolean isSuccess() {
      this.isSuccess_Called = true;
      return false;
    }

    public boolean getMessages_Called { get; set;}

    public List<ENSX.EnosixFramework.Message> getMessages(){
      this.getMessages_Called = true;
      return new ENSX.EnosixFramework.Message[] {};
    }
  }

  /* test call to check success and call to read of error messages by framework */
  @isTest
  public static void test_displayResultErrors() {
    Result_displayResultErrors result = new Result_displayResultErrors();
    Test.startTest();
    UTIL_Error.displayResultErrors(result);
    Test.stopTest();
    System.assertEquals(true, result.isSuccess_Called);
    System.assertEquals(true, result.getMessages_Called);
  }

}
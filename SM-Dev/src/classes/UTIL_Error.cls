public class UTIL_Error {
  public static void displayResultErrors(ENSX.EnosixFramework.Result result) {
    if (null == result) return;

    if (!result.isSuccess()) {
        ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
    }
  }
}
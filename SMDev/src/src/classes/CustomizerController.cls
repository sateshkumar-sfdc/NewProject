public class CustomizerController {
  
   

   
    @AuraEnabled
    public static void  getCustomLineItems (String customizerJson) {
        
        //system.debug(customizerJson);
      String customizerJson1 = customizerJson.replace('\\','');
        string customjsaon2 = customizerJson1.replace('"{', '{');
        system.debug(customjsaon2);
        string customizerJson3 = customjsaon2.replace('}"','}');
        system.debug(customizerJson3);
     system.debug(customizerJson1);
        
          List<customizerdata> custwrapper =( List<customizerdata>)JSON.deserialize(customizerJson3, List<customizerdata>.class);
        
        system.debug(custwrapper);
        
        
        
        
    }
}
/*
######################################################################################################################
Name:       CommonServiceApiUtil.apxc 
Description: This Class is common service util class 
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     4/26/2018    1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/


public with sharing class CommonServiceApiUtil {
    
   public static final String POST = 'POST';
    public static final String GET='GET'; 
    
    
    
    /*
######################################################################################################################
Method Name:       sendApiRequest 
Description: common service method to make Api call 
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     4/26/2018    1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/
    public static String sendApiRequest(string EndPoint, string ReqBody, string ReqMethod )
        
    {
        
       
        try {
            
            Http httpProtocol = new Http();
            
            // Create HTTP request to send.
            HttpRequest request = new HttpRequest();
            
            // set end point
            request.setEndPoint(EndPoint);
            request.setHeader('Content-Type', 'application/json');
            
            // set request body
            if(ReqMethod != 'GET')
            request.setBody(ReqBody);
            
            // Set the HTTP verb
            request.setMethod(ReqMethod);
            request.setTimeout(60000);
            
            HttpResponse response = httpProtocol.send(request);
            if(response.getStatusCode() == 200){
                
               
           
            return response.getBody();
            }
            else{
                return response.getStatus();
            }
        }
        catch(Exception e){
             //Write a log in to IntegrationsLog Object for monitoring and support
            Intgeration_Log__c log = new Intgeration_Log__c();
               	log.Object_Name__c = 'CommonServiceApiUtil';
                log.ServiceName__c = 'checkAvailability';
                log.Time_Stamp__c = System.now();
                //log.RecordId__c = recordId;
                log.Target_System__c = 'SAP';
                log.Log__c = e.getMessage();
                insert log;
            return e.getMessage();
           }
            
            
        }
        
    }
//}
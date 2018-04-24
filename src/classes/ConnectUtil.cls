/*
* -----------------------------------------------------------
* Apex Class Name: ConnectUtil
* -----------------------------------------------------------
* Description: This class contains methods to peform operations
* assoicated with the Connect integration
* -----------------------------------------------------------
* Created by: Jeff Rogers, Alternative Technology Solutions.
* Created on: 2014-12-12
* Last Modified by: 
* Last Date Modified: 
* Modification Log:
* 1 - 
*/

public class ConnectUtil{
    
    //This methods validated street field format and length
    public static boolean validStreet(String street, Integer numOfLines, Integer lenLimit) {
    	
    	Boolean valid = true;
    	
    	if (street != '') {
    		
    		Integer line = 1;
    		List<String> streetSplit = new List<String>();
    		
    		//handle new lines from multiple OSes
    		if (street.contains('\r\n')) {
    			streetSplit = street.split('\r\n');
    		}
    		else if (street.contains('\n')) {
    			streetSplit = street.split('\n');
    		}
    		else if (street.contains('\r')) {
    			streetSplit = street.split('\r');
    		}
    		
    		//validate
    		for (String s : streetSplit) {
    			if (line > numOfLines) {
    				valid = false;
    				break;
    			}
    			if (s.length() > lenLimit) {
    				valid = false;
    				break;
    			}
    			line++;
    		}
    	}
    	
    	return valid;
    	
    }
    
}
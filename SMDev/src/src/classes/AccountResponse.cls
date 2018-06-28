/*
*************************************************************
** Name: AccountResponse.apxc                        	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose:                  							   **
** Account Response structure from Json                     **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 05/16/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/
//JSON response Structure
public class AccountResponse {
    /* public String BUSINESSPARTNER {get;set;} 
public String RETURN_Z {get;set;} // in json: RETURN */
    
    public String BUSINESSPARTNER {get;set;} 
    public RETURN_Z RETURN_Z {get;set;} // in json: RETURN
    public class RETURN_Z {
        public Item item {get;set;}
    }
    public class Item {
        public String TYPE_Z {get;set;} // in json: TYPE
        public String ID {get;set;} 
        public String NUMBER_Z {get;set;} // in json: NUMBER
        public String MESSAGE {get;set;} 
        public String LOG_NO {get;set;} 
        public String LOG_MSG_NO {get;set;} 
        public String MESSAGE_V1 {get;set;} 
        public String MESSAGE_V2 {get;set;} 
        public String MESSAGE_V3 {get;set;} 
        public String MESSAGE_V4 {get;set;} 
        public String PARAMETER {get;set;} 
        public Integer ROW {get;set;} 
        public String FIELD {get;set;} 
        public String SYSTEM_Z {get;set;} // in json: SYSTEM
        
    }
    
    
}
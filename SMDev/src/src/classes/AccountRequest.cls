/*
*************************************************************
** Name: AccountRequest.apxc                        	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose:                  							   **
** Account Request structure from Json                     **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 05/16/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/

//JSON Request Structure
public class AccountRequest {
    
   public ADDRESSDATA ADDRESSDATA;
	public class ADDRESSDATA {
		public String CITY;
		public String POSTL_COD1;
		public String STREET;
		public String COUNTRY;
		public String REGION;
		public String LANGU;
	}
	
	public CENTRALDATA CENTRALDATA;
	public class CENTRALDATA {
		public String SEARCHTERM1;
	}
	
	public CENTRALDATAORGANIZATION CENTRALDATAORGANIZATION;
	public class CENTRALDATAORGANIZATION {
		public String NAME1;
	}
	
	public COMPANY_DATA COMPANY_DATA;
	public class COMPANY_DATA {
		public String RECACCT;
		public String PAYTERM;
	}
	
	public COMPANY_KEY COMPANY_KEY;
	public class COMPANY_KEY {
		public String COMPANY;
	}
	
	public E_MAILDATA E_MAILDATA;
	public class E_MAILDATA {
		public Item_Z item;
	}
	public class Item_Z {
		public String E_MAIL;
	}
	
	public String PARTNERCATEGORY;
	
	public String PARTNERGROUP;
	
	public ROLES ROLES;
	public class ROLES {
		public Item_Y item;
	}
	public class Item_Y {
		public String PARTNERROLE;
		public String VALID_FROM;
		public String VALID_TO;
	}
	
	public SALES_DATA SALES_DATA;
	public class SALES_DATA {
		public String CUST_STAT_GRP;
		public String CUST_PRIC_PROC;
		public String DISTRICT;
		public String PRICE_GROUP;
		public String PLTYP;
		public String INCO1;
		public String INCO2;
		public String PART_DLV;
		public String SHP_COND;
		public String CURRENCY1;
		public String PAYT_TERMS;
		public String DELIVER_PLANT;
		public String SALES_GROUP;
		public String SALES_OFFICE;
		
	}
	
	public SALES_KEY SALES_KEY;
	public class SALES_KEY {
		public String SALESORG;
		public String DISTR_CHAN;
		public String DIVISION;
	}
	
	public TELEFONDATA TELEFONDATA;
	public class TELEFONDATA {
		public Item item;
	}
	public class Item {
		public String COUNTRY;
		public String TELEPHONE;
	}
}
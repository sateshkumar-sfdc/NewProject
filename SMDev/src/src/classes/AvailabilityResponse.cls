/*
     *Name: AvailabilityResponse.apxc.      
     *Description: This is the Object Structure of Response JSON   
     *Date : 04-26-2018
*/


public class AvailabilityResponse {
    

public class Item {
		public String COND_TYPE {get;set;} 
		public String COND_DESC {get;set;} 
		public Double COND_VALUE {get;set;} 
		public String CALC_TYPE {get;set;} 
		public Decimal CONDVALUE {get;set;} 
}
		
	
	public class PRICING {
		public List<Item> item {get;set;} 

		}
	
	public PRODUCT_LIST PRODUCT_LIST {get;set;} 
	public String RETURN_Z {get;set;} // in json: RETURN

	
	
	public class PRODUCT_LIST {
		public List<Item_Z> item {get;set;} 

	}
	public class Item_Z {
		public String ITM_NUMBER {get;set;} 
		public Integer PLANT {get;set;} 
		public String STGE_LOC {get;set;} 
		public string MATERIAL {get;set;} 
		public String SHORT_TEXT {get;set;} 
		public Decimal QTY_AVAILABLE {get;set;} 
		public PRICING PRICING {get;set;} 

		
	}
	


}
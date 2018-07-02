/*
     *Name: AvailabilityRequest.apxc.      
     *Description: This is the Object Structure Request JSON   
     *Date : 04-26-2018
*/

public class AvailabilityRequest {
    public String CUSTOMER;
	public String PRICE_DATE;
	public PRODUCTS PRODUCTS;
	public String SALES_GRP;
	public String SALES_OFF;
	public String SALES_ORG;
    public String DISTR_CHAN;
    public String DIVISION;

	public class PRODUCTS {
		public List<Item> item;

	}
     public class Item {	
		public String MATERIAL;
	}


	
	
}
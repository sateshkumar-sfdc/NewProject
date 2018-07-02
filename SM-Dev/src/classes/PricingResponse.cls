/*
     *Name: PricingResponse.apxc.      
     *Description: This is the Object Structure of ResponseJSON   
     *Date : 04-26-2018
*/

public class PricingResponse {
    
    public class Item {
		public String COND_TYPE;
		public String COND_DESC;
		public Double COND_VALUE;
		public String CALC_TYPE;
		public Decimal CONDVALUE;
	}

	public class PRICING {
		public List<Item> item;
	}

	public ORDER_PRICING ORDER_PRICING;

	public class ORDER_PRICING {
		public List<Item_Z> item;
	}

	public class Item_Z {
		public String ITM_NUMBER;
		public String HG_LV_ITEM;
		public Integer PLANT;
		public Integer STGE_LOC;
		public string MATERIAL;
		public String SHORT_TEXT;
		public Decimal REQ_QTY;
		public PRICING PRICING;
	}

	
}
/*
     *Name: PricingRequest.apxc.      
     *Description: This is the Object Structure of Request JSON   
     *Date : 04-26-2018
*/

public class PricingRequest {
    

	public class Item {
		public String ITM_NUMBER;
		public String MATERIAL;
		public Decimal PLANT;
		public String TARGET_QTY;
        public String HG_LV_ITEM;
	}

	public class ORDER_PARTNERS {
		public List<Item_Z> item;
	}

	public ORDER_HEADER_IN ORDER_HEADER_IN;
	public ORDER_ITEMS_IN ORDER_ITEMS_IN;
	public ORDER_PARTNERS ORDER_PARTNERS;

	public class ORDER_HEADER_IN {
		public String DOC_TYPE;
		public String SALES_ORG;
		public String DISTR_CHAN;
		public String DIVISION;
		public String SALES_GRP;
		public String SALES_OFF;
		public String REQ_DATE_H;
		public String PRICE_DATE;
	}
  
	public class ORDER_ITEMS_IN {
		public List<Item> item;
	}

	public class Item_Z {
		public String PARTN_ROLE;
		public String PARTN_NUMB;
	}

	
}
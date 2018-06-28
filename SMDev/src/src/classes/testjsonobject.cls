public class testjsonobject {


	public class ORDER_CCARD {
		public Item item;
	}

	public class Item {
		public String CC_TYPE;
		public String CC_NUMBER;
		public String CC_VALID_T;
		public String BILLAMOUNT;
		public String AUTHAMOUNT;
		public String CURRENCYz;
	}

	public class ORDER_PARTNERS {
		public List<Item_Y> item;
	}

	public ORDER_CCARD ORDER_CCARD;
	public ORDER_HEADER_IN ORDER_HEADER_IN;
	public ORDER_ITEMS_IN ORDER_ITEMS_IN;
	public ORDER_PARTNERS ORDER_PARTNERS;
	public PARTNERADDRESSES PARTNERADDRESSES;

	public class ORDER_HEADER_IN {
		public String DOC_TYPE;
		public String SALES_ORG;
		public String DISTR_CHAN;
		public String DIVISION;
		public String SALES_GRP;
		public String SALES_OFF;
		public String REQ_DATE_H;
		public String PRICE_DATE;
		public String PURCH_NO_C;
	}

	public class ORDER_ITEMS_IN {
		public List<Item_Z> item;
	}

	public class Item_Z {
		public String ITM_NUMBER;
		public String MATERIAL;
		public String PLANT;
		public String TARGET_QTY;
		public String TARGET_QU;
		public String HG_LV_ITEM;
	}

	public class PARTNERADDRESSES {
		public List<Item_X> item;
	}

	public class Item_Y {
		public String PARTN_ROLE;
		public String PARTN_NUMB;
		public String ADDR_LINK;
	}

	public class Item_X {
		public String ADDR_NO;
		public String NAME;
		public String CITY;
		public String POSTL_COD1;
		public String STREET;
		public String COUNTRY;
		public String REGION;
	}

	
	
}
public class OrderService {

	public class Item_W {
		public String PARTN_ROLE;
		public String PARTN_NUMB;
	}

	public class Item_V {
		public String ITM_NUMBER;
		public String TEXT_ID;
		public String TEXT_STRING;
	}

	public class Item_Z {
		public String ITM_NUMBER;
		public String MATERIAL;
		public String PLANT;
		public String TARGET_QTY;
		public String TARGET_QU;
		public String REASON_REJ;
		public String HG_LV_ITEM;
	}

	public class Item_Y {
		public String ITM_NUMBER;
		public String READY_FOR_PROD;
	}

	public class Item_X {
		public String ITM_NUMBER;
		public String COND_TYPE;
		public String COND_VALUE;
	}

	public class Item {
		public String CC_TYPE;
		public String CC_NUMBER;
		public String CC_VALID_T;
		public String BILLAMOUNT;
		public String AUTHAMOUNT;
		public String CURRENCYz;
	}


	public String SALESDOCUMENT;
	public ORDER_CCARD ORDER_CCARD;
	public class ORDER_CCARD {
		public Item item;
	}
	public ORDER_HEADER_IN ORDER_HEADER_IN;
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
	public ORDER_ITEMS_IN ORDER_ITEMS_IN;
	public class ORDER_ITEMS_IN {
		public List<Item_Z> item;
	}
	public ADD_ORDER_ITEMS_IN ADD_ORDER_ITEMS_IN;
	public class ADD_ORDER_ITEMS_IN {
		public List<Item_Y> item;
	}
	public ORDER_CONDITIONS_IN ORDER_CONDITIONS_IN;
	public class ORDER_CONDITIONS_IN {
		public List<Item_X> item;
	}
	public ORDER_PARTNERS ORDER_PARTNERS;
	public class ORDER_PARTNERS {
		public List<Item_W> item;
	}
	public ORDER_TEXT ORDER_TEXT;
	public class ORDER_TEXT {
		public List<Item_V> item;
	}

}
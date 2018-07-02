/*
     *Name: AccountSeedDataResponse.apxc.      
     *Description: This is the Object Structure of ResponseJSON for Account SEED Data from SAP  
     *Date : 05-17-2018
	 *Author : Sumanth Anumukonda
*/

public class AccountSeedDataResponse {

   

	public PV_ACC_SEQ_DATA PV_ACC_SEQ_DATA;
	public PV_FIELD_TO_ACC_SEQ PV_FIELD_TO_ACC_SEQ;
	public PV_KEY_VALUES PV_KEY_VALUES;

	public class PV_ACC_SEQ_DATA {
		public List<Item> item;
	}
    public class PV_FIELD_TO_ACC_SEQ {
		public List<Item_Z> item;
	}
    public class PV_KEY_VALUES {
            public List<Item_Y> item;
        }
     public class Item {
		public String ACC_SEQ_NAME;
		public String ACC_SEQ_DATA;
	}
	public class Item_Z {
		public String KEY_FIELDNAME;
		public String ACC_SEQ_NAME;
		public String ACC_SEQ_DESCR;
		public String ACC_SEQ_TABLE;
		public String ACC_SEQ_FIELDS;
	}
	public class Item_Y {
        @AuraEnabled public String FIELDNAME {get;set;}
            @AuraEnabled public String FIELDVALUE {get;set;}
                @AuraEnabled public String FIELDDESCR {get;set;}
	}

	

}
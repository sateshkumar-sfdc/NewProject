/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_RETURN_CUSTINSPEC extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_RETURN_CUSTINSPEC() {
		super('/ENSX/SD_GET_RETURN_CUSTINSPEC', RFC_SD_GET_RETURN_CUSTINSPEC.RESULT.class);
	}

	public override Type getType() { return RFC_SD_GET_RETURN_CUSTINSPEC.class; }

    public RESULT Params {
		get { return (RESULT)this.getParameterContext(); }
	}

	public RESULT execute() {
		return (RESULT)this.executeFunction();
	}
    
    public class RESULT extends ENSX.EnosixFramework.FunctionObject {
    	
    	public RESULT() {
			super(new Map<string,type>
			{
				'ET_CUST_INSPECTION' => RFC_SD_GET_RETURN_CUSTINSPEC.ET_CUST_INSPECTION.class,
'ET_ORDER_REASON' => RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON.class,
'ET_REFUND_TYPE' => RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE.class,
'ET_RETURN_REASON' => RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON.class
			});	
    	}
		
		public override Type getType() { return RFC_SD_GET_RETURN_CUSTINSPEC.RESULT.class; }

		public List<ET_CUST_INSPECTION> ET_CUST_INSPECTION_List
	{
		get 
		{
			List<ET_CUST_INSPECTION> results = new List<ET_CUST_INSPECTION>();
			this.getCollection(RFC_SD_GET_RETURN_CUSTINSPEC.ET_CUST_INSPECTION.class).copyTo(results);
			return results;
		}
	}
		public List<ET_ORDER_REASON> ET_ORDER_REASON_List
	{
		get 
		{
			List<ET_ORDER_REASON> results = new List<ET_ORDER_REASON>();
			this.getCollection(RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON.class).copyTo(results);
			return results;
		}
	}
		public List<ET_REFUND_TYPE> ET_REFUND_TYPE_List
	{
		get 
		{
			List<ET_REFUND_TYPE> results = new List<ET_REFUND_TYPE>();
			this.getCollection(RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE.class).copyTo(results);
			return results;
		}
	}
		public List<ET_RETURN_REASON> ET_RETURN_REASON_List
	{
		get 
		{
			List<ET_RETURN_REASON> results = new List<ET_RETURN_REASON>();
			this.getCollection(RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON.class).copyTo(results);
			return results;
		}
	}
	    	
    }
    	public class ET_CUST_INSPECTION extends ENSX.EnosixFramework.ValueObject{

		public ET_CUST_INSPECTION() {
			super('ET_CUST_INSPECTION', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_RETURN_CUSTINSPEC.ET_CUST_INSPECTION.class; }
			
					public String CODE
		{ 
			get { return this.getString ('CODE'); } 
			set { this.Set (value, 'CODE'); }
		}

		public String CODE_TEXT
		{ 
			get { return this.getString ('CODE_TEXT'); } 
			set { this.Set (value, 'CODE_TEXT'); }
		}

			
		}
		public class ET_ORDER_REASON extends ENSX.EnosixFramework.ValueObject{

		public ET_ORDER_REASON() {
			super('ET_ORDER_REASON', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON.class; }
			
					public String AUGRU
		{ 
			get { return this.getString ('AUGRU'); } 
			set { this.Set (value, 'AUGRU'); }
		}

		public String BEZEI
		{ 
			get { return this.getString ('BEZEI'); } 
			set { this.Set (value, 'BEZEI'); }
		}

			
		}
		public class ET_REFUND_TYPE extends ENSX.EnosixFramework.ValueObject{

		public ET_REFUND_TYPE() {
			super('ET_REFUND_TYPE', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE.class; }
			
					public String REFUND_TYPE
		{ 
			get { return this.getString ('REFUND_TYPE'); } 
			set { this.Set (value, 'REFUND_TYPE'); }
		}

		public String REFUND_TYPE_TEXT
		{ 
			get { return this.getString ('REFUND_TYPE_TEXT'); } 
			set { this.Set (value, 'REFUND_TYPE_TEXT'); }
		}

			
		}
		public class ET_RETURN_REASON extends ENSX.EnosixFramework.ValueObject{

		public ET_RETURN_REASON() {
			super('ET_RETURN_REASON', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON.class; }
			
					public String RET_REASON
		{ 
			get { return this.getString ('RET_REASON'); } 
			set { this.Set (value, 'RET_REASON'); }
		}

		public String BEZEI
		{ 
			get { return this.getString ('BEZEI'); } 
			set { this.Set (value, 'BEZEI'); }
		}

			
		}
	}
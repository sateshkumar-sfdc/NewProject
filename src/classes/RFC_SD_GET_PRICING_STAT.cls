/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_PRICING_STAT extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_PRICING_STAT() {
		super('/ENSX/SD_GET_PRICING_STAT', RFC_SD_GET_PRICING_STAT.RESULT.class);
	}

	public override Type getType() { return RFC_SD_GET_PRICING_STAT.class; }

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
				'ET_CUST_PRICE_GRP' => RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP.class,
'ET_CUST_PRICE_LIST' => RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST.class,
'ET_CUST_PRICE_PROC' => RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC.class,
'ET_CUST_STAT_GROUP' => RFC_SD_GET_PRICING_STAT.ET_CUST_STAT_GROUP.class
			});	
    	}
		
		public override Type getType() { return RFC_SD_GET_PRICING_STAT.RESULT.class; }

		public List<ET_CUST_PRICE_GRP> ET_CUST_PRICE_GRP_List
	{
		get 
		{
			List<ET_CUST_PRICE_GRP> results = new List<ET_CUST_PRICE_GRP>();
			this.getCollection(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP.class).copyTo(results);
			return results;
		}
	}
		public List<ET_CUST_PRICE_LIST> ET_CUST_PRICE_LIST_List
	{
		get 
		{
			List<ET_CUST_PRICE_LIST> results = new List<ET_CUST_PRICE_LIST>();
			this.getCollection(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST.class).copyTo(results);
			return results;
		}
	}
		public List<ET_CUST_PRICE_PROC> ET_CUST_PRICE_PROC_List
	{
		get 
		{
			List<ET_CUST_PRICE_PROC> results = new List<ET_CUST_PRICE_PROC>();
			this.getCollection(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC.class).copyTo(results);
			return results;
		}
	}
		public List<ET_CUST_STAT_GROUP> ET_CUST_STAT_GROUP_List
	{
		get 
		{
			List<ET_CUST_STAT_GROUP> results = new List<ET_CUST_STAT_GROUP>();
			this.getCollection(RFC_SD_GET_PRICING_STAT.ET_CUST_STAT_GROUP.class).copyTo(results);
			return results;
		}
	}
	    	
    }
    	public class ET_CUST_PRICE_GRP extends ENSX.EnosixFramework.ValueObject{

		public ET_CUST_PRICE_GRP() {
			super('ET_CUST_PRICE_GRP', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP.class; }
			
					public String KONDA
		{ 
			get { return this.getString ('KONDA'); } 
			set { this.Set (value, 'KONDA'); }
		}

		public String VTEXT
		{ 
			get { return this.getString ('VTEXT'); } 
			set { this.Set (value, 'VTEXT'); }
		}

			
		}
		public class ET_CUST_PRICE_LIST extends ENSX.EnosixFramework.ValueObject{

		public ET_CUST_PRICE_LIST() {
			super('ET_CUST_PRICE_LIST', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST.class; }
			
					public String PLTYP
		{ 
			get { return this.getString ('PLTYP'); } 
			set { this.Set (value, 'PLTYP'); }
		}

		public String PTEXT
		{ 
			get { return this.getString ('PTEXT'); } 
			set { this.Set (value, 'PTEXT'); }
		}

			
		}
		public class ET_CUST_PRICE_PROC extends ENSX.EnosixFramework.ValueObject{

		public ET_CUST_PRICE_PROC() {
			super('ET_CUST_PRICE_PROC', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC.class; }
			
					public String KALKS
		{ 
			get { return this.getString ('KALKS'); } 
			set { this.Set (value, 'KALKS'); }
		}

		public String VTEXT
		{ 
			get { return this.getString ('VTEXT'); } 
			set { this.Set (value, 'VTEXT'); }
		}

			
		}
		public class ET_CUST_STAT_GROUP extends ENSX.EnosixFramework.ValueObject{

		public ET_CUST_STAT_GROUP() {
			super('ET_CUST_STAT_GROUP', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_PRICING_STAT.ET_CUST_STAT_GROUP.class; }
			
					public String STGKU
		{ 
			get { return this.getString ('STGKU'); } 
			set { this.Set (value, 'STGKU'); }
		}

		public String BEZEI20
		{ 
			get { return this.getString ('BEZEI20'); } 
			set { this.Set (value, 'BEZEI20'); }
		}

			
		}
	}
/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_SHIP_INFO extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_SHIP_INFO() {
		super('/ENSX/SD_GET_SHIP_INFO', RFC_SD_GET_SHIP_INFO.RESULT.class);
	}

	public override Type getType() { return RFC_SD_GET_SHIP_INFO.class; }

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
				'ET_FREIGHT_TERMS' => RFC_SD_GET_SHIP_INFO.ET_FREIGHT_TERMS.class,
'ET_PAY_TERMS' => RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS.class,
'ET_SHIP_COND' => RFC_SD_GET_SHIP_INFO.ET_SHIP_COND.class
			});	
    	}
		
		public override Type getType() { return RFC_SD_GET_SHIP_INFO.RESULT.class; }

		public List<ET_FREIGHT_TERMS> ET_FREIGHT_TERMS_List
	{
		get 
		{
			List<ET_FREIGHT_TERMS> results = new List<ET_FREIGHT_TERMS>();
			this.getCollection(RFC_SD_GET_SHIP_INFO.ET_FREIGHT_TERMS.class).copyTo(results);
			return results;
		}
	}
		public List<ET_PAY_TERMS> ET_PAY_TERMS_List
	{
		get 
		{
			List<ET_PAY_TERMS> results = new List<ET_PAY_TERMS>();
			this.getCollection(RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS.class).copyTo(results);
			return results;
		}
	}
		public List<ET_SHIP_COND> ET_SHIP_COND_List
	{
		get 
		{
			List<ET_SHIP_COND> results = new List<ET_SHIP_COND>();
			this.getCollection(RFC_SD_GET_SHIP_INFO.ET_SHIP_COND.class).copyTo(results);
			return results;
		}
	}
	    	
    }
    	public class ET_FREIGHT_TERMS extends ENSX.EnosixFramework.ValueObject{

		public ET_FREIGHT_TERMS() {
			super('ET_FREIGHT_TERMS', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_SHIP_INFO.ET_FREIGHT_TERMS.class; }
			
					public String INCO1
		{ 
			get { return this.getString ('INCO1'); } 
			set { this.Set (value, 'INCO1'); }
		}

		public String BEZEI
		{ 
			get { return this.getString ('BEZEI'); } 
			set { this.Set (value, 'BEZEI'); }
		}

			
		}
		public class ET_PAY_TERMS extends ENSX.EnosixFramework.ValueObject{

		public ET_PAY_TERMS() {
			super('ET_PAY_TERMS', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS.class; }
			
					public String ZTERM
		{ 
			get { return this.getString ('ZTERM'); } 
			set { this.Set (value, 'ZTERM'); }
		}

		public String VTEXT
		{ 
			get { return this.getString ('VTEXT'); } 
			set { this.Set (value, 'VTEXT'); }
		}

			
		}
		public class ET_SHIP_COND extends ENSX.EnosixFramework.ValueObject{

		public ET_SHIP_COND() {
			super('ET_SHIP_COND', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_SHIP_INFO.ET_SHIP_COND.class; }
			
					public String VSBED
		{ 
			get { return this.getString ('VSBED'); } 
			set { this.Set (value, 'VSBED'); }
		}

		public String VTEXT
		{ 
			get { return this.getString ('VTEXT'); } 
			set { this.Set (value, 'VTEXT'); }
		}

			
		}
	}
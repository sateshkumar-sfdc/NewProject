/// enosiX Inc. Generated Apex Model
/// Generated On: 4/28/17 1:45:59 PM
/// SAP Host: yeti-sfdc-api.enosix.com
/// CID: S4H

public with sharing class RFC_SD_GET_CUST_ATTRIB_VALUE extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_CUST_ATTRIB_VALUE() {
		super('/ENSX/SD_GET_CUST_ATTRIB_VALUE', RFC_SD_GET_CUST_ATTRIB_VALUE.RESULT.class);
	}

	public override Type getType() { return RFC_SD_GET_CUST_ATTRIB_VALUE.class; }

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
				'ET_ATTRIB1' => RFC_SD_GET_CUST_ATTRIB_VALUE.ET_ATTRIB1.class
			});	
    	}
		
		public override Type getType() { return RFC_SD_GET_CUST_ATTRIB_VALUE.RESULT.class; }

		public List<ET_ATTRIB1> ET_ATTRIB1_List
	{
		get 
		{
			List<ET_ATTRIB1> results = new List<ET_ATTRIB1>();
			this.getCollection(RFC_SD_GET_CUST_ATTRIB_VALUE.ET_ATTRIB1.class).copyTo(results);
			return results;
		}
	}
			public String IV_CID
		{ 
			get { return this.getString ('IV_CID'); } 
			set { this.Set (value, 'IV_CID'); }
		}

    	
    }
    	public class ET_ATTRIB1 extends ENSX.EnosixFramework.ValueObject{

		public ET_ATTRIB1() {
			super('ET_ATTRIB1', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_CUST_ATTRIB_VALUE.ET_ATTRIB1.class; }
			
					public String KATR1
		{ 
			get { return this.getString ('KATR1'); } 
			set { this.Set (value, 'KATR1'); }
		}

		public String VTEXT
		{ 
			get { return this.getString ('VTEXT'); } 
			set { this.Set (value, 'VTEXT'); }
		}

			
		}
	}
/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_DOC_CATEG_VALUES extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_DOC_CATEG_VALUES() {
		super('/ENSX/SD_GET_DOC_CATEG_VALUES', RFC_SD_GET_DOC_CATEG_VALUES.RESULT.class);
	}

	public override Type getType() { return RFC_SD_GET_DOC_CATEG_VALUES.class; }

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
				'ET_VALUES' => RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES.class
			});	
    	}
		
		public override Type getType() { return RFC_SD_GET_DOC_CATEG_VALUES.RESULT.class; }

		public List<ET_VALUES> ET_VALUES_List
	{
		get 
		{
			List<ET_VALUES> results = new List<ET_VALUES>();
			this.getCollection(RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES.class).copyTo(results);
			return results;
		}
	}
			public String IV_DOMAIN_NAME
		{ 
			get { return this.getString ('IV_DOMAIN_NAME'); } 
			set { this.Set (value, 'IV_DOMAIN_NAME'); }
		}

    	
    }
    	public class ET_VALUES extends ENSX.EnosixFramework.ValueObject{

		public ET_VALUES() {
			super('ET_VALUES', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES.class; }
			
					public String VBTYP
		{ 
			get { return this.getString ('VBTYP'); } 
			set { this.Set (value, 'VBTYP'); }
		}

		public String VBTYP_TEXT
		{ 
			get { return this.getString ('VBTYP_TEXT'); } 
			set { this.Set (value, 'VBTYP_TEXT'); }
		}

			
		}
	}
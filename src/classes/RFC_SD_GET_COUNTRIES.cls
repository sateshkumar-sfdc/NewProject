/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_COUNTRIES extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_COUNTRIES() {
		super('/ENSX/SD_GET_COUNTRIES', RFC_SD_GET_COUNTRIES.RESULT.class);
	}

	public override Type getType() { return RFC_SD_GET_COUNTRIES.class; }

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
				'ET_OUTPUT' => RFC_SD_GET_COUNTRIES.ET_OUTPUT.class,
'ET_REGIONS' => RFC_SD_GET_COUNTRIES.ET_REGIONS.class
			});	
    	}
		
		public override Type getType() { return RFC_SD_GET_COUNTRIES.RESULT.class; }

		public List<ET_OUTPUT> ET_OUTPUT_List
	{
		get 
		{
			List<ET_OUTPUT> results = new List<ET_OUTPUT>();
			this.getCollection(RFC_SD_GET_COUNTRIES.ET_OUTPUT.class).copyTo(results);
			return results;
		}
	}
		public List<ET_REGIONS> ET_REGIONS_List
	{
		get 
		{
			List<ET_REGIONS> results = new List<ET_REGIONS>();
			this.getCollection(RFC_SD_GET_COUNTRIES.ET_REGIONS.class).copyTo(results);
			return results;
		}
	}
	    	
    }
    	public class ET_OUTPUT extends ENSX.EnosixFramework.ValueObject{

		public ET_OUTPUT() {
			super('ET_OUTPUT', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_COUNTRIES.ET_OUTPUT.class; }
			
					public String MANDT
		{ 
			get { return this.getString ('MANDT'); } 
			set { this.Set (value, 'MANDT'); }
		}

		public String SPRAS
		{ 
			get { return this.getString ('SPRAS'); } 
			set { this.Set (value, 'SPRAS'); }
		}

		public String LAND1
		{ 
			get { return this.getString ('LAND1'); } 
			set { this.Set (value, 'LAND1'); }
		}

		public String LANDX
		{ 
			get { return this.getString ('LANDX'); } 
			set { this.Set (value, 'LANDX'); }
		}

		public String NATIO
		{ 
			get { return this.getString ('NATIO'); } 
			set { this.Set (value, 'NATIO'); }
		}

		public String LANDX50
		{ 
			get { return this.getString ('LANDX50'); } 
			set { this.Set (value, 'LANDX50'); }
		}

		public String NATIO50
		{ 
			get { return this.getString ('NATIO50'); } 
			set { this.Set (value, 'NATIO50'); }
		}

		public String PRQ_SPREGT
		{ 
			get { return this.getString ('PRQ_SPREGT'); } 
			set { this.Set (value, 'PRQ_SPREGT'); }
		}

			
		}
		public class ET_REGIONS extends ENSX.EnosixFramework.ValueObject{

		public ET_REGIONS() {
			super('ET_REGIONS', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_COUNTRIES.ET_REGIONS.class; }
			
					public String LAND1
		{ 
			get { return this.getString ('LAND1'); } 
			set { this.Set (value, 'LAND1'); }
		}

		public String REGIO
		{ 
			get { return this.getString ('REGIO'); } 
			set { this.Set (value, 'REGIO'); }
		}

		public String BEZEI
		{ 
			get { return this.getString ('BEZEI'); } 
			set { this.Set (value, 'BEZEI'); }
		}

			
		}
	}
/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_GROUP_OFFICE extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_GROUP_OFFICE() {
		super('/ENSX/SD_GET_GROUP_OFFICE', RFC_SD_GET_GROUP_OFFICE.RESULT.class);
	}

	public override Type getType() { return RFC_SD_GET_GROUP_OFFICE.class; }

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
				'ET_SALES_DISTRICT' => RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT.class,
'ET_SALES_GROUP' => RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP.class,
'ET_SALES_OFFICE' => RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE.class
			});	
    	}
		
		public override Type getType() { return RFC_SD_GET_GROUP_OFFICE.RESULT.class; }

		public List<ET_SALES_DISTRICT> ET_SALES_DISTRICT_List
	{
		get 
		{
			List<ET_SALES_DISTRICT> results = new List<ET_SALES_DISTRICT>();
			this.getCollection(RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT.class).copyTo(results);
			return results;
		}
	}
		public List<ET_SALES_GROUP> ET_SALES_GROUP_List
	{
		get 
		{
			List<ET_SALES_GROUP> results = new List<ET_SALES_GROUP>();
			this.getCollection(RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP.class).copyTo(results);
			return results;
		}
	}
		public List<ET_SALES_OFFICE> ET_SALES_OFFICE_List
	{
		get 
		{
			List<ET_SALES_OFFICE> results = new List<ET_SALES_OFFICE>();
			this.getCollection(RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE.class).copyTo(results);
			return results;
		}
	}
	    	
    }
    	public class ET_SALES_DISTRICT extends ENSX.EnosixFramework.ValueObject{

		public ET_SALES_DISTRICT() {
			super('ET_SALES_DISTRICT', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT.class; }
			
					public String BZIRK
		{ 
			get { return this.getString ('BZIRK'); } 
			set { this.Set (value, 'BZIRK'); }
		}

		public String BZTXT
		{ 
			get { return this.getString ('BZTXT'); } 
			set { this.Set (value, 'BZTXT'); }
		}

			
		}
		public class ET_SALES_GROUP extends ENSX.EnosixFramework.ValueObject{

		public ET_SALES_GROUP() {
			super('ET_SALES_GROUP', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP.class; }
			
					public String VKBUR
		{ 
			get { return this.getString ('VKBUR'); } 
			set { this.Set (value, 'VKBUR'); }
		}

		public String VKGRP
		{ 
			get { return this.getString ('VKGRP'); } 
			set { this.Set (value, 'VKGRP'); }
		}

		public String BEZEI
		{ 
			get { return this.getString ('BEZEI'); } 
			set { this.Set (value, 'BEZEI'); }
		}

			
		}
		public class ET_SALES_OFFICE extends ENSX.EnosixFramework.ValueObject{

		public ET_SALES_OFFICE() {
			super('ET_SALES_OFFICE', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE.class; }
			
					public String VKORG
		{ 
			get { return this.getString ('VKORG'); } 
			set { this.Set (value, 'VKORG'); }
		}

		public String VTWEG
		{ 
			get { return this.getString ('VTWEG'); } 
			set { this.Set (value, 'VTWEG'); }
		}

		public String SPART
		{ 
			get { return this.getString ('SPART'); } 
			set { this.Set (value, 'SPART'); }
		}

		public String VKBUR
		{ 
			get { return this.getString ('VKBUR'); } 
			set { this.Set (value, 'VKBUR'); }
		}

		public String BEZEI
		{ 
			get { return this.getString ('BEZEI'); } 
			set { this.Set (value, 'BEZEI'); }
		}

			
		}
	}
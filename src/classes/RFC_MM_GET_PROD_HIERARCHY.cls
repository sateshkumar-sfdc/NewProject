/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_MM_GET_PROD_HIERARCHY extends ENSX.EnosixFramework.RFC {
	public RFC_MM_GET_PROD_HIERARCHY() {
		super('/ENSX/MM_GET_PROD_HIERARCHY', RFC_MM_GET_PROD_HIERARCHY.RESULT.class);
	}

	public override Type getType() { return RFC_MM_GET_PROD_HIERARCHY.class; }

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
				'ET_MATERIAL_TYPE' => RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class,
'ET_PRODUCT_ATTRIB' => RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class,
'ET_PROD_HIERARCHY' => RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class
			});	
    	}
		
		public override Type getType() { return RFC_MM_GET_PROD_HIERARCHY.RESULT.class; }

		public List<ET_MATERIAL_TYPE> ET_MATERIAL_TYPE_List
	{
		get 
		{
			List<ET_MATERIAL_TYPE> results = new List<ET_MATERIAL_TYPE>();
			this.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class).copyTo(results);
			return results;
		}
	}
		public List<ET_PRODUCT_ATTRIB> ET_PRODUCT_ATTRIB_List
	{
		get 
		{
			List<ET_PRODUCT_ATTRIB> results = new List<ET_PRODUCT_ATTRIB>();
			this.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class).copyTo(results);
			return results;
		}
	}
		public List<ET_PROD_HIERARCHY> ET_PROD_HIERARCHY_List
	{
		get 
		{
			List<ET_PROD_HIERARCHY> results = new List<ET_PROD_HIERARCHY>();
			this.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class).copyTo(results);
			return results;
		}
	}
			public String IV_LEVEL_NUMBER
		{ 
			get { return this.getString ('IV_LEVEL_NUMBER'); } 
			set { this.Set (value, 'IV_LEVEL_NUMBER'); }
		}

    	
    }
    	public class ET_MATERIAL_TYPE extends ENSX.EnosixFramework.ValueObject{

		public ET_MATERIAL_TYPE() {
			super('ET_MATERIAL_TYPE', new Map<string,type>());
		}

		public override Type getType() { return RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class; }
			
					public String MTART
		{ 
			get { return this.getString ('MTART'); } 
			set { this.Set (value, 'MTART'); }
		}

		public String MTBEZ
		{ 
			get { return this.getString ('MTBEZ'); } 
			set { this.Set (value, 'MTBEZ'); }
		}

			
		}
		public class ET_PRODUCT_ATTRIB extends ENSX.EnosixFramework.ValueObject{

		public ET_PRODUCT_ATTRIB() {
			super('ET_PRODUCT_ATTRIB', new Map<string,type>());
		}

		public override Type getType() { return RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class; }
			
					public String PRODUCT_ATTRIB
		{ 
			get { return this.getString ('PRODUCT_ATTRIB'); } 
			set { this.Set (value, 'PRODUCT_ATTRIB'); }
		}

			
		}
		public class ET_PROD_HIERARCHY extends ENSX.EnosixFramework.ValueObject{

		public ET_PROD_HIERARCHY() {
			super('ET_PROD_HIERARCHY', new Map<string,type>());
		}

		public override Type getType() { return RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class; }
			
					public String PRODH
		{ 
			get { return this.getString ('PRODH'); } 
			set { this.Set (value, 'PRODH'); }
		}

		public String STUFE
		{ 
			get { return this.getString ('STUFE'); } 
			set { this.Set (value, 'STUFE'); }
		}

		public String VTEXT
		{ 
			get { return this.getString ('VTEXT'); } 
			set { this.Set (value, 'VTEXT'); }
		}

			
		}
	}
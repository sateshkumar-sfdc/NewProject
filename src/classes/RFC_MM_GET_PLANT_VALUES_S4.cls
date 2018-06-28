/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_MM_GET_PLANT_VALUES_S4 extends ENSX.EnosixFramework.RFC {
	public RFC_MM_GET_PLANT_VALUES_S4() {
		super('/ENSX/MM_GET_PLANT_VALUES_S4', RFC_MM_GET_PLANT_VALUES_S4.RESULT.class);
	}

	public override Type getType() { return RFC_MM_GET_PLANT_VALUES_S4.class; }

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
				'ET_OUTPUT' => RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT.class
			});	
    	}
		
		public override Type getType() { return RFC_MM_GET_PLANT_VALUES_S4.RESULT.class; }

		public List<ET_OUTPUT> ET_OUTPUT_List
	{
		get 
		{
			List<ET_OUTPUT> results = new List<ET_OUTPUT>();
			this.getCollection(RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT.class).copyTo(results);
			return results;
		}
	}
	    	
    }
    	public class ET_OUTPUT extends ENSX.EnosixFramework.ValueObject{

		public ET_OUTPUT() {
			super('ET_OUTPUT', new Map<string,type>());
		}

		public override Type getType() { return RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT.class; }
			
					public String WERKS
		{ 
			get { return this.getString ('WERKS'); } 
			set { this.Set (value, 'WERKS'); }
		}

		public String WERKS_NAME
		{ 
			get { return this.getString ('WERKS_NAME'); } 
			set { this.Set (value, 'WERKS_NAME'); }
		}

			
		}
	}
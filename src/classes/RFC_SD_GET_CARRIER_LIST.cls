/// enosiX Inc. Generated Apex Model
/// Generated On: 11/23/2016 9:54:50 AM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_CARRIER_LIST extends ENSX.EnosixFramework.RFC {
    public RFC_SD_GET_CARRIER_LIST() {
        super('/ENSX/SD_GET_CARRIER_LIST', RFC_SD_GET_CARRIER_LIST.RESULT.class);
    }

    public override Type getType() { return RFC_SD_GET_CARRIER_LIST.class; }

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
                'ET_OUTPUT' => RFC_SD_GET_CARRIER_LIST.ET_OUTPUT.class
            }); 
        }
        
        public override Type getType() { return RFC_SD_GET_CARRIER_LIST.RESULT.class; }

        public List<ET_OUTPUT> ET_OUTPUT_List
    {
        get 
        {
            List<ET_OUTPUT> results = new List<ET_OUTPUT>();
            this.getCollection(RFC_SD_GET_CARRIER_LIST.ET_OUTPUT.class).copyTo(results);
            return results;
        }
    }
    
    public String IV_SALESORG
    {
      get { return this.getString ('IV_SALESORG'); }
      set { this.Set (value, 'IV_SALESORG'); }
    }

            
    }
        public class ET_OUTPUT extends ENSX.EnosixFramework.ValueObject{

        public ET_OUTPUT() {
            super('ET_OUTPUT', new Map<string,type>());
        }

        public override Type getType() { return RFC_SD_GET_CARRIER_LIST.ET_OUTPUT.class; }
            
                    public String CARRIER
        { 
            get { return this.getString ('CARRIER'); } 
            set { this.Set (value, 'CARRIER'); }
        }

        public String CARRIER_NAME
        { 
            get { return this.getString ('CARRIER_NAME'); } 
            set { this.Set (value, 'CARRIER_NAME'); }
        }

            
        }
    }
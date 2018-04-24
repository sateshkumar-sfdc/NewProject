/// enosiX Inc. Generated Apex Model
/// Generated On: 1/11/2017 1:46:08 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_CONDITION_GROUP extends ENSX.EnosixFramework.RFC {
    public RFC_SD_GET_CONDITION_GROUP() {
        super('/ENSX/SD_GET_CONDITION_GROUP', RFC_SD_GET_CONDITION_GROUP.RESULT.class);
    }

    public override Type getType() { return RFC_SD_GET_CONDITION_GROUP.class; }

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
                    'ET_COND_GROUP' => RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP.class
            });
        }

        public override Type getType() { return RFC_SD_GET_CONDITION_GROUP.RESULT.class; }

        public List<ET_COND_GROUP> ET_COND_GROUP_List
        {
            get
            {
                List<ET_COND_GROUP> results = new List<ET_COND_GROUP>();
                this.getCollection(RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP.class).copyTo(results);
                return results;
            }
        }

    }
    public class ET_COND_GROUP extends ENSX.EnosixFramework.ValueObject{

        public ET_COND_GROUP() {
            super('ET_COND_GROUP', new Map<string,type>());
        }

        public override Type getType() { return RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP.class; }

        public String KDKGR
        {
            get { return this.getString ('KDKGR'); }
            set { this.Set (value, 'KDKGR'); }
        }

        public String VTEXT
        {
            get { return this.getString ('VTEXT'); }
            set { this.Set (value, 'VTEXT'); }
        }


    }
}
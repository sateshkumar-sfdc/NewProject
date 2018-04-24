public with sharing class RFC_SD_GET_DOC_TYPE_VALUES extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_DOC_TYPE_VALUES() {
		super('/ENSX/SD_GET_DOC_TYPE_VALUES', RFC_SD_GET_DOC_TYPE_VALUES.RESULT.class);
	}

    public override Type getType() { return RFC_SD_GET_DOC_TYPE_VALUES.class; }

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
				'ET_OUTPUT' => RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class
			});
    	}

        public override Type getType() { return RFC_SD_GET_DOC_TYPE_VALUES.RESULT.class; }

		public List<ET_OUTPUT> ET_OUTPUT_List
	{
		get
		{
			List<ET_OUTPUT> results = new List<ET_OUTPUT>();
			this.getCollection(RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class).copyTo(results);
			return results;
		}
	}

    }
    	public class ET_OUTPUT extends ENSX.EnosixFramework.ValueObject{

		public ET_OUTPUT() {
			super('ET_OUTPUT', new Map<string,type>());
		}

        public override Type getType() { return RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class; }

		public String AUART
		{
			get { return this.getString ('AUART'); }
			set { this.Set (value, 'AUART'); }
		}

		public String BEZEI
		{
			get { return this.getString ('BEZEI'); }
			set { this.Set (value, 'BEZEI'); }
		}

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

		public String INCPO
		{
			get { return this.getString ('INCPO'); }
			set { this.Set (value, 'INCPO'); }
		}

		public String X_PONUM_REQUIRED
		{
			get { return this.getString ('X_PONUM_REQUIRED'); }
			set { this.Set (value, 'X_PONUM_REQUIRED'); }
		}


		}
	}
public class RFC_SD_GET_BP_ROLE_TYPE extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_BP_ROLE_TYPE() {
		super('/ENSX/SD_GET_BP_ROLE_TYPE', RFC_SD_GET_BP_ROLE_TYPE.RESULT.class);
	}

    public override Type getType() { return RFC_SD_GET_BP_ROLE_TYPE.class; }

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
				'ET_BP_CATEGORY' => RFC_SD_GET_BP_ROLE_TYPE.ET_BP_CATEGORY.class,
				'ET_BP_ROLE' => RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE.class,
				'ET_BP_ROLE_GROUP' => RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP.class,
				'ET_BP_TYPE' => RFC_SD_GET_BP_ROLE_TYPE.ET_BP_TYPE.class
			});
    	}

        public override Type getType() { return RFC_SD_GET_BP_ROLE_TYPE.RESULT.class; }

        public List<ET_BP_CATEGORY> Categories
        {
            get
            {
                List<ET_BP_CATEGORY> results = new List<ET_BP_CATEGORY>();
                this.getCollection(RFC_SD_GET_BP_ROLE_TYPE.ET_BP_CATEGORY.class).copyTo(results);
                return results;
            }
        }

        public List<ET_BP_ROLE> Roles
        {
            get
            {
                List<ET_BP_ROLE> results = new List<ET_BP_ROLE>();
                this.getCollection(RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE.class).copyTo(results);
                return results;
            }
        }

        public List<ET_BP_ROLE_GROUP> ET_BP_ROLE_GROUP_List
		{
			get
			{
				List<ET_BP_ROLE_GROUP> results = new List<ET_BP_ROLE_GROUP>();
				this.getCollection(RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP.class).copyTo(results);
				return results;
			}
		}

        public List<ET_BP_TYPE> Types
        {
            get
            {
                List<ET_BP_TYPE> results = new List<ET_BP_TYPE>();
                this.getCollection(RFC_SD_GET_BP_ROLE_TYPE.ET_BP_TYPE.class).copyTo(results);
                return results;
            }
        }

    }

    public class ET_BP_CATEGORY extends ENSX.EnosixFramework.ValueObject {

		public ET_BP_CATEGORY() {
			super('ET_BP_CATEGORY', new Map<string,type>());
		}

        public override Type getType() { return RFC_SD_GET_BP_ROLE_TYPE.ET_BP_CATEGORY.class; }

		public String Category
		{
			get { return this.getString ('DOMVALUE'); }
			set { this.Set (value, 'DOMVALUE'); }
		}

		public String Description
		{
			get { return this.getString ('DDTEXT'); }
			set { this.Set (value, 'DDTEXT'); }
		}


	}

    public class ET_BP_ROLE extends ENSX.EnosixFramework.ValueObject{

		public ET_BP_ROLE() {
			super('ET_BP_ROLE', new Map<string,type>());
		}

        public override Type getType() { return RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE.class; }

		public String Role
		{
			get { return this.getString ('RLTYP'); }
			set { this.Set (value, 'RLTYP'); }
		}

		public String Description
		{
			get { return this.getString ('RLTITL'); }
			set { this.Set (value, 'RLTITL'); }
		}


		public boolean ForPerson
		{
			get { return this.getBoolean ('XPERS'); }
			set { this.setBoolean (value, 'XPERS'); }
		}

		public boolean ForOrg
		{
			get { return this.getBoolean ('XORG'); }
			set { this.setBoolean (value, 'XORG'); }
		}

		public boolean ForGroup
		{
			get { return this.getBoolean ('XGROUP'); }
			set { this.setBoolean (value, 'XGROUP'); }
		}
	}

	public class ET_BP_ROLE_GROUP extends ENSX.EnosixFramework.ValueObject{

		public ET_BP_ROLE_GROUP() {
			super('ET_BP_ROLE_GROUP', new Map<string,type>());
		}

        public override Type getType() { return RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP.class; }

					public String RLTGR
		{
			get { return this.getString ('RLTGR'); }
			set { this.Set (value, 'RLTGR'); }
		}

		public String RLTGRTXT
		{
			get { return this.getString ('RLTGRTXT'); }
			set { this.Set (value, 'RLTGRTXT'); }
		}


		}

    public class ET_BP_TYPE extends ENSX.EnosixFramework.ValueObject {

		public ET_BP_TYPE() {
			super('ET_BP_TYPE', new Map<string,type>());
		}

        public override Type getType() { return RFC_SD_GET_BP_ROLE_TYPE.ET_BP_TYPE.class; }

		public String Type
		{
			get { return this.getString ('BPKIND'); }
			set { this.Set (value, 'BPKIND'); }
		}

		public String Description
		{
			get { return this.getString ('TEXT40'); }
			set { this.Set (value, 'TEXT40'); }
		}
	}
}
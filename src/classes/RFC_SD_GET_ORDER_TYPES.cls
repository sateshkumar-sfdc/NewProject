/// enosiX Inc. Generated Apex Model
/// Generated On: 1/9/2017 12:00:33 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class RFC_SD_GET_ORDER_TYPES extends ENSX.EnosixFramework.RFC {
	public RFC_SD_GET_ORDER_TYPES() {
		super('/ENSX/SD_GET_ORDER_TYPES', RFC_SD_GET_ORDER_TYPES.RESULT.class);
	}

	public override Type getType() { return RFC_SD_GET_ORDER_TYPES.class; }

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
				'ET_ITEM_CAT' => RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class,
				'ET_VALUES' => RFC_SD_GET_ORDER_TYPES.ET_VALUES.class
			});
    	}

		public override Type getType() { return RFC_SD_GET_ORDER_TYPES.RESULT.class; }

		public List<ET_ITEM_CAT> ET_ITEM_CAT_List
		{
			get
			{
				List<ET_ITEM_CAT> results = new List<ET_ITEM_CAT>();
				this.getCollection(RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class).copyTo(results);
				return results;
			}
		}

		public List<ET_VALUES> ET_VALUES_List
		{
			get
			{
				List<ET_VALUES> results = new List<ET_VALUES>();
				this.getCollection(RFC_SD_GET_ORDER_TYPES.ET_VALUES.class).copyTo(results);
				return results;
			}
		}

		public String IV_BOPROCESS
		{
			get { return this.getString ('IV_BOPROCESS'); }
			set { this.Set (value, 'IV_BOPROCESS'); }
		}

		public String IV_BOTYPE
		{
			get { return this.getString ('IV_BOTYPE'); }
			set { this.Set (value, 'IV_BOTYPE'); }
		}

		public String IV_CID
		{
			get { return this.getString ('IV_CID'); }
			set { this.Set (value, 'IV_CID'); }
		}

		public String IV_LANGU
		{
			get { return this.getString ('IV_LANGU'); }
			set { this.Set (value, 'IV_LANGU'); }
		}

		public String IV_USERNAME
		{
			get { return this.getString ('IV_USERNAME'); }
			set { this.Set (value, 'IV_USERNAME'); }
		}


    }
    	public class ET_ITEM_CAT extends ENSX.EnosixFramework.ValueObject{

		public ET_ITEM_CAT() {
			super('ET_ITEM_CAT', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class; }

					public String AUART
		{
			get { return this.getString ('AUART'); }
			set { this.Set (value, 'AUART'); }
		}

		public String PSTYV
		{
			get { return this.getString ('PSTYV'); }
			set { this.Set (value, 'PSTYV'); }
		}


		}
		public class ET_VALUES extends ENSX.EnosixFramework.ValueObject{

		public ET_VALUES() {
			super('ET_VALUES', new Map<string,type>());
		}

		public override Type getType() { return RFC_SD_GET_ORDER_TYPES.ET_VALUES.class; }

					public String VALUE
		{
			get { return this.getString ('VALUE'); }
			set { this.Set (value, 'VALUE'); }
		}

		public String DESCRIPTION
		{
			get { return this.getString ('DESCRIPTION'); }
			set { this.Set (value, 'DESCRIPTION'); }
		}


		}
	}
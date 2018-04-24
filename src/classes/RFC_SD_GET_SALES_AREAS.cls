public with sharing class RFC_SD_GET_SALES_AREAS extends ENSX.EnosixFramework.RFC {

    public RFC_SD_GET_SALES_AREAS() {
		super('/ENSX/SD_GET_SALES_AREAS', RFC_SD_GET_SALES_AREAS.RESULT.class);
	}

    public override Type getType() { return RFC_SD_GET_SALES_AREAS.class; }

    public RESULT Params {
		get { return (RESULT)this.getParameterContext(); }
	}

	public RESULT execute() {
		return (RESULT)this.executeFunction();
	}

    public class RESULT extends ENSX.EnosixFramework.FunctionObject {
    	public RESULT() {
    		super(new Map<string,type>{
    			'ET_SALES_AREA' => RFC_SD_GET_SALES_AREAS.ET_SALES_AREA.class
    			});
    	}

        public override Type getType() { return RFC_SD_GET_SALES_AREAS.RESULT.class; }

    	public List<ET_SALES_AREA> SalesAreas {
			get {
				List<ET_SALES_AREA> results = new List<ET_SALES_AREA>();
				this.getCollection(RFC_SD_GET_SALES_AREAS.ET_SALES_AREA.class).copyTo(results);
				return results;
			}
		}
    }

    public class ET_SALES_AREA extends ENSX.EnosixFramework.ValueObject {

        public override Type getType() { return RFC_SD_GET_SALES_AREAS.ET_SALES_AREA.class; }

		public string SalesOrganization
		{
			get { return this.getString ('VKORG'); }
			set { this.Set (value, 'VKORG'); }
		}



		public string SalesOrganizationName
		{
			get { return this.getString ('VKORG_TEXT'); }
			set { this.Set (value, 'VKORG_TEXT'); }
		}



		public string DistributionChannel
		{
			get { return this.getString ('VTWEG'); }
			set { this.Set (value, 'VTWEG'); }
		}



		public string DistributionChannelName
		{
			get { return this.getString ('VTWEG_TEXT'); }
			set { this.Set (value, 'VTWEG_TEXT'); }
		}



		public string Division
		{
			get { return this.getString ('SPART'); }
			set { this.Set (value, 'SPART'); }
		}



		public string DivisionName
		{
			get { return this.getString ('SPART_TEXT'); }
			set { this.Set (value, 'SPART_TEXT'); }
		}

    }
}
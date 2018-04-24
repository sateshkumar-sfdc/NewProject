public with sharing class CTRL_SalesAreas
    implements UTIL_SalesArea.DistributionChannel_Filter, UTIL_SalesArea.Division_Filter
{
	private DS_SalesArea DataSource;

    public boolean isPaymentTermsEditEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Customer.IsPaymentTermsEditEnabled', true);
        }
    }

	Transient boolean hasUpdated = false;

	public void setMyDataSource(DS_SalesArea value)
    {
        if(this.hasUpdated==null){
            this.hasUpdated=false;
        }
        if(this.DataSource==null){
	        this.DataSource = value;
            updateSalesArea();
        }else if(value != null){
           this.DataSource = value;
        }
    }

    public DS_SalesArea getMyDataSource()
    {
        return this.DataSource;
    }

    public void updateSalesArea() {
        if (string.isBlank(this.SalesData.SalesOrganization)) {
        	this.SalesData.SalesOrganization = pickFirst(SalesOrganizations);
        }

        if (string.isBlank(this.SalesData.DistributionChannel)) {
        	this.SalesData.DistributionChannel = pickFirst(DistributionChannels);
        }

        if (string.isBlank(this.SalesData.Division)) {
        	this.SalesData.Division = pickFirst(Divisions);
        }

        if (string.isBlank(this.SalesData.SalesOffice)) {
        	this.SalesData.SalesOffice = pickFirst(SalesOffices);
        }

        if (string.isBlank(this.SalesData.SalesGroup)) {
        	this.SalesData.SalesGroup = pickFirst(SalesGroups);
        }

        if (string.isBlank(this.SalesData.PriceListType)) {
        	this.SalesData.PriceListType = pickFirst(PriceLists);
        }

        if (string.isBlank(this.SalesData.CustomerPricingProcedure)) {
        	this.SalesData.CustomerPricingProcedure = pickFirst(PriceProcedures);
        }

        if (string.isBlank(this.SalesData.PriceGroup)) {
        	this.SalesData.PriceGroup = pickFirst(PriceGroups);
        }

        if (string.isBlank(this.SalesData.ShippingConditions)) {
        	this.SalesData.ShippingConditions = pickFirst(ShippingConditions);
        }

        if (string.isBlank(this.SalesData.TermsofPaymentKey)) {
        	this.SalesData.TermsofPaymentKey = pickFirst(PaymentTerms);
        }
        if(null!=this.dataSource && this.hasUpdated!=null && !this.hasUpdated){
            this.dataSource.updateSalesArea(this.SalesData);
            hasUpdated= true;
        }
    }
	/* Begin 	UTIL_SalesArea.DistributionChannel_Filter */
	public string getSelectedSalesOrganization() {
		return this.SalesData.SalesOrganization;
	}
	/* END    UTIL_SalesArea.DistributionChannel_Filter */

	/* Begin UTIL_SalesArea.Division_Filter */
	public string getSelectedDistributionChannel() {
		return this.SalesData.DistributionChannel;
	}
	/* END 	 UTIL_SalesArea.Division_Filter */

	private boolean checkSource() {
		if (null == this.DataSource) {
			return false;
		}
		return true;
	}

    public RFC_SD_GET_SALES_AREAS.RESULT SalesAreaMaster {
    	get {
    		if (checkSource()) {
    			return this.DataSource.getSalesAreas();
    		}
    		return new RFC_SD_GET_SALES_AREAS.RESULT();
    	}
    }

    public RFC_SD_GET_GROUP_OFFICE.RESULT GroupOfficeMaster {
    	get {
    		if (checkSource()) {
    			return this.DataSource.getGroupOffice();
    		}
    		return new RFC_SD_GET_GROUP_OFFICE.RESULT();
    	}
    }

    public RFC_SD_GET_PRICING_STAT.RESULT PricingMaster {
    	get {
    		if (checkSource()) {
    			return this.DataSource.getPricingStat();
    		}
    		return new RFC_SD_GET_PRICING_STAT.RESULT();
    	}
    }

    public RFC_SD_GET_SHIP_INFO.RESULT ShippingMaster {
    	get {
    		if (checkSource()) {
    			return this.DataSource.getShipInfo();
    		}
    		return new RFC_SD_GET_SHIP_INFO.RESULT();
    	}
    }

    public SBO_EnosixCustomer_Detail.SALES_DATA SalesData {
    	get {
    		if (checkSource()) {
    			return this.DataSource.getSALES_DATA();
    		}
    		return new SBO_EnosixCustomer_Detail.SALES_DATA();
    	}
    }

    private static string dropDownDescriptionFormat
    {
        get
        {
            return UTIL_SelectOption.dropDownDescriptionFormat;
        }
    }

	public List<SelectOption> SalesOrganizations {
  	get {

			List<SelectOption> result = Util_SelectOption.buildOptionsFromList(
					new UTIL_SalesArea.SalesOrganization_OptionBuilder(),
					this.SalesAreaMaster.SalesAreas
			);

      return result;
    }
  }



  public List<SelectOption> DistributionChannels {
    get {
			List<SelectOption> result = Util_SelectOption.buildOptionsFromList(
					new UTIL_SalesArea.DistributionChannel_OptionBuilder(this),
					this.SalesAreaMaster.SalesAreas
			);

      return result;
    }
  }

  public List<SelectOption> Divisions {
    get {
			List<SelectOption> result = Util_SelectOption.buildOptionsFromList(
					new UTIL_SalesArea.Division_OptionBuilder(this),
					this.SalesAreaMaster.SalesAreas
			);

			return result;
    }
  }

    public List<SelectOption> SalesOffices {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (checkSource()) {
            	AddSalesOffice(result, this.GroupOfficeMaster.ET_SALES_OFFICE_List,
            		this.SalesData.SalesOrganization, this.SalesData.DistributionChannel, this.SalesData.Division);
            }

            return result;
        }
    }

    public List<SelectOption> SalesGroups {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (checkSource()) {
            	AddSalesGroups(result, this.GroupOfficeMaster.ET_SALES_GROUP_List,
            		this.SalesData.SalesOffice);
            }

            return result;
        }
    }

    public List<SelectOption> SalesDistricts {
        get {
            List<SelectOption> result = new List<SelectOption>();
            result.add(new SelectOption('', '(Default)'));
            if (checkSource()) {
            	AddSalesDistricts(result, this.GroupOfficeMaster.ET_SALES_DISTRICT_List);
            }

            return result;
        }
    }

    public List<SelectOption> PriceLists {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (checkSource()) {
            	AddPriceList(result, this.PricingMaster.ET_CUST_PRICE_LIST_List);
            }

            return result;
        }
    }

    public List<SelectOption> PriceProcedures {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (checkSource()) {
            	AddPriceProcedure(result, this.PricingMaster.ET_CUST_PRICE_PROC_List);
            }

            return result;
        }
    }

    public List<SelectOption> PriceGroups {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (checkSource()) {
            	AddPriceGroup(result, this.PricingMaster.ET_CUST_PRICE_GRP_List);
            }

            return result;
        }
    }

    public List<SelectOption> PaymentTerms {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (checkSource()) {
            	AddPaymentTerms(result, this.ShippingMaster.ET_PAY_TERMS_List);
            }

            return result;
        }
    }

    public List<SelectOption> ShippingConditions {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (checkSource()) {
            	AddShippingConditions(result, this.ShippingMaster.ET_SHIP_COND_List);
            }

            return result;
        }
    }

    private static void AddSalesOffice(List<SelectOption> result, List<RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE> offices,
    	string salesOrganization, string distributionChannel, string division) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE office : offices) {
            if (!  values.contains(office.VKBUR)
            	&& office.VKORG.equalsIgnoreCase(salesOrganization)
            	&& office.VTWEG.equalsIgnoreCase(distributionChannel)
            	&& office.SPART.equalsIgnoreCase(division)
                && (true || 'NTL' == office.VKBUR || 'STD' == office.VKBUR)
            	) {
                    string description = string.format(dropDownDescriptionFormat, new string[]{office.VKBUR, office.BEZEI});
                 result.add(new SelectOption(office.VKBUR, description));
                 values.add(office.VKBUR);
            }
        }
    }

    private static void AddSalesGroups(List<SelectOption> result, List<RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP> groups,
    	string salesOffice) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP g : groups) {
            if (!values.contains(g.VKGRP) &&  g.VKBUR.equalsIgnoreCase(salesOffice)  ) {
                string description = string.format(dropDownDescriptionFormat, new string[]{g.VKGRP, g.BEZEI});
                result.add(new SelectOption(g.VKGRP, description));
                 values.add(g.VKGRP);
            }
        }
    }

    private static void AddSalesDistricts(List<SelectOption> result, List<RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT> districts) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT d : districts) {
            if (!values.contains(d.BZIRK)) {
                string description = string.format(dropDownDescriptionFormat, new string[]{d.BZIRK, d.BZTXT});
                result.add(new SelectOption(d.BZIRK, description));
                 values.add(d.BZIRK);
            }
        }
    }

    private static void AddPriceList(List<SelectOption> result, List<RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST> prices ) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST p : prices) {
            if (!values.contains(p.PLTYP)) {
                 string description = string.format(dropDownDescriptionFormat, new string[]{p.PLTYP, p.PTEXT});
                 result.add(new SelectOption(p.PLTYP, description));
                 values.add(p.PLTYP);
            }
        }
    }

    private static void AddPriceProcedure(List<SelectOption> result, List<RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC> priceProcedures ) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC p : priceProcedures) {
            if (!values.contains(p.KALKS)) {
                 string description = string.format(dropDownDescriptionFormat, new string[]{p.KALKS, p.VTEXT});
                 result.add(new SelectOption(p.KALKS, description));
                 values.add(p.KALKS);
            }
        }
    }

    private static void AddPriceGroup(List<SelectOption> result, List<RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP> priceGroups ) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP p : priceGroups) {
            if (!values.contains(p.KONDA)) {
                 string description = string.format(dropDownDescriptionFormat, new string[]{p.KONDA, p.VTEXT});
                 result.add(new SelectOption(p.KONDA, description));
                 values.add(p.KONDA);
            }
        }
    }



    private static void AddPaymentTerms(List<SelectOption> result, List<RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS> paymentTerms ) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS t : paymentTerms) {
            if (string.isNotBlank( t.ZTERM ) && string.isNotBlank(t.VTEXT ) && !values.contains(t.ZTERM)) {
                 string description = string.format(dropDownDescriptionFormat, new string[]{t.ZTERM, t.VTEXT});
                 result.add(new SelectOption(t.ZTERM, description));
                 values.add(t.ZTERM);
            }
        }
    }

    private static void AddShippingConditions(List<SelectOption> result, List<RFC_SD_GET_SHIP_INFO.ET_SHIP_COND> shippingConditions ) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_SHIP_INFO.ET_SHIP_COND c : shippingConditions) {
            if (!values.contains(c.VSBED)) {
                 string description = string.format(dropDownDescriptionFormat, new string[]{c.VSBED, c.VTEXT});
                 result.add(new SelectOption(c.VSBED, description));
                 values.add(c.VSBED);
            }
        }
    }


    static string pickFirst(List<SelectOption> options) {
        if(options.size() <= 0) return '';

        SelectOption firstOption = options.get(0);
        if (null != firstOption) {
        	return firstOption.getValue();
        }
        return '';
    }
}
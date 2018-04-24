public with sharing class CTRL_CompanyCode {
    
    private DS_CompanyCode DataSource;
    
	public CTRL_CompanyCode() {
	}
	
	public void setMyDataSource(DS_CompanyCode value)
    {
    	system.debug('Datasource set');
        this.DataSource = value;
    }
    
    public DS_CompanyCode getMyDataSource()
    {
        return this.DataSource;
    }
    
    public RFC_SD_GET_SHIP_INFO.RESULT ShippingMaster {
    	get { 
    		if (checkSource()) {
    			return this.DataSource.getShipInfo(); 
    		}
    		return new RFC_SD_GET_SHIP_INFO.RESULT();
    	}
    }
    
    public SBO_EnosixCustomer_Detail.COMPANY_DATA CompanyData {
    	get {
    		if (checkSource()) {
    			return this.DataSource.getCOMPANY_DATA();
    		} 
    		return new SBO_EnosixCustomer_Detail.COMPANY_DATA();
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
    
    private boolean checkSource() {
		if (null == this.DataSource) {
			system.debug('Datasource is null');
			return false;
		}
		return true;
	}
	
	private static void AddPaymentTerms(List<SelectOption> result, List<RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS> paymentTerms ) {
    	Set<string> values = new Set<string>();
    	for (RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS t : paymentTerms) {
            if (string.isNotBlank( t.ZTERM ) && string.isNotBlank(t.VTEXT ) && !values.contains(t.ZTERM)) {
                 result.add(new SelectOption(t.ZTERM, t.VTEXT));
                 values.add(t.ZTERM);
            }
        }
    }
}
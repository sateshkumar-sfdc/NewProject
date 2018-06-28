/// enosiX Inc. Generated Apex Model
/// Generated On: 1/12/2017 9:56:51 AM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_YetiCustCreditLimitSync_Search extends ENSX.EnosixFramework.SearchSBO {
    
    public SBO_YetiCustCreditLimitSync_Search() {
        super('YetiCustCreditLimitSync', SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SC.class, SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SR.class);
    }
    
	public override Type getType() { return SBO_YetiCustCreditLimitSync_Search.class; }

    public class YetiCustCreditLimitSync_SC extends ENSX.EnosixFramework.SearchContext { 		
        public YetiCustCreditLimitSync_SC() {		
            super(new Map<string,type>		
            {		
                'SEARCHPARAMS' => SBO_YetiCustCreditLimitSync_Search.SEARCHPARAMS.class
		
            });		
        }

		public override Type getType() { return SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SC.class; }

        public SBO_YetiCustCreditLimitSync_Search.SEARCHPARAMS SEARCHPARAMS { 
            get 
            { 
                return (SEARCHPARAMS)this.getStruct(SBO_YetiCustCreditLimitSync_Search.SEARCHPARAMS.class);		
            } 
        } 

    }		

    public YetiCustCreditLimitSync_SC SearchContext 		
    {		
        get { return ( YetiCustCreditLimitSync_SC)this.getSearchContext(); }		
    }		

    public class YetiCustCreditLimitSync_SR extends ENSX.EnosixFramework.SearchResult 
    {
        public YetiCustCreditLimitSync_SR() {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT.class } );
        }
        
        public ENSX.EnosixFramework.FrameworkCollection SearchResults{
            get { return super.getCollection(SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

		public override Type getType() { return SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SR.class; }
    }
    
    public YetiCustCreditLimitSync_SR execute() 
    {
        return (YetiCustCreditLimitSync_SR)super.executeSearch();
    }

    	public class SEARCHPARAMS extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_YetiCustCreditLimitSync_Search.SEARCHPARAMS.class; }

				public String FromCustomerNumber
		{ 
			get { return this.getString ('KUNNR_FR'); } 
			set { this.Set (value, 'KUNNR_FR'); }
		}

		public Integer MAX_ROWS
		{ 
			get { return this.getInteger ('MAX_ROWS'); } 
			set { this.Set (value, 'MAX_ROWS'); }
		}

	}
		public class SEARCHRESULT extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT.class; }

				public String CustomerNumber
		{ 
			get { return this.getString ('KUNNR'); } 
			set { this.Set (value, 'KUNNR'); }
		}

		public String CreditSegment
		{ 
			get { return this.getString ('CREDIT_SGMNT'); } 
			set { this.Set (value, 'CREDIT_SGMNT'); }
		}

		public String Currencies
		{ 
			get { return this.getString ('CURRENCIES'); } 
			set { this.Set (value, 'CURRENCIES'); }
		}

		public Decimal TotalCreditExposure
		{ 
			get { return this.getDecimal ('EXPOSURE'); } 
			set { this.Set (value, 'EXPOSURE'); }
		}

		public Decimal CreditLimit
		{ 
			get { return this.getDecimal ('CREDIT_LIMIT'); } 
			set { this.Set (value, 'CREDIT_LIMIT'); }
		}

		public Decimal HorizonExposure
		{ 
			get { return this.getDecimal ('HORIZON_EXP'); } 
			set { this.Set (value, 'HORIZON_EXP'); }
		}

		public Date HorizonDate
		{ 
			get { return this.getDate ('HORIZON_DATE'); } 
			set { this.Set (value, 'HORIZON_DATE'); }
		}

		public String HorizonInDays
		{ 
			get { return this.getString ('HORIZON_DAYS'); } 
			set { this.Set (value, 'HORIZON_DAYS'); }
		}

		public Date CreditLimitChangeDate
		{ 
			get { return this.getDate ('LIMIT_CHG_DATE'); } 
			set { this.Set (value, 'LIMIT_CHG_DATE'); }
		}

	}
	
}
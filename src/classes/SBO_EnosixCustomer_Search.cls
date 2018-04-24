/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixCustomer_Search extends ENSX.EnosixFramework.SearchSBO {
    
    public SBO_EnosixCustomer_Search() {
        super('EnosixCustomer', SBO_EnosixCustomer_Search.EnosixCustomer_SC.class, SBO_EnosixCustomer_Search.EnosixCustomer_SR.class);
    }
    
	public override Type getType() { return SBO_EnosixCustomer_Search.class; }

    public class EnosixCustomer_SC extends ENSX.EnosixFramework.SearchContext { 		
        public EnosixCustomer_SC() {		
            super(new Map<string,type>		
            {		
                'SEARCHPARAMS' => SBO_EnosixCustomer_Search.SEARCHPARAMS.class
		
            });		
        }

		public override Type getType() { return SBO_EnosixCustomer_Search.EnosixCustomer_SC.class; }

        public SBO_EnosixCustomer_Search.SEARCHPARAMS SEARCHPARAMS { 
            get 
            { 
                return (SEARCHPARAMS)this.getStruct(SBO_EnosixCustomer_Search.SEARCHPARAMS.class);		
            } 
        } 

    }		

    public EnosixCustomer_SC SearchContext 		
    {		
        get { return ( EnosixCustomer_SC)this.getSearchContext(); }		
    }		

    public class EnosixCustomer_SR extends ENSX.EnosixFramework.SearchResult 
    {
        public EnosixCustomer_SR() {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_EnosixCustomer_Search.SEARCHRESULT.class } );
        }
        
        public ENSX.EnosixFramework.FrameworkCollection SearchResults{
            get { return super.getCollection(SBO_EnosixCustomer_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

		public override Type getType() { return SBO_EnosixCustomer_Search.EnosixCustomer_SR.class; }
    }
    
    public EnosixCustomer_SR execute() 
    {
        return (EnosixCustomer_SR)super.executeSearch();
    }

    	public class SEARCHPARAMS extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixCustomer_Search.SEARCHPARAMS.class; }

				public String CustomerNumberFrom
		{ 
			get { return this.getString ('KUNNR_FR'); } 
			set { this.Set (value, 'KUNNR_FR'); }
		}

		public String CustomerNumberTo
		{ 
			get { return this.getString ('KUNNR_TO'); } 
			set { this.Set (value, 'KUNNR_TO'); }
		}

		public String CustomerName
		{ 
			get { return this.getString ('MCOD1'); } 
			set { this.Set (value, 'MCOD1'); }
		}

		public String PostalCode
		{ 
			get { return this.getString ('PSTLZ'); } 
			set { this.Set (value, 'PSTLZ'); }
		}

		public String City
		{ 
			get { return this.getString ('CITY1'); } 
			set { this.Set (value, 'CITY1'); }
		}

		public String Region
		{ 
			get { return this.getString ('REGION'); } 
			set { this.Set (value, 'REGION'); }
		}

		public String Country
		{ 
			get { return this.getString ('COUNTRY'); } 
			set { this.Set (value, 'COUNTRY'); }
		}

		public String TelephoneNumber
		{ 
			get { return this.getString ('TEL_NUMBER'); } 
			set { this.Set (value, 'TEL_NUMBER'); }
		}

		public String EmailAddress
		{ 
			get { return this.getString ('EMAIL_ADDRESS'); } 
			set { this.Set (value, 'EMAIL_ADDRESS'); }
		}

	}
		public class SEARCHRESULT extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixCustomer_Search.SEARCHRESULT.class; }

				public String CustomerNumber
		{ 
			get { return this.getString ('KUNNR'); } 
			set { this.Set (value, 'KUNNR'); }
		}

		public String Name
		{ 
			get { return this.getString ('NAME1'); } 
			set { this.Set (value, 'NAME1'); }
		}

		public String Name2
		{ 
			get { return this.getString ('NAME2'); } 
			set { this.Set (value, 'NAME2'); }
		}

		public String Street
		{ 
			get { return this.getString ('STREET'); } 
			set { this.Set (value, 'STREET'); }
		}

		public String City
		{ 
			get { return this.getString ('CITY1'); } 
			set { this.Set (value, 'CITY1'); }
		}

		public String PostalCode
		{ 
			get { return this.getString ('POST_CODE1'); } 
			set { this.Set (value, 'POST_CODE1'); }
		}

		public String Region
		{ 
			get { return this.getString ('REGION'); } 
			set { this.Set (value, 'REGION'); }
		}

		public String Country
		{ 
			get { return this.getString ('COUNTRY'); } 
			set { this.Set (value, 'COUNTRY'); }
		}

		public String POBox
		{ 
			get { return this.getString ('PO_BOX'); } 
			set { this.Set (value, 'PO_BOX'); }
		}

		public String TelephoneNumber
		{ 
			get { return this.getString ('TEL_NUMBER'); } 
			set { this.Set (value, 'TEL_NUMBER'); }
		}

		public String Language
		{ 
			get { return this.getString ('LANGU'); } 
			set { this.Set (value, 'LANGU'); }
		}

		public Decimal CreditLimit
		{ 
			get { return this.getDecimal ('KLIMK'); } 
			set { this.Set (value, 'KLIMK'); }
		}

		public Decimal CreditAvailable
		{ 
			get { return this.getDecimal ('CREDIT_AVAIL'); } 
			set { this.Set (value, 'CREDIT_AVAIL'); }
		}

		public String CurrencyKey
		{ 
			get { return this.getString ('WAERS'); } 
			set { this.Set (value, 'WAERS'); }
		}

		public String EmailAddress
		{ 
			get { return this.getString ('EMAIL_ADDRESS'); } 
			set { this.Set (value, 'EMAIL_ADDRESS'); }
		}

	}
	
}
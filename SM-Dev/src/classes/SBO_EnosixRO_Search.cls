/// enosiX Inc. Generated Apex Model
/// Generated On: 1/26/2017 8:46:28 AM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixRO_Search extends ENSX.EnosixFramework.SearchSBO {
    
    public SBO_EnosixRO_Search() {
        super('EnosixRO', SBO_EnosixRO_Search.EnosixRO_SC.class, SBO_EnosixRO_Search.EnosixRO_SR.class);
    }
    
	public override Type getType() { return SBO_EnosixRO_Search.class; }

    public class EnosixRO_SC extends ENSX.EnosixFramework.SearchContext { 		
        public EnosixRO_SC() {		
            super(new Map<string,type>		
            {		
                'SEARCHPARAMS' => SBO_EnosixRO_Search.SEARCHPARAMS.class
		
            });		
        }

		public override Type getType() { return SBO_EnosixRO_Search.EnosixRO_SC.class; }

        public SBO_EnosixRO_Search.SEARCHPARAMS SEARCHPARAMS { 
            get 
            { 
                return (SEARCHPARAMS)this.getStruct(SBO_EnosixRO_Search.SEARCHPARAMS.class);		
            } 
        } 

    }		

    public EnosixRO_SC SearchContext 		
    {		
        get { return ( EnosixRO_SC)this.getSearchContext(); }		
    }		

    public class EnosixRO_SR extends ENSX.EnosixFramework.SearchResult 
    {
        public EnosixRO_SR() {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_EnosixRO_Search.SEARCHRESULT.class } );
        }
        
        public ENSX.EnosixFramework.FrameworkCollection SearchResults{
            get { return super.getCollection(SBO_EnosixRO_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

		public override Type getType() { return SBO_EnosixRO_Search.EnosixRO_SR.class; }
    }
    
    public EnosixRO_SR execute() 
    {
        return (EnosixRO_SR)super.executeSearch();
    }

    	public class SEARCHPARAMS extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixRO_Search.SEARCHPARAMS.class; }

				public String FromSalesDocumentNumber
		{ 
			get { return this.getString ('VBELN_FR'); } 
			set { this.Set (value, 'VBELN_FR'); }
		}

		public String ToSalesDocumentNumber
		{ 
			get { return this.getString ('VBELN_TO'); } 
			set { this.Set (value, 'VBELN_TO'); }
		}

		public String SoldToParty
		{ 
			get { return this.getString ('KUNAG'); } 
			set { this.Set (value, 'KUNAG'); }
		}

		public String ShipToParty
		{ 
			get { return this.getString ('KUNWE'); } 
			set { this.Set (value, 'KUNWE'); }
		}

		public String CustomerPONumber
		{ 
			get { return this.getString ('BSTNK'); } 
			set { this.Set (value, 'BSTNK'); }
		}

		public String Material
		{ 
			get { return this.getString ('MATNR'); } 
			set { this.Set (value, 'MATNR'); }
		}

		public String SalesDocumentType
		{ 
			get { return this.getString ('AUART'); } 
			set { this.Set (value, 'AUART'); }
		}

		public Date FromCreateDate
		{ 
			get { return this.getDate ('ERDAT_FR'); } 
			set { this.Set (value, 'ERDAT_FR'); }
		}

		public Date ToCreateDate
		{ 
			get { return this.getDate ('ERDAT_TO'); } 
			set { this.Set (value, 'ERDAT_TO'); }
		}

		public String OpenOnly
		{ 
			get { return this.getString ('X_OPENONLY'); } 
			set { this.Set (value, 'X_OPENONLY'); }
		}

		public String CompletedOnly
		{ 
			get { return this.getString ('X_COMPLETEDONLY'); } 
			set { this.Set (value, 'X_COMPLETEDONLY'); }
		}

		public String Username
		{ 
			get { return this.getString ('USERNAME'); } 
			set { this.Set (value, 'USERNAME'); }
		}

		public String SalesDocumentVersionNumber
		{ 
			get { return this.getString ('VSNMR_V'); } 
			set { this.Set (value, 'VSNMR_V'); }
		}

		public String YourReference
		{ 
			get { return this.getString ('IHREZ'); } 
			set { this.Set (value, 'IHREZ'); }
		}

		public String ShipToPurchaseOrderNumber
		{ 
			get { return this.getString ('BSTKD_E'); } 
			set { this.Set (value, 'BSTKD_E'); }
		}

	}
		public class SEARCHRESULT extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixRO_Search.SEARCHRESULT.class; }

				public String SalesDocument
		{ 
			get { return this.getString ('VBELN'); } 
			set { this.Set (value, 'VBELN'); }
		}

		public String CustomerPONumber
		{ 
			get { return this.getString ('BSTNK'); } 
			set { this.Set (value, 'BSTNK'); }
		}

		public Date CreateDate
		{ 
			get { return this.getDate ('ERDAT'); } 
			set { this.Set (value, 'ERDAT'); }
		}

		public String SalesDocumentType
		{ 
			get { return this.getString ('AUART'); } 
			set { this.Set (value, 'AUART'); }
		}

		public String SalesDocumentTypeDescription
		{ 
			get { return this.getString ('AUART_TEXT'); } 
			set { this.Set (value, 'AUART_TEXT'); }
		}

		public String SoldToParty
		{ 
			get { return this.getString ('KUNAG'); } 
			set { this.Set (value, 'KUNAG'); }
		}

		public String SoldToName
		{ 
			get { return this.getString ('KUNAG_NAME'); } 
			set { this.Set (value, 'KUNAG_NAME'); }
		}

		public String SoldToCity
		{ 
			get { return this.getString ('KUNAG_CITY1'); } 
			set { this.Set (value, 'KUNAG_CITY1'); }
		}

		public String SoldToRegion
		{ 
			get { return this.getString ('KUNAG_REGION'); } 
			set { this.Set (value, 'KUNAG_REGION'); }
		}

		public String ShipToParty
		{ 
			get { return this.getString ('KUNWE'); } 
			set { this.Set (value, 'KUNWE'); }
		}

		public String ShipToName
		{ 
			get { return this.getString ('KUNWE_NAME'); } 
			set { this.Set (value, 'KUNWE_NAME'); }
		}

		public String ShipToCity
		{ 
			get { return this.getString ('KUNWE_CITY1'); } 
			set { this.Set (value, 'KUNWE_CITY1'); }
		}

		public String ShipToRegion
		{ 
			get { return this.getString ('KUNWE_REGION'); } 
			set { this.Set (value, 'KUNWE_REGION'); }
		}

		public Decimal NetTotalValue
		{ 
			get { return this.getDecimal ('NETWR'); } 
			set { this.Set (value, 'NETWR'); }
		}

		public Decimal NetTotalTax
		{ 
			get { return this.getDecimal ('MWSBP'); } 
			set { this.Set (value, 'MWSBP'); }
		}

		public String SalesDocumentCurrency
		{ 
			get { return this.getString ('WAERK'); } 
			set { this.Set (value, 'WAERK'); }
		}

		public String OrderStatus
		{ 
			get { return this.getString ('ORDERSTATUS'); } 
			set { this.Set (value, 'ORDERSTATUS'); }
		}

		public String SalesDocumentVersionNumber
		{ 
			get { return this.getString ('VSNMR_V'); } 
			set { this.Set (value, 'VSNMR_V'); }
		}

		public String YourReference
		{ 
			get { return this.getString ('IHREZ'); } 
			set { this.Set (value, 'IHREZ'); }
		}

		public String ShipToPurchaseOrderNumber
		{ 
			get { return this.getString ('BSTKD_E'); } 
			set { this.Set (value, 'BSTKD_E'); }
		}

	}
	
}
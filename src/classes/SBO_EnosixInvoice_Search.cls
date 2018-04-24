/// enosiX Inc. Generated Apex Model
/// Generated On: 1/17/2017 3:39:05 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixInvoice_Search extends ENSX.EnosixFramework.SearchSBO {
    
    public SBO_EnosixInvoice_Search() {
        super('EnosixInvoice', SBO_EnosixInvoice_Search.EnosixInvoice_SC.class, SBO_EnosixInvoice_Search.EnosixInvoice_SR.class);
    }
    
	public override Type getType() { return SBO_EnosixInvoice_Search.class; }

    public class EnosixInvoice_SC extends ENSX.EnosixFramework.SearchContext { 		
        public EnosixInvoice_SC() {		
            super(new Map<string,type>		
            {		
                'SEARCHPARAMS' => SBO_EnosixInvoice_Search.SEARCHPARAMS.class
		
            });		
        }

		public override Type getType() { return SBO_EnosixInvoice_Search.EnosixInvoice_SC.class; }

        public SBO_EnosixInvoice_Search.SEARCHPARAMS SEARCHPARAMS { 
            get 
            { 
                return (SEARCHPARAMS)this.getStruct(SBO_EnosixInvoice_Search.SEARCHPARAMS.class);		
            } 
        } 

    }		

    public EnosixInvoice_SC SearchContext 		
    {		
        get { return ( EnosixInvoice_SC)this.getSearchContext(); }		
    }		

    public class EnosixInvoice_SR extends ENSX.EnosixFramework.SearchResult 
    {
        public EnosixInvoice_SR() {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_EnosixInvoice_Search.SEARCHRESULT.class } );
        }
        
        public ENSX.EnosixFramework.FrameworkCollection SearchResults{
            get { return super.getCollection(SBO_EnosixInvoice_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

		public override Type getType() { return SBO_EnosixInvoice_Search.EnosixInvoice_SR.class; }
    }
    
    public EnosixInvoice_SR execute() 
    {
        return (EnosixInvoice_SR)super.executeSearch();
    }

    	public class SEARCHPARAMS extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixInvoice_Search.SEARCHPARAMS.class; }

				public String FromBillingDocumentNumber
		{ 
			get { return this.getString ('VBELN_FR'); } 
			set { this.Set (value, 'VBELN_FR'); }
		}

		public String ToBillingDocumentNumber
		{ 
			get { return this.getString ('VBELN_TO'); } 
			set { this.Set (value, 'VBELN_TO'); }
		}

		public String SalesOrganization
		{ 
			get { return this.getString ('VKORG'); } 
			set { this.Set (value, 'VKORG'); }
		}

		public String Payer
		{ 
			get { return this.getString ('KUNRG'); } 
			set { this.Set (value, 'KUNRG'); }
		}

		public String SoldToParty
		{ 
			get { return this.getString ('KUNAG'); } 
			set { this.Set (value, 'KUNAG'); }
		}

		public String BillingType
		{ 
			get { return this.getString ('FKART'); } 
			set { this.Set (value, 'FKART'); }
		}

		public Date FromBillingDate
		{ 
			get { return this.getDate ('FKDAT_FR'); } 
			set { this.Set (value, 'FKDAT_FR'); }
		}

		public Date ToBillingDate
		{ 
			get { return this.getDate ('FKDAT_TO'); } 
			set { this.Set (value, 'FKDAT_TO'); }
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

		public String CreatedBy
		{ 
			get { return this.getString ('ERNAM'); } 
			set { this.Set (value, 'ERNAM'); }
		}

	}
		public class SEARCHRESULT extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixInvoice_Search.SEARCHRESULT.class; }

				public String BillingDocument
		{ 
			get { return this.getString ('VBELN'); } 
			set { this.Set (value, 'VBELN'); }
		}

		public String BillingType
		{ 
			get { return this.getString ('FKART'); } 
			set { this.Set (value, 'FKART'); }
		}

		public String BillingTypeDescription
		{ 
			get { return this.getString ('FKART_TEXT'); } 
			set { this.Set (value, 'FKART_TEXT'); }
		}

		public String CompanyCode
		{ 
			get { return this.getString ('BUKRS'); } 
			set { this.Set (value, 'BUKRS'); }
		}

		public String CompanyCodeName
		{ 
			get { return this.getString ('BUKRS_TEXT'); } 
			set { this.Set (value, 'BUKRS_TEXT'); }
		}

		public String SalesOrganization
		{ 
			get { return this.getString ('VKORG'); } 
			set { this.Set (value, 'VKORG'); }
		}

		public String SalesOrgDescription
		{ 
			get { return this.getString ('VKORG_TEXT'); } 
			set { this.Set (value, 'VKORG_TEXT'); }
		}

		public Date BillingDate
		{ 
			get { return this.getDate ('FKDAT'); } 
			set { this.Set (value, 'FKDAT'); }
		}

		public Date ShipDate
		{ 
			get { return this.getDate ('WADAT'); } 
			set { this.Set (value, 'WADAT'); }
		}

		public String SalesOrderNumber
		{ 
			get { return this.getString ('AUBEL'); } 
			set { this.Set (value, 'AUBEL'); }
		}

		public String Payer
		{ 
			get { return this.getString ('KUNRG'); } 
			set { this.Set (value, 'KUNRG'); }
		}

		public String PayerName
		{ 
			get { return this.getString ('KUNRG_NAME'); } 
			set { this.Set (value, 'KUNRG_NAME'); }
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

		public String TrackingNumber
		{ 
			get { return this.getString ('BOLNR'); } 
			set { this.Set (value, 'BOLNR'); }
		}

		public Decimal NetOrderValue
		{ 
			get { return this.getDecimal ('NETWR'); } 
			set { this.Set (value, 'NETWR'); }
		}

		public Decimal TaxAmount
		{ 
			get { return this.getDecimal ('MWSBP'); } 
			set { this.Set (value, 'MWSBP'); }
		}

		public String SalesDocumentCurrency
		{ 
			get { return this.getString ('WAERK'); } 
			set { this.Set (value, 'WAERK'); }
		}

		public String CreatedBy
		{ 
			get { return this.getString ('ERNAM'); } 
			set { this.Set (value, 'ERNAM'); }
		}

		public Date CreateDate
		{ 
			get { return this.getDate ('ERDAT'); } 
			set { this.Set (value, 'ERDAT'); }
		}

		public String BillingStatus
		{ 
			get { return this.getString ('VF_STATUS'); } 
			set { this.Set (value, 'VF_STATUS'); }
		}

		public String BillingStatusDescription
		{ 
			get { return this.getString ('VF_STATUS_TEXT'); } 
			set { this.Set (value, 'VF_STATUS_TEXT'); }
		}

	}
	
}
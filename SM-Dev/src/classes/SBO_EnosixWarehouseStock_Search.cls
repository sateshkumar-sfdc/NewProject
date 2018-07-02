/// enosiX Inc. Generated Apex Model
/// Generated On: 10/6/2016 12:57:18 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixWarehouseStock_Search extends ENSX.EnosixFramework.SearchSBO {
    
    public SBO_EnosixWarehouseStock_Search() {
        super('EnosixWarehouseStock', SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SC.class, SBO_EnosixWarehouseStock_Search.EnosixWarehouseStock_SR.class);

    }
    

    public class EnosixWarehouseStock_SC extends ENSX.EnosixFramework.SearchContext { 		
        public EnosixWarehouseStock_SC() {		
            super(new Map<string,type>		
            {		
                'SEARCHPARAMS' => SBO_EnosixWarehouseStock_Search.SEARCHPARAMS.class
,'MATERIALSEARCH' => SBO_EnosixWarehouseStock_Search.MATERIALSEARCH.class
,'MATDESCSEARCH' => SBO_EnosixWarehouseStock_Search.MATDESCSEARCH.class
,'PLANTSEARCH' => SBO_EnosixWarehouseStock_Search.PLANTSEARCH.class
,'STORAGELOCSEARCH' => SBO_EnosixWarehouseStock_Search.STORAGELOCSEARCH.class
,'BATCHSEARCH' => SBO_EnosixWarehouseStock_Search.BATCHSEARCH.class
,'MATERIALTYSEARCH' => SBO_EnosixWarehouseStock_Search.MATERIALTYSEARCH.class
,'MATERIALGRPSEARCH' => SBO_EnosixWarehouseStock_Search.MATERIALGRPSEARCH.class
,'SPECIALSTKTYSEARCH' => SBO_EnosixWarehouseStock_Search.SPECIALSTKTYSEARCH.class
,'POSTINGDTSEARCH' => SBO_EnosixWarehouseStock_Search.POSTINGDTSEARCH.class
,'MOVEMENTTYSEARCH' => SBO_EnosixWarehouseStock_Search.MOVEMENTTYSEARCH.class
		
            });		
        }		

        public SBO_EnosixWarehouseStock_Search.SEARCHPARAMS SEARCHPARAMS { 
            get 
            { 
                return (SEARCHPARAMS)this.getStruct(SBO_EnosixWarehouseStock_Search.SEARCHPARAMS.class);		
            } 
        } 

	    public ENSX.EnosixFramework.FrameworkCollection MATERIALSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.MATERIALSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection MATDESCSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.MATDESCSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection PLANTSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.PLANTSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection STORAGELOCSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.STORAGELOCSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection BATCHSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.BATCHSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection MATERIALTYSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.MATERIALTYSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection MATERIALGRPSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.MATERIALGRPSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection SPECIALSTKTYSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.SPECIALSTKTYSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection POSTINGDTSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.POSTINGDTSEARCH.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection MOVEMENTTYSEARCH { 
            get 
            { 
                return this.getCollection(SBO_EnosixWarehouseStock_Search.MOVEMENTTYSEARCH.class);		
            }
		}
    }		

    public EnosixWarehouseStock_SC SearchContext 		
    {		
        get { return ( EnosixWarehouseStock_SC)this.getSearchContext(); }		
    }		

    public class EnosixWarehouseStock_SR extends ENSX.EnosixFramework.SearchResult 
    {
        public EnosixWarehouseStock_SR() {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_EnosixWarehouseStock_Search.SEARCHRESULT.class } );
        }
        
        public ENSX.EnosixFramework.FrameworkCollection SearchResults{
            get { return super.getCollection(SBO_EnosixWarehouseStock_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }
    }
    
    public EnosixWarehouseStock_SR execute() 
    {
        return (EnosixWarehouseStock_SR)super.executeSearch();
    }

    	public class SEARCHPARAMS extends ENSX.EnosixFramework.ValueObject {	
				public String X_SpecialStock
		{ 
			get { return this.getString ('X_SPECIALSTOCK'); } 
			set { this.Set (value, 'X_SPECIALSTOCK'); }
		}

		public String X_DisplayBatchStock
		{ 
			get { return this.getString ('X_BATCH'); } 
			set { this.Set (value, 'X_BATCH'); }
		}

		public String X_DisplayNoZeroStockLines
		{ 
			get { return this.getString ('X_NOZEROSTOCK'); } 
			set { this.Set (value, 'X_NOZEROSTOCK'); }
		}

		public Integer MAXROWS
		{ 
			get { return this.getInteger ('MAXROWS'); } 
			set { this.Set (value, 'MAXROWS'); }
		}

	}
		public class MATERIALSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public String High
		{ 
			get { return this.getString ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class MATDESCSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

	}
		public class PLANTSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public String High
		{ 
			get { return this.getString ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class STORAGELOCSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public String High
		{ 
			get { return this.getString ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class BATCHSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public String High
		{ 
			get { return this.getString ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class MATERIALTYSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public String High
		{ 
			get { return this.getString ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class MATERIALGRPSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public String High
		{ 
			get { return this.getString ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class SPECIALSTKTYSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public String High
		{ 
			get { return this.getString ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class POSTINGDTSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public Date Low
		{ 
			get { return this.getDate ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public Date High
		{ 
			get { return this.getDate ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class MOVEMENTTYSEARCH extends ENSX.EnosixFramework.ValueObject {	
				public String Sign
		{ 
			get { return this.getString ('ENSX_SIGN'); } 
			set { this.Set (value, 'ENSX_SIGN'); }
		}

		public String Option
		{ 
			get { return this.getString ('ENSX_OPTION'); } 
			set { this.Set (value, 'ENSX_OPTION'); }
		}

		public String Low
		{ 
			get { return this.getString ('ENSX_LOW'); } 
			set { this.Set (value, 'ENSX_LOW'); }
		}

		public String High
		{ 
			get { return this.getString ('ENSX_HIGH'); } 
			set { this.Set (value, 'ENSX_HIGH'); }
		}

	}
		public class SEARCHRESULT extends ENSX.EnosixFramework.ValueObject {	
				public String Material
		{ 
			get { return this.getString ('MATNR'); } 
			set { this.Set (value, 'MATNR'); }
		}

		public String MaterialDescription
		{ 
			get { return this.getString ('MAKTX'); } 
			set { this.Set (value, 'MAKTX'); }
		}

		public String Plant
		{ 
			get { return this.getString ('WERKS'); } 
			set { this.Set (value, 'WERKS'); }
		}

		public String StorageLocation
		{ 
			get { return this.getString ('LGORT'); } 
			set { this.Set (value, 'LGORT'); }
		}

		public String StorageLocationDescription
		{ 
			get { return this.getString ('LGOBE'); } 
			set { this.Set (value, 'LGOBE'); }
		}

		public String MaterialType
		{ 
			get { return this.getString ('MTART'); } 
			set { this.Set (value, 'MTART'); }
		}

		public String MaterialGroup
		{ 
			get { return this.getString ('MATKL'); } 
			set { this.Set (value, 'MATKL'); }
		}

		public String SpecialStockInd
		{ 
			get { return this.getString ('SOBKZ'); } 
			set { this.Set (value, 'SOBKZ'); }
		}

		public String ValuationofSpecialStock
		{ 
			get { return this.getString ('KZBWS'); } 
			set { this.Set (value, 'KZBWS'); }
		}

		public String SpecialStockNumber
		{ 
			get { return this.getString ('SSNUM'); } 
			set { this.Set (value, 'SSNUM'); }
		}

		public String DeletionFLag
		{ 
			get { return this.getString ('LVORM'); } 
			set { this.Set (value, 'LVORM'); }
		}

		public String BatchNumber
		{ 
			get { return this.getString ('CHARG'); } 
			set { this.Set (value, 'CHARG'); }
		}

		public String QuantityUOM
		{ 
			get { return this.getString ('MEINS'); } 
			set { this.Set (value, 'MEINS'); }
		}

		public String Currencies
		{ 
			get { return this.getString ('CURRENCIES'); } 
			set { this.Set (value, 'CURRENCIES'); }
		}

		public Decimal UnrestrictedStock
		{ 
			get { return this.getDecimal ('UNRES_QUAN'); } 
			set { this.Set (value, 'UNRES_QUAN'); }
		}

		public Decimal UnrestrictedValue
		{ 
			get { return this.getDecimal ('UNRES_VALUE'); } 
			set { this.Set (value, 'UNRES_VALUE'); }
		}

		public Decimal TransitTransferStock
		{ 
			get { return this.getDecimal ('TRANSIT_QUAN'); } 
			set { this.Set (value, 'TRANSIT_QUAN'); }
		}

		public Decimal TransitTransferValue
		{ 
			get { return this.getDecimal ('TRANSIT_VALUE'); } 
			set { this.Set (value, 'TRANSIT_VALUE'); }
		}

		public Decimal QualityInspectionStock
		{ 
			get { return this.getDecimal ('QUALITY_QUAN'); } 
			set { this.Set (value, 'QUALITY_QUAN'); }
		}

		public Decimal QualityInspectionValue
		{ 
			get { return this.getDecimal ('QUALITY_VALUE'); } 
			set { this.Set (value, 'QUALITY_VALUE'); }
		}

		public Decimal RestrictedStock
		{ 
			get { return this.getDecimal ('RESTR_QUAN'); } 
			set { this.Set (value, 'RESTR_QUAN'); }
		}

		public Decimal RestrictedValue
		{ 
			get { return this.getDecimal ('RESTR_VALUE'); } 
			set { this.Set (value, 'RESTR_VALUE'); }
		}

		public Decimal BlockedStock
		{ 
			get { return this.getDecimal ('BLOCKED_QUAN'); } 
			set { this.Set (value, 'BLOCKED_QUAN'); }
		}

		public Decimal BlockedValue
		{ 
			get { return this.getDecimal ('BLOCKED_VALUE'); } 
			set { this.Set (value, 'BLOCKED_VALUE'); }
		}

		public Decimal ReturnsStock
		{ 
			get { return this.getDecimal ('RETURN_QUAN'); } 
			set { this.Set (value, 'RETURN_QUAN'); }
		}

		public Decimal ReturnsValue
		{ 
			get { return this.getDecimal ('RETURN_VALUE'); } 
			set { this.Set (value, 'RETURN_VALUE'); }
		}

		public String SystemID
		{ 
			get { return this.getString ('SYSTEM_ID'); } 
			set { this.Set (value, 'SYSTEM_ID'); }
		}

	}
	
}
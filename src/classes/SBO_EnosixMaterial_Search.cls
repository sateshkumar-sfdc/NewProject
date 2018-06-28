/// enosiX Inc. Generated Apex Model
/// Generated On: 1/12/2017 2:37:35 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixMaterial_Search extends ENSX.EnosixFramework.SearchSBO {
    
    public SBO_EnosixMaterial_Search() {
        super('EnosixMaterial', SBO_EnosixMaterial_Search.EnosixMaterial_SC.class, SBO_EnosixMaterial_Search.EnosixMaterial_SR.class);
    }
    
	public override Type getType() { return SBO_EnosixMaterial_Search.class; }

    public class EnosixMaterial_SC extends ENSX.EnosixFramework.SearchContext { 		
        public EnosixMaterial_SC() {		
            super(new Map<string,type>		
            {		
                'SEARCHPARAMS' => SBO_EnosixMaterial_Search.SEARCHPARAMS.class
,'MATERIAL_TYPE' => SBO_EnosixMaterial_Search.MATERIAL_TYPE.class
,'PRODUCT_ATTRIB' => SBO_EnosixMaterial_Search.PRODUCT_ATTRIB.class
		
            });		
        }

		public override Type getType() { return SBO_EnosixMaterial_Search.EnosixMaterial_SC.class; }

        public SBO_EnosixMaterial_Search.SEARCHPARAMS SEARCHPARAMS { 
            get 
            { 
                return (SEARCHPARAMS)this.getStruct(SBO_EnosixMaterial_Search.SEARCHPARAMS.class);		
            } 
        } 

	    public ENSX.EnosixFramework.FrameworkCollection MATERIAL_TYPE { 
            get 
            { 
                return this.getCollection(SBO_EnosixMaterial_Search.MATERIAL_TYPE.class);		
            }
		}
	    public ENSX.EnosixFramework.FrameworkCollection PRODUCT_ATTRIB { 
            get 
            { 
                return this.getCollection(SBO_EnosixMaterial_Search.PRODUCT_ATTRIB.class);		
            }
		}
    }		

    public EnosixMaterial_SC SearchContext 		
    {		
        get { return ( EnosixMaterial_SC)this.getSearchContext(); }		
    }		

    public class EnosixMaterial_SR extends ENSX.EnosixFramework.SearchResult 
    {
        public EnosixMaterial_SR() {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_EnosixMaterial_Search.SEARCHRESULT.class } );
        }
        
        public ENSX.EnosixFramework.FrameworkCollection SearchResults{
            get { return super.getCollection(SBO_EnosixMaterial_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

		public override Type getType() { return SBO_EnosixMaterial_Search.EnosixMaterial_SR.class; }
    }
    
    public EnosixMaterial_SR execute() 
    {
        return (EnosixMaterial_SR)super.executeSearch();
    }

    	public class SEARCHPARAMS extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixMaterial_Search.SEARCHPARAMS.class; }

				public String MaterialNumberFrom
		{ 
			get { return this.getString ('MATNR_FR'); } 
			set { this.Set (value, 'MATNR_FR'); }
		}

		public String MaterialNumberTo
		{ 
			get { return this.getString ('MATNR_TO'); } 
			set { this.Set (value, 'MATNR_TO'); }
		}

		public String MaterialDescription
		{ 
			get { return this.getString ('MAKTX'); } 
			set { this.Set (value, 'MAKTX'); }
		}

		public String SalesOrganization
		{ 
			get { return this.getString ('VKORG'); } 
			set { this.Set (value, 'VKORG'); }
		}

		public String DistributionChannel
		{ 
			get { return this.getString ('VTWEG'); } 
			set { this.Set (value, 'VTWEG'); }
		}

		public String MaterialGroup
		{ 
			get { return this.getString ('MATKL'); } 
			set { this.Set (value, 'MATKL'); }
		}

		public String ProductHierarchy
		{ 
			get { return this.getString ('PRODH'); } 
			set { this.Set (value, 'PRODH'); }
		}

		public String CrossPlantMaterialStatus
		{ 
			get { return this.getString ('MSTAE'); } 
			set { this.Set (value, 'MSTAE'); }
		}

		public Date FromCreateDate
		{ 
			get { return this.getDate ('ERSDA_FR'); } 
			set { this.Set (value, 'ERSDA_FR'); }
		}

		public Date ToCreateDate
		{ 
			get { return this.getDate ('ERSDA_TO'); } 
			set { this.Set (value, 'ERSDA_TO'); }
		}

		public Date FromChangeDate
		{ 
			get { return this.getDate ('LAEDA_FR'); } 
			set { this.Set (value, 'LAEDA_FR'); }
		}

		public Date ToChangeDate
		{ 
			get { return this.getDate ('LAEDA_TO'); } 
			set { this.Set (value, 'LAEDA_TO'); }
		}

	}
		public class MATERIAL_TYPE extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixMaterial_Search.MATERIAL_TYPE.class; }

				public String MaterialType
		{ 
			get { return this.getString ('MTART'); } 
			set { this.Set (value, 'MTART'); }
		}

	}
		public class PRODUCT_ATTRIB extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixMaterial_Search.PRODUCT_ATTRIB.class; }

				public String ProductAttribute
		{ 
			get { return this.getString ('PRODUCT_ATTRIB'); } 
			set { this.Set (value, 'PRODUCT_ATTRIB'); }
		}

	}
		public class SEARCHRESULT extends ENSX.EnosixFramework.ValueObject {

		public override Type getType() { return SBO_EnosixMaterial_Search.SEARCHRESULT.class; }

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

		public String MaterialType
		{ 
			get { return this.getString ('MTART'); } 
			set { this.Set (value, 'MTART'); }
		}

		public String MaterialTypeDescription
		{ 
			get { return this.getString ('MTART_MTBEZ'); } 
			set { this.Set (value, 'MTART_MTBEZ'); }
		}

		public String MaterialGroup
		{ 
			get { return this.getString ('MATKL'); } 
			set { this.Set (value, 'MATKL'); }
		}

		public String SalesOrganization
		{ 
			get { return this.getString ('VKORG'); } 
			set { this.Set (value, 'VKORG'); }
		}

		public String DistributionChannel
		{ 
			get { return this.getString ('VTWEG'); } 
			set { this.Set (value, 'VTWEG'); }
		}

		public String ProductHierarchy
		{ 
			get { return this.getString ('PRODH'); } 
			set { this.Set (value, 'PRODH'); }
		}

		public String ProductHierarchyDescription
		{ 
			get { return this.getString ('PRODH_TEXT'); } 
			set { this.Set (value, 'PRODH_TEXT'); }
		}

		public String CrossPlantMaterialStatus
		{ 
			get { return this.getString ('MSTAE'); } 
			set { this.Set (value, 'MSTAE'); }
		}

		public String MaterialStatusDescription
		{ 
			get { return this.getString ('MTSTB'); } 
			set { this.Set (value, 'MTSTB'); }
		}

		public Date CreationDate
		{ 
			get { return this.getDate ('ERSDA'); } 
			set { this.Set (value, 'ERSDA'); }
		}

		public Date ChangeDate
		{ 
			get { return this.getDate ('LAEDA'); } 
			set { this.Set (value, 'LAEDA'); }
		}

		public String AlternateUnitOfMeasure
		{ 
			get { return this.getString ('MEINH'); } 
			set { this.Set (value, 'MEINH'); }
		}

		public Decimal NumeratorForConversion
		{ 
			get { return this.getDecimal ('UMREZ'); } 
			set { this.Set (value, 'UMREZ'); }
		}

		public Decimal DenominatorForConversion
		{ 
			get { return this.getDecimal ('UMREN'); } 
			set { this.Set (value, 'UMREN'); }
		}

		public Decimal Quotient
		{ 
			get { return this.getDecimal ('QUOTIENT'); } 
			set { this.Set (value, 'QUOTIENT'); }
		}

	}
	
}
/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixMaterial_Detail extends ENSX.EnosixFramework.DetailSBO {
    
    public SBO_EnosixMaterial_Detail() {
    	super('EnosixMaterial', SBO_EnosixMaterial_Detail.EnosixMaterial.class);
    }

	public override Type getType() { return SBO_EnosixMaterial_Detail.class; }

	public EnosixMaterial initialize(EnosixMaterial obj) {
    	return (EnosixMaterial)this.executeInitialize(obj);
    }
    
    public EnosixMaterial getDetail(object key) {
    	return (EnosixMaterial)this.executeGetDetail(key);
    }
    
    public EnosixMaterial save(EnosixMaterial obj) {
    	return (EnosixMaterial) this.executeSave(obj);
    }

    public EnosixMaterial command(string command, EnosixMaterial obj) {
    	return (EnosixMaterial) this.executeCommand(command, obj);
    }
    
    public with sharing class EnosixMaterial extends ENSX.EnosixFramework.DetailObject {
     	public EnosixMaterial() {
			super('HEADER', new Map<string,type>{'BASIC_DATA_1' => SBO_EnosixMaterial_Detail.BASIC_DATA_1.class
,'BASIC_DATA_2' => SBO_EnosixMaterial_Detail.BASIC_DATA_2.class
,'PLANT_DATA' => SBO_EnosixMaterial_Detail.PLANT_DATA.class
});	
    	}

		public override Type getType() { return SBO_EnosixMaterial_Detail.EnosixMaterial.class; }

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

		public String MaterialDescriptionUpperCase
		{ 
			get { return this.getString ('MAKTG'); } 
			set { this.Set (value, 'MAKTG'); }
		}


		public SBO_EnosixMaterial_Detail.BASIC_DATA_1 BASIC_DATA_1 {
			get { return (SBO_EnosixMaterial_Detail.BASIC_DATA_1)this.getStruct(SBO_EnosixMaterial_Detail.BASIC_DATA_1.class); }
		}
		
		
		public SBO_EnosixMaterial_Detail.BASIC_DATA_2 BASIC_DATA_2 {
			get { return (SBO_EnosixMaterial_Detail.BASIC_DATA_2)this.getStruct(SBO_EnosixMaterial_Detail.BASIC_DATA_2.class); }
		}
		
				
		public ENSX.EnosixFramework.FrameworkCollection PLANT_DATA {
    		get { return this.getCollection(SBO_EnosixMaterial_Detail.PLANT_DATA.class); }
    	}

				
	}

	//Write child objects
	public class BASIC_DATA_1 extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixMaterial_Detail.BASIC_DATA_1.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String Material
		{ 
			get { return this.getString ('MATNR'); } 
			set { this.Set (value, 'MATNR'); }
		}

		public String QuantityUOM
		{ 
			get { return this.getString ('MEINS'); } 
			set { this.Set (value, 'MEINS'); }
		}

		public String OldMaterialNumber
		{ 
			get { return this.getString ('BISMT'); } 
			set { this.Set (value, 'BISMT'); }
		}

		public String Division
		{ 
			get { return this.getString ('SPART'); } 
			set { this.Set (value, 'SPART'); }
		}

		public String AllocationDeterminationProcedure
		{ 
			get { return this.getString ('KOSCH'); } 
			set { this.Set (value, 'KOSCH'); }
		}

		public String CrossPlantMaterialStatus
		{ 
			get { return this.getString ('MSTAE'); } 
			set { this.Set (value, 'MSTAE'); }
		}

		public String OverrideChangeNumbers
		{ 
			get { return this.getString ('KZEFF'); } 
			set { this.Set (value, 'KZEFF'); }
		}

		public String MaterialGroup
		{ 
			get { return this.getString ('MATKL'); } 
			set { this.Set (value, 'MATKL'); }
		}

		public String ExternalMaterialGroup
		{ 
			get { return this.getString ('EXTWG'); } 
			set { this.Set (value, 'EXTWG'); }
		}

		public String Laboratory
		{ 
			get { return this.getString ('LABOR'); } 
			set { this.Set (value, 'LABOR'); }
		}

		public Date CrossPlantStatusValidDate
		{ 
			get { return this.getDate ('MSTDE'); } 
			set { this.Set (value, 'MSTDE'); }
		}

		public String GeneralItemCategoryGroup
		{ 
			get { return this.getString ('MTPOS_MARA'); } 
			set { this.Set (value, 'MTPOS_MARA'); }
		}

		public String AuthorizationGroup
		{ 
			get { return this.getString ('BEGRU'); } 
			set { this.Set (value, 'BEGRU'); }
		}

		public Decimal GrossWeight
		{ 
			get { return this.getDecimal ('BRGEW'); } 
			set { this.Set (value, 'BRGEW'); }
		}

		public String WeightUnit
		{ 
			get { return this.getString ('GEWEI'); } 
			set { this.Set (value, 'GEWEI'); }
		}

		public Decimal Netweight
		{ 
			get { return this.getDecimal ('NTGEW'); } 
			set { this.Set (value, 'NTGEW'); }
		}

		public Decimal Volume
		{ 
			get { return this.getDecimal ('VOLUM'); } 
			set { this.Set (value, 'VOLUM'); }
		}

		public String VolumeUnit
		{ 
			get { return this.getString ('VOLEH'); } 
			set { this.Set (value, 'VOLEH'); }
		}

		public String SizeDimensions
		{ 
			get { return this.getString ('GROES'); } 
			set { this.Set (value, 'GROES'); }
		}

		public String EANUPC
		{ 
			get { return this.getString ('EAN11'); } 
			set { this.Set (value, 'EAN11'); }
		}

		public String EANUPCCategory
		{ 
			get { return this.getString ('NUMTP'); } 
			set { this.Set (value, 'NUMTP'); }
		}

		public String MaterialGroupPackagingMaterials
		{ 
			get { return this.getString ('MAGRV'); } 
			set { this.Set (value, 'MAGRV'); }
		}

		public String ReferenceMaterialPackedInSameWay
		{ 
			get { return this.getString ('RMATP'); } 
			set { this.Set (value, 'RMATP'); }
		}

}
public class BASIC_DATA_2 extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixMaterial_Detail.BASIC_DATA_2.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String ANSIISODescription
		{ 
			get { return this.getString ('NORMT'); } 
			set { this.Set (value, 'NORMT'); }
		}

		public String CADIndicator
		{ 
			get { return this.getString ('CADKZ'); } 
			set { this.Set (value, 'CADKZ'); }
		}

		public String BasicMaterial
		{ 
			get { return this.getString ('WRKST'); } 
			set { this.Set (value, 'WRKST'); }
		}

		public String IntrastatDataTransportMedium
		{ 
			get { return this.getString ('MEDIUM'); } 
			set { this.Set (value, 'MEDIUM'); }
		}

		public String DangerousGoodsIndicator
		{ 
			get { return this.getString ('PROFL'); } 
			set { this.Set (value, 'PROFL'); }
		}

		public String DangerousGoodsPackagingStatus
		{ 
			get { return this.getString ('DG_PACK_STATUS'); } 
			set { this.Set (value, 'DG_PACK_STATUS'); }
		}

		public String PackagingCode
		{ 
			get { return this.getString ('PACKCODE'); } 
			set { this.Set (value, 'PACKCODE'); }
		}

		public String EnvironmentallyRelevant
		{ 
			get { return this.getString ('KZUMW'); } 
			set { this.Set (value, 'KZUMW'); }
		}

		public String InBulkIndicator
		{ 
			get { return this.getString ('ILOOS'); } 
			set { this.Set (value, 'ILOOS'); }
		}

		public String HighlyViscousIndicator
		{ 
			get { return this.getString ('IHIVI'); } 
			set { this.Set (value, 'IHIVI'); }
		}

		public String NonDMSDocumentNumber
		{ 
			get { return this.getString ('ZEINR'); } 
			set { this.Set (value, 'ZEINR'); }
		}

		public String NonDMSDocumentType
		{ 
			get { return this.getString ('ZEIAR'); } 
			set { this.Set (value, 'ZEIAR'); }
		}

		public String NonDMSDocumentVersion
		{ 
			get { return this.getString ('ZEIVR'); } 
			set { this.Set (value, 'ZEIVR'); }
		}

		public String NonDMSDocumentPageNumber
		{ 
			get { return this.getString ('BLATT'); } 
			set { this.Set (value, 'BLATT'); }
		}

		public String NonDMSDocumentChangeNumber
		{ 
			get { return this.getString ('AESZN'); } 
			set { this.Set (value, 'AESZN'); }
		}

		public String NonDMSDocumentPageFormat
		{ 
			get { return this.getString ('ZEIFO'); } 
			set { this.Set (value, 'ZEIFO'); }
		}

		public String NonDMSDocumentNumberOfSheets
		{ 
			get { return this.getString ('BLANZ'); } 
			set { this.Set (value, 'BLANZ'); }
		}

		public String CrossPlantConfigurableMaterial
		{ 
			get { return this.getString ('SATNR'); } 
			set { this.Set (value, 'SATNR'); }
		}

		public String ConfigurableMaterial
		{ 
			get { return this.getString ('KZKFG'); } 
			set { this.Set (value, 'KZKFG'); }
		}

		public String GlobalDataSyncIndicator
		{ 
			get { return this.getString ('GDS_RELEVANT'); } 
			set { this.Set (value, 'GDS_RELEVANT'); }
		}

}
public class PLANT_DATA extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixMaterial_Detail.PLANT_DATA.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'WERKS','VKORG','VTWEG' };
	
		return keyFields;
	}

			public String Plant
		{ 
			get { return this.getString ('WERKS'); } 
			set { this.Set (value, 'WERKS'); }
		}

		public String Name
		{ 
			get { return this.getString ('NAME1'); } 
			set { this.Set (value, 'NAME1'); }
		}

		public String SalesOrganization
		{ 
			get { return this.getString ('VKORG'); } 
			set { this.Set (value, 'VKORG'); }
		}

		public String VKORG_TEXT
		{ 
			get { return this.getString ('VKORG_TEXT'); } 
			set { this.Set (value, 'VKORG_TEXT'); }
		}

		public String DistributionChannel
		{ 
			get { return this.getString ('VTWEG'); } 
			set { this.Set (value, 'VTWEG'); }
		}

		public String VTWEG_TEXT
		{ 
			get { return this.getString ('VTWEG_TEXT'); } 
			set { this.Set (value, 'VTWEG_TEXT'); }
		}

}
}
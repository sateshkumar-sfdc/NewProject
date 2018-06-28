/// enosiX Inc. Generated Apex Model
/// Generated On: 5/12/17 1:59:32 PM
/// SAP Host: yeti-sfdc-api.enosix.com
/// CID: S4H

public with sharing class SBO_EnosixRO_Detail extends ENSX.EnosixFramework.DetailSBO {
    
    public SBO_EnosixRO_Detail() {
    	super('EnosixRO', SBO_EnosixRO_Detail.EnosixRO.class);
    }

	public override Type getType() { return SBO_EnosixRO_Detail.class; }

	public EnosixRO initialize(EnosixRO obj) {
    	return (EnosixRO)this.executeInitialize(obj);
    }
    
    public EnosixRO getDetail(object key) {
    	return (EnosixRO)this.executeGetDetail(key);
    }
    
    public EnosixRO save(EnosixRO obj) {
    	return (EnosixRO) this.executeSave(obj);
    }

    public EnosixRO command(string command, EnosixRO obj) {
    	return (EnosixRO) this.executeCommand(command, obj);
    }
    
    public with sharing class EnosixRO extends ENSX.EnosixFramework.DetailObject {
     	public EnosixRO() {
			super('HEADER', new Map<string,type>{'SALES' => SBO_EnosixRO_Detail.SALES.class
,'SHIPPING' => SBO_EnosixRO_Detail.SHIPPING.class
,'BILLING' => SBO_EnosixRO_Detail.BILLING.class
,'ACCOUNTING' => SBO_EnosixRO_Detail.ACCOUNTING.class
,'CONDITIONS' => SBO_EnosixRO_Detail.CONDITIONS.class
,'ACCOUNT_ASSIGNMENT' => SBO_EnosixRO_Detail.ACCOUNT_ASSIGNMENT.class
,'PARTNERS' => SBO_EnosixRO_Detail.PARTNERS.class
,'TEXTS' => SBO_EnosixRO_Detail.TEXTS.class
,'ORDERDATA' => SBO_EnosixRO_Detail.ORDERDATA.class
,'STATUS' => SBO_EnosixRO_Detail.STATUS.class
,'ADDITIONAL_DATA_A' => SBO_EnosixRO_Detail.ADDITIONAL_DATA_A.class
,'ITEMS' => SBO_EnosixRO_Detail.ITEMS.class
,'ITEMS_SCHEDULE' => SBO_EnosixRO_Detail.ITEMS_SCHEDULE.class
,'ITEMS_ARM' => SBO_EnosixRO_Detail.ITEMS_ARM.class
,'ITEMS_TEXT' => SBO_EnosixRO_Detail.ITEMS_TEXT.class
,'MATERIAL_UOM' => SBO_EnosixRO_Detail.MATERIAL_UOM.class
,'CCARD' => SBO_EnosixRO_Detail.CCARD.class
,'ITEMS_ACTION' => SBO_EnosixRO_Detail.ITEMS_ACTION.class
});	
    	}

		public override Type getType() { return SBO_EnosixRO_Detail.EnosixRO.class; }

				public String SalesDocument
		{ 
			get { return this.getString ('VBELN'); } 
			set { this.Set (value, 'VBELN'); }
		}

		public String SoldToParty
		{ 
			get { return this.getString ('KUNAG'); } 
			set { this.Set (value, 'KUNAG'); }
		}

		public String SoldToPartyText
		{ 
			get { return this.getString ('KUNAG_TXTPA'); } 
			set { this.Set (value, 'KUNAG_TXTPA'); }
		}

		public String CustomerPurchaseOrderNumber
		{ 
			get { return this.getString ('BSTKD'); } 
			set { this.Set (value, 'BSTKD'); }
		}

		public Date CustomerPurchaseOrderDate
		{ 
			get { return this.getDate ('BSTDK'); } 
			set { this.Set (value, 'BSTDK'); }
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

		public Decimal NetReturnValue
		{ 
			get { return this.getDecimal ('NETWR_R'); } 
			set { this.Set (value, 'NETWR_R'); }
		}

		public Decimal NetReturnTax
		{ 
			get { return this.getDecimal ('MWSBP_R'); } 
			set { this.Set (value, 'MWSBP_R'); }
		}

		public Decimal NetReplacementValue
		{ 
			get { return this.getDecimal ('NETWR_D'); } 
			set { this.Set (value, 'NETWR_D'); }
		}

		public Decimal NetReplacementTax
		{ 
			get { return this.getDecimal ('MWSBP_D'); } 
			set { this.Set (value, 'MWSBP_D'); }
		}

		public String SalesDocumentCurrency
		{ 
			get { return this.getString ('WAERK'); } 
			set { this.Set (value, 'WAERK'); }
		}

		public String BillingPlan
		{ 
			get { return this.getString ('RPLNR'); } 
			set { this.Set (value, 'RPLNR'); }
		}

		public String OrderReason
		{ 
			get { return this.getString ('AUGRU'); } 
			set { this.Set (value, 'AUGRU'); }
		}

		public String OrderReasonDescription
		{ 
			get { return this.getString ('AUGRU_BEZEI'); } 
			set { this.Set (value, 'AUGRU_BEZEI'); }
		}

		public String ProcessIDNumber
		{ 
			get { return this.getString ('MSR_ID'); } 
			set { this.Set (value, 'MSR_ID'); }
		}


		public SBO_EnosixRO_Detail.SALES SALES {
			get { return (SBO_EnosixRO_Detail.SALES)this.getStruct(SBO_EnosixRO_Detail.SALES.class); }
		}
		
		
		public SBO_EnosixRO_Detail.SHIPPING SHIPPING {
			get { return (SBO_EnosixRO_Detail.SHIPPING)this.getStruct(SBO_EnosixRO_Detail.SHIPPING.class); }
		}
		
		
		public SBO_EnosixRO_Detail.BILLING BILLING {
			get { return (SBO_EnosixRO_Detail.BILLING)this.getStruct(SBO_EnosixRO_Detail.BILLING.class); }
		}
		
		
		public SBO_EnosixRO_Detail.ACCOUNTING ACCOUNTING {
			get { return (SBO_EnosixRO_Detail.ACCOUNTING)this.getStruct(SBO_EnosixRO_Detail.ACCOUNTING.class); }
		}
		
				
		public ENSX.EnosixFramework.FrameworkCollection CONDITIONS {
    		get { return this.getCollection(SBO_EnosixRO_Detail.CONDITIONS.class); }
    	}

		
		public SBO_EnosixRO_Detail.ACCOUNT_ASSIGNMENT ACCOUNT_ASSIGNMENT {
			get { return (SBO_EnosixRO_Detail.ACCOUNT_ASSIGNMENT)this.getStruct(SBO_EnosixRO_Detail.ACCOUNT_ASSIGNMENT.class); }
		}
		
				
		public ENSX.EnosixFramework.FrameworkCollection PARTNERS {
    		get { return this.getCollection(SBO_EnosixRO_Detail.PARTNERS.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection TEXTS {
    		get { return this.getCollection(SBO_EnosixRO_Detail.TEXTS.class); }
    	}

		
		public SBO_EnosixRO_Detail.ORDERDATA ORDERDATA {
			get { return (SBO_EnosixRO_Detail.ORDERDATA)this.getStruct(SBO_EnosixRO_Detail.ORDERDATA.class); }
		}
		
		
		public SBO_EnosixRO_Detail.STATUS STATUS {
			get { return (SBO_EnosixRO_Detail.STATUS)this.getStruct(SBO_EnosixRO_Detail.STATUS.class); }
		}
		
		
		public SBO_EnosixRO_Detail.ADDITIONAL_DATA_A ADDITIONAL_DATA_A {
			get { return (SBO_EnosixRO_Detail.ADDITIONAL_DATA_A)this.getStruct(SBO_EnosixRO_Detail.ADDITIONAL_DATA_A.class); }
		}
		
				
		public ENSX.EnosixFramework.FrameworkCollection ITEMS {
    		get { return this.getCollection(SBO_EnosixRO_Detail.ITEMS.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection ITEMS_SCHEDULE {
    		get { return this.getCollection(SBO_EnosixRO_Detail.ITEMS_SCHEDULE.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection ITEMS_ARM {
    		get { return this.getCollection(SBO_EnosixRO_Detail.ITEMS_ARM.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection ITEMS_TEXT {
    		get { return this.getCollection(SBO_EnosixRO_Detail.ITEMS_TEXT.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection MATERIAL_UOM {
    		get { return this.getCollection(SBO_EnosixRO_Detail.MATERIAL_UOM.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection CCARD {
    		get { return this.getCollection(SBO_EnosixRO_Detail.CCARD.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection ITEMS_ACTION {
    		get { return this.getCollection(SBO_EnosixRO_Detail.ITEMS_ACTION.class); }
    	}

				
	}

	//Write child objects
	public class SALES extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.SALES.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
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

		public String SalesOrganization
		{ 
			get { return this.getString ('VKORG'); } 
			set { this.Set (value, 'VKORG'); }
		}

		public String SalesOrganizationName
		{ 
			get { return this.getString ('VKORG_VTEXT'); } 
			set { this.Set (value, 'VKORG_VTEXT'); }
		}

		public String DistributionChannel
		{ 
			get { return this.getString ('VTWEG'); } 
			set { this.Set (value, 'VTWEG'); }
		}

		public String DistributionChannelName
		{ 
			get { return this.getString ('VTWEG_VTEXT'); } 
			set { this.Set (value, 'VTWEG_VTEXT'); }
		}

		public String Division
		{ 
			get { return this.getString ('SPART'); } 
			set { this.Set (value, 'SPART'); }
		}

		public String DivisionName
		{ 
			get { return this.getString ('SPART_VTEXT'); } 
			set { this.Set (value, 'SPART_VTEXT'); }
		}

		public String SalesGroup
		{ 
			get { return this.getString ('VKGRP'); } 
			set { this.Set (value, 'VKGRP'); }
		}

		public String SalesGroupName
		{ 
			get { return this.getString ('VKGRP_BEZEI'); } 
			set { this.Set (value, 'VKGRP_BEZEI'); }
		}

		public String SalesOffice
		{ 
			get { return this.getString ('VKBUR'); } 
			set { this.Set (value, 'VKBUR'); }
		}

		public String SalesOfficeName
		{ 
			get { return this.getString ('VKBUR_BEZEI'); } 
			set { this.Set (value, 'VKBUR_BEZEI'); }
		}

		public Date CreateDate
		{ 
			get { return this.getDate ('ERDAT'); } 
			set { this.Set (value, 'ERDAT'); }
		}

		public Time EntryTime
		{ 
			get { return this.getTime ('ERZET'); } 
			set { this.Set (value, 'ERZET'); }
		}

		public String CreatedBy
		{ 
			get { return this.getString ('ERNAM'); } 
			set { this.Set (value, 'ERNAM'); }
		}

		public Date ValidFrom
		{ 
			get { return this.getDate ('ANGDT'); } 
			set { this.Set (value, 'ANGDT'); }
		}

		public Date ValidTo
		{ 
			get { return this.getDate ('BNDDT'); } 
			set { this.Set (value, 'BNDDT'); }
		}

		public String SalesDocumentVersionNumber
		{ 
			get { return this.getString ('VSNMR_V'); } 
			set { this.Set (value, 'VSNMR_V'); }
		}

		public Date WarrantyDate
		{ 
			get { return this.getDate ('GWLDT'); } 
			set { this.Set (value, 'GWLDT'); }
		}

		public String OrderReason
		{ 
			get { return this.getString ('AUGRU'); } 
			set { this.Set (value, 'AUGRU'); }
		}

		public String OrderReasonDescription
		{ 
			get { return this.getString ('AUGRU_BEZEI'); } 
			set { this.Set (value, 'AUGRU_BEZEI'); }
		}

		public String AgreedDeliveryTime
		{ 
			get { return this.getString ('DELCO'); } 
			set { this.Set (value, 'DELCO'); }
		}

		public String AgreedDeliveryTimeDescription
		{ 
			get { return this.getString ('DELCO_BEZEI'); } 
			set { this.Set (value, 'DELCO_BEZEI'); }
		}

		public String SalesDocumentCurrency
		{ 
			get { return this.getString ('WAERK'); } 
			set { this.Set (value, 'WAERK'); }
		}

		public Decimal ExchangeRatePriceDetermination
		{ 
			get { return this.getDecimal ('KURSK'); } 
			set { this.Set (value, 'KURSK'); }
		}

		public Date DateforPricingExchangeRate
		{ 
			get { return this.getDate ('PRSDT'); } 
			set { this.Set (value, 'PRSDT'); }
		}

		public String PricingProcedureInPricing
		{ 
			get { return this.getString ('KALSM'); } 
			set { this.Set (value, 'KALSM'); }
		}

		public String PricingProcedureInPricingDesc
		{ 
			get { return this.getString ('KALSM_VTEXT'); } 
			set { this.Set (value, 'KALSM_VTEXT'); }
		}

		public String CustomerGroup
		{ 
			get { return this.getString ('KDGRP'); } 
			set { this.Set (value, 'KDGRP'); }
		}

		public String CustomerGroupName
		{ 
			get { return this.getString ('KDGRP_KTEXT'); } 
			set { this.Set (value, 'KDGRP_KTEXT'); }
		}

		public String PriceListType
		{ 
			get { return this.getString ('PLTYP'); } 
			set { this.Set (value, 'PLTYP'); }
		}

		public String PriceListTypeText
		{ 
			get { return this.getString ('PLTYP_PTEXT'); } 
			set { this.Set (value, 'PLTYP_PTEXT'); }
		}

		public String UsageIndicator
		{ 
			get { return this.getString ('ABRVW'); } 
			set { this.Set (value, 'ABRVW'); }
		}

		public String UsageIndicatorDescription
		{ 
			get { return this.getString ('ABRVW_BEZEI'); } 
			set { this.Set (value, 'ABRVW_BEZEI'); }
		}

		public String PriceGroup
		{ 
			get { return this.getString ('KONDA'); } 
			set { this.Set (value, 'KONDA'); }
		}

		public String PriceGroupDescription
		{ 
			get { return this.getString ('KONDA_VTEXT'); } 
			set { this.Set (value, 'KONDA_VTEXT'); }
		}

		public String SalesDistrict
		{ 
			get { return this.getString ('BZIRK'); } 
			set { this.Set (value, 'BZIRK'); }
		}

		public String SalesDistrictName
		{ 
			get { return this.getString ('BZTXT'); } 
			set { this.Set (value, 'BZTXT'); }
		}

		public Date RequestedDeliveryDate
		{ 
			get { return this.getDate ('VDATU'); } 
			set { this.Set (value, 'VDATU'); }
		}

		public String DeliveryBlock
		{ 
			get { return this.getString ('LIFSK'); } 
			set { this.Set (value, 'LIFSK'); }
		}

		public String DeliveryBlockDescription
		{ 
			get { return this.getString ('LIFSK_VTEXT'); } 
			set { this.Set (value, 'LIFSK_VTEXT'); }
		}

		public String BillingBlock
		{ 
			get { return this.getString ('FAKSK'); } 
			set { this.Set (value, 'FAKSK'); }
		}

		public String BillingBlockDescription
		{ 
			get { return this.getString ('FAKSK_VTEXT'); } 
			set { this.Set (value, 'FAKSK_VTEXT'); }
		}

		public String TermsofPaymentKey
		{ 
			get { return this.getString ('ZTERM'); } 
			set { this.Set (value, 'ZTERM'); }
		}

		public String TermsofPaymentKeyDescription
		{ 
			get { return this.getString ('ZTERM_VTEXT'); } 
			set { this.Set (value, 'ZTERM_VTEXT'); }
		}

		public String IncotermsPart1
		{ 
			get { return this.getString ('INCO1'); } 
			set { this.Set (value, 'INCO1'); }
		}

		public String IncotermsPart1Description
		{ 
			get { return this.getString ('INCO1_BEZEI'); } 
			set { this.Set (value, 'INCO1_BEZEI'); }
		}

		public String IncotermsPart2
		{ 
			get { return this.getString ('INCO2'); } 
			set { this.Set (value, 'INCO2'); }
		}

}
public class SHIPPING extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.SHIPPING.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String ShipToParty
		{ 
			get { return this.getString ('KUNWE'); } 
			set { this.Set (value, 'KUNWE'); }
		}

		public String ShipToPartyText
		{ 
			get { return this.getString ('KUNWE_TXTPA'); } 
			set { this.Set (value, 'KUNWE_TXTPA'); }
		}

		public String UnloadingPoint
		{ 
			get { return this.getString ('ABLAD'); } 
			set { this.Set (value, 'ABLAD'); }
		}

		public String ReceivingPoint
		{ 
			get { return this.getString ('EMPST'); } 
			set { this.Set (value, 'EMPST'); }
		}

		public String DepartmentNumber
		{ 
			get { return this.getString ('ABTNR'); } 
			set { this.Set (value, 'ABTNR'); }
		}

		public String DepartmentNumberDescription
		{ 
			get { return this.getString ('ABTNR_VTEXT'); } 
			set { this.Set (value, 'ABTNR_VTEXT'); }
		}

		public String DeliveryBlock
		{ 
			get { return this.getString ('LIFSK'); } 
			set { this.Set (value, 'LIFSK'); }
		}

		public String DeliveryBlockDescription
		{ 
			get { return this.getString ('LIFSK_VTEXT'); } 
			set { this.Set (value, 'LIFSK_VTEXT'); }
		}

		public String ShippingConditions
		{ 
			get { return this.getString ('VSBED'); } 
			set { this.Set (value, 'VSBED'); }
		}

		public String ShippingConditionsDescription
		{ 
			get { return this.getString ('VSBED_VTEXT'); } 
			set { this.Set (value, 'VSBED_VTEXT'); }
		}

		public String DangerousGoodsMngmntProfile
		{ 
			get { return this.getString ('PROLI'); } 
			set { this.Set (value, 'PROLI'); }
		}

		public String DangerousGoodsMngmntProfDesc
		{ 
			get { return this.getString ('PROBZ'); } 
			set { this.Set (value, 'PROBZ'); }
		}

		public String MeansofTransportType
		{ 
			get { return this.getString ('TRATY'); } 
			set { this.Set (value, 'TRATY'); }
		}

		public String MeansofTransportTypDescription
		{ 
			get { return this.getString ('TRATY_VTEXT'); } 
			set { this.Set (value, 'TRATY_VTEXT'); }
		}

		public String MeansofTransport
		{ 
			get { return this.getString ('TRMTYP'); } 
			set { this.Set (value, 'TRMTYP'); }
		}

		public String MeansofTransportDescription
		{ 
			get { return this.getString ('TRMTYP_MAKTX'); } 
			set { this.Set (value, 'TRMTYP_MAKTX'); }
		}

		public String RelevantforPODprocessing
		{ 
			get { return this.getString ('PODKZ'); } 
			set { this.Set (value, 'PODKZ'); }
		}

		public String CompleteDeliveryDefined
		{ 
			get { return this.getString ('AUTLF'); } 
			set { this.Set (value, 'AUTLF'); }
		}

		public String OrderCombinationIndicator
		{ 
			get { return this.getString ('KZAZU'); } 
			set { this.Set (value, 'KZAZU'); }
		}

		public String DocumentContainsDangerousGoods
		{ 
			get { return this.getString ('CONT_DG'); } 
			set { this.Set (value, 'CONT_DG'); }
		}

		public String ShippingType
		{ 
			get { return this.getString ('VSART'); } 
			set { this.Set (value, 'VSART'); }
		}

		public String ShippingTypeDescription
		{ 
			get { return this.getString ('VSART_BEZEI'); } 
			set { this.Set (value, 'VSART_BEZEI'); }
		}

		public String SpecialProcessing
		{ 
			get { return this.getString ('SDABW'); } 
			set { this.Set (value, 'SDABW'); }
		}

		public String SpecialProcessingDescription
		{ 
			get { return this.getString ('SDABW_BEZEI'); } 
			set { this.Set (value, 'SDABW_BEZEI'); }
		}

		public Decimal TotalWeight
		{ 
			get { return this.getDecimal ('BTGEW'); } 
			set { this.Set (value, 'BTGEW'); }
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

}
public class BILLING extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.BILLING.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String Payer
		{ 
			get { return this.getString ('KUNRG'); } 
			set { this.Set (value, 'KUNRG'); }
		}

		public String PayerDisplayText
		{ 
			get { return this.getString ('KUNRG_TXTPA'); } 
			set { this.Set (value, 'KUNRG_TXTPA'); }
		}

		public String IncotermsPart1
		{ 
			get { return this.getString ('INCO1'); } 
			set { this.Set (value, 'INCO1'); }
		}

		public String IncotermsPart1Description
		{ 
			get { return this.getString ('INCO1_BEZEI'); } 
			set { this.Set (value, 'INCO1_BEZEI'); }
		}

		public String IncotermsPart2
		{ 
			get { return this.getString ('INCO2'); } 
			set { this.Set (value, 'INCO2'); }
		}

		public Date FixedValueDate
		{ 
			get { return this.getDate ('VALDT'); } 
			set { this.Set (value, 'VALDT'); }
		}

		public String TermsofPaymentKey
		{ 
			get { return this.getString ('ZTERM'); } 
			set { this.Set (value, 'ZTERM'); }
		}

		public String TermsofPaymentKeyDescription
		{ 
			get { return this.getString ('ZTERM_VTEXT'); } 
			set { this.Set (value, 'ZTERM_VTEXT'); }
		}

		public String AdditionalValueDays
		{ 
			get { return this.getString ('VALTG'); } 
			set { this.Set (value, 'VALTG'); }
		}

		public String BillingBlock
		{ 
			get { return this.getString ('FAKSK'); } 
			set { this.Set (value, 'FAKSK'); }
		}

		public String BillingBlockDescription
		{ 
			get { return this.getString ('FAKSK_VTEXT'); } 
			set { this.Set (value, 'FAKSK_VTEXT'); }
		}

		public String InvoiceDates
		{ 
			get { return this.getString ('PERFK'); } 
			set { this.Set (value, 'PERFK'); }
		}

		public String InvoiceDatesText
		{ 
			get { return this.getString ('PERFK_LTEXT'); } 
			set { this.Set (value, 'PERFK_LTEXT'); }
		}

		public Date BillingDate
		{ 
			get { return this.getDate ('FKDAT'); } 
			set { this.Set (value, 'FKDAT'); }
		}

		public String CompanyCodeToBeBilled
		{ 
			get { return this.getString ('BUKRS_VF'); } 
			set { this.Set (value, 'BUKRS_VF'); }
		}

		public String CompanyCodeToBeBilledText
		{ 
			get { return this.getString ('BUKRS_VF_LTEXT'); } 
			set { this.Set (value, 'BUKRS_VF_LTEXT'); }
		}

		public Date DateOnWhichServicesRendered
		{ 
			get { return this.getDate ('FBUDA'); } 
			set { this.Set (value, 'FBUDA'); }
		}

		public String AlternativeTaxClassification
		{ 
			get { return this.getString ('TAXK1'); } 
			set { this.Set (value, 'TAXK1'); }
		}

		public String AltTaxClassificationDescription
		{ 
			get { return this.getString ('TAXK1_VTEXT'); } 
			set { this.Set (value, 'TAXK1_VTEXT'); }
		}

		public String TaxDepartureCountry
		{ 
			get { return this.getString ('LANDTX'); } 
			set { this.Set (value, 'LANDTX'); }
		}

		public String TaxDepartureCountryName
		{ 
			get { return this.getString ('LANDTX_LANDX'); } 
			set { this.Set (value, 'LANDTX_LANDX'); }
		}

		public String TaxDestinationCountry
		{ 
			get { return this.getString ('STCEG_L'); } 
			set { this.Set (value, 'STCEG_L'); }
		}

		public String TaxDestinationCountryName
		{ 
			get { return this.getString ('STCEG_L_LANDX'); } 
			set { this.Set (value, 'STCEG_L_LANDX'); }
		}

		public String TriangularDeal
		{ 
			get { return this.getString ('XEGDR'); } 
			set { this.Set (value, 'XEGDR'); }
		}

		public String PaymentGuaranteeProcedure
		{ 
			get { return this.getString ('ABSSC'); } 
			set { this.Set (value, 'ABSSC'); }
		}

		public String PaymentGuaranteeProcedureDesc
		{ 
			get { return this.getString ('ABSSC_BEZEI'); } 
			set { this.Set (value, 'ABSSC_BEZEI'); }
		}

		public String InternalfinancialDocNumber
		{ 
			get { return this.getString ('LCNUM'); } 
			set { this.Set (value, 'LCNUM'); }
		}

		public Decimal DepreciationPercentage
		{ 
			get { return this.getDecimal ('AKPRZ'); } 
			set { this.Set (value, 'AKPRZ'); }
		}

}
public class ACCOUNTING extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ACCOUNTING.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String AccountAssignmentGroup
		{ 
			get { return this.getString ('KTGRD'); } 
			set { this.Set (value, 'KTGRD'); }
		}

		public String AccountAssignmentGroupDesc
		{ 
			get { return this.getString ('KTGRD_VTEXT'); } 
			set { this.Set (value, 'KTGRD_VTEXT'); }
		}

		public String PaymentMethod
		{ 
			get { return this.getString ('ZLSCH'); } 
			set { this.Set (value, 'ZLSCH'); }
		}

		public String PaymentMethodDescription
		{ 
			get { return this.getString ('ZLSCH_TEXT2'); } 
			set { this.Set (value, 'ZLSCH_TEXT2'); }
		}

		public String PostingPeriod
		{ 
			get { return this.getString ('POPER'); } 
			set { this.Set (value, 'POPER'); }
		}

		public String FiscalYear
		{ 
			get { return this.getString ('GJAHR'); } 
			set { this.Set (value, 'GJAHR'); }
		}

		public String AssignmentNumber
		{ 
			get { return this.getString ('ZUONR'); } 
			set { this.Set (value, 'ZUONR'); }
		}

		public Decimal ExchangeRateforFIpostings
		{ 
			get { return this.getDecimal ('KURRF'); } 
			set { this.Set (value, 'KURRF'); }
		}

		public String DunningKey
		{ 
			get { return this.getString ('MSCHL'); } 
			set { this.Set (value, 'MSCHL'); }
		}

		public String DunningKeyText
		{ 
			get { return this.getString ('MSCHL_TEXT1'); } 
			set { this.Set (value, 'MSCHL_TEXT1'); }
		}

		public String DunningBlock
		{ 
			get { return this.getString ('MANSP'); } 
			set { this.Set (value, 'MANSP'); }
		}

		public String DunningBlockText
		{ 
			get { return this.getString ('MANSP_TEXT1'); } 
			set { this.Set (value, 'MANSP_TEXT1'); }
		}

		public String ReferenceDocumentNumber
		{ 
			get { return this.getString ('XBLNR'); } 
			set { this.Set (value, 'XBLNR'); }
		}

}
public class CONDITIONS extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.CONDITIONS.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'KPOSN','STUNR','ZAEHK','KSCHL' };
	
		return keyFields;
	}

			public String ConditionNumber
		{ 
			get { return this.getString ('KNUMV'); } 
			set { this.Set (value, 'KNUMV'); }
		}

		public String ConditionItemNumber
		{ 
			get { return this.getString ('KPOSN'); } 
			set { this.Set (value, 'KPOSN'); }
		}

		public String StepNumber
		{ 
			get { return this.getString ('STUNR'); } 
			set { this.Set (value, 'STUNR'); }
		}

		public String ConditionCounter
		{ 
			get { return this.getString ('ZAEHK'); } 
			set { this.Set (value, 'ZAEHK'); }
		}

		public String ConditionType
		{ 
			get { return this.getString ('KSCHL'); } 
			set { this.Set (value, 'KSCHL'); }
		}

		public String ConditionTypeName
		{ 
			get { return this.getString ('KSCHL_VTEXT'); } 
			set { this.Set (value, 'KSCHL_VTEXT'); }
		}

		public Decimal Rate
		{ 
			get { return this.getDecimal ('KBETR'); } 
			set { this.Set (value, 'KBETR'); }
		}

		public String RateUnit
		{ 
			get { return this.getString ('KOEIN'); } 
			set { this.Set (value, 'KOEIN'); }
		}

		public Decimal ConditionPricingUnit
		{ 
			get { return this.getDecimal ('KPEIN'); } 
			set { this.Set (value, 'KPEIN'); }
		}

		public String ConditionUnit
		{ 
			get { return this.getString ('KMEIN'); } 
			set { this.Set (value, 'KMEIN'); }
		}

		public Decimal ConditionValue
		{ 
			get { return this.getDecimal ('KWERT'); } 
			set { this.Set (value, 'KWERT'); }
		}

		public String CurrencyKey
		{ 
			get { return this.getString ('WAERS'); } 
			set { this.Set (value, 'WAERS'); }
		}

		public Decimal CondValueforCumulationFields
		{ 
			get { return this.getDecimal ('KWERT_K'); } 
			set { this.Set (value, 'KWERT_K'); }
		}

		public String CondCurrencyforCumulationFlds
		{ 
			get { return this.getString ('KWAEH'); } 
			set { this.Set (value, 'KWAEH'); }
		}

		public String ConditionStatistics
		{ 
			get { return this.getString ('KSTAT'); } 
			set { this.Set (value, 'KSTAT'); }
		}

		public String KRECH
		{ 
			get { return this.getString ('KRECH'); } 
			set { this.Set (value, 'KRECH'); }
		}

		public String KMANU
		{ 
			get { return this.getString ('KMANU'); } 
			set { this.Set (value, 'KMANU'); }
		}

}
public class ACCOUNT_ASSIGNMENT extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ACCOUNT_ASSIGNMENT.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String BusinessArea
		{ 
			get { return this.getString ('GSBER'); } 
			set { this.Set (value, 'GSBER'); }
		}

		public String WBSElementInternal
		{ 
			get { return this.getString ('PS_PSP_PNR'); } 
			set { this.Set (value, 'PS_PSP_PNR'); }
		}

		public String WBSElement
		{ 
			get { return this.getString ('POSID'); } 
			set { this.Set (value, 'POSID'); }
		}

		public String WBSElementDescription
		{ 
			get { return this.getString ('POST1'); } 
			set { this.Set (value, 'POST1'); }
		}

}
public class PARTNERS extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.PARTNERS.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'PARVW','KUNNR','LIFNR','PERNR','PARNR' };
	
		return keyFields;
	}

			public String PartnerFunction
		{ 
			get { return this.getString ('PARVW'); } 
			set { this.Set (value, 'PARVW'); }
		}

		public String PartnerFunctionName
		{ 
			get { return this.getString ('PARVW_VTEXT'); } 
			set { this.Set (value, 'PARVW_VTEXT'); }
		}

		public String CustomerNumber
		{ 
			get { return this.getString ('KUNNR'); } 
			set { this.Set (value, 'KUNNR'); }
		}

		public String Vendor
		{ 
			get { return this.getString ('LIFNR'); } 
			set { this.Set (value, 'LIFNR'); }
		}

		public String PersonnelNumber
		{ 
			get { return this.getString ('PERNR'); } 
			set { this.Set (value, 'PERNR'); }
		}

		public String ContactPersonNumber
		{ 
			get { return this.getString ('PARNR'); } 
			set { this.Set (value, 'PARNR'); }
		}

		public String PartnerName
		{ 
			get { return this.getString ('NAME1'); } 
			set { this.Set (value, 'NAME1'); }
		}

		public String PartnerName2
		{ 
			get { return this.getString ('NAME2'); } 
			set { this.Set (value, 'NAME2'); }
		}

		public String HouseNumber
		{ 
			get { return this.getString ('HOUSE_NUM1'); } 
			set { this.Set (value, 'HOUSE_NUM1'); }
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

		public String RegionDescription
		{ 
			get { return this.getString ('REGIO_BEZEI'); } 
			set { this.Set (value, 'REGIO_BEZEI'); }
		}

		public String Country
		{ 
			get { return this.getString ('COUNTRY'); } 
			set { this.Set (value, 'COUNTRY'); }
		}

		public String CountryName
		{ 
			get { return this.getString ('COUNTRY_LANDX'); } 
			set { this.Set (value, 'COUNTRY_LANDX'); }
		}

		public String TimeZone
		{ 
			get { return this.getString ('TIME_ZONE'); } 
			set { this.Set (value, 'TIME_ZONE'); }
		}

		public String TimeZoneText
		{ 
			get { return this.getString ('TIME_ZONE_TEXT'); } 
			set { this.Set (value, 'TIME_ZONE_TEXT'); }
		}

		public String TransportationZone
		{ 
			get { return this.getString ('TRANSPZONE'); } 
			set { this.Set (value, 'TRANSPZONE'); }
		}

		public String TransportationZoneDescription
		{ 
			get { return this.getString ('TRANSPZONE_VTEXT'); } 
			set { this.Set (value, 'TRANSPZONE_VTEXT'); }
		}

		public String POBox
		{ 
			get { return this.getString ('PO_BOX'); } 
			set { this.Set (value, 'PO_BOX'); }
		}

		public String POBoxPostalCode
		{ 
			get { return this.getString ('POST_CODE2'); } 
			set { this.Set (value, 'POST_CODE2'); }
		}

		public String CompanyPostalCode
		{ 
			get { return this.getString ('POST_CODE3'); } 
			set { this.Set (value, 'POST_CODE3'); }
		}

		public String Language
		{ 
			get { return this.getString ('LANGU'); } 
			set { this.Set (value, 'LANGU'); }
		}

		public String LanguageDesc
		{ 
			get { return this.getString ('LANGU_SPTXT'); } 
			set { this.Set (value, 'LANGU_SPTXT'); }
		}

		public String TelephoneNumber
		{ 
			get { return this.getString ('TEL_NUMBER'); } 
			set { this.Set (value, 'TEL_NUMBER'); }
		}

		public String TelephoneNumberExtension
		{ 
			get { return this.getString ('TEL_EXTENS'); } 
			set { this.Set (value, 'TEL_EXTENS'); }
		}

		public String MobileNumber
		{ 
			get { return this.getString ('MOB_NUMBER'); } 
			set { this.Set (value, 'MOB_NUMBER'); }
		}

		public String FaxNumber
		{ 
			get { return this.getString ('FAX_NUMBER'); } 
			set { this.Set (value, 'FAX_NUMBER'); }
		}

		public String FaxNumberExtension
		{ 
			get { return this.getString ('FAX_EXTENS'); } 
			set { this.Set (value, 'FAX_EXTENS'); }
		}

		public String EMailAddress
		{ 
			get { return this.getString ('SMTP_ADDR'); } 
			set { this.Set (value, 'SMTP_ADDR'); }
		}

		public String DefaultCommunicationMethod
		{ 
			get { return this.getString ('DEFLT_COMM'); } 
			set { this.Set (value, 'DEFLT_COMM'); }
		}

		public String DefaultCommunicationMethodDescription
		{ 
			get { return this.getString ('DEFLT_COMM_TEXT'); } 
			set { this.Set (value, 'DEFLT_COMM_TEXT'); }
		}

		public String Extension1
		{ 
			get { return this.getString ('EXTENSION1'); } 
			set { this.Set (value, 'EXTENSION1'); }
		}

		public String Extension2
		{ 
			get { return this.getString ('EXTENSION2'); } 
			set { this.Set (value, 'EXTENSION2'); }
		}

		public String AddressNotes
		{ 
			get { return this.getString ('REMARK'); } 
			set { this.Set (value, 'REMARK'); }
		}

}
public class TEXTS extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.TEXTS.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'TDID','TDSPRAS' };
	
		return keyFields;
	}

			public String TextID
		{ 
			get { return this.getString ('TDID'); } 
			set { this.Set (value, 'TDID'); }
		}

		public String TextLanguage
		{ 
			get { return this.getString ('TDSPRAS'); } 
			set { this.Set (value, 'TDSPRAS'); }
		}

		public String TextIDDescription
		{ 
			get { return this.getString ('TDTEXT'); } 
			set { this.Set (value, 'TDTEXT'); }
		}

		public String Text
		{ 
			get { return this.getString ('TEXT'); } 
			set { this.Set (value, 'TEXT'); }
		}

}
public class ORDERDATA extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ORDERDATA.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String CustomerPurchaseOrderNumber
		{ 
			get { return this.getString ('BSTKD'); } 
			set { this.Set (value, 'BSTKD'); }
		}

		public Date CustomerPurchaseOrderDate
		{ 
			get { return this.getDate ('BSTDK'); } 
			set { this.Set (value, 'BSTDK'); }
		}

		public String CustomerPurchaseOrderType
		{ 
			get { return this.getString ('BSARK'); } 
			set { this.Set (value, 'BSARK'); }
		}

		public String PurchaseOrderNumberSupplement
		{ 
			get { return this.getString ('BSTZD'); } 
			set { this.Set (value, 'BSTZD'); }
		}

		public Date LastCustomerContactDate
		{ 
			get { return this.getDate ('MAHDT'); } 
			set { this.Set (value, 'MAHDT'); }
		}

		public Decimal NumberOfContactsFromCustomer
		{ 
			get { return this.getDecimal ('MAHZA'); } 
			set { this.Set (value, 'MAHZA'); }
		}

		public String OrdererName
		{ 
			get { return this.getString ('BNAME'); } 
			set { this.Set (value, 'BNAME'); }
		}

		public String CollectiveNumber
		{ 
			get { return this.getString ('SUBMI'); } 
			set { this.Set (value, 'SUBMI'); }
		}

		public String YourReference
		{ 
			get { return this.getString ('IHREZ'); } 
			set { this.Set (value, 'IHREZ'); }
		}

		public String TelephoneNumber
		{ 
			get { return this.getString ('TELF1'); } 
			set { this.Set (value, 'TELF1'); }
		}

		public String ShipToPurchaseOrderNumber
		{ 
			get { return this.getString ('BSTKD_E'); } 
			set { this.Set (value, 'BSTKD_E'); }
		}

		public Date ShipToPODate
		{ 
			get { return this.getDate ('BSTDK_E'); } 
			set { this.Set (value, 'BSTDK_E'); }
		}

		public String ShipToPurchaseOrderType
		{ 
			get { return this.getString ('BSARK_E'); } 
			set { this.Set (value, 'BSARK_E'); }
		}

		public String ShipToCharacter
		{ 
			get { return this.getString ('IHREZ_E'); } 
			set { this.Set (value, 'IHREZ_E'); }
		}

}
public class STATUS extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.STATUS.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String OverallStatusDescription
		{ 
			get { return this.getString ('GBSTA_BEZ'); } 
			set { this.Set (value, 'GBSTA_BEZ'); }
		}

		public String RejectionStatusDescription
		{ 
			get { return this.getString ('ABSTA_BEZ'); } 
			set { this.Set (value, 'ABSTA_BEZ'); }
		}

		public String DeliveryStatusDescription
		{ 
			get { return this.getString ('LFSTA_BEZ'); } 
			set { this.Set (value, 'LFSTA_BEZ'); }
		}

		public String CreditStatusDescription
		{ 
			get { return this.getString ('CMGST_BEZ'); } 
			set { this.Set (value, 'CMGST_BEZ'); }
		}

		public String OveralBlockedStatusDescription
		{ 
			get { return this.getString ('SPSTG_BEZ'); } 
			set { this.Set (value, 'SPSTG_BEZ'); }
		}

		public String DataCompleteDescription
		{ 
			get { return this.getString ('UVALL_BEZ'); } 
			set { this.Set (value, 'UVALL_BEZ'); }
		}

		public String HeaderDeliveryDataCompleteDesc
		{ 
			get { return this.getString ('UVVLK_BEZ'); } 
			set { this.Set (value, 'UVVLK_BEZ'); }
		}

		public String HeaderBillingCompleteDesc
		{ 
			get { return this.getString ('UVFAK_BEZ'); } 
			set { this.Set (value, 'UVFAK_BEZ'); }
		}

		public String ItemDataCompleteDesc
		{ 
			get { return this.getString ('UVALS_BEZ'); } 
			set { this.Set (value, 'UVALS_BEZ'); }
		}

		public String ItemDeliveryDataCompleteDesc
		{ 
			get { return this.getString ('UVVLS_BEZ'); } 
			set { this.Set (value, 'UVVLS_BEZ'); }
		}

		public String ItemBillingDataCompleteDesc
		{ 
			get { return this.getString ('UVFAS_BEZ'); } 
			set { this.Set (value, 'UVFAS_BEZ'); }
		}

}
public class ADDITIONAL_DATA_A extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ADDITIONAL_DATA_A.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String CustomerGroup1
		{ 
			get { return this.getString ('KVGR1'); } 
			set { this.Set (value, 'KVGR1'); }
		}

		public String CustomerGroup1Description
		{ 
			get { return this.getString ('KVGR1_BEZEI'); } 
			set { this.Set (value, 'KVGR1_BEZEI'); }
		}

		public String CustomerGroup2
		{ 
			get { return this.getString ('KVGR2'); } 
			set { this.Set (value, 'KVGR2'); }
		}

		public String CustomerGroup2Description
		{ 
			get { return this.getString ('KVGR2_BEZEI'); } 
			set { this.Set (value, 'KVGR2_BEZEI'); }
		}

		public String CustomerGroup3
		{ 
			get { return this.getString ('KVGR3'); } 
			set { this.Set (value, 'KVGR3'); }
		}

		public String CustomerGroup3Description
		{ 
			get { return this.getString ('KVGR3_BEZEI'); } 
			set { this.Set (value, 'KVGR3_BEZEI'); }
		}

		public String CustomerGroup4
		{ 
			get { return this.getString ('KVGR4'); } 
			set { this.Set (value, 'KVGR4'); }
		}

		public String CustomerGroup4Description
		{ 
			get { return this.getString ('KVGR4_BEZEI'); } 
			set { this.Set (value, 'KVGR4_BEZEI'); }
		}

		public String CustomerGroup5
		{ 
			get { return this.getString ('KVGR5'); } 
			set { this.Set (value, 'KVGR5'); }
		}

		public String CustomerGroup5Description
		{ 
			get { return this.getString ('KVGR5_BEZEI'); } 
			set { this.Set (value, 'KVGR5_BEZEI'); }
		}

		public String CustomerConditionGroup1
		{ 
			get { return this.getString ('KDKG1'); } 
			set { this.Set (value, 'KDKG1'); }
		}

		public String CustomerConditionGroup1Description
		{ 
			get { return this.getString ('KDKG1_VTEXT'); } 
			set { this.Set (value, 'KDKG1_VTEXT'); }
		}

		public String CustomerConditionGroup2
		{ 
			get { return this.getString ('KDKG2'); } 
			set { this.Set (value, 'KDKG2'); }
		}

		public String CustomerConditionGroup2Description
		{ 
			get { return this.getString ('KDKG2_VTEXT'); } 
			set { this.Set (value, 'KDKG2_VTEXT'); }
		}

		public String CustomerConditionGroup3
		{ 
			get { return this.getString ('KDKG3'); } 
			set { this.Set (value, 'KDKG3'); }
		}

		public String CustomerConditionGroup3Description
		{ 
			get { return this.getString ('KDKG3_VTEXT'); } 
			set { this.Set (value, 'KDKG3_VTEXT'); }
		}

		public String CustomerConditionGroup4
		{ 
			get { return this.getString ('KDKG4'); } 
			set { this.Set (value, 'KDKG4'); }
		}

		public String CustomerConditionGroup4Description
		{ 
			get { return this.getString ('KDKG4_VTEXT'); } 
			set { this.Set (value, 'KDKG4_VTEXT'); }
		}

		public String CustomerConditionGroup5
		{ 
			get { return this.getString ('KDKG5'); } 
			set { this.Set (value, 'KDKG5'); }
		}

		public String CustomerConditionGroup5Description
		{ 
			get { return this.getString ('KDKG5_VTEXT'); } 
			set { this.Set (value, 'KDKG5_VTEXT'); }
		}

}
public class ITEMS extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ITEMS.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'POSNR' };
	
		return keyFields;
	}

			public String ItemNumber
		{ 
			get { return this.getString ('POSNR'); } 
			set { this.Set (value, 'POSNR'); }
		}

		public String Material
		{ 
			get { return this.getString ('MATNR'); } 
			set { this.Set (value, 'MATNR'); }
		}

		public Decimal OrderQuantity
		{ 
			get { return this.getDecimal ('KWMENG'); } 
			set { this.Set (value, 'KWMENG'); }
		}

		public String SalesUnit
		{ 
			get { return this.getString ('VRKME'); } 
			set { this.Set (value, 'VRKME'); }
		}

		public String SalesUnitDescription
		{ 
			get { return this.getString ('VRKME_TXDIM'); } 
			set { this.Set (value, 'VRKME_TXDIM'); }
		}

		public String ItemDescription
		{ 
			get { return this.getString ('ARKTX'); } 
			set { this.Set (value, 'ARKTX'); }
		}

		public String CustomerMaterialNumber
		{ 
			get { return this.getString ('KDMAT'); } 
			set { this.Set (value, 'KDMAT'); }
		}

		public String ItemCategory
		{ 
			get { return this.getString ('PSTYV'); } 
			set { this.Set (value, 'PSTYV'); }
		}

		public String ItemCategoryDescription
		{ 
			get { return this.getString ('PSTYV_VTEXT'); } 
			set { this.Set (value, 'PSTYV_VTEXT'); }
		}

		public String DangerousGoodsIndicator
		{ 
			get { return this.getString ('PROFL'); } 
			set { this.Set (value, 'PROFL'); }
		}

		public String HigherLevelItemNumber
		{ 
			get { return this.getString ('UEPOS'); } 
			set { this.Set (value, 'UEPOS'); }
		}

		public String ScheduleLineDate
		{ 
			get { return this.getString ('ETDAT'); } 
			set { this.Set (value, 'ETDAT'); }
		}

		public String Plant
		{ 
			get { return this.getString ('WERKS'); } 
			set { this.Set (value, 'WERKS'); }
		}

		public String PlantName
		{ 
			get { return this.getString ('WERKS_NAME'); } 
			set { this.Set (value, 'WERKS_NAME'); }
		}

		public String BatchNumber
		{ 
			get { return this.getString ('CHARG'); } 
			set { this.Set (value, 'CHARG'); }
		}

		public String ConditionType
		{ 
			get { return this.getString ('KSCHL'); } 
			set { this.Set (value, 'KSCHL'); }
		}

		public Decimal Rate
		{ 
			get { return this.getDecimal ('KBETR'); } 
			set { this.Set (value, 'KBETR'); }
		}

		public String RateUnit
		{ 
			get { return this.getString ('KOEIN'); } 
			set { this.Set (value, 'KOEIN'); }
		}

		public Decimal NetItemPrice
		{ 
			get { return this.getDecimal ('NETPR'); } 
			set { this.Set (value, 'NETPR'); }
		}

		public Decimal ConditionPricingUnit
		{ 
			get { return this.getDecimal ('KPEIN'); } 
			set { this.Set (value, 'KPEIN'); }
		}

		public String ConditionUnit
		{ 
			get { return this.getString ('KMEIN'); } 
			set { this.Set (value, 'KMEIN'); }
		}

		public String ConditionUnitDescription
		{ 
			get { return this.getString ('KMEIN_TXDIM'); } 
			set { this.Set (value, 'KMEIN_TXDIM'); }
		}

		public Decimal NetTotalValue
		{ 
			get { return this.getDecimal ('NETWR'); } 
			set { this.Set (value, 'NETWR'); }
		}

		public String SalesDocumentCurrency
		{ 
			get { return this.getString ('WAERK'); } 
			set { this.Set (value, 'WAERK'); }
		}

		public Decimal ConditionScaleQuantity
		{ 
			get { return this.getDecimal ('KSTBS'); } 
			set { this.Set (value, 'KSTBS'); }
		}

		public String ReasonForRejection
		{ 
			get { return this.getString ('ABGRU'); } 
			set { this.Set (value, 'ABGRU'); }
		}

		public String CustomerPurchaseOrderNumber
		{ 
			get { return this.getString ('BSTKD'); } 
			set { this.Set (value, 'BSTKD'); }
		}

		public String CustomerPurchaseOrderItemNumber
		{ 
			get { return this.getString ('POSEX'); } 
			set { this.Set (value, 'POSEX'); }
		}

		public String DeliveryBlockStatus
		{ 
			get { return this.getString ('LSSTA'); } 
			set { this.Set (value, 'LSSTA'); }
		}

		public String DeliveryBlockStatusDescription
		{ 
			get { return this.getString ('LSSTA_BEZ'); } 
			set { this.Set (value, 'LSSTA_BEZ'); }
		}

		public String BillingBlockStatus
		{ 
			get { return this.getString ('FSSTA'); } 
			set { this.Set (value, 'FSSTA'); }
		}

		public String BillingBlockStatusDescription
		{ 
			get { return this.getString ('FSSTA_BEZ'); } 
			set { this.Set (value, 'FSSTA_BEZ'); }
		}

		public String AgreedDeliveryTime
		{ 
			get { return this.getString ('DELCO'); } 
			set { this.Set (value, 'DELCO'); }
		}

		public String AgreedDeliveryTimeDescription
		{ 
			get { return this.getString ('DELCO_BEZEI'); } 
			set { this.Set (value, 'DELCO_BEZEI'); }
		}

		public String Materialgroup1
		{ 
			get { return this.getString ('MVGR1'); } 
			set { this.Set (value, 'MVGR1'); }
		}

		public String Materialgroup1Description
		{ 
			get { return this.getString ('MVGR1_BEZEI'); } 
			set { this.Set (value, 'MVGR1_BEZEI'); }
		}

		public String Materialgroup2
		{ 
			get { return this.getString ('MVGR2'); } 
			set { this.Set (value, 'MVGR2'); }
		}

		public String Materialgroup2Description
		{ 
			get { return this.getString ('MVGR2_BEZEI'); } 
			set { this.Set (value, 'MVGR2_BEZEI'); }
		}

		public String Materialgroup3
		{ 
			get { return this.getString ('MVGR3'); } 
			set { this.Set (value, 'MVGR3'); }
		}

		public String Materialgroup3Description
		{ 
			get { return this.getString ('MVGR3_BEZEI'); } 
			set { this.Set (value, 'MVGR3_BEZEI'); }
		}

		public String Materialgroup4
		{ 
			get { return this.getString ('MVGR4'); } 
			set { this.Set (value, 'MVGR4'); }
		}

		public String Materialgroup4Description
		{ 
			get { return this.getString ('MVGR4_BEZEI'); } 
			set { this.Set (value, 'MVGR4_BEZEI'); }
		}

		public String Materialgroup5
		{ 
			get { return this.getString ('MVGR5'); } 
			set { this.Set (value, 'MVGR5'); }
		}

		public String Materialgroup5Description
		{ 
			get { return this.getString ('MVGR5_BEZEI'); } 
			set { this.Set (value, 'MVGR5_BEZEI'); }
		}

		public String CustomerConditionGroup1
		{ 
			get { return this.getString ('KDKG1'); } 
			set { this.Set (value, 'KDKG1'); }
		}

		public String CustomerConditionGroup1Description
		{ 
			get { return this.getString ('KDKG1_VTEXT'); } 
			set { this.Set (value, 'KDKG1_VTEXT'); }
		}

		public String CustomerConditionGroup2
		{ 
			get { return this.getString ('KDKG2'); } 
			set { this.Set (value, 'KDKG2'); }
		}

		public String CustomerConditionGroup2Description
		{ 
			get { return this.getString ('KDKG2_VTEXT'); } 
			set { this.Set (value, 'KDKG2_VTEXT'); }
		}

		public String CustomerConditionGroup3
		{ 
			get { return this.getString ('KDKG3'); } 
			set { this.Set (value, 'KDKG3'); }
		}

		public String CustomerConditionGroup3Description
		{ 
			get { return this.getString ('KDKG3_VTEXT'); } 
			set { this.Set (value, 'KDKG3_VTEXT'); }
		}

		public String CustomerConditionGroup4
		{ 
			get { return this.getString ('KDKG4'); } 
			set { this.Set (value, 'KDKG4'); }
		}

		public String CustomerConditionGroup4Description
		{ 
			get { return this.getString ('KDKG4_VTEXT'); } 
			set { this.Set (value, 'KDKG4_VTEXT'); }
		}

		public String CustomerConditionGroup5
		{ 
			get { return this.getString ('KDKG5'); } 
			set { this.Set (value, 'KDKG5'); }
		}

		public String CustomerConditionGroup5Description
		{ 
			get { return this.getString ('KDKG5_VTEXT'); } 
			set { this.Set (value, 'KDKG5_VTEXT'); }
		}

		public String ProductHierarchyDescription
		{ 
			get { return this.getString ('PRODH'); } 
			set { this.Set (value, 'PRODH'); }
		}

		public String MaterialGroupHierarchy1
		{ 
			get { return this.getString ('WGRU1'); } 
			set { this.Set (value, 'WGRU1'); }
		}

		public String MaterialGroupHierarchy2
		{ 
			get { return this.getString ('WGRU2'); } 
			set { this.Set (value, 'WGRU2'); }
		}

		public String Division
		{ 
			get { return this.getString ('SPART'); } 
			set { this.Set (value, 'SPART'); }
		}

		public String DivisionName
		{ 
			get { return this.getString ('SPART_VTEXT'); } 
			set { this.Set (value, 'SPART_VTEXT'); }
		}

		public String WBSElementInternal
		{ 
			get { return this.getString ('PS_PSP_PNR'); } 
			set { this.Set (value, 'PS_PSP_PNR'); }
		}

		public String WBSElement
		{ 
			get { return this.getString ('POSID'); } 
			set { this.Set (value, 'POSID'); }
		}

		public String WBSElementDescription
		{ 
			get { return this.getString ('POST1'); } 
			set { this.Set (value, 'POST1'); }
		}

		public String OrderNumber
		{ 
			get { return this.getString ('AUFNR'); } 
			set { this.Set (value, 'AUFNR'); }
		}

		public String ProfitCenter
		{ 
			get { return this.getString ('PRCTR'); } 
			set { this.Set (value, 'PRCTR'); }
		}

		public String MaterialPricingGroup
		{ 
			get { return this.getString ('KONDM'); } 
			set { this.Set (value, 'KONDM'); }
		}

		public String MaterialPricingGroupDescription
		{ 
			get { return this.getString ('KONDM_VTEXT'); } 
			set { this.Set (value, 'KONDM_VTEXT'); }
		}

		public String CustomerGroup
		{ 
			get { return this.getString ('KDGRP'); } 
			set { this.Set (value, 'KDGRP'); }
		}

		public String CustomerGroupName
		{ 
			get { return this.getString ('KDGRP_KTEXT'); } 
			set { this.Set (value, 'KDGRP_KTEXT'); }
		}

		public String PriceGroup
		{ 
			get { return this.getString ('KONDA'); } 
			set { this.Set (value, 'KONDA'); }
		}

		public String PriceGroupDescription
		{ 
			get { return this.getString ('KONDA_VTEXT'); } 
			set { this.Set (value, 'KONDA_VTEXT'); }
		}

		public String PriceListType
		{ 
			get { return this.getString ('PLTYP'); } 
			set { this.Set (value, 'PLTYP'); }
		}

		public String PriceListTypeText
		{ 
			get { return this.getString ('PLTYP_PTEXT'); } 
			set { this.Set (value, 'PLTYP_PTEXT'); }
		}

		public String SalesDistrict
		{ 
			get { return this.getString ('BZIRK'); } 
			set { this.Set (value, 'BZIRK'); }
		}

		public String SalesDistrictName
		{ 
			get { return this.getString ('BZIRK_BZTXT'); } 
			set { this.Set (value, 'BZIRK_BZTXT'); }
		}

		public Date CustomerPurchaseOrderDate
		{ 
			get { return this.getDate ('BSTDK'); } 
			set { this.Set (value, 'BSTDK'); }
		}

		public String CustomerPurchaseOrderType
		{ 
			get { return this.getString ('BSARK'); } 
			set { this.Set (value, 'BSARK'); }
		}

		public String CustomerPurchaseOrderTypeDesc
		{ 
			get { return this.getString ('BSARK_VTEXT'); } 
			set { this.Set (value, 'BSARK_VTEXT'); }
		}

		public String ShipToPurchaseOrderNumber
		{ 
			get { return this.getString ('BSTKD_E'); } 
			set { this.Set (value, 'BSTKD_E'); }
		}

		public Date ShipToPODate
		{ 
			get { return this.getDate ('BSTDK_E'); } 
			set { this.Set (value, 'BSTDK_E'); }
		}

		public String ShipToPurchaseOrderType
		{ 
			get { return this.getString ('BSARK_E'); } 
			set { this.Set (value, 'BSARK_E'); }
		}

		public String ShipToPurchaseOrderTypeDesc
		{ 
			get { return this.getString ('BSARK_E_VTEXT'); } 
			set { this.Set (value, 'BSARK_E_VTEXT'); }
		}

		public String ShipToPurchaseOrderItemNumber
		{ 
			get { return this.getString ('POSEX_E'); } 
			set { this.Set (value, 'POSEX_E'); }
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

		public String DeliveryPriority
		{ 
			get { return this.getString ('LPRIO'); } 
			set { this.Set (value, 'LPRIO'); }
		}

		public String DeliveryPriorityDescription
		{ 
			get { return this.getString ('LPRIO_BEZEI'); } 
			set { this.Set (value, 'LPRIO_BEZEI'); }
		}

		public String ShippingPoint
		{ 
			get { return this.getString ('VSTEL'); } 
			set { this.Set (value, 'VSTEL'); }
		}

		public String ShippingPointDescription
		{ 
			get { return this.getString ('VSTEL_VTEXT'); } 
			set { this.Set (value, 'VSTEL_VTEXT'); }
		}

		public String PartialDelivery
		{ 
			get { return this.getString ('KZTLF'); } 
			set { this.Set (value, 'KZTLF'); }
		}

		public String PartialDeliveryDescription
		{ 
			get { return this.getString ('KZTLF_DDTEXT'); } 
			set { this.Set (value, 'KZTLF_DDTEXT'); }
		}

		public String Route
		{ 
			get { return this.getString ('ROUTE'); } 
			set { this.Set (value, 'ROUTE'); }
		}

		public String RouteDescription
		{ 
			get { return this.getString ('ROUTE_BEZEI'); } 
			set { this.Set (value, 'ROUTE_BEZEI'); }
		}

		public Decimal Netweight
		{ 
			get { return this.getDecimal ('NTGEW'); } 
			set { this.Set (value, 'NTGEW'); }
		}

		public String WeightUnit
		{ 
			get { return this.getString ('GEWEI'); } 
			set { this.Set (value, 'GEWEI'); }
		}

		public Decimal GrossWeight
		{ 
			get { return this.getDecimal ('BRGEW'); } 
			set { this.Set (value, 'BRGEW'); }
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

		public String IncotermsPart1
		{ 
			get { return this.getString ('INCO1'); } 
			set { this.Set (value, 'INCO1'); }
		}

		public String IncotermsPart1Description
		{ 
			get { return this.getString ('INCO1_BEZEI'); } 
			set { this.Set (value, 'INCO1_BEZEI'); }
		}

		public String IncotermsPart2
		{ 
			get { return this.getString ('INCO2'); } 
			set { this.Set (value, 'INCO2'); }
		}

		public String TermsofPaymentKey
		{ 
			get { return this.getString ('ZTERM'); } 
			set { this.Set (value, 'ZTERM'); }
		}

		public String TermsofPaymentKeyDescription
		{ 
			get { return this.getString ('ZTERM_VTEXT'); } 
			set { this.Set (value, 'ZTERM_VTEXT'); }
		}

		public String BillingBlock
		{ 
			get { return this.getString ('FAKSP'); } 
			set { this.Set (value, 'FAKSP'); }
		}

		public String BillingBlockDescription
		{ 
			get { return this.getString ('FAKSP_VTEXT'); } 
			set { this.Set (value, 'FAKSP_VTEXT'); }
		}

		public String BillingRelevant
		{ 
			get { return this.getString ('FKREL'); } 
			set { this.Set (value, 'FKREL'); }
		}

		public String BillingRelevantDescription
		{ 
			get { return this.getString ('FKREL_DDTEXT'); } 
			set { this.Set (value, 'FKREL_DDTEXT'); }
		}

		public String BillingPlanInHeaderIndicator
		{ 
			get { return this.getString ('KFREL'); } 
			set { this.Set (value, 'KFREL'); }
		}

		public String OverallStatusDescription
		{ 
			get { return this.getString ('GBSTA_BEZ'); } 
			set { this.Set (value, 'GBSTA_BEZ'); }
		}

		public String DataCompleteDescription
		{ 
			get { return this.getString ('UVALL_BEZ'); } 
			set { this.Set (value, 'UVALL_BEZ'); }
		}

		public Decimal ExchangeRatePriceDetermination
		{ 
			get { return this.getDecimal ('KURSK'); } 
			set { this.Set (value, 'KURSK'); }
		}

		public Date DateforPricingExchangeRate
		{ 
			get { return this.getDate ('PRSDT'); } 
			set { this.Set (value, 'PRSDT'); }
		}

		public String MaterialEntered
		{ 
			get { return this.getString ('MATWA'); } 
			set { this.Set (value, 'MATWA'); }
		}

		public String UsageIndicator
		{ 
			get { return this.getString ('VKAUS'); } 
			set { this.Set (value, 'VKAUS'); }
		}

		public String UsageIndicatorDescription
		{ 
			get { return this.getString ('VKAUS_BEZEI'); } 
			set { this.Set (value, 'VKAUS_BEZEI'); }
		}

		public String PricingReferenceMaterial
		{ 
			get { return this.getString ('PMATN'); } 
			set { this.Set (value, 'PMATN'); }
		}

		public String CostingSheet
		{ 
			get { return this.getString ('KALSM_K'); } 
			set { this.Set (value, 'KALSM_K'); }
		}

		public String CostingSheetDescription
		{ 
			get { return this.getString ('KALSM_K_VTEXT'); } 
			set { this.Set (value, 'KALSM_K_VTEXT'); }
		}

		public String Overheadkey
		{ 
			get { return this.getString ('ZSCHL_K'); } 
			set { this.Set (value, 'ZSCHL_K'); }
		}

		public String ReceivingPoint
		{ 
			get { return this.getString ('EMPST'); } 
			set { this.Set (value, 'EMPST'); }
		}

		public String DepartmentNumber
		{ 
			get { return this.getString ('ABTNR'); } 
			set { this.Set (value, 'ABTNR'); }
		}

		public String DepartmentNumberDescription
		{ 
			get { return this.getString ('ABTNR_VTEXT'); } 
			set { this.Set (value, 'ABTNR_VTEXT'); }
		}

		public Decimal MaxNumberOfPartialDeliveriesAllowed
		{ 
			get { return this.getDecimal ('ANTLF'); } 
			set { this.Set (value, 'ANTLF'); }
		}

		public Decimal OverdeliveryToleranceLimit
		{ 
			get { return this.getDecimal ('UEBTO'); } 
			set { this.Set (value, 'UEBTO'); }
		}

		public Decimal UnderdeliveryToleranceLimit
		{ 
			get { return this.getDecimal ('UNTTO'); } 
			set { this.Set (value, 'UNTTO'); }
		}

		public Date FixedValueDate
		{ 
			get { return this.getDate ('VALDT'); } 
			set { this.Set (value, 'VALDT'); }
		}

		public String AdditionalValueDays
		{ 
			get { return this.getString ('VALTG'); } 
			set { this.Set (value, 'VALTG'); }
		}

		public String InvoiceDates
		{ 
			get { return this.getString ('PERFK'); } 
			set { this.Set (value, 'PERFK'); }
		}

		public String InvoiceDatesText
		{ 
			get { return this.getString ('PERFK_LTEXT'); } 
			set { this.Set (value, 'PERFK_LTEXT'); }
		}

		public Date BillingDate
		{ 
			get { return this.getDate ('FKDAT'); } 
			set { this.Set (value, 'FKDAT'); }
		}

		public Date DateOnWhichServicesRendered
		{ 
			get { return this.getDate ('FBUDA'); } 
			set { this.Set (value, 'FBUDA'); }
		}

		public String AccountAssignmentGroup
		{ 
			get { return this.getString ('KTGRM'); } 
			set { this.Set (value, 'KTGRM'); }
		}

		public String AccountAssignmentGroupDescription
		{ 
			get { return this.getString ('KTGRM_VTEXT'); } 
			set { this.Set (value, 'KTGRM_VTEXT'); }
		}

		public Decimal ComponentQuantity
		{ 
			get { return this.getDecimal ('KMPMG'); } 
			set { this.Set (value, 'KMPMG'); }
		}

		public String QuantityUOM
		{ 
			get { return this.getString ('MEINS'); } 
			set { this.Set (value, 'MEINS'); }
		}

		public String IUIDRelevant
		{ 
			get { return this.getString ('IUID_RELEVANT'); } 
			set { this.Set (value, 'IUID_RELEVANT'); }
		}

		public String DeliveryBlock
		{ 
			get { return this.getString ('LIFSP'); } 
			set { this.Set (value, 'LIFSP'); }
		}

		public String DeliveryBlockDescription
		{ 
			get { return this.getString ('LIFSP_VTEXT'); } 
			set { this.Set (value, 'LIFSP_VTEXT'); }
		}

		public Decimal Quantityreceivedorrequired
		{ 
			get { return this.getDecimal ('REC_REQD_QTY'); } 
			set { this.Set (value, 'REC_REQD_QTY'); }
		}

		public Decimal AvailabeQuantity
		{ 
			get { return this.getDecimal ('CUM_ATP_QTY'); } 
			set { this.Set (value, 'CUM_ATP_QTY'); }
		}

}
public class ITEMS_SCHEDULE extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ITEMS_SCHEDULE.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'POSNR','ETENR' };
	
		return keyFields;
	}

			public String ItemNumber
		{ 
			get { return this.getString ('POSNR'); } 
			set { this.Set (value, 'POSNR'); }
		}

		public String ScheduleLineNumber
		{ 
			get { return this.getString ('ETENR'); } 
			set { this.Set (value, 'ETENR'); }
		}

		public Date ScheduleLineDate
		{ 
			get { return this.getDate ('EDATU'); } 
			set { this.Set (value, 'EDATU'); }
		}

		public Decimal OrderQuantity
		{ 
			get { return this.getDecimal ('WMENG'); } 
			set { this.Set (value, 'WMENG'); }
		}

		public Decimal RoundedQuantity
		{ 
			get { return this.getDecimal ('CMENG'); } 
			set { this.Set (value, 'CMENG'); }
		}

		public Decimal ConfirmedQuantity
		{ 
			get { return this.getDecimal ('BMENG'); } 
			set { this.Set (value, 'BMENG'); }
		}

		public String SalesUnit
		{ 
			get { return this.getString ('VRKME'); } 
			set { this.Set (value, 'VRKME'); }
		}

		public String DeliveryBlock
		{ 
			get { return this.getString ('LIFSP'); } 
			set { this.Set (value, 'LIFSP'); }
		}

		public String DeliveryBlockDescription
		{ 
			get { return this.getString ('LIFSP_VTEXT'); } 
			set { this.Set (value, 'LIFSP_VTEXT'); }
		}

		public Decimal DeliveredQuantity
		{ 
			get { return this.getDecimal ('VSMNG'); } 
			set { this.Set (value, 'VSMNG'); }
		}

		public String ScheduleLineCategory
		{ 
			get { return this.getString ('ETTYP'); } 
			set { this.Set (value, 'ETTYP'); }
		}

		public String ScheduleLineCategoryDescription
		{ 
			get { return this.getString ('ETTYP_VTEXT'); } 
			set { this.Set (value, 'ETTYP_VTEXT'); }
		}

		public String PurchaseRequisitionNumber
		{ 
			get { return this.getString ('BANFN'); } 
			set { this.Set (value, 'BANFN'); }
		}

		public String PurchaseRequisitionItemNumber
		{ 
			get { return this.getString ('BNFPO'); } 
			set { this.Set (value, 'BNFPO'); }
		}

}
public class ITEMS_ARM extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ITEMS_ARM.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'MSR_ID','ITEM' };
	
		return keyFields;
	}

			public String ProcessIDNumber
		{ 
			get { return this.getString ('MSR_ID'); } 
			set { this.Set (value, 'MSR_ID'); }
		}

		public String Item
		{ 
			get { return this.getString ('ITEM'); } 
			set { this.Set (value, 'ITEM'); }
		}

		public String ExecutedStepID
		{ 
			get { return this.getString ('EXECUTED_STEP_ID'); } 
			set { this.Set (value, 'EXECUTED_STEP_ID'); }
		}

		public String Plant
		{ 
			get { return this.getString ('WERKS'); } 
			set { this.Set (value, 'WERKS'); }
		}

		public String Material
		{ 
			get { return this.getString ('MATNR'); } 
			set { this.Set (value, 'MATNR'); }
		}

		public String MaterialDescription
		{ 
			get { return this.getString ('MATNR_DESC'); } 
			set { this.Set (value, 'MATNR_DESC'); }
		}

		public Decimal Quantity
		{ 
			get { return this.getDecimal ('QUANTITY'); } 
			set { this.Set (value, 'QUANTITY'); }
		}

		public String UnitOfMeasure
		{ 
			get { return this.getString ('UNIT'); } 
			set { this.Set (value, 'UNIT'); }
		}

		public String ReplacementMaterial
		{ 
			get { return this.getString ('REPLACE_MATNR'); } 
			set { this.Set (value, 'REPLACE_MATNR'); }
		}

		public String ReplaceMaterialDescription
		{ 
			get { return this.getString ('REP_MATNR_DESC'); } 
			set { this.Set (value, 'REP_MATNR_DESC'); }
		}

		public Decimal ReplacementQuantity
		{ 
			get { return this.getDecimal ('REPLACE_QTY'); } 
			set { this.Set (value, 'REPLACE_QTY'); }
		}

		public String ReplacementUOM
		{ 
			get { return this.getString ('REPLACE_UNIT'); } 
			set { this.Set (value, 'REPLACE_UNIT'); }
		}

		public Decimal ReplacedQuantity
		{ 
			get { return this.getDecimal ('REPLACED_QTY'); } 
			set { this.Set (value, 'REPLACED_QTY'); }
		}

		public String ReplacedUOM
		{ 
			get { return this.getString ('REPLACED_UNIT'); } 
			set { this.Set (value, 'REPLACED_UNIT'); }
		}

		public String ReturnReason
		{ 
			get { return this.getString ('RET_REASON'); } 
			set { this.Set (value, 'RET_REASON'); }
		}

		public String ReturnReasonDescription
		{ 
			get { return this.getString ('RET_REASON_DESC'); } 
			set { this.Set (value, 'RET_REASON_DESC'); }
		}

		public String InspectionCode
		{ 
			get { return this.getString ('INSPECTION_CODE'); } 
			set { this.Set (value, 'INSPECTION_CODE'); }
		}

		public String InspectionCodeText
		{ 
			get { return this.getString ('KURZTEXT_IC'); } 
			set { this.Set (value, 'KURZTEXT_IC'); }
		}

		public String CustomerRMA
		{ 
			get { return this.getString ('RMA_CUSTOMER'); } 
			set { this.Set (value, 'RMA_CUSTOMER'); }
		}

		public String RefundType
		{ 
			get { return this.getString ('REFUND_TYPE'); } 
			set { this.Set (value, 'REFUND_TYPE'); }
		}

		public String RefundTypeDescription
		{ 
			get { return this.getString ('REFUND_TYPE_DESC'); } 
			set { this.Set (value, 'REFUND_TYPE_DESC'); }
		}

		public String RefundCode
		{ 
			get { return this.getString ('REFUND_CODE'); } 
			set { this.Set (value, 'REFUND_CODE'); }
		}

		public String RefundControl
		{ 
			get { return this.getString ('REFUND_CONTROL'); } 
			set { this.Set (value, 'REFUND_CONTROL'); }
		}

		public String ApprovalBlock
		{ 
			get { return this.getString ('MSR_APPROV_BLOCK'); } 
			set { this.Set (value, 'MSR_APPROV_BLOCK'); }
		}

		public String CustomerInspectionCode
		{ 
			get { return this.getString ('CUST_INSP_CODE'); } 
			set { this.Set (value, 'CUST_INSP_CODE'); }
		}

		public String ScheduleLineDate
		{ 
			get { return this.getString ('ETDAT'); } 
			set { this.Set (value, 'ETDAT'); }
		}

		public String CustomerInspectionCodeText
		{ 
			get { return this.getString ('KURZTEXT_CI'); } 
			set { this.Set (value, 'KURZTEXT_CI'); }
		}

		public String PayingPlant
		{ 
			get { return this.getString ('PAYING_PLANT'); } 
			set { this.Set (value, 'PAYING_PLANT'); }
		}

		public String InspectionAtCustomerSite
		{ 
			get { return this.getString ('AT_CUSTOMER_SITE'); } 
			set { this.Set (value, 'AT_CUSTOMER_SITE'); }
		}

		public String MaterialReceived
		{ 
			get { return this.getString ('MAT_RECEIVED'); } 
			set { this.Set (value, 'MAT_RECEIVED'); }
		}

		public String CustomerInspectionText
		{ 
			get { return this.getString ('CI_COMM'); } 
			set { this.Set (value, 'CI_COMM'); }
		}

		public String InspectionText
		{ 
			get { return this.getString ('IC_COMM'); } 
			set { this.Set (value, 'IC_COMM'); }
		}

		public Decimal ReturnMaterialNetPrice
		{ 
			get { return this.getDecimal ('MAT_NET_PRICE'); } 
			set { this.Set (value, 'MAT_NET_PRICE'); }
		}

		public Decimal ReturnMaterialTax
		{ 
			get { return this.getDecimal ('MAT_TAX'); } 
			set { this.Set (value, 'MAT_TAX'); }
		}

		public Decimal ReplacementMaterialNetPrice
		{ 
			get { return this.getDecimal ('REP_MAT_NET_PRICE'); } 
			set { this.Set (value, 'REP_MAT_NET_PRICE'); }
		}

		public Decimal ReplacementMaterialTax
		{ 
			get { return this.getDecimal ('REP_MAT_NET_TAX'); } 
			set { this.Set (value, 'REP_MAT_NET_TAX'); }
		}

		public Decimal PriceDifference
		{ 
			get { return this.getDecimal ('NET_PRICE_DIFF'); } 
			set { this.Set (value, 'NET_PRICE_DIFF'); }
		}

		public Decimal TaxDifference
		{ 
			get { return this.getDecimal ('NET_TAX_DIFF'); } 
			set { this.Set (value, 'NET_TAX_DIFF'); }
		}

}
public class ITEMS_TEXT extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ITEMS_TEXT.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'POSNR','TDID','TDSPRAS' };
	
		return keyFields;
	}

			public String ItemNumber
		{ 
			get { return this.getString ('POSNR'); } 
			set { this.Set (value, 'POSNR'); }
		}

		public String TextID
		{ 
			get { return this.getString ('TDID'); } 
			set { this.Set (value, 'TDID'); }
		}

		public String TextLanguage
		{ 
			get { return this.getString ('TDSPRAS'); } 
			set { this.Set (value, 'TDSPRAS'); }
		}

		public String TextIDDescription
		{ 
			get { return this.getString ('TDTEXT'); } 
			set { this.Set (value, 'TDTEXT'); }
		}

		public String Text
		{ 
			get { return this.getString ('TEXT'); } 
			set { this.Set (value, 'TEXT'); }
		}

}
public class MATERIAL_UOM extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.MATERIAL_UOM.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'MATNR','MEINH' };
	
		return keyFields;
	}

			public String Material
		{ 
			get { return this.getString ('MATNR'); } 
			set { this.Set (value, 'MATNR'); }
		}

		public String AlternateUnitOfMeasure
		{ 
			get { return this.getString ('MEINH'); } 
			set { this.Set (value, 'MEINH'); }
		}

}
public class CCARD extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.CCARD.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'CC_TYPE','CC_NUMBER' };
	
		return keyFields;
	}

			public String BillingPlan
		{ 
			get { return this.getString ('FPLNR'); } 
			set { this.Set (value, 'FPLNR'); }
		}

		public String BillingPlanItem
		{ 
			get { return this.getString ('FPLTR'); } 
			set { this.Set (value, 'FPLTR'); }
		}

		public String CreditCardType
		{ 
			get { return this.getString ('CC_TYPE'); } 
			set { this.Set (value, 'CC_TYPE'); }
		}

		public String CreditCardNumber
		{ 
			get { return this.getString ('CC_NUMBER'); } 
			set { this.Set (value, 'CC_NUMBER'); }
		}

		public String PaymentCardSuffix
		{ 
			get { return this.getString ('CC_SEQ_NO'); } 
			set { this.Set (value, 'CC_SEQ_NO'); }
		}

		public Date ValidToDate
		{ 
			get { return this.getDate ('CC_VALID_T'); } 
			set { this.Set (value, 'CC_VALID_T'); }
		}

		public String CardholderName
		{ 
			get { return this.getString ('CC_NAME'); } 
			set { this.Set (value, 'CC_NAME'); }
		}

		public Decimal BillAmount
		{ 
			get { return this.getDecimal ('BILLAMOUNT'); } 
			set { this.Set (value, 'BILLAMOUNT'); }
		}

		public Decimal AuthorizedAmount
		{ 
			get { return this.getDecimal ('AUTHAMOUNT'); } 
			set { this.Set (value, 'AUTHAMOUNT'); }
		}

		public String OrderCurrency
		{ 
			get { return this.getString ('CURRENCIES'); } 
			set { this.Set (value, 'CURRENCIES'); }
		}

		public Date AuthorizationDate
		{ 
			get { return this.getDate ('AUTH_DATE'); } 
			set { this.Set (value, 'AUTH_DATE'); }
		}

		public Time AuthorizationTime
		{ 
			get { return this.getTime ('AUTH_TIME'); } 
			set { this.Set (value, 'AUTH_TIME'); }
		}

		public String AuthorizationNumber
		{ 
			get { return this.getString ('AUTH_CC_NO'); } 
			set { this.Set (value, 'AUTH_CC_NO'); }
		}

		public String Settlement
		{ 
			get { return this.getString ('SETTLEMENT'); } 
			set { this.Set (value, 'SETTLEMENT'); }
		}

		public String ClearingHouseAuthCode
		{ 
			get { return this.getString ('CLEARING_REF'); } 
			set { this.Set (value, 'CLEARING_REF'); }
		}

		public String AuthorizationCheckResponse
		{ 
			get { return this.getString ('CC_REACT'); } 
			set { this.Set (value, 'CC_REACT'); }
		}

		public String StatusFromExternalSystem
		{ 
			get { return this.getString ('CC_STAT_EX'); } 
			set { this.Set (value, 'CC_STAT_EX'); }
		}

		public String Preauthorization
		{ 
			get { return this.getString ('PRE_AUTH'); } 
			set { this.Set (value, 'PRE_AUTH'); }
		}

		public String AmountChanged
		{ 
			get { return this.getString ('AMOUNTCHAN'); } 
			set { this.Set (value, 'AMOUNTCHAN'); }
		}

		public String AuthorizationType
		{ 
			get { return this.getString ('AUTHORTYPE'); } 
			set { this.Set (value, 'AUTHORTYPE'); }
		}

		public String BillingPlanAuthorization
		{ 
			get { return this.getString ('BP_AUTH'); } 
			set { this.Set (value, 'BP_AUTH'); }
		}

		public String ResultCode
		{ 
			get { return this.getString ('CC_RESULT_CD'); } 
			set { this.Set (value, 'CC_RESULT_CD'); }
		}

		public String ResultText
		{ 
			get { return this.getString ('CC_RESULT_TX'); } 
			set { this.Set (value, 'CC_RESULT_TX'); }
		}

}
public class ITEMS_ACTION extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixRO_Detail.ITEMS_ACTION.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'POSNR' };
	
		return keyFields;
	}

			public String ItemNumber
		{ 
			get { return this.getString ('POSNR'); } 
			set { this.Set (value, 'POSNR'); }
		}

		public String ItemChanged
		{ 
			get { return this.getString ('X_ITEMCHANGED'); } 
			set { this.Set (value, 'X_ITEMCHANGED'); }
		}

		public String ItemDeleted
		{ 
			get { return this.getString ('X_ITEMDELETED'); } 
			set { this.Set (value, 'X_ITEMDELETED'); }
		}

		public String ItemAdded
		{ 
			get { return this.getString ('X_ITEMADDED'); } 
			set { this.Set (value, 'X_ITEMADDED'); }
		}

		public String PriceOverride
		{ 
			get { return this.getString ('X_PRICEOVERRIDE'); } 
			set { this.Set (value, 'X_PRICEOVERRIDE'); }
		}

}
}
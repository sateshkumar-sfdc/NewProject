/// enosiX Inc. Generated Apex Model
/// Generated On: 1/17/2017 3:39:05 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixInvoice_Detail extends ENSX.EnosixFramework.DetailSBO {
    
    public SBO_EnosixInvoice_Detail() {
    	super('EnosixInvoice', SBO_EnosixInvoice_Detail.EnosixInvoice.class);
    }

	public override Type getType() { return SBO_EnosixInvoice_Detail.class; }

	public EnosixInvoice initialize(EnosixInvoice obj) {
    	return (EnosixInvoice)this.executeInitialize(obj);
    }
    
    public EnosixInvoice getDetail(object key) {
    	return (EnosixInvoice)this.executeGetDetail(key);
    }
    
    public EnosixInvoice save(EnosixInvoice obj) {
    	return (EnosixInvoice) this.executeSave(obj);
    }

    public EnosixInvoice command(string command, EnosixInvoice obj) {
    	return (EnosixInvoice) this.executeCommand(command, obj);
    }
    
    public with sharing class EnosixInvoice extends ENSX.EnosixFramework.DetailObject {
     	public EnosixInvoice() {
			super('HEADER', new Map<string,type>{'ITEMS' => SBO_EnosixInvoice_Detail.ITEMS.class
,'CONDITIONS' => SBO_EnosixInvoice_Detail.CONDITIONS.class
});	
    	}

		public override Type getType() { return SBO_EnosixInvoice_Detail.EnosixInvoice.class; }

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

		public String PaymentMethod
		{ 
			get { return this.getString ('ZLSCH'); } 
			set { this.Set (value, 'ZLSCH'); }
		}

		public String PaymentMethodDescription
		{ 
			get { return this.getString ('ZLSCH_TEXT'); } 
			set { this.Set (value, 'ZLSCH_TEXT'); }
		}

		public String TermsofPaymentKey
		{ 
			get { return this.getString ('ZTERM'); } 
			set { this.Set (value, 'ZTERM'); }
		}

		public String TermsOfPaymentKeyDesc
		{ 
			get { return this.getString ('ZTERM_TEXT'); } 
			set { this.Set (value, 'ZTERM_TEXT'); }
		}

		public Decimal NetOrderValue
		{ 
			get { return this.getDecimal ('NETWR'); } 
			set { this.Set (value, 'NETWR'); }
		}

		public Decimal TaxAmount
		{ 
			get { return this.getDecimal ('MWSBK'); } 
			set { this.Set (value, 'MWSBK'); }
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

		
		public ENSX.EnosixFramework.FrameworkCollection ITEMS {
    		get { return this.getCollection(SBO_EnosixInvoice_Detail.ITEMS.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection CONDITIONS {
    		get { return this.getCollection(SBO_EnosixInvoice_Detail.CONDITIONS.class); }
    	}

				
	}

	//Write child objects
	public class ITEMS extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixInvoice_Detail.ITEMS.class; }

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

		public String ItemDescription
		{ 
			get { return this.getString ('ARKTX'); } 
			set { this.Set (value, 'ARKTX'); }
		}

		public Decimal BillingQuantity
		{ 
			get { return this.getDecimal ('FKIMG'); } 
			set { this.Set (value, 'FKIMG'); }
		}

		public String SalesUnit
		{ 
			get { return this.getString ('VRKME'); } 
			set { this.Set (value, 'VRKME'); }
		}

		public String Plant
		{ 
			get { return this.getString ('WERKS'); } 
			set { this.Set (value, 'WERKS'); }
		}

		public String PlantDescription
		{ 
			get { return this.getString ('WERKS_TEXT'); } 
			set { this.Set (value, 'WERKS_TEXT'); }
		}

		public Decimal NetItemValue
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

}
public class CONDITIONS extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixInvoice_Detail.CONDITIONS.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'KPOSN','KSCHL' };
	
		return keyFields;
	}

			public String ConditionItemNumber
		{ 
			get { return this.getString ('KPOSN'); } 
			set { this.Set (value, 'KPOSN'); }
		}

		public String ConditionType
		{ 
			get { return this.getString ('KSCHL'); } 
			set { this.Set (value, 'KSCHL'); }
		}

		public Date ConditionPricingDate
		{ 
			get { return this.getDate ('KDATU'); } 
			set { this.Set (value, 'KDATU'); }
		}

		public Decimal ConditionBaseValue
		{ 
			get { return this.getDecimal ('KAWRT'); } 
			set { this.Set (value, 'KAWRT'); }
		}

		public Decimal Rate
		{ 
			get { return this.getDecimal ('KBETR'); } 
			set { this.Set (value, 'KBETR'); }
		}

		public String CurrencyKey
		{ 
			get { return this.getString ('WAERS'); } 
			set { this.Set (value, 'WAERS'); }
		}

		public Decimal ConditionExchangeRate
		{ 
			get { return this.getDecimal ('KKURS'); } 
			set { this.Set (value, 'KKURS'); }
		}

}
}
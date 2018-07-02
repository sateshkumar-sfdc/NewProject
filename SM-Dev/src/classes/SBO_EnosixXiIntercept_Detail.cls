/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixXiIntercept_Detail extends ENSX.EnosixFramework.DetailSBO {
    
    public SBO_EnosixXiIntercept_Detail() {
    	super('EnosixXiIntercept', SBO_EnosixXiIntercept_Detail.EnosixXiIntercept.class);
    }

	public override Type getType() { return SBO_EnosixXiIntercept_Detail.class; }

	public EnosixXiIntercept initialize(EnosixXiIntercept obj) {
    	return (EnosixXiIntercept)this.executeInitialize(obj);
    }
    
    public EnosixXiIntercept getDetail(object key) {
    	return (EnosixXiIntercept)this.executeGetDetail(key);
    }
    
    public EnosixXiIntercept save(EnosixXiIntercept obj) {
    	return (EnosixXiIntercept) this.executeSave(obj);
    }

    public EnosixXiIntercept command(string command, EnosixXiIntercept obj) {
    	return (EnosixXiIntercept) this.executeCommand(command, obj);
    }
    
    public with sharing class EnosixXiIntercept extends ENSX.EnosixFramework.DetailObject {
     	public EnosixXiIntercept() {
			super('HEADER', new Map<string,type>{'RESPONSE' => SBO_EnosixXiIntercept_Detail.RESPONSE.class
,'CMPI_LOOKUP' => SBO_EnosixXiIntercept_Detail.CMPI_LOOKUP.class
,'CMPI_AUTHENTICATE' => SBO_EnosixXiIntercept_Detail.CMPI_AUTHENTICATE.class
,'FIELDS' => SBO_EnosixXiIntercept_Detail.FIELDS.class
,'PAYMENT_TYPES' => SBO_EnosixXiIntercept_Detail.PAYMENT_TYPES.class
});	
    	}

		public override Type getType() { return SBO_EnosixXiIntercept_Detail.EnosixXiIntercept.class; }

				public String MerchantGUID
		{ 
			get { return this.getString ('MERCHANTGUID'); } 
			set { this.Set (value, 'MERCHANTGUID'); }
		}

		public String AccessToken
		{ 
			get { return this.getString ('ACCESSTOKEN'); } 
			set { this.Set (value, 'ACCESSTOKEN'); }
		}

		public String Signature
		{ 
			get { return this.getString ('SIGNATURE'); } 
			set { this.Set (value, 'SIGNATURE'); }
		}

		public String StatusCode
		{ 
			get { return this.getString ('STATUSCODE'); } 
			set { this.Set (value, 'STATUSCODE'); }
		}

		public String Message
		{ 
			get { return this.getString ('MESSAGE'); } 
			set { this.Set (value, 'MESSAGE'); }
		}

		public String XiInterceptURL
		{ 
			get { return this.getString ('XIURL'); } 
			set { this.Set (value, 'XIURL'); }
		}

		public String Key
		{ 
			get { return this.getString ('KEY'); } 
			set { this.Set (value, 'KEY'); }
		}

		public String CreditCardNumber
		{ 
			get { return this.getString ('CCNUM'); } 
			set { this.Set (value, 'CCNUM'); }
		}

		public String CreditCardHolder
		{ 
			get { return this.getString ('CCNAM'); } 
			set { this.Set (value, 'CCNAM'); }
		}

		public String ValidToMonth
		{ 
			get { return this.getString ('VALTM'); } 
			set { this.Set (value, 'VALTM'); }
		}

		public String ValidToYear
		{ 
			get { return this.getString ('VALTY'); } 
			set { this.Set (value, 'VALTY'); }
		}

		public String CardVerificationValue
		{ 
			get { return this.getString ('CCSCD'); } 
			set { this.Set (value, 'CCSCD'); }
		}

		public String HostUri
		{ 
			get { return this.getString ('HOSTURI'); } 
			set { this.Set (value, 'HOSTURI'); }
		}

		public String CSSUri
		{ 
			get { return this.getString ('CSSURI'); } 
			set { this.Set (value, 'CSSURI'); }
		}


		public SBO_EnosixXiIntercept_Detail.RESPONSE RESPONSE {
			get { return (SBO_EnosixXiIntercept_Detail.RESPONSE)this.getStruct(SBO_EnosixXiIntercept_Detail.RESPONSE.class); }
		}
		
		
		public SBO_EnosixXiIntercept_Detail.CMPI_LOOKUP CMPI_LOOKUP {
			get { return (SBO_EnosixXiIntercept_Detail.CMPI_LOOKUP)this.getStruct(SBO_EnosixXiIntercept_Detail.CMPI_LOOKUP.class); }
		}
		
		
		public SBO_EnosixXiIntercept_Detail.CMPI_AUTHENTICATE CMPI_AUTHENTICATE {
			get { return (SBO_EnosixXiIntercept_Detail.CMPI_AUTHENTICATE)this.getStruct(SBO_EnosixXiIntercept_Detail.CMPI_AUTHENTICATE.class); }
		}
		
				
		public ENSX.EnosixFramework.FrameworkCollection FIELDS {
    		get { return this.getCollection(SBO_EnosixXiIntercept_Detail.FIELDS.class); }
    	}

				
		public ENSX.EnosixFramework.FrameworkCollection PAYMENT_TYPES {
    		get { return this.getCollection(SBO_EnosixXiIntercept_Detail.PAYMENT_TYPES.class); }
    	}

				
	}

	//Write child objects
	public class RESPONSE extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixXiIntercept_Detail.RESPONSE.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String StatusCode
		{ 
			get { return this.getString ('STATUSCODE'); } 
			set { this.Set (value, 'STATUSCODE'); }
		}

		public String Message
		{ 
			get { return this.getString ('MESSAGE'); } 
			set { this.Set (value, 'MESSAGE'); }
		}

		public String CreditCardNumber
		{ 
			get { return this.getString ('CCNUM'); } 
			set { this.Set (value, 'CCNUM'); }
		}

		public String PaymetricCardType
		{ 
			get { return this.getString ('CARD_TYPE'); } 
			set { this.Set (value, 'CARD_TYPE'); }
		}

		public String CreditCardHolder
		{ 
			get { return this.getString ('CCNAM'); } 
			set { this.Set (value, 'CCNAM'); }
		}

		public String ValidToMonth
		{ 
			get { return this.getString ('VALTM'); } 
			set { this.Set (value, 'VALTM'); }
		}

		public String ValidToYear
		{ 
			get { return this.getString ('VALTY'); } 
			set { this.Set (value, 'VALTY'); }
		}

		public String CardVerificationValue
		{ 
			get { return this.getString ('CCSCD'); } 
			set { this.Set (value, 'CCSCD'); }
		}

		public String SAPCardType
		{ 
			get { return this.getString ('SAP_CARD_TYPE'); } 
			set { this.Set (value, 'SAP_CARD_TYPE'); }
		}

}
public class CMPI_LOOKUP extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixXiIntercept_Detail.CMPI_LOOKUP.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String ErrorNo
		{ 
			get { return this.getString ('ERRORNO'); } 
			set { this.Set (value, 'ERRORNO'); }
		}

		public String ErrorDescription
		{ 
			get { return this.getString ('ERRORDESC'); } 
			set { this.Set (value, 'ERRORDESC'); }
		}

		public String Secure3DECIFlag
		{ 
			get { return this.getString ('ECIFLG'); } 
			set { this.Set (value, 'ECIFLG'); }
		}

		public String AvailabilityStatus
		{ 
			get { return this.getString ('ENROLLED'); } 
			set { this.Set (value, 'ENROLLED'); }
		}

		public String CentinelTransactionID
		{ 
			get { return this.getString ('TRANSACTIONID'); } 
			set { this.Set (value, 'TRANSACTIONID'); }
		}

		public String CentinelOrderID
		{ 
			get { return this.getString ('ORDERID'); } 
			set { this.Set (value, 'ORDERID'); }
		}

		public String EncodedPaymentRequest
		{ 
			get { return this.getString ('PAYLOAD'); } 
			set { this.Set (value, 'PAYLOAD'); }
		}

		public String RedirectURL
		{ 
			get { return this.getString ('ACSURL'); } 
			set { this.Set (value, 'ACSURL'); }
		}

}
public class CMPI_AUTHENTICATE extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixXiIntercept_Detail.CMPI_AUTHENTICATE.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String Secure3DECIFlag
		{ 
			get { return this.getString ('ECIFLG'); } 
			set { this.Set (value, 'ECIFLG'); }
		}

		public String ParesStatus
		{ 
			get { return this.getString ('PARESSTATUS'); } 
			set { this.Set (value, 'PARESSTATUS'); }
		}

		public String SignatureVerification
		{ 
			get { return this.getString ('SIGNVERI'); } 
			set { this.Set (value, 'SIGNVERI'); }
		}

		public String CardinallXID
		{ 
			get { return this.getString ('XID'); } 
			set { this.Set (value, 'XID'); }
		}

		public String ErrorNo
		{ 
			get { return this.getString ('ERRORNO'); } 
			set { this.Set (value, 'ERRORNO'); }
		}

		public String ErrorDescription
		{ 
			get { return this.getString ('ERRORDESC'); } 
			set { this.Set (value, 'ERRORDESC'); }
		}

		public String Secure3DCAVV
		{ 
			get { return this.getString ('CAVV'); } 
			set { this.Set (value, 'CAVV'); }
		}

}
public class FIELDS extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixXiIntercept_Detail.FIELDS.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'NAME' };
	
		return keyFields;
	}

			public String Name
		{ 
			get { return this.getString ('NAME'); } 
			set { this.Set (value, 'NAME'); }
		}

		public String Value
		{ 
			get { return this.getString ('VALUE'); } 
			set { this.Set (value, 'VALUE'); }
		}

}
public class PAYMENT_TYPES extends ENSX.EnosixFramework.ValueObject 
{
	public override Type getType() { return SBO_EnosixXiIntercept_Detail.PAYMENT_TYPES.class; }

	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'TYPE','VALUE' };
	
		return keyFields;
	}

			public String PaymentType
		{ 
			get { return this.getString ('TYPE'); } 
			set { this.Set (value, 'TYPE'); }
		}

		public String Value
		{ 
			get { return this.getString ('VALUE'); } 
			set { this.Set (value, 'VALUE'); }
		}

		public String Text
		{ 
			get { return this.getString ('TEXT'); } 
			set { this.Set (value, 'TEXT'); }
		}

}
}
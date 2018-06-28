public with sharing class SBO_EnosixCCPreauth_Detail extends ENSX.EnosixFramework.DetailSBO {
    
    public SBO_EnosixCCPreauth_Detail() {
    	super('EnosixCCPreauth', SBO_EnosixCCPreauth_Detail.EnosixCCPreauth.class);
    }

	public EnosixCCPreauth initialize(EnosixCCPreauth obj) {
    	return (EnosixCCPreauth)this.executeInitialize(obj);
    }
    
    public EnosixCCPreauth getDetail(object key) {
    	return (EnosixCCPreauth)this.executeGetDetail(key);
    }
    
    public EnosixCCPreauth save(EnosixCCPreauth obj) {
    	return (EnosixCCPreauth) this.executeSave(obj);
    }

    public EnosixCCPreauth command(string command, EnosixCCPreauth obj) {
    	return (EnosixCCPreauth) this.executeCommand(command, obj);
    }
    
    public with sharing class EnosixCCPreauth extends ENSX.EnosixFramework.DetailObject {
     	public EnosixCCPreauth() {
		super('HEADER', new Map<string,type>{'RESPONSE' => SBO_EnosixCCPreauth_Detail.RESPONSE.class
});	

    	}

				public String CreditCardNumber
		{ 
			get { return this.getString ('CCNUM'); } 
			set { this.Set (value, 'CCNUM'); }
		}

		public String CardVerificationValue
		{ 
			get { return this.getString ('CVVAL'); } 
			set { this.Set (value, 'CVVAL'); }
		}

		public Decimal AmountToBeAuthorized
		{ 
			get { return this.getDecimal ('AUTWV'); } 
			set { this.Set (value, 'AUTWV'); }
		}

		public String Currencies
		{ 
			get { return this.getString ('CCWAE'); } 
			set { this.Set (value, 'CCWAE'); }
		}

		public String CardType
		{ 
			get { return this.getString ('CCINS'); } 
			set { this.Set (value, 'CCINS'); }
		}

		public String CadholderName
		{ 
			get { return this.getString ('CCNAME'); } 
			set { this.Set (value, 'CCNAME'); }
		}

		public Date ValidToDate
		{ 
			get { return this.getDate ('DATBI'); } 
			set { this.Set (value, 'DATBI'); }
		}


		public SBO_EnosixCCPreauth_Detail.RESPONSE RESPONSE {
			get { return (SBO_EnosixCCPreauth_Detail.RESPONSE)this.getStruct(SBO_EnosixCCPreauth_Detail.RESPONSE.class); }
		}
		
				
	}

	//Write child objects
	public class RESPONSE extends ENSX.EnosixFramework.ValueObject 
{
	public override List<string> getKeyFields()
	{
		List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		return keyFields;
	}

			public String AuthorizationResponse
		{ 
			get { return this.getString ('REACT'); } 
			set { this.Set (value, 'REACT'); }
		}

		public Decimal AuthorizedAmount
		{ 
			get { return this.getDecimal ('AUTWR'); } 
			set { this.Set (value, 'AUTWR'); }
		}

		public String AuthorizationNumber
		{ 
			get { return this.getString ('AUNUM'); } 
			set { this.Set (value, 'AUNUM'); }
		}

		public String AuthorizationReferenceCode
		{ 
			get { return this.getString ('AUTRA'); } 
			set { this.Set (value, 'AUTRA'); }
		}

		public String ResultCode
		{ 
			get { return this.getString ('RCRSP'); } 
			set { this.Set (value, 'RCRSP'); }
		}

		public String ResultCodeText
		{ 
			get { return this.getString ('RTEXT'); } 
			set { this.Set (value, 'RTEXT'); }
		}

		public String CVVResultCode
		{ 
			get { return this.getString ('RCCVV'); } 
			set { this.Set (value, 'RCCVV'); }
		}

}
}
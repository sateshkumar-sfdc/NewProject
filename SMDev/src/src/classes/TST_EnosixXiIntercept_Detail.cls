/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_EnosixXiIntercept_Detail{
	@isTest
	static void testEnosixXiIntercept(){
		SBO_EnosixXiIntercept_Detail.EnosixXiIntercept sbo = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();
		System.assertEquals(SBO_EnosixXiIntercept_Detail.EnosixXiIntercept.class, sbo.getType(), 'getType() does not match object type.');
				sbo.MerchantGUID = 'X';
		System.assertEquals('X', sbo.MerchantGUID);

		sbo.AccessToken = 'X';
		System.assertEquals('X', sbo.AccessToken);

		sbo.Signature = 'X';
		System.assertEquals('X', sbo.Signature);

		sbo.StatusCode = 'X';
		System.assertEquals('X', sbo.StatusCode);

		sbo.Message = 'X';
		System.assertEquals('X', sbo.Message);

		sbo.XiInterceptURL = 'X';
		System.assertEquals('X', sbo.XiInterceptURL);

		sbo.Key = 'X';
		System.assertEquals('X', sbo.Key);

		sbo.CreditCardNumber = 'X';
		System.assertEquals('X', sbo.CreditCardNumber);

		sbo.CreditCardHolder = 'X';
		System.assertEquals('X', sbo.CreditCardHolder);

		sbo.ValidToMonth = 'X';
		System.assertEquals('X', sbo.ValidToMonth);

		sbo.ValidToYear = 'X';
		System.assertEquals('X', sbo.ValidToYear);

		sbo.CardVerificationValue = 'X';
		System.assertEquals('X', sbo.CardVerificationValue);

		sbo.HostUri = 'X';
		System.assertEquals('X', sbo.HostUri);

		sbo.CSSUri = 'X';
		System.assertEquals('X', sbo.CSSUri);

		//Test child collections
		System.assertNotEquals(null,sbo.RESPONSE);
		System.assertNotEquals(null,sbo.CMPI_LOOKUP);
		System.assertNotEquals(null,sbo.CMPI_AUTHENTICATE);
		System.assertNotEquals(null,sbo.FIELDS);
		System.assertNotEquals(null,sbo.PAYMENT_TYPES);
	}

		@isTest
	static void testRESPONSE()
	{
		SBO_EnosixXiIntercept_Detail.RESPONSE childObj = new SBO_EnosixXiIntercept_Detail.RESPONSE();

		System.assertEquals(SBO_EnosixXiIntercept_Detail.RESPONSE.class,childObj.getType(),'getType() does not match object type.');
			childObj.StatusCode = 'X';
		System.assertEquals('X', childObj.StatusCode);

		childObj.Message = 'X';
		System.assertEquals('X', childObj.Message);

		childObj.CreditCardNumber = 'X';
		System.assertEquals('X', childObj.CreditCardNumber);

		childObj.PaymetricCardType = 'X';
		System.assertEquals('X', childObj.PaymetricCardType);

		childObj.CreditCardHolder = 'X';
		System.assertEquals('X', childObj.CreditCardHolder);

		childObj.ValidToMonth = 'X';
		System.assertEquals('X', childObj.ValidToMonth);

		childObj.ValidToYear = 'X';
		System.assertEquals('X', childObj.ValidToYear);

		childObj.CardVerificationValue = 'X';
		System.assertEquals('X', childObj.CardVerificationValue);

		childObj.SAPCardType = 'X';
		System.assertEquals('X', childObj.SAPCardType);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testCMPI_LOOKUP()
	{
		SBO_EnosixXiIntercept_Detail.CMPI_LOOKUP childObj = new SBO_EnosixXiIntercept_Detail.CMPI_LOOKUP();

		System.assertEquals(SBO_EnosixXiIntercept_Detail.CMPI_LOOKUP.class,childObj.getType(),'getType() does not match object type.');
			childObj.ErrorNo = 'X';
		System.assertEquals('X', childObj.ErrorNo);

		childObj.ErrorDescription = 'X';
		System.assertEquals('X', childObj.ErrorDescription);

		childObj.Secure3DECIFlag = 'X';
		System.assertEquals('X', childObj.Secure3DECIFlag);

		childObj.AvailabilityStatus = 'X';
		System.assertEquals('X', childObj.AvailabilityStatus);

		childObj.CentinelTransactionID = 'X';
		System.assertEquals('X', childObj.CentinelTransactionID);

		childObj.CentinelOrderID = 'X';
		System.assertEquals('X', childObj.CentinelOrderID);

		childObj.EncodedPaymentRequest = 'X';
		System.assertEquals('X', childObj.EncodedPaymentRequest);

		childObj.RedirectURL = 'X';
		System.assertEquals('X', childObj.RedirectURL);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testCMPI_AUTHENTICATE()
	{
		SBO_EnosixXiIntercept_Detail.CMPI_AUTHENTICATE childObj = new SBO_EnosixXiIntercept_Detail.CMPI_AUTHENTICATE();

		System.assertEquals(SBO_EnosixXiIntercept_Detail.CMPI_AUTHENTICATE.class,childObj.getType(),'getType() does not match object type.');
			childObj.Secure3DECIFlag = 'X';
		System.assertEquals('X', childObj.Secure3DECIFlag);

		childObj.ParesStatus = 'X';
		System.assertEquals('X', childObj.ParesStatus);

		childObj.SignatureVerification = 'X';
		System.assertEquals('X', childObj.SignatureVerification);

		childObj.CardinallXID = 'X';
		System.assertEquals('X', childObj.CardinallXID);

		childObj.ErrorNo = 'X';
		System.assertEquals('X', childObj.ErrorNo);

		childObj.ErrorDescription = 'X';
		System.assertEquals('X', childObj.ErrorDescription);

		childObj.Secure3DCAVV = 'X';
		System.assertEquals('X', childObj.Secure3DCAVV);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testFIELDS()
	{
		SBO_EnosixXiIntercept_Detail.FIELDS childObj = new SBO_EnosixXiIntercept_Detail.FIELDS();

		System.assertEquals(SBO_EnosixXiIntercept_Detail.FIELDS.class,childObj.getType(),'getType() does not match object type.');
			childObj.Name = 'X';
		System.assertEquals('X', childObj.Name);

		childObj.Value = 'X';
		System.assertEquals('X', childObj.Value);

List<string> keyFields = new List<string>{ 'NAME' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
	@isTest
	static void testPAYMENT_TYPES()
	{
		SBO_EnosixXiIntercept_Detail.PAYMENT_TYPES childObj = new SBO_EnosixXiIntercept_Detail.PAYMENT_TYPES();

		System.assertEquals(SBO_EnosixXiIntercept_Detail.PAYMENT_TYPES.class,childObj.getType(),'getType() does not match object type.');
			childObj.PaymentType = 'X';
		System.assertEquals('X', childObj.PaymentType);

		childObj.Value = 'X';
		System.assertEquals('X', childObj.Value);

		childObj.Text = 'X';
		System.assertEquals('X', childObj.Text);

List<string> keyFields = new List<string>{ 'TYPE','VALUE' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
}
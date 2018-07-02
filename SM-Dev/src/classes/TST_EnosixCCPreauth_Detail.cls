@isTest
public with sharing class TST_EnosixCCPreauth_Detail{
	@isTest
	static void testEnosixCCPreauth(){
		SBO_EnosixCCPreauth_Detail.EnosixCCPreauth sbo = new SBO_EnosixCCPreauth_Detail.EnosixCCPreauth();
				sbo.CreditCardNumber = 'X';
		System.assertEquals('X', sbo.CreditCardNumber);

		sbo.CardVerificationValue = 'X';
		System.assertEquals('X', sbo.CardVerificationValue);

		sbo.AmountToBeAuthorized = 1.5;
		System.assertEquals(1.5, sbo.AmountToBeAuthorized);

		sbo.Currencies = 'X';
		System.assertEquals('X', sbo.Currencies);

		sbo.CardType = 'X';
		System.assertEquals('X', sbo.CardType);

		sbo.CadholderName = 'X';
		System.assertEquals('X', sbo.CadholderName);

		sbo.ValidToDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), sbo.ValidToDate);

		//Test child collections
		System.assertNotEquals(null,sbo.RESPONSE);
	}

		@isTest
	static void testRESPONSE()
	{
		SBO_EnosixCCPreauth_Detail.RESPONSE childObj = new SBO_EnosixCCPreauth_Detail.RESPONSE();
			childObj.AuthorizationResponse = 'X';
		System.assertEquals('X', childObj.AuthorizationResponse);

		childObj.AuthorizedAmount = 1.5;
		System.assertEquals(1.5, childObj.AuthorizedAmount);

		childObj.AuthorizationNumber = 'X';
		System.assertEquals('X', childObj.AuthorizationNumber);

		childObj.AuthorizationReferenceCode = 'X';
		System.assertEquals('X', childObj.AuthorizationReferenceCode);

		childObj.ResultCode = 'X';
		System.assertEquals('X', childObj.ResultCode);

		childObj.ResultCodeText = 'X';
		System.assertEquals('X', childObj.ResultCodeText);

		childObj.CVVResultCode = 'X';
		System.assertEquals('X', childObj.CVVResultCode);

List<string> keyFields = new List<string>{ 'EnosixObjKey' };
	
		List<string> keys = childObj.getKeyFields();
		for(Integer i = 0; i < keys.size(); i++)
		{
			system.assertEquals(keyFields[i],keys[i]);
		}
	}	
}
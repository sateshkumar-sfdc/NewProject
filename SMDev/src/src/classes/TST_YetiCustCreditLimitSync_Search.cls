/// enosiX Inc. Generated Apex Model
/// Generated On: 1/12/2017 9:56:51 AM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
private class TST_YetiCustCreditLimitSync_Search {

	@isTest 
	static void testSBO() {
		SBO_YetiCustCreditLimitSync_Search sbo = new SBO_YetiCustCreditLimitSync_Search();
		
		System.assertEquals(SBO_YetiCustCreditLimitSync_Search.class, sbo.getType(), 'getType() does not match object type.');

		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_YetiCustCreditLimitSync_Search.SEARCHPARAMS childObj = new SBO_YetiCustCreditLimitSync_Search.SEARCHPARAMS();
		System.assertEquals(SBO_YetiCustCreditLimitSync_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

			childObj.FromCustomerNumber = 'X';
		System.assertEquals('X', childObj.FromCustomerNumber);

		childObj.MAX_ROWS = 0;
		System.assertEquals(0, childObj.MAX_ROWS);

	}
@isTest
static void testYetiCustCreditLimitSync_SR()
{
SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SR sr = new SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SR();

System.assertEquals(SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SR.class, sr.getType(), 'getType() does not match object type.');

System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT childObj = new SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT();
		System.assertEquals(SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

			childObj.CustomerNumber = 'X';
		System.assertEquals('X', childObj.CustomerNumber);

		childObj.CreditSegment = 'X';
		System.assertEquals('X', childObj.CreditSegment);

		childObj.Currencies = 'X';
		System.assertEquals('X', childObj.Currencies);

		childObj.TotalCreditExposure = 1.5;
		System.assertEquals(1.5, childObj.TotalCreditExposure);

		childObj.CreditLimit = 1.5;
		System.assertEquals(1.5, childObj.CreditLimit);

		childObj.HorizonExposure = 1.5;
		System.assertEquals(1.5, childObj.HorizonExposure);

		childObj.HorizonDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.HorizonDate);

		childObj.HorizonInDays = 'X';
		System.assertEquals('X', childObj.HorizonInDays);

		childObj.CreditLimitChangeDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreditLimitChangeDate);

	}

}
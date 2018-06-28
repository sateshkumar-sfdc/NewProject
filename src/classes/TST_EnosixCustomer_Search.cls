/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
private class TST_EnosixCustomer_Search {

	@isTest 
	static void testSBO() {
		SBO_EnosixCustomer_Search sbo = new SBO_EnosixCustomer_Search();
		
		System.assertEquals(SBO_EnosixCustomer_Search.class, sbo.getType(), 'getType() does not match object type.');

		System.assertNotEquals(null, sbo.SearchContext.SEARCHPARAMS);
	}
	
		@isTest
	static void testSEARCHPARAMS(){
	SBO_EnosixCustomer_Search.SEARCHPARAMS childObj = new SBO_EnosixCustomer_Search.SEARCHPARAMS();
		System.assertEquals(SBO_EnosixCustomer_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

			childObj.CustomerNumberFrom = 'X';
		System.assertEquals('X', childObj.CustomerNumberFrom);

		childObj.CustomerNumberTo = 'X';
		System.assertEquals('X', childObj.CustomerNumberTo);

		childObj.CustomerName = 'X';
		System.assertEquals('X', childObj.CustomerName);

		childObj.PostalCode = 'X';
		System.assertEquals('X', childObj.PostalCode);

		childObj.City = 'X';
		System.assertEquals('X', childObj.City);

		childObj.Region = 'X';
		System.assertEquals('X', childObj.Region);

		childObj.Country = 'X';
		System.assertEquals('X', childObj.Country);

		childObj.TelephoneNumber = 'X';
		System.assertEquals('X', childObj.TelephoneNumber);

		childObj.EmailAddress = 'X';
		System.assertEquals('X', childObj.EmailAddress);

	}
@isTest
static void testEnosixCustomer_SR()
{
SBO_EnosixCustomer_Search.EnosixCustomer_SR sr = new SBO_EnosixCustomer_Search.EnosixCustomer_SR();

System.assertEquals(SBO_EnosixCustomer_Search.EnosixCustomer_SR.class, sr.getType(), 'getType() does not match object type.');

System.assertNotEquals(null,sr.SearchResults);
}

	@isTest
	static void testSEARCHRESULT(){
	SBO_EnosixCustomer_Search.SEARCHRESULT childObj = new SBO_EnosixCustomer_Search.SEARCHRESULT();
		System.assertEquals(SBO_EnosixCustomer_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

			childObj.CustomerNumber = 'X';
		System.assertEquals('X', childObj.CustomerNumber);

		childObj.Name = 'X';
		System.assertEquals('X', childObj.Name);

		childObj.Name2 = 'X';
		System.assertEquals('X', childObj.Name2);

		childObj.Street = 'X';
		System.assertEquals('X', childObj.Street);

		childObj.City = 'X';
		System.assertEquals('X', childObj.City);

		childObj.PostalCode = 'X';
		System.assertEquals('X', childObj.PostalCode);

		childObj.Region = 'X';
		System.assertEquals('X', childObj.Region);

		childObj.Country = 'X';
		System.assertEquals('X', childObj.Country);

		childObj.POBox = 'X';
		System.assertEquals('X', childObj.POBox);

		childObj.TelephoneNumber = 'X';
		System.assertEquals('X', childObj.TelephoneNumber);

		childObj.Language = 'X';
		System.assertEquals('X', childObj.Language);

		childObj.CreditLimit = 1.5;
		System.assertEquals(1.5, childObj.CreditLimit);

		childObj.CreditAvailable = 1.5;
		System.assertEquals(1.5, childObj.CreditAvailable);

		childObj.CurrencyKey = 'X';
		System.assertEquals('X', childObj.CurrencyKey);

		childObj.EmailAddress = 'X';
		System.assertEquals('X', childObj.EmailAddress);

	}

}
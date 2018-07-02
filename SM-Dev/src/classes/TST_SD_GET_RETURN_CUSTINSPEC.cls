/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_RETURN_CUSTINSPEC{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_RETURN_CUSTINSPEC.RESULT funcObj = new RFC_SD_GET_RETURN_CUSTINSPEC.RESULT();

		System.assertEquals(RFC_SD_GET_RETURN_CUSTINSPEC.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
		//Check all the collections
		funcObj.getCollection(RFC_SD_GET_RETURN_CUSTINSPEC.ET_CUST_INSPECTION.class).add(new RFC_SD_GET_RETURN_CUSTINSPEC.ET_CUST_INSPECTION());
		System.assertEquals(1,funcObj.ET_CUST_INSPECTION_List.size());

		funcObj.getCollection(RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON.class).add(new RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON());
		System.assertEquals(1,funcObj.ET_ORDER_REASON_List.size());

		funcObj.getCollection(RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE.class).add(new RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE());
		System.assertEquals(1,funcObj.ET_REFUND_TYPE_List.size());

		funcObj.getCollection(RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON.class).add(new RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON());
		System.assertEquals(1,funcObj.ET_RETURN_REASON_List.size());

	}

		@isTest
	static void testET_CUST_INSPECTION()
	{
		RFC_SD_GET_RETURN_CUSTINSPEC.ET_CUST_INSPECTION funcObj = new RFC_SD_GET_RETURN_CUSTINSPEC.ET_CUST_INSPECTION();

		System.assertEquals(RFC_SD_GET_RETURN_CUSTINSPEC.ET_CUST_INSPECTION.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.CODE = 'X';
		System.assertEquals('X', funcObj.CODE);

		funcObj.CODE_TEXT = 'X';
		System.assertEquals('X', funcObj.CODE_TEXT);

	}
		@isTest
	static void testET_ORDER_REASON()
	{
		RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON funcObj = new RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON();

		System.assertEquals(RFC_SD_GET_RETURN_CUSTINSPEC.ET_ORDER_REASON.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.AUGRU = 'X';
		System.assertEquals('X', funcObj.AUGRU);

		funcObj.BEZEI = 'X';
		System.assertEquals('X', funcObj.BEZEI);

	}
		@isTest
	static void testET_REFUND_TYPE()
	{
		RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE funcObj = new RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE();

		System.assertEquals(RFC_SD_GET_RETURN_CUSTINSPEC.ET_REFUND_TYPE.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.REFUND_TYPE = 'X';
		System.assertEquals('X', funcObj.REFUND_TYPE);

		funcObj.REFUND_TYPE_TEXT = 'X';
		System.assertEquals('X', funcObj.REFUND_TYPE_TEXT);

	}
		@isTest
	static void testET_RETURN_REASON()
	{
		RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON funcObj = new RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON();

		System.assertEquals(RFC_SD_GET_RETURN_CUSTINSPEC.ET_RETURN_REASON.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.RET_REASON = 'X';
		System.assertEquals('X', funcObj.RET_REASON);

		funcObj.BEZEI = 'X';
		System.assertEquals('X', funcObj.BEZEI);

	}
	}
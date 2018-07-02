/// enosiX Inc. Generated Apex Model
/// Generated On: 11/23/2016 9:54:50 AM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_CARRIER_LIST{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_CARRIER_LIST.RESULT funcObj = new RFC_SD_GET_CARRIER_LIST.RESULT();

		System.assertEquals(RFC_SD_GET_CARRIER_LIST.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
		//Check all the collections
		funcObj.getCollection(RFC_SD_GET_CARRIER_LIST.ET_OUTPUT.class).add(new RFC_SD_GET_CARRIER_LIST.ET_OUTPUT());
		System.assertEquals(1,funcObj.ET_OUTPUT_List.size());

	}

		@isTest
	static void testET_OUTPUT()
	{
		RFC_SD_GET_CARRIER_LIST.ET_OUTPUT funcObj = new RFC_SD_GET_CARRIER_LIST.ET_OUTPUT();

		System.assertEquals(RFC_SD_GET_CARRIER_LIST.ET_OUTPUT.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.CARRIER = 'X';
		System.assertEquals('X', funcObj.CARRIER);

		funcObj.CARRIER_NAME = 'X';
		System.assertEquals('X', funcObj.CARRIER_NAME);

	}
	}
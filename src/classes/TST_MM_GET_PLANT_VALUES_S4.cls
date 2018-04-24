/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_MM_GET_PLANT_VALUES_S4{

	@isTest
	static void testRESULT()
	{
		RFC_MM_GET_PLANT_VALUES_S4.RESULT funcObj = new RFC_MM_GET_PLANT_VALUES_S4.RESULT();

		System.assertEquals(RFC_MM_GET_PLANT_VALUES_S4.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
		//Check all the collections
		funcObj.getCollection(RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT.class).add(new RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT());
		System.assertEquals(1,funcObj.ET_OUTPUT_List.size());

	}

		@isTest
	static void testET_OUTPUT()
	{
		RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT funcObj = new RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT();

		System.assertEquals(RFC_MM_GET_PLANT_VALUES_S4.ET_OUTPUT.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.WERKS = 'X';
		System.assertEquals('X', funcObj.WERKS);

		funcObj.WERKS_NAME = 'X';
		System.assertEquals('X', funcObj.WERKS_NAME);

	}
	}
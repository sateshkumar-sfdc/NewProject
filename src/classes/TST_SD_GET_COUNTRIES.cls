/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_COUNTRIES{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_COUNTRIES.RESULT funcObj = new RFC_SD_GET_COUNTRIES.RESULT();

		System.assertEquals(RFC_SD_GET_COUNTRIES.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
		//Check all the collections
		funcObj.getCollection(RFC_SD_GET_COUNTRIES.ET_OUTPUT.class).add(new RFC_SD_GET_COUNTRIES.ET_OUTPUT());
		System.assertEquals(1,funcObj.ET_OUTPUT_List.size());

		funcObj.getCollection(RFC_SD_GET_COUNTRIES.ET_REGIONS.class).add(new RFC_SD_GET_COUNTRIES.ET_REGIONS());
		System.assertEquals(1,funcObj.ET_REGIONS_List.size());

	}

		@isTest
	static void testET_OUTPUT()
	{
		RFC_SD_GET_COUNTRIES.ET_OUTPUT funcObj = new RFC_SD_GET_COUNTRIES.ET_OUTPUT();

		System.assertEquals(RFC_SD_GET_COUNTRIES.ET_OUTPUT.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.MANDT = 'X';
		System.assertEquals('X', funcObj.MANDT);

		funcObj.SPRAS = 'X';
		System.assertEquals('X', funcObj.SPRAS);

		funcObj.LAND1 = 'X';
		System.assertEquals('X', funcObj.LAND1);

		funcObj.LANDX = 'X';
		System.assertEquals('X', funcObj.LANDX);

		funcObj.NATIO = 'X';
		System.assertEquals('X', funcObj.NATIO);

		funcObj.LANDX50 = 'X';
		System.assertEquals('X', funcObj.LANDX50);

		funcObj.NATIO50 = 'X';
		System.assertEquals('X', funcObj.NATIO50);

		funcObj.PRQ_SPREGT = 'X';
		System.assertEquals('X', funcObj.PRQ_SPREGT);

	}
		@isTest
	static void testET_REGIONS()
	{
		RFC_SD_GET_COUNTRIES.ET_REGIONS funcObj = new RFC_SD_GET_COUNTRIES.ET_REGIONS();

		System.assertEquals(RFC_SD_GET_COUNTRIES.ET_REGIONS.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.LAND1 = 'X';
		System.assertEquals('X', funcObj.LAND1);

		funcObj.REGIO = 'X';
		System.assertEquals('X', funcObj.REGIO);

		funcObj.BEZEI = 'X';
		System.assertEquals('X', funcObj.BEZEI);

	}
	}
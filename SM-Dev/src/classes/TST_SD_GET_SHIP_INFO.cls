/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_SHIP_INFO{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_SHIP_INFO.RESULT funcObj = new RFC_SD_GET_SHIP_INFO.RESULT();

		System.assertEquals(RFC_SD_GET_SHIP_INFO.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
		//Check all the collections
		funcObj.getCollection(RFC_SD_GET_SHIP_INFO.ET_FREIGHT_TERMS.class).add(new RFC_SD_GET_SHIP_INFO.ET_FREIGHT_TERMS());
		System.assertEquals(1,funcObj.ET_FREIGHT_TERMS_List.size());

		funcObj.getCollection(RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS.class).add(new RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS());
		System.assertEquals(1,funcObj.ET_PAY_TERMS_List.size());

		funcObj.getCollection(RFC_SD_GET_SHIP_INFO.ET_SHIP_COND.class).add(new RFC_SD_GET_SHIP_INFO.ET_SHIP_COND());
		System.assertEquals(1,funcObj.ET_SHIP_COND_List.size());

	}

		@isTest
	static void testET_FREIGHT_TERMS()
	{
		RFC_SD_GET_SHIP_INFO.ET_FREIGHT_TERMS funcObj = new RFC_SD_GET_SHIP_INFO.ET_FREIGHT_TERMS();

		System.assertEquals(RFC_SD_GET_SHIP_INFO.ET_FREIGHT_TERMS.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.INCO1 = 'X';
		System.assertEquals('X', funcObj.INCO1);

		funcObj.BEZEI = 'X';
		System.assertEquals('X', funcObj.BEZEI);

	}
		@isTest
	static void testET_PAY_TERMS()
	{
		RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS funcObj = new RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS();

		System.assertEquals(RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.ZTERM = 'X';
		System.assertEquals('X', funcObj.ZTERM);

		funcObj.VTEXT = 'X';
		System.assertEquals('X', funcObj.VTEXT);

	}
		@isTest
	static void testET_SHIP_COND()
	{
		RFC_SD_GET_SHIP_INFO.ET_SHIP_COND funcObj = new RFC_SD_GET_SHIP_INFO.ET_SHIP_COND();

		System.assertEquals(RFC_SD_GET_SHIP_INFO.ET_SHIP_COND.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.VSBED = 'X';
		System.assertEquals('X', funcObj.VSBED);

		funcObj.VTEXT = 'X';
		System.assertEquals('X', funcObj.VTEXT);

	}
	}
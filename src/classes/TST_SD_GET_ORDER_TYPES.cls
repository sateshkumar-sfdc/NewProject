/// enosiX Inc. Generated Apex Model
/// Generated On: 1/9/2017 12:00:33 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_ORDER_TYPES{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_ORDER_TYPES.RESULT funcObj = new RFC_SD_GET_ORDER_TYPES.RESULT();

		System.assertEquals(RFC_SD_GET_ORDER_TYPES.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
			funcObj.IV_BOPROCESS = 'X';
		System.assertEquals('X', funcObj.IV_BOPROCESS);

		funcObj.IV_BOTYPE = 'X';
		System.assertEquals('X', funcObj.IV_BOTYPE);

		funcObj.IV_CID = 'X';
		System.assertEquals('X', funcObj.IV_CID);

		funcObj.IV_LANGU = 'X';
		System.assertEquals('X', funcObj.IV_LANGU);

		funcObj.IV_USERNAME = 'X';
		System.assertEquals('X', funcObj.IV_USERNAME);

	//Check all the collections
		funcObj.getCollection(RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class).add(new RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT());
		System.assertEquals(1,funcObj.ET_ITEM_CAT_List.size());

		funcObj.getCollection(RFC_SD_GET_ORDER_TYPES.ET_VALUES.class).add(new RFC_SD_GET_ORDER_TYPES.ET_VALUES());
		System.assertEquals(1,funcObj.ET_VALUES_List.size());

	}

		@isTest
	static void testET_ITEM_CAT()
	{
		RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT funcObj = new RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT();

		System.assertEquals(RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.AUART = 'X';
		System.assertEquals('X', funcObj.AUART);

		funcObj.PSTYV = 'X';
		System.assertEquals('X', funcObj.PSTYV);

	}
		@isTest
	static void testET_VALUES()
	{
		RFC_SD_GET_ORDER_TYPES.ET_VALUES funcObj = new RFC_SD_GET_ORDER_TYPES.ET_VALUES();

		System.assertEquals(RFC_SD_GET_ORDER_TYPES.ET_VALUES.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.VALUE = 'X';
		System.assertEquals('X', funcObj.VALUE);

		funcObj.DESCRIPTION = 'X';
		System.assertEquals('X', funcObj.DESCRIPTION);

	}
	}
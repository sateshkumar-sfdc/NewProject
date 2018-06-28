/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_DOC_CATEG_VALUES{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_DOC_CATEG_VALUES.RESULT funcObj = new RFC_SD_GET_DOC_CATEG_VALUES.RESULT();

		System.assertEquals(RFC_SD_GET_DOC_CATEG_VALUES.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
			funcObj.IV_DOMAIN_NAME = 'X';
		System.assertEquals('X', funcObj.IV_DOMAIN_NAME);

	//Check all the collections
		funcObj.getCollection(RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES.class).add(new RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES());
		System.assertEquals(1,funcObj.ET_VALUES_List.size());

	}

		@isTest
	static void testET_VALUES()
	{
		RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES funcObj = new RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES();

		System.assertEquals(RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.VBTYP = 'X';
		System.assertEquals('X', funcObj.VBTYP);

		funcObj.VBTYP_TEXT = 'X';
		System.assertEquals('X', funcObj.VBTYP_TEXT);

	}
	}
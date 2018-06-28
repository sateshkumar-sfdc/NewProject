/// enosiX Inc. Generated Apex Model
/// Generated On: 1/12/2017 2:53:57 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_CONDITION_GROUP{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_CONDITION_GROUP.RESULT funcObj = new RFC_SD_GET_CONDITION_GROUP.RESULT();

		System.assertEquals(RFC_SD_GET_CONDITION_GROUP.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
		//Check all the collections
		funcObj.getCollection(RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP.class).add(new RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP());
		System.assertEquals(1,funcObj.ET_COND_GROUP_List.size());

	}

		@isTest
	static void testET_COND_GROUP()
	{
		RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP funcObj = new RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP();

		System.assertEquals(RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.KDKGR = 'X';
		System.assertEquals('X', funcObj.KDKGR);

		funcObj.VTEXT = 'X';
		System.assertEquals('X', funcObj.VTEXT);

	}
	}
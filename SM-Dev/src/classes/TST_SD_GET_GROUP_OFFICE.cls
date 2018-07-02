/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_GROUP_OFFICE{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_GROUP_OFFICE.RESULT funcObj = new RFC_SD_GET_GROUP_OFFICE.RESULT();

		System.assertEquals(RFC_SD_GET_GROUP_OFFICE.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
		//Check all the collections
		funcObj.getCollection(RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT.class).add(new RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT());
		System.assertEquals(1,funcObj.ET_SALES_DISTRICT_List.size());

		funcObj.getCollection(RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP.class).add(new RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP());
		System.assertEquals(1,funcObj.ET_SALES_GROUP_List.size());

		funcObj.getCollection(RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE.class).add(new RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE());
		System.assertEquals(1,funcObj.ET_SALES_OFFICE_List.size());

	}

		@isTest
	static void testET_SALES_DISTRICT()
	{
		RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT funcObj = new RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT();

		System.assertEquals(RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.BZIRK = 'X';
		System.assertEquals('X', funcObj.BZIRK);

		funcObj.BZTXT = 'X';
		System.assertEquals('X', funcObj.BZTXT);

	}
		@isTest
	static void testET_SALES_GROUP()
	{
		RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP funcObj = new RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP();

		System.assertEquals(RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.VKBUR = 'X';
		System.assertEquals('X', funcObj.VKBUR);

		funcObj.VKGRP = 'X';
		System.assertEquals('X', funcObj.VKGRP);

		funcObj.BEZEI = 'X';
		System.assertEquals('X', funcObj.BEZEI);

	}
		@isTest
	static void testET_SALES_OFFICE()
	{
		RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE funcObj = new RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE();

		System.assertEquals(RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.VKORG = 'X';
		System.assertEquals('X', funcObj.VKORG);

		funcObj.VTWEG = 'X';
		System.assertEquals('X', funcObj.VTWEG);

		funcObj.SPART = 'X';
		System.assertEquals('X', funcObj.SPART);

		funcObj.VKBUR = 'X';
		System.assertEquals('X', funcObj.VKBUR);

		funcObj.BEZEI = 'X';
		System.assertEquals('X', funcObj.BEZEI);

	}
	}
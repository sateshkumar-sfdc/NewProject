/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_PRICING_STAT{

	@isTest
	static void testRESULT()
	{
		RFC_SD_GET_PRICING_STAT.RESULT funcObj = new RFC_SD_GET_PRICING_STAT.RESULT();

		System.assertEquals(RFC_SD_GET_PRICING_STAT.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
		//Check all the collections
		funcObj.getCollection(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP.class).add(new RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP());
		System.assertEquals(1,funcObj.ET_CUST_PRICE_GRP_List.size());

		funcObj.getCollection(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST.class).add(new RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST());
		System.assertEquals(1,funcObj.ET_CUST_PRICE_LIST_List.size());

		funcObj.getCollection(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC.class).add(new RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC());
		System.assertEquals(1,funcObj.ET_CUST_PRICE_PROC_List.size());

		funcObj.getCollection(RFC_SD_GET_PRICING_STAT.ET_CUST_STAT_GROUP.class).add(new RFC_SD_GET_PRICING_STAT.ET_CUST_STAT_GROUP());
		System.assertEquals(1,funcObj.ET_CUST_STAT_GROUP_List.size());

	}

		@isTest
	static void testET_CUST_PRICE_GRP()
	{
		RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP funcObj = new RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP();

		System.assertEquals(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_GRP.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.KONDA = 'X';
		System.assertEquals('X', funcObj.KONDA);

		funcObj.VTEXT = 'X';
		System.assertEquals('X', funcObj.VTEXT);

	}
		@isTest
	static void testET_CUST_PRICE_LIST()
	{
		RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST funcObj = new RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST();

		System.assertEquals(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_LIST.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.PLTYP = 'X';
		System.assertEquals('X', funcObj.PLTYP);

		funcObj.PTEXT = 'X';
		System.assertEquals('X', funcObj.PTEXT);

	}
		@isTest
	static void testET_CUST_PRICE_PROC()
	{
		RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC funcObj = new RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC();

		System.assertEquals(RFC_SD_GET_PRICING_STAT.ET_CUST_PRICE_PROC.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.KALKS = 'X';
		System.assertEquals('X', funcObj.KALKS);

		funcObj.VTEXT = 'X';
		System.assertEquals('X', funcObj.VTEXT);

	}
		@isTest
	static void testET_CUST_STAT_GROUP()
	{
		RFC_SD_GET_PRICING_STAT.ET_CUST_STAT_GROUP funcObj = new RFC_SD_GET_PRICING_STAT.ET_CUST_STAT_GROUP();

		System.assertEquals(RFC_SD_GET_PRICING_STAT.ET_CUST_STAT_GROUP.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.STGKU = 'X';
		System.assertEquals('X', funcObj.STGKU);

		funcObj.BEZEI20 = 'X';
		System.assertEquals('X', funcObj.BEZEI20);

	}
	}
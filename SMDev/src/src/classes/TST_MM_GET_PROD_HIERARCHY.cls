/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_MM_GET_PROD_HIERARCHY{

	@isTest
	static void testRESULT()
	{
		RFC_MM_GET_PROD_HIERARCHY.RESULT funcObj = new RFC_MM_GET_PROD_HIERARCHY.RESULT();

		System.assertEquals(RFC_MM_GET_PROD_HIERARCHY.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
			funcObj.IV_LEVEL_NUMBER = 'X';
		System.assertEquals('X', funcObj.IV_LEVEL_NUMBER);

	//Check all the collections
		funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class).add(new RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE());
		System.assertEquals(1,funcObj.ET_MATERIAL_TYPE_List.size());

		funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class).add(new RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB());
		System.assertEquals(1,funcObj.ET_PRODUCT_ATTRIB_List.size());

		funcObj.getCollection(RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class).add(new RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY());
		System.assertEquals(1,funcObj.ET_PROD_HIERARCHY_List.size());

	}

		@isTest
	static void testET_MATERIAL_TYPE()
	{
		RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE funcObj = new RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE();

		System.assertEquals(RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.MTART = 'X';
		System.assertEquals('X', funcObj.MTART);

		funcObj.MTBEZ = 'X';
		System.assertEquals('X', funcObj.MTBEZ);

	}
		@isTest
	static void testET_PRODUCT_ATTRIB()
	{
		RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB funcObj = new RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB();

		System.assertEquals(RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.PRODUCT_ATTRIB = 'X';
		System.assertEquals('X', funcObj.PRODUCT_ATTRIB);

	}
		@isTest
	static void testET_PROD_HIERARCHY()
	{
		RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY funcObj = new RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY();

		System.assertEquals(RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class, funcObj.getType(), 'getType() does not match object type.');
				funcObj.PRODH = 'X';
		System.assertEquals('X', funcObj.PRODH);

		funcObj.STUFE = 'X';
		System.assertEquals('X', funcObj.STUFE);

		funcObj.VTEXT = 'X';
		System.assertEquals('X', funcObj.VTEXT);

	}
	}
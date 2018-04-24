@isTest
public with sharing class TST_SD_GET_DOC_TYPE_VALUES{

	@isTest
	static void testRESULT()
	{
	RFC_SD_GET_DOC_TYPE_VALUES.RESULT funcObj = new RFC_SD_GET_DOC_TYPE_VALUES.RESULT();
		}

		@isTest
	static void testET_OUTPUT()
	{
		RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT funcObj = new RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT();

				funcObj.AUART = 'X';
		System.assertEquals('X', funcObj.AUART);

		funcObj.BEZEI = 'X';
		System.assertEquals('X', funcObj.BEZEI);

		funcObj.VBTYP = 'X';
		System.assertEquals('X', funcObj.VBTYP);

		funcObj.VBTYP_TEXT = 'X';
		System.assertEquals('X', funcObj.VBTYP_TEXT);

		funcObj.INCPO = 'X';
		System.assertEquals('X', funcObj.INCPO);

		funcObj.X_PONUM_REQUIRED = 'X';
		System.assertEquals('X', funcObj.X_PONUM_REQUIRED);

	}
}
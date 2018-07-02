@isTest
public with sharing class TST_SD_GET_BP_ROLE_TYPE {

    @isTest
    static void testRESULT() {
        RFC_SD_GET_BP_ROLE_TYPE.RESULT funcObj = new RFC_SD_GET_BP_ROLE_TYPE.RESULT();

    }

    @isTest
    static void testET_BP_CATEGORY() {
        RFC_SD_GET_BP_ROLE_TYPE.ET_BP_CATEGORY funcObj = new RFC_SD_GET_BP_ROLE_TYPE.ET_BP_CATEGORY();

        funcObj.Category = 'X';
        System.assertEquals('X', funcObj.Category);

        funcObj.Description = 'X';
        System.assertEquals('X', funcObj.Description);

    }
    @isTest
    static void testET_BP_ROLE() {
        RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE funcObj = new RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE();

        funcObj.Role = 'X';
        System.assertEquals('X', funcObj.Role);

        funcObj.ForPerson = true;
        System.assertEquals(true, funcObj.ForPerson);

        funcObj.ForOrg = true;
        System.assertEquals(true, funcObj.ForOrg);

        funcObj.ForGroup = true;
        System.assertEquals(true, funcObj.ForGroup);

        funcObj.Description = 'X';
        System.assertEquals('X', funcObj.Description);

    }

    @isTest
    static void testET_BP_ROLE_GROUP() {
        RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP funcObj = new RFC_SD_GET_BP_ROLE_TYPE.ET_BP_ROLE_GROUP();

        funcObj.RLTGR = 'X';
        System.assertEquals('X', funcObj.RLTGR);

        funcObj.RLTGRTXT = 'X';
        System.assertEquals('X', funcObj.RLTGRTXT);

    }

    @isTest
    static void testET_BP_TYPE() {
        RFC_SD_GET_BP_ROLE_TYPE.ET_BP_TYPE funcObj = new RFC_SD_GET_BP_ROLE_TYPE.ET_BP_TYPE();

        funcObj.Type = 'X';
        System.assertEquals('X', funcObj.Type);

        funcObj.Description = 'X';
        System.assertEquals('X', funcObj.Description);

    }
}
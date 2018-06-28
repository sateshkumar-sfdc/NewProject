/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public with sharing class TST_SD_GET_SALES_AREAS {

    @isTest
    static void testRESULT() {
        RFC_SD_GET_SALES_AREAS.RESULT funcObj = new RFC_SD_GET_SALES_AREAS.RESULT();

        System.assertEquals(RFC_SD_GET_SALES_AREAS.RESULT.class, funcObj.getType(), 'getType() does not match object type.');
        //Check all the collections
        funcObj.getCollection(RFC_SD_GET_SALES_AREAS.ET_SALES_AREA.class).add(new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA());
        System.assertEquals(1, funcObj.SalesAreas.size());

    }

    @isTest
    static void testET_SALES_AREA() {
        RFC_SD_GET_SALES_AREAS.ET_SALES_AREA funcObj = new RFC_SD_GET_SALES_AREAS.ET_SALES_AREA();

        System.assertEquals(RFC_SD_GET_SALES_AREAS.ET_SALES_AREA.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.SalesOrganization = 'X';
        System.assertEquals('X', funcObj.SalesOrganization);

        funcObj.SalesOrganizationName = 'X';
        System.assertEquals('X', funcObj.SalesOrganizationName);

        funcObj.DistributionChannel = 'X';
        System.assertEquals('X', funcObj.DistributionChannel);

        funcObj.DistributionChannelName = 'X';
        System.assertEquals('X', funcObj.DistributionChannelName);

        funcObj.Division = 'X';
        System.assertEquals('X', funcObj.Division);

        funcObj.DivisionName = 'X';
        System.assertEquals('X', funcObj.DivisionName);

    }
}
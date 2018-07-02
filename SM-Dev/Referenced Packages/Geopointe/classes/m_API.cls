/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/mAPI/*')
global class m_API {
    global m_API() {

    }
    webService static String checkIn(String authToken, Decimal whereLatDec, Decimal whereLngDec, String note, Boolean chatterThis, String whatId, String whatText) {
        return null;
    }
    webService static String dataSetList(String authToken) {
        return null;
    }
    webService static String deleteRoute(String authToken, String routeId) {
        return null;
    }
    webService static String init(String authToken) {
        return null;
    }
    webService static String invokeMethod(String authToken, String methodName, String inputs) {
        return null;
    }
    @HttpPost
    global static geopointe.m_API.mAPIResponse invokeMethodREST(String authToken, String methodName, String inputs) {
        return null;
    }
    webService static Boolean isChatterEnabled() {
        return null;
    }
    webService static String radialSearch(String authToken, String ds, Decimal centerLatDec, Decimal centerLngDec, Decimal rangeDec, String units) {
        return null;
    }
    webService static String routeDetail(String authToken, String routeId) {
        return null;
    }
    webService static String routeList(String authToken) {
        return null;
    }
    webService static String saveRoute(String authToken, String routeXML, String routeId, String routeName) {
        return null;
    }
global class mAPIResponse {
    global String json {
        get;
        set;
    }
    global mAPIResponse() {

    }
}
}

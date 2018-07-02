/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class EnosixFramework {
    global static String version;
    global EnosixFramework() {

    }
    global static void displayResultMessages(ensx.EnosixFramework.Result result) {

    }
    @TestVisible
    global static void displayResultMessages(ensx.EnosixFramework.Result result, ensx.EnosixFramework.MessageType level) {

    }
    global static ensx.EnosixFramework.ConnectOptions getConnectionOptions() {
        return null;
    }
    global static ensx.EnosixFramework.LoginResult login() {
        return null;
    }
    global static void setMock(System.Type t, Object inst) {

    }
global class ConnectOptions {
}
global abstract class DetailObject extends ensx.EnosixFramework.ValueObject implements ensx.EnosixFramework.Result {
    global DetailObject(String headerElement, Map<String,System.Type> typeMap) {

    }
    global List<ensx.EnosixFramework.Message> getMessages() {
        return null;
    }
    @TestVisible
    global override virtual System.Type getType() {
        return null;
    }
    global Boolean isSuccess() {
        return null;
    }
    global void setSuccess(Boolean success) {

    }
}
global abstract class DetailSBO implements ensx.EnosixFramework.TypeInfo {
    global DetailSBO(String businessObjectName, System.Type businessObjectType) {

    }
    global DetailSBO(String businessObjectName, System.Type businessObjectType, ensx.EnosixFramework.ConnectOptions options) {

    }
    @TestVisible
    global ensx.EnosixFramework.DetailObject executeCommand(String command, ensx.EnosixFramework.DetailObject obj) {
        return null;
    }
    @TestVisible
    global ensx.EnosixFramework.DetailObject executeGetDetail(Object key) {
        return null;
    }
    @TestVisible
    global ensx.EnosixFramework.DetailObject executeInitialize(ensx.EnosixFramework.DetailObject initialState) {
        return null;
    }
    @TestVisible
    global ensx.EnosixFramework.DetailObject executeSave(ensx.EnosixFramework.DetailObject obj) {
        return null;
    }
    @TestVisible
    global virtual System.Type getType() {
        return null;
    }
    @TestVisible
    global ensx.EnosixFramework.DetailObject processExecuteCommand(System.HttpResponse response) {
        return null;
    }
    @TestVisible
    global ensx.EnosixFramework.DetailObject processExecuteGetDetail(System.HttpResponse response) {
        return null;
    }
    @TestVisible
    global ensx.EnosixFramework.DetailObject processExecuteInitialize(System.HttpResponse response) {
        return null;
    }
    @TestVisible
    global ensx.EnosixFramework.DetailObject processExecuteSave(System.HttpResponse response) {
        return null;
    }
    @TestVisible
    global System.HttpRequest startExecuteCommand(String command, ensx.EnosixFramework.DetailObject obj) {
        return null;
    }
    @TestVisible
    global System.HttpRequest startExecuteGetDetail(Object key) {
        return null;
    }
    @TestVisible
    global System.HttpRequest startExecuteInitialize(ensx.EnosixFramework.DetailObject initialState) {
        return null;
    }
    @TestVisible
    global System.HttpRequest startExecuteSave(ensx.EnosixFramework.DetailObject obj) {
        return null;
    }
}
global interface DetailSBOCommandMock {
    ensx.EnosixFramework.DetailObject executeCommand(String param0, ensx.EnosixFramework.DetailObject param1);
}
global interface DetailSBOGetMock {
    ensx.EnosixFramework.DetailObject executeGetDetail(Object param0);
}
global interface DetailSBOInitMock {
    ensx.EnosixFramework.DetailObject executeInitialize(ensx.EnosixFramework.DetailObject param0);
}
global interface DetailSBOSaveMock {
    ensx.EnosixFramework.DetailObject executeSave(ensx.EnosixFramework.DetailObject param0);
}
global class FrameworkCollection implements ensx.EnosixFramework.TypeInfo {
    global FrameworkCollection(String elementName, System.Type elementType, ensx.EnosixFramework.FrameworkCollectionDelegate delegate) {

    }
    global void add(ensx.EnosixFramework.ValueObject obj) {

    }
    global void addAll(List<ensx.EnosixFramework.ValueObject> items) {

    }
    global void clear() {

    }
    global void copyTo(List<ensx.EnosixFramework.ValueObject> dest) {

    }
    global ensx.EnosixFramework.ValueObject createItem() {
        return null;
    }
    global ensx.EnosixFramework.ValueObject get(Integer index) {
        return null;
    }
    @TestVisible
    global virtual System.Type getType() {
        return null;
    }
    global Boolean isEmpty() {
        return null;
    }
    global ensx.EnosixFramework.ValueObject remove(Integer index) {
        return null;
    }
    @TestVisible
    global Boolean remove(ensx.EnosixFramework.ValueObject obj) {
        return null;
    }
    global void set(Integer index, ensx.EnosixFramework.ValueObject listElement) {

    }
    global Integer size() {
        return null;
    }
}
global interface FrameworkCollectionDelegate {
}
global abstract class FunctionObject extends ensx.EnosixFramework.ValueObject implements ensx.EnosixFramework.Result {
    global FunctionObject(Map<String,System.Type> typeMap) {

    }
    global List<ensx.EnosixFramework.Message> getMessages() {
        return null;
    }
    @TestVisible
    global override virtual System.Type getType() {
        return null;
    }
    global Boolean isSuccess() {
        return null;
    }
    global void setSuccess(Boolean success) {

    }
}
global interface HttpTrace {
    void onRequest(Map<String,String> param0);
    void onResponse(Map<String,String> param0);
}
global class LoginResult extends ensx.EnosixFramework.ValueObject implements ensx.EnosixFramework.Result {
    global LoginResult() {

    }
    global List<ensx.EnosixFramework.Message> getMessages() {
        return null;
    }
    @TestVisible
    global override System.Type getType() {
        return null;
    }
    global Boolean isSuccess() {
        return null;
    }
    global void setSuccess(Boolean success) {

    }
}
global class Message {
    global String Text {
        get;
    }
    global ensx.EnosixFramework.MessageType Type {
        get;
    }
    global Message(ensx.EnosixFramework.MessageType messageType, String message) {

    }
}
global enum MessageType {ERROR, INFO, SUCCESS, WARNING}
global class OperationException extends Exception {
}
global abstract class RFC implements ensx.EnosixFramework.TypeInfo {
    global RFC(String functionName, System.Type functionResultType) {

    }
    global RFC(String functionName, System.Type functionResultType, ensx.EnosixFramework.ConnectOptions options) {

    }
    @TestVisible
    global ensx.EnosixFramework.FunctionObject executeFunction() {
        return null;
    }
    global ensx.EnosixFramework.FunctionObject getParameterContext() {
        return null;
    }
    @TestVisible
    global virtual System.Type getType() {
        return null;
    }
    global ensx.EnosixFramework.FunctionObject processExecuteFunction(System.HttpResponse response) {
        return null;
    }
    global System.HttpRequest startExecuteFunction() {
        return null;
    }
}
global interface RFCMock {
    ensx.EnosixFramework.FunctionObject executeFunction();
}
global interface Result {
    List<ensx.EnosixFramework.Message> getMessages();
    Boolean isSuccess();
}
global abstract class SearchContext extends ensx.EnosixFramework.ValueObject {
    global SearchContext(Map<String,System.Type> elementMap) {

    }
    @TestVisible
    global override virtual System.Type getType() {
        return null;
    }
}
global abstract class SearchResult extends ensx.EnosixFramework.ValueObject implements ensx.EnosixFramework.Result {
    global SearchResult(Map<String,System.Type> typeMap) {

    }
    global List<ensx.EnosixFramework.Message> getMessages() {
        return null;
    }
    @TestVisible
    global override virtual System.Type getType() {
        return null;
    }
    global Boolean isSuccess() {
        return null;
    }
    global void setSuccess(Boolean success) {

    }
}
global abstract class SearchSBO implements ensx.EnosixFramework.TypeInfo {
    global SearchSBO(String businessObjectName, System.Type searchContextType, System.Type searchResultType) {

    }
    global SearchSBO(String businessObjectName, System.Type searchContextType, System.Type searchResultType, ensx.EnosixFramework.ConnectOptions options) {

    }
    global ensx.EnosixFramework.SearchResult executeSearch() {
        return null;
    }
    global ensx.EnosixFramework.SearchContext getSearchContext() {
        return null;
    }
    @TestVisible
    global virtual System.Type getType() {
        return null;
    }
    global ensx.EnosixFramework.SearchResult processExecuteSearch(System.HttpResponse response) {
        return null;
    }
    global System.HttpRequest startExecuteSearch() {
        return null;
    }
}
global interface SearchSBOMock {
    ensx.EnosixFramework.SearchResult executeSearch();
}
global abstract class ValueObject implements ensx.EnosixFramework.FrameworkCollectionDelegate, ensx.EnosixFramework.Serialization, ensx.EnosixFramework.TypeInfo {
    global ValueObject() {

    }
    global ValueObject(Map<String,System.Type> elementMap) {

    }
    global ValueObject(String elementName, Map<String,System.Type> elementMap) {

    }
    global virtual Object Get(String name) {
        return null;
    }
    global virtual void Set(Object value, String name) {

    }
    global virtual Boolean getBoolean(String name) {
        return null;
    }
    global ensx.EnosixFramework.FrameworkCollection getCollection(System.Type collectionItemType) {
        return null;
    }
    global Date getDate(String name) {
        return null;
    }
    global Datetime getDateTime(String name) {
        return null;
    }
    global Decimal getDecimal(String name) {
        return null;
    }
    @Deprecated
    global Boolean getFlag(String name) {
        return null;
    }
    global Integer getInteger(String name) {
        return null;
    }
    global virtual List<String> getKeyFields() {
        return null;
    }
    global String getNumC(String name) {
        return null;
    }
    global String getString(String name) {
        return null;
    }
    global ensx.EnosixFramework.ValueObject getStruct(System.Type collectionItemType) {
        return null;
    }
    global Time getTime(String name) {
        return null;
    }
    @TestVisible
    global virtual System.Type getType() {
        return null;
    }
    global Boolean isModified() {
        return null;
    }
    global virtual void setBoolean(Boolean value, String name) {

    }
    @Deprecated
    global void setFlag(Boolean value, String name) {

    }
}
}

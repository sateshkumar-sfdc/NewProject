/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class UniqueConfigureFieldTable {
    global List<System.SelectOption> availableConfigurations {
        get;
        set;
    }
    global List<System.SelectOption> availableFields {
        get;
        set;
    }
    global UniqueEntry__Scanned_Field_Config__c configuration {
        get;
        set;
    }
    global UniqueEntry.UniqueConfigureFieldTable fieldTable {
        get;
    }
    global String objectName {
        get;
        set;
    }
    global String rowId {
        get;
        set;
    }
    global List<UniqueEntry.UniqueConfigureFieldTable.ScannedFieldObject> table {
        get;
        set;
    }
    global String tempName {
        get;
        set;
    }
    global UniqueConfigureFieldTable(String objectNameVal, String settingNameVal, UniqueEntry__Scanned_Field_Config__c configurationVal, List<System.SelectOption> availableFieldsVal, Map<String,Schema.SObjectField> fieldMapVal, Boolean isRelated) {

    }
    global void SaveConfigurationAs() {

    }
    global void addRow() {

    }
    global void changeConfiguration() {

    }
    global void deleteConfiguration() {

    }
    global List<System.SelectOption> getMatchTypes(String obj, String fieldName) {
        return null;
    }
    global void refreshConfiguration() {

    }
    global void refreshTable() {

    }
    global void removeRow() {

    }
    global List<UniqueEntry.UniqueConfigureFieldTable.ScannedFieldObject> sortTableByScore(List<UniqueEntry.UniqueConfigureFieldTable.ScannedFieldObject> fList) {
        return null;
    }
global class ScannedFieldObject {
    global List<System.SelectOption> allFields {
        get;
        set;
    }
    global String id {
        get;
        set;
    }
    global String importance {
        get;
        set;
    }
    global List<System.SelectOption> matchTypes {
        get;
        set;
    }
    global String selectedField {
        get;
        set;
    }
    global String selectedMatchType {
        get;
        set;
    }
    global ScannedFieldObject(UniqueEntry__Scanned_Field__c sfVal) {

    }
    global ScannedFieldObject(String idVal, String objVal, List<System.SelectOption> allFieldsVal, List<System.SelectOption> matchTypesVal, String importanceVal) {

    }
    global ScannedFieldObject(String idVal, String objVal, List<System.SelectOption> allFieldsVal, String selectedFieldVal, List<System.SelectOption> matchTypesVal, String selectedMatchTypeVal, String importanceVal, String configurationVal) {

    }
}
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ExternalData {
    global ExternalData() {

    }
global class DataObject {
    global DataObject(String objectName, List<Loop.ExternalData.FieldInfo> fields) {

    }
}
global class FieldInfo {
    global Boolean isHtmlFormatted {
        get;
        set;
    }
    global String label {
        get;
        set;
    }
    global String referenceTo {
        get;
        set;
    }
    global Integer scale {
        get;
        set;
    }
    global FieldInfo(String name, Schema.DisplayType type) {

    }
}
global class QueryRequestInfo {
    global Id DDPId {
        get;
        set;
    }
    global Id DeliveryOptionId {
        get;
        set;
    }
    global Map<String,String> FormData {
        get;
        set;
    }
    global Id RecordId {
        get;
        set;
    }
    global List<Loop.ExternalData.Relationship> Relationships {
        get;
        set;
    }
    global Set<Id> TopLevelIds {
        get;
        set;
    }
    global QueryRequestInfo() {

    }
    global List<String> GetObjectNames() {
        return null;
    }
}
global class QueryResult {
    global List<List<String>> rows {
        get;
        set;
    }
    global QueryResult(String objectName, List<String> columnNames) {

    }
}
global class QueryResultSet {
    global QueryResultSet() {

    }
    global void add(Loop.ExternalData.QueryResult result) {

    }
}
global class Relationship {
    global List<Loop.ExternalData.Relationship> Children {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global Loop.ExternalData.Relationship Parent {
        get;
        set;
    }
    global String RelatedByField {
        get;
        set;
    }
    global Relationship() {

    }
}
}

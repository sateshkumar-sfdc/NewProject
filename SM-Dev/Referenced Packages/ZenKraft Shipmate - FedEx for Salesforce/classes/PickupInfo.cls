/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PickupInfo {
    global PickupInfo() {

    }
global class CreatePickupReply {
    global String location {
        get;
        set;
    }
    global String message {
        get;
        set;
    }
    global String pickupConfirmationNumber {
        get;
        set;
    }
    global String status {
        get;
        set;
    }
    global CreatePickupReply() {

    }
}
global class PickupAvailabilityReply {
    global String message {
        get;
        set;
    }
    global List<zkfedex.PickupInfo.PickupScheduleOption> options {
        get;
        set;
    }
    global Datetime requestTimestamp {
        get;
        set;
    }
    global String status {
        get;
        set;
    }
    global PickupAvailabilityReply() {

    }
}
global class PickupScheduleOption {
    global String accessTime {
        get;
        set;
    }
    global Boolean available {
        get;
        set;
    }
    global String carrier {
        get;
        set;
    }
    global String countryRelationship {
        get;
        set;
    }
    global String cutOffTime {
        get;
        set;
    }
    global String description {
        get;
        set;
    }
    global Date pickupDate {
        get;
        set;
    }
    global Boolean residentialAvailable {
        get;
        set;
    }
    global String scheduleDay {
        get;
        set;
    }
    global PickupScheduleOption() {

    }
}
}

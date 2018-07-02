/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PrinterServiceDTOs {
    global PrinterServiceDTOs() {

    }
global class ComputerInfo {
    global String id {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String state {
        get;
        set;
    }
    global ComputerInfo() {

    }
}
global virtual class PrintJob {
    global String content {
        get;
        set;
    }
    global String contentType {
        get;
        set;
    }
    global String id {
        get;
        set;
    }
    global String printerId {
        get;
        set;
    }
    global String source {
        get;
        set;
    }
    global String state {
        get;
        set;
    }
    global String title {
        get;
        set;
    }
    global PrintJob() {

    }
}
global virtual class PrintNodeAccount {
    global String email {
        get;
        set;
    }
    global String firstname {
        get;
        set;
    }
    global String id {
        get;
        set;
    }
    global String lastname {
        get;
        set;
    }
    global String password {
        get;
        set;
    }
    global PrintNodeAccount() {

    }
}
global class PrintNodeAccountStatus extends zkfedex.PrinterServiceDTOs.PrintNodeAccount {
    global String state {
        get;
        set;
    }
    global PrintNodeAccountStatus() {

    }
}
global class Printer {
    global zkfedex.PrinterServiceDTOs.ComputerInfo computer {
        get;
        set;
    }
    global String id {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String state {
        get;
        set;
    }
    global Printer() {

    }
}
}

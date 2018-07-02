/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PrintService {
    global Boolean isServiceAvailable;
    global static String PRINT_NODE_PROVIDER;
    global void changeAccountInfo(String firstName, String lastName, String username, String password) {

    }
    global zkfedex.PrinterServiceDTOs.PrintNodeAccountStatus getAccountStatus() {
        return null;
    }
    global List<System.SelectOption> getAvailablePrintersOptions() {
        return null;
    }
    global List<zkfedex.PrinterServiceDTOs.Printer> getAvailablePrinters() {
        return null;
    }
    global static zkfedex.PrintService getInstance(String printServiceProvider) {
        return null;
    }
    global String getPrintJobStatus(String printJobId) {
        return null;
    }
    global void init() {

    }
    global void init(String apiKey) {

    }
    global String printLabel(String printLabelId, String selectedPrinterId) {
        return null;
    }
    global List<String> printLabels(List<String> printLabelIds, List<String> selectedPrinterIds) {
        return null;
    }
    global List<String> printLabels(List<String> printLabelIds, String selectedPrinterId) {
        return null;
    }
    global void register(String firstName, String lastName, String username, String password) {

    }
    global String registerWithoutSaving(String firstName, String lastName, String username, String password) {
        return null;
    }
    global Boolean verifyRegistration() {
        return null;
    }
global class PrintServiceException extends Exception {
}
}

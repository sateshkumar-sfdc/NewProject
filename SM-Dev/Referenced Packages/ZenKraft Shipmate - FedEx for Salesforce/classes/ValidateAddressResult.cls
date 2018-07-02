/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ValidateAddressResult {
    global List<zkfedex.ValidateAddressResult.AddressValidationDetail> addressValidationDetails;
    global String message {
        get;
        set;
    }
    global Boolean success {
        get;
        set;
    }
    global ValidateAddressResult() {

    }
global class AddressValidationChangeEntry {
    global String change {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String value {
        get;
        set;
    }
    global AddressValidationChangeEntry() {

    }
}
global class AddressValidationDetail {
    global List<zkfedex.ValidateAddressResult.AddressValidationChangeEntry> changeEntries {
        get;
        set;
    }
    global List<String> changes {
        get;
        set;
    }
    global Boolean isDeliveryPointValid {
        get;
        set;
    }
    global Boolean isDeliveryPointValidationKnown {
        get;
        set;
    }
    global Boolean isResidential {
        get;
        set;
    }
    global Boolean isResidentialStatusKnown {
        get;
        set;
    }
    global Integer score {
        get;
        set;
    }
    global AddressValidationDetail() {

    }
}
}

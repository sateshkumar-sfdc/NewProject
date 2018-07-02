/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ShipmentInterface {
    global ShipmentInterface() {

    }
    global static List<zkfedex.ShipmentRate> calculateRates(zkfedex__ShipmatePreference__c shipmatePreference, zkfedex__Shipment__c shipment, zkfedex__ShipmentSpecialServices__c specialServices, zkfedex__SmartPostDetails__c smartPostDetails, List<zkfedex__Package__c> packages) {
        return null;
    }
    global static Boolean fillPickupOnShipment(zkfedex__Shipment__c shipment, zkfedex__Pickup__c pickup) {
        return null;
    }
    global static zkfedex.PickupInfo.PickupAvailabilityReply getPickupAvailability(zkfedex__ShipmatePreference__c shipmatePreference, zkfedex__Pickup__c pickupObject) {
        return null;
    }
    global static zkfedex.PickupInfo.CreatePickupReply pickupCreate(zkfedex__ShipmatePreference__c shipmatePreference, zkfedex__Pickup__c pickupObject) {
        return null;
    }
    global static zkfedex.TrackingInfo trackShipment(String trackingNumber, zkfedex__ShipmatePreference__c preference, Boolean checkShipmentInOrg) {
        return null;
    }
    global static zkfedex.TrackingInfo trackShipment(String trackingNumber, Date shipDate, zkfedex__ShipmatePreference__c preference, Boolean checkShipmentInOrg) {
        return null;
    }
    global static zkfedex.ValidateAddressResult validateAddress(zkfedex__Shipment__c shipment, zkfedex__ShipmatePreference__c shipmatePreference, User user) {
        return null;
    }
    global static zkfedex.GlobalWebServiceResponse webServiceRequest(String requestName, User user, zkfedex__ShipmatePreference__c shipmatePreference) {
        return null;
    }
    global static zkfedex.GlobalWebServiceResponse webServiceRequest(String requestName, Map<String,Object> requestMap, User user, zkfedex__ShipmatePreference__c shipmatePreference) {
        return null;
    }
}

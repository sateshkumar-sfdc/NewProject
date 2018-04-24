public with sharing class CTRL_CreditCardEntry_Test implements CB_CardDetailsReceiver {
    public SBO_EnosixXiIntercept_Detail.RESPONSE cardDetails { get; private set; }
    public CB_CardDetailsReceiver receiver { get; private set; }
    public boolean displayCaptureButton { get; set; }

    public CTRL_CreditCardEntry_Test() {
        receiver = this;
        displayCaptureButton = false;
    }

    public void onReceiveCardDetails(SBO_EnosixXiIntercept_Detail.EnosixXiIntercept details) {
        // Do something with the captured card data here - we'll just save to a property for display
        this.cardDetails = details.RESPONSE;
        displayCaptureButton = false;
    }

    public void onInitCardDetails(SBO_EnosixXiIntercept_Detail.EnosixXiIntercept details) {
        // Do something here when the form inits, for example hide or show buttons
        displayCaptureButton = true;
    }
}
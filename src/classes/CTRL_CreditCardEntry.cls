public with sharing class CTRL_CreditCardEntry {

    public CTRL_CreditCardEntry() {
        this.isFrameDisplayed = false;
        this.intercept = new SBO_EnosixXiIntercept_Detail.EnosixXiIntercept();

        if (!Test.isRunningTest()) {
            init();
        }
    }

    public CB_CardDetailsReceiver cardDetailsReceiver { get; set; }
    public SBO_EnosixXiIntercept_Detail.EnosixXiIntercept intercept { get; private set; }
    public string parentRerender { get; set; }
    public string jsSubmitMethodName { get; set; }
    public string jsInitMethodName { get; set; }

    public boolean isFrameDisplayed { get; private set; }

    public string targetUrl {
        get {
            return UTIL_PaymentCards.getPaymetricTargetUrl(this.intercept);
        }
    }

    public void init() {

    }

    public void actionInitAccessToken() {
      this.intercept = UTIL_PaymentCards.initEnosixXiIntercept();

      this.intercept.HostUri =  getHostUrl();
      this.intercept.CSSUri = URL.getSalesforceBaseUrl().toExternalForm() + UTIL_StaticResource.getResourceUrl('enosix') + 'css/cc-iframe.css';

      if (null != this.cardDetailsReceiver) {
        this.cardDetailsReceiver.onInitCardDetails(this.intercept);
      }

      this.intercept = UTIL_PaymentCards.getAccessToken(this.intercept);
      this.isFrameDisplayed = true;
    }

    @testVisible
    static string getHostUrl() {

      PageReference pageRef = ApexPages.currentPage();

      pageref.getParameters().clear();

      string result = URL.getSalesforceBaseUrl().toExternalForm() + pageRef.getUrl();

      return result;
    }

    public void actionGetCardDetails() {
        // pass result to callback
        SBO_EnosixXiIntercept_Detail.EnosixXiIntercept result = UTIL_PaymentCards.getCardInfo(this.intercept);

        if (null != result.RESPONSE) {
            cardDetailsReceiver.onReceiveCardDetails(result);

            this.isFrameDisplayed = false;
        }
    }

}
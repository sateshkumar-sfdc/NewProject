@isTest
public class TSTC_Account_PartnerPreview {
    @isTest static void testAccountPartnerPreview ()
    {
        Test.startTest();
        // TODO: To increase code coverage, insert an Account with a SAP Customer Number set,
        // mock a StandardController with the account ID so that the a SAP Customer Number is
        // found, and mock the results for FetchCustomer so that Partner's are returned.
        // Also mock out the AppSettings with various filter settings to ensure filtering and
        // changing the Title works.
        CTRL_Account_PartnerPreview capp = new CTRL_Account_PartnerPreview(null);
        String partnerPreviewTitle = capp.PartnerPreviewTitle;
        List<SBO_EnosixCustomer_Detail.PARTNERS> partnerPreviewList = capp.PartnerPreviewList;
        Test.stopTest();
    }
}
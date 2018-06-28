@isTest
public with sharing class TSTC_CompanyCode {
    @isTest
    static void test_createControllerAndTouchProps() {
        Test.startTest();
        CTRL_CompanyCode constructor = new CTRL_CompanyCode();
        TSTCompanyCode val = new TSTCompanyCode();
        constructor.setMyDataSource(val);
        System.assert(constructor.getMyDataSource() != null);
        Test.stopTest();
    }
    @isTest
    static void test_shippingMaster() {
        Test.startTest();
        CTRL_CompanyCode constructor = new CTRL_CompanyCode();
        TSTCompanyCode val = new TSTCompanyCode();
        constructor.setMyDataSource(val);
        RFC_SD_GET_SHIP_INFO.RESULT shipInfo = constructor.ShippingMaster;
        System.assert(shipInfo != null);
        Test.stopTest();
    }
    @isTest
    static void test_companyData() {
        Test.startTest();
        CTRL_CompanyCode constructor = new CTRL_CompanyCode();
        TSTCompanyCode val = new TSTCompanyCode();
        constructor.setMyDataSource(val);
        SBO_EnosixCustomer_Detail.COMPANY_DATA coData = constructor.CompanyData;
        System.assert(coData != null);
        Test.stopTest();
    }
    @isTest
    static void test_paymentTerms() {
        Test.startTest();
        CTRL_CompanyCode constructor = new CTRL_CompanyCode();
        TSTCompanyCode val = new TSTCompanyCode();
        constructor.setMyDataSource(val);
        RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS term = new RFC_SD_GET_SHIP_INFO.ET_PAY_TERMS();
        term.ZTERM = 'TST ZTERM';
        term.VTEXT = 'TSTVTEXT';
        val.getShipInfo().ET_PAY_TERMS_List.add(term);
        List<SelectOption> selectOptions = constructor.PaymentTerms;
        Test.stopTest();
    }



    class TSTCompanyCode implements DS_CompanyCode {

        public SBO_EnosixCustomer_Detail.COMPANY_DATA companyData { get; set; }
        public RFC_SD_GET_SHIP_INFO.RESULT shipInfo { get; set; }
        public TSTC_CompanyCode.TSTCompanyCode() {
            companyData = new SBO_EnosixCustomer_Detail.COMPANY_DATA();
            shipInfo = new RFC_SD_GET_SHIP_INFO.RESULT();
        }
        public SBO_EnosixCustomer_Detail.COMPANY_DATA getCOMPANY_DATA() {
            return companyData;
        }

        public RFC_SD_GET_SHIP_INFO.RESULT getShipInfo() {
            return shipInfo;
        }
    }
}
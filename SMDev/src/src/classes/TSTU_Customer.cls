@isTest
public class TSTU_Customer
{
    public class MOC_Customer implements ENSX.EnosixFramework.DetailSBOGetMock, ENSX.EnosixFramework.DetailSBOSaveMock
    {
        private boolean throwException = false;
    	public Boolean success = false;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ENSX.EnosixFramework.DetailObject executeGetDetail(object key)
        {
            SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();
            result.setSuccess(success);
            return result;
        }

        public ENSX.EnosixFramework.DetailObject executeSave(ENSX.EnosixFramework.DetailObject obj)
        {
            SBO_EnosixCustomer_Detail.EnosixCustomer result = (SBO_EnosixCustomer_Detail.EnosixCustomer) obj;
            result.setSuccess(success);
            return result;
        }
    }

    @isTest
    static void test_FetchEnosixCustomer()
    {
        MOC_Customer mockCustomer = new MOC_Customer();
        ENSX.EnosixFramework.setMock(SBO_EnosixCustomer_Detail.class, mockCustomer);

        Test.startTest();
        mockCustomer.setSuccess(false);
        Set<String> clientTypes = UTIL_Customer.allowedClientTypes;
        SBO_EnosixCustomer_Detail.EnosixCustomer result = UTIL_Customer.fetchEnosixCustomer(null);
        SBO_EnosixCustomer_Detail.EnosixCustomer result2 = UTIL_Customer.saveCustomer(null);
        UTIL_Customer.redirectToEditCustomer();
        UTIL_Customer.redirectToDisplayCustomer();
        UTIL_Customer.redirectToCreateCustomer();
        Test.stopTest();

        System.assert(null != result);
    }
}
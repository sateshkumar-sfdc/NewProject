// TODO: We should move a lot of this into a UTIL class (maybe all of it)
public abstract with sharing class CTRL_Customer_Base {

    public static string sapAccountField {
    	get {
    		return 'ENSX_EDM__SAP_Customer_Number__c';
    	}
    }

    @TestVisible
    public static string getSapCustomerNumberFromAccount(Account account) {
        string result = null;

        if (null != account) {

            ID id = account.Id;

            sObject s = Database.query('SELECT ' + sapAccountField + ' FROM Account WHERE Id = :Id');

            result = string.valueOf(s.get(sapAccountField));

        }

        return result;
    }

    @TestVisible
    public static void setSapCustomerNumberForAccount(Account account, string customerNumber) {
        string result = null;

        if (null != account) {

            account.put(sapAccountField, customerNumber);

            Id id = account.Id;

            if (null != id) {
                sObject s = Database.query('SELECT ' + sapAccountField + ' FROM Account WHERE Id = :Id');
                s.put(sapAccountField, customerNumber);
                upsert s;
            }
        }
    }

    public static SBO_EnosixCustomer_Detail.EnosixCustomer FetchEnosixCustomer(string id){
        SBO_EnosixCustomer_Detail sbo = new SBO_EnosixCustomer_Detail();

        SBO_EnosixCustomer_Detail.EnosixCustomer result = sbo.getDetail(id);

        if (!result.isSuccess()) {
        	ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }

        return result;
    }

    // Helper method to save customer record. Returns updated customer if successful,
    // otherwise displays errors and returns null
    public static SBO_EnosixCustomer_Detail.EnosixCustomer saveCustomer(
        SBO_EnosixCustomer_Detail.EnosixCustomer customer)
    {
        SBO_EnosixCustomer_Detail sbo = new SBO_EnosixCustomer_Detail();
        SBO_EnosixCustomer_Detail.EnosixCustomer result = null;
        try {
            result = sbo.save(customer);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
            return null;
        }

        return result;
    }

    public static PageReference RedirectToEditCustomer() {
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_Customer_Edit, UTIL_PageState.current);
    }

    public static PageReference RedirectToDisplayCustomer() {
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_CustomerDetail, UTIL_PageState.current);
    }

    public static PageReference RedirectToCreateCustomer() {
        return UTIL_PageFlow.redirectTo(
            UTIL_PageFlow.VFP_CustomerCreate, UTIL_PageState.current);
    }
}
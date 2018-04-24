public with sharing class CTRL_Invoice_Detail {

	public SBO_EnosixInvoice_Detail.EnosixInvoice invoiceDetail { get; private set;}
  	public SBO_EnosixInvoice_Detail.ITEMS priceInfoDetail	{get; private set;}
  	public List<SBO_EnosixInvoice_Detail.CONDITIONS> priceInfoItems { get; private set;}
  	public String invNum {get; private set;}

  	public CTRL_Invoice_Detail() {

    	// First check InvoiceNumber and based on invoice number showing the deatil of invoice
    	invNum = UTIL_PageState.current.invoiceNum;

    	//Check null value in Invoice number
    	if (invNum == null) {
      		ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error , 'Invalid Invoice');
      		ApexPages.addMessage(msg);
      		return;
    	}

    	if (!Test.isRunningTest()) {
        	init();
        }
	}

	public List<SBO_EnosixInvoice_Detail.ITEMS> InvoiceItems {
		get {
			List<SBO_EnosixInvoice_Detail.ITEMS> result = new List<SBO_EnosixInvoice_Detail.ITEMS>();

			if (null != this.invoiceDetail) {
				this.invoiceDetail.Items.copyTo(result);
			}

			return result;
		}
	}

	void init() {
		invoiceDetail = getInvoiceById(this.invNum);
	}


	@TestVisible
	static SBO_EnosixInvoice_Detail.EnosixInvoice GetInvoiceById(string invoiceNumber) {
		SBO_EnosixInvoice_Detail sbo = new SBO_EnosixInvoice_Detail();
		SBO_EnosixInvoice_Detail.EnosixInvoice result = sbo.getDetail(invoiceNumber);

		if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }

		return result;
	}

	@TestVisible
	static SBO_EnosixInvoice_Detail.ITEMS getItemByItemNumber(List<SBO_EnosixInvoice_Detail.ITEMS> items, string itemNumber){
		for (SBO_EnosixInvoice_Detail.ITEMS item : items) {
			if (itemNumber == item.ItemNumber) {
				return item;
			}
		}
		System.Debug('Item ' + itemNumber +' not found');
		return null;
	}

  	@TestVisible
  	static List<SBO_EnosixInvoice_Detail.CONDITIONS> getConditionsForItem(SBO_EnosixInvoice_Detail.EnosixInvoice invoice, string itemNumber){
  		List<SBO_EnosixInvoice_Detail.CONDITIONS> result = new List<SBO_EnosixInvoice_Detail.CONDITIONS>();
  		List<SBO_EnosixInvoice_Detail.CONDITIONS> allConditions = new List<SBO_EnosixInvoice_Detail.CONDITIONS>();
  		invoice.CONDITIONS.copyTo(allConditions);

  		for(SBO_EnosixInvoice_Detail.CONDITIONS condition : allConditions) {
  			if(condition.ConditionItemNumber == itemNumber) {
      			result.add(condition);
      		}
  		}

  		return result;
  	}


  	//Reterive Pricing info and Pricing info items based on Billing item number of Invoice
	public void PricingInfo() {

  		String itemNumber = System.currentPageReference().getParameters().get('itemnumber');

  		this.priceInfoDetail = getItemByItemNumber(this.InvoiceItems, itemNumber);
  		//Initialize the list to display data on visualforce page
  		priceInfoItems = getConditionsForItem(invoiceDetail, itemNumber);


 	}
}
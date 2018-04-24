public with sharing class CTRL_DeliveryDetail {
	public SBO_EnosixDL_Detail.EnosixDL dlDetail { get; private set;}
	public List<SBO_EnosixDL_Detail.ITEMS> dlItems {get; private set;}
	public SBO_EnosixDL_Detail.ITEMS SelectedItem {get; private set;}
	public String fromaccount {get; private set;}   // if this is set, then show the Back to Account button

	public String dlnumber {get; private set;}

	public CTRL_DeliveryDetail() {
		dlnumber = UTIL_PageState.current.deliveryNum;
		fromaccount = UTIL_PageState.current.accountId;

		if (dlnumber == null) {
			ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error , 'Invalid Delivery Inquiry');
			ApexPages.addMessage(msg);
			return;
		}

		dlItems = new List<SBO_EnosixDL_Detail.ITEMS>();

		SBO_EnosixDL_Detail detail = new SBO_EnosixDL_Detail();

		if (Test.isRunningTest()) ensx.EnosixFramework.setMock(ensx.EnosixFramework.DetailSBO.class, new MOC_EnosixDL_Detail.MockEnosixDLSuccess());
		dlDetail = detail.getDetail(dlnumber);

		if (dlDetail.isSuccess()) {
			dlItems = new List<SBO_EnosixDL_Detail.ITEMS>();
			dlDetail.Items.copyTo(dlItems);
		} else {
			ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error , 'Unable to retrieve Delivery Inquiry SAP Webservice');
			ApexPages.addMessage(msg);
			return;
		}

		String itemNum = UTIL_PageState.current.deliveryItemNum;
		if (null != this.dlItems && null != itemNum)
			this.SelectedItem = getDeliveryItemByNumber(this.dlItems, itemNum);
	}

	// Item select action
	public void ItemDetailPage() {
		String itemNum = System.currentPageReference().getParameters().get('itemNum');
		this.SelectedItem = getDeliveryItemByNumber(this.dlItems, itemNum);
	}

	@testVisible
	private static SBO_EnosixDL_Detail.ITEMS getDeliveryItemByNumber(
		List<SBO_EnosixDL_Detail.ITEMS> items, string itemNum) {

		for (SBO_EnosixDL_Detail.ITEMS item : items) {
			if (itemNum == item.DeliveryItem) {
				return item;
			}
		}

		return null;
	}
}
({
	doInit : function(component, event, helper) {
		//Initialize anything here
		helper.getAcctId(component);
	},

	iframeOnLoad: function(cmp) {
		//Hide the spinner after the iframe has loaded
		var spinner = cmp.find('spinner');
		$A.util.addClass(spinner, 'slds-hide');
	}
})
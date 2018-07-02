({
	sendOrderRequest : function(component, event, helper) {  
        helper.getNewCase(component);
        helper.showPopupHelper(component, 'newmodaldialog', 'slds-fade-in-');
        helper.showPopupHelper(component,'backdrop','slds-backdrop--');
    },
    HidePopUp : function(component, event, helper) {        
        helper.hidePopupHelper(component, 'newmodaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');        
    },
    saveMCase : function(component, event, helper) {
        var caseobj = component.get("v.dval");
        var isError = false;    
        helper.saveNewCase(component);
        helper.hidePopupHelper(component, 'newmodaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
    }
})
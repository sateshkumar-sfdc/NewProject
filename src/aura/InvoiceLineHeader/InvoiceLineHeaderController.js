({
    doInit : function(component, event, helper) {
		var action = component.get("c.getInvoice");
        action.setParams({
            "lineid": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
				component.set("v.invoiceid", response.getReturnValue().Invoice__c);
				component.set("v.invoicenumber", response.getReturnValue().Invoice__r.Name);
            }
            else {
                alert("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
    
})
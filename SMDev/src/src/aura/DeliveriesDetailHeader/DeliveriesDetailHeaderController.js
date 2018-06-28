({
    doInit : function(component, event, helper) {
		var action = component.get("c.getDelivery");
        action.setParams({
            "lineid": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('ID:'+component.get("v.recordId"));
            if (state === "SUCCESS") {
				component.set("v.deliveriesid", response.getReturnValue().Deliveries__c);
				component.set("v.deliveriesnumber", response.getReturnValue().Deliveries__r.Name);
            }
            else {
                alert("Failed with state: " + state+'-'+response);
            }
        });
        $A.enqueueAction(action);
    }
    
})
({
    doInit : function(component, event, helper) {
		var action = component.get("c.getOrderDetail");
        action.setParams({
            "orderId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
				component.set("v.orderid", response.getReturnValue().Order_Details__c);
				component.set("v.ordernumber", response.getReturnValue().Order_Details__r.Name);
            }
            else {
                alert("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
    
})
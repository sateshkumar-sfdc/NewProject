({
	redirectToRecord : function(component, event, helper) {
		var action = component.get("c.getRecordIdToRedirect");
        action.setParams({
            theRecordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var theRecordId = response.getReturnValue();
                if(theRecordId) {
                    var urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({
                        "recordId" : theRecordId,
                        "slideDevName" : "related"
                    });
                    urlEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})
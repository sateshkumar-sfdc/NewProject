({
	redirectToAccount : function(component, event, helper) {
        var action = component.get("c.getAccountId");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var accountId = response.getReturnValue();
//                alert(accountId);
                if(accountId) {
                    var urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({
                        "recordId" : accountId
                    });
                    urlEvent.fire();
                }
                else {
                    // Show error message to user.
                    helper.showErrorMessage(
                        component,
                        [],
                        $A.get("$Label.c.YETI_DealerAccountDetails_NoAccountFound")
                    );
                }
            }
        });
        $A.enqueueAction(action);
    },

    // Show spinner when waiting for response.
    showSpinner : function(component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({
            isVisible : true
        });
        evt.fire();
    },

    // Hide spinner when response received.
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({
            isVisible : false
        });
        evt.fire();
    }
})
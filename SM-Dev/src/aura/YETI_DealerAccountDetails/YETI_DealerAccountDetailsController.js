({
    // Load account data from salesforce server.
    doInit : function(component, event, helper) {
        // Create the action.
        var action = component.get("c.getAccountDetails");

        // Add callback behaviour for when respose is received.
        action.setCallback(this, function(response) {
			// Show page header.
            var pageHeader = component.find('pageHeaderSection');
            $A.util.removeClass(pageHeader, 'hideSection');

            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var theAccountRecord = response.getReturnValue();
                if(theAccountRecord) {
                	component.set("v.dealerAccount", theAccountRecord);

                    // Show data sections.
                    var dataSections = component.find('theDataSections');
                    $A.util.removeClass(dataSections, 'hideSection');
                }
                else {
                    // Show error message to user.
                    helper.showErrorMessage(
                        component,
                        [],
                        $A.get("$Label.c.YETI_DealerAccountDetails_NoAccountFound")
                    );

					// hide data tabs.
                    var dataSections = component.find('theDataSections');
                    $A.util.addClass(dataSections, 'hideSection');
                }
            }
            else {
                helper.showErrorMessage(
                    component,
                    response.getError(),
                    $A.get("$Label.c.YETI_DealerAccountDetails_DefaultErrorMessageText")
                );
            }
        });

        // Send action off to be executed.
        $A.enqueueAction(action);
    }
})
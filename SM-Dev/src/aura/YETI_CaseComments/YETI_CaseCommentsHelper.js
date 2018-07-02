({
    // Show error messages.
    showErrorMessage : function(component, theErrors, theMessage) {
		// Log errors to browser console.
        for(var i = 0; i < theErrors.length; i++) {
			console.log('TRACE: YETI_CaseComments - YETI_CaseCommentsHelper.js - showErrorMessage - Error - ' + theErrors[i].message);
        }

        // Show error message to user.
        component.set("v.errorMessage", theMessage);
        var errorMessageSection = component.find("errorMessageDiv");
        $A.util.toggleClass(errorMessageSection, "error-message");
    },

    // Call apex controller method to fetch case comments.
    getCaseComments : function(component) {
        // Show page header.
        var pageHeader = component.find('pageHeaderSection');
        $A.util.removeClass(pageHeader, 'hideSection');

        var action = component.get("c.getAllCaseComments");
        action.setParams({
            theCaseId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
				component.set("v.caseComments", response.getReturnValue());
            }
            else {
                helper.showErrorMessage(
                    component,
                    response.getError(),
                    $A.get("$Label.c.YETI_DealerAccountDetails_DefaultErrorMessageText")
                );
            }
        });
        $A.enqueueAction(action);
    }
})
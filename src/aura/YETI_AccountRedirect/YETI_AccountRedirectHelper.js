({
    showErrorMessage : function(component, theErrors, theMessage) {
		// Log errors to browser console.
        for(var i = 0; i < theErrors.length; i++) {
			console.log('TRACE: YETI_AccountRedirect - YETI_AccountRedirectHelper.js - showErrorMessage - Error - ' + theErrors[i].message);
        }

        // Show error message to user.
        component.set("v.errorMessage", theMessage);
        var errorMessageSection = component.find("errorMessageDiv");
        $A.util.toggleClass(errorMessageSection, "error-message");
    }
})
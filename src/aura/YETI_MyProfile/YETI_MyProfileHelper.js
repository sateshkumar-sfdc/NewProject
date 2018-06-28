({
    // Show success/error messages to user.
    showUserMessages : function(component, theType, theMessageArray) {
		var theMessages = '';
        for(var i = 0; i < theMessageArray.length; i++) {
			theMessages += theMessageArray[i].message + '\n';
        }

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode" : 'sticky',
            "type" : theType,
            "title" : theType == 'success' ? 'Success!' : 'Error!',
            "message": theMessages
        });
        toastEvent.fire();
    },

	// Validate update password fields.
	validateUpdatePasswordFields : function(component) {
        var isValid = true;

        // Validate current password field.
        var currentPasswordField = component.find('currentPasswordField');
		var currentPasswordValue = currentPasswordField.get("v.value");
        if($A.util.isEmpty(currentPasswordValue)) {
            isValid = false;
            $A.util.addClass(currentPasswordField, 'requiredField');
        }
        else {
            $A.util.removeClass(currentPasswordField, 'requiredField');
        }

        // Validate new password field.
        var newPasswordField = component.find('newPasswordField');
        var newPasswordValue = newPasswordField.get("v.value");
        if($A.util.isEmpty(newPasswordValue)) {
            isValid = false;
            $A.util.addClass(newPasswordField, 'requiredField');
        }
        else {
            $A.util.removeClass(newPasswordField, 'requiredField');
        }

        // Validate verify new password field.
        var verifyNewPasswordField = component.find('verifyNewPasswordField');
        var verifyNewPasswordValue = verifyNewPasswordField.get("v.value");
        if($A.util.isEmpty(verifyNewPasswordValue)) {
            isValid = false;
            $A.util.addClass(verifyNewPasswordField, 'requiredField');
        }
        else {
            if(verifyNewPasswordValue != newPasswordValue) {
                isValid = false;
                verifyNewPasswordField.set("v.errors", [{ message : "Passwords do not match." }]);
            }
            else {
                verifyNewPasswordField.set("v.errors", null);
            	$A.util.removeClass(verifyNewPasswordField, 'requiredField');
            }
        }

        // Ensure that password has atleast 8 characters and contains only underscore, digits and alphabets.
        var regex = /^[0-9a-zA-Z\_]+$/
        var invalidPasswordMessage = component.find('invalidPasswordMessage');
        if(
            !regex.test(newPasswordValue) ||
            !regex.test(verifyNewPasswordValue) ||
            newPasswordValue.length < 8 ||
            verifyNewPasswordValue.length < 8
        ) {
            isValid = false;
            $A.util.addClass(invalidPasswordMessage, 'highlight');
        }
        else {
            $A.util.removeClass(invalidPasswordMessage, 'highlight');
        }

        return isValid;
    },

    // Communicate with apex controller.
	callApexControllerMethod : function(component, methodName, params, callback) {
		var action = component.get("c." + methodName);
        if(params) {
            action.setParams(params);
        }
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },

    // Show modal box.
    showPopup : function(component, componentId, className) {
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
        component.set("v.isModalBoxDisplayed", true);
    },

	// Reset modal box.
    resetModalBox : function(component) {
		var currentPasswordField = component.find('currentPasswordField');
		var newPasswordField = component.find('newPasswordField');
        var verifyNewPasswordField = component.find('verifyNewPasswordField');
        var invalidPasswordMessage = component.find('invalidPasswordMessage');

        currentPasswordField.set("v.value", '');
        newPasswordField.set("v.value", '');
        verifyNewPasswordField.set("v.value", '');
        verifyNewPasswordField.set("v.errors", null);

        $A.util.removeClass(currentPasswordField, 'requiredField');
        $A.util.removeClass(newPasswordField, 'requiredField');
        $A.util.removeClass(verifyNewPasswordField, 'requiredField');
        $A.util.removeClass(invalidPasswordMessage, 'highlight');
    },

    // Hide modal box.
    hidePopup : function(component, componentId, className) {
		this.resetModalBox(component);

        var modal = component.find(componentId);
        $A.util.addClass(modal, className + 'hide');
        $A.util.removeClass(modal, className + 'open');
        component.set("v.isModalBoxDisplayed", false);
    }
})
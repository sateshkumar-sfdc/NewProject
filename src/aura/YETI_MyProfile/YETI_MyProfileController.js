({
	// Load user information.
    getUserData : function(component, event, helper) {
		helper.callApexControllerMethod(component, "fetchUserData", null, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var theUserData = response.getReturnValue();
                component.set("v.userData", theUserData);
                component.find("userTimeZones").set("v.value", theUserData.userTimezoneValue);
            }
            else {
                helper.showUserMessages(component, 'error', response.getError());
            }
        });
	},

	// Update user timezone value.
	updateUserTimeZone : function(component, event, helper) {
        helper.callApexControllerMethod(
            component,
            "updateUserTimeZoneValue",
            {
				theTimezoneValue : component.find("userTimeZones").get("v.value")
        	},
			function(response) {
				var state = response.getState();
				if(component.isValid() && state === "SUCCESS") {
					helper.showUserMessages(component, 'success', [{ message : 'Timezone updated successfully.'} ]);
                }
                else {
					helper.showUserMessages(component, 'error', response.getError());
                }
            }
        );
    },

    // Update user password.
    updateUserPassword : function(component, event, helper) {
        if(helper.validateUpdatePasswordFields(component)) {
            helper.callApexControllerMethod(
                component,
                "changeUserPassword",
				{
                    currentPassword : component.find('currentPasswordField').get("v.value"),
                    newPassword : component.find('newPasswordField').get("v.value"),
                    verifyNewPassword : component.find('verifyNewPasswordField').get("v.value")
            	},
                function(response) {
                    var state = response.getState();
                    if(component.isValid() && state === "SUCCESS") {
                        helper.hidePopup(component, 'modaldialog', 'slds-fade-in-');
                        helper.hidePopup(component, 'backdrop', 'slds-backdrop--');
                        helper.showUserMessages(component, 'success', [{ message : 'Password updated successfully.'} ]);
                    }
                    else {
                        helper.showUserMessages(component, 'error', response.getError());
                    }
                }
            );
        }
    },

    // Show modal box.
	showModalBox : function(component, event, helper) {
        helper.showPopup(component, 'modaldialog', 'slds-fade-in-');
        helper.showPopup(component,'backdrop','slds-backdrop--');
    },

    // Close modal box.
    hideModalBox : function(component, event, helper) {
        helper.hidePopup(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopup(component, 'backdrop', 'slds-backdrop--');
    },

    // Show spinner when waiting for response.
    showSpinner : function(component, event, helper) {
        var updatePasswordButtons = component.find("updatePasswordButtons");
        $A.util.removeClass(updatePasswordButtons, 'updatePasswordButtons');

        var isModalBoxDisplayed = component.get("v.isModalBoxDisplayed");
        var spinner = isModalBoxDisplayed ? component.find('processing') : component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({
            isVisible : true
        });
        evt.fire();
    },

    // Hide spinner when response received.
    hideSpinner : function (component, event, helper) {
		var processing = component.find('processing');
        var evt = processing.get("e.toggle");
        evt.setParams({
            isVisible : false
        });
        evt.fire();

		var updatePasswordButtons = component.find("updatePasswordButtons");
        $A.util.addClass(updatePasswordButtons, 'updatePasswordButtons');

        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({
            isVisible : false
        });
        evt.fire();
    }
})
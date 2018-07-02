({
	runWizzard : function(component, event, helper) {
        helper.runWizzard(component);
	},
    skipWizzard : function(component, event, helper) {
		helper.skipWizzard(component);
	},
    doInit: function(component, event, helper) {
		var action = component.get("c.isWizardCompleted");
        action.setCallback(this, function(response) {
        	var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue()) {
                    helper.skipWizzard(component);
                }
                else {
                    helper.showSetup(component);
                }
        	}
        	else if (component.isValid() && state === "ERROR") {
                //TODO: Do Error Handling stuff
        	}
        		
        });
        $A.enqueueAction(action);
    },
    
    throwErrorMessage : function (component, event, helper) {
        $A.createComponents([
            ["ui:message",{
                "title" : event.getParam("title"),
                "severity" : "error",
                "closable" : true
            }],
            ["ui:outputText",{
                "value" : event.getParam("message")
            }]
        ],function(components, status){
            if (status === "SUCCESS") {
                var message = components[0];
                var outputText = components[1];
                // set the body of the ui:message to be the ui:outputText
                message.set("v.body", outputText);
                var div1 = component.find("errorMessage");
                // Replace div body with the dynamic component
                div1.set("v.body", message);
                //Scroll to top
                document.body.scrollTop = document.documentElement.scrollTop = 0;
            }
        });
    },
})
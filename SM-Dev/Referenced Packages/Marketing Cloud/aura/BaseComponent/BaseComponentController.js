({
    handleComponentEvent : function(component, event, helper) {
        var errorMessage = event.getParam("errorMessage");
        var successMessage = event.getParam("successMessage");
        var toastMessage = event.getParam("toastMessage");
        var title = event.getParam("messageTitle");
        var severity = "";
        var eventMessage = "";

        if(typeof errorMessage !== "undefined") {
            severity = "error";
            eventMessage = errorMessage;
        }   
        else if(typeof successMessage !== "undefined") {
            severity = "confirm";
            eventMessage = successMessage;
        }    
        else {
            severity = "info";
            eventMessage = toastMessage;
        }
        $A.createComponents([
            ["ui:message",{
                "title" : title,
                "severity" : severity,
                "closable" : true
            }],
            ["ui:outputText",{
                "value" : eventMessage
            }]
        ],function(components, status){
            if (status === "SUCCESS") {
                var message = components[0];
                var outputText = components[1];
                // set the body of the ui:message to be the ui:outputText
                message.set("v.body", outputText);
                var div1 = component.find("popupMessage");
                // Replace div body with the dynamic component
                div1.set("v.body", message);
                //Scroll to top
                document.body.scrollTop = document.documentElement.scrollTop = 0;
            }
        });    
    },

    showSpinner : function (component, event, helper) {
		document.getElementById("spinnerSpan").style.visibility = "visible";       
        var spinner = component.find('mainSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();
    },

    hideSpinner : function (component, event, helper) {
        document.getElementById("spinnerSpan").style.visibility = "hidden";       
        var spinner = component.find('mainSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();
    },    
})
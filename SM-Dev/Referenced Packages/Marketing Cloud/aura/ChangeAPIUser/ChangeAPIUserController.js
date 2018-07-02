({    
    onInit : function(component, event, helper) {
        //Call server and check for outstanding sends
        var action = component.get("c.initialize");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var initializeResponse = JSON.parse(response.getReturnValue());
                if(initializeResponse.errorCode === "UNAUTHORIZED"){
                    var urlprefix = "/apex/";
                    top.window.location.href = urlprefix.concat(initializeResponse.destination);
                }
                else {
                    //Set user credentials variables
                    component.find("userCredsJSON").set("v.json",helper.getUserCredsJSON(initializeResponse.destination));
                    helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.msg0251"), '',"info");
                    var modalData = helper.getMessagingModalJSON(initializeResponse);
                    if (modalData != null) {
                        $A.createComponent(
                            "et4ae5:message_modal",
                            {
                                "step_json": modalData,
                                "dynamicallyCreated" : true
                            },
                            function(newModal){
                                //Add the new modal to the body array
                                if (component.isValid()) {
                                    var body = component.get("v.body");
                                    body.push(newModal);
                                    component.set("v.body", body);
                                }
                            }
                        );                        
                    }
                    var cmpTarget = component.find("userCredsDiv");
                    $A.util.removeClass(cmpTarget, "hide");                    
                } 
            }
            else {
                helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.srySmtgWrng"), $A.get("$Label.et4ae5.msg0241"), "error");
            }
        });
        $A.enqueueAction(action);                   
    },

    handleErrorMessage : function(component, event, helper) {
        helper.bc_throwEventMessage(component, event.getParam("message"), event.getParam("title"), "error");
    },
})
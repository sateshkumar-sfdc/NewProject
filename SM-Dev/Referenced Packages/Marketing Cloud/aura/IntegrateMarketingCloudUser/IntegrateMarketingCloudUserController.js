({
	//During initialization the user credential attributes are generated
    //Things such as title, labels, and instructions.
    onInit : function(component, event, helper) {
		component.find("userCredsJSON").set("v.json",helper.getUserCredsJSON());
        //This is here to "temporarily" fix extensible component lightning issue`
        var action = component.get("c.isServer");     
        $A.enqueueAction(action);
    },
    
    //The userCredentials component uses the ThrowErrorMessage application event to throw errors
    //Here fuse the existing base component errors with the custom event
    handleErrorMessage : function(component, event, helper) {
        if(event.getParam("message") === $A.get("$Label.et4ae5.msg0239"))
            helper.bc_throwEventMessage(component, event.getParam("message"), event.getParam("title"), "info");
        else
            helper.bc_throwEventMessage(component, event.getParam("message"), event.getParam("title"), "error");
    },
    
    //If a BusinessUnitSelection event is fired, this function sets up the picklist, username, password,
    //and the business unit label to MID reference map that are all necessary when the user authenticates
    handleBusinessUnitSelection : function(component, event, helper) {
        var businessUnitsAvailableJSON = event.getParam("businessUnits");
        var businessUnitsAvailable =  JSON.parse(businessUnitsAvailableJSON);
        component.set("v.username", event.getParam("username"));
        component.set("v.password", event.getParam("password"));
        $A.util.removeClass(component.find("buSelectDiv"), "hide");
        $A.util.addClass(component.find("userCredsDiv"),"hide");
        helper.populateBUSelection(component, businessUnitsAvailable);
    },
    
    //This function handles the authentication call to the server and its responses
    multiOrgLoginAttempt : function(component, event, helper) {
        var username = component.get("v.username");
        var password = component.get("v.password");
    	var action = component.get("c.multiOrgStandardUserAuthenticate");
        var buSelect = component.find("buSelect");
        var buSelectVal = buSelect.get("v.value");
        
        //Client side validation
        if($A.util.isUndefined(buSelectVal) || buSelectVal === "" || buSelectVal === $A.get("$Label.et4ae5.none_dashes")) {
        	var selBU = $A.get("$Label.et4ae5.slctABUToCnnct");
            buSelect.set("v.errors", [{message: selBU}]);
            return;    
        }     
        else
            buSelect.set("v.errors", null);
   
        var buMID = helper.getMIDofSelectedBU(component,buSelect.get("v.value"));
        if($A.util.isUndefined(buMID) || buMID === "") {
        	helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.midNotFoundinJSON"), event.getParam("title"), "error");
    		return;
    	}        		
        action.setParams({"username" : username, "password" : password, "selectedBU": buMID});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
            	var data = JSON.parse(response.getReturnValue());
                //No errors
                if(!data.hasErrors) {
                    var urlprefix = "/apex/";
                    top.window.location.href = urlprefix.concat(data.destination);
                }
                else
                    helper.bc_throwEventMessage(component, data.message, data.messageTitle, "error");    
            }
            else {
                helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.srySmtgWrng"), $A.get("$Label.et4ae5.msg0241"), "error");    
            }
        });
        $A.enqueueAction(action);                                         
    }
})
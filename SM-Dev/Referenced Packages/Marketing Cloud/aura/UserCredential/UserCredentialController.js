({  
    doInit : function (component, event, helper) {
        var json = component.get("v.json");
        
        if(json  === null || json === "undefined") {
            component.set("v.json",helper.setJSON());
        }
    },
    showText : function(component, event) {
        var urllink = component.find("urllink");
        var element = urllink.getElement();
        element.setAttribute('disabled', 'disabled');
        var divAPIUrl = component.find("divAPIUrl");
        $A.util.removeClass(divAPIUrl.getElement(), 'hide');
        var divAdvancedlink = component.find("divAdvancedlink");
        $A.util.addClass(divAdvancedlink.getElement(), 'hide');
        var divURLlink = component.find("divURLlink");
        $A.util.removeClass(divURLlink.getElement(), 'hide');
    },
    enableText : function(component, event) {
        var urllink = component.find("urllink");
        var element = urllink.getElement();
        element.removeAttribute('disabled');
        var divURLlink = component.find("divURLlink");
        $A.util.addClass(divURLlink.getElement(), 'hide');
    },
    loginAttempt : function (component, event, helper) {
        var uname = component.find("uname");
        var json = component.get("v.json");
        var unameval = uname.get("v.value");
        if($A.util.isUndefined(unameval) || unameval === ""){
            uname.set("v.errors",[{message:"Please enter a " + json.first_label}]);
        }else{
            uname.set("v.errors", null);           
        }
       
        var passw = component.find("passw");
        var passwval = passw.get("v.value");
        if($A.util.isUndefined(passwval) || passwval === ""){
            passw.set("v.errors", [{message:"Please enter a " + json.second_label}]);
        }else{
            passw.set("v.errors", null); 
        }
        
        var valid_urlLink = false;
        var url_linkval;
        if(json.advanced_settings_flag) {
            var url_link = component.find("urllink");
            url_linkval = url_link.get("v.value");
            if($A.util.isUndefined(url_linkval) || url_linkval === ""){
                url_link.set("v.errors", [{message:"Please enter a " + json.third_label}]);
            }else{
                url_link.set("v.errors", null);
                valid_urlLink = true;
            }
        }
        else
            valid_urlLink = true;
        
        //Excecute callout if possible
        if(passw.get("v.errors") === null && uname.get("v.errors") === null && valid_urlLink)
        {
            var element = component.find("connect_button").getElement();
            element.setAttribute('disabled', 'disabled');
            var action = component.get(json.authenticate);
            var strFirst = "" + json.firstParamName;
            var strSec = "" + json.secParamName;
            var strTh = "" + json.thirdParamName;
            //If the url link is valid, it means we are using that option inside the component
            //Otherwise we assume that it is an authentication using existing configuration url
            if(!$A.util.isUndefined(url_linkval))
                action.setParams({"username" : unameval, "password" : passwval, "authAPIUrl": url_linkval});
            else
                action.setParams({"username" : unameval, "password" : passwval});    
            action.setCallback(this, function(response) {
                var state = response.getState();
                var data = JSON.parse(response.getReturnValue());
                if(component.isValid() && state === "SUCCESS") {
                    //c.authenticateStandardUser is passed by the developer
                    if(json.authenticate === "c.authenticateStandardUser") {
                        if(data.hasErrors) {
                        	//$A.get used to get application event
                            var standardUserAuthError = $A.get(json.error);
                            standardUserAuthError.setParams({"title" : data.messageTitle, "message" : data.message});
                            standardUserAuthError.fire();
                            if(data.needsToPickBU){
                            	//getEvent used to get component event
                                var pickBUEvent = component.getEvent("businessUnitSelect");
                                pickBUEvent.setParams({"businessUnits" : JSON.stringify(data.accessibleBusinessUnits), "username" : unameval, "password" : passwval});
                                pickBUEvent.fire();
                            }                            
                        }
                        else {
                            var urlprefix = "/apex/";
                            top.window.location.href = urlprefix.concat(data.destination);
                        }    
                    }
                    //Adding support for other authenticate functions should be done here
                    else if(json.authenticate === "c.authenticate") {
                        if(!data.hasErrors)
                            top.window.location.href = json.top + "";
                        else {
                            var apiUserAuthError = $A.get(json.error);
                            apiUserAuthError.setParams({"title" : $A.get("$Label.et4ae5.usrCredErr"), "message" : data.message});
                            apiUserAuthError.fire();   
                        }           
                    }
                }
                //Handling of unhandled apex exception
                else {
                    var errorEvent = $A.get(json.error);
                    var message;
                    if(data != null) {
                        if (data.message) {
                            message = data.message;
                        }
                        else {
                            message = $A.get("$Label.et4ae5.unkError");
                        }
                    }
                    else {
                        message = $A.get("$Label.et4ae5.msg0211");
                    }
                    errorEvent.setParams({"title" : $A.get("$Label.et4ae5.usrCredErr"), "message" : message});
                    errorEvent.fire();
                }
                element.removeAttribute('disabled');
            });
                $A.enqueueAction(action);
        }
    }
})
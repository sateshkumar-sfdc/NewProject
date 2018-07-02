({    
    getUserCredsJSON : function (destination) {
        return {
            "title"        : $A.get("$Label.et4ae5.chngMCAPIUsr"),
            "first_label"  : $A.get("$Label.et4ae5.username"),
            "first_placeholder"     : $A.get("$Label.et4ae5.mcAPIUsrAbbr"),
            "second_label" : $A.get("$Label.et4ae5.password"),
            "second_placeholder"    : "**********",
            "button_label" : $A.get("$Label.et4ae5.updtAPIUsr"),
            "authenticate" : "c.authenticate",
            "firstParamName" : "user",
            "secParamName" : "secret",
            "top"          : "/apex/" + destination,
            "error"        : "e.et4ae5:ThrowErrorMessage",
            "advanced_settings_flag" : true,
            "third_label"  : $A.get("$Label.et4ae5.editApiUrl"),
            "thirdParamName" : "link",
            "third_placeholder"       : $A.get("$Label.et4ae5.apiUrl"),
            "third_value"  : "https://webservice.exacttarget.com/Authentication/Auth.svc",
            "instruction_label" : $A.get("$Label.et4ae5.msg0248"),
            "advancedSettings" : $A.get("$Label.et4ae5.advancedSettings")
        };
    },

    getMessagingModalJSON : function (response) {
        if(!response.hasErrors) {
            return null;
        }
        else if(response.errorCode === "EMAIL_SENDS_FOUND") {
            return {
                "entries" : [
                    {
                        "title" : $A.get("$Label.et4ae5.outstndgEmlSnds"),
                        "body" : $A.get("$Label.et4ae5.msg0249")
                    }
                ]
            };
        }
        else if(response.errorCode === "TRIGGERED_SENDS_FOUND") {
            return {
                "entries" : [
                    {
                        "title" : $A.get("$Label.et4ae5.activeTS"),
                        "body" : $A.get("$Label.et4ae5.msg0250")
                    }
                ]
            };                    
        }
        else if(response.errorCode === "EMAIL_TRIGGERED_SENDS_FOUND") {
            return {
                "entries" : [
                    {
                        "title" : $A.get("$Label.et4ae5.outstndgEmlSnds"),
                        "body" : $A.get("$Label.et4ae5.msg0249")
                    },
                    {
                        "title" : $A.get("$Label.et4ae5.activeTS"),
                        "body" : $A.get("$Label.et4ae5.msg0250")
                    }
                ]
            };
        }
        else {
            helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.srySmtgWrng"), $A.get("$Label.et4ae5.msg0241"), "error");        
        }
    },
})
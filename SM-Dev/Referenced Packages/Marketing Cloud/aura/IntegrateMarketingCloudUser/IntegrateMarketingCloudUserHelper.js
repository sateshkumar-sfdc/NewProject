({
    getUserCredsJSON : function () {
        return {
            "title"        : $A.get("$Label.et4ae5.mcUsrCreds"),
            "first_label"  : $A.get("$Label.et4ae5.username"),
            "first_placeholder"     : $A.get("$Label.et4ae5.mcUsrAbbr"),
            "second_label" : $A.get("$Label.et4ae5.password"),
            "second_placeholder"    : "**********",
            "button_label" : $A.get("$Label.et4ae5.connect"),
            "authenticate" : "c.authenticateStandardUser",
            "firstParamName" : "user",
            "secParamName" : "secret",
            "top"          : "/apex/sendETEmail",
            "error"        : "e.et4ae5:ThrowErrorMessage",
            "advanced_settings_flag" : false,
            "third_label"  : $A.get("$Label.et4ae5.editApiUrl"),
            "thirdParamName" : "link",
            "third_placeholder"       : $A.get("$Label.et4ae5.apiUrl"),
            "third_value"  : "https://webservice.exacttarget.com/Authentication/Auth.svc",
            "instruction_label" : $A.get("$Label.et4ae5.msg0238"),
            "advancedSettings" : $A.get("$Label.et4ae5.advancedSettings")
        };
    },
    
    populateBUSelection : function(component, availableBUs) {
        var buReference = {};
        var listOfBUs = [];
        listOfBUs.push($A.get("$Label.et4ae5.none_dashes"));
    	availableBUs.forEach( function (val) {
            var label = val.et4ae5__Business_Unit_Name__c.concat(" (", val.et4ae5__Business_Unit_ID__c,")");
            listOfBUs.push(label);
            buReference[label] = val.et4ae5__Business_Unit_ID__c;
        });
        component.set("v.buSelectOptions", listOfBUs);
        component.set("v.buLabelToMIDReferenceJSON", JSON.stringify(buReference));
    },
    
    getMIDofSelectedBU : function(component, selectedBU) {
        var allBUs = JSON.parse(component.get("v.buLabelToMIDReferenceJSON"));
        var midString = "";
        if(!$A.util.isUndefined(selectedBU) && selectedBU !== "") 
            midString = allBUs[selectedBU];
        
        return midString;
    },
})
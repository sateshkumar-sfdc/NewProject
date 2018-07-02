({
    setJSON : function () {
		return {
            "title"        : $A.get("$Label.et4ae5.mcAPIUsr"),
            "first_label"  : $A.get("$Label.et4ae5.username"),
            "first_placeholder"     : $A.get("$Label.et4ae5.mcAPIUsrAbbr"),
            "second_label" : $A.get("$Label.et4ae5.password"),
            "second_placeholder"    : "**********",
            "button_label" : $A.get("$Label.et4ae5.connect"),
            "authenticate" : "c.authenticate",
            "firstParamName" : "user",
            "secParamName" : "secret",
            "top"          : "/apex/MarketingCloudSettings",
            "error"        : "e.et4ae5:ThrowErrorMessage",
            "advanced_settings_flag" : true,
            "third_label"  : $A.get("$Label.et4ae5.editApiUrl"),
            "thirdParamName" : "link",
            "third_placeholder"       : $A.get("$Label.et4ae5.apiUrl"),
            "third_value"  : "https://webservice.exacttarget.com/Authentication/Auth.svc",
            "advancedSettings" : $A.get("$Label.et4ae5.advancedSettings")
            };
    }
})
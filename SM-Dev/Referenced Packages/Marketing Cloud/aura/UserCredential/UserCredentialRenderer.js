({
    afterRender : function (component, event, helper) {
        this.superAfterRender();
        var json = component.get("v.json");

        component.set("v.json.title", json.title || "User Credentials");
        component.set("v.json.first_label", json.first_label || "USER NAME");
        component.set("v.json.first_placeholder", json.first_placeholder || "USER");
        component.set("v.json.second_label", json.second_label || "PASSWORD");
        component.set("v.json.second_placeholder", json.second_placeholder || "PASSWORD");
        component.set("v.json.button_label", json.button_label || "Login");
        component.set("v.json.authenticate", json.authenticate || "c.authenticate");
        component.set("v.json.firstParamName", json.firstParamName || "user");
        component.set("v.json.secParamName", json.secParamName || "secret");
        component.set("v.json.top", json.top || "http://www.google.com");
        component.set("v.json.error", json.error || "e.et4ae5:ThrowErrorMessage");
        component.set("v.json.advancedSettings", json.advancedSettings || "Advanced Settings");
        if(json.advanced_settings_flag) {
            component.set("v.json.third_label", json.third_label || "API-LINK");
            component.set("v.json.thirdParamName", json.thirdParamName || "link");
            component.set("v.json.third_placeholder", json.third_placeholder || "API-URL");
            component.set("v.json.third_value", json.third_value || "https://webservice.s1.qa1.exacttarget.com/Authentication/Auth.svc")
        }
    },
})
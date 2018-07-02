({    
    doInit: function(component, event, helper) {
        component.set("v.sidebysideJSON", helper.getSidebySideJSON());
        component.set("v.json_step", helper.getMessagingModalJSON());  
    },
    
    enableFin : function(component, event, helper) {
        
        var fin = component.find("finish_button");
        var finVal = fin.get("v.disabled");

        if (String(finVal) === "true") {
            fin.set("v.disabled", "false");
        }
        else {
            fin.set("v.disabled", "true");
        }      
    },
    
    finishSetup : function (component, event, helper) {
        $(".spinner").attr("class", "spinner uiSpinner");
        
        var options = {
            "backdrop" : "static"
        }
        
        $('#basicModal').modal(options);
        $("#server_response").html("");          
        $("#server_response").html($A.get("$Label.et4ae5.configMCCC"));
        helper.setAutomations(component, helper); 
    },

    clickOK : function(cmp, evt) {

        location.reload();
        /*TODO: Instead of reloading try to use an event to skip to the user login page
        var divAuto = component.find("divAutomation");
        $A.util.addClass(divAuto.getElement(), 'hide');
        var skipWizzardEvent = $A.get("e.et4ae5:SkipWizzard");
        skipWizzardEvent.fire();*/
    }    
})
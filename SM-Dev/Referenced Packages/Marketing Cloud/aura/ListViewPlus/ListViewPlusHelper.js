({    
    lvp_getRecords : function(component, helper) {
        var action = component.get("c.getRecords");
        var sObjectAPIName = component.get("v.sObjectAPIName");
        var sObjectFields = component.get("v.sObjectFields");
        action.setParams({
            sObjectFields : sObjectFields,
	        sObjectAPIName : sObjectAPIName
		});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set("v.records", records);
                if(records.length >= 4000){
                    var recordLimitLoadTitleLabel = component.get("v.recordLimitLoadTitleLabel");
            		var recordLimitLoadLabel = component.get("v.recordLimitLoadLabel");
                    helper.bc_throwEventMessage(component, recordLimitLoadLabel, recordLimitLoadTitleLabel, "info");
                }
            }
            if (component.isValid() && state === "ERROR") {
				component.set("v.records", []);
                var recordLoadErrorTitleLabel = component.get("v.recordLoadErrorTitleLabel");
          		var recordLoadErrorLabel = component.get("v.recordLoadErrorLabel");
                helper.bc_throwEventMessage(component, recordLoadErrorLabel, recordLoadErrorTitleLabel, "error");
            }
        });
	 	$A.enqueueAction(action);
    },
    
    // This method can be overwritten by the component implementing this abstract class.
    // Enter component specific validation before updating records 
    preUpdateProcess : function(component) {
    	return true;
    },
    
    lvp_updateRecords : function(component, helper) {
        // These two lines call the method "preUpdateProcess" in the helper class of the component (UserManagement)
        // implementing this abstract component (ListViewPlus). If the component implementing this abstract class
        // doesnt have a "preUpdateProcess" method in its helper, then the "preUpdateProcess" method in this helper 
        // will be called (right above).  
        var concreteComponent = component.getConcreteComponent();
    	var valid = concreteComponent.getDef().getHelper().preUpdateProcess(concreteComponent); 
        if(valid){
            var updatedRecords = component.get("v.updatedRecords");
            if(updatedRecords.length > 0){
                var action = component.get("c.updateRecords");
                action.setParams({
                    sObjects : updatedRecords
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    var cmpMessageEvent = component.getEvent("BCMessage");
                    if (component.isValid() && state === "SUCCESS") {
                        var result = JSON.parse(response.getReturnValue());
                        if(!result.hasErrors) {
                            component.set("v.updatedRecords", []);
        					var returnPage = component.get("v.returnPage");
							top.window.location.href = returnPage; 
                        }else{
                            var saveServerErrorTitleLabel = component.get("v.saveServerErrorTitleLabel");
                            var saveServerErrorLabel = component.get("v.saveServerErrorLabel");
                            helper.bc_throwEventMessage(component, result.message, saveServerErrorTitleLabel, "error");
                        }
                    }
                    if (component.isValid() && state === "ERROR") {
                        var saveServerErrorTitleLabel = component.get("v.saveServerErrorTitleLabel");
                        var saveServerErrorLabel = component.get("v.saveServerErrorLabel");
                        helper.bc_throwEventMessage(component, saveServerErrorLabel, saveServerErrorTitleLabel, "error");
                    }
                });
                $A.enqueueAction(action);
            }else{
                var saveNoChangeTitleLabel = component.get("v.saveNoChangeTitleLabel");
                var saveNoChangeLabel = component.get("v.saveNoChangeLabel");
                helper.bc_throwEventMessage(component, saveNoChangeLabel, saveNoChangeTitleLabel, "error");
            }
        }
    }
})
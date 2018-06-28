({
	loadCaseComments : function(component, event, helper) {
        helper.getCaseComments(component);

        // Fetch case comments again after 5 seconds each.
        window.setInterval(
            $A.getCallback(function() {
				helper.getCaseComments(component);
            }),
            10000
        );
    },    
    onChangeFunction : function(component,event, helper){
		var action = component.get("c.saveCaseComment");
		action.setParams({"concatekey": event.getSource().get("v.value")});
		action.setCallback(this, function(response) {});
		$A.enqueueAction(action);        
    }
})
({

    // Call apex controller method to fetch case comments.
    getCaseEmailFeed : function(component) {
        // Show page header.
        var pageHeader = component.find('pageHeaderSection');
        $A.util.removeClass(pageHeader, 'hideSection');

        var action = component.get("c.getAllCaseEmailFeed");
        action.setParams({
            caseId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {
				component.set("v.CaseEmailFeed", response.getReturnValue());
            }
            else {
				alert('-->'+response+'--'+response.getError());               
            }
        });
        $A.enqueueAction(action);
    }
})
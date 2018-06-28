({
    

    // Call apex controller method to fetch case comments.
    getMyTaskInvoices : function(component) {
        

        var action = component.get("c.getIsPostInvoices");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if(state === "SUCCESS") { 
                
				component.set("v.isPastDue",response.getReturnValue());
                 //var errorMessageSection = component.find("errorMessageDiv");
                 //$A.util.toggleClass(errorMessageSection, "error-message");
				 
				 /*var pageHeader = component.find('errorMessageDiv');
				 if(response.getReturnValue() == false){
					alert('ok');        
					$A.util.removeClass(pageHeader, 'hideSection');
				 }*/
            }
        });
        $A.enqueueAction(action);
    }
})
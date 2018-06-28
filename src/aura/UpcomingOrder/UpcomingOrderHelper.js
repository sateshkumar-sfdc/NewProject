({
	initialization : function(component) {
        
        var action = component.get("c.getUpcomingOrders");       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") { 
				component.set("v.orders",response.getReturnValue());
            }else{
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
    }
})
({
	showPopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
    },
    hidePopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.addClass(modal, className+'hide');
        $A.util.removeClass(modal, className+'open');
    },
    getNewCase : function(component) {
        
		//alert('call');
        var action = component.get("c.getNewCase"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {                 
				component.set("v.dval",response.getReturnValue());
            }else{
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
    },
    saveNewCase : function(component) {        
		//alert('call');
        var action = component.get("c.saveNewCase"); 
        action.setParams({ 
            "cobj" : JSON.stringify(component.get("v.dval"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") { 
				//alert(response);                
				
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
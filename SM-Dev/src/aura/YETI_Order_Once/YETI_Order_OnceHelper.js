({
	initialization : function(component) {
        
        var action = component.get("c.Intialization");       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") { 
				component.set("v.dval",response.getReturnValue());
                component.set("v.ShipToOptions",(component.get("v.dval")).ShipToOptions);
            }else{
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
    },
    saveOpportunity : function(component, stage) {
        
		component.set("v.ConfirmationMsg",'Creating Order, please wait.....');
        var action = component.get("c.saveOpportunity");     
        action.setParams({ 
            "wObj" : JSON.stringify(component.get("v.dval")),
            "stage" : stage
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(response);
            if(state === "SUCCESS") {  
				component.set("v.ConfirmationMsg",'Thank you for submitting your order!');
                //component.set("v.ShipToOptions",(component.get("v.dval")).ShipToOptions);
            }else{
                //alert(response);
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
    },
    getShipToAccount : function(component) {
        
		
        var action = component.get("c.getShipToAccount");     
        action.setParams({ 
            "wObj" : JSON.stringify(component.get("v.dval"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {                 
				component.set("v.ShipToOptions",response.getReturnValue());
            }else{
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
    },
    getNewOpportunity : function(component) {
        
		//alert('call');
        var action = component.get("c.getNewOpportunity");     
        action.setParams({ 
            "wObj" : JSON.stringify(component.get("v.dval"))
        });
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
    removeShipToItem : function(component,pbeid) {
        
        var action = component.get("c.removeShipToItem");     
        action.setParams({ 
            "wObj" : JSON.stringify(component.get("v.dval")),
            "pbeid" : pbeid
        });
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

    
    SaveOrderOnceProduct : function(component) {    
        
        var action = component.get("c.saveOrderOnce");
        action.setParams({ 
            "wObj" : JSON.stringify(component.get("v.dval"))
        });
        
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
    findProductEntry : function(component, event) {       
		
		var searchtext = component.find("searchtext").get("v.value");
		var productcategory = "";//component.find("searchcategory").get("v.value");
        
        
		var action = component.get("c.getFilteredProducts");
        action.setParams({ 
            "wObj" : JSON.stringify(component.get("v.dval")),
            "searchText" : searchtext,
			"productCategory" : productcategory
        });
		

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
    searchOrderOnce : function(component) {       
		
        var action = component.get("c.searchOrderOnce");
        action.setParams({ 
            "wObj" : JSON.stringify(component.get("v.dval"))
        });
		

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {    
				component.set("v.dval",response.getReturnValue());
                component.set("v.ShipToOptions",(component.get("v.dval")).ShipToOptions);
            }else{
               
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
        
    },
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
})
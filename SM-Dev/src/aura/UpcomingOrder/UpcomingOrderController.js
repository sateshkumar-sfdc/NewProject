({
	onloadpage : function(component, event, helper) {        
        helper.initialization(component);        
    },
    onOrderClick : function(component, event, helper) {
    	var orderid = event.srcElement.id;        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ 
            "url": '/order/' + orderid            
        });
        urlEvent.fire();        
	},
    onViewAllClick : function(component, event, helper) {      
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/order/Order__c/00B0S000000Vp7uUAC'          
        });
        urlEvent.fire();        
	}
})
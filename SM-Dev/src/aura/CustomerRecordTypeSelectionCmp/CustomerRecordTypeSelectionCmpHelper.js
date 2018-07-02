({
	openWindow : function(component, event, helper) { 
        try{
           
            component.set("v.Spinner",true);
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:CreateCustomerCmp",
                componentAttributes: {
                    "customerType":component.find("selectid").get('v.value'),
                    "Spinner":true
                }
    });
    		evt.fire();
            component.set("v.isOpen", false);
            component.destroy();
            
        }catch(Err){
          
        } 
    },
})
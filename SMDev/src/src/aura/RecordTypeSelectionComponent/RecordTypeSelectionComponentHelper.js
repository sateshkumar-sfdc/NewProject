({
	openWindow : function(component, event, helper) { 
        try{
            $A.createComponent(
                "c:CreateCustomerCmp",{
                }, 
                
                function(newcomponent){
                    if (component.isValid()) {
                        var body = component.get("v.body");
                        body.push(newcomponent);
                        component.set("v.body", body); 
                        component.set("v.isOpen", false);
                    }
                }            
            );
            
        }catch(Err){
           //console.log(Err);
          
        } 
    },
})
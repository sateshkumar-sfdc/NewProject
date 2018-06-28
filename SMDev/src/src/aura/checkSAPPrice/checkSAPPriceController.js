({
	doInit : function(component, event, helper) {
        
        var action = component.get("c.getStatus");
         component.set("v.Spinner",true);
        action.setCallback(this, function(response){
                var state = response.getState();
             if(state === "SUCCESS"){
           component.set("v.Spinner",false);
       var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
      helper.showToast(component);
             }else{
                 
            console.log("error");
        }
      
            
      
        });        
		 $A.enqueueAction(action);
        
	}
})
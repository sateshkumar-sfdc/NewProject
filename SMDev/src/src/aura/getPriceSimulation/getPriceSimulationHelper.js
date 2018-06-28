({
	getResponse : function(component, recID, callback){
        try{
		    var action = component.get("c.getPriceSimulation");     
            component.set("v.Spinner",true);
            action.setParams({
                recordId : recID
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log(state);
                 
                 if (state === "SUCCESS") { 
                     var result = response.getReturnValue();
                      if (result === "Successfully updated" && result != null){
                          component.set("v.MESSAGE",response.getReturnValue());
                           var dismissActionPanel = $A.get("e.force:closeQuickAction");
                          dismissActionPanel.fire();
                       
                        var label = component.get("v.MESSAGE");
                        this.showToast(component,"Success!",label,"success"); 
                       }
                     else{
                          var dismissActionPanel = $A.get("e.force:closeQuickAction");
                          dismissActionPanel.fire();
                          this.showToast(component,"Error!",$A.get("$Label.c.ComponentError"),"error");
                     }
                     
                    }
                    
                  component.set("v.Spinner",false);
                  $A.get('e.force:refreshView').fire();    
                 
            }); 
                  $A.enqueueAction(action);
           }catch(Err){
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                this.showToast(component,"Error!",$A.get("$Label.c.ComponentError"),"error");
              //	 console.log($A.get("$Label.c.ComponentError"));
           }
              
        },
    
            
       
         
    showToast : function(component,title,message,type){
        try{
          var toastEvent = $A.get("e.force:showToast");
         toastEvent.setParams({
            "title": title,
            "message":message ,
            "type" : type
         });
          toastEvent.fire();
          }catch(Err){
             console.log(Err);
            }
    }
})
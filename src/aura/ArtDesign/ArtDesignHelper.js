({
	getResponse : function(component, artID, callback){
        try{
		    var action = component.get("c.getProducts");     
            component.set("v.Spinner",true);
            action.setParams({
                recordId : artID
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
               // console.log(state);
                 if (state === "SUCCESS") { 
                     var result = response.getReturnValue();
                      if (result!= null){
                       component.set("v.image",response.getReturnValue());
                      }else{
                          component.set("v.image",null);
                          component.destroy();
                          this.showToast(component,"Error!",$A.get("$Label.c.Art"),"error"); 
                      }
                 }else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                        this.showToast(component,"Error!",$A.get("$Label.c.Art"),"error"); 
                      
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                       this.showToast(component,"Error!",$A.get("$Label.c.Art"),"error"); 
                    }
                 component.set("v.Spinner",false); 
                        
                  }); 
                  $A.enqueueAction(action);
        }catch(Err){
             this.showToast(component,"Error!",$A.get("$Label.c.Art"),"error"); 
        }
    },
    
    navigate : function(component,event,myLabel){
        try{
         var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                 "url": myLabel
                 });
                urlEvent.fire();
        }catch(Err){
      this.showToast(component,"Error!",$A.get("$Label.c.Art"),"error"); 
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
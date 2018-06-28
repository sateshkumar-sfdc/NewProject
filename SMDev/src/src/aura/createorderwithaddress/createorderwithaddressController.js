({
	  clickcheck : function(component, event, helper){
        //var aci = helper.checkingvalid(component, event, helper);
         var mcheck = component.find("mcheck").get("v.value");
          console.log(mcheck);
          if(mcheck === true){
              component.set("v.checked",true);
             }
          else{
              component.set("v.checked",false);
              
          }
      },
    
    
       createorder : function(component, event, helper){
            var recID = component.get("v.recordId");
           console.log(recID);
           
      
             var action = component.get("c.createOrder");
       // if (action!=null && action !=undefined){
       
         var mcheck = component.find("mcheck").get("v.value");
  
       if(mcheck){
          if(helper.checkingvalid(component, event, helper)){
        
        var aStreet = component.find("mStreet").get("v.value");
        var aCity = component.find("mCity").get("v.value");
        var aState = component.find("mState").get("v.value");
        var aZIPCode = component.find("mZIPCode").get("v.value"); 
          component.set("v.Spinner",true);     
               
      action.setParams({
                      check : mcheck,
                      recordId: recID,
                      aStreet:aStreet,
                      aCity:aCity,
                      aState:aState,
                      aZIPCode:aZIPCode
                      });  
        
       action.setCallback(this, function(response){
                var state = response.getState();
               // console.log(state);
                 
                 if (state === "SUCCESS") { 
                     var result = response.getReturnValue();
                      if (result != null){
                          component.set("v.MESSAGE",response.getReturnValue());
                          
                          var dismissActionPanel = $A.get("e.force:closeQuickAction");
                          dismissActionPanel.fire();
                         var label =  component.get("v.MESSAGE");
                         helper.createRecord(component, label, helper);
                        
                       }
                     else{
                          var dismissActionPanel = $A.get("e.force:closeQuickAction");
                          dismissActionPanel.fire();
                        helper.showToast(component,"Error!",$A.get("$Label.c.ComponentError"),"error");
                     }
                     
                    }
                    
                  component.set("v.Spinner",false);
                  $A.get('e.force:refreshView').fire();    
                 
            }); 
                  
             
          
        
          }
  }
        else{
             component.set("v.Spinner",true);
            action.setParams({
                      check : mcheck,
                      recordId: recID,
                      aStreet:"",
                      aCity:"",
                      aState:"",
                      aZIPCode:"",
            })
            
             action.setCallback(this, function(response){
                var state = response.getState();
               // console.log(state);
                 
                 if (state === "SUCCESS") { 
                     var result = response.getReturnValue();
                      if (result != null){
                          component.set("v.MESSAGE",response.getReturnValue());
                           var dismissActionPanel = $A.get("e.force:closeQuickAction");
                          dismissActionPanel.fire();
                      var label =  component.get("v.MESSAGE");
                      helper.createRecord(component, label, helper);
                        
                       }
                     else{
                          var dismissActionPanel = $A.get("e.force:closeQuickAction");
                          dismissActionPanel.fire();
                         helper.showToast(component,"Error!",$A.get("$Label.c.ComponentError"),"error");
                     }
                     
                    }
                    
                  component.set("v.Spinner",false);
                  $A.get('e.force:refreshView').fire();    
                 
            }); 
        }

    $A.enqueueAction(action);
    }
    
    
   
    
    
    
  
})
/*
*************************************************************
** Name: ReleaseButtonCmpHelper.js                  	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose: (Omni Channel)								   **
** This is helper method for ReleaseButtonCmp              **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 05/20/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/
/* Helper Method*/

({
    getResponse : function(component, recID, callback){
        try{
            // alert('helper');
            
            //run server side controller when action happend
            var action = component.get("c.createAccountInSAP");     
            //component.set("v.Spinner",true);
            action.setParams({
                "ac" : '' ,
                "recId" : recID
            });
            
            //Handle response from Apex controller & Toast messages
            action.setCallback(this, function(response){
                var state = response.getState();
                // console.log(state);
                
                if (state === "SUCCESS") { 
                    var result = response.getReturnValue();
                    var resultStr =result.substr(0, 36); // expected result "Successfully Created SAP Customer"
                    var resultStrExt =result.substr(0, 23); // expected result "Account Already Exist!!"
                    var resultStrExtE =result.substr(0, 5);
                    
                    // console.log(result);
                    // console.log(resultStr);
                    // console.log(resultStrExt);
                    // console.log(resultStrExtE);
                    
                    if (resultStr === "Successfully Created Customer in SAP" && result != null){
                        component.set("v.MESSAGE",response.getReturnValue());
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        
                        var label = component.get("v.MESSAGE"); // Message show on the Popup Successfully Created SAP Customer 0000101918
                        this.showToast(component,"Success!",label,"Success"); 
                    }
                    
                    else if (resultStrExt === "Account Already Exist!!" && result != null){
                        component.set("v.MESSAGE",response.getReturnValue());
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        
                        var label = component.get("v.MESSAGE"); // Message show on the Popup Account Already Exist!! 0000101918
                        this.showToast(component,"Already Exist!!",label,"warning"); 
                    }
                    
                        else if(resultStrExtE === "Error"){
                            component.set("v.MESSAGE",response.getReturnValue());
                            var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            dismissActionPanel.fire();
                            var label = component.get("v.MESSAGE");
                            this.showToast(component,"Mandatory fields are Missing to create in SAP!",label,"Error");
                        }
                            else{
                                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                dismissActionPanel.fire();
                                var label = component.get("v.MESSAGE");
                                this.showToast(component,"Error!",label,"Error");
                            }
                    
                }
                component.set("v.Spinner",false);
                $A.get('e.force:refreshView').fire();    
                
            }); 
            $A.enqueueAction(action);
        }catch(Err){
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            //  this.showToast(component,"Error!",$A.get("$Label.c.ComponentError"),"error");
        }
        
    },
    // Showing the message on the screen
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
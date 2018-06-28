/*
*************************************************************
** Name: ReleaseButtonCmpController.js              	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose: (Omni Channel)								   **
** This js controller handles the necessary functions      **
** for the  ReleaseButtonCmp.cmp and Run the related Helper**
** Method "ReleaseButtonCmpControllerHelper.Js"            **
** and push to Server Side controller                      **
** UpdateOpportunityOwner.apxc                             **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 05/20/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/
/* Client - Side Controller*/

({
    doInit : function(component, event, helper) {
        try{
            
            //get the record id from the Data service and assign to attribute recID
            var recID = component.get("v.recordId"); 
            component.set("v.Spinner",true);
            //console.log(recID);
            
            //Call helper method (getResponse) to run the logic 
            helper.getResponse(component, recID, event);
        }catch(Err){
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            //console.log(Err);
            // helper.showToast(component,"Error!",$A.get("$Label.c.ComponentError"),"error");
        }
    },
    
})
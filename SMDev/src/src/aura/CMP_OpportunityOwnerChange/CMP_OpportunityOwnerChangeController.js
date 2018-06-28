/*
*************************************************************
** Name: CMP_OpportunityOwnerChangeController.js    	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose: (Omni Channel)								   **
** This js controller handles the necessary functions      **
** for the  CMP_OpportunityOwnerChange.cmp. Capture the    **
** WorkItemId and WorkId from component and push to Server ** 
** side controller UpdateOpportunityOwner.apxc             **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 05/04/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/
/* Client - Side Controller*/
({
    onWorkAccepted : function(component, event) {
        // console.log("Work accepted.");
        var workItemId = event.getParam('workItemId');
        // var workId = event.getParam('workId');
        //console.log(workItemId);
        //console.log(workId);
        var wrk = workItemId.toString();
        var sli = wrk.slice(0,3);
        // console.log(sli);
        
        //only work for Custom Opportunities
        if(sli == 'a1X'){
            // console.log('Test Fire');
            var action = component.get("c.updateOpportunityOwner");
            action.setParams({ workItemId : workItemId });
            action.setCallback(this,function(actionResult) {
                var state = actionResult.getState();
                //Error Capture
                if(state == "SUCCESS"){
                    var returnValue = actionResult.getReturnValue();
                    if(returnValue != null){
                        console.log(returnValue);
                    } else{
                        console.log('Error : Return value is Null');
                    }
                }
            });
            
            $A.enqueueAction(action);
            $A.get("e.force:refreshView").fire();
            
        } 
    }
})
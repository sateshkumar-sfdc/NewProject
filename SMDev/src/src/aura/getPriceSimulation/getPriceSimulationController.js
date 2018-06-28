({
	doInit : function(component, event, helper) {
        try{
            var recID = component.get("v.recordId");
            helper.getResponse(component, recID, event);
        }catch(Err){
             var dismissActionPanel = $A.get("e.force:closeQuickAction");
             dismissActionPanel.fire();
            //console.log(Err);
             helper.showToast(component,"Error!",$A.get("$Label.c.ComponentError"),"error");
            }

    },

})
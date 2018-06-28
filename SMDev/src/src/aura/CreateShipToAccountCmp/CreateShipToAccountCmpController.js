({
	doInit : function(component, event, helper) {
        try{
            
            //get the record id from the Data service and assign to attribute recID
            var recID = component.get("v.recordId"); 
            console.log('Record Id : '+recID);
            
            //Call helper method (getResponse) to run the logic 
            helper.getSoldTo(component, recID, event);
        }catch(Err){
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            //console.log(Err);
            // helper.showToast(component,"Error!",$A.get("$Label.c.ComponentError"),"error");
        }
    },
    
    saveAccount : function(component, event, helper) {
        console.log('test');
         
        helper.saveShipto(component, component.get("v.recordId"));
        
    }
    
})
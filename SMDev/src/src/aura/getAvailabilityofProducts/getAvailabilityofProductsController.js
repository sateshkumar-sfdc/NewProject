({
	 handleComponentEvent : function(component, event, helper) {
          component.set("v.SearchKeyWord",null);
        // get the selected object record from the COMPONENT event 	 
       // var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        
        console.log('hi-->' + selectedAccountGetFromEvent.ENSX_EDM__Material__c);
        var selectedrecords = helper.getPricing(selectedAccountGetFromEvent,component,event);
        
        console.log('server-->' + selectedrecords);
        
        
       // listSelectedItems.push(selectedAccountGetFromEvent);
       // component.set("v.lstSelectedRecords" , listSelectedItems); 
        
        
        console.log('hey-->'+listSelectedItems);
         
     }
})
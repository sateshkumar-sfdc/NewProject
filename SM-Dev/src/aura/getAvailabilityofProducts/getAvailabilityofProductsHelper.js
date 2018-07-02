({
	    getPricing : function(selectedAccountGetFromEvent,component,event) {
    component.set("v.loaded",true);
    console.log('select----->'+selectedAccountGetFromEvent);
         var action1 = component.get("c.productAvailj");
       
        
        action1.setParams({ 
            "Sapnumber" : component.get("v.sapnumber"),
            "Materialnumber":selectedAccountGetFromEvent.ENSX_EDM__Material__c,
            "materialname":selectedAccountGetFromEvent.Name
         })   
        
        action1.setCallback(this, function(response1) {
         var state = response1.getState();
            if (state === "SUCCESS") {
       var storeResponse1 = response1.getReturnValue();
                console.log('testhi'+ storeResponse1.Quantitys);
              var listSelectedItems1 =  component.get("v.lstSelectedRecords1");
                listSelectedItems1.push(storeResponse1);
                component.set("v.lstSelectedRecords1" , listSelectedItems1); 
            }
            
             component.set("v.loaded",false);
        });
         $A.enqueueAction(action1);
  
    }
})
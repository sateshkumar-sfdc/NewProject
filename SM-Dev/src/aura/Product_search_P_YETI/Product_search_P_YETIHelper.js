({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'ExcludeitemsList' :null // component.get("v.lstSelectedRecords")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                    // set searchResult list with return value from server.
                }
                component.set("v.listOfSearchRecords", storeResponse); 
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
   /* getPricing : function(selectedAccountGetFromEvent,component,event) {
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
  
    }*/
})
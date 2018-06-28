({
    getSoldTo : function(component, recID, event) {
        
        //alert('helper');
        	
        //run server side controller when action happend
        var action = component.get("c.getSoldToAccount");     
        var Accountname = component.find("accountnameId").get("v.value");

        action.setParams({
            "recId" : recID
        });
        
        action.setCallback(this, function(getSoldToresponse){
            var state = getSoldToresponse.getState();
            if (state === "SUCCESS") {
                var storeResponse = getSoldToresponse.getReturnValue();
                console.log(storeResponse);
                component.set("v.acc", storeResponse);
                component.find("accountnameId").set("v.value",storeResponse.Name);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    saveShipto : function(component, recID) {
        
        //alert('helper');
        	var accstreet = component.find("addressStreetId").get("v.value");
           	
            component.set("v.acc.ShippingStreet", component.find("addressStreetId").get("v.value"));
        	component.set("v.acc.ShippingCity", component.find("addressCityId").get("v.value"));
        	component.set("v.acc.ShippingState", component.find("addressStateId").get("v.value"));
        	component.set("v.acc.ShippingPostalCode", component.find("addressZipId").get("v.value"));
        	component.set("v.acc.ShippingCountry", component.find("addressCountryId").get("v.value"));
        	component.set("v.acc.Id", null);
        
        var saveAcc = component.get("c.saveShipTo");     
        

        saveAcc.setParams({
            "ac" : component.get("v.acc"),
            "recId" : recID
        });
        
        saveAcc.setCallback(this, function(saveAccresponse){
            var saveAccresponseState = saveAccresponse.getState();
            if (saveAccresponseState === "SUCCESS") {
                var saveAccresponseResult = saveAccresponse.getReturnValue();
                console.log('save result'+saveAccresponseResult);
            }
        });
        $A.enqueueAction(saveAcc);
       
    },
    
    
})
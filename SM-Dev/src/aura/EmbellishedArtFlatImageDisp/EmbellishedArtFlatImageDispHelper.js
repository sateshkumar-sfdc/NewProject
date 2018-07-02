({
	
      /*
    Author : Ranjith Thadakala
    version: 1.0
    Date : 4/12/2018
    helper creating custom component c:ArtDesign when click of Button */
    
    openWindow : function(component, event, helper) { 
        try{
            $A.createComponent(
                "c:ArtDesign",{
                    "ArtID":component.get("v.recordId"),
                }, 
                
                function(newcomponent){
                    if (component.isValid()) {
                        var body = component.get("v.body");
                        body.push(newcomponent);
                        component.set("v.body", body);             
                    }
                }            
            );
            
        }catch(Err){
           //console.log(Err);
          
        } 
    },
    
    getUrlValues :function(component,event) {
        try{
            var baseUrl = component.get("c.getCommonMetaData");
            baseUrl.setParams({  metadataName : "AmazonUrl" });
            baseUrl.setCallback(this,function(baseUrlResponse) { 
                var state = baseUrlResponse.getState();
                if (state === "SUCCESS") { 
                    var result = baseUrlResponse.getReturnValue();
                    if (result!= null) {    
                        component.set("v.amazonUrl", baseUrlResponse.getReturnValue());
                        console.log(baseUrlResponse.getReturnValue());
                    }else {
                        component.set("v.amazonUrl", null);
                    }
                	}else if (state === "INCOMPLETE") {
                        this.showToast(component,"Error!","No response from server or client is offline.","error"); 
                        //console.log("No response from server or client is offline.")
                        // Show offline error
                	}else if (state === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                        this.showToast(component,"Error!",$A.get("$Label.c.Art"),"error"); 
                    }
                
            });
            var flatPng = component.get("c.getCommonMetaData");
            flatPng.setParams({  metadataName : "Flat" });
            flatPng.setCallback(this,function(flatPngResponse) {
                
                var state = flatPngResponse.getState();
                if (state === "SUCCESS") { 
                    var result = flatPngResponse.getReturnValue();
                    if (result!= null) { 
                        component.set("v.amazonUrlEnd", flatPngResponse.getReturnValue());
                        console.log(flatPngResponse.getReturnValue());
                    }else {
                        component.set("v.amazonUrlEnd", null);
                    }
                	}else if (state === "INCOMPLETE") {
                        this.showToast(component,"Error!","No response from server or client is offline.","error"); 
                        //console.log("No response from server or client is offline.")
                        // Show offline error
                	}else if (state === "ERROR") {
                        console.log("Error: " + errorMessage);
                        this.showToast(component,"Error!",$A.get("$Label.c.Art"),"error"); 
                    }
            });
            $A.enqueueAction(baseUrl);
            $A.enqueueAction(flatPng);
        }
        catch(Err){
            //console.log(Err);
        }
    },
    
     /*
    Author : Sumanth Anumukonda
    version: 1.0
    Date : 4/20/2018
    helper to show toast when some error handling need to take place. */
    
    showMyToast : function(component,title,message,type) {
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
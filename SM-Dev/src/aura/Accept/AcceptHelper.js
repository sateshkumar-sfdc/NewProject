({
	initialization : function(component) {
        console.log(JSON.stringify(component.get("v.recordId")));
        var action = component.get("c.ownerChange"); 
        action.setParams({ 
            "RecordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") { 
				component.set("v.pmessage",response.getReturnValue());
                console.log('Result:'+response.getReturnValue());
                var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                    "url": "/one/one.app?source=alohaHeader/case/"+ component.get("v.recordId")+"/view"
                });
                urlEvent.fire();
                //window.location.replace('https://yetiappirio--appiriodev.lightning.force.com/one/one.app?source=alohaHeader#/sObject/'+component.get("v.recordId")+'/view') ; 
            }else{
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
    }
})
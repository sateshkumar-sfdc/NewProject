({
	getLineData : function(cmp,idp) {
        cmp.set("v.spinner",true)
        var action = cmp.get('c.getLineItems');
        action.setParams({
            
            "recId": idp
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.Lineitemslist', response.getReturnValue());
                console.log("working-->" + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            cmp.set("v.spinner",false)
        }));
        $A.enqueueAction(action);
    }
    
    
    
    
    
})
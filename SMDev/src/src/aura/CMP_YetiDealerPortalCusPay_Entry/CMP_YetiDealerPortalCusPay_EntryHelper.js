({
    //Add any helper method here
	getAcctId : function(component) {
		var action = component.get("c.getAccountId");

		action.setCallback(this, function(a){
			if (a.getState() === "SUCCESS"){
				var id = a.getReturnValue();
				if (id){
					var queryString = "?SF_AcctId=" + id;
					component.set("v.accountParam", queryString);
				}
			}
			else if (a.getState() === "ERROR"){
				$A.log("Errors", a.getError());
			}
		});

		$A.enqueueAction(action);
	}
})
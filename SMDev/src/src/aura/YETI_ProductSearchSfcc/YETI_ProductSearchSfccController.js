({
	searchProductsInDemandware : function(component, event, helper) {
        var action = component.get("c.getSearchedProducts");
        action.setParams({ searchText : component.get("v.SearchKeyWord") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let jsonStr = response.getReturnValue();
                console.log("jsonStr => ",jsonStr);
                let jsonresp = JSON.parse(jsonStr);
                component.set("v.searchedProducts",jsonresp);
            }
            else if (state === "INCOMPLETE") {
                alert("error");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }
})
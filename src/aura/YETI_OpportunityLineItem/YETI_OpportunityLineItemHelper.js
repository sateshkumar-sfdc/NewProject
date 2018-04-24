({
    getOppLineItems : function(component) {       
		
        var action = component.get("c.getOpportunityLineItems");
        action.setParams({ 
            "OppId" : component.get("v.recordId")
         });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {    
                //alert(response.getReturnValue());
				component.set("v.opp",response.getReturnValue());
            }else{
                
            }
        });
        $A.enqueueAction(action);
    },
	SelectProductEntry : function(component,event) {       
		
		//alert(event.getSource().get("v.name")+'--'+component.get("v.opp"));
        var action = component.get("c.getRefreshOpportunityLineItems");
        action.setParams({ 
            "wOppObj" : JSON.stringify(component.get("v.opp")),
            "ProductEntryId" : event.getSource().get("v.name")
         });

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {    
                //alert(response.getReturnValue());
				component.set("v.opp",response.getReturnValue());
            }else{
               
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
    },
    removeProductEntry : function(component,event) { 
        var action = component.get("c.getRemoveOpportunityLineItems");
        action.setParams({ 
            "wOppObj" : JSON.stringify(component.get("v.opp")),
            "ProductEntryId" : event.getSource().get("v.name")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {    
				component.set("v.opp",response.getReturnValue());
            }else{               
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
    },
    findProductEntry : function(component) {       
		
		var searchtext = (component.find("searchtext")).get("v.value");
		var productcategory = component.find("productcategorylist").get("v.value");
		var action = component.get("c.getFilteredProducts");
        action.setParams({ 
            "wOppObj" : JSON.stringify(component.get("v.opp")),
            "searchText" : searchtext,
			"productCategory" : productcategory
        });
		

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {    
				component.set("v.opp",response.getReturnValue());
            }else{
               
                var theErrors = response.getError();
                for(var i = 0; i < theErrors.length; i++) {
					alert(theErrors[i].message);
        		}
            }
        });
        $A.enqueueAction(action);
        
    },
	
	saveOpportunityProducts: function(component,event,btnname) {       
		//alert('call');
        var sellist = component.get("v.opp").lstSelLine;
		var isError = false;
        for(var i = 0; i < sellist.length; i++) {
            if(sellist[i].lineQuantity == null || sellist[i].lineQuantity == '' || sellist[i].linePrice == null || sellist[i].linePrice == ''){
                
				isError = true;
                if(sellist[i].lineQuantity == null || sellist[i].lineQuantity == ''){
                    var errordiv = document.getElementById(sellist[i].PriceBookEntryId+'-Q');
                    errordiv.style.border = 'solid 1px red';
                }
                if(sellist[i].linePrice == null || sellist[i].linePrice == ''){
                    var errordiv = document.getElementById(sellist[i].PriceBookEntryId+'-U');
                    errordiv.style.border = 'solid 1px red';
                }
            }
		}
		if(isError == false) {   
           // alert('going to call');
			var action = component.get("c.saveProducts");
                action.setParams({ 
                    "wOppObj" : JSON.stringify(component.get("v.opp")),
                    "btnname" : btnname
                });
                
        
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if(state === "SUCCESS") {    
                        //alert('saved');
                        //$A.get('e.force:refreshView').fire();                       
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                          "url": "/opportunity/Opportunity/00Bi0000003jz4mEAA"
                        });
                        urlEvent.fire();

                    }else{
                       
                        var theErrors = response.getError();
                        for(var i = 0; i < theErrors.length; i++) {
                            alert(theErrors[i].message);
                        }
                    }
                });
                $A.enqueueAction(action);
                
            }
        
            
		
        
    }
})
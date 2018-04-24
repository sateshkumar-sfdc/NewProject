({
	onloadpage : function(component, event, helper) {        
        helper.getOppLineItems(component);
    },
    addProduct : function(component, event, helper) {
        //var whichOne = event.getSource().getLocalId();        
		helper.SelectProductEntry(component,event);        
    },
	removeProduct : function(component, event, helper) {
        //var whichOne = event.getSource().getLocalId();        
		helper.removeProductEntry(component,event);        
    },
    onFindProduct : function(component, event, helper) {      
		helper.findProductEntry(component,event);        
    },
    cancelOpportunityProduct : function(component, event, helper) { 
    		var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                "url": "/opportunity/Opportunity/00Bi0000003jz4mEAA"
            });
            urlEvent.fire();
    },
    saveOpportunityProduct:function(component, event, helper) {    
		var oppobj = component.get("v.opp");
		var isError = false;	        
		if(oppobj.lstSelLine.length == 0){			
			isError = true;
			component.find('selectedproductlbl').set("v.value","Add at least one product");                
		}else {
			component.find('selectedproductlbl').set("v.value","");  
		}
		
		if(!isError){
			helper.saveOpportunityProducts(component,event,'Save');
		}		        
    },
    submitOpportunityProduct:function(component, event, helper) { 
		var oppobj = component.get("v.opp");
		var isError = false;	        
		if(oppobj.lstSelLine.length == 0){			
			isError = true;
			component.find('selectedproductlbl').set("v.value","Add at least one product");                
		}else {
			component.find('selectedproductlbl').set("v.value","");  
		}
		
		if(!isError){
			helper.saveOpportunityProducts(component,event,'Submit');
		}
		        
    },
    onTermAndConditionCheck: function(cmp, evt) {
		 var checkCmp = cmp.find("termandcondition");
         if(checkCmp.get("v.value")){
             var btn1 = cmp.find('submitoppbtn');
             btn1.set("v.disabled",false);
             
             var btn2 = cmp.find('submitoppbtn2');
             btn2.set("v.disabled",false);

         }else{
             var btn1 = cmp.find('submitoppbtn');
             btn1.set("v.disabled",true);
             
             var btn2 = cmp.find('submitoppbtn2');
             btn2.set("v.disabled",true);

         }
         

	 }
    
})
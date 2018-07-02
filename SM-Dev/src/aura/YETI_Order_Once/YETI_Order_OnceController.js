({
	onloadpage : function(component, event, helper) {        
        helper.initialization(component);        
    },    
    onAccountSearch : function(component, event, helper) {  
        if (event.keyCode === 13) {
            /*var searchtext = component.find("strShipTo").get("v.value");
            alert(searchtext);*/
            helper.searchOrderOnce(component);
        }
    },
    onOpportunityClick : function(component, event, helper) {
    	var oppid = event.srcElement.id;
        var oppstage = event.srcElement.name;
        if(oppstage == 'Submit' || oppstage == 'Trading Post Submitted'){
            alert('Order has been submitted, please contact your Outside Rep with any questions.');
        }else{
            var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                "url": '/opportunity/' + oppid
            });
            urlEvent.fire();
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
         

	 },

    submitMOpportunity : function(component, event, helper) {
        var oppobj = component.get("v.dval");
        var isError = false;        
        
        var nameField = component.find("oppclosedate");
        var nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Close Date"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
        
        /*nameField = component.find("oppname");
        nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Opportunity name"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }*/
        
        
        /*nameField = component.find("oppstage");
        nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Stage"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }*/
        
		nameField = component.find("oppaccname");
        nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Account Name"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
        
         nameField = component.find("oppponumber");
         nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Po Number"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
        
         /*nameField = component.find("oppneedbydate");
         nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Select Date"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }*/
        
         nameField = component.find("oppshipto");
         nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Ship To Name"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
		
		
        //var oppstage1 = (component.find("oppstage")).get("v.value");
        
		if(!isError){
			//helper.saveOpportunity(component,oppstage1);
			helper.saveOpportunity(component,'Trading Post');
			helper.hidePopupHelper(component, 'newmodaldialog', 'slds-fade-in-');
			helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
			
			helper.showPopupHelper(component, 'confirmmodaldialog', 'slds-fade-in-');
			helper.showPopupHelper(component,'backdrop','slds-backdrop--');
				
		}
    },
    saveMOpportunity : function(component, event, helper) {
        var oppobj = component.get("v.dval");
        var isError = false;        
        
        var nameField = component.find("oppclosedate");
        var nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Close Date"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
        
         nameField = component.find("oppname");
         nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Opportunity name"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
        
        
         nameField = component.find("oppstage");
         nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Stage"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
        
        
        
        
        
         nameField = component.find("oppaccname");
         nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Account Name"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
        
         nameField = component.find("oppponumber");
         nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Po Number"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
        
        /*nameField = component.find("oppneedbydate");
        nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Select Date"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }*/
        
         nameField = component.find("oppshipto");
         nameValue = nameField.get("v.value");
        
        if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
            nameField.set("v.errors", [{message:"Enter Ship To Name"}]);
            isError = true;
        }         
        else {
            nameField.set("v.errors",null);
        }
		
		if(!isError){
			helper.saveOpportunity(component,component.find("oppstage").get("v.value"));
			helper.hidePopupHelper(component, 'newmodaldialog', 'slds-fade-in-');
			helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
		}
		
    },
    onAccountChange : function(component, event, helper) {
        helper.getShipToAccount(component);
    },
	goToHome : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
			urlEvent.setParams({
			"url": '/'
		});
		urlEvent.fire();
    },
    onRemoveShipProduct : function(component, event, helper) {
        //alert(event.getSource().get("v.name"));
        helper.removeShipToItem(component,event.getSource().get("v.name"));
    },
    sendOrderRequest : function(component, event, helper) {  
        var oppobj = component.get("v.dval");
		var isError = false;
        
			var nameField;
			var nameValue;
			/*var nameField = component.find("productcategorylist2");
			var nameValue = nameField.get("v.value");

			if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
				nameField.set("v.errors", [{message:"Select ShipTo"}]);
				isError = true;
			}         
			else {
				nameField.set("v.errors",null);
			}
			var nameField = component.find("productcategorylist");
			var nameValue = nameField.get("v.value");

			if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
				nameField.set("v.errors", [{message:"Select Account"}]);
				isError = true;
			}         
			else {
				nameField.set("v.errors",null);
			}*/
			
			nameField = component.find("oppnonumber1");
			nameValue = nameField.get("v.value");

			if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
				nameField.set("v.errors", [{message:"Enter a PO Number"}]);
				isError = true;
			}         
			else {
				nameField.set("v.errors",null);
			}
			
			nameField = component.find("oppneedbydate1");
			nameValue = nameField.get("v.value");

			if($A.util.isEmpty(nameValue) || $A.util.isUndefined(nameValue)){
				nameField.set("v.errors", [{message:"Enter a valid Date"}]);
				isError = true;
			}         
			else {
				/*var today = new Date();
				var cdate = new Date(nameValue);
				
				var sDate = new Date(today.getFullYear(), today.getMonth(), today.getDate());
				var uDate = new Date(cdate.getFullYear(), cdate.getMonth(), cdate.getDate());              
				
				alert(sDate+'---'+uDate);
				if(sDate > uDate){
					nameField.set("v.errors", [{message:"please enter more than today date only"}]);
					isError = true;
				}
				else{*/
					nameField.set("v.errors",null);
				//}
			}
        
        	if(oppobj.lstShipLine.length == 0){
				
            	isError = true;
             	component.find('selectedproductlbl').set("v.value","Add at least one product");                
            }else {
				component.find('selectedproductlbl').set("v.value","");  
			}
        
			
			if(!isError){
				helper.getNewOpportunity(component);
				helper.showPopupHelper(component, 'newmodaldialog', 'slds-fade-in-');
				helper.showPopupHelper(component,'backdrop','slds-backdrop--');
			}
		
    },
    onSaveOrderOnce : function(component, event, helper) {  
        helper.SaveOrderOnceProduct(component);         
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--'); 
    },
    onMaterialSearch : function(component, event, helper) {  
        if (event.keyCode === 13) {
            helper.findProductEntry(component,event);
        }
    },
    onFindProduct : function(component, event, helper) {   
		helper.findProductEntry(component,event);        
    },
    showPopUp : function(component, event, helper) {
        helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.showPopupHelper(component,'backdrop','slds-backdrop--');
        //helper.getOppLineItems(component);
    },
    hidePopUp : function(component, event, helper) {        
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');        
    },
	newHidePopUp : function(component, event, helper) {        
        helper.hidePopupHelper(component, 'newmodaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');        
    },
	confirmHidePopup : function(component, event, helper) {        
        helper.hidePopupHelper(component, 'confirmHidePopup', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');        
    }
})
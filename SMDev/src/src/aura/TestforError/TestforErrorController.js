({
	handleSaveRecord1 : function(component, event, helper) {
        var name = component.find("customerpoid");
            var nameVal = name.get("v.value");
            if (nameVal == null || nameVal == "" || nameVal == "undefined" || nameVal == "  "){
               //name.showHelpMessageIfInvalid();
                 name.set("v.errors", [{message:"Required field missing1"}]);
				$A.util.addClass(name,'slds-has-error');
              // errfld += ' Account Name';
               // isError = true;
               // alert('test');
            }
           
    },
})
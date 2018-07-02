({
	afterRender : function(component, event, helper) {
        var record = component.get("v.record");
		if(record.et4ae5__ExactTargetForAppExchangeAdmin__c){
            $("." + record.Id + "admin").prop("checked", true);    
        }
        if(record.et4ae5__ExactTargetForAppExchangeUser__c){
            $("." + record.Id + "user").prop("checked", true);    
        }
        // jQuery thats fired when the "Admin" checkbox changed
        $("." + record.Id + "admin").change(function() {
            var adminCheckbox = $(this).is(":checked");
            var userCheckbox = $("." + record.Id + "user").is(":checked");
            var updateEvent = component.getEvent("UpdateRecord");
            // Check to see if the changes to the check boxes are the same as the original values of the User record
            if(adminCheckbox === record.et4ae5__ExactTargetForAppExchangeAdmin__c && userCheckbox === record.et4ae5__ExactTargetForAppExchangeUser__c){
                // If the values are the same, remove the record from the "updaterecords" list in the ListViewPlus component
				updateEvent.setParams({
                    "action": "remove",
                    "record": record 
                }).fire();            	    
            }else{
                // If the values are different, add the record to the "updaterecords" list in the ListViewPlus component
                record.et4ae5__ExactTargetForAppExchangeAdmin__c = adminCheckbox;
                record.et4ae5__ExactTargetForAppExchangeUser__c = userCheckbox;
                updateEvent.setParams({
                    "action": "add",
                    "record": record 
                }).fire();
            }
        });
     	// jQuery thats fired when the "User" checkbox changed
        $("." + record.Id + "user").change(function() {
        	var adminCheckbox = $("." + record.Id + "admin").is(":checked");
            var userCheckbox = $(this).is(":checked");
            var updateEvent = component.getEvent("UpdateRecord");
			if(adminCheckbox === record.et4ae5__ExactTargetForAppExchangeAdmin__c && userCheckbox === record.et4ae5__ExactTargetForAppExchangeUser__c){
            	updateEvent.setParams({
                    "action": "remove",
                    "record": record 
                }).fire();  
            }else{
                record.et4ae5__ExactTargetForAppExchangeAdmin__c = adminCheckbox;
                record.et4ae5__ExactTargetForAppExchangeUser__c = userCheckbox;                
                updateEvent.setParams({
                    "action": "add",
                    "record": record 
                }).fire();
            }
    	});
    }
})
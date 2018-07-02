({
	afterRender : function(component, event, helper) {
        var record = component.get("v.record");
        if(record.et4ae5__Enabled__c){
            $("." + record.Id).prop("checked", true);    
        }  
        $("." + record.Id).change(function() {
            if(record.et4ae5__Enabled__c !== $(this).is(":checked")){
                record.et4ae5__Enabled__c = $(this).is(":checked");
            	var updateEvent = component.getEvent("UpdateRecord");
                updateEvent.setParams({
                    "action": "add",
                    "record": record 
                }).fire();
            }else{
				var updateEvent = component.getEvent("UpdateRecord");
                updateEvent.setParams({
                    "action": "remove",
                    "record": record 
                }).fire();                
            }
    	});		      
    }
})
({
	preUpdateProcess : function(component) {
		var table = $('#mainTable').dataTable();
        var rows = table.fnGetNodes();
        var checked = false;
   		for(var i = 0; i < rows.length; i++){
            if($(rows[i]).find('input[type="checkbox"]:checked').length > 0){
       			return true; 	
            } 
        }
        var saveErrorTitleLabel = component.get("v.saveErrorTitleLabel");
        var saveErrorLabel = component.get("v.saveErrorLabel");
        var cmpMessageEvent = component.getEvent("BCMessage");
        cmpMessageEvent.setParams({
            "messageTitle" : saveErrorTitleLabel,
            "errorMessage" : saveErrorLabel
        });
        cmpMessageEvent.fire();
        return false;
    }
})
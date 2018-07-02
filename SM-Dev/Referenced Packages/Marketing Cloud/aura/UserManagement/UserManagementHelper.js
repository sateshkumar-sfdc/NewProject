({
    // Method is called by ListViewPlusHelper (in the "lvp_updateRecords" method). 
    // This overwrites the "preUpdateProcess" method in ListViewPlusHelper.
    preUpdateProcess : function(component) {
		var table = $('#mainTable').dataTable();
        var rows = table.fnGetNodes();
        var checked = false;
   		for(var i = 0; i < rows.length; i++){
            if($(rows[i]).find("#admin").is(":checked")){
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
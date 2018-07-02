({
    doInit : function(component, event, helper) {
		var tableHeaderLabels = component.get("v.tableHeaderLabels");      
		var tableHeaders = tableHeaderLabels.split(",");
 		component.set("v.tableHeaders", tableHeaders);   
        var updateButtonLabel = component.get("v.updateButtonLabel");
        var updateButton = component.find("updateButton");
        updateButton.set("v.label", updateButtonLabel);
        var cancelButtonLabel = component.get("v.cancelButtonLabel");
        var cancelButton = component.find("cancelButton");
        cancelButton.set("v.label", cancelButtonLabel);
 	},
	
    afterScriptsLoaded : function (component, event, helper) {
        $('#tableDiv').hide();
        component.set("v.initialLoadFinished", true);
    },
    
    doneRendering: function(component, event, helper) {
        if(!component.get("v.initialLoadFinished"))
            return;        
        var tableBuilt = component.get("v.tableBuilt");
        var jqueryDataTableBuilt = component.get("v.jqueryDataTableBuilt");
        if(!tableBuilt){ 
            if($("#mainTable").length){
				component.set("v.tableBuilt", true);
            }
        }else{
            if(!jqueryDataTableBuilt){ 
                //var infoLabel = component.get("v.infoLabel");
                var entriesPerPageLabel = component.get("v.entriesPerPageLabelPrefix") + " _MENU_ " + component.get("v.entriesPerPageLabelSuffix");
                var filteredLabel = component.get("v.filteredLabelPrefix") + " _MAX_ " + component.get("v.filteredLabelSuffix");
                var paginatePreviousLabel = component.get("v.paginatePreviousLabel");
                var paginateNextLabel = component.get("v.paginateNextLabel");
                var noDataLabel = component.get("v.noDataLabel");
                var noDataMessage = component.get("v.noDataMessage");
                var noDataFilterMessage = component.get("v.noDataFilterMessage"); 
                try{
                    var table = $("#mainTable").DataTable({
                        "bSort": false,  
                        "bProcessing": true,
                        "oLanguage": {
                            //"sInfo": infoLabel,
                            "sInfoEmpty": noDataLabel,
                            "sZeroRecords": noDataFilterMessage,
                            "sEmptyTable": noDataMessage,
                            "sLengthMenu": entriesPerPageLabel,
                            "sInfoFiltered": filteredLabel,
                            "oPaginate": {
                                "sPrevious": paginatePreviousLabel,
                                "sNext": paginateNextLabel
                            }
                        }
                    });
                }catch(exp){
                   // bubble up to base component 
                }
                $('#selectAllCheckbox').click(function(e){
                    var rows = table.rows({ 'search': 'applied' }).nodes();
                    $('input[type="checkbox"]', rows).prop('checked', this.checked).change();
                });        
                $('#searchText').keyup(function(){
                    table.search($(this).val()).draw();
                });
                $('#buildTableDiv').hide();
                $('#tableDiv').show();
                component.set("v.jqueryDataTableBuilt", true);
            }
        }        
    },

    updateEvent : function(component, event, helper) {
        var updatedRecord = event.getParam("record");
        var updatedRecordId = updatedRecord.Id;
        var action = event.getParam("action");
        var updatedRecords = component.get("v.updatedRecords");
        var foundRecords = $.grep(updatedRecords, function(e){ 
            return e.Id === updatedRecordId; 
        });
        if(action == "add"){
            if(foundRecords.length == 0) { 
            	updatedRecords.push(updatedRecord);
			}else{
				var removedUpdatedRecordList = updatedRecords.filter(function (e) {
					return e.Id !== updatedRecordId;
				});
  				removedUpdatedRecordList.push(updatedRecord);
                component.set("v.updatedRecords", removedUpdatedRecordList);            
            }
        }
        if(action == "remove"){
			if(foundRecords.length == 0) {
				var removedUpdatedRecordList = updatedRecords.filter(function (e) {
					return e.Id !== updatedRecordId;
				});
  				component.set("v.updatedRecords", removedUpdatedRecordList);            
            }
        }
        event.stopPropagation();  
    },
    
    cancel : function(component, event, helper) {
        var returnPage = component.get("v.returnPage");
		top.window.location.href = returnPage;        
    },
    
    update : function(component, event, helper) {
		helper.lvp_updateRecords(component, helper);        
    }
})
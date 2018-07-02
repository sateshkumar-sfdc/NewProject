({  
    doInit : function(component, event, helper) {
     	var json = component.get("v.step_json");

        if(json  === null || json === "undefined") {
            component.set("v.step_json",helper.setJSON());
        }
        
        component.set("v.page", 1);
    },
	setupModal : function (component, event, helper) {
        var options = {
    		 backdrop : "static"
             //keyboard: false
		}   
        $('#stepModal').on('show.bs.modal', helper.centralize);      
        $('#stepModal').modal(options);
        if(!component.get("v.dynamicallyCreated"))
        	$(".modal-backdrop.fade.in").hide();
        
        $(".modal-open").css("overflow","auto");
         
    
        $(window).on('resize', function() {
            $('#stepModal:visible').each(helper.centralize);
        });
        
        $('.modal').modal('handleUpdate');

	}, move : function(component, event, helper) {
        var aur_id = event.getSource().getElement().textContent;
       	var entries = component.get("v.step_json").entries;
        var pages = entries.length;
        var val = component.get("v.page");
 
        switch(aur_id) {
            case "Next": 
                component.set("v.cont", entries[val].body);
                component.set("v.head", entries[val].title);
                val++;
                if(val === 2 && val === entries.length) {
                    $A.util.removeClass(component.find("prev_btn"), "hide");
                    $A.util.addClass(component.find("next_btn"), "hide");
            		$A.util.removeClass(component.find("done_btn"), "hide");
                } else if(val === entries.length) {
                    $A.util.addClass(component.find("next_btn"), "hide");
            		$A.util.removeClass(component.find("done_btn"), "hide");
                } else if (val - 1 === 1) {
                    $A.util.removeClass(component.find("prev_btn"), "hide");
                }
            	break;
            case "Previous": 
                val--;
                component.set("v.cont", entries[val - 1].body);
                component.set("v.head", entries[val - 1].title);
                if(val === 1) {
                    $A.util.addClass(component.find("prev_btn"), "hide");
                } 
                if(val + 1 === entries.length) {
                    $A.util.removeClass(component.find("next_btn"), "hide");
            		$A.util.addClass(component.find("done_btn"), "hide");
                }
            	break;
            case "Done":
                $('#stepModal').modal('toggle');
                break;
        }
        component.set("v.page", val);
    },
})
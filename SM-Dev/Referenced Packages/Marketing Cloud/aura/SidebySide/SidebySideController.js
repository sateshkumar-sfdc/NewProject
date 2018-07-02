({
	setTextArea : function(component, event, helper) {
		var elements = document.getElementsByClassName("active");
        if(elements.length > 0) {
            elements[0].className = "list-group-item";
        }
        target = event.getSource();
        var items = component.get("v.items");
        var optTextArea = component.find("optTextArea");
        optTextArea.set("v.value", items[target.get("v.label")]);        
        target.set("v.class", "");
        target.set("v.class", "list-group-item active");
    }
})
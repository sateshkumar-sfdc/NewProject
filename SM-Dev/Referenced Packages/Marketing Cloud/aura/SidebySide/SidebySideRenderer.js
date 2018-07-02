({
    afterRender : function(component, event, helper) {
        try{
            this.superAfterRender();
            var values = component.get("v.json");
            var entries = values.entries;
            var labels = [];
            var items = {};
            entries.forEach( function (entry) {
                labels.push(entry.label);
                items[entry.label] = entry.content;
            });
            if(labels.length > 0){
                var optTextArea = component.find("optTextArea");
                optTextArea.set("v.value", items[labels[0]]);
            }
            component.set("v.labels", labels);
            component.set("v.items", items);
        }catch(e){
            throw new Error($A.get("$Label.et4ae5.sBsCmpErr") + e.message);
        }
    }
})
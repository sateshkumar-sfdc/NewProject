({
	addInQueue : function addInQueue(component, event, helper) {
        var actionObject;
        var actionList;
        var actionEnqueued;
        var params = event.getParams();
        if(params && params.actionObject){
            actionObject = params.actionObject;
            actionList = component.get('v.actionList');
            actionEnqueued = component.get('v.actionEnqueued');
            if(!actionEnqueued){
                $A.enqueueAction(actionObject);
                component.set('v.actionEnqueued',true);
            } else if(actionList && actionList.length ){
                actionList.push(actionObject);
            } else {
                actionList.push(actionObject);
            }
            component.set('v.actionList',actionList);
        }
	},
    removeFromQueue : function removeFromQueue(component, event, helper) {
		var actionObject;
        var actionList;
        var actionEnqueued;
        actionList = component.get('v.actionList');
        actionEnqueued = component.set('v.actionEnqueued');
        if(actionList && actionList.length ){
            if(!actionEnqueued){
            	actionObject = actionList.shift();
                $A.enqueueAction(actionObject);
                component.set('v.actionEnqueued',true);
                component.set('v.actionList',actionList);   
            }
        } else {
            component.set('v.actionEnqueued',false);
        }
	}
})
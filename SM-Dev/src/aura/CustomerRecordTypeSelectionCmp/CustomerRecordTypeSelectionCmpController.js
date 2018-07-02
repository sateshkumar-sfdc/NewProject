({
    doInit: function(component, event, helper) {
        component.set("v.isOpen",true);
        
    },
    /* On the component Load this function call the apex class method, 
    * which is return the list of RecordTypes of object 
    * and set it to the lstOfRecordType attribute to display record Type values
    * on ui:inputSelect component. */
    /* In this "createRecord" function, first we have call apex class method 
    * and pass the selected RecordType values[label] and this "getRecTypeId"
    * apex method return the selected recordType ID.
    * When RecordType ID comes, we have call  "e.force:createRecord"
    * event and pass object API Name and 
    * set the record type ID in recordTypeId parameter. and fire this event
    * if response state is not equal = "SUCCESS" then display message on various situations.
    */
    createRecord: function(component, event, helper) {
        //component.set("v.Spinner",true);
        var recordTypeId = component.find("selectid").get('v.value');
        console.log('test'+recordTypeId);		
        //component.set("v.isOpen",false);
        //alert('rec1'+recordTypeId);
        helper.openWindow(component, event, helper);
    },
    
    closeModal : function(component){
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Account"
        });
        homeEvt.fire();
    } 
})
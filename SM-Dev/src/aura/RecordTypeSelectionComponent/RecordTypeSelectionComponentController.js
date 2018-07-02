({
	
 
   /* On the component Load this function call the apex class method, 
    * which is return the list of RecordTypes of object 
    * and set it to the lstOfRecordType attribute to display record Type values
    * on ui:inputSelect component. */
 
   fetchListOfRecordTypes: function(component, event, helper) {
      component.set("v.isOpen",true);
       var action = component.get("c.fetchRecordTypeValues");
       action.setParams({  "object_name" : "Account"});
      action.setCallback(this, function(response) {
          console.log(response.getReturnValue().length);
          console.log(response.getReturnValue());
          var recTypes = response.getReturnValue();
          var reqRecordTypes = [];
          var i = 0;
          for(i = 0; i<recTypes.length; i++)
              {
				 console.log(recTypes[i]);
                 if(recTypes[i].Name !== 'Ship to' ) 
                     reqRecordTypes.push(recTypes[i]);
              }
          
          console.log(reqRecordTypes);
         component.set("v.lstOfRecordType", reqRecordTypes);
      });
      $A.enqueueAction(action);
   },
 
   /* In this "createRecord" function, first we have call apex class method 
    * and pass the selected RecordType values[label] and this "getRecTypeId"
    * apex method return the selected recordType ID.
    * When RecordType ID comes, we have call  "e.force:createRecord"
    * event and pass object API Name and 
    * set the record type ID in recordTypeId parameter. and fire this event
    * if response state is not equal = "SUCCESS" then display message on various situations.
    */
   createRecord: function(component, event, helper) {
      
 	component.set("v.Spinner",true);
     // var action = component.get("c.getRecTypeId");
      var recordTypeId = component.find("selectid");
       var i = 0;
       var recordTypeLabel;
          for( i = 0; i<recordTypeId.length; i++)
              {
                  if(recordTypeId[i].get('v.value')){
				 console.log(recordTypeId[i].get('v.text'));
                 recordTypeLabel = recordTypeId[i].get('v.text');
                 }
              }
     // var recordTypeLabel = component.get('v.selectedRecordType');
       console.log('test'+recordTypeLabel);
    //  action.setParams({
      //   "recordTypeLabel": recordTypeLabel
     // });
     // action.setCallback(this, function(response) {
        // var state = response.getState();
         //if (state === "SUCCESS") {
             component.set("v.isOpen",false);
             alert('rec1'+recordTypeLabel);
             if(recordTypeLabel === '012i0000000yQvFAAU')
             {
                 alert('rec2'+recordTypeLabel);
				 helper.openWindow(component, event, helper);
             }
             else{
                 console.log('else');
            var createRecordEvent = $A.get("e.force:createRecord");
           // var RecTypeID  = response.getReturnValue();
            createRecordEvent.setParams({
               "entityApiName": 'Account',
               "recordTypeId": recordTypeLabel
            });
            createRecordEvent.fire();
			}             
       /*  } else if (state == "INCOMPLETE") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Oops!",
               "message": "No Internet Connection"
            });
            toastEvent.fire();
             
         } else if (state == "ERROR") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Error!",
               "message": "Please contact your administrator"
            });
            toastEvent.fire();
     //    }
   //   });
     // $A.enqueueAction(action);*/
   },
    onChangeRadio : function(component, event, helper) {
		var value = event.getSource().get("v.value");
        console.log('value'+value);
        component.set(value, true);
	},
    closeModal : function(component){
        try{
        component.destroy();
        }catch(Err){
            }
    }
 
    
 
})
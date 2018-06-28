({
	checkingvalid : function(component, event, helper){
        var isValid = true;
        var field1 = component.find('mStreet');
        var field1Value = field1.get('v.value');
      //  var aStreet = component.find("mStreet").get("v.value");
     
       
        var aCity = component.find("mCity").get("v.value");
        var aState = component.find("mState").get("v.value");
        var aZIPCode = component.find("mZIPCode").get("v.value");
        
        
        if ((field1Value == null) || (field1Value == "") || (field1Value == " ")){
            field1.set("v.errors", [{message:"field is missing"}]);
                isValid = false;
            //alert('test');
               // this.showToast("",'Error', $A.get("$Label.c.ContactFirstNameValidation"), "Error"); 
           }
         if ((aCity == null) || (aCity == "") || (aCity	 == " ")){
             
                isValid = false;
            // alert("testfield");
               // this.showToast("",'Error', $A.get("$Label.c.ContactFirstNameValidation"), "Error"); 
           }
         if ((aState == null) || (aState == "") || (aState == " ")){
                isValid = false;
            // alert("testfield");
               // this.showToast("",'Error', $A.get("$Label.c.ContactFirstNameValidation"), "Error"); 
           }
         if ((aZIPCode == null) || (aZIPCode == "") || (aZIPCode == " ")){
                isValid = false;
            // alert("testfield");
               // this.showToast("",'Error', $A.get("$Label.c.ContactFirstNameValidation"), "Error"); 
           }
        
             return isValid;  
    },
    
    createRecord : function (component, recId, helper) {
    var navEvt = $A.get("e.force:navigateToSObject");
    navEvt.setParams({
      "recordId": recId,
      "slideDevName": "related"
    });
    navEvt.fire();
  this.showToast(component,"Success!","successfull","success");
},
    showToast : function(component,title,message,type){
        try{
          var toastEvent = $A.get("e.force:showToast");
         toastEvent.setParams({
            "title": title,
            "message":message ,
            "type" : type
         });
          toastEvent.fire();
          }catch(Err){
             console.log(Err);
            }
    }
    
})
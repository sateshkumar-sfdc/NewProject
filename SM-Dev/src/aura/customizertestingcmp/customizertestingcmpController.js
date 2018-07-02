({
    
  sendToVF : function(component, event, helper) {
      
    
      /* var productkey = event.getSource().get("v.name");
        var modalBody;
         $A.createComponent(
                "c:Customizer",{
                    "UPK": productkey
                },
           function(content, status) {
               console.log(status);
               console.log(content);
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Application Confirmation",
                       body: modalBody, 
                       showCloseButton: true,
                       cssClass: "mymodal",
                       closeCallback: function() {
                           alert('You closed the alert!');
                       }
                   })
               }                               
           });
    */
      
      /*//component.set("v.isOpen",true);
 console.log(event.getSource().get("v.name"));
      
      var productkey = event.getSource().get("v.name");
      
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Customizer",
            componentAttributes: {
                  "UPK": productkey,
            }
        });
        evt.fire();
    */
      
 /*  var productkey = event.getSource().get("v.name");  
    var modalBody;
    
    $A.createComponents([
        ["c:Customizer",{"UPK": productkey}],
       
    ],
    function(components, status){
        if (status === "SUCCESS") {
            modalBody = components[0];
           
            component.find('overlayLib').showCustomModal({
               header: "Application Confirmation",
               body: modalBody, 
               footer: 'hai',
               showCloseButton: true,
               cssClass: "my-modal,my-custom-class,my-other-class",
               closeCallback: function() {
                   alert('You closed the alert!');
               }
           })
        }
    }
   );*/	

      
     /*  var productkey = event.getSource().get("v.name");
      console.log('test1');
      $A.createComponent(
                "c:Customizer",{
                    "UPK": productkey
                }, 
               
                function(newcomponent){
                    if (component.isValid()) {
                        var body = component.get("v.body");
                        body.push(newcomponent);
                        component.set("v.body", body);             
                    }
                }            
            );*/
      
       /* var message = event.getSource().get("v.name");
      console.log(message);
       var vfOrigin = "https://" + component.get("v.vfHost");
      var vfWindow = component.find("vfFrame1").getElement().contentWindow;
      console.log(vfWindow);
       vfWindow.postMessage(message, '*');*/
    },
    
   handleComponentEventFired : function(component, event, helper){
        console.log("componeteventdata");
        console.log(event.getParam("customizerdata"));
        component.set("v.customizerdataList",event.getParam("customizerdata"));
        var customjson1 = JSON.stringify(event.getParam("customizerdata"));
        console.log('hai');
        console.log(customjson1.replace("\\",""));
        var customizerJson = (event.getParam("customizerdata").toString());
       
        var action = component.get("c.getCustomLineItems");
        action.setParams({ customizerJson : customjson1 });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
            }
            
            });

        $A.enqueueAction(action);


        
    }
})
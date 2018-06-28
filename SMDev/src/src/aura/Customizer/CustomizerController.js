({
    doInit : function(component,event){
      window.addEventListener("message", function(event) {
            
            console.log('show json');
            console.log(event.data);
          component.set("v.jsonobj",(event.data));
        } , false); 
        
        
        console.log(component.get("v.jsonobj"));
    },
    
    
    saveon : function(component,event){
        
        
        console.log('test123');
       console.log(component.get("v.jsonobj"));
        var customizerdata = component.get("v.jsonobj");
       var cmpeve = component.getEvent("cmpEventtocaptureJsondata");

        cmpeve.setParams({ 
            "customizerdata" : customizerdata ,
            "ItemId" : component.get("v.itemID")
        
        });
        cmpeve.fire();
         component.destroy();
        
    },
      
// document.body.insertBefore(newDiv, currentDiv);
     /*  console.log(message);
          var vfWindow = component.find("vfFrame").getElement().contentWindow;
            console.log(vfWindow);
            vfWindow.postMessage(message, '*');*/
     
    
    doaction : function(component,event){
        console.log('test');
    var message = component.get("v.UPK");
     var vfWindow = component.find("vfFrame").getElement().contentWindow;
            console.log(vfWindow);	
            vfWindow.postMessage(message, '*');
        
   
    },	
    
    
    closemodal : function(component,event){
          component.destroy();
}
})
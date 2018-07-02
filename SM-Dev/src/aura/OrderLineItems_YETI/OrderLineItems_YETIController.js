({

    handleEvent: function (cmp, event, helper) {
        var idp = event.getParam("OrdID");
        console.log('idp'+ idp);
        helper.getLineData(cmp,idp);
    }
    
    /* handleApplicationEvent : function(cmp, event, helper) {
        
      var lineobj = event.getParam("lineitems");
       console.log('appevent-->' + lineobj.Name);
       helper.getData(cmp,lineobj);
       
         console.log(cmp.find("carsec"));
         
        // set the handler attributes based on event data
       // cmp.set("v.lineobject", lineobj);
    
    console.log('appevent-->' + lineobj.Name);
    
        
    },*/
    
    
})
({
	
    doInit : function(component, event, helper) {
        try{
            var artID = component.get("v.ArtID");
            helper.getResponse(component, artID,event);
          }catch(Err){
             helper.showToast(component,"Error!",$A.get("$Label.c.Art"),"error");
            }
    },
   
    imageError: function(component,event,helper){
        try{
            event.target.src= $A.get('$Resource.NoImage');
        }catch(Err){
          helper.showToast(component,"Error!",$A.get("$Label.c.Art"),"error");
        }
    },
    
         
    onClick : function(component, event, helper){
        try{
          var myLabel = event.currentTarget.getAttribute("src");
          helper.navigate(component,event,myLabel);
        }
        catch(Err){
            helper.showToast(component,"Error!",$A.get("$Label.c.Art"),"error");
            }
    },
    
    closemodal : function(component){
        try{
        component.destroy();
        }catch(Err){
             helper.showToast(component,"Error!",$A.get("$Label.c.Art"),"error");
            }
    }
   	
 })
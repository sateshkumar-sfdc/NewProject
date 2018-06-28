({
	loadScript : function(component) {
        var self = this;
        try{    
	        var head = document.getElementsByTagName('head')[0];
             	var script = document.createElement('script');
            	script.src = "/resource/ZPhoneFormatter";
            	script.type = "text/javascript";
            	script.key = '/resource/ZPhoneFormatter';
            	script.helper = this;
            	script.id = "scriptPF_" +  component.getGlobalId();
            	console.log('Phone is',component.get("v.phoneNumber"));
            	
            	script.onload = function (){
                    self.triggerScriptLoadedEvent(component);
            	};
                
            	head.appendChild(script);
              
         }catch(e){
                console.log('Exception is', e);
         }
		
	},
    
    triggerScriptLoadedEvent:function(component){
        var evt = $A.get("e.c:ZPhoneFormatterLoadedEvent").fire();
    },
    
    formatPhoneNumber:function(component,event){
        var self = this;
      	var phoneNumber = component.get("v.phoneNumber");
      	var country = component.get("v.country");  
      	phoneNumber = formatE164(country,phoneNumber);
      	var formattedPhoneNumber = formatInternational(country,phoneNumber); 
      	component.set("v.phoneNumber",phoneNumber);
      	component.set("v.phoneNumberToDisplay",formattedPhoneNumber);
    },
    
    setPhoneService:function(component){
        var phoneService = component.get("v.phoneService");
        var phoneNumber = component.get("v.phoneNumber");
        var phoneNumberToDisplay = component.get("v.phoneNumberToDisplay");
        if(phoneNumberToDisplay == '' || phoneNumberToDisplay == undefined ){
            phoneNumberToDisplay = phoneNumber;
        }
        var div = component.find("rootDiv").getElement();
        //Skype
        if(phoneService=='Skype'){
       		div.innerHTML = '<a href="' + 'skype:'+ phoneNumber+'?call">' + phoneNumberToDisplay + '</a>' ; 
        }
        //Hangout
        if(phoneService=='Hangout'){
            
        }
        
        if(phoneService=='Device'){
          div.innerHTML = '<a href="' + 'tel:'+ phoneNumber+'">' + phoneNumberToDisplay + '</a>' ;   
        }
    },
})
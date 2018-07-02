var geopointe = geopointe || {};

//Customer exposed methods
geopointe.api = {
	closeAction: function(){
		parent.postMessage({messageType: 'gpAction', action: "closeActionWindow"},"*");
	},

	refreshRouteFields: function(){
		parent.postMessage({messageType: 'gpAction', action: "refreshRouteStopFields"},"*");
	},

	updateMarker: function(opts){
		parent.postMessage({messageType: 'gpAction', action: "refreshMarkerAfterAction", args: opts},"*");
	},

	setActionHeight: function(opts){
		parent.postMessage({messageType: 'gpAction', action: "setActionHeight", args: opts},"*");
	},

	//Proxy to the parent sforce object for SF1 navigation
	sforce:{
		one:{
			navigateToSObject: function(recordId,view){
				//Listener for post message is in this file below, this file is included in parent page and iframes
				try{
					parent.postMessage({messageType: 'gpAction', action: "one.navigateToSObject", recordId: recordId, view: view},"*");
				}catch(e){
					geopointe.api._handleException(e);
				}
			},
			navigateToURL: function(url,isRedirect){
				//Listener for post message is in this file below, this file is included in parent page and iframes
				try{
					parent.postMessage({messageType: 'gpAction', action: "one.navigateToURL", url: url, isRedirect: isRedirect},"*");
				}catch(e){
					geopointe.api._handleException(e);
				}
			}
		}
	},

	_handleException: function(e){
		var msg = e.message;
		alert(msg);
	}
}

//Geopointe listeners on the parent page
window.addEventListener("message", function(event){
	if(event.data.messageType == 'gpAction'){

		if(event.data.action == 'setActionHeight'){
			if(typeof gp_setActionHeight != "undefined") gp_setActionHeight(event.data.args);

		}else if(event.data.action == 'closeActionWindow'){
			if(typeof gp_closeActionWindow != "undefined") gp_closeActionWindow();

		}else if(event.data.action == 'refreshRouteStopFields'){
			gp_refreshRouteStopFields();

		}else if(event.data.action == 'refreshMarkerAfterAction'){
			gp_refreshMarkerAfterAction(event.data.args);

		}else if(event.data.action == 'one.navigateToSObject'){
			
			//iOS work around for this issue https://success.salesforce.com/issues_view?id=a1p300000008ZjNAAU
			jQuery('.scrollableContent').removeClass('scrollableContentTouch');
			setTimeout(function(){
				jQuery('.scrollableContent').addClass('scrollableContentTouch');
			},5000);

			if(event.data.recordId && event.data.view){
				sforce.one.navigateToSObject(event.data.recordId,event.data.view);
			}else{
				sforce.one.navigateToSObject(event.data.recordId);
			}

		}else if(event.data.action == 'one.navigateToURL'){
			if(event.data.url && event.data.isRedirect){
				sforce.one.navigateToURL(event.data.url,event.data.isRedirect);
			}else{
				sforce.one.navigateToURL(event.data.url);
			}
		}
	}
}, false);
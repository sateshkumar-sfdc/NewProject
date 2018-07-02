var gp_map; // holds the Map object
var gp_bestFitMaxZoom; // max zoom for bestFit. global var b/c we need it in a listener
var gp_forceBestFitMaxZoom = false; // whether the listener should use bestFitMaxZoom or not
var googAutoCompleteService = new google.maps.places.AutocompleteService();
var placesService;

// For markers
var gp_markers; // all the map markers as an associative array
var gp_masterMarker; // The Master Record's Marker - GMarker
var gp_searchMarker;
var gp_bounds; // holds the LatLngBounds object so we can center and zoom properly - GLatLngBounds
var gp_infoWindow; // a single info window object used on the map
var gp_tooltip; // a floating tooltip for the markers
var gp_cirOverlays; // all the Circle overlay as an associative array
var gp_kmlOverlays; // all the Circle overlay as an associative array
var gp_layers = {}; // object that contains url as key, and google layer object as value
var gp_sameLocationMarkers = [];

// Layers
var gp_traffic;
var gp_trafficState = false;

// For Drawing
var gp_drawingManager; // master drawing manager object
var gp_shapeDragInProgress = false;

//For Heatmaps
var gp_heatmaps = {}; //Object that contains heatmaps with key as the POIC unique Id

var gp_remapHidden = [];
var gp_dragMarker;

//Info about the jQuery Tabs
var gp_JQTabs = {
	"mapDataSets": 0,
	"search": 1,
	"layers": 2,
	"manualEntry": 3,
	"currentRoute": 4,
	"mySettings": 5
}

var GP_POLYLINE_STROKE = 5;

function __MAPPING_STUFF__(){}
// re-init the global objects
function gp_initJSObjects(){
	if (typeof(gp_markers) == 'undefined'){gp_markers = new Object();}
	if (typeof(gp_bounds) == 'undefined'){gp_bounds = new google.maps.LatLngBounds();}
	if (typeof(gp_infoWindow) == 'undefined'){
		gp_infoWindow = new google.maps.InfoWindow({ maxWidth: 550, disableAutoPan: true });

		gp_infoWindow.originalOpen = gp_infoWindow.open;
		gp_infoWindow.open = function(){
			if(gp_mapMode === 'search' || gp_mapMode === 'thematicEdit' || !gp_mapMode) gp_infoWindow.originalOpen.apply(gp_infoWindow, arguments);
			var gmiwParent = jQuery('.gm-style-iw').parent();	// suppress flicker when repositioning infoWindow
			gmiwParent.css('visibility', 'hidden');
		}

		// Close edit window when infowindow closes
		gp_infoWindow.addListener('closeclick', function(){
			gp_inlineEdit.close();
		});

		// Close edit window when infowindow moves
		gp_infoWindow.addListener('position_changed', function(){
			gp_inlineEdit.close();
		});

		google.maps.event.addListener(gp_infoWindow, 'domready', function() {
			jQuery('#gp_demoTabs').tabs();
			jQuery('#gp_demoTabs').show();

			//Find the shapeColor input field
			var $colorInput = jQuery(".gp_shapeColorInput");

			var reposVertOffset = 56;	// default for marker with label
			
			if($colorInput.length > 0){ //Only proceed if infowindow has a color input for a shape
				
				//Get the shape object from the polygonObjects object so we can default the
				var shapeId = $colorInput.attr('data-shapeId');
				var polygon = polygonObjects[shapeId];

				//Set starting color value and opacity on the input field
				$colorInput.val(('polyline' == polygon.gpProperties.gpType)? polygon.strokeColor : polygon.fillColor);
				$colorInput.attr('data-opacity', ('polyline' == polygon.gpProperties.gpType)? polygon.strokeOpacity : polygon.fillOpacity);

				//Apply original colors, they can change when a users hovers
				if(polygon.gpProperties.originalOpacity){
					$colorInput.attr('data-opacity',polygon.gpProperties.originalOpacity);
				}
				if(polygon.gpProperties.originalColor){
					$colorInput.val(polygon.gpProperties.originalColor);
				}

				//Create color selector for the selected shape
				jQuery(".gp_shapeColorInput").minicolors({
					inline:true,
					opacity:true,
					theme: 'geopointe',
					change: function(hex, opacity){
						//Get overlay Id
						var overlayId = jQuery(this).attr('data-shapeId');
						var groupLayerId = jQuery(this).attr('data-groupLayerId');

						//If there is a groupLayerId update all the layers with this id
						if(groupLayerId && groupLayerId != 'undefined' && groupLayerId != ''){
							for(key in polygonObjects){
								if(polygonObjects[key].gpProperties.groupLayerId == groupLayerId){
									if ('polyline' == polygonObjects[key].gpProperties.gpType) {
										polygonObjects[key].setOptions({
											strokeColor: hex,
											strokeOpacity: opacity
										});
									}
									else {
										polygonObjects[key].setOptions({
											fillColor: hex,
											fillOpacity: opacity
										});
									}
									polygonObjects[key].gpProperties.originalColor = hex;
									polygonObjects[key].gpProperties.originalOpacity = opacity;
								}
							}

						}else{ //update this single shape
							//Set the color and opacity of the shap on the map
							if ('polyline' == polygonObjects[overlayId].gpProperties.gpType) {
								polygonObjects[overlayId].setOptions({
									strokeColor: hex,
									strokeOpacity: opacity
								});
							}
							else {
								polygonObjects[overlayId].setOptions({
									fillColor: hex,
									fillOpacity: opacity
								});
							}
							polygonObjects[overlayId].gpProperties.originalColor = hex;
							polygonObjects[overlayId].gpProperties.originalOpacity = opacity;
						}
					}
				});

				reposVertOffset = 48;	// just adjust for the height of the popup tail
			}
			// if possible, keep the infoWindow inside the bounds of the map
			var mapBds = gp_map.getBounds();
			var mapCtr = mapBds.getCenter();
			var mapNE = mapBds.getNorthEast();
			var mapEast = (mapNE.lng() - mapCtr.lng()) * 0.5 + mapCtr.lng();

			// try to suss out the various elements of the infoWindow
			var gmiwParent = jQuery('.gm-style-iw').parent();
			var gmiwBkgd = gmiwParent? gmiwParent.children('div:first-child') : null;
			var gmiwArrowShadow = gmiwBkgd? gmiwBkgd.children("div:first-child") : null;
			var gmiwArrow = gmiwBkgd? gmiwBkgd.children("div:nth-child(3)") : null;
			// if we found everything we're looking for, go ahead and slide the infoWindow around
			if (gmiwParent && gmiwBkgd && gmiwArrowShadow && gmiwArrow)
			{
				var hgtPx = gmiwParent.css('height');
				var wdPx = gmiwParent.css('width');
				hgtPx = hgtPx.substring(0, hgtPx.length-2);
				wdPx = wdPx.substring(0, wdPx.length-2);
				var hgt = Number(hgtPx);
				var wd = Number(wdPx);
				var offCtr = ~~(0.4 * wd);

				var xShift = 0;
				var yShift = 0;
				if (gp_infoWindow.position.lng() < mapCtr.lng()) {
					// shift infoWindow right
					xShift = -offCtr;
				}
				else if (gp_infoWindow.position.lng() > mapEast) {
					xShift = offCtr;
				}
				var flip = '';
				var jump = '';
				if (gp_infoWindow.position.lat() > mapCtr.lat()) {
					flip = 'scale(1, -1) translate(' + xShift + 'px, 0px)';
					jump = '3px';
					yShift = hgt + reposVertOffset;	// point down from below the anchor, vs. up from above it
				}
				else {
					flip = 'translate(' + xShift + 'px, 0px)';
					jump = String(hgt-2) + 'px';
				}
				if (xShift || yShift) {
					var transProp = 'translate('+(-xShift)+'px, '+yShift+'px)';
					gmiwParent.css('transform', transProp);
				}
				gmiwArrow.css('transform', flip).css('top', jump);
				gmiwArrowShadow.css('transform', flip).css('top', jump);
			}
			else {
				// if we can't control the infoWindow, then we may have to
				// just pull it toward the center of the map as best we can
				var pulldown = gp_infoWindow.position.lat() - mapCtr.lat();
				var pullover = gp_infoWindow.position.lng() - mapCtr.lng();
				var ctrLat = mapCtr.lat()
				var ctrLng = mapCtr.lng();
				if (pulldown > 0) {
					ctrLat = gp_infoWindow.position.lat();
				}
				if ((mapCtr.lng() + pullover * 2) > mapBds.getNorthEast().lng()
					|| (mapCtr.lng() - pullover * 3) < mapBds.getSouthWest().lng()
				) {
					ctrLng = mapCtr.lng() + pullover * 0.5;
				}
				gp_map.panTo(new google.maps.LatLng(ctrLat, ctrLng));
			}

			// if infoWindow runs out of bounds, move map the minimum to bring it in
			var winTop = gmiwParent.offset()['top'];
			var winHgt = gmiwParent.prop('clientHeight');
			var winBtm = winTop + winHgt;
			var mapDiv = jQuery('#mapDIV');
			var mapTop = mapDiv.offset()['top'];
			var mapHgt = mapDiv.prop('clientHeight');
			var mapBtm = mapTop + mapHgt;
			if (gp_infoWindow.position.lng() > mapEast) {
				mapTop += 32;	// dodge map controls at upper right
			}
			if (winTop < mapTop || winBtm > mapBtm) {
				var overlay = new google.maps.OverlayView();
				overlay.draw = function() {};
				overlay.setMap(gp_map);
				var projection = overlay.getProjection(); 
				var mapCtrPixel = { x: ~~(mapDiv.prop('clientWidth') * 0.5), y: ~~(mapDiv.prop('clientHeight') * 0.5) };
				var panDist = (winBtm > mapBtm && winHgt <= mapHgt)? mapBtm - winBtm : mapTop - winTop;
				var panCtr = projection.fromContainerPixelToLatLng(new google.maps.Point(mapCtrPixel.x, mapCtrPixel.y - panDist));
				gp_map.panTo(panCtr);
			}

			// let repositioned infoWindow show
			gmiwParent.css('visibility', 'visible');
		});
	}
	if (typeof(gp_tooltip) == 'undefined'){
		var ttOptions = {
			content: '',
			boxClass: 'gp_tooltip',
			closeBoxURL: '',
			isHidden: true
		}
		gp_tooltip = new InfoBox(ttOptions); // using the infoBox add-in
	}
	if (typeof(gp_cirOverlays) == 'undefined'){gp_cirOverlays = new Object();}
	if (typeof(gp_kmlOverlays) == 'undefined'){gp_kmlOverlays = new Object();}
}

//Clears the global variables out
function gp_cleanMapObjects(){
	for(var i in gp_markers) {
		gp_markers[i].setMap(null);
	}
	gp_infoWindow.close();
	gp_tooltip.hide();
	for(var i in gp_cirOverlays) {
		gp_cirOverlays[i].setMap(null);
	}
	for(var i in gp_kmlOverlays) {
		gp_kmlOverlays[i].setMap(null);
	}

	//Clear heat maps
	for(var i in gp_heatmaps) {
		gp_heatmaps[i].setMap(null);
	}

	//Remove shape fields
	for(key in polygonObjects){
		
		//Don't remove shapes associated with center pin marker
		if(polygonObjects[key].gpProperties.usageType == 'Shape Field' && gp_centerPOI.recordId && gp_centerPOI.recordId == polygonObjects[key].gpProperties.relatedRecordId){
			//don't remove this shape
		}else if(polygonObjects[key].gpProperties.usageType == 'Shape Field'){
			polygonObjects[key].setMap(null);
			delete polygonObjects[key];
		}
	}
	
	gp_bounds = new google.maps.LatLngBounds();
	gp_markers = new Object();
	gp_cirOverlays = new Object();
	gp_kmlOverlays = new Object()
	
}

// Handles a Map Constructor
function gp_mapConstructor(jsAction){
	
	var thisMC = jsAction.mapConstructor;
	
	// Fix up the thisMC object as needed
	thisMC.startingZoom = 2;
	if (typeof(eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Zoom__c')) != 'undefined' && !jsAction.mapConstructor.centerAddress){
		if (eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Zoom__c') != "") {
			thisMC.startingZoom = eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Zoom__c');
		}
	}
	
	thisMC.startingLat = 12;
	if (typeof(eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Lat__c')) != 'undefined' && !jsAction.mapConstructor.centerAddress){
		if (eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Lat__c') != "") {
			thisMC.startingLat = eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Lat__c');
		}
	}
	
	thisMC.startingLng = -30;
	if (typeof(eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Lng__c')) != 'undefined' && !jsAction.mapConstructor.centerAddress){
		if (eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Lng__c') != "") {
			thisMC.startingLng = eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Starting_Lng__c');
		}
	}
	
	thisMC.width = document.getElementById("mapWrapper").clientWidth;
	if (thisMC.height == "") { thisMC.height = 600;}
	
	if (thisMC.centerLat == null || thisMC.centerLat == ''){
		thisMC.centerLat = thisMC.startingLat;
	}
	
	if (thisMC.centerLng == null || thisMC.centerLng == ''){
		thisMC.centerLng = thisMC.startingLng;
	}
	
	if (thisMC.centerZoom == null || thisMC.centerZoom == ''){
		thisMC.centerZoom = thisMC.startingZoom;
	}
	
	// New Map Object
	if (thisMC.newMap){
		
		gp_map = null;
		document.getElementById('mapDIV').innerHTML = '';
		
		gp_bounds = new google.maps.LatLngBounds();

		// Build list of custom style ids and maps
		var mapStyleIds = [];
		gp_mapStyles.forEach(function(mapStyle){
			var style;
			try {
				style = JSON.parse(mapStyle[nameSpacePrefix + 'Style_JSON__c']);
			} catch(err) {
				console.log(err);
				return;
			}
			mapStyleIds.push(mapStyle.Id);
			mapStyle.map = new google.maps.StyledMapType(style, {name: mapStyle.Name});
		});

		//Determine map type
		var savedMapTypeId = gp_userSettings.settings__c[gp_orgSettings.fieldPrefix + 'Map_Type__c'];
		var googleMapTypeId = google.maps.MapTypeId.ROADMAP;
		if(savedMapTypeId == 'map' || savedMapTypeId == 'OSM' || savedMapTypeId == 'roadmap'){
			googleMapTypeId = google.maps.MapTypeId.ROADMAP;
		}else if(savedMapTypeId == 'terrain'){
			googleMapTypeId = google.maps.MapTypeId.TERRAIN;
		}else if(savedMapTypeId == 'sat' || savedMapTypeId == 'satellite'){
			jQuery('.mapControlTabInner').addClass('mapControlDarkShadow');
			jQuery('.mapControlContent').addClass('mapControlContentDarkShadow');
			showWhiteSettingsHelp();
			googleMapTypeId = google.maps.MapTypeId.SATELLITE;
		}else if(savedMapTypeId == 'hyb' || savedMapTypeId == 'hybrid'){
			jQuery('.mapControlTabInner').addClass('mapControlDarkShadow');
			jQuery('.mapControlContent').addClass('mapControlContentDarkShadow');
			showWhiteSettingsHelp();
			googleMapTypeId = google.maps.MapTypeId.HYBRID;
		}else if(mapStyleIds.some(function(id){return id === savedMapTypeId;})){
			googleMapTypeId = savedMapTypeId;
		}else{
			googleMapTypeId = google.maps.MapTypeId.ROADMAP;
		}

		// Set map initial options
		var useScrollWheelZoom = eval('gp_userSettings.settings__c.' + gp_orgSettings.fieldPrefix + 'Use_Scrollwheel_Zoom__c');
		if(typeof getURLparams().inlineMap != 'undefined'){
			useScrollWheelZoom = false;
		}

		var myOptions = {
			zoom: thisMC.startingZoom,
			center: new google.maps.LatLng(thisMC.startingLat, thisMC.startingLng),
			draggableCursor: 'default',
			gestureHandling: 'greedy',
			mapTypeId: googleMapTypeId,
			mapTypeControlOptions: {
                style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
                position: google.maps.ControlPosition.TOP_RIGHT,
                mapTypeIds: [google.maps.MapTypeId.ROADMAP, google.maps.MapTypeId.SATELLITE, google.maps.MapTypeId.TERRAIN, google.maps.MapTypeId.HYBRID].concat(mapStyleIds)
            },
            panControlOptions: {
            	position: google.maps.ControlPosition.RIGHT_TOP
            },
            zoomControlOptions: {
            	position: google.maps.ControlPosition.RIGHT_TOP
            },
            streetViewControlOptions: {
            	position: google.maps.ControlPosition.RIGHT_TOP
            },
            clickableIcons: false,
            scaleControl: true,
			scrollwheel: useScrollWheelZoom,
			overviewMapControl: true,
			backgroundColor: 'none'
		}
		
		// init the map
		gp_map = new google.maps.Map(document.getElementById("mapDIV"), myOptions);

		//Show the map controls
		jQuery("#mapControlsWrapper").removeClass("mapControlsWrapperInit");
		
		//Remove the splash background
		var initLoad = google.maps.event.addListenerOnce(gp_map, 'idle', function(){
		    jQuery("#mapDIV").removeClass("mapDIVloading");
		    google.maps.event.removeListener(initLoad);
		});

		gp_mapStyles.forEach(function(mapStyle, i){
			gp_map.mapTypes.set(mapStyleIds[i], mapStyle.map);
		});
		// gp_map.setMapTypeId('map_style');

		gp_setTrafficIcon();

		//Init places services
		placesService = new google.maps.places.PlacesService(gp_map);
		
		// OSM Tiles
		gp_map.mapTypes.set("OSM", new google.maps.ImageMapType({
            getTileUrl: function(coord, zoom) {
                return "http://tile.openstreetmap.org/" + zoom + "/" + coord.x + "/" + coord.y + ".png";
            	//return "https://otile1.mqcdn.com/tiles/1.0.0/osm/" + zoom + "/" + coord.x + "/" + coord.y + ".png";
            },
            tileSize: new google.maps.Size(256, 256),
            name: "Open Street Map",
            maxZoom: 18
        }));
		
		// Add layers
		gp_traffic = new google.maps.TrafficLayer();

		//Add drawing control
		gp_drawingManager = new google.maps.drawing.DrawingManager({
			drawingMode: google.maps.drawing.OverlayType.MARKER,
			drawingControl: false,
			drawingControlOptions: {
				position: google.maps.ControlPosition.TOP_CENTER,
				drawingModes: [
					google.maps.drawing.OverlayType.POLYGON,
					google.maps.drawing.OverlayType.POLYLINE,
					google.maps.drawing.OverlayType.RECTANGLE,
					google.maps.drawing.OverlayType.CIRCLE,
					google.maps.drawing.OverlayType.POLYLINE
				]
			},
			markerOptions: {
				icon: 'http://www.example.com/icon.png'
			},
			polygonOptions: {
				fillColor: '#EFFF79',
				fillOpacity: .2,
				strokeWeight: 1.5,
				clickable: true,
				zIndex: 1,
				editable: true,
				draggable: false
			},
			polylineOptions: {
				strokeColor : '#B0C040',
				strokeOpacity: .8,
				strokeWeight: GP_POLYLINE_STROKE,
				clickable: true,
				zIndex: 1,
				editable: true,
				draggable: false
			},
			rectangleOptions : {
				fillColor : '#EFFF79',
				fillOpacity: .2,
				strokeWeight: 1.5,
				clickable: true,
				zIndex: 1,
				editable: true,
				draggable: false
			},
			circleOptions : {
				fillColor : '#EFFF79',
				fillOpacity: .2,
				strokeWeight: 1.5,
				clickable: true,
				zIndex: 1,
				editable: true,
				draggable: false
			}
		});

		//Add event listener when a polygon is added to the map after drawing is complete
		google.maps.event.addListener(gp_drawingManager, 'overlaycomplete', function(e) {
			gp_shapeAddedToMap(e.overlay,e.type);
			
			//Update the list of layers on the map
			angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true});
		});

		// Event listener on zoom change to correct the zoom if needed
		google.maps.event.addListener(gp_map, 'zoom_changed', function() {
			zoomChangeBoundsListener = google.maps.event.addListener(gp_map, 'bounds_changed', function(event) {
				if (this.getZoom() > gp_bestFitMaxZoom && gp_forceBestFitMaxZoom) {
					this.setZoom(gp_bestFitMaxZoom);
					gp_forceBestFitMaxZoom = false;
				}
				google.maps.event.removeListener(zoomChangeBoundsListener);
	        });
		});
		
		//Event listener for right click
		google.maps.event.addListener(gp_map, 'rightclick', function(e) {
			gp_openRigthClickMenu(e); //Open the right click menu
		});

		//Event listener for left click to hide right click menu
		google.maps.event.addListener(gp_map, 'click', function(e) {
			if (gp_mapMode == 'measureDistance') 
				gp_rulerTool.addPinToRuler(e);  // map.distance.js
			else {
				gp_map.set('disableDoubleClickZoom', false); //Enable double click zoom again
				//Hide the context menu.
		 		jQuery("#mapContextMenu").hide();
				gp_infoWindow.close(); // close info window
		 	}
	 	});

	 	//Event listener for bounds change to hide right click menu
		google.maps.event.addListener(gp_map, 'bounds_changed', function(e) {
			//Hide the context menu.
	 		jQuery("#mapContextMenu").hide();
	 	});

	 	//Event listner for map type change
	 	google.maps.event.addListener(gp_map, 'maptypeid_changed', function(e) {
			//Update shadow boxes map controls
			var mapType = gp_map.getMapTypeId();

			if(mapType == 'sat' || mapType == 'satellite' || mapType == 'hyb' || mapType == 'hybrid'){
				jQuery('.mapControlTabInner').addClass('mapControlDarkShadow');
				jQuery('.mapControlContent').addClass('mapControlContentDarkShadow');
				showWhiteSettingsHelp();
				gp_setTrafficIcon();
			}else{
				jQuery('.mapControlTabInner').removeClass('mapControlDarkShadow');
				jQuery('.mapControlContent').removeClass('mapControlContentDarkShadow');
				showBlackSettingsHelp();
				gp_setTrafficIcon();
			}

			//Update the map type on user custom settings
			var object = {};
			object[nameSpacePrefix + 'Map_Type__c'] = gp_map.getMapTypeId();
			Visualforce.remoting.Manager.invokeAction(
				gpRemoteAction,
				'Map_Controller.updateUserSettings',
				{userSetting: JSON.stringify(object)},
				function(result, event){ 
		        //Nothing to do here
		    },{escape:true, timeout: 120000});

		    //Trigger map resize event to re-align map pan/zoom controls
		    google.maps.event.trigger(gp_map, 'resize');
	 	});

		//Add event listener to show/hide map controls on enter and exit of street view
	 	var thePanorama = gp_map.getStreetView();
		google.maps.event.addListener(thePanorama, 'visible_changed', function() {
		    if (thePanorama.getVisible()) {
		    	//Hide the map control tabs
		    	jQuery('.mapControlsWrapper').hide();
		    	jQuery("#settingsAndHelp").hide();
		    } else {
				jQuery('.mapControlsWrapper').show();
				jQuery("#settingsAndHelp").show();
		    }
		});

		//Event lisnter for zoom change
		google.maps.event.addListener(gp_map, 'zoom_changed', function(e) {
			//Hide info window if it is for a cluster as clusters will be changed on zoom
			if(gp_infoWindow.markerId == 'cluster') gp_infoWindow.close();
	 	});

		//Event listener for user drag
		google.maps.event.addListener(gp_map, 'dragend', function(e) {
			//User has moved the map, centerpoint address should change
			gp_mapManualMove();
	 	});

		//Create jquery event listner for map control panel so that if user moves map gp_centerPointKeepAddress is set to false, this is brittle has google may change markup
		jQuery("#mapDIV").on('click','div [title*="Pan"]',function(){
			gp_mapManualMove();
		});

		// Key Drag Zoom
		gp_map.enableKeyDragZoom({
			key: "shift", 
			boxStyle: {
				border: "medium dashed red",
				opacity: 0.80
			},
			paneStyle: {
				backgroundColor: "transparent",
				opacity: 0.00
			},
			visualEnabled: false,
			visualPosition: google.maps.ControlPosition.RIGHT_TOP,
			visualPositionOffset: new google.maps.Size(0, 10),
			visualPositionIndex: null,
			visualSprite: "https://maps.gstatic.com/mapfiles/ftr/controls/dragzoom_btn.png",
			visualSize: new google.maps.Size(20, 20),
			visualTips: {
				off: "Turn on",
				on: "Turn off"
			},
			visualClass: 'gpDragZoom'
		});

		//Event listner to call mapManualMove if someone use the shift drag zoom functionality
        var dz = gp_map.getDragZoomObject();
        google.maps.event.addListener(dz, 'dragend', function (bnds) {
        	gp_mapManualMove();
        });
		
		
		// My Location Control
		if (navigator.geolocation != null){
			var mlControl = jQuery('<div class="locationArrowWrapper"><i class="fa fa-location-arrow"></i></div>').css({
														"margin": "1px 11px 0px 0px",
														"cursor": "pointer",
														"position": "relative",
														"height": "26px",
														"width": "27px",
														"background-color":"white",
														"color": "#666666",
														"text-align": "center",
													    "font-size": "16px",
													    "line-height": "26px",
													})
													.attr('title', 'Center the map on your current location');
													
			mlControl[0].index=2;
			gp_map.controls[google.maps.ControlPosition.RIGHT_TOP].push(mlControl[0]);
			google.maps.event.addDomListener(mlControl[0], 'click', function() {
				gp_centerZoomMyPosition();
				gp_mapManualMove();
				// show user location icon
				gp_setCurrentPositionMarker();
			});
		}

		var drawingControls = jQuery('<div class="drawingControls"></div>');
		var divider = jQuery('<div class="drawingControlsDivider"></div>');

		var dControl = jQuery('<div id="drawHand2" class="drawToolOption drawHand mapDrawTool gp-btn-selected"></div>').css({
														"border-radius": "3px 3px 0 0",
													})
													.attr('title', 'Pan the map');
		drawingControls.append(dControl, divider.clone());

		dControl = jQuery('<div id="drawPolygon2" class="drawToolOption drawPolygon mapDrawTool"></div>').attr('title', 'Draw a Polygon');
		drawingControls.append(dControl, divider.clone());

		dControl = jQuery('<div id="drawRect2" class="drawToolOption drawRect mapDrawTool"></div>').attr('title', 'Draw a Rectangle');
		drawingControls.append(dControl, divider.clone());

		dControl = jQuery('<div id="drawCircle2" class="drawToolOption drawCircle mapDrawTool"></div>').attr('title', 'Draw a Circle');
		drawingControls.append(dControl, divider.clone());

		dControl = jQuery('<div id="drawPolyline2" class="drawToolOption drawPolyline mapDrawTool"></div>').attr('title', 'Draw a Line');
		drawingControls.append(dControl, divider.clone());

		dControl = jQuery('<div id="drawLibrary" class="drawToolOption drawLibrary mapDrawTool"></div>').css({
														"border-radius": "0 0 3px 3px",
													})
													.attr('title', 'Add Geo Library Shape');
		google.maps.event.addDomListener(dControl[0], 'click', function() {
			// jQuery('#openDataSetShapeLibrary').click();
			openVisualGeoshapeEditorApply();
		});
		drawingControls.append(dControl, divider.clone());

		dControl = jQuery('<div id="distanceCalculation" class="drawToolOption distanceIcon" title="Measure Distance"></div>').click(function(){
			openAddLayer('Ruler');
		});

		drawingControls.append(dControl);

		drawingControls[0].index = 3;
		gp_map.controls[google.maps.ControlPosition.RIGHT_TOP].push(drawingControls[0]);
		
		gp_trackMapLoad();
		
	}
	
	var urlParams = getURLparams();
	if(!urlParams.center) {
		// Set Center
		if (thisMC.setCenter && !urlParams.routeid){
			gp_map.setCenter(new google.maps.LatLng(thisMC.centerLat, thisMC.centerLng));
			gp_map.setZoom(thisMC.centerZoom);
		}
		
		// GeoLocation
		if(gp_userSettings.settings__c[nameSpacePrefix + 'Use_Geolocation__c'] && thisMC.entireDataSetAutoRun != true ){
			if (navigator.geolocation != null){
				if (thisMC.centerByGeoLocation){
					gp_setCurrentPositionMarker( function(ctrPt) {
						if (!urlParams.routeid) {
							gp_map.setCenter(ctrPt);
							gp_map.setZoom(11);
						}
					});
				}
			}
		}
	}

	//After map is created set the max height of the route table, my locations table, and layers table
	setRouteTabHeights();
	setMyLocationsTableMaxHeight();
	setDataSetTabMaxHeight();
	setLayersTableMaxHeight();
	setSearchTabMaxHeight();

}

// build address (if possible) and map-action HTML from latLng for infoWindow
function gp_showCurrentLocationInfoWindow() {
	var curLoc = gp_markers['gp_currentLocation'];
	var latLng = curLoc.position;
	rightClickLatLng = latLng;	// I know, right?
	//Do the reverse geocode 
	var geocoder = new google.maps.Geocoder();
	geocoder.geocode({'latLng': latLng}, function(results, status) {
		var htmlStr = '<div class="poiTitle"><b>Current Location</b></div>';

		if (status == google.maps.GeocoderStatus.OK) {
			//Parse google geocode
			var address = gp_parseGoogleGeocode(results[0]);

			//build a poi object
			aPOI = {
				lat: results[0].geometry.location.lat(),
				lng: results[0].geometry.location.lng(),
				countryISO: address.country,
				title: 'Current Location',
				street: address.street,
				city: address.city,
				state: address.state,
				postalCode: address.postalCode,
				country: address.country,
				geocodeQuality: 'CUSTOM',
				usesCustomerGeocode: '',
				recordId: '',
				uniqueId: 'gp_currentLocation'
			};
			// Record Actions
			htmlStr += '<div class="poiTooltip">';
			if (address.fullAddress) {
				htmlStr += '<div notranslate>'+address.fullAddress+'</div>';
			}
			var recordActions = buildPOIActions(null, aPOI, 'button', 'map', true);
			if(recordActions){
				htmlStr += '<div class="poiTooltipButtons"><span style="font-size: 10pt;"><b>'+gp_translations.Record_Actions+':</b></span><br/>';
				htmlStr += 		recordActions;
				htmlStr += '</div>';
			}
			// Map Actions
			htmlStr += '<div class="poiTooltipMapActions"><span style="font-size: 10pt;"><b>'+gp_translations.Map_Actions+':</b></span>';
			htmlStr += '<br/><a href="#" onclick="gp_zoomToStreet(' + aPOI.lat + ',' + aPOI.lng + ',16); return false;">'+gp_translations.Zoom_and_Center+'</a>';
			htmlStr += '<a href="#" onclick="gp_enableStreetView(' + aPOI.lat + ',' + aPOI.lng + ')"; return false;>'+gp_translations.Street_View+'</a>';
			
			var googleLink = 'http://maps.google.com/?q=' + encodeURIComponent(aPOI.street || '') + ',' + encodeURIComponent(aPOI.city || '') + ',' + encodeURIComponent(aPOI.state || '') + ' ' + encodeURIComponent(aPOI.postalCode || '') + ' ' + encodeURIComponent(aPOI.countryISO || '');
			htmlStr += '<a href="' + googleLink + '" target="_blank">'+gp_translations.View_on_Google_Maps+'</a>';
			// htmlStr += '<a href="#" onclick="gp_removeMarkerTable(\'' + aPOI.uniqueId + '\',\'' + collectionName + '\'); ' +
			// 			'gp_removeMarkerMap(\'' + aPOI.uniqueId + '\'); updateChartAfterMarkerRemoval(\'' + collectionName + '\'); return false;">Remove from Map</a>';
			htmlStr += '</div>';

			htmlStr += '</div>';	// close poiTooltip

			// pop up the marker window
			gp_infoWindow.setContent(htmlStr);
			gp_infoWindow.setPosition(latLng);
			gp_infoWindow.setOptions({pixelOffset: {height: 0, width: -1}});
			gp_infoWindow.open(gp_map);
			gp_infoWindow.markerId = 'gp_currentLocation';
			gp_infoWindow.tabsDIV = null;
			gp_tooltip.hide();
		}

		//Called to reset the ActionFunction bug		
		// gp_emptyActionFunction(); 
	});
}

//Handles a poiCollections Request
function gp_poiCollections(jsAction){

	//Update the gp_dataSetSearches object 
	gp_updateDataSearchesObject(jsAction);
	
	var thisPOICollections = jsAction.poiCollections;
	
	// Quick loop through the POI Collections to determine if we should bestFit and/or remove shapes at the end
	gp_bestFitMaxZoom = 3;
	var toBestFit = false; // assume we are not doing bestFit
	var isAutoRefresh = false;
	var toRemoveAllShapes = true; // assume we are removing them
	if (thisPOICollections.length == 0){ toRemoveAllShapes = false; } // don't touch the points if there are no poiCollections
	jQuery.each(thisPOICollections, function(key, value) { 
		// Determine if we are removing shapes
		if(!value.removeAllShapes){ 
			toRemoveAllShapes = false;
		}
		
		// Determine if we are doing Best Fit
		if (value.bestFit) {
			toBestFit = true;
		}

		if (value.searchContext && value.searchContext.options && value.searchContext.options.isAutoRefresh) {
			isAutoRefresh = true;
		}
		
		// Figure max bestFitMaxZoom
		if (value.bestFitMaxZoom > gp_bestFitMaxZoom){
			gp_bestFitMaxZoom = value.bestFitMaxZoom;
		}
	});
	

	// Removing markers and add back the center one if one exists
	if (toRemoveAllShapes){
		
		// Remove shapes and clear the global vars
		gp_cleanMapObjects();
		
		// Destroy the jQuery Data Tables 
		gp_destroyDataTables('gp_dataTables'); 

		//Reset object that keeps track of selected records
		gp_selectedRecords = {};
		
		// Add the center one back
		if (gp_masterMarker != null){
			
			gp_masterMarker.setMap(gp_map); // Add back onto the map
			gp_bounds.extend(gp_masterMarker.getPosition()); // Extend the bounds object so we can do bestFit later
				
			// Add them using the uniqueId as an Index so we can interact with them outside the map
			if(gp_masterMarker.uniqueID != null){ 
				gp_markers[gp_masterMarker.uniqueID] = gp_masterMarker;
			}
		}
	}

	//Create a list of points to handle/add to map and so this asynchronously later
	var poisToHandle = [];
	
	// Loop through each poiCollection
	jQuery.each(thisPOICollections, function(key, value) {
		
		thisPOIC = value;
		thisPOIC.searchType = jsAction.searchType;
		thisPOIC.sfdcObject = '';
		
		// Determine whether we should create the table
		var createTable = thisPOIC.collectionName != gp_centerPOICollectionName;

		//Don't create a table if there are no pois
		if (!thisPOIC.POIs || (thisPOIC.POIs && !thisPOIC.POIs.length)) {
			createTable = false;
		}
		
		if(createTable){
			jQuery('#gp_dataTablesNoData').hide(); // Hide the No Data message
			gp_newDataTableStructure('gp_dataTables', thisPOIC); // Add new jQuery Data Table structure
			var tableCols = gp_defineDataTableColumns(thisPOIC); // Prepare the columns array for use in creating the data table
		}
		
		// Loop over data and add POIS / rows to table
		var tableData = new Array();
		var tmpMarkersArray = [];
		if(typeof(value.POIs) != "undefined"){
			if (value.POIs != null && value.POIs.length > 0) {
				var useIconImgUrl = value.POIs[0].mapIconURL;

				// if this is an idArray search (i.e. search type is empty), check whether associated
				// primary Map Object has a Default Icon defined, and if so, use it
				var mapObjDefaultIconUrl = '';
				if (!jsAction.searchType && gp_dataSetSearches[thisPOIC.collectionName].qo.moNew) {
					var mo = gp_dataSetSearches[thisPOIC.collectionName].qo.moNew;
					if (mo.DefaultMarkerColor || mo.DefaultMarkerIcon || mo.DefaultMarkerText) {
						mapObjDefaultIconUrl = gp_composeMarkerUrl(mo.DefaultMarkerColor, mo.DefaultMarkerIcon, mo.DefaultMarkerText);
					}
				}

				if ('centerPin' != useIconImgUrl && useIconImgUrl.indexOf(GEOPOINTE_API) == -1) {
					// set up failover image in case custom icon URL doesn't load
					var bindUpdate = function(colName, dsName, imgUrl, fallbackColor) {
						// this function creates a closure which preserves passed-in loop variables after loop has exited
						return function() {
							jQuery.jGrowl('Custom marker image on Dataset \'' + dsName + 
											'\' failed to load from URL:<blockquote>' + imgUrl +
											'</blockquote>Using default markers.',
											{ beforeOpen: function(e,m,o) { jQuery(e).removeClass('ui-state-highlight ui-corner-all').width('600px'); }, life: 60000 }
										);
							for (key in gp_markers) {
								if (gp_markers[key].collectionName == colName) {
									var mkr = gp_markers[key];
									mkr.icon.url = GEOPOINTE_API + '/v1/markers/pin-l+' + fallbackColor + '.png';
									mkr.icon.scaledSize.height += 12;
									mkr.icon.anchor.y += 12;
								}
							}
							gp_restoreDataSetSearchOnMap(colName);
						}
					}
					var testImg = new Image();
					testImg.onerror = bindUpdate(thisPOIC.collectionName, thisPOIC.dataSetName, useIconImgUrl, thisPOIC.mapIconColor);
					// set .src last, after setting up error listener
					testImg.src = useIconImgUrl;
				}

				for(var i = 0; i < value.POIs.length; i++){
					
					thisPOI = gp_finishPOIObject(value.POIs[i]); //TODO perf 2500ms
					thisPOI.poicCollectionName = thisPOIC.collectionName;
					thisPOIC.sfdcObject = thisPOI.sfdcObject;

					//Set center pin icon if necesssary
					if(thisPOI.mapIconURL == 'centerPin'){
						thisPOI.mapIconURL = gpImg.center_pin2;
					}
					else if (mapObjDefaultIconUrl) {
						thisPOI.mapIconURL = mapObjDefaultIconUrl;
					}
					
					// Archive off the centerPOI
					if (thisPOI.uniqueId == gp_centerPOICollectionName) { 
						gp_centerPOI = thisPOI; 
						gp_radialSearchCenter = {lat: gp_centerPOI.lat, 
												 lng: gp_centerPOI.lng, 
												 recordId: gp_centerPOI.recordId};
					}

					//poisToHandle.push({poi:thisPOI, poiCollection:thisPOIC});
					gp_handlePOI(thisPOIC, thisPOI);
												
					// Add a row of data to the data table array
					if(createTable){ tableData.push(gp_defineDataTableRow(thisPOIC, thisPOI)); }
					thisPOI.tableData.rowIndex = i;
					thisPOI.tableData.tableCols = tableCols;

					thisPOI = null;
				}// end of loop through each poi
			}
		}
		
		// create circle overlay
		if(	thisPOIC.searchType == 'nearbyRadial' 
			&& typeof(thisPOIC.searchNearbyRange) != "undefined" 
			&& typeof(thisPOIC.searchNearbyLat) != "undefined" 
			&& typeof(thisPOIC.searchNearbyLng) != "undefined"
			&& jsAction.searchNearbyShowOverlay){
		    
				var radius = gp_milesToMeters(thisPOIC.searchNearbyRange);
				if(thisPOIC.distanceUnits=='kilometers' || thisPOIC.distanceUnits=='km' || thisPOIC.distanceUnits=='k'){
					radius = thisPOIC.searchNearbyRange * 1000;
				}
				
				var cirOptions = {
		          clickable:false, //Disable clicks so right click event on map below opens context menu
		          strokeColor: "#B00303", //'#B00303'; '#1797c0';
		          strokeOpacity: 0.75,
		          strokeWeight: 2,
		          fillColor: "#EFFF79", //'#EFFF79'; '#1797c0';
		          fillOpacity: 0.0,
		          map: gp_map,
		          center: new google.maps.LatLng(thisPOIC.searchNearbyLat, thisPOIC.searchNearbyLng),
		          radius: radius
		        };
			    var circle = new google.maps.Circle(cirOptions);
			    gp_cirOverlays[thisPOIC.collectionName + '_overlay'] = circle;
			    
			    gp_bounds.union(circle.getBounds());
		    
		}
	    
		// Initialize the Data Table
		if(createTable){
			//Delay the creation of the table slightly, TODO WHY?!?!
			setTimeout(function(){ 
				//value is the POI collection in the larger jQuery loop, need to use this due do the way var are stored and used in timeout functions
				gp_initDataTable(value, tableCols, tableData)  

				// Calculate Drive Times
				if (jsAction.searchNearbyDriveCalc){
					gp_showDriveDistanceColumn(value.collectionName, value.distanceUnits)
					//gp_calcDriveTimes(value.collectionName, value.distanceUnits);
				}

				//Add same location markers, need to do this after table is created as this is the data source
				gp_createSameLocationMarkers();

				google.maps.event.trigger(gp_map, 'resize');
			}, 50);
		}
		
	}); // end of loop through each poiCollection 

	//Show the markers on the map, do this in seperate javascript thread with timeout as it is browser intensive
	setTimeout(function(){
		thisPOICollections.forEach(function(objCollection) {
			//Restoring a data set search is the same as adding it so we can use this method of initial add after search is performed
			if (objCollection.collectionName) {
				gp_restoreDataSetSearchOnMap(objCollection.collectionName);
			}
		});
	},50);

	//If there are shapes on the map make sure they are included in the bounds calculation so the map zoom contains entire shape
    for(key in polygonObjects){
    	var bounds = polygonObjects[key].getBounds();
    	gp_bounds.extend( new google.maps.LatLng(bounds.getNorthEast().lat(), bounds.getNorthEast().lng()) );
    	gp_bounds.extend( new google.maps.LatLng(bounds.getSouthWest().lat(), bounds.getSouthWest().lng()) );
    }

	// Best Fit
	if (toBestFit && !isAutoRefresh) {
		gp_forceBestFitMaxZoom = true;
		gp_centerZoom();
	}

	//Build the list actions
	buildListActions(); //map.actions.js
}

//Take an object as input and process the POI onto the map
function gp_handlePOI(thisPOIC, thisPOI){	

	if(!thisPOI.isBlankLat && !thisPOI.isBlankLng){

		//If there is salesforceObject property, move to sObject
		if(thisPOI.salesforceObject){
			thisPOI.sObject = makeObjectKeysLowerCase(thisPOI.salesforceObject);
		}

		// Make Lat Lon Object
		var g_latlon = new google.maps.LatLng(thisPOI.latDisplay, thisPOI.lngDisplay);
		
		// Extend the bounds object so we can do bestFit later
		gp_bounds.extend(g_latlon);
		
		// Build the InfoContentHTML
		var tmpInfoContentHTML = '<div class="poiActions"></div>';
			
		var hoverText = thisPOI.title;
		if (thisPOI.title2 != ''){
			hoverText = '<strong>'+ thisPOI.title + '</strong><br/>' + thisPOI.title2;
		}
		
		// Create this GMarker
		var imgWidth = 20;
		var imgHeight = 32;
		var imgFloat = -2;
		if (!thisPOI.mapIconURL.startsWith(GEOPOINTE_API)) {
			// Custom icons are considered to be square, vs. the taller standard pin icons.
			// Also, std. pins have a 'shadow' at the bottom which touches the label,
			// while custom icons look too crowded if they touch where the shadow would.
			imgWidth = 32;
			imgHeight = 32;
			imgFloat = 3;
		}

		var image = {
		    url: thisPOI.mapIconURL,
		    scaledSize: new google.maps.Size(imgWidth + 3, imgHeight + 3), // All markers are 20 pixels wide. Include margin
		    anchor: new google.maps.Point(11.5, imgHeight + imgFloat), // The anchor for this image is just above the base of the image.
		    type: thisPOI.markerType
		};

		// provide a marker value for records lacking label-by value
		if (('label' == thisPOI.markerType) && !thisPOI.labelByFieldText) {
			thisPOI.labelByFieldText = 'No Value';
		}

		var g_marker = gp_createMarker(g_latlon, hoverText, tmpInfoContentHTML, image, thisPOI.uniqueId, null, thisPOI.labelByFieldText); //TODO perf 300ms
		
		//Set the collectionName property on the marker object so we can keep track of what markers belong to each data set search
		g_marker.collectionName = thisPOI.poicCollectionName;
		g_marker.sObject = thisPOI.sObject;
		g_marker.recordId = thisPOI.recordId;
		g_marker.recordTypeId = thisPOI.recordTypeId;
		g_marker.gp_title = thisPOI.title;
		g_marker.gp_title2 = thisPOI.title2;
		g_marker.gp_distanceInfo = thisPOI.distanceInfo;
		g_marker.gp_formattedAddr = thisPOI.formattedAddr;
		g_marker.gp_additionalFields = thisPOI.additionalFields;
		g_marker.gp_sfdcObject = thisPOI.sfdcObject;
		g_marker.gp_geocodeQuality = thisPOI.geocodeQuality;
		g_marker.gp_tableData = thisPOI.tableData = thisPOI.tableData || {};

		//Set flat to determin if labels are displayed
		if(thisPOI.labelByFieldText){
			gp_dataSetSearches[thisPOI.poicCollectionName].markerLabelsVisible = true;
		}

		// Add them to the main object using the uniqueId as an Index so we can interact with them outside the map
		if(thisPOI.uniqueId != ''){
			gp_markers[thisPOI.uniqueId] = g_marker;
		}
		
		// Save off the centerPOI marker
		if (thisPOI.poicCollectionName == gp_centerPOICollectionName){
			gp_masterMarker = g_marker;
		}

		//If this poi has shapes associated with it add those to the map
		if(thisPOIC.shapeMap[thisPOI.recordId]){
			
			//Record could have more that one shape so loop through and add to map
			for(var i = 0; i < thisPOIC.shapeMap[thisPOI.recordId].length; i++){
				var shape = thisPOIC.shapeMap[thisPOI.recordId][i];

				//Create a new polygon overlay
				var shapeOverlay;
				var shapeOptions = {
					fillColor: shape.color,
					fillOpacity: shape.opacity,
					strokeWeight: 1.5,
					clickable: true,
					zIndex: 2,
					editable: false,
					draggable: false
				};

				var isPolyline = shape.type && shape.type.toLowerCase() == 'polyline';
				var isPolygon = shape.type && shape.type.toLowerCase() == 'polygon';
				var isCircle = shape.type && shape.type.toLowerCase() == 'circle';
				var isGeoshape = shape.type && shape.type.toLowerCase() == 'multipolygon';
				if(isPolygon || isPolyline) {

					//Decode the lat lng string
					var latLngs = [];

					var coordArrays = null;
					if(shape.coordinates && shape.coordinates.search(/^\s*\[\s*\[\s*\[/) == 0){ //Stored in GeoJSON format
						coordArrays = JSON.parse(shape.coordinates);
						var lngLatArray = coordArrays[0];	// first array of lng lats is the outer ring of the main shape
						for(var j = 0; j < lngLatArray.length; j++){
							latLngs.push(new google.maps.LatLng(lngLatArray[j][1],lngLatArray[j][0]));
						}

					}else{
						latLngs = google.maps.geometry.encoding.decodePath(shape.coordinates);
					}

					if (isPolyline) {
						shapeOptions.path = latLngs;	// polyline has only one
						shapeOptions.strokeColor = shape.color;
						shapeOptions.strokeOpacity = shape.opacity;
						shapeOptions.strokeWeight = GP_POLYLINE_STROKE;
					}
					else {
						shapeOptions.paths = latLngs;	// polygon may have several
					}

					var shapeOverlay = (isPolyline? new google.maps.Polyline(shapeOptions) : new google.maps.Polygon(shapeOptions));
					shapeOverlay.gpProperties = {};

					if (coordArrays && coordArrays.length > 1) {	// if there were holes / extra pieces, set up to display them
						shapeOverlay.gpProperties.innerRings = {};
						shapeOverlay.gpProperties.outerRingsToInnerRings = {};
						shapeOverlay.gpProperties.outerRingsToInnerRings[0] = [];
						var paths = [];
						paths.push(latLngs);

						for (var cdx = 1; cdx < coordArrays.length; cdx++) {
							shapeOverlay.gpProperties.outerRingsToInnerRings[cdx] = [];
							var innerRingArray = coordArrays[cdx];
							var innerLatLngs = [];
							for (var ix = 0; ix < innerRingArray.length; ix++) {
								innerLatLngs.push(new google.maps.LatLng(innerRingArray[ix][1], innerRingArray[ix][0]));
							}
							paths.push(innerLatLngs);
							shapeOverlay.gpProperties.innerRings[paths.length - 1] = true;
							shapeOverlay.gpProperties.outerRingsToInnerRings[cdx].push(paths.length - 1);
						}

						shapeOverlay.setPaths(paths);
					}

				} else if (isCircle) {

					//Determing radius in meters
					var radius = JSON.parse(JSON.stringify(shape.radius)); //Copy radius by value, not reference

					if(shape.units == 'm' || shape.units == 'miles' || shape.units == 'Miles'){
						radius = shape.radius * 1.60934;
					}
					radius = radius * 1000; //convert to meters

					shapeOptions.radius = radius;

					//If lat/lng was defined on the Shape__c object use that, other wise use lat/lng from record
					if(shape.centerLat && shape.centerLng){
						shapeOptions.center = new google.maps.LatLng(shape.centerLat,shape.centerLng);
					}else{
						shapeOptions.center = new google.maps.LatLng(thisPOI.lat,thisPOI.lng);
					}
					
					//Create a new circle overlay
					var shapeOverlay = new google.maps.Circle(shapeOptions);
					shapeOverlay.gpProperties = {};
					shapeOverlay.gpProperties.centerLabel = shape.centerLabel;
					shapeOverlay.gpProperties.range = shape.radius;
				} else if (isGeoshape) { //This are currently only geoshape fields
					var suppressToastAndZoom = true;
					gp_addShapeIdToMap(shape.sfdcId, function(result){

						//Loop through all the polygons on the map and update the properties
						for(key in polygonObjects){
							var shapeOverlay = polygonObjects[key];
							if (shapeOverlay.gpProperties.groupLayerId != result.groupLayerId)
								continue;
							
							shapeOverlay.gpProperties.sfdcId = shape.sfdcId;
							shapeOverlay.gpProperties.sfdcName = shape.name;
							shapeOverlay.gpProperties.sfdcDescription = shape.description ? shape.description : '';
							shapeOverlay.gpProperties.relatedRecordName = thisPOI.title;
							shapeOverlay.gpProperties.relatedRecordId = thisPOI.recordId;
							shapeOverlay.gpProperties.usageType = 'Shape Field';
							shapeOverlay.gpProperties.gpCollectionName = thisPOIC.collectionName;
							shapeOverlay.gpProperties.relatedRecordFieldName = shape.relatedRecordFieldName;
							shapeOverlay.gpProperties.relatedRecordFieldLabel = shape.relatedRecordFieldLabel;
							shapeOverlay.gpProperties.units = shape.units;
							shapeOverlay.gpProperties.recordLat = thisPOI.lat;
							shapeOverlay.gpProperties.recordLng =  thisPOI.lng;
							shapeOverlay.gpProperties.gpPoiId = thisPOI.uniqueId;
						}
					}, suppressToastAndZoom);


				}

				//Set the saved properties on the overlay shape object, shape was added synchronously for polygon and circl
				if (isPolygon || isPolyline || isCircle) {

					shapeOverlay.gpProperties.sfdcId = shape.sfdcId;
					shapeOverlay.gpProperties.sfdcName = shape.name;
					shapeOverlay.gpProperties.sfdcDescription = shape.description;
					shapeOverlay.gpProperties.relatedRecordName = thisPOI.title;
					shapeOverlay.gpProperties.relatedRecordId = thisPOI.recordId;
					shapeOverlay.gpProperties.usageType = 'Shape Field';
					shapeOverlay.gpProperties.gpCollectionName = thisPOIC.collectionName;
					shapeOverlay.gpProperties.relatedRecordFieldName = shape.relatedRecordFieldName;
					shapeOverlay.gpProperties.relatedRecordFieldLabel = shape.relatedRecordFieldLabel;
					shapeOverlay.gpProperties.units = shape.units;
					shapeOverlay.gpProperties.recordLat = thisPOI.lat;
					shapeOverlay.gpProperties.recordLng =  thisPOI.lng;
					shapeOverlay.gpProperties.gpPoiId = thisPOI.uniqueId;

					//Add the shape to map
					shapeOverlay.setMap(gp_map);

					var shapeBounds = shapeOverlay.getBounds();
					gp_bounds.extend(shapeBounds.getNorthEast());
					gp_bounds.extend(shapeBounds.getSouthWest());

					//Call polygon added to map method, make sure it is added to polygon Objects array
					gp_shapeAddedToMap(shapeOverlay,shape.type.toLowerCase());
				}

			}
		}
	}
	
	return null;
}

//Creates and returns a map marker
function gp_createMarker(latlng,title,html,image,uid,place,maplabel) {
	
	// Create traditional marker
	var marker = new google.maps.Marker({
	      position: latlng, 
	      icon: image,
	      flat: true,
	      type: image.type
	});  

	//If this is a center pin marker make it slightly larger than the rest
	if(image.url == gpImg.center_pin2 || image == gpImg.center_pin2){
		var useIconUrl = gpImg.center_pin2;
		var upscaleWidth = 29;	// we enlarge the center marker, and if we're using a custom image we need to square it up
		var upscaleHeight = 48;
		if (gp_dataSetSearches.centerPOI) {
			if (gp_dataSetSearches.centerPOI.qo.moNew &&
							(gp_dataSetSearches.centerPOI.qo.moNew.DefaultMarkerColor ||
							gp_dataSetSearches.centerPOI.qo.moNew.DefaultMarkerIcon ||
							gp_dataSetSearches.centerPOI.qo.moNew.DefaultMarkerText)) {
				useIconUrl = gp_composeMarkerUrl(gp_dataSetSearches.centerPOI.qo.moNew.DefaultMarkerColor,
												gp_dataSetSearches.centerPOI.qo.moNew.DefaultMarkerIcon,
												gp_dataSetSearches.centerPOI.qo.moNew.DefaultMarkerText);
				if (gp_dataSetSearches.centerPOI.qo.moNew.DefaultMarkerIcon.startsWith('http') &&
				!gp_dataSetSearches.centerPOI.qo.moNew.DefaultMarkerIcon.startsWith(GEOPOINTE_API)) {
					upscaleWidth = upscaleHeight = 48;
				}
			}
		}
		marker.setIcon({
		    url: useIconUrl,
		    scaledSize: new google.maps.Size(upscaleWidth, upscaleHeight),
		    anchor: new google.maps.Point(~~(0.5 * upscaleWidth), ~~(0.8 * upscaleHeight))
		});
	}

	// If this is currentLocation, fix it up centered
	if (image.url == gpImg.currentLocation || image == gpImg.currentLocation) {
		marker.setIcon({
			url: gpImg.currentLocation,
			scaledSize: new google.maps.Size(25, 25), // This marker is 25 pixels wide by 40 pixels tall.
			anchor: new google.maps.Point(12, 12) 
		});
	}
	
	// Add custom properties to it
	marker.tooltip = '<div class="gp_tooltip nowrap" notranslate>'+title+'</div>';
	marker.tooltipDetail = '';
	if(html){
		marker.tooltipDetail = html.substring(0,html.indexOf('<div class="poiActions">'));
	}            
	marker.infoWindowHTML = html;
	marker.uniqueID = uid;
	
	// Marker Click Event
	if(!place){
		google.maps.event.addListener(marker, 'click', function() {
			
			//If we are in record selection mode perform special handling from record clicks
			if(gp_inRecordSelectionMode && marker.uniqueID != 'gp_mapCenterPoi' && marker.uniqueID != 'centerPOI'){
				gp_toggleRecordSelection(marker.uniqueID);
			}else{
				gp_openPoiInfoMarker(marker.uniqueID);
			}
			gp_tooltip.hide();
		});
	} else {
		google.maps.event.addListener(marker, 'click', function() {
			gp_placesInfoWindowHandler(place);
		});
	}
	
	// Marker Mouseover Event 
	google.maps.event.addListener(marker,"mouseover", function() {
		var ttOptions = {
			content: '',
			boxClass: 'gp_tooltip_parent',
			closeBoxURL: '',
			isHidden: true
		}
		gp_tooltip.setOptions(ttOptions);	// reset to avoid cross-contamination of styles with gm_infoWindow
		if(gp_inRecordSelectionMode && marker.type != undefined && marker.uniqueID != 'gp_mapCenterPoi'){
			if (marker.sObject) {
				gp_tooltip.setContent(gp_buildPoiHtml(marker));
			} else {
				gp_tooltip.setContent(angular.element('#modalListDirective').injector().get('dataLayerSearchService').buildInfoWindowHtml(marker.poi, marker.dataLayer));
			}
		}else{
			gp_tooltip.pixelOffset_.height = ('label' === marker.type || 'gp_currentLocation' === marker.uniqueID)? 16 : 0;	// don't let tooltip overlap label-only marker
			gp_tooltip.setContent(marker.tooltip);
		}
		// pull any slightly off-map marker into bounds so that
		// tooltip.open() doesn't make a radical grab to center
		gp_map.getBounds().extend(marker.position);
		gp_tooltip.show();
		gp_tooltip.open(gp_map, marker);
	});
	
	// Marker Mouseout Event
	google.maps.event.addListener(marker,"mouseout", function() {
		gp_tooltip.hide();
	}); 

	// if label text defined, create that graphic
	if (maplabel) {
		var mkrLabel = new MapLabel({
								fontSize: 14,
								strokeWeight: 5,
								position: latlng,
								text: maplabel,
								zIndex: 102	// above polygons, below everything else
							});
		marker.mapLabel = mkrLabel;
	}

	return marker;
}

function gp_createSameLocationMarkers(){

	//Wipe out existing same location markers
	for(var i = 0; i < gp_sameLocationMarkers.length; i++){
		gp_sameLocationMarkers[i].setMap(null);
	}
	gp_sameLocationMarkers = [];

	var sameLocations = {};

	//Loop through all of the data
	var allTables = jQuery('.dataTable');
	
	// Loop through each table
	for(var i = 0, iLen = allTables.length; i < iLen; i++) {
		
		// Get the Table Data
		var aoData = jQuery(allTables[i]).dataTable().fnGetData();
		var columnInfo = jQuery(allTables[i]).data('columnInfo');
		var collectionName = jQuery(allTables[i]).attr('id');		

		//Only proceed if these markers are visible on the map
		if(gp_dataSetSearches[collectionName] && gp_dataSetSearches[collectionName].markersVisible != false && gp_dataSetSearches[collectionName].markerType == 'marker'){
			//Loop through the rows
			for ( var j = 0; j < aoData.length; j++ ){
				var row = aoData[j];

				var marker = gp_markers[row[gp_ColumnInfo.uniqueId]];

				//If marker is hidden by the legend skip it
				if(marker && marker.hiddenByLegend == true){
					continue;
				}

				//Get that lat and combine them with a x
				var latLng = row[gp_ColumnInfo.latitudeDisplay] + 'x' + row[gp_ColumnInfo.longitudeDisplay];
				
				//Maker sure there is a key value for this lat long in same locations object
				if(typeof sameLocations[latLng] == 'undefined'){
					sameLocations[latLng] = [];
				}

				//Increment the count of records at this location
				sameLocations[latLng].push(marker);

			} // END OF Rows Loop
		}
		
	} // END OF tables loop

	_.forEach(gp_markers, function (dataLayerMarker) {
		// If not a data layer marker, skip
		if (!dataLayerMarker.poi) return;

		// If marker is hidden by the legend skip it
		if (dataLayerMarker.hiddenByLegend === true || dataLayerMarker.visible === false) return;

		// If clustering is turned on for this layer, skip
		if (gp_layers[dataLayerMarker.collectionName].displayType === 'cluster') return;

		// Get that lat and combine them with a x
		var markerLatLng = dataLayerMarker.poi.geocode.coordinates[1] + 'x' + dataLayerMarker.poi.geocode.coordinates[0];

		// Maker sure there is a key value for this lat long in same locations object
		if (typeof sameLocations[markerLatLng] === 'undefined') {
			sameLocations[markerLatLng] = [];
		}

		// Increment the count of records at this location
		sameLocations[markerLatLng].push(dataLayerMarker);
	});

	//Loop through the same locations object
	var hidingSLMs = gp_userSettings.settings__c[nameSpacePrefix + 'Same_Location_Markers__c'] == 'on';
	for(key in sameLocations){
		// hide markers/labels at this sameLocation, IF we're replacing with a SLM
		var hideThisKey = hidingSLMs && (sameLocations[key].length > 1);
		for (var mx = 0; mx < sameLocations[key].length; mx++) {
			sameLocations[key][mx].setMap(hideThisKey? null : gp_map);
		}

		//If there was more than one location at same spot create a special marker
		if(sameLocations[key].length > 1){
			//Parse out the lat long
			var latLng = key.split('x');

			// Create a new marker at this location that carries 'N markers at this location' tooltip.
			// If SLM=='on' marker is a visible circle with a Number
			var marker = gp_createSameLocationMarker(latLng[0],latLng[1],sameLocations[key].length);

			//Set gp properties
			marker.gpLat = latLng[0];
			marker.gpLng = latLng[1];
			marker.gpRecordCount = sameLocations[key].length;
			marker.type = 'cluster';

			gp_sameLocationMarkers.push(marker);
		}
	}

	//Hide the info window if it is open for sameLocationMarkers
	if(gp_infoWindow && gp_infoWindow.content && gp_infoWindow.content.indexOf('sameLocationInfoWindowWrapper') > -1){
		gp_infoWindow.close();
	}
}

function gp_createSameLocationMarker(lat,lng,count){
	
	var imgUrl = GEOPOINTE_API + '/v1/markers/circle-l+007AA5.png?text=' + count;
	
	//If org setting is default off use the transparent img
	if(gp_orgSettings.settings.sameLocationMarkers == 'Default Off'){
		imgUrl = gpImg.onepxtransparent;
	}
	
	//If user as overriden the same location marker option use this
	if(typeof gp_userSettings.settings__c[nameSpacePrefix + 'Same_Location_Markers__c'] != 'undefined'){
		if(gp_userSettings.settings__c[nameSpacePrefix + 'Same_Location_Markers__c'] == 'on'){
			imgUrl = GEOPOINTE_API + '/v1/markers/circle-l+007AA5.png?text=' + count;
		}else{	
			imgUrl = gpImg.onepxtransparent;
		}
	}

	var marker = new google.maps.Marker({
		position: new google.maps.LatLng(lat, lng), 
		map: gp_map,
	    icon: {
	        scaledSize: new google.maps.Size(33,33),
	        size: new google.maps.Size(33,33),
	        url: imgUrl
	    },
	    zIndex: 100000 //make sure this is always on top of the markers
	});  

	marker.tooltip = '<div class="gp_tooltip nowrap"><var>'+count+'</var> records at this location</div>';

	google.maps.event.addListener(marker,"mouseover", function() {
		gp_tooltip.setContent(marker.tooltip);
		// pull any slightly off-map marker into bounds so that
		// tooltip.open() doesn't make a radical grab to center
		gp_map.getBounds().extend(marker.position);
		gp_tooltip.show();
		gp_tooltip.open(gp_map, marker);
	});
	
	// Marker Mouseout Event
	google.maps.event.addListener(marker,"mouseout", function() {
		gp_tooltip.hide();
	}); 

	//Create event listener for click
	google.maps.event.addListener(marker, 'click', function(e) { 
        gp_showSameLocationMarkerInfoWindow(marker);
    });

	return marker;
}

function gp_showSameLocationMarkerInfoWindow(marker){
	//Calculate max height of infowindow
	var maxHeight = jQuery('#mapDIV').height() * 0.70;

	var infoWindowHTML = '<div class="sameLocationInfoWindowWrapper" style="max-height: '+maxHeight+'px"><table cellspacing="0" cellpadding="0" width="100%" class="sameLocationInfoWindowTable"><tbody>';

	//Loop through all of the data
	var allTables = jQuery('.dataTable');

	// Loop through each table
	for(var i = 0, iLen = allTables.length; i < iLen; i++) {
		
		// Get the Table Data
		var aoData = jQuery(allTables[i]).dataTable().fnGetData();
		var columnInfo = jQuery(allTables[i]).data('columnInfo');
		var collectionName = jQuery(allTables[i]).attr('id');

		//Only proceed if markers are on the map for this dataset
		var foundSameLocation = 0;
		if(gp_dataSetSearches[collectionName].markersVisible != false){
			//Loop through the rows
			for ( var j = 0; j < aoData.length; j++ ){
				var row = aoData[j];
				var titleTop = '-3px;'
				if(row[gp_ColumnInfo.title2]){
					titleTop = '-1px';
				}

				var mapMarker = gp_markers[row[columnInfo.uniqueId]];

				//If marker is hidden by the legend skip it
				if(mapMarker.hiddenByLegend == true){
					continue;
				}

				//If record has same lat lng of marker, add it to info window
				if(marker.gpLat == row[gp_ColumnInfo.latitudeDisplay] && marker.gpLng == row[gp_ColumnInfo.longitudeDisplay]){
					infoWindowHTML+= '<tr>'+
							            '<td width="17px">'+
							                '<a href="#"  onclick="if(gp_inRecordSelectionMode && \''+
							                row[gp_ColumnInfo.uniqueId]+'\' != \'gp_mapCenterPoi\' && \''+
							                row[gp_ColumnInfo.uniqueId]+'\' != \'centerPOI\') '+
							                '{ gp_toggleRecordSelection(\''+row[gp_ColumnInfo.uniqueId]+'\'); }'+
							                'else{gp_openPoiInfoMarker(\''+row[gp_ColumnInfo.uniqueId]+'\',false); return false;}">';
					if ('label' == marker.type) {
						infoWindowHTML += '<img src="' + GEOPOINTE_API + '/v1/markers/pin-m+' + dsController.baseColorPalette[0] + '.png" height="32px"/>';
					}
					else {
						infoWindowHTML += '<img src="'+row[gp_ColumnInfo.mapIconURL]+'" height="32px" ' +
											'onerror="this.onerror=null;this.src=\''+gp_dataSetSearches[collectionName].icon+'\'"/>';
					}
					infoWindowHTML+=	'</a></td>'+
							            '<td>'+
							            	'<div class="sameLocationDetail" style="top: '+ titleTop +'">'+
								                '<div><a href="#" onclick="gp_openPoiInfoMarker(\''+row[gp_ColumnInfo.uniqueId]+'\',false); return false;">'+row[gp_ColumnInfo.title]+'</a></div>'+
								                '<div class="title2">'+row[gp_ColumnInfo.title2]+'</div>'+
							                '</div>'+
							            '</td>'+
							        '</tr>';
				}

			} // END OF Rows Loop
		}
	} // END OF tables loop

	_.forEach(gp_markers, function (dataLayerMarker, key) {
		// If not a data layer marker, skip
		if (!dataLayerMarker.poi) return;

		// If marker is hidden by the legend skip it
		if (dataLayerMarker.hiddenByLegend === true || dataLayerMarker.visible === false) return;

		// If clustering is turned on for this layer, skip
		if (gp_layers[dataLayerMarker.collectionName].displayType === 'cluster') return;

		// If record doesn't have same lat lng of same location marker, skip
		if (marker.gpLat !== String(dataLayerMarker.poi.geocode.coordinates[1]) || marker.gpLng !== String(dataLayerMarker.poi.geocode.coordinates[0])) return;

		infoWindowHTML += '<tr>' +
			'<td width="17px">' +
				'<a href="#"  onclick="if(gp_inRecordSelectionMode && \'' +
				key + '\' != \'gp_mapCenterPoi\' && \'' +
				key + '\' != \'centerPOI\') ' +
				'{ gp_toggleRecordSelection(\'' + key + '\'); }' +
				'else{gp_openPoiInfoMarker(\'' + key + '\',false); return false;}">';
		if (dataLayerMarker.type === 'label') {
			infoWindowHTML += '<img src="' + GEOPOINTE_API + '/v1/markers/pin-l+' + angular.element('#dataLayerDirective').injector().get('dataLayerService').dataLayerDefaults[dataLayerMarker.dataType].defaultColorRule.color + '.png" height="32px"/>';
		} else {
			infoWindowHTML += '<img src="' + dataLayerMarker.markerUrl + '" height="32px" />';
		}
		infoWindowHTML += '</a></td>' +
			'<td>' +
				'<div class="sameLocationDetail" style="top: ' + titleTop + '">' +
					'<div><a href="#" onclick="google.maps.event.trigger(gp_markers[\'' + key + '\'], \'click\'); return false;">' + dataLayerMarker.name + '</a></div>' +
				'</div>' +
			'</td>' +
		'</tr>';
	});

	//Close the table
	infoWindowHTML += '</tbody></table></div>';

	//Set properties of info window and show it
	gp_infoWindow.setOptions({pixelOffset: {height: -28, width: 0}});
	gp_infoWindow.setContent(infoWindowHTML);
	gp_infoWindow.setPosition(new google.maps.LatLng(marker.gpLat, marker.gpLng));
	gp_infoWindow.open(gp_map);
}

//Toggle record selection, add checkmark to map, update checkbox in table
function gp_toggleRecordSelection(uniqueId){
	
	//Set apply to picklist to selected records
	jQuery("#applyActionTo").val('selectedRecords');

	//Check to see if the record is already selected
	if(!gp_selectedRecords[uniqueId]){
		gp_selectedRecords[uniqueId] = true;

		//Set z index of the maker pin 1 below the check box icon
		gp_markers[uniqueId].setZIndex(199999);

		gp_markers[uniqueId].selectedMarker = new google.maps.Marker({
			position: gp_markers[uniqueId].getPosition(), 
			map: gp_map,
			icon: {
                anchor: new google.maps.Point(0,17),
                scaledSize: new google.maps.Size(18,18),
                size: new google.maps.Size(18,18),
                url: redCheckIconURL
            },
			flat: false,
			zIndex: 200000
		});  

	}else{
		//Set selected flag as false for the record
		gp_selectedRecords[uniqueId] = false;
		
		//Remove the selected marker from the map
		gp_markers[uniqueId].selectedMarker.setMap(null);
		gp_markers[uniqueId].selectedMarker = null;
	}

	updateDataTableSelectedProp(uniqueId);
}

function gp_removeCenterMarker(){
	// Removing the center poi if it exists on the map
	if(gp_masterMarker != null){ 
		gp_removeMarkerMap(gp_masterMarker.uniqueID);
		gp_masterMarker = null;
		jQuery("#centerContextTitleOutput").html('Center of the Map');
		setDataSetTabMaxHeight();
	}
}

//Resizes the map to be the width of the div
function gp_resetMapWidth(){
	// In the console, if the map is loaded in the background in a subtab, the map size is 0
	// Then when the user clicks on the map, the view is all wrong.  So, if width/height started as 0,
	// try to set the bounds correctly afterwards
	var center;
	if (gp_map && (jQuery("#mapDIV").height() == 0 || jQuery("#mapDIV").width() == 0)) {
		center = gp_map.getCenter();
	}

	google.maps.event.trigger(gp_map, 'resize');

	if (center) {
		gp_map.setCenter(center);
		gp_map.setZoom(10);

		if (jQuery("#mapDIV").height() > 0 && jQuery("#mapDIV").width() > 0) {
			var numMarkers = _.size(gp_markers);
			var numCircles = _.size(gp_cirOverlays);

			if (numMarkers == 1 && numCircles == 0) {
				// set the center to the marker and set zoom to 16
				gp_map.setCenter(_.sample(gp_markers).position);
				gp_map.setZoom(16);
			} else if (numMarkers > 1 || numCircles > 0) {
				var bounds = new google.maps.LatLngBounds();
				_.each(gp_markers, function(marker) {
					bounds.extend(marker.position);
				})
				_.each(gp_cirOverlays, function(circle) {
				    bounds.union(circle.getBounds());
				})
				gp_map.fitBounds(bounds);
			}
		}
	}

	//Resent legend max width
	setLegendMaxHeight();
}

function gp_setMaxDataTableWidth(){
	var navBar = jQuery('.zen #tabContainer');//sfdc header, same width as visualforce content
	if(navBar && navBar.length > 0){
		jQuery('.dataTableScrollWrapper').width(navBar.width());
	}else{
		jQuery('.dataTableScrollWrapper').width(jQuery(window).width());
	}
}

function gp_setMapHeight(height){
	// In the console, if the map is loaded in the background in a subtab, the map size is 0
	// Then when the user clicks on the map, the view is all wrong.  So, if width/height started as 0,
	// try to set the bounds correctly afterwards
	var center;
	if (gp_map && (jQuery("#mapDIV").height() == 0 || jQuery("#mapDIV").width() == 0)) {
		center = gp_map.getCenter();
	}

	jQuery('#mapWrapper').removeClass('mapWrapperInit');

	if(height == 'auto'){
		height = getAutoMapHeight();
	}
	jQuery("#mapDIV").width('100%');
	jQuery("#mapDIV").height (height);

	if(gp_map)google.maps.event.trigger(gp_map, 'resize');

	if (center) {
		gp_map.setCenter(center);
		gp_map.setZoom(10);

		if (jQuery("#mapDIV").height() > 0 && jQuery("#mapDIV").width() > 0 ) {
			var numMarkers = _.size(gp_markers);
			var numCircles = _.size(gp_cirOverlays);

			if (numMarkers == 1 && numCircles == 0) {
				// set the center to the marker and set zoom to 16
				gp_map.setCenter(_.sample(gp_markers).position);
				gp_map.setZoom(16);
			} else if (numMarkers > 1 || numCircles > 0) {
				// set the bounds to include markers and circles
				var bounds = new google.maps.LatLngBounds();
				_.each(gp_markers, function(marker) {
					bounds.extend(marker.position);
				})
				_.each(gp_cirOverlays, function(circle) {
				    bounds.union(circle.getBounds());
				})
				gp_map.fitBounds(bounds);
			}
		}
	}

	setRouteTabHeights();
	setMyLocationsTableMaxHeight();
	setDataSetTabMaxHeight();
	setLayersTableMaxHeight();
	setSearchTabMaxHeight();
}

//Called from a link inside a POI to zoom down to that location
function gp_zoomToStreet(lat, lon, zoom){
	gp_map.setCenter(new google.maps.LatLng(lat, lon));
	gp_map.setZoom(zoom);
}

function gp_getZoomLevel(){
	return gp_map.getZoom();
}

function gp_centerZoomMyPosition(){

	//Dreamforce demo org
	if(gp_userSettings.userInfo.orgId == '00Do0000000bwHyEAI'){
		gp_map.setCenter(new google.maps.LatLng(37.784188, -122.401519));
		gp_map.setZoom(14);

	}else if (navigator.geolocation != null){
		navigator.geolocation.getCurrentPosition(function(position){
			gp_map.setCenter(new google.maps.LatLng(position.coords.latitude, position.coords.longitude));
	    	gp_map.setZoom(14);
		}, function() {
			jQuery.extend(toastr.options,{ timeOut: 60000 });
			toastr.error(gp_translations.Your_browser_failed_to_determine_your_current_location);
	    });
	} else {
		jQuery.extend(toastr.options,{ timeOut: 60000 });
		toastr.error(gp_translations.Your_browser_does_not_support_determination_of_your_current_location);
	}
}

function gp_centerRightClick(){
	//Recenter map
	gp_map.panTo(new google.maps.LatLng(rightClickLatLng.lat, rightClickLatLng.lng));
	gp_trackRightClick('Center');
}

function gp_bestFitRightClick(){
	gp_centerZoom();
	gp_trackRightClick('Show All Mapped Points');
}

function gp_streetViewRightClick(){
	gp_enableStreetView(rightClickLatLng.lat, rightClickLatLng.lng);
	gp_trackRightClick('Street View');
}

function gp_centerZoomRightClick(){
	gp_centerRightClick();

	//Based on current zoom level zoom in.
	var zoom = gp_getZoomLevel();
	var newZoom = 14; //Default
	if(zoom == 0){
		newZoom = 3;
	}else if(zoom == 1){
		newZoom = 5;
	}else if(zoom == 2){
		newZoom = 6;
	}else if(zoom == 3){
		newZoom = 7;
	}else if(zoom == 4){
		newZoom = 7;
	}else if(zoom == 5){
		newZoom = 9;
	}else if(zoom == 6){
		newZoom = 11;
	}else if(zoom == 7){
		newZoom = 11;
	}else if(zoom == 8){
		newZoom = 12;
	}else if(zoom == 9){
		newZoom = 13;
	}else if(zoom == 10){
		newZoom = 14;
	}else if(zoom == 11){
		newZoom = 15;
	}else if(zoom == 12){
		newZoom = 15;
	}else if(zoom == 13){
		newZoom = 16;
	}else if(zoom == 14){
		newZoom = 16;
	}else if(zoom == 15){
		newZoom = 18;
	}else if(zoom == 16){
		newZoom = 18;
	}else if(zoom == 17){
		newZoom = 19;
	}else if(zoom == 18){
		newZoom = 20;
	}else if(zoom == 19){
		newZoom = 20;
	}else if(zoom == 20){
		newZoom = 21;
	}else if(zoom == 21){
		newZoom = 21;	
	}

	gp_map.setZoom(newZoom);

	gp_trackRightClick('Center and Zoom');
}

function gp_openRigthClickMenu(e){
	// if the map mode is not search, don't open (could be in measureDistance, addShape)
	if (gp_mapMode !== undefined && gp_mapMode != 'search')
		return;

	gp_map.set('disableDoubleClickZoom', true); //disable double click zoom becuase of FF zoom out bug

	//Find the pixel position in the map
	var overlay = new google.maps.OverlayView();
	overlay.draw = function() {};
	overlay.setMap(gp_map);
	var projection = overlay.getProjection(); 
	var pixel = projection.fromLatLngToContainerPixel(e.latLng);

	//Create on object with coordinates and mouse position
	var clickInfo = {
		lat: e.latLng.lat(),
		lng: e.latLng.lng(),
		x: pixel.x,
		y: pixel.y
	};

	//Save the lat lng of the click in rightClickLatLng var so other methods have access
	rightClickLatLng = clickInfo;

	//Create a "POI" object we can send to the buildPOIActions method
	var thisPOI = {
		lat: clickInfo.lat,
		lng: clickInfo.lng,
	};

	//First populate the custom map actions
	var actionsHTML = buildPOIActions(null,thisPOI,'link','map');
	jQuery('#mapContextMenu .menuMapActions').html(actionsHTML);

	//Select the menu and store in variable
	var $mapMenu = jQuery("#mapContextMenu");
	var $mapWrapper = jQuery("#mapWrapper");
	
	//Determine coordinates of mouse click inside the mapDiv
	var x = clickInfo.x + 1; //+1 so normal right click menu does not open
	var y = clickInfo.y 

	//Collision detection stuff to make sure menu is not off the edge of the screen
	if(y + $mapMenu.outerHeight() > $mapWrapper.height()){
		y = y - $mapMenu.outerHeight();
	}
	if(x + $mapMenu.outerWidth() > $mapWrapper.width()){
		x = x - $mapMenu.outerWidth() - 1; //-1 so normal right click menu does not open
	}

	//Show the menu
	$mapMenu.css({
		display: 'block',
		top: y,
		left: x 
	});
}

function gp_clearCenter(){
	// Removing the center poi if it exists on the map
	if(gp_masterMarker != null){ 
		gp_removeMarkerMap(gp_masterMarker.uniqueID);
		gp_masterMarker = null;
	}

	jQuery('#centerContextTitleOutput').html('Center of the Map');
	setDataSetTabMaxHeight();

	//Wipe out the old center point poi
	gp_centerPOI = {};
	gp_centerPointKeepAddress = false;

	//Clear search center
	gp_radialSearchCenter = {lat: null, 
		lng: null, 
		recordId: null};
}

function gp_setCenter(){
	//Recenter map
	gp_map.panTo(new google.maps.LatLng(rightClickLatLng.lat, rightClickLatLng.lng));

	//Set the right click repositioned flag to true so original centerPOI is not used
	rightClickRepositionOccured = true;

	gp_clearCenter();

	//Set search center
	gp_radialSearchCenter = {lat: rightClickLatLng.lat, 
		lng: rightClickLatLng.lng, 
		recordId: null};
}

function gp_searchRadialRemoteRightClick(){
	//Recenter map
	gp_map.panTo(new google.maps.LatLng(rightClickLatLng.lat, rightClickLatLng.lng));

	//Set the right click repositioned flag to true so original centerPOI is not used
	rightClickRepositionOccured = true;

	//Wipe out the old center point poi
	gp_centerPOI = {};
	gp_centerPointKeepAddress = false;

	//Set search center
	gp_radialSearchCenter = {lat: rightClickLatLng.lat, 
							 lng: rightClickLatLng.lng, 
							 recordId: null};

	//Do radial search
	gp_searchRadialRemote();

	gp_trackRightClick('Radial Search');
}

function gp_measureDistanceRightClick() {
	gp_rulerTool.startMeasureDistance(rightClickLatLng.lat, rightClickLatLng.lng);
	gp_trackRightClick('Measure Distance');
}

//Return an object with center info
function gp_getCenterObject(){
	var r = new Object();
	r.center = gp_map.getCenter();
	r.lat = r.center.lat();
	r.lng = r.center.lng();
	return r;
}




//Return an object with bounds
function gp_getBoundsObject(){
	var r = new Object();
	r.bounds = gp_map.getBounds();

	if (!r.bounds) 
		return null;

	r.minLat = r.bounds.getSouthWest().lat();
	r.maxLat = r.bounds.getNorthEast().lat();
	r.minLng = r.bounds.getSouthWest().lng();
	r.maxLng = r.bounds.getNorthEast().lng();
	return r;
}

//A Best Fit function for Google Maps - depends upon the gp_bounds object being populated
function gp_centerZoom(){
	
		if (gp_bounds.getCenter().lat() != 0 && gp_bounds.getCenter().lng() != -180){
			
			// Center
			gp_map.setCenter(gp_bounds.getCenter());
			
			// Zoom
			gp_map.fitBounds(gp_bounds);
			
			// an event listener will reset the zoom if its in too far
		}
	} 

// Open the Info Window
function gp_openPoiInfoMarker(markerID,sameLocationMarker) {
	var marker = gp_markers[markerID];
	
	if(sameLocationMarker){
		gp_infoWindow.setOptions({pixelOffset: {height: -28, width: 0}});
	}else{
		var heightOffset = ('label' == marker.type || 'gp_currentLocation' == markerID)? 2 : -16;
		gp_infoWindow.setOptions({pixelOffset: {height: heightOffset, width: 0}});

		//Populate the actions section
		if(marker.infoWindowHTML.indexOf('"poiActions"') > -1){

			//Get the related sObject
			var obj = marker.sObject;

			//Get the collectionName this marker is a part of
			var collectionName = marker.collectionName;

			//Get the related data set search detail
			var dataSetSearch = gp_dataSetSearches[collectionName];

			//Get the query optimizer and map object detail 
			var qo; 
			var moNew;

			if(dataSetSearch){
				qo = dataSetSearch.qo;
				moNew = dataSetSearch.qo.moNew;
			}

			//Construct a POI to build the actions
			var poi = {};

			if(marker.uniqueID == 'centerPOI'){
				poi = {
					"uniqueId": marker.uniqueID,
					"recordId": gp_centerPOI.recordId,
					"recordTypeId": gp_centerPOI.recordTypeId,
					"title": gp_centerPOI.title,
					"lat": gp_centerPOI.lat,
					"lng": gp_centerPOI.lng,
					"street": gp_centerPOI.street,
					"city": gp_centerPOI.city,
					"postalCode": gp_centerPOI.postalCode,
					"state": gp_centerPOI.state,
					"country": gp_centerPOI.country,
					"sfdcObject": gp_centerPOI.sfdcObject,
					"markerURL": marker.icon.url
				};
				if(gp_centerPOI.title2){
					poi.title2 = gp_centerPOI.title2;
				}

			}else if (obj) {
				poi = {
					"uniqueId": marker.uniqueID,
					"recordId": obj.id,
					"recordTypeId": obj.recordtypeid,
					"title": getDescendantProp(obj, moNew.ReadNameField),
					"lat": getDescendantProp(obj, moNew.GpLatitudeField),
					"lng": getDescendantProp(obj, moNew.GpLongitudeField),
					"street": getDescendantProp(obj, moNew.ReadStreetField),
					"city": getDescendantProp(obj, moNew.ReadCityField),
					"postalCode": getDescendantProp(obj, moNew.ReadPostalField),
					"state": getDescendantProp(obj, moNew.ReadStateField),
					"country": getDescendantProp(obj, moNew.ReadCountryField),
					"sfdcObject": moNew.SobjectName,
					"markerURL": marker.icon.url
				};
			}else {
				poi = {
					"uniqueId": marker.uniqueID,
					"recordId": marker.recordId,
					"recordTypeId": marker.recordTypeId,
					"title": marker.title,
					"lat": marker.lat,
					"lng": marker.lng,
					"street": marker.street,
					"city": marker.city,
					"postalCode": marker.postalCode,
					"state": marker.state,
					"country": marker.country,
					"sfdcObject": moNew.SobjectName,
					"markerURL": marker.icon.url
				};
			}

			// custom lat/lng for geocode correction
			if(qo && qo.moNew){
				poi.customLatLng = moNew.UsesCustomLatLngFields;
				poi.customLatField = moNew.ReadLatitudeField;
				poi.customLngField = moNew.ReadLongitudeField;
			}

			// Title 2
			if (poi.sfdcObject == 'lead' && moNew.ReadNameField == 'name' && obj){ poi.title2 = obj.company }
			if (poi.sfdcObject == 'contact' || poi.sfdcObject == 'opportunity') {
				if (moNew.ReadNameField == 'name' && obj && obj.account) {
					poi.title2 = obj.account.name;
				}
			}

			//Build a poiCollection object
			var poic = {
				collectionName: collectionName,
				qo: qo
			};

			var actionsHTML = '<div class="poiActions">';

			//POI Inline Actions
			actionsHTML += '<div class="poiTooltipInlines" notranslate>';
			actionsHTML += 		buildPOIActions(poic,poi,'inline','record');  
			actionsHTML += '</div>';
			
			//POI Buttons
			actionsHTML += '<div class="poiTooltipButtons">';

			// if called for, inject writeBack button first
			if (writeBackEnabled) {
				// do some defensive checking in case url params are missing anything
				if (!writeBackButtonText) {	// provide sensible button text
					// can't get record name without a server lookup, so just show cleaned up field API name
					var writeBackLabel = writeBackField;
					if (writeBackField.indexOf('__') > 0) {
						var labelParts = writeBackField.split('__');
						var lx = labelParts.length - 2;	// may or may not have a namespace prefix; the chunk BEFORE __c is what we want
						writeBackLabel = labelParts[lx];
					}
					writeBackButtonText = 'Link to Originating Record\'s ' + writeBackLabel.replace(/_/g, '%20');
				}

				if (poi.sfdcObject == writeBackLookupObject.toLowerCase()){
					actionsHTML += '<input class="gpButton gpButtonBasic gpButtonBrand" onclick="geopointeAjaxStart(\'body\',\''+gp_translations.Updating_Originating_Record+'...\'); gp_writeBackSelection(\'' + poi.recordId + '\'); return false;" value="' + decodeURIComponent((writeBackButtonText + '').replace(/\+/g, '%20')) + '" type="button" />';
				}
			}

			actionsHTML += 		buildPOIActions(poic,poi,'button','record'); //map.actions.js
			actionsHTML += '</div>';
			// end POI Buttons
			
			//Record Actions
			var recordActionHtml = buildPOIActions(poic,poi,'link','record');
			if(recordActionHtml){
				actionsHTML += '<div class="poiTooltipActions"><span style="font-size: 10pt;"><b>'+gp_translations.Record_Actions+':</b></span><br/>';
				actionsHTML += 		recordActionHtml;
				actionsHTML += '</div>';
			}

			//Map Actions
			actionsHTML += '<div class="poiTooltipMapActions"><span style="font-size: 10pt;"><b>'+gp_translations.Map_Actions+':</b></span>';
			actionsHTML += '<br/><a href="#" onclick="gp_zoomToStreet(' + poi.lat + ',' + poi.lng + ',16); return false;">'+gp_translations.Zoom_and_Center+'</a>';
			actionsHTML += '<a href="#" onclick="gp_enableStreetView(' + poi.lat + ',' + poi.lng + ')"; return false;>'+gp_translations.Street_View+'</a>';
			
			var googleLink = 'http://maps.google.com/?q=' + encodeURIComponent(poi.street || '') + ',' + encodeURIComponent(poi.city || '') + ',' + encodeURIComponent(poi.state || '') + ' ' + encodeURIComponent(poi.postalCode || '') + ' ' + encodeURIComponent(poi.countryISO || '');
			actionsHTML += '<a href="' + googleLink + '" target="_blank">'+gp_translations.View_on_Google_Maps+'</a>';
			actionsHTML += '<a href="#" onclick="gp_removeMarkerTable(\'' + poi.uniqueId + '\',\'' + collectionName + '\'); ' +
												'gp_removeMarkerMap(\'' + poi.uniqueId + '\'); updateChartAfterMarkerRemoval(\'' + collectionName + '\'); return false;">Remove from Map</a>';
			actionsHTML += '</div>';
			
			actionsHTML += '</div>';	// close "poiActions"

			// Build the InfoContentHTML
			var tmpInfoContentHTML = gp_buildPoiHtml(marker);

			marker.infoWindowHTML = tmpInfoContentHTML.replace('<div class="poiActions"></div>',actionsHTML);
		}
	}

	gp_infoWindow.setContent(marker.infoWindowHTML);
	gp_infoWindow.setPosition(marker.getPosition());
	gp_infoWindow.open(gp_map);
	gp_infoWindow.markerId = marker.uniqueID;
	gp_infoWindow.tabsDIV - null;
}

function gp_getSObjectFieldValue(sObject, path){
	return path.split('.').reduce(function(sObject, field){
		if(!sObject || sObject[field] === undefined || sObject[field] === null) return '';
		else return sObject[field];
	}, sObject);
}

function gp_setSObjectFieldValue(sObject, path, value){
	var path = path.split('.');
	var lastField = path.pop();
	var sObject = path.reduce(function(sObject, field){
		if(sObject[field] === '' || sObject[field] === undefined || sObject[field] === null) sObject[field] = {};
		return sObject[field];
	}, sObject);
	sObject[lastField] = value;
}

function gp_buildPoiHtml(marker){
	var tmpInfoContentHTML = '';

	var styleStr = "font-size: 9pt;";
	if (gp_inRecordSelectionMode) {
		styleStr += "margin:1em;overflow:hidden;";
	}
	tmpInfoContentHTML += '<div style="' + styleStr + '" class="poiTooltip" >';

	if (marker.recordId) {
		var url = '';

		// Add url prefix, typically for Communities if it is present
		if (gp_orgSettings.urlPrefix) {
			url = gp_orgSettings.urlPrefix + '/' + marker.recordId;
		} else {
			url = '/' + marker.recordId;
		}

		tmpInfoContentHTML += '<div class="poiTitle" notranslate><a href="' + url + '" target="_blank">' + marker.gp_title + '</a></div><span notranslate>';
	}else{
		tmpInfoContentHTML += '<div class="poiTitle" notranslate>' + marker.gp_title + '</div><span notranslate>';
	}
	
	if(marker.gp_title2 != ''){
		tmpInfoContentHTML += '<b style="font-size: 9pt;">' + marker.gp_title2 + '</b><br/>';
	}
	tmpInfoContentHTML += marker.gp_formattedAddr + '</span>';
	if (marker.gp_distanceInfo){
		tmpInfoContentHTML += marker.gp_distanceInfo;
	}
	if (marker.gp_geocodeQuality){
		tmpInfoContentHTML += '<br/><b>'+gp_translations.Geocode_Quality+'</b>: ' + marker.gp_geocodeQuality;
	}

	if(marker.gp_additionalFields){
		tmpInfoContentHTML += '<hr/><span notranslate>';
		jQuery.each(marker.gp_additionalFields, function(key, value) { 
			var referenceName = '';
			var additionalFieldsObj = null;
			if(value.datatype === 'REFERENCE'){
				additionalFieldsObj = _.find(marker.gp_additionalFields, function(info){
					return info.name === value.name;
				});
				referenceName = additionalFieldsObj.referenceName || '';
			}
			var inInfo = (value.inInfo == undefined || value.inInfo); // default to 'true' for old datasets
			if((value.isShapeField != true) && inInfo){
				var fieldValue = gp_getSObjectFieldValue(marker.sObject, value.name);
				if(value.datatype === 'REFERENCE'){
					fieldValue = {label: referenceName, value: fieldValue || ''};
				}else if(value.datatype === 'DATE'){
					fieldValue = {label: fieldValue ? moment(fieldValue).format('l') : '',
						value: fieldValue || ''};
				}else if(value.datatype === 'DATETIME'){
					var momentDate = moment(fieldValue);
					fieldValue = {label: fieldValue ? momentDate.tz(gp_userSettings.userInfo.timeZone).format('l') + ' ' + momentDate.tz(gp_userSettings.userInfo.timeZone).format('LT') : '',
						value: fieldValue || ''};
				}
				tmpInfoContentHTML += '<b style="float: left">';
				if (value.pathLabel && value.pathLabel.length && value.label[value.label.length-1] !== ')') {
					tmpInfoContentHTML += value.pathLabel.join(' ') + ' (';
				}
				tmpInfoContentHTML += value.label + ((value.pathLabel && value.pathLabel.length && value.label[value.label.length-1] !== ')')? ')' : '') + ':&nbsp;</b>' + 
					gp_formatOutputField({
						sfdcRecordId: marker.recordId,
						fieldType: value.datatype,
						fieldValue: fieldValue,
						recordName: marker.gp_title,
						precision: value.precision,
						apiName: value.name,
						objectApiName: marker.gp_sfdcObject,
						isUpdateable: value.isUpdateable,
						referenceName: referenceName,
						isInfoWindow: true,
						tableData: marker.gp_tableData,
						sObject: marker.sObject,
						collectionName: marker.collectionName,
						additionalFieldsObj: additionalFieldsObj,
						uniqueId: marker.uniqueID
					}) + '<br style="clear: both"/>';
			}
		});
		tmpInfoContentHTML += '</span>';
	}

	tmpInfoContentHTML += '<div class="poiActions"></div>';	
	
	tmpInfoContentHTML += '</div>';

	return tmpInfoContentHTML;
}

// Remove the marker from the map
function gp_removeMarkerMap(markerID) {

	var marker = gp_markers[markerID];

	if(!marker) return;

	if(gp_dataSetSearches[marker.collectionName] && gp_dataSetSearches[marker.collectionName].markerClusterer){
		gp_dataSetSearches[marker.collectionName].markerClusterer.removeMarker(marker);
	}

	// Remove marker from map
	gp_markers[markerID].setMap(null);
	
	// Close info window if applicable
	if (markerID == gp_infoWindow.markerId){
		gp_infoWindow.close();
		gp_tooltip.hide();
	}
	
	// Remove from the gp_markers object
	delete gp_markers[markerID];

	//Recalc the samelocation markers
	gp_createSameLocationMarkers();
	
}

//Given a data set search collection name, remove those markers from the map
function gp_removeDataSetSearchFromMap(collectionName){

	//Loop through markers collection and remove those from map for the specified collection
	for(key in gp_markers){
		if(gp_markers[key].collectionName == collectionName){
			gp_markers[key].setMap(null);

			// Close info window if applicable
			if (gp_markers[key].uniqueID == gp_infoWindow.markerId){
				gp_infoWindow.close();
				gp_tooltip.hide();
			}
		}
	}

	//Remove any circles on the map related to this search
	for(key in gp_cirOverlays){
		if(key == collectionName + '_overlay'){
			gp_cirOverlays[key].setMap(null);
		}
	}

	//Remove shape fields
	for(key in polygonObjects){
		if(polygonObjects[key].gpProperties.gpCollectionName == collectionName){
			if (polygonObjects[key].mapLabel) polygonObjects[key].mapLabel.setMap(null);
			polygonObjects[key].setMap(null);
		}
	}

	//Set markers visible flag to false for this search
	if(gp_dataSetSearches[collectionName]){
		gp_dataSetSearches[collectionName].markersVisible = false;
	}

	//Remove any marker clusters
	gp_dataSetSearches[collectionName].markerClusterer.clearMarkers();

	//Rebuild the same location markers
	gp_createSameLocationMarkers();
}

function gp_removeDataSetSearchTab(collectionName){

	//Remove markers from gp_markers object
	for(key in gp_markers){
		if(gp_markers[key].collectionName == collectionName){
			// Remove any associated record-selection checkmark
			if (gp_selectedRecords[key] && gp_markers[key].selectedMarker) {
				delete gp_selectedRecords[key];
			}
			gp_markers[key].setMap(null);
			delete gp_markers[key];
		}
	}

	//Remove circle from gp_cirOverlays object
	for(key in gp_cirOverlays){
		if(key == collectionName + '_overlay'){
			gp_cirOverlays[key].setMap(null);
			delete gp_cirOverlays[key];
		}
	}

	//Remove shape fields
	for(key in polygonObjects){
		if(polygonObjects[key].gpProperties.gpCollectionName == collectionName){
			if (polygonObjects[key].mapLabel) polygonObjects[key].mapLabel.setMap(null);
			polygonObjects[key].setMap(null);
			delete polygonObjects[key];
		}
	}

	//Remove the tab and content
	jQuery(".dataSetResultTableTab[data-collectionName='"+collectionName+"']").remove();
	jQuery("#tabs-" + collectionName).remove();

	//Remove any cluster layers
	var collectionSearch = gp_dataSetSearches[collectionName];
	if (collectionSearch) {
		if (collectionSearch.markerClusterer) collectionSearch.markerClusterer.clearMarkers();

		//Remove from gp_dataSetSearches object
		delete gp_dataSetSearches[collectionName];
		collectionSearch = null;
	}

	//Remove the legend
	var mapLegendService = angular.element('.legendController').injector().get('mapLegendService');
	mapLegendService.removeLegendGroup(collectionName);

	//Rebuild the same location markers
	gp_createSameLocationMarkers()

	//Update the layers list with new record counts
	setTimeout(function(){
		angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true}); 
	},0);

	//If there no more result or route tabs show the no data message
	var $tabs = jQuery(".dataSetResultTableTab,#routeDirectionsTab");
	if($tabs.length == 0){
		jQuery("#gp_dataTablesNoData").show();
		jQuery("#gp_dataTables").hide();
	}else{ 
		jQuery($tabs[0]).find("a").click();
	}
}

function gp_restoreDataSetSearchOnMap(collectionName){
	//If markers where visibile before data set was removed from map, add them back
	var dataSetSearch = gp_dataSetSearches[collectionName];
	if (!dataSetSearch) return;
	var useCluster = dataSetSearch.numOfRecords > gp_userSettings.settings__c[nameSpacePrefix + 'Auto_Cluster_Query_Size__c'] ? true : false;

	//If market type for this data set is explicitly set to cluster, use it.
	if(dataSetSearch.markerType == 'cluster'){
		useCluster = true;
	}
	
	for(key in gp_markers){
		
		var marker = gp_markers[key];

		if(marker.collectionName == collectionName && !marker.hiddenByLegend){
			if(useCluster){
				dataSetSearch.markerClusterer.addMarker(marker,true); //True is a noDraw option, we will do this once all markers have been added
			}else{
				if ('label' == marker.type) {	// MapLabel has no event listners, so we borrow those of Marker by spreading it over the text
					var labelWidth = marker.mapLabel.text.length * 6;	// good-enough estimate - if we had a text extent it would be better
					marker.icon.anchor = { x: labelWidth * 0.5, y: 0 };
					marker.icon.scaledSize = { width: labelWidth, height: marker.mapLabel.fontSize, U: 'px', V: 'px' };
					marker.icon.url = gpImg.onepxtransparent;
				}

				marker.setMap(gp_map);

				if (marker.mapLabel && dataSetSearch.layerSettings && dataSetSearch.layerSettings.markerLabelsVisible == true) {
					// mapPane will be behind polygons unless its Canvas is lifted
					var panes = marker.mapLabel.getPanes();
					if (panes && panes.mapPane) {
						jQuery(panes.mapPane).css('z-index', marker.mapLabel.zIndex);
					}
					marker.mapLabel.setMap(gp_map);	// oddly, Marker.prototype.setMap overload doesn't seem to cover this case
				}
			}
		}
	}

	//Draw the cluster layer after all markers have been added
	if(useCluster == true){
		dataSetSearch.markerType = 'cluster';
		dataSetSearch.markerClusterer.repaint();
	}

	//Add back any necessary circles
	for(key in gp_cirOverlays){
		if(key == collectionName + '_overlay'){
			gp_cirOverlays[key].setMap(gp_map);
			if (gp_cirOverlays[key].mapLabel) {
				gp_cirOverlays[key].mapLabel.setMap(gp_cirOverlays[key].showLabel? gp_map : null);
			}
		}
	}

	//Add shape fields
	for(key in polygonObjects){
		if(polygonObjects[key].gpProperties.gpCollectionName == collectionName){
			polygonObjects[key].setMap(gp_map);
			if (polygonObjects[key].mapLabel) {
				polygonObjects[key].mapLabel.setMap(polygonObjects[key].gpProperties.showLabel ? gp_map : null);
			}
		}
	}

	//Set markers visible flag to true for this search
	if(gp_dataSetSearches[collectionName]){
		gp_dataSetSearches[collectionName].markersVisible = true;
	}

	//Rebuild the same location markers
	gp_createSameLocationMarkers();
}

// Enable Street View
function gp_enableStreetView(lat,lng){
	jQuery("#mapContextMenu").hide();
	gp_map.getStreetView().setPosition(new google.maps.LatLng(lat,lng));
	gp_map.getStreetView().setVisible(true);
}


//Toggles the Traffic Overlay
function gp_toggleTraffic() {
	try{
		if (gp_trafficState) {
			gp_traffic.setMap(null);
			gp_trafficState = false;
			jQuery('#buttonTrafficLayer').val(gp_translations.Toggle_Traffic_On);
			gp_trackLayerToggle('Traffic','Off');
		} else {
			gp_traffic.setMap(gp_map);
			gp_trafficState = true;
			jQuery('#buttonTrafficLayer').val(gp_translations.Toggle_Traffic_Off);
			gp_trackLayerToggle('Traffic','On');
		}
		gp_setTrafficIcon();
		return false;
	} catch(e){
		alert(e); 
		geopointeAjaxEnd();
		return false;
	}
}

function gp_setTrafficIcon(){
	//Hide all the traffic icons
	jQuery('.trafficIcon').hide();
	var mapType = gp_map.getMapTypeId();

	//Only proceed if google
	if(gp_trafficState){ //traffic layer is on
		if(mapType == 'sat' || mapType == 'satellite' || mapType == 'hyb' || mapType == 'hybrid'){
			jQuery(".trafficLightWhiteColor").show();
		}else{
			jQuery(".trafficLightBlackColor").show();
		}
	}else{ // traffic layer is off
		if(mapType == 'sat' || mapType == 'satellite' || mapType == 'hyb' || mapType == 'hybrid'){
			jQuery(".trafficLightWhite").show();
		}else{
			jQuery(".trafficLightBlack").show();
		}
	}
}

function gp_updateSearchMarker(address,isGotoMyLocation){

	//1 Center the map on result
	gp_map.panTo(new google.maps.LatLng(address.lat,address.lng));

	if(gp_getZoomLevel() < 13){
		gp_map.setZoom(13);
	}

	//2 Remove existing center map marker if it exists
	if(gp_searchMarker != null &&  gp_markers['gp_mapSearchPoi']){ 
		gp_removeMarkerMap(gp_searchMarker.uniqueID);
		gp_searchMarker = null;
	}
	
	//3 Add new center map marker
	var g_latlon = new google.maps.LatLng(address.lat, address.lng);

	//Set option to keep center address for marker and "Search Center" on dataset 
	var keepSearchFromAddress = false;
	if(isGotoMyLocation || address.keepAddress){
		keepSearchFromAddress = true;
	}

	//Update search center location
	gp_radialSearchCenter = {lat: address.lat, 
							 lng: address.lng, 
							 recordId: null};

	jQuery('#centerContextTitleOutput').html('<span notranslate>'+address.fullAddress+'</span>');
	setDataSetTabMaxHeight();
	
	tmpInfoContentHTML = '<div class="poiTooltip">';
	if(address.title){
		tmpInfoContentHTML += '<strong notranslate><u>'+address.title+'</u></strong>';
	}
	tmpInfoContentHTML += '<div notranslate>'+address.fullAddress+'</div>';

	var pointType = 'map';

	var thisPOI = {
		name: address.name,
		title: address.name,
		recordId: '',
		street: address.street,
		city: address.city,
		postalCode: address.postalCode,
		state: address.state,
		country: address.country,
		lat: address.lat,
		lng: address.lng,
		markerURL: gp_searchMarker? gp_searchMarker.icon.url : null,
		placeId: address.placeId
	};

	if(gp_searchMarker && gp_searchMarker.icon){
		thisPOI.markerURL = gp_searchMarker.icon.url;
	}

	if(address.source == 'googlePlace'){
		pointType = 'place';
		thisPOI.phone = address.phone;
		thisPOI.website = address.website;
	}

	//Record Actions, buttons
	var actionsHTML = buildPOIActions(null,thisPOI,'button',pointType,true);
	if(actionsHTML){
		tmpInfoContentHTML += '<div class="poiTooltipButtons">';
		tmpInfoContentHTML += 	actionsHTML;
		tmpInfoContentHTML += '</div>';
	}

	//Record Actions, links
	actionsHTML = buildPOIActions(null,thisPOI,'link',pointType,true);
	if(actionsHTML){
		tmpInfoContentHTML += '<div class="poiTooltipActions"><span style="font-size: 12px;"><b>Actions:</b></span><br/>';
		tmpInfoContentHTML += 	actionsHTML;
		tmpInfoContentHTML += '</div>';
	}

	//Map Actions
	tmpInfoContentHTML += '<div class="poiTooltipMapActions"><span><b>'+gp_translations.Map_Actions+':</b></span>';
	tmpInfoContentHTML += '<br/><a onclick="gp_setPlaceSearchCenter(' + address.lat + ',' + address.lng + ',\'' + address.fullAddress.replace(/'/g,'\\\'') +'\'); return false;">Set Search Center</a>';
	tmpInfoContentHTML += '<a onclick="gp_zoomToStreet(' + address.lat + ',' + address.lng + ',16);">'+gp_translations.Zoom_and_Center+'</a>';
	tmpInfoContentHTML += '<a onclick="gp_enableStreetView(' + address.lat + ',' + address.lng + ')">'+gp_translations.Street_View+'</a>';
	tmpInfoContentHTML += '<a onclick="gp_removeMarkerMap(\'gp_mapSearchPoi\')">Remove from Map</a>';

	tmpInfoContentHTML += '</div>';

	tmpInfoContentHTML += '</div>';

	//Update html on searchPOI object
	if(gp_searchPOI){
		gp_searchPOI.markerHtml = tmpInfoContentHTML;
	}

	var image = {
	    url: searchPinURL,
	    scaledSize: new google.maps.Size(25, 40), // This marker is 20 pixels wide by 32 pixels tall.
	    anchor: new google.maps.Point(13, 32) // The anchor for this image is the base of the flagpole at 0,32.
	};

	var g_marker = gp_createMarker(g_latlon
									, '<b>'+address.singleLineAddress+'</b>'
									,tmpInfoContentHTML 
									, image
									, 'gp_mapSearchPoi');


	
	
	gp_markers[g_marker.uniqueID] = g_marker;
	gp_searchMarker = g_marker;
	g_marker.setMap(gp_map);
}

//--------DRAWING AND POLYGON/SHAPE SEARCH METHODS----------
var polygonObjects = {}; //keeps track of polygons on the map

// Defaults to Rectangle mode
function gp_enterDrawMode(mode){
	if (!gp_drawingManager)
		return;  // Throw error instead?

	//Remove selected class from other drawtool buttons*/
	jQuery(".drawToolOption").removeClass('gp-btn-selected');
	
	//Enable drawing mode
	gp_drawingManager.setMap(gp_map);

	if (mode == 'polygon') {
		//Add the selected class to the polygon drawtool
		jQuery('.drawPolygon').addClass('gp-btn-selected');
		gp_drawingManager.setDrawingMode(google.maps.drawing.OverlayType.POLYGON);

	} else if (mode == 'polyline') {
		//Add the selected class to the polyline drawtool
		jQuery('.drawPolyline').addClass('gp-btn-selected');
		gp_drawingManager.setDrawingMode(google.maps.drawing.OverlayType.POLYLINE);

	} else if (mode == 'circle') {
		//Add the selected class to the circle drawtool
		jQuery('.drawCircle').addClass('gp-btn-selected');
		gp_drawingManager.setDrawingMode(google.maps.drawing.OverlayType.CIRCLE);

	} else { // default to rectangle
		//Add the selected class to the rectangle drawtool
		jQuery('.drawRect').addClass('gp-btn-selected');
		gp_drawingManager.setDrawingMode(google.maps.drawing.OverlayType.RECTANGLE);
	}

}

function gp_exitDrawMode(){
	jQuery(".drawToolOption").removeClass('gp-btn-selected');
	jQuery('.drawHand').addClass('gp-btn-selected');
	if(gp_drawingManager){
		gp_drawingManager.setDrawingMode(null);
	}
}

// This can be called for a regular shape search (params.searchType=='shape') or a nearbyShape search (params.searchType=='nearbyShape')
// If nearbyShape, params will also include range, nearbySearchUnits, nearbySearchDistanceUnits
function doPolygonSearch(params, dataSet, isGroup, callback){ //{overlayId: id of shape, groupLayerId: id group layer, jqThis: jQuery(this)}
	callback = callback || function(){};
	//If there are no polygons, tell user to add one.  do not do a search
	if(jQuery.isEmptyObject(polygonObjects)){
		callback(true);
		toastr.warning('Please add a shape to the map before performing a Shape search.');
		return;
	}

	//Create options object
	var options = {};
	if(dataSet) options.dataSetObject = dataSet;
	options.searchType = 'shape';
	if(isGroup) options.autoLoad = true;

	// If nearbyShape, add additional options
	if (params.searchType == 'nearbyShape') {
		options.searchType = 'nearbyShape';
		options.range = params.range;
		options.radialCenterLat = params.radialCenterLat;
		options.radialCenterLng = params.radialCenterLng;
		options.nearbySearchUnits = params.nearbySearchUnits;
		options.nearbySearchDistanceUnits = params.nearbySearchDistanceUnits;
		options.calcDriveDistance = true;
	}

	//Loop through all of the objects on the map and build bound boxes for each shape
	var shapeBoundBoxes = [];
	
	//If overlay id for a shape was defined only search this bound box
	if(params.overlayId){
		var bounds = polygonObjects[params.overlayId].getBounds();

		var boundBox = {
			minLat: bounds.getSouthWest().lat(),
			maxLat: bounds.getNorthEast().lat(),
			minLng: bounds.getSouthWest().lng(),
			maxLng: bounds.getNorthEast().lng()
		}
		shapeBoundBoxes.push(boundBox);

		//Set id of over lay that is being searched on the options object
		options.groupLayerId = params.overlayId;

	}else{ //Else is a groupLayer search, a Geo Shape search
		
		//Create an object of groupLayerId to a bounding box, as one layer could be comprised of many parts but we only want one bbox
		var groupLayerIdBbox = {};

		//Create search bounds for all of the shapes
		for(key in polygonObjects){
			var layer = polygonObjects[key];
			var groupLayerId = layer.gpProperties.groupLayerId;
			
			//Only process layers with groupId that was provided, if it wasnt search all shapes
			if(typeof params.groupLayerId == 'undefined' || params.groupLayerId == layer.gpProperties.groupLayerId ){
				if(typeof groupLayerIdBbox[layer.gpProperties.groupLayerId] == 'undefined'){
					groupLayerIdBbox[groupLayerId] = new google.maps.LatLngBounds();
				}

				//Extend the bounding box for this layer
				groupLayerIdBbox[groupLayerId].extend(layer.getBounds().getNorthEast());
				groupLayerIdBbox[groupLayerId].extend(layer.getBounds().getSouthWest())
			}
		}

		//Now for each layer that has a bounding box populate array of bboxes that will be used in search
		for(key in groupLayerIdBbox){
			var bounds = groupLayerIdBbox[key];

			var boundBox = {
				minLat: bounds.getSouthWest().lat(),
				maxLat: bounds.getNorthEast().lat(),
				minLng: bounds.getSouthWest().lng(),
				maxLng: bounds.getNorthEast().lng()
			}
			shapeBoundBoxes.push(boundBox);
		}

		//Set group layer Id so we only check for pois in this group of shapes being searched
		options.groupLayerId = params.groupLayerId;
	}

	//Add bound boxes to options
	options.shapeBoundBoxes = shapeBoundBoxes;

	//Show the data set section by 'clicking the back to search button'
	jQuery("#drawCancel").click();

	//Remove the center marker if it is not a record id.  if it is, set the options.recordId
	if (gp_centerPOI.recordId) {
		options.recordId = gp_centerPOI.recordId;
	} else if (params.searchType !== 'nearbyShape') {
		gp_removeCenterMarker();
		gp_centerPOI = {};
	}

	if (dataSet.refreshInterval) {
		options.refreshInterval = dataSet.refreshInterval;
	}

	// check whether cacheing new search, or reloading from cache
	if (dataSet && dataSet.searchContext) {
		if (dataSet.searchContext.reuse && dataSet.searchContext.options) {
			for (opt in dataSet.searchContext.options) {
				if (dataSet.searchContext.options.hasOwnProperty(opt)) {
					options[opt] = dataSet.searchContext.options[opt];
				}
			}
			if (dataSet.searchContext.layerSettings) {
				options.layerSettings = dataSet.searchContext.layerSettings;
			}
		}
		else {
			dataSet.searchContext.options = {
				refreshInterval:	options.refreshInterval,
				isAutoRefresh:		options.isAutoRefresh,
				groupLoad:			options.groupLoad,
				searchType:			options.searchType
			};

			if (options.searchType == 'nearbyShape') {
				dataSet.searchContext.options.range = options.range;
				dataSet.searchContext.options.radialCenterLat = options.radialCenterLat;
				dataSet.searchContext.options.radialCenterLng = options.radialCenterLng;
				dataSet.searchContext.options.nearbySearchUnits = options.nearbySearchUnits;
				dataSet.searchContext.options.nearbySearchDistanceUnits = options.nearbySearchDistanceUnits;
				dataSet.searchContext.options.calcDriveDistance = options.calcDriveDistance;
			}
		}
	}

	//Do the search and pass in the options
	gp_doSearch(options, callback);
	dataSet.searchContext.reuse = false;
}

var gp_polyEditListenerTimeout;
function gp_polyEditListener(overlay) {
	window.clearTimeout(gp_polyEditListenerTimeout);
	gp_polyEditListenerTimeout = setTimeout(function(poly) { return function() {
		gp_updateBoundsOnOverlay(poly);
		calcRecordsInShapes();
		calcDistanceInPolyline(poly);
		buildShapeInfoWindowHTML(poly);
		angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true}); 
	}; }(overlay), 250);
}

function gp_shapeAddedToMap(overlay,type){
	//Exit draw mode
	gp_exitDrawMode();

	//Create a gpProperties object if it does not exist
	if(typeof overlay.gpProperties == 'undefined'){
		overlay.gpProperties = {};
	}	

	//Calculate and set the bounds for this 
	gp_updateBoundsOnOverlay(overlay);

	//Create a unique Id for this overlay
	overlay.gpProperties.uniqueId = guid();

	//Create a group layer Id if one does not alreay exist
	if(typeof overlay.gpProperties.groupLayerId == 'undefined'){
		overlay.gpProperties.groupLayerId = guid();
	}

	//Set custom properties to empty string if they are null
	if(!overlay.gpProperties.sfdcName){
		overlay.gpProperties.sfdcName = '';
	}
	if(!overlay.gpProperties.sfdcDescription){
		overlay.gpProperties.sfdcDescription = '';
	}

	//Set type
	overlay.gpProperties.gpType = type.toLowerCase();

	//Specialy handling for shape fields
	if(!overlay.gpProperties.usageType){
		overlay.gpProperties.usageType = 'Standard';
		if(gp_mapMode == 'addShape'){
			overlay.gpProperties.usageType = 'Shape Field';

			//Set different color
			var controller = angular.element('.shapeFieldTypeController').scope();
			var color = controller.color;
			if(color.indexOf('#') != 0){
				color = '#' + color;
			}

			if ('polyline' == overlay.gpProperties.gpType) {
				overlay.setOptions({clickable: false, strokeColor: color, strokeOpacity: controller.opacity});
			}
			else {
				overlay.setOptions({clickable: false, fillColor: color, fillOpacity: controller.opacity});
			}

			//Set overlay in controller
			controller.overlay = overlay;
		}
	}

	//Add the polygon to the polygonObjects object to keep track of shapes on the map
	polygonObjects[overlay.gpProperties.uniqueId] = overlay;

	//Update record count in shapes
	calcRecordsInShapes();
	if ('polyline' == overlay.gpProperties.gpType) {
		if (google.maps.geometry) {
			calcDistanceInPolyline(overlay);
		}
		else {	// if polyline is first shape loaded, we may need to give google a chance to rev up
			setTimeout(function(poly) { return function() {
				calcDistanceInPolyline(poly);
				buildShapeInfoWindowHTML(poly);
			}; }(overlay), 500);
		}
	}
	buildShapeInfoWindowHTML(overlay);

	//Add event listener to the polygon overlay to open the infowindow popup bubble
	google.maps.event.addListener(overlay, 'click', function(e) {
		if (typeof e.vertex !== 'undefined' && overlay.getPath().length > 2) {
			overlay.getPath().removeAt(e.vertex);
			return;
		}

		// Get an array of shapes that contain the clicked point
		var shapesWithPoint = filterPolygonObjectsContainingPoint(e.latLng);

		if(shapesWithPoint.length < 2){
			showSingleShapeInfoWindow(e);

		}else{
			showMultiShapeInfoWindow(e, shapesWithPoint);
		}
	});

	function showSingleShapeInfoWindow(e, shape){
		var content = shape || overlay;
		// If the map is in measure distance mode, add point to ruler  may want to refactor this?
		if (gp_mapMode == 'measureDistance') {
			gp_rulerTool.addPinToRuler(e);
			return;
		}

		gp_infoWindow.setOptions({pixelOffset: {height: 0, width: 0}});
		gp_infoWindow.setContent(content.gpProperties.htmlContent);
		gp_infoWindow.setPosition(e.latLng);
		gp_infoWindow.open(gp_map);
	}

	function showMultiShapeInfoWindow(e, shapeArray){
		gp_infoWindow.setOptions({pixelOffset: {height: 0, width: 0}});
		gp_infoWindow.setContent('<div id="multiShapeInfoWindow" class="slds"><div style="font-weight: bold; font-size: 14px">Shapes</div></div>');
		gp_infoWindow.setPosition(e.latLng);
		gp_infoWindow.open(gp_map);

		function getShapeName(shape){
			return shape.gpProperties.geoShapeName || shape.gpProperties.sfdcName || 'Unnamed ' + shape.gpProperties.gpType.charAt(0).toUpperCase() + shape.gpProperties.gpType.slice(1);
		}

		// Alphabetical sort
		shapeArray.sort(function(a, b){
			return getShapeName(a).toLowerCase() > getShapeName(b).toLowerCase();

		// Append the links for each shape
		}).forEach(function(shape){
			jQuery(
				'<i class="fa fa-square" style="color: ' + (('polyline' == shape.gpProperties.gpType)? shape.strokeColor : shape.fillColor) + '"/> ' +
				'<a href="#">' + getShapeName(shape) + '</a>' + 
				'<br/>'
				).appendTo('#multiShapeInfoWindow').click(function(){
					showSingleShapeInfoWindow(e, shape);
				});
		});
	}

	function filterPolygonObjectsContainingPoint(latLng){
		return _.filter(polygonObjects, function(shape){
			//Only proceed with complex point in poly check if point is within the bounds of the overlay
			if(!shape.getMap()){
				return false;

			}else if(typeof shape.gpProperties.bounds === 'undefined' || !shape.gpProperties.bounds.contains(latLng)){
				return false;

			}else if(shape.gpProperties.gpType === 'circle'){ 
				var distanceFromCenterKM = getGeoDistance(shape.getCenter().lat(), shape.getCenter().lng(), latLng.lat(), latLng.lng(), 'kilometers');

				if (distanceFromCenterKM > shape.radius/1000)
					return false;

			}else if(shape.gpProperties.gpType === 'rectangle') {
				if (!shape.getBounds().contains(latLng))
					return false;
			} else if (shape.gpProperties.gpType === 'polyline') {
				// if we're in mouseover (i.e. color is darkened) or failing that if we're close to the polyline, return true
				if (shape.strokeColor == shape.gpProperties.originalColor && !google.maps.geometry.poly.isLocationOnEdge(latLng, shape, calcZoomTolerance()))
					return false;
			}else if(!google.maps.geometry.poly.containsLocation(latLng,shape)){
				return false;

			}

			return true;
		});
	}

	// Event listener for when circle changes
	if (overlay.gpProperties.gpType == 'circle') {
		google.maps.event.addListener(overlay, 'radius_changed', function() {
			gp_updateBoundsOnOverlay(overlay);
			calcRecordsInShapes();
		});
		google.maps.event.addListener(overlay, 'center_changed', function() {
			if (overlay.mapLabel) {
				overlay.mapLabel.position = overlay.center;
				overlay.mapLabel.setMap(overlay.gpProperties.showLabel? gp_map : null);
			}
			gp_updateBoundsOnOverlay(overlay);
			calcRecordsInShapes();
		});
	}
	
	if (overlay.gpProperties.gpType == 'rectangle') {
		google.maps.event.addListener(overlay, 'bounds_changed', function() {
			if (overlay.mapLabel) {
				overlay.mapLabel.position = overlay.bounds.getCenter();
				overlay.mapLabel.setMap(overlay.gpProperties.showLabel? gp_map : null);
			}
			gp_updateBoundsOnOverlay(overlay);
			calcRecordsInShapes();
		});
	}

	//Event listeners for when polygon shape changes
	google.maps.event.addListener(overlay, 'mousedown', function(e) {
		if(overlay.gpProperties.gpType == 'polygon' || overlay.gpProperties.gpType == 'polyline'){
			google.maps.event.addListener(overlay.getPath(), 'set_at', function() { return gp_polyEditListener(overlay); });
			google.maps.event.addListener(overlay.getPath(), 'insert_at', function() { return gp_polyEditListener(overlay); });
			google.maps.event.addListener(overlay.getPath(), 'remove_at', function() { return gp_polyEditListener(overlay); });
    	}
	});

	//http://stackoverflow.com/questions/5560248/programmatically-lighten-or-darken-a-hex-color-or-rgb-and-blend-colors
	function lightenDarkenHex(color, percent) {   
	    var f=parseInt(color.slice(1),16),t=percent<0?0:255,p=percent<0?percent*-1:percent,R=f>>16,G=f>>8&0x00FF,B=f&0x0000FF;
	    return "#"+(0x1000000+(Math.round((t-R)*p)+R)*0x10000+(Math.round((t-G)*p)+G)*0x100+(Math.round((t-B)*p)+B)).toString(16).slice(1);
	}

	//Event listen to change the color slightly on hover
	google.maps.event.addListener(overlay, 'mouseover', function(e) {
		if (undefined == overlay.gpProperties.originalOpacity)
			overlay.gpProperties.originalOpacity = parseFloat(overlay.fillOpacity || overlay.strokeOpacity);	// polyline has no fill
		if (undefined == overlay.gpProperties.originalColor)
			overlay.gpProperties.originalColor = (('polyline' == overlay.gpProperties.gpType)? overlay.strokeColor : overlay.fillColor);
		
		//Only set darker opacity if it is less or equal to 70
		var newOpacity = parseFloat(('polyline' == overlay.gpProperties.gpType)? overlay.strokeOpacity : overlay.fillOpacity);
		if(newOpacity <= .70) newOpacity += 0.20;

		var newColor = lightenDarkenHex((('polyline' == overlay.gpProperties.gpType)? overlay.strokeColor : overlay.fillColor), -0.2);

		if ('polyline' == overlay.gpProperties.gpType) {
			overlay.setOptions({strokeOpacity: newOpacity, strokeColor: newColor}); 
		}
		else {
			overlay.setOptions({fillOpacity: newOpacity, fillColor: newColor}); 
		}
	});

	google.maps.event.addListener(overlay, 'mouseout', function(e) {
		//For all polygons that are part of this layer change the color back to orginal before hover
		if ('polyline' == overlay.gpProperties.gpType) {
			overlay.setOptions({strokeOpacity: overlay.gpProperties.originalOpacity, strokeColor: overlay.gpProperties.originalColor}); 
		}
		else {
			overlay.setOptions({fillOpacity: overlay.gpProperties.originalOpacity, fillColor: overlay.gpProperties.originalColor}); 
		}
	});

	//Create a right click event listener on the shape to open the right click context menu
	google.maps.event.addListener(overlay, 'rightclick', function(e) {
		gp_openRigthClickMenu(e); //Open the right click menu
	});
}

function gp_updateBoundsOnOverlay(overlay){
	if (!overlay)  //getPaths() check makes sure it is a polygon and not a shape file server
		return;

	try{
		if (overlay.bounds) {
			overlay.gpProperties.bounds = overlay.bounds;
		} else if (overlay.getBounds) {
			overlay.gpProperties.bounds = overlay.getBounds();
		} else {
			var bounds = new google.maps.LatLngBounds();
		    var paths = overlay.getPaths();
		    var path;        
		    for (var i = 0; i < paths.getLength(); i++) {
		        path = paths.getAt(i);
		        for (var ii = 0; ii < path.getLength(); ii++) {
		            bounds.extend(path.getAt(ii));
		        }
		    }
		    overlay.gpProperties.bounds = bounds;
		}
	}catch(e){
		// Do something?
	}
}

function getShapeBubbleDistanceHtml(overlay) {
	var html = '<div id="shapeDistance" style="margin-bottom: 6px; font-size: 12px;">';
	html += '<div style="margin-bottom: 2px;"><span style="font-weight:bold;">Distance</span>: '
		if (gp_userDistanceUnit.startsWith('k')) {
			html += overlay.gpProperties.distance.metric;
		}
		else {
			html += overlay.gpProperties.distance.us;
		}
	html += '</div></div>';

	return html;
}

function getShapeBubbleRecordCountHtml(overlay){

	var html = '<div id="shapeRecordCounts" style="margin-bottom: 6px; font-size: 12px;">';

	var dataLayerService = angular.element('#dataLayerDirective').injector().get('dataLayerService');

	//Record Counts
	for(key in overlay.gpProperties.recordCounts){
		//Get the label
		var objectLablePlural = 'Selected Records';		// idArray markers won't have objectMeta available this way
		if (gp_objectMeta[key]) {
			objectLablePlural = gp_objectMeta[key].objectLablePlural;
		} else if (dataLayerService.dataLayerDefaults[key]) { 
			objectLablePlural = dataLayerService.dataLayerDefaults[key].label;
		}
		html += '<div style="margin-bottom: 2px;"><span style="font-weight:bold;">' + objectLablePlural + '</span>: ' + overlay.gpProperties.recordCounts[key] + '</div>';
	}

	//Aggregations
	for(key in overlay.gpProperties.aggregations){
		//Get the label
		var amount = overlay.gpProperties.aggregations[key].amount;
		var formattedAmount = angular.injector(["ng"]).get("currencyFilter")(amount,gp_userSettings.userInfo.userCurrency.symbol);

		//Append to html
		html += '<div style="margin-bottom: 2px;"><span style="font-weight:bold;">' + overlay.gpProperties.aggregations[key].label + '</span>: ' + formattedAmount + '</div>';
	}

	html += '</div>';

	return html;
}

function buildShapeInfoWindowHTML(overlay){

	//Only show delete button if record has sfdc id
	var deleteDisplay = 'none';
	if(overlay.gpProperties.sfdcId){
		deleteDisplay = '';
	}

	var html = '<div style="max-width:240px; min-width: 80px;" id="'+overlay.gpProperties.uniqueId+'">'+
				'<div id="shapeBubbleTitle" notranslate>';
				if(overlay.gpProperties.usageType == 'Shape Field' && overlay.gpProperties.gpPoiId){
	html+=			'<a href="#" onclick="gp_openPoiInfoMarker(\''+overlay.gpProperties.gpPoiId+'\',false); return false;">'+overlay.gpProperties.sfdcName+'</a>';    
				}else{
	html+=			'<div style="width: 200px;">'+overlay.gpProperties.sfdcName+'</div>';
				}
	html+=		'</div>';
	if (overlay.gpProperties.sfdcDescription) {
		html += '<div id="shapeBubbleDescription" notranslate>'+overlay.gpProperties.sfdcDescription.replace(/(?:\r\n|\r|\n)/g, '<br />')+'</div>';
	}
	if (overlay.gpProperties.subshapeName) {
		html += '<div id="shapeBubbleSubshape" notranslate>'+overlay.gpProperties.subshapeName.replace(/(?:\r\n|\r|\n)/g, '<br />')+'</div>';
	}
	html +=		'<div id="shapeRecordCountWrapper">';
				
					if((overlay.gpProperties.recordIdsInShape && overlay.gpProperties.recordIdsInShape.length > 0) || overlay.gpProperties.containsDataLayerMarker){
						html+= getShapeBubbleRecordCountHtml(overlay);
					}

	html+=		'</div>';

	html +=		'<div id="shapeDistanceWrapper">';
					if (overlay.gpProperties.distance && overlay.gpProperties.distance.totalM > 0) {
						html += getShapeBubbleDistanceHtml(overlay);
					}
	html +=		'</div>';

				//Don't show the shape actions if map mode is addShape 
				if(gp_mapMode != 'addShape' || overlay.gpProperties.sfdcId){
	html+=			'<div class="shapeEditButtons">'+
						'<span id="shapeActionsBtn" class="gpButton openMultiButtonOptions" onclick="showShapeActions(\''+overlay.gpProperties.uniqueId+'\');"/>'+
		                    '<div class="multiButtonInner multiButtonLeftLarge noRightBorder">'+
		                        'Actions'+
		                    '</div>'+
		                    '<div class="multiButtonInner multiButtonRightLarge">'+
		                        '<span class="ui-icon ui-icon-triangle-1-s" style="margin-top: 2px;"></span>'+
		                    '</div>'+
		                '</span>'+
					'</div>';
				}

				if(overlay.gpProperties.usageType != 'Shape Field' && overlay.gpProperties.usageType != 'GeoShape'){			
	html+=		    '<div style="height: 165px; margin-left: 4px;" class="gp_ShapeColorDiv"><input type="text" class="gp_shapeColorInput" data-shapeId="'+overlay.gpProperties.uniqueId+'" data-groupLayerId="'+overlay.gpProperties.groupLayerId+'" value="E7DC40" id="shapeColor'+overlay.gpProperties.uniqueId+'"/></div>'+
					'<style>.gp_ShapeColorDiv .minicolors-theme-geopointe .minicolors-panel{top: 4px}</style>'+
					'</div>';	
				}


	overlay.gpProperties.htmlContent = html;
}

function showShapeActions(shapeId){
	//Get the shape
	var shape = polygonObjects[shapeId];

	var $shapeActionBtn = jQuery("#shapeActionsBtn");
	var actionButtonOffset = $shapeActionBtn.offset();

	//Only show delete button if record has sfdc id, TODO remove this, moved to edit modal
	var deleteDisplay = 'none';
	if(shape.gpProperties.sfdcId){
		deleteDisplay = '';
	}

	//Determine if this is a multi part shape, ie one layer consisting of many sub shapes
	var subShapeCount = 0;
	var multiPartShape = false;
	for(key in polygonObjects){
		if(shape.gpProperties.groupLayerId == polygonObjects[key].gpProperties.groupLayerId){
			subShapeCount++;
		}
		if(subShapeCount > 1){
			multiPartShape = true;
			break;
		}
	}

	//Remove action menu element already exists
	jQuery(".shapeActionMenu").remove();

	var saveMethod = 'gp_saveShape';
	if(shape.gpProperties.usageType == 'GeoShape') saveMethod = 'gp_editShape';

	var htmlString = '<div class="multiButtonContent shapeActionMenu">';
						if(multiPartShape){
	htmlString+=			'<div class="multiButtonOptionHeader">'+shape.gpProperties.sfdcName+'</div>';
						}
	
						if(shape.gpProperties.usageType == 'GeoShape'){
	htmlString+=       		'<div class="multiButtonOption" onclick="angular.element(\'#ShapeSearchDataSetSelectorController\').scope().openSelector({groupLayerId: \''+shape.gpProperties.groupLayerId+'\'}); return false;">'+
	                        	'<span class="multiButtonOptionText">'+
	                            	gp_translations.Search+
	                        	'</span>'+   
	                    	'</div>';
						}else{
	htmlString+=       		'<div class="multiButtonOption" onclick="angular.element(\'#ShapeSearchDataSetSelectorController\').scope().openSelector({overlayId: \''+shape.gpProperties.uniqueId+'\'}); return false;">'+
	                        	'<span class="multiButtonOptionText">'+
	                            	gp_translations.Search+
	                        	'</span>'+   
	                    	'</div>';
						}
	htmlString+=        '<div class="multiButtonOption" onclick="gp_removeShape(\''+shape.gpProperties.uniqueId+'\'); return false;">'+
	                        '<span class="multiButtonOptionText">'+
	                            gp_translations.Remove+
	                        '</span>'+   
	                    '</div>'+
	                    '<div class="multiButtonOption" onclick="gp_editShape(\''+shape.gpProperties.uniqueId+'\'); return false;">'+
	                        '<span class="multiButtonOptionText">'+
	                            gp_translations.Edit+
	                        '</span>'+   
	                    '</div>';
	                    if(shape.gpProperties.usageType != 'Shape Field'){
							if(shape.gpProperties.usageType != 'GeoShape' && (isGeopointeAdmin || shape.gpProperties.folderId == 'personal' || !shape.gpProperties.sfdcId || (shape.gpProperties.sfdcId && shape.gpProperties.folderAccessLevel == 'edit'))) {
	htmlString+=        		'<div class="multiButtonOption" onclick="'+ saveMethod +'(\''+shape.gpProperties.uniqueId+'\'); return false;">'+
		                        	'<span class="multiButtonOptionText">'+
		                            	gp_translations.Save+
		                        	'</span>'+   
		                    	'</div>';
							}

							if(shape.gpProperties.usageType != 'GeoShape' && shape.gpProperties.sfdcId) {
	htmlString+=        		'<div class="multiButtonOption" onclick="'+ saveMethod +'(\''+shape.gpProperties.uniqueId+'\',true); return false;">'+
		                        	'<span class="multiButtonOptionText">Save As</span>'+   
	                    		'</div>';
							}
		                    
	/*	                    if(shape.gpProperties.sfdcId && shape.gpProperties.usageType != 'GeoShape' &&){
	htmlString+=	        	'<div class="multiButtonOption" onclick="window.open(\'/p/share/CustomObjectSharingDetail?parentId='+shape.gpProperties.sfdcId+'\'); return false;">'+
			                        '<span class="multiButtonOptionText">'+
			                            'Sharing'+
			                        '</span>'+   
			                    '</div>';
		                	}*/
						}

						if(shape.gpProperties.usageType != 'GeoShape' && (isGeopointeAdmin || shape.gpProperties.folderId == 'personal' || !shape.gpProperties.sfdcId || (shape.gpProperties.sfdcId && shape.gpProperties.folderAccessLevel == 'edit'))){	
	htmlString+=        	'<div class="multiButtonOption" onclick="gp_deleteShapeConfirm(\''+shape.gpProperties.uniqueId+'\'); return false;" style="display: '+deleteDisplay+';" >'+
		                        '<span class="multiButtonOptionText">'+
		                            gp_translations.Delete+
		                        '</span>'+   
		                    '</div>';
	                	}


	//Build html for custom list actions
	var actionsHTML = getCustomShapeActionsHTML(shape,shape.gpProperties.groupLayerId);
	
	//If there were custom actions add to list of options
	if(actionsHTML != ''){
		htmlString += '<hr/>'+actionsHTML;
	}

	//If this was a multipart shape build actions specific to the sub shape that was selected
	if(multiPartShape){
		htmlString += '<div class="multiButtonOptionHeader">'+shape.gpProperties.geoShapeName+'</div>';
		htmlString+=  '<div class="multiButtonOption" onclick="angular.element(\'#ShapeSearchDataSetSelectorController\').scope().openSelector({overlayId: \''+shape.gpProperties.uniqueId+'\'}); return false;">'+
	                        '<span class="multiButtonOptionText">'+
	                            gp_translations.Search+
	                        '</span>'+   
	                    '</div>'
		if (_.find(gp_layers, ['dataType', 'zoominfo'])) {
			htmlString += '<div class="multiButtonOption" onclick="angular.element(\'#modalListDirective\').scope().initFromOverlay(\'zoominfo\', {overlayId: \''+shape.gpProperties.uniqueId+'\'}, \'Companies\'); return false;">' +
			'<span class="multiButtonOptionText">' +
			'Import Companies' +
			'</span>' +
			'</div>';
		}
		htmlString += '<div class="multiButtonOption" onclick="gp_removeSubShape(\''+shape.gpProperties.uniqueId+'\'); return false;"">'+
	                        '<span class="multiButtonOptionText">'+
	                            gp_translations.Remove+
	                        '</span>'+   
	                    '</div>';
		
	    var actionsHTML = getCustomShapeActionsHTML(shape,shape.gpProperties.uniqueId);
	
		//If there were custom actions add to list of options
		if(actionsHTML != ''){
			htmlString += '<hr/>';
			htmlString += actionsHTML;
		}
	}

	htmlString += '</div>';

   	gp_disableMultiButtonContentClose = true;
    jQuery(htmlString).appendTo('body').show().css({top: actionButtonOffset.top + $shapeActionBtn.outerHeight() , left: actionButtonOffset.left  });
    setTimeout(function(){
    	gp_disableMultiButtonContentClose = false;	
    },1);
}

function getCustomShapeActionsHTML(shape,shapeId){

	var objects = {}; //Use object keys to keep unique list of map objects
	var actionsHTML = '';

	//Build a list off objects in which we should build the action list for
	for(key in shape.gpProperties.recordCounts){
		objects[key] = true;
	}

	//Loop through all of the geopointe actions
	for(var i = 0; i < getOrderedActionsArray().length; i++){
		var action = getOrderedActionsArray()[i];
		var actionObjects;
		if(action.mapObjects){
			actionObjects = action.mapObjects.split(',');
		}
		var actionValidForObjects = false;

		//Check to see if this action should be applied to any of the data set searches based on the map object
		for(key in objects){
			if(actionObjects.indexOf(key) > -1){
				actionValidForObjects = true;
				break;
			}
		}

		//Only build an action if it is for all objects or one of the searched objects
		if(action.applyTo == 'List' && (action.allObjects == true || actionValidForObjects == true) ){

			if(action.standardAction){
				if(action.standardAction.toLowerCase() == 'add all to route'){
					actionsHTML += '<div class="multiButtonOption" onclick="gp_addAllToRoute(extractIdsInShape(\''+shapeId+'\'));">'+
				                        '<span class="multiButtonOptionText">'+action.name+'</span>'+   
				                    '</div>';

				}else if(action.standardAction.toLowerCase() == 'add to campaign'){
					actionsHTML += '<div class="multiButtonOption" onclick="gp_trackAddToCampaign(); executeShapePOSTAction(\''+action.id+'\',\''+shapeId+'\');">'+
				                        '<span class="multiButtonOptionText">'+action.name+'</span>'+   
				                    '</div>';

				}else if(action.standardAction.toLowerCase() == 'change owner'){
					actionsHTML += '<div class="multiButtonOption" onclick="gp_trackChangeOwner(); executeShapePOSTAction(\''+action.id+'\',\''+shapeId+'\');">'+
				                        '<span class="multiButtonOptionText">'+action.name+'</span>'+   
				                    '</div>';

				}else if(action.standardAction.toLowerCase() == 'update field'){
					actionsHTML += '<div class="multiButtonOption" onclick="gp_trackUpdateField(); executeShapePOSTAction(\''+action.id+'\',\''+shapeId+'\');">'+
				                        '<span class="multiButtonOptionText">'+action.name+'</span>'+   
				                    '</div>';

				}else if(action.standardAction.toLowerCase() == 'export csv' && gp_userSettings.userInfo.exportReports){
					actionsHTML += '<div class="multiButtonOption" onclick="executeShapePOSTAction(\''+action.id+'\',\''+shapeId+'\');">'+
				                        '<span class="multiButtonOptionText">'+action.name+'</span>'+   
				                    '</div>';

				}else if(action.standardAction.toLowerCase() == 'export kml' && gp_userSettings.userInfo.exportReports){
					actionsHTML += '<div class="multiButtonOption" onclick="executeShapePOSTAction(\''+action.id+'\',\''+shapeId+'\');">'+
				                        '<span class="multiButtonOptionText">'+action.name+'</span>'+   
				                    '</div>';
				
				}else if(action.standardAction.toLowerCase() == 'import business'){
					if (!_.find(gp_layers, ['dataType', 'zoominfo'])) continue;
					var shapeReference = {};
					if (shape.gpProperties.uniqueId === shapeId) {
						shapeReference.overlayId = shapeId;
					} else {
						shapeReference.groupLayerId = shapeId;
					}
					actionsHTML += '<div class="multiButtonOption" onclick="angular.element(\'#modalListDirective\').scope().initFromOverlay(\'zoominfo\', ' + JSON.stringify(shapeReference).replace(/"/g, '\'') + ', \'Companies\'); return false;">' +
						'<span class="multiButtonOptionText">'+action.name+'</span>'+   
					'</div>';
				}

			}else if(action.actionType == 'Apex'){
				//Custom actions				
				actionsHTML += '<div class="multiButtonOption" onclick="executeShapeApexAction(\''+action.id+'\',\''+shapeId+'\');">'+
			                        '<span notranslate class="multiButtonOptionText">'+action.name+'</span>'+   
			                    '</div>';

			}else if(action.actionType == 'POST (Visualforce)'){
				actionsHTML += '<div class="multiButtonOption" onclick="executeShapePOSTAction(\''+action.id+'\',\''+shapeId+'\');">'+
			                        '<span notranslate class="multiButtonOptionText">'+action.name+'</span>'+   
			                    '</div>';
			}
		}
	}

	return actionsHTML;
}

function gp_editShape(uniqueId){
	
	//Get the shape
	var overlay = polygonObjects[uniqueId];

	//Unique Id may have been a groupingId for a geoshape, try to find overlay with this
	if(!overlay){
		for(key in polygonObjects){
			if(polygonObjects[key].gpProperties.groupLayerId == uniqueId){
				overlay = polygonObjects[key];
				break;
			}
		}
	}

	if(overlay.gpProperties.usageType == 'GeoShape'){
		//Setup the geo shape controller
		var controller = angular.element('#visualGeoShapeEditor').scope();

		controller.isEdit = true;
		controller.sfdcId = overlay.gpProperties.sfdcId;
		controller.groupLayerId = overlay.gpProperties.groupLayerId;
		controller.uniqueId = uniqueId;
		controller.layerName = overlay.gpProperties.sfdcName;
		controller.layerDescription = overlay.gpProperties.sfdcDescription;
		controller.layerNameBeforeSave = overlay.gpProperties.sfdcName;
		controller.folderId = overlay.gpProperties.folderId;
		controller.accessLevel = overlay.gpProperties.accessLevel;
		controller.folderName = overlay.gpProperties.folderName;
		controller.color = ('polyline' == overlay.gpProperties.gpType)? overlay.strokeColor : overlay.fillColor;
		controller.dissolve = overlay.gpProperties.dissolve;
		controller.opacity = ('polyline' == overlay.gpProperties.gpType)? overlay.strokeOpacity : overlay.fillOpacity;
		controller.usedInAssignments = overlay.gpProperties.usedInAssignments;
		controller.selectedGeoShapes = {};
		controller.originalShapes = {};
		controller.initList = true;
		controller.showLabel = overlay.gpProperties.showLabel;
		controller.$broadcast('resetGeoShapeSelector');

		//If overlay contains geoshape Id and name, no need to fetch these from API, rebuild the geoshapes
		if(overlay.gpProperties.geoShapeId && overlay.gpProperties.geoShapeName && overlay.gpProperties.geoShapeType){
			//Loop through all the polygon overlay objects
			for(key in polygonObjects){
				
				var thisOverlay = polygonObjects[key];

				//If this polygon is part of the larger shape add it to list of selected geo shapes
				if(thisOverlay.gpProperties.groupLayerId == overlay.gpProperties.groupLayerId){
					var shape = {
						id: thisOverlay.gpProperties.geoShapeId,
						name: thisOverlay.gpProperties.geoShapeName,
						type: thisOverlay.gpProperties.geoShapeType
					};

					controller.addShapeById(shape, true);

					// controller.selectedGeoShapes[thisOverlay.gpProperties.geoShapeId] = {
					// 	id: thisOverlay.gpProperties.geoShapeId,
					// 	name: thisOverlay.gpProperties.geoShapeName,
					// 	type: thisOverlay.gpProperties.geoShapeType
					// }
				}
			}
		}

		//If shape was dissolved populate list of selectedGeoShapes
		if(overlay.gpProperties.dissolve){
			for(var i = 0; i < overlay.gpProperties.subShapes.length; i++){

				var subShape = overlay.gpProperties.subShapes[i];

				controller.addShapeById(subShape, true);

				// controller.selectedGeoShapes[subShape.id] = {
				// 	id: subShape.id,
				// 	name: subShape.name,
				// 	type: subShape.type
				// }
			}
		}

		// controller.originalShapes = _.cloneDeep(controller.selectedGeoShapes);

		//Execute apply on the controller so UI updates as this is outsite scope of angular
		// setTimeout(function(){
		// 	controller.$apply();
		// },0);
		
		openAddLayer('GeoShape');
		// var title = 'Edit Shape - ' + overlay.gpProperties.sfdcName;
		// var height = overlay.gpProperties.usedInAssignments ? 638 : 600; 

		// jQuery( "#geoShapeModal" ).dialog({
		// 	height: height,
		// 	width: 800,
		// 	modal: true,
		// 	title: title,
		// 	resizable: false,
		// 	draggable: false,
		// 	dialogClass: 'dataSetEditModalWrapper gp-modal',
		// 	open: function( event, ui ) {
		// 		//Set height of modal content
		// 		setGPmodalContentHeight(jQuery(this));
		// 	}
		// });
	
	}else if(overlay.gpProperties.usageType == 'Shape Field'){

		gp_mapMode = 'addShape';
		jQuery('#mapContextMenu').hide();
		jQuery('.drawingControls').hide();
		gp_infoWindow.setMap(null); //Hide the open info window

		//Setup the angular controller by passing over data
		var controller = angular.element('.shapeFieldTypeController').scope();
		controller.isEdit = true;
		controller.sfdcId = overlay.gpProperties.sfdcId;
		controller.gpCollectionName = overlay.gpProperties.gpCollectionName;
		controller.recordName = overlay.gpProperties.relatedRecordName;
		controller.relatedRecordId = overlay.gpProperties.relatedRecordId;
		controller.selectedShapeField = {name: overlay.gpProperties.relatedRecordFieldName, label: overlay.gpProperties.relatedRecordFieldLabel};
		controller.shapeDescription = overlay.gpProperties.sfdcDescription;
		controller.allShapeFieldsPopulated = false;
		controller.noShapeFields = false;
		controller.color = ('polyline' == overlay.gpProperties.gpType)? overlay.strokeColor : overlay.fillColor;
		controller.opacity = ('polyline' == overlay.gpProperties.gpType)? overlay.strokeOpacity : overlay.fillOpacity;
		controller.dissolve = overlay.gpProperties.dissolve;
		controller.showLabel = overlay.gpProperties.showLabel;
		controller.overlay = overlay;
		controller.centerLatLng = {lat: overlay.gpProperties.recordLat, lng: overlay.gpProperties.recordLng};
		controller.selectedGeoShapes = {};
		controller.initGeoShapeList = true;
		controller.enteringEditMode = true;
		controller.$broadcast('resetGeoShapeSelector');

		if(overlay.gpProperties.gpType){
			controller.shapeType = overlay.gpProperties.gpType.toLowerCase();

			if(overlay.gpProperties.gpType.toLowerCase() == 'polygon' || overlay.gpProperties.gpType.toLowerCase() == 'polyline'){
				overlay.setOptions({editable:true});
				controller.range = 5;//default to 5 if user switch from circle to polygon
				controller.centerLatLng = {lat: overlay.gpProperties.recordLat, lng: overlay.gpProperties.recordLng}; //Set center as record 
			
			}else if(overlay.gpProperties.gpType.toLowerCase() == 'circle'){
				controller.range = overlay.gpProperties.range;
				overlay.setEditable(true);
				controller.addCenterListener(overlay);
				controller.addRadiusListener(overlay);
				controller.centerLabel = controller.recordName;
				if (controller.isCenterAtRecord(overlay)) {
					controller.centerLabel = controller.recordName;
				} else {
					controller.centerLabel = overlay.gpProperties.centerLabel;
				}
			}else if(overlay.gpProperties.gpType.toLowerCase() == 'geoshape'){

				// Subshape info is stored/retrieved differently depending on whether shape is dissolved
				if (controller.dissolve) {
					var subshapes = overlay.gpProperties.subShapes;
					for (var i = 0, last = subshapes.length; i < last; i++) {
						controller.selectedGeoShapes[subshapes[i].id] = {
							id: subshapes[i].id,
							name: subshapes[i].name,
							type: subshapes[i].type
						}						
					}
				} else {
					//Loop through all the polygon overlay objects and populate the selected shapes array in the shapeFieldTypeController
					for(key in polygonObjects){
						
						var thisOverlay = polygonObjects[key];

						//If this polygon is part of the larger shape add it to list of selected geo shapes
						if(thisOverlay.gpProperties.groupLayerId == overlay.gpProperties.groupLayerId){
							controller.selectedGeoShapes[thisOverlay.gpProperties.geoShapeId] = {
								id: thisOverlay.gpProperties.geoShapeId,
								name: thisOverlay.gpProperties.geoShapeName,
								type: thisOverlay.gpProperties.geoShapeType
							}
						}
					}
				}
			}
		}
		
		if(overlay.gpProperties.units == 'Miles'){
			controller.rangeUnits = 'm';
		}else if(overlay.gpProperties.units == 'Kilometers'){
			controller.rangeUnits = 'k';
		}

		setTimeout(function(){
			controller.$apply();
		},0);

		jQuery('.mapControlsWrapper').hide(); //Hide the map controls, TODO this needs to be a smart function
		jQuery('#addShapeFieldShape').show(); //Show the box explaining add shape mode

	}else{

		//If shape is used in Assignment plans show a warning.
		if(overlay.gpProperties.usedInAssignments == true){
			alert('This Shape is used in Geopointe Assignment Plans. Modifiying it may affect geographic assignment of records to this shape.');
		}

		//Make shape editable
		overlay.setOptions({editable:true});
		
		//Hide the info window
		gp_infoWindow.setMap(null);
	}
}

function gp_editGeoShape(shape){
	var controller = angular.element('#visualGeoShapeEditor').scope();
	controller.isEdit = true;
	controller.sfdcId = shape.sfdcId;
	controller.layerName = shape.name;
	controller.layerDescription = shape.description;
	controller.layerNameBeforeSave = shape.name;
	controller.folderId = shape.folderId;
	controller.accessLevel = shape.accessLevel;
	controller.folderName = shape.folderName;
	controller.color = shape.color;
	controller.dissolve = shape.dissolve;
	controller.opacity = shape.opacity;
	controller.selectedGeoShapes = {};
	controller.originalShapes = {};
	controller.initList = true;
	controller.showLabel = shape.showLabel;
	controller.$broadcast('resetGeoShapeSelector');

	Visualforce.remoting.Manager.invokeAction(gpRemoteAction,'Map_Controller.getShapeLatLng',{shapeId: shape.sfdcId},function(result, event){
		if (event.status) {
			result = JSON.parse(result);
			controller.usedInAssignments = result.usedInAssignments;
			geoShapeIds = JSON.parse(result.coordinates);
			geoShapeIds.forEach(function(id){
				controller.addShapeById({id: id}, true);
			});
			openAddLayer('GeoShape');
		}
	},
		{escape: false}
	);
}

function gp_saveShape(uniqueId,isSaveAs){
	//Get the shape from the polygonObjects object
	var polygon = polygonObjects[uniqueId];

	//Set isSaveAs to false if it is undefined, Javascript rempoting requiers false value
	if(!isSaveAs) isSaveAs = false;

	var title = 'Save';
	if(isSaveAs){
		title = 'Save As';
	}
	if(polygon.gpProperties.sfdcName){
		title += ' - <span notranslate>' + polygon.gpProperties.sfdcName + '</span>';
	}

	//Get access to the Folder Service
	var folderService = angular.element('.dataSetController').injector().get('folderService');
	
	folderService.getFolders(function(folders){
		var saveFolderId = polygon.gpProperties.folderId;

		if (!polygon.gpProperties.folderId || polygon.gpProperties.accessLevel === 'read') {
			saveFolderId = folderService.getPersonalFolder().id;
		}

		var foldersHtml = '<a class="modal-style" id="gp_saveShapeFolderId" data-id="' + saveFolderId + '">' + folderService.getFolderNameById(saveFolderId) + '</a>';

		var buttonText = 'Save';
		if(isSaveAs) buttonText = 'Save As';

		var body = gp_translations.Enter_a_Name_and_Short_Description_for_the_shape +'<br/>'+
					'<table>'+
					'<tr><td class="saveShapeLabel">'+gp_translations.Name+'</td><td><input type="text" value="'+polygon.gpProperties.sfdcName+'" id="gp_saveShapeName"/></td></tr>'+
					'<tr><td class="saveShapeLabel">Folder</td><td>'+foldersHtml+'</td></tr>'+
					'<tr><td class="saveShapeLabel">Show Label</td><td><input type="checkbox" id="gp_saveShapeShowLabel"/></td></tr>' +
					'<tr><td class="saveShapeLabel alignTop">'+gp_translations.Description+'</td><td><textarea maxlength="255" style="height: 50px; width: 200px;" id="gp_saveShapeDescription">'+polygon.gpProperties.sfdcDescription+'</textarea></td></tr>'+
					'</table>';

		//Remove any existing save dialogs
		jQuery('.gpSaveDialog').remove();

		jQuery('<div class="gpSaveDialog"></div>')
			.append('<p>'+body+'</p>')
			.dialog({
				modal: true, 
				draggable: false, 
				width: '515px', 
				title: title, 
				position: { my: "bottom", at: "center", of: window },
				open: function() {
			      	//Create Enter event listner
			      	jQuery('#gp_saveShapeName').keypress(function(e) {
					    if (e.keyCode == 13) {
					    	//Click the first button in this modal, which is the OK button
					    	jQuery(this).parents(".ui-dialog").find("button").first().click();
					    }
					});	

			      	// set up to handle labels
					jQuery("#gp_saveShapeShowLabel").attr('checked', polygon.gpProperties.showLabel? true : false);
					'dragend'

					//If save as, wipe out input field for name
					if(isSaveAs) jQuery("#gp_saveShapeName").val('');	      	
			    },

			    buttons:[{text: buttonText, 
			    			click: function(){ 
			    		   		var name = jQuery("#gp_saveShapeName").val();	
			    		   		var description = jQuery("#gp_saveShapeDescription").val();		
			    		   		var folderId = jQuery("#gp_saveShapeFolderId").attr('data-id');	
								var showLabel = jQuery("#gp_saveShapeShowLabel").is(':checked');

								if(folderId === 'nofolder'){
									return gp_alert('Folder name field is required.');
								}

			    				//Proceed if name was supplied
			    		   		if(name){

			    		   			//Close this dialog
									jQuery( this ).remove();

									geopointeAjaxStart('body',gp_translations.Saving_Shape+'...');
									
									//Build a shape object to save
									var shapeToSave = {
										sfdcId: polygon.gpProperties.sfdcId,
										name: name,
										folderId: folderId,
										saveAsFolderId: isSaveAs? folderId : null,
										saveAsName: isSaveAs ? name : null,
										description: description,
										usageType: 'Standard',
										color: ('polyline' == polygon.gpProperties.gpType)? polygon.strokeColor : polygon.fillColor,
										opacity: ('polyline' == polygon.gpProperties.gpType)? polygon.strokeOpacity : polygon.fillOpacity,
										showLabel: showLabel
									};

									if (polygon.gpProperties.gpType == 'circle') {
										shapeToSave.type = 'Circle';
										shapeToSave.coordinates = '';
										shapeToSave.centerLat = polygon.getCenter().lat();
										shapeToSave.centerLng = polygon.getCenter().lng();
										shapeToSave.radius = polygon.getRadius() / 1000;
										shapeToSave.units = 'Kilometers';

										shapeToSave.labelPointLat = shapeToSave.centerLat;
										shapeToSave.labelPointLng = shapeToSave.centerLng;

									} else if (polygon.gpProperties.gpType == 'rectangle') {
										shapeToSave.type = 'Rectangle';

										// Build a string with SW coords and NE coords - code based on shapeFieldTypeController.js
										var coords = [];
										var sw = polygon.getBounds().getSouthWest();
										var ne = polygon.getBounds().getNorthEast();

										// Following geoJSON structure so store lng first.
										coords.push([Number(Math.round(sw.lng()+'e'+6)+'e-'+6), Number(Math.round(sw.lat()+'e'+6)+'e-'+6)]);
										coords.push([Number(Math.round(ne.lng()+'e'+6)+'e-'+6), Number(Math.round(ne.lat()+'e'+6)+'e-'+6)]);

										shapeToSave.coordinates = JSON.stringify([coords]);

										var eastEnd = ne.lng() + (sw.lng() > ne.lng()? 360 : 0);
										var westEnd = sw.lng();
										var midLng = (westEnd + eastEnd) * 0.5;
										shapeToSave.labelPointLat = (sw.lat() + ne.lat()) * 0.5;
										shapeToSave.labelPointLng = midLng - (midLng > 180? 360 : 0);
									} else {
										var isPolyline = ('polyline' == polygon.gpProperties.gpType);
										shapeToSave.type = isPolyline? 'Polyline' : 'Polygon';

										//Build a string of lng lat coordinates - code copied from shapeFieldTypeController.js
										var coords = [];

										polygon.getPath().forEach(function(e,i){
											var point = [];

											//Following geoJSON structure so store lng first.
											point.push(Number(Math.round(e.lng()+'e'+6)+'e-'+6));
											point.push(Number(Math.round(e.lat()+'e'+6)+'e-'+6));
											coords.push(point);
										});

										//Following geoJSON spec for polygon, the last point needs to match the first
										if (!isPolyline && (coords[0][0] != coords[coords.length-1][0] || coords[0][1] != coords[coords.length-1][1]))
											coords.push([coords[0][0],coords[0][1]]);

										shapeToSave.coordinates = JSON.stringify([coords]);

										if (shapeToSave.showLabel) {
											var labelPoint;
											if (isPolyline) {
												var midPt = Math.floor(coords.length / 2);
												labelPoint = { 'lat': coords[midPt][1], 'lng': coords[midPt][0] };
											}
											else {
												var polyFeature = turf.polygon([coords]);
												var useLabelPoint = turf.pointOnSurface(polyFeature);
												labelPoint = { lat: useLabelPoint.geometry.coordinates[1], lng: useLabelPoint.geometry.coordinates[0] };
											}
											shapeToSave.labelPointLat = labelPoint.lat;
											shapeToSave.labelPointLng = labelPoint.lng;
										}

										//Uncomment following line to create encoded data for testing
										//shapeToSave.coordinates = google.maps.geometry.encoding.encodePath(polygon.getPath());
									}

									// Save the shape
									Visualforce.remoting.Manager.invokeAction(gpRemoteAction,'ShapeRemotes.save',{shapeJSON: JSON.stringify(shapeToSave), isSaveAs: isSaveAs},function(result, event){ 
        								result = JSON.parse(result);

										if (event.status) { //Success
											var shapeService = angular.element('.dataSetController').injector().get('shapeService');
											
											//Update the object stored in polygonObjects
											polygon.gpProperties.sfdcName = name;
											polygon.gpProperties.folderId = folderId;
											polygon.gpProperties.sfdcDescription = description;
											polygon.gpProperties.sfdcId = result.sfdcId;
											polygon.gpProperties.showLabel = result.showLabel;

											polygon.centroid = { lat: result.labelPointLat, lng: result.labelPointLng };

											// remove any old label
											if (polygon.mapLabel)
												polygon.mapLabel.setMap(null);

											if (polygon.gpProperties.showLabel) {
												polygon.mapLabel = shapeService.createShapeMapLabel(name, polygon.centroid);
												polygon.mapLabel.setMap(gp_map);

												// mapPane will be behind polygons unless its Canvas is lifted
												jQuery(polygon.mapLabel.getPanes().mapPane).css('z-index', polygon.mapLabel.zIndex);  // is this necessary?
											}

					                    	//Update the html for the shape bubble
					                    	buildShapeInfoWindowHTML(polygon);

											//Turn off edit mode
											polygon.setOptions({editable:false});

											//Update info window content
											gp_infoWindow.setContent(polygon.gpProperties.htmlContent);

											geopointeAjaxEnd();

											//Update the list of shapes
											if(isSaveAs){
												shapeService.shapes.push(result);
											}else{
												var index = _.findIndex(shapeService.shapes, function(shape){
													return shape.sfdcId === result.sfdcId;
												});
												if(index === -1){
													shapeService.shapes.push(result);
												}else{
													shapeService.shapes[index] = result;
												}
											}

											//Broadcast events to update the shape folder lists
											angular.element('.dataSetController').scope().$broadcast('folderListChanged'); 

											//Notify shape layer controller that layers on map changed
											angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true});
										} else {
											//Error handling
											var message = {
												severity: 'ERROR',
												message: 'Uh oh. Something didn\'t work quite right. If this error continues please contact Geopointe support. '+ event.message
											};
											updatePageMessages([message]);
											gp_track('Error', {'Language': 'JavaScript', 'Type':'Remoting', 'Function':'saveShape', 'Message':event.message});

											geopointeAjaxEnd();
										}
									},
										{escape: false}
									);
								}	
			    			} 
			    		},
			    		{text: gp_translations.Cancel, 
			    			click: function(){ 
			    		   		jQuery( this ).remove(); 
			    			} 
			    		}] 
		});

		jQuery('#gp_saveShapeFolderId').on('click', function () {
			angular.element('#main-folder-list').scope().openFolderSelect()
				.then(function (parentFolder) {
					jQuery('#gp_saveShapeFolderId').text(parentFolder.name);

					jQuery('#gp_saveShapeFolderId').attr('data-id', parentFolder.id);
				});
		});
	});//End get folders from folder services
}

function gp_addShapeToMap(shape, callback, isFolderAddShapesToMap){

	//Check to see if shape is already on the map
	for(key in polygonObjects){
		if(shape.sfdcId == polygonObjects[key].gpProperties.sfdcId){
			//geopointeAjaxEnd();
			
			gp_bounds = polygonObjects[key].getBounds();

			//Readjust the map
			if(!isFolderAddShapesToMap) gp_centerZoom();

			if(callback) callback();

			return;
		}
	}

	//Shape was not already on the map, add it
	gp_addShapeIdToMap(shape.sfdcId, callback, isFolderAddShapesToMap);
}

function gp_addShapeIdToMap(sfdcShapeId,callback,isFolderAddShapesToMap){

	//Get the shape coordinates
	Visualforce.remoting.Manager.invokeAction(gpRemoteAction,'Map_Controller.getShapeLatLng',{shapeId: sfdcShapeId},function(result, event){
		if (event.status) {
			result = JSON.parse(result);

			if (!result.color)  // If no color, set default color
				result.color = '#00C414';
			else if (result.color.indexOf('#') != 0)  //Make sure color starts with #
				result.color = '#' + result.color;
			
			if (!result.opacity)
				result.opacity = 0.4;

			//Special handing for Geo Shapes
			if(result.usageType == 'GeoShape' || (result.usageType == 'Shape Field' && result.type == 'MultiPolygon')){
				
				//Set user the Angular geoShapeService to add shapes to the map
				var geoShapeControllerElement = angular.element('.geoShapeController');
				var injector = geoShapeControllerElement.injector();
				var geoShapeService = injector.get('geoShapeService');

				//Build a list of Geo Shape URLs that should be used to add shapes to the map
				var geoShapeIds = JSON.parse(result.coordinates);

				geoShapeService.GETgeoShapes({
					addToMap: true,
					color: result.color,
					opacity: result.opacity,
					dissolve: result.dissolve,
					layerName: result.name,
					layerDescription: result.description,
					sfdcId: result.sfdcId,
					folderId: result.folderId,
					folderAccessLevel: result.folderAccessLevel,
					folderName: result.folderName,
					usedInAssignments: result.usedInAssignments,
					shapeIds: geoShapeIds,
					isFolderAddShapesToMap: isFolderAddShapesToMap,
					showLabel: result.showLabel,
					onComplete: function(result){
						
						//Zoom and fit map to shape
						gp_bounds = new google.maps.LatLngBounds();

						for(key in polygonObjects){
							var overlay = polygonObjects[key];

							if(overlay.gpProperties.groupLayerId == result.groupLayerId){

								var paths = overlay.getPaths();

								for (var p = 0; p < paths.getLength(); p++) {
									var path = paths.getAt(p);
									for (var i = 0; i < path.getLength(); i++) {
										gp_bounds.extend(path.getAt(i));
									}
								}
							}
						}

						//Readjust the map
						if(!isFolderAddShapesToMap) gp_centerZoom();

						//geoShapeControllerElement.scope().$apply();

						//Call the supplied callback
						if(callback){
							callback(result);
						}

						//Notify shape layer controller that layers on map changed
						angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true}); 
					}
				});
			
			}else{ //Standard Shape
				if (!result.type || !result.type.toLowerCase)
					throw 'Unknown shape type: ' + result.type;

				var type = result.type.toLowerCase();
				var shape;
				var labelPoint = { lat: result.labelPointLat, lng: result.labelPointLng };
				var coordArrays = null;

				if (type == 'polygon' || type == 'polyline') {
					var latLngs = [];
					if (result.coordinates && result.coordinates.search(/^\s*\[\s*\[\s*\[/) == 0){ //Stored in GeoJSON format
						coordArrays = JSON.parse(result.coordinates);
						var lngLatArray = coordArrays[0];	// first array of lng lats is the outer ring of the main shape
						for(var j = 0; j < lngLatArray.length; j++){
							latLngs.push(new google.maps.LatLng(lngLatArray[j][1],lngLatArray[j][0]));
						}
					} else {
						//Decode the lat lng string stored in sfdc, multiple lat lng fields are combined into Lat_Lng_1__c
						latLngs = google.maps.geometry.encoding.decodePath(result.coordinates);
					}

					if ('polyline' == type) {
						shape = new google.maps.Polyline({
							path: latLngs,
							strokeColor: result.color,
							strokeOpacity: result.opacity,
							strokeWeight: GP_POLYLINE_STROKE
						});
					}
					else {
						shape = new google.maps.Polygon({
							paths: latLngs,
							fillColor: result.color,	// these are restated here because of an apparent bug in google.maps.Polygon code,
							fillOpacity: result.opacity,	// whereby if you update value between ctor and setMap() call, new value is ignored.
							strokeWeight: 1
						});

						if (coordArrays && coordArrays.length > 1) {	// if there were holes / extra pieces, set up to display them
							shape.gpProperties = {};
							shape.gpProperties.innerRings = {};
							shape.gpProperties.outerRingsToInnerRings = {};
							shape.gpProperties.outerRingsToInnerRings[0] = [];
							var paths = [];
							paths.push(latLngs);

							for (var cdx = 1; cdx < coordArrays.length; cdx++) {
								shape.gpProperties.outerRingsToInnerRings[cdx] = [];
								var innerRingArray = coordArrays[cdx];
								var innerLatLngs = [];
								for (var ix = 0; ix < innerRingArray.length; ix++) {
									innerLatLngs.push(new google.maps.LatLng(innerRingArray[ix][1], innerRingArray[ix][0]));
									gp_bounds.extend(innerLatLngs[innerLatLngs.length-1]);
								}
								paths.push(innerLatLngs);
								shape.gpProperties.innerRings[paths.length - 1] = true;
								shape.gpProperties.outerRingsToInnerRings[cdx].push(paths.length - 1);
							}

							shape.setPaths(paths);
						}
					}
					//Make sure bounds of map include the shape
					for (var i = 0; i < latLngs.length; i++) {
						gp_bounds.extend(latLngs[i]);
					}

				} else if (type == 'circle') {
					// radius needs to be in meters.  convert from km or mi.  if not either of those, just use the radius
					var units = result.units.toLowerCase();
					var radius = (units == 'kilometers' || units == 'km' || units == 'k') ? result.radius * 1000 : (units == 'miles' || units == 'mi' || units == 'm') ? result.radius * 1609.344 : result.radius;

					shape = new google.maps.Circle({ 
						center: new google.maps.LatLng(result.centerLat, result.centerLng),
						fillColor: result.color,		// these are restated here because of an apparent bug in google.maps.Circle code,
						fillOpacity: result.opacity,	// whereby if you update value between ctor and setMap() call, new value is ignored.
						radius:  radius,
						strokeWeight: 1,
					});

					labelPoint = { lat: result.centerLat, lng: result.centerLng };

					//Make sure bounds of map include the shape
					var circleBounds = shape.getBounds();
					gp_bounds.extend(circleBounds.getNorthEast());
					gp_bounds.extend(circleBounds.getSouthWest());

				} else if (type == 'rectangle') {
					// Rectangles are stored in GeoJSON, SW point then NE point.
					var lngLatArray = JSON.parse(result.coordinates)[0]; //Doesn't support holes so first array of lng lats is the shape
					var sw = new google.maps.LatLng(lngLatArray[0][1], lngLatArray[0][0]);
					var ne = new google.maps.LatLng(lngLatArray[1][1], lngLatArray[1][0]);

					shape = new google.maps.Rectangle({
						bounds: new google.maps.LatLngBounds(sw, ne),
						fillColor: result.color,	// these are restated here because of an apparent bug in google.maps.Rectangle code,
						fillOpacity: result.opacity, // whereby if you update value between ctor and setMap() call, new value is ignored.
						strokeWeight: 1
					});

					var eastEnd = ne.lng() + (sw.lng() > ne.lng()? 360 : 0);
					var westEnd = sw.lng();
					var midLng = (westEnd + eastEnd) * 0.5;
					labelPoint = {	lat: (sw.lat() + ne.lat()) * 0.5,
									lng: midLng - (midLng > 180? 360 : 0) };

					//Make sure bounds of map include the shape
					gp_bounds.extend(sw);
					gp_bounds.extend(ne);

				} else {
					if(callback) callback(true);
					throw 'Unknown shape type: ' + result.type;
				}

				// set common properties to all types of shape overlays
				shape.setOptions({
					clickable: true,
					zIndex: 1,
					editable: false,
					draggable: false
				});
				if ('polyline' == type) {
					shape.strokeColor = result.color;
					shape.strokeOpacity = result.opacity;
					shape.strokeWeight = GP_POLYLINE_STROKE;
				}
				else {
					shape.fillColor = result.color;
					shape.fillOpacity = result.opacity;
					shape.strokeWeight = 1.5;
				}

				// always calculate labelPoint for polygons, in case user-entered coordinate data (supported in 17.x) has changed
				if ('polygon' == type && coordArrays && coordArrays.length) {
					var polyFeature = turf.polygon(coordArrays);
					var useLabelPoint = turf.pointOnSurface(polyFeature);
					labelPoint = { lat: useLabelPoint.geometry.coordinates[1], lng: useLabelPoint.geometry.coordinates[0] };
				}
				shape.centroid = labelPoint;

				//Set the saved properties on the overlay shape object
				shape.gpProperties = {};
				shape.gpProperties.sfdcId = result.sfdcId;
				shape.gpProperties.sfdcName = result.name;
				shape.gpProperties.sfdcDescription = result.description;
				shape.gpProperties.folderId = result.folderId;
				shape.gpProperties.folderName = result.folderName;
				var shapeFromList = _.find(angular.element('.dataSetController').scope().shapes, ['id', sfdcShapeId]);

				shape.gpProperties.accessLevel = shapeFromList && shapeFromList.accessLevel;
				shape.gpProperties.usedInAssignments = result.usedInAssignments;
				shape.gpProperties.originalOpacity = parseFloat(result.opacity);
				shape.gpProperties.originalColor = result.color;
				shape.gpProperties.gpType = type;
				shape.gpProperties.showLabel = result.showLabel;

				//Add the shape to map
				shape.setMap(gp_map);

				if (result.showLabel) {
					if (!(labelPoint.lat && labelPoint.lng)) {
						// polygon labelPoint already calculated above, if possible
						if ('polyline' == type) {
							var midPt = Math.floor(lngLatArray.length / 2);
							labelPoint = { 'lat': lngLatArray[midPt][1], 'lng': lngLatArray[midPt][0] };
						}
					}
					var shapeService = angular.element('.dataSetController').injector().get('shapeService');
					shape.mapLabel = shapeService.createShapeMapLabel(result.name, labelPoint);

					shape.mapLabel.setMap(shape.gpProperties.showLabel? gp_map : null);
				}
				// mapPane will be behind polygons unless its Canvas is lifted
				if (shape.mapLabel) {
					jQuery(shape.mapLabel.getPanes().mapPane).css('z-index', shape.mapLabel.zIndex);
				}

				//Call polygon added to map method, make sure it is added to polygon Objects array
				gp_shapeAddedToMap(shape, type);

				//Track in mixpanel that a geo shape was added to the map
				gp_track('Shape Added',{"Type": "Standard", "Number of Sub Shapes": 1});

				//Readjust the map
				if(!isFolderAddShapesToMap) gp_centerZoom();

				if(callback) callback();
			}

		} else {
			//Error handling
			if(callback) callback(true);
			var message = {
				severity: 'ERROR',
				message: 'Uh oh. Something didn\'t work quite right. If this error continues please contact Geopointe support. '+ event.message
			};
			updatePageMessages([message]);
			gp_track('Error', {'Language': 'JavaScript', 'Type':'Remoting', 'Function':'gp_addShapeToMap', 'Message':event.message});
		}
	},
		{escape: false}
	);
}

function gp_deleteShapeConfirm(uniqueId){
	//Get the current data set
	var polygon = polygonObjects[uniqueId];

	//Unique Id may have been a groupingId for a geoshape, try to find polygon with this
	if(!polygon){
		for(key in polygonObjects){
			if(polygonObjects[key].gpProperties.groupLayerId == uniqueId){
				polygon = polygonObjects[key];
				break;
			}
		}
	}

	//Set the dialog title and body
	var title = gp_translations.Delete_Shape + '<var> - ' + polygon.gpProperties.sfdcName + '</var>';
	
	var body = '<div class="gp-modal-content">';

	if(polygon.gpProperties.usageType == 'Shape Field'){
		body+= gp_translations.This_will_DELETE_the_selected_shape_and_clear_the_Shape_field_on_the_record + ':<br/><br/>';
		body+= '<b>'+gp_translations.Record_Name + '</b>: <var>' + polygon.gpProperties.relatedRecordName + '</var><br/>';
		body+= '<b>'+gp_translations.Shape_Field + '</b>: <var>' + polygon.gpProperties.relatedRecordFieldLabel + '</var>';
	}else{
		body+= gp_translations.This_will_DELETE_the_selected_Shape_and_remove_it_from_your_list;
	}

	body += '</div>'+
			'<div class="gp-modal-footer">'+
                '<input class="gp-btn btn-lg modalButtonRight" onclick="jQuery(this).closest(\'.ui-dialog-content\').dialog(\'close\');" type="button" value="'+gp_translations.Close+'">'+
                '<input class="gp-btn btn-lg btn-danger modalButtonRight" onclick="jQuery(this).closest(\'.ui-dialog-content\').dialog(\'close\'); gp_deleteShape(\''+polygon.gpProperties.uniqueId+'\')" type="button" value="'+gp_translations.Delete+'">'+
                '<div class="clear"></div>'+
            '</div>';

	jQuery('<div></div>')
		.append(body)
		.dialog({
			modal: true, 
			draggable: false, 
			width: '515px', 
			title: title, 
			position: { my: "bottom", at: "center", of: window },
			dialogClass: 'gp-modal warn',
			resizable: false,
			open: function( event, ui ) {
				//Set height of modal content
				setGPmodalContentHeight(jQuery(this));
			}
		});
}

function gp_deleteShape(shapeId){
	geopointeAjaxStart('body',gp_translations.Deleting_Shape+'...');

	//Find the shape to delete
	var shape;
	for(key in polygonObjects){
		if(polygonObjects[key].gpProperties.uniqueId == shapeId || polygonObjects[key].gpProperties.groupLayerId == shapeId){
			shape = polygonObjects[key];
			break;
		}
	}

	//Remoting save methods for dataSet
	Visualforce.remoting.Manager.invokeAction(gpRemoteAction,'Shape.deleteShape',{shapeId: shape.gpProperties.sfdcId},function(result, event){
		result = JSON.parse(result);

		if (event.status) {
			
			//Remove this data set from the shape picklist by rerendering it
			if(shape.gpProperties.usageType == 'Shape Field'){
				geopointeAjaxEnd();
			}else{
				var shapeService = angular.element('.dataSetController').injector().get('shapeService');

				//Update the list of shapes
				shapeService.getShapes({refresh: true, onComplete: function(shapes){
					//Broadcast events to update the shape folder lists
					angular.element('.dataSetController').scope().$broadcast('folderListChanged'); 
				}});
			}
			
			//Remove the data set from polygon objects and map
			gp_removeShape(shapeId);

			//Close the geo shape edit modal as it may have  if it was open
			try { jQuery( "#geoShapeModal" ).dialog('close'); } catch (e) {}

			//Show success message
			jQuery.extend(toastr.options,{ timeOut: 5000 });
			toastr.success('Shape deleted.');

		} else {
			//Show error message
			jQuery.extend(toastr.options,{ timeOut: 60000 });
			toastr.error('Uh oh. Something didn\'t work quite right. '+ event.message);
		
			//Track the error
			gp_track('Error', {'Language': 'JavaScript', 'Type':'Remoting', 'Function':'dataShape', 'Message':event.message});
		}

		geopointeAjaxEnd();
	},
		{escape: true}
	);
}

function gp_removeShape(uniqueId){ //UniqueId could be unique shape Id or groupLayerId
	//Remove from map
	var overlay = polygonObjects[uniqueId];
	var groupLayerIdToRemove;

	//UniqueId was a unique shape Id
	if(overlay){ 
		groupLayerIdToRemove = overlay.gpProperties.groupLayerId;

	}else{
		//UniqueId was a groupLayerId
		groupLayerIdToRemove = uniqueId;
	}

	for(key in polygonObjects){
		if(polygonObjects[key].gpProperties.groupLayerId == groupLayerIdToRemove){
			if (polygonObjects[key].mapLabel)
				polygonObjects[key].mapLabel.setMap(null);

			polygonObjects[key].setMap(null);
			delete polygonObjects[key];
		}
	}

	//Close the info window
	gp_infoWindow.close();

	//Update the layers list with new record counts
	setTimeout(function(){
		angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true}); 
	},0);
}

function gp_removeFolderShapes(folderId){
	//Check folderId of mapped shapes and remove any that match the input
	_.forEach(polygonObjects, function(shape, key){
		if(shape.gpProperties.folderId === folderId){
			if (shape.mapLabel) shape.mapLabel.setMap(null);
			shape.setMap(null);
			delete polygonObjects[key];
		}
	});

	//Update the layers list with new record counts
	setTimeout(function(){
		angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true}); 
	},0);
}

//IE this will remove one zip code from a shape comprised of many zip codes
function gp_removeSubShape(uniqueId){
	var overlay = polygonObjects[uniqueId];
	if (overlay.mapLabel)
		overlay.mapLabel.setMap(null);

	overlay.setMap(null);
	delete polygonObjects[uniqueId];

	//Close the info window
	gp_infoWindow.close();

	//Update the layers list with new record counts
	setTimeout(function(){
		angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true}); 
	},0);
}

function gp_removeAllShapesFromMap(){
	jQuery('<div></div>')
		.append('<p>'+gp_translations.This_will_remove_all_shapes_from_the_map+'<br/><br/>'+gp_translations.Select_Remove_to_continue+'</p>')
		.dialog({
			modal: true, 
			draggable: false, 
			width: '270px', 
			title: gp_translations.Remove_All_Shapes, 
			position: { my: "bottom", at: "center", of: window },
			
		    buttons:[{text: "Remove", 
		    			click: function(){ 
		    				//Remove shapes from the map
							for(key in polygonObjects){
								var shape = polygonObjects[key];

								//Dont remove shape field shapes
								if (shape.gpProperties.usageType == 'Shape Field')
									continue;

								if (shape.mapLabel)
									shape.mapLabel.setMap(null);

								shape.setMap(null);
								delete polygonObjects[key];
							}

							//Remove geojson files
							gp_map.data.forEach(function(shape){
								gp_map.data.remove(shape);
							});

							//Close info window that may be open
							gp_infoWindow.close();	

							//Close this dialog
							jQuery( this ).remove(); 

							//Update angular ui elements
							angular.element('.dataSetController').scope().$apply();
		    			} 
		    		},
		    		{text: "Cancel", 
		    			click: function(){ 
		    		   		jQuery( this ).remove(); 
		    			} 
		    		}] 
		});
}

function gp_goToShapeField(sfdcRecordId,shapeRecordId){
	//Loop through all the polygon objects
	for(key in polygonObjects){
		var shape = polygonObjects[key];
		if(shape.gpProperties.relatedRecordId == sfdcRecordId && shape.gpProperties.sfdcId == shapeRecordId){
			gp_goToShape(key);
		}
	}
}

function gp_goToShape(sfdcIdUniqueId){
	for(key in polygonObjects){
		var shape = polygonObjects[key];
		if(shape.gpProperties.sfdcId == sfdcIdUniqueId || shape.gpProperties.uniqueId == sfdcIdUniqueId){
			var bounds = shape.getBounds();
			gp_map.fitBounds(bounds);
		}
	}
}

function checkIfPoiInShapes(poi,groupLayerId){ //groupLayerId is optional
	
	//Construct a google lat lng object from the poi
	var latLng = new google.maps.LatLng(poi.lat,poi.lng);

	for(key in polygonObjects){	

		var overlay = polygonObjects[key];
		if (!overlay.visible || null == overlay.map) {
			continue;	// check next shape, this one is hidden
		}

		if(typeof groupLayerId == 'undefined' 
		|| ( typeof groupLayerId != 'undefined' && groupLayerId == overlay.gpProperties.groupLayerId ) 
		|| ( typeof groupLayerId != 'undefined' && groupLayerId == overlay.gpProperties.uniqueId) 
		){

			if (overlay.gpProperties.gpType == 'circle') { 
	            var distanceFromCenterKM = getGeoDistance(overlay.getCenter().lat(), overlay.getCenter().lng(), poi.lat, poi.lng, 'kilometers');

	            if(distanceFromCenterKM <= overlay.radius/1000)
	            	return true;

			} else if (overlay.gpProperties.gpType == 'rectangle') {
				if (overlay.getBounds().contains(latLng))
					return true;
			} else if ('polyline' == overlay.gpProperties.gpType) {
				// Polyline currently doesn't 'contain' any records.  Search-within-distance from line goes here.
				return false;
			} else {
				if (google.maps.geometry.poly.containsLocation(latLng,overlay))
					return true;
			}
		}
	}

	//Poi is not inside a shape
	return false;
}

function calcZoomTolerance() {
	var z = gp_map.getZoom();
	return Math.pow(z, -z * 0.22);	// be 'close to' polyline whatever the zoom level
}

function calcDistanceInPolyline(poly) {
	if (poly && ('polyline' === poly.gpProperties.gpType) && google.maps.geometry) {
		var totalDistance = 0.0;
		var path = poly.getPath();
		var prev = path.getAt(0);
		var curr;
		for (var i = 1, end = path.length; i < end; i++) {
			curr = path.getAt(i);
			totalDistance += google.maps.geometry.spherical.computeDistanceBetween(prev, curr);
			prev = curr;
		}

		// totalDistance is in meters.  Convert to ft or miles, and convert to km if > 1000
		poly.gpProperties.distance = {};
		poly.gpProperties.distance.totalM = totalDistance;
		poly.gpProperties.distance.us = totalDistance > 1500 ? angular.injector(["ng"]).get("numberFilter")((totalDistance / 1609.34),2) + ' mi' : angular.injector(["ng"]).get("numberFilter")((totalDistance * 3.28084),2) + ' ft';
		poly.gpProperties.distance.metric = totalDistance >= 1000 ? angular.injector(["ng"]).get("numberFilter")((totalDistance / 1000),2) + ' km' : angular.injector(["ng"]).get("numberFilter")(totalDistance,2) + ' m';
	}
}

var recordsInShapesTimeoutHandler;

function calcRecordsInShapes(){
	window.clearTimeout(recordsInShapesTimeoutHandler);

	if(gp_shapeDragInProgress == false){
		recordsInShapesTimeoutHandler = window.setTimeout(function(){
			doCalcRecordsInShapes();
		},250);
	}
}

//Never ever call this method directly. Always call calcRecordsInShapes();
function doCalcRecordsInShapes(){
	try{
		//Get the tables to process
		var tables = [];

		//Loop through all of the tabs and check to see it it has been removed from the map
		jQuery(".dataSetResultTableTab").each(function(){
			var collectionName = jQuery(this).attr('data-collectionName');

			//If tab is not hidden from the map add the table to list of those that should be returned
			if(jQuery(this).find(".poiCollectionTabLabel").hasClass('tabDataHidden') == false){
				tables.push(jQuery("#" + collectionName));
			}
		});

		//Reset shape recordCount values
		for(key in polygonObjects){
			polygonObjects[key].gpProperties.recordCounts = {};
			polygonObjects[key].gpProperties.recordIdsInShape = [];
			polygonObjects[key].gpProperties.aggregations = {};
			polygonObjects[key].gpProperties.containsDataLayerMarker = false;
		}

		// Reset recordCount values for DataSet layers
		for(key in gp_dataSetSearches) {
			if(!gp_dataSetSearches[key].name)
				continue;

			gp_dataSetSearches[key].aggregations = {};
		}

		// Set data layer counts
		var dataLayerInjector = angular.element('#dataLayerDirective').injector();
		if (dataLayerInjector) { // id= and idArray= layers won't have this
			var dataLayerService = dataLayerInjector.get('dataLayerService');
			var dataLayerSearchService = dataLayerInjector.get('dataLayerSearchService');
			var batchId = guid();

			// Data layer point in poly: loop through shapes first
			Promise.all(_.map(polygonObjects, function (polygon) {
				// Loop through each type of data layer and add counts to the polygon
				return Promise.all(_.map(dataLayerService.dataLayerDefaults, function (value, dataLayerType) {
					return dataLayerSearchService.getPoiListInOverlay(dataLayerType, polygon, batchId)
					.then(function (pois) {
						var count = pois.length;
						if (count) {
							polygon.gpProperties.recordCounts[dataLayerType] = count;
							polygon.gpProperties.containsDataLayerMarker = true;
						}
					});
				}));
			}))
			.then(function () {
				// Loop thru all tables and populate recordIds array and recordIdToObjectName object
				return Promise.all(_.map(tables, function (row, i) {
					// Determin the object name for this search/collection/datatable
					var collectionName = jQuery(tables[i]).attr('id');
					var objectName = gp_dataSetSearches[collectionName].qo.moNew.SobjectName;

					// Use the column info object attached to the data table as each table could have different number of columns
					var gp_ColumnInfo = jQuery(tables[i]).data('columnInfo');
					var apiNameToColNumber = jQuery(tables[i]).data('apiNameToColNumber');

					var oSettings = jQuery(tables[i]).dataTable().fnSettings();
					var columns = oSettings.aoColumns;

					// Get the Table Data
					var table = jQuery(tables[i]).dataTable();
					var aoData = table.fnGetData();

					var aggregates = {};

					// Loop through fields to determine currency fields for this object
					for (var apiName in apiNameToColNumber) {
						var columnNumber = apiNameToColNumber[apiName]
						var columnDetail = columns[columnNumber];

						// Only aggregate currency fields
						if (columnDetail.gpFieldType === 'CURRENCY') {
							aggregates[columnDetail.gpAPIname] = {
								aggkey: objectName + columnDetail.gpAPIname,
								columnNumber: columnNumber,
								label: columnDetail.sTitle,
								precision: columnDetail.gpPrecision
							};
						}
					}

					// Generate points for point in poly check
					var points = _.chain(aoData)
					.filter(function (thisRow) {
						var uniqueId = thisRow[gp_ColumnInfo.uniqueId];
						var marker = gp_markers[uniqueId];

						// Skip this row if it is hidden by the legend
						if (marker && marker.hiddenByLegend === true) {
							return false;
						}

						// Add field info to DataSet aggregations
						for (key in aggregates) {
							if (!aggregates.hasOwnProperty(key)) continue;

							var agg = aggregates[key];
							var value = thisRow[agg.columnNumber];

							if(typeof value != 'number') 
								continue;

							if (typeof gp_dataSetSearches[collectionName].aggregations[agg.aggkey] == 'undefined'){
								gp_dataSetSearches[collectionName].aggregations[agg.aggkey] = {label: agg.label, amount: 0, precision: agg.precision};
							}

							gp_dataSetSearches[collectionName].aggregations[agg.aggkey].amount += value;
						}

						return true;
					})
					.map(function (thisRow) {
						// Loop through currency fields
						var pointValues = _.reduce(aggregates, function (aggHash, agg, key) {
							var value = agg.columnNumber ? thisRow[agg.columnNumber] : null;

							if (typeof value !== 'number') return aggHash;

							aggHash[key] = value;
							return aggHash;
						}, {});

						var point = turf.point([thisRow[gp_ColumnInfo.longitude], thisRow[gp_ColumnInfo.latitude]]);
						point.properties.id = thisRow[gp_ColumnInfo.recordId];
						point.properties.values = pointValues;
						return point;
					})
					.value();

					// Loop through each shape and filter points in shape
					return Promise.all(_.map(polygonObjects, function (shape) {
						return dataLayerSearchService.containsLocationFilter(points, shape, batchId)
						.then(function (filteredPoints) {
							_.forEach(filteredPoints, function (point) {
								// Increment record counts
								shape.gpProperties.recordIdsInShape.push(point.properties.id);

								if (!shape.gpProperties.recordCounts[objectName]) {
									shape.gpProperties.recordCounts[objectName] = 0;
								}
								shape.gpProperties.recordCounts[objectName]++;

								// Loop through currency fields
								_.forEach(aggregates, function (agg, key) {
									if (typeof point.properties.values[key] === 'undefined') return;
									if (typeof shape.gpProperties.aggregations[agg.aggkey] === 'undefined') {
										shape.gpProperties.aggregations[agg.aggkey] = {label: agg.label, amount: 0, precision: agg.precision};
									}

									shape.gpProperties.aggregations[agg.aggkey].amount += point.properties.values[key];
								});
							});
						});
					}));
				}));
			})
			.then(function () {
				// Update the shape html for each shape
				for (var key in polygonObjects) {
					var shape = polygonObjects[key];

					buildShapeInfoWindowHTML(shape);

					// If the info window is currently open for this shape update the content
					if (gp_infoWindow.content && gp_infoWindow.content.indexOf(shape.gpProperties.uniqueId) > -1) {
						jQuery("#shapeRecordCountWrapper").html(getShapeBubbleRecordCountHtml(shape));
					}
				}

				// Update the layers list with new record counts
				angular.element('#ngApp').scope().$broadcast('layersChanged', {doApply: true});

				// After dom updates are complete re-calc legend item widths
				setTimeout(function () {
					gp_setLegendItemsWidth();
				}, 0);
			})
			.catch(function (err) {
				console.log(err);
			});
		}
	} catch (err) {
		console.log(err);
		gp_track('Error', {'Language': 'JavaScript', 'Type': 'Shape Record Count', 'Message': err.message});
	}
}

//Record action that launches process to create a new shape associated with a record, ie Polygon Field type
function gp_addShapeFieldShape(recordId,poiId,name,lat,lng,gpCollectionName){

	gp_mapMode = 'addShape';
	jQuery('#mapContextMenu').hide();
	jQuery('.drawingControls').hide();
	gp_enterDrawMode('polygon'); //Enter draw mode
	gp_infoWindow.setMap(null); //Hide the open info window

	//Setup the angular controller by passing over data
	var controller = angular.element('.shapeFieldTypeController').scope();
	delete controller.sfdcId;
	controller.$apply(function(){
		controller.init();
	})
	controller.initGeoShapeList = true;

	//Make it so watch on shapeType fires
	var shapeTypeBefore = controller.shapeType;
	controller.shapeType = 'polygon';
	controller.$apply();
	controller.shapeType = shapeTypeBefore;

	//Init controller properties
	controller.recordName = name;
	controller.centerLatLng = {lat: lat, lng: lng};
	controller.relatedRecordId = recordId;
	controller.getShapeFields();
	controller.isEdit = false;
	controller.gpCollectionName = gpCollectionName;
	controller.poiId = poiId;
	controller.initGeoShapeList = true;
	controller.$apply();

	jQuery('.mapControlsWrapper').hide(); //Hide the map controls, TODO this needs to be a smart function
	jQuery('.hiddenPanel').hide(); //Hide any other open panels
	jQuery('#addShapeFieldShape').show(); //Show the box explaining add shape mode
	geopointeAjaxStart('#addShapeFieldShape',gp_translations.Loading+'...');
}

function gp_exitAddShapeMode(){
	gp_mapMode = 'search';
	gp_exitDrawMode(); //Exit draw mode
	jQuery('.drawingControls').show();
	jQuery('.mapControlsWrapper').show(); //Show the map controls, TODO this needs to be a smart function
	jQuery('.hiddenPanel').hide(); //Hide any open panels
	
	//Remove any Shape Fields that were not saved
	for(key in polygonObjects){
		var shape = polygonObjects[key];
		
		//Turn off edit mode for the shape
		shape.setOptions({editable: false});

		//Remove any pending shape that was drawn on the map
		if(shape.gpProperties.usageType == 'Shape Field' && !shape.gpProperties.sfdcId){
			shape.setMap(null);
			delete polygonObjects[key];
		}
	}

}

function gp_correctLocationHideMapObjects() {
	var reshow = [];
	var activeCollections = [];
	for(var mx in gp_markers) {
		var mkr = gp_markers[mx];
		if (mkr.setMap) {
			reshow.push(mkr);
			mkr.setMap(null);
		}
		if (mkr.collectionName && (gp_dataSetSearches[mkr.collectionName].markerClusterer)
		&&  (-1 == activeCollections.indexOf(mkr.collectionName)) ) {
			activeCollections.push(mkr.collectionName);	// only do this once
			gp_dataSetSearches[mkr.collectionName].markerClusterer.clearMarkers();
		}
	}
	for (var slx in gp_sameLocationMarkers) {
		var mkr = gp_sameLocationMarkers[slx];
		if (mkr.setMap) {
			mkr.setMap(null);
		}
	}
	gp_sameLocationMarkers = [];	// they'll be completely rebuilt on exit
	return reshow;
}

// Record Action that launches process to add custom/corrected Lat, Lng values to record
function gp_correctLocation(poiId, name, customLatLng, latField, lngField) {
	var mkr = gp_markers[poiId];
	if (mkr.uniqueID !== poiId) {
		console.log('poiId mismatch: ', poiId, mkr.uniqueID);
	}

	gp_mapMode = 'correctLocation';
	jQuery('#mapContextMenu').hide();
	jQuery('.drawingControls').hide();
	gp_infoWindow.setMap(null);

	gp_remapHidden = gp_correctLocationHideMapObjects();
	gp_dragMarker = new google.maps.Marker({
		uniqueID: mkr.uniqueID,
		position: mkr.position, 
		icon: mkr.icon,
		flat: true,
		draggable: true
	});
	// follow along with label-only marker
	if (mkr.mapLabel) {
		gp_dragMarker.mapLabel = new MapLabel({
										fontSize: mkr.mapLabel.fontSize,
										strokeWeight: mkr.mapLabel.strokeWeight,
										position: mkr.mapLabel.position,
										text: mkr.mapLabel.text,
										zIndex: mkr.mapLabel.zIndex
									});
		gp_dragMarker.setOpacity(mkr.opacity);
		gp_dragMarker.type = mkr.type;
		gp_dragMarker.addListener('dragend', function(event) {
			gp_dragMarker.mapLabel.position = gp_dragMarker.position;
			gp_dragMarker.mapLabel.setMap(gp_map);
		});
	}

	var corLocController = angular.element('.correctLocationController').scope();
	var recordId = ('centerPOI' == poiId)? gp_centerPOI.recordId : mkr.sObject.id;
	var recordType = ('centerPOI' == poiId)? gp_centerPOI.sfdcObject : gp_dataSetSearches[mkr.collectionName].objectName;
	corLocController.recordName = name;
	corLocController.poiId = poiId;
	corLocController.relatedRecordId = recordId;
	corLocController.recordTypeString = recordType;
	corLocController.customLatField = latField;
	corLocController.customLngField = lngField;
	corLocController.editAccess = customLatLng? 'checking' : 'no';
	if (customLatLng && (latField.indexOf('.') > 0 || lngField.indexOf('.') > 0)) {
		corLocController.editAccess = 'ref';	// can't correct location on referenced MapObjects
	}

	if ('checking' === corLocController.editAccess) {
		Visualforce.remoting.Manager.invokeAction(
			gpRemoteAction,
			'Map_Controller.hasCorrectLocationWriteAccess',
			{recordType: corLocController.recordTypeString, recordId: recordId, latField: latField, lngField: lngField},
			function(result, event) {
				if (event.status) {
					corLocController.editAccess = (result? result : 'noPerm');
					if ('custom' == corLocController.editAccess) {
						corLocController.resetLocActive = true;
						corLocController.editAccess = 'yes';
					}
					else {
						corLocController.resetLocActive = false;
					}
				}
				else {
					corLocController.editAccess = 'noPerm';
				}
				corLocController.$apply();
			}
		);
	}

	corLocController.$apply();

	jQuery('.mapControlsWrapper').hide();
	jQuery('#correctLocation').show();

	gp_dragMarker.setMap(gp_map);
}

function gp_correctLocationUpdateMarker() {
	// pass new location info to Angular remoteAction caller
	var corLocController = angular.element('.correctLocationController').scope();
	corLocController.newLat = gp_dragMarker.position.lat();
	corLocController.newLng = gp_dragMarker.position.lng();

	var failback = gp_markers[gp_dragMarker.uniqueID].position;
	gp_markers[gp_dragMarker.uniqueID].position = gp_dragMarker.position;
	if (gp_markers[gp_dragMarker.uniqueID].mapLabel) {
		gp_markers[gp_dragMarker.uniqueID].mapLabel.position = gp_dragMarker.position;
		gp_markers[gp_dragMarker.uniqueID].mapLabel.setMap(gp_map);
	}
	return failback;
}

function gp_exitCorrectLocationMode(failback) {
	jQuery('.mapControlsWrapper').show(); // Show the map controls
	jQuery('#correctLocation').hide();

	if (failback) {
		gp_markers[gp_dragMarker.uniqueID].position = failback;
		if (gp_markers[gp_dragMarker.uniqueID].mapLabel) {
			gp_markers[gp_dragMarker.uniqueID].mapLabel.position = failback;
			gp_markers[gp_dragMarker.uniqueID].mapLabel.setMap(gp_map);
		}
	}
	else {
		// push new data into relevant dataTable row or
		// gp_centerPOI, depending on what we're moving
		var tableId = gp_markers[gp_dragMarker.uniqueID].collectionName;
		if ('centerPOI' == tableId) {
			gp_centerPOI.lat = gp_centerPOI.latDisplay = gp_markers[gp_dragMarker.uniqueID].position.lat();
			gp_centerPOI.lng = gp_centerPOI.lngDisplay = gp_markers[gp_dragMarker.uniqueID].position.lng();
		}
		else {
			var dataElement = jQuery('#' + tableId);
			var aoData = dataElement.dataTable().fnGetData();
			var colInfo = dataElement.data('columnInfo');
			if (aoData && aoData.length && colInfo) {
				for (var i = 0, iLen = aoData.length; i < iLen; i++) {
					var thisRow = aoData[i];
					if (thisRow[colInfo.uniqueId] == gp_dragMarker.uniqueID) {
						thisRow[colInfo.latitude] = thisRow[gp_ColumnInfo.latitudeDisplay] = gp_markers[gp_dragMarker.uniqueID].position.lat();
						thisRow[colInfo.longitude] = thisRow[gp_ColumnInfo.longitudeDisplay] = gp_markers[gp_dragMarker.uniqueID].position.lng();
						break;
					}
				}
			}
		}
		gp_createSameLocationMarkers();
	}

	gp_dragMarker.setMap(null);
	gp_dragMarker = null;

	// unhide all hidden objects
	var remapped = [];
	for (var hx in gp_remapHidden) {
		var mkr = gp_remapHidden[hx];
		if(mkr.setMap) {
			mkr.setMap(gp_map);
			if (mkr.collectionName && gp_dataSetSearches[mkr.collectionName]) {
				if (-1 == remapped.indexOf(mkr.collectionName)) {
					remapped.push(mkr.collectionName);	// just do this once per collection
				}
			}
		}
	}
	for (var cx in remapped) {
		if (gp_dataSetSearches[remapped[cx]]) {
			gp_restoreDataSetSearchOnMap(remapped[cx]);
		}
	}
	gp_mapMode = 'search';
	jQuery('.drawingControls').show();
}

// Extend the google Marker.setMap method to include awareness of mapLabel objects and their visibility
google.maps.Marker.prototype.gp_superSetMap = google.maps.Marker.prototype.setMap;

google.maps.Marker.prototype.setMap = function(map, labelVisible) {
	if (this.gp_superSetMap) {
		this.gp_superSetMap(map);
	} else { console.log('marker gp_superSetMap missing'); }
	// Set correct visibility for marker label (if any)
	if (this.mapLabel) {
		var dsSrch = gp_dataSetSearches[this.collectionName];
		if (map) {
			var showLabel = (undefined != labelVisible)? labelVisible : 
							( (dsSrch && dsSrch.layerSettings)? dsSrch.layerSettings.markerLabelsVisible : true);
			this.mapLabel.setMap(showLabel? map : null);
		}
		else {
			this.mapLabel.setMap(null);	// labels always disappear with their marker
		}
	}
	// Set correct visibility for selected checkbox marker (if any)
	if (this.selectedMarker) {
		this.selectedMarker.setMap(map);
	}
}

//Extend the google Polygon object with getBounds - https://github.com/tparkin/Google-Maps-Point-in-Polygon
if (!google.maps.Polygon.prototype.getBounds) {
  google.maps.Polygon.prototype.getBounds = function(latLng) {
    var bounds = new google.maps.LatLngBounds();
    var paths = this.getPaths();
    var path;
    
    for (var p = 0; p < paths.getLength(); p++) {
      path = paths.getAt(p);
      for (var i = 0; i < path.getLength(); i++) {
        bounds.extend(path.getAt(i));
      }
    }

    return bounds;
  }
}

// Also extend google Polyline with getBounds
if (! google.maps.Polyline.prototype.getBounds) {
	google.maps.Polyline.prototype.getBounds = function() {
	    var bounds = new google.maps.LatLngBounds();
	    this.getPath().forEach(function(item, index) {
	        bounds.extend(new google.maps.LatLng(item.lat(), item.lng()));
	    });
	    return bounds;
	};
}

/* Layer methods */
function gp_showKMLlayer(url){
	gp_layers[url].kmlLayer.setMap(gp_map);
}

function gp_hideKMLlayer(url){
	gp_layers[url].kmlLayer.setMap(null);
}

function gp_removeKMLlayer(id){
	if(!gp_layers[id] || !gp_layers[id].kmlLayer){
		return;
	}
	gp_layers[id].kmlLayer.setMap(null);
	delete gp_layers[id].kmlLayer;

	//Update the layers list with new record counts
	setTimeout(function(){
		angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true}); 
	},0);
}

function gp_addKMLlayer(opts){ //recieves opts object with arguments {url: string, this: jQuery(this)}	
	if(gp_layers[opts.id].kmlLayer){
		if(opts.callback)
			opts.callback();

		return;
	}

	//Create a new layer object
	var layer = new google.maps.KmlLayer({
		url: opts.url,
		preserveViewport: true,
		map: gp_map
	});

	//Use exising kml layer if it is already attached to the gp_layers object
	if(gp_layers[opts.id].kmlLayer){
		layer = gp_layers[opts.id].kmlLayer;
	}

	//Event listener to track if the kml layer was added to map successfully
	google.maps.event.addListener(layer, 'status_changed', function(kmlEvent) {
		if(layer.getStatus() == 'OK'){
				
			//On success update text and show the little green dot indicating layer is visible on map
			if(opts.id){

				//Update list of layers on the map
				angular.element('#ngApp').scope().$broadcast('layersChanged',{doApply: true}); 
				
				//Hide Ajax status spinner
				geopointeAjaxEnd();

				if(opts.callback) opts.callback();
			}
		}else{
			//Remove Ajax status icon
			geopointeAjaxEnd();

			if(opts.callback) opts.callback(true);

			//'Remove' layer from the map as it was never added successfully
			layer.setMap(null);
			delete gp_layers[opts.id].kmlLayer;

			var layerMessage;
			var status = layer.getStatus();

			if(status == 'DOCUMENT_NOT_FOUND'){
				layerMessage = gp_translations.The_layer_could_not_be_added_to_the_map + '<br/><br/>'+gp_translations.Unable_to_locate_the_file;

			}else if(status == 'DOCUMENT_TOO_LARGE'){
				layerMessage = gp_translations.The_layer_could_not_be_added_to_the_map + '<br/><br/>'+gp_translations.The_file_is_too_large;

			}else if(status == 'FETCH_ERROR'){
				layerMessage = gp_translations.The_layer_could_not_be_added_to_the_map + '<br/><br/>'+gp_translations.Unable_to_fetch_the_file;

			}else if(status == 'INVALID_DOCUMENT'){
				layerMessage = gp_translations.The_layer_could_not_be_added_to_the_map + '<br/><br/>'+gp_translations.The_document_is_not_a_well_formed;

			}else if(status == 'INVALID_REQUEST'){
				layerMessage = gp_translations.The_layer_could_not_be_added_to_the_map + '<br/><br/>'+gp_translations.The_KmlLayer_is_invalid;
				
			}else if(status == 'LIMITS_EXCEEDED'){
				layerMessage = gp_translations.The_layer_could_not_be_added_to_the_map + '<br/><br/>'+gp_translations.The_document_exceeds_the_limit_of_supported_features;

			}else if (status == 'TIMED_OUT'){
				layerMessage = gp_translations.The_layer_could_not_be_added_to_the_map + '<br/><br/>'+gp_translations.Connection_timeout;

			}else{
				layerMessage = gp_translations.The_layer_could_not_be_added_to_the_map + '<br/><br/>'+gp_translations.Please_contact_Arrowpointe_Support_if_you_continue_to_see_this_error;
			}

			jQuery('<div style="margin-top: 4px;"></div>')
			.append('<div class="gp-alert gp-alert-error">'+layerMessage+'<div>')
			.dialog({
				modal: true, 
				draggable: true, 
				width: 350,
				title: gp_translations.Layers_Error, 
				draggable: false,
				resizable: false,
				buttons: { 
					Close: function() {jQuery( this ).remove();} 
				}
			});
		}
	});

	//Add layer to map
	layer.setMap(gp_map);

	//update kml object
	gp_layers[opts.id].kmlLayer = layer;

	//Log layer being added in mixpanel
	if(typeof opts.isAutoLoad == 'undefined') opts.isAutoLoad = false;

	gp_track('Layer', {	"Layer Type": 'KML', 
						"Layer Status": 'On',
						"Is Auto Load": opts.isAutoLoad
						});
}
/* End Layer Methods */

/*Start Heatmap Methods */
function toggleHeatMap(layer){

	var collectionName = layer.id;

	//Check to see if heatmap is all ready visible on the map, and if so remove it
	if(gp_heatmaps[collectionName]){
		if(gp_heatmaps[collectionName].getMap()){
			//Remove from map
			gp_heatmaps[collectionName].setMap(null);
			delete gp_heatmaps[collectionName];

			//Hide the heat map slider controls
			jQuery("#heatMapSlider-"+collectionName).hide();
			//jQuery(btn).removeClass('btnSelected');

			//Add markers back to map
			if(gp_dataSetSearches[collectionName]){
				gp_dataSetSearches[collectionName].markersVisible = true;
			}
			gp_restoreDataSetSearchOnMap(collectionName);
		}

	}else{ //Need to add to map

		heatmap = new google.maps.visualization.HeatmapLayer({
			opacity: 0.5,
			radius: jQuery("#heatmapSlider-"+collectionName).slider("value"),
			maxIntensity: 5,
			gradient: [
				'rgba(0, 0, 255, 0)',
			    'rgba(0, 0, 255, 1)',
			    'rgba(0, 255, 255, 1)',
			    'rgba(0, 255, 0, 1)',
			    'rgba(255, 255, 0, 1)',
			    'rgba(255, 0, 0, 1)'
			]
		});

		if(layer.heatmapWeightField){
			heatmap.gp_weightField = layer.heatmapWeightField.field;
		}

		heatmap.setMap(gp_map);

		//Remove the marker pins on the map
		if(!layer.showHeatMapMarkers){
			gp_removeDataSetSearchFromMap(collectionName);
			gp_dataSetSearches[collectionName].markersVisible = false;
		}else{
			gp_dataSetSearches[collectionName].markersVisible = true
		}

		//Add to heatmap object
		gp_heatmaps[collectionName] = heatmap;

		//Update the data points for the heatmap
		updateHeapMapDataPoints(collectionName)

		//Track in mixpanel
		if(gp_dataSetSearches[collectionName]){
			gp_track('Heatmap Added', {'Number of Markers': gp_dataSetSearches[collectionName].numOfRecords, 
										'Zoom Level': gp_getZoomLevel()
			});
		}
	}
}

function updateHeapMapDataPoints(collectionName){
	var heatmap = gp_heatmaps[collectionName];

	//Create array of google.maps.LatLng objects
	if(heatmap){
		var latLngs = [];
		var maxIntensity = 5;

		for (key in gp_markers){
			var marker = gp_markers[key];

			if(marker.collectionName == collectionName && marker.hiddenByLegend != true){
				
				if(heatmap.gp_weightField){
					
					var weightValue = getDescendantProp(marker.sObject,heatmap.gp_weightField);

					if(!weightValue || weightValue < 0) weightValue = 0;

					if(weightValue > maxIntensity) maxIntensity = weightValue;

					latLngs.push({
						'location': marker.getPosition(),
						'weight' :  weightValue
					});

					marker.setMap(null);
				}else{
					latLngs.push(marker.getPosition());

					marker.setMap(null);
				}
			}
		}

		//Update the heatmap
		gp_heatmaps[collectionName].set('maxIntensity', maxIntensity);
		gp_heatmaps[collectionName].set('data', new google.maps.MVCArray(latLngs));
	}
}

function toggleMapMarkers(collectionName){
	//Only proceed if gp_dataSetSearches object contains meta data for this search, it always should
	if(gp_dataSetSearches[collectionName]){
		
		if(gp_dataSetSearches[collectionName].markersVisible != false){
			gp_removeDataSetSearchFromMap(collectionName);

			//Update the gp_dataSetSearches object with state of marker visibility
			if(gp_dataSetSearches[collectionName]){
				gp_dataSetSearches[collectionName].markersVisible = false;
			}

		}else{
			//Update the gp_dataSetSearches object with state of marker visibility
			if(gp_dataSetSearches[collectionName]){
				gp_dataSetSearches[collectionName].markersVisible = true;
			}
			
			gp_restoreDataSetSearchOnMap(collectionName); //Add markers to map
		}

	}
}
/* End Heatmap Methods */

function gp_setCurrentPositionMarker(callback) {
	// spin the icon as feedback - this may take a sec...
	var spinner = jQuery('.fa-location-arrow').addClass('fa-spin');										

	navigator.geolocation.getCurrentPosition(function(position) {
		spinner.removeClass('fa-spin');
		var curLoc = gp_markers['gp_currentLocation'];
		if (curLoc) { curLoc.setMap(null); }
		curLoc = gp_createMarker(new google.maps.LatLng(position.coords.latitude, position.coords.longitude),
									'<b>Current Location</b>', '<div class="poiTitle"><b>Current Location</b></div>',
									gpImg.currentLocation, 'gp_currentLocation');
		curLoc.setMap(gp_map);
		google.maps.event.addListener(curLoc, 'click', function() {
			gp_showCurrentLocationInfoWindow();
		});
		gp_markers['gp_currentLocation'] = curLoc;
		if ('function' == typeof callback) {
			callback(curLoc.position);
		}
	},
	function() {
		// called if getCurrentPosition fails
		spinner.removeClass('fa-spin');
	});
}

google.maps.Polyline.prototype.douglasPeucker = function(tolerance){
	var res = null;
	
	//adjust tolerance depending on the zoom level
	tolerance = tolerance * Math.pow(2, 20 - gp_map.getZoom());

	if(this.getPath() && this.getPath().getLength()){
		var points = this.getPath().getArray();

		var Line = function( p1, p2 ) {
			this.p1 = p1;
			this.p2 = p2;

			this.distanceToPoint = function( point ) {
				// slope
				var m = ( this.p2.lat() - this.p1.lat() ) / ( this.p2.lng() - this.p1.lng() ),
					// y offset
					b = this.p1.lat() - ( m * this.p1.lng() ),
					d = [];
				// distance to the linear equation
				d.push( Math.abs( point.lat() - ( m * point.lng() ) - b ) / Math.sqrt( Math.pow( m, 2 ) + 1 ) );
				// distance to p1
				d.push( Math.sqrt( Math.pow( ( point.lng() - this.p1.lng() ), 2 ) + Math.pow( ( point.lat() - this.p1.lat() ), 2 ) ) );
				// distance to p2
				d.push( Math.sqrt( Math.pow( ( point.lng() - this.p2.lng() ), 2 ) + Math.pow( ( point.lat() - this.p2.lat() ), 2 ) ) );
				// return the smallest distance
				return d.sort( function( a, b ) {
					return ( a - b ); //causes an array to be sorted numerically and ascending
				} )[0];
			};
		};

		var douglasPeucker = function( points, tolerance ) {
				
			if ( points.length <= 2 ) {
				return [points[0]];
			}
			var returnPoints = [],
				// make line from start to end 
				line = new Line( points[0], points[points.length - 1] ),
				// find the largest distance from intermediate poitns to this line
				maxDistance = 0,
				maxDistanceIndex = 0,
				p;
			for( var i = 1; i <= points.length - 2; i++ ) {
				var distance = line.distanceToPoint( points[ i ] );
				if( distance > maxDistance ) {
					maxDistance = distance;
					maxDistanceIndex = i;
				}
			}
			// check if the max distance is greater than our tollerance allows 
			if ( maxDistance >= tolerance ) {
				p = points[maxDistanceIndex];
				line.distanceToPoint( p, true );
				// include this point in the output 
				returnPoints = returnPoints.concat( douglasPeucker( points.slice( 0, maxDistanceIndex + 1 ), tolerance ) );
				// returnPoints.push( points[maxDistanceIndex] );
				returnPoints = returnPoints.concat( douglasPeucker( points.slice( maxDistanceIndex, points.length ), tolerance ) );
			} else {
				// ditching this point
				p = points[maxDistanceIndex];
				line.distanceToPoint( p, true );
				returnPoints = [points[0]];
			}
			return returnPoints;
		};
		res = douglasPeucker( points, tolerance );
		// always have to push the very last point on so it doesn't get left off
		res.push( points[points.length - 1 ] );
		this.setPath(res);
	}
	return this;
};
//http://jsfiddle.net/9gvsq3od/
///Start custom poly fill code
PolyLineFill.prototype = new google.maps.OverlayView();
PolyLineFill.prototype.constructor = PolyLineFill;

function PolyLineFill(poly, map, options) {
	var bounds = new google.maps.LatLngBounds();
	for (var i = 0; i < poly.length; i++) {
		bounds.extend(poly[i]);
	}

	//initialize all properties.
	this.bounds_ = bounds;
	this.map_ = map;
	this.div_ = null;
	this.poly_ = poly;
	this.polysvg_ = null;
	this.fill_ = options.fill;
	this.stroke_ = options.stroke;
	this.onClick_ = options.onClick;

	// Explicitly call setMap on this overlay
	this.setMap(map);
}

PolyLineFill.prototype.updateStyle = function(style){
	this.fill_ = style.fill || this.fill_;
	this.stroke_ = style.stroke || this.stroke_;

	this.setMap(this.map_);
}

PolyLineFill.prototype.onAdd = function () {
	// Create the DIV and set some basic attributes.
	var div = document.createElement('div');
	div.style.borderStyle = 'none';
	div.style.borderWidth = '0px';
	div.style.position = 'absolute';

	//createthe svg element
	var svgns = "http://www.w3.org/2000/svg";
	var svg = document.createElementNS(svgns, "svg");
	svg.setAttributeNS(null, "preserveAspectRatio", "xMidYMid meet");

	var def = document.createElementNS(svgns, "defs");

	//create the pattern fill 
	var pattern = document.createElementNS(svgns, "pattern");
	pattern.setAttributeNS(null, "id", "lineFill");
	pattern.setAttributeNS(null, "patternUnits", "userSpaceOnUse");
	pattern.setAttributeNS(null, "patternTransform", "rotate(-45)");
	pattern.setAttributeNS(null, "height", "4");
	pattern.setAttributeNS(null, "width", "4");
	def.appendChild(pattern);

	var rect = document.createElementNS(svgns, "rect");
	rect.setAttributeNS(null, "id", "rectFill");
	rect.setAttributeNS(null, "fill", this.fill_ || "none");
	rect.setAttributeNS(null, "fill-opacity", this.opacity_ || "0.5");
	rect.setAttributeNS(null, "stroke", this.stroke_ || "black");
	rect.setAttributeNS(null, "stroke-width", "2")
	rect.setAttributeNS(null, "stroke-opacity", "0.1");
	// rect.setAttributeNS(null, "stroke-dasharray", "7,7");
	rect.setAttributeNS(null, "height", "4");
	rect.setAttributeNS(null, "width", "4");
	pattern.appendChild(rect);

	svg.appendChild(def);

	//add path to the div
	var path = document.createElementNS(svgns, 'path');
	path.setAttributeNS(null, 'fill', 'url(#lineFill)');
	path.setAttributeNS(null, 'stroke', '#000');
	path.setAttributeNS(null, 'stroke-width', '1');
	this.path_ = path;
	svg.appendChild(this.path_);
	svg.appendChild(this.path_);

	div.appendChild(svg);

	// Set the overlay's div_ property to this DIV
	this.div_ = div;
	this.div_.className = 'polygon';

	// We add an overlay to a map via one of the map's panes.
	// We'll add this overlay to the overlayLayer pane.
	var panes = this.getPanes();
	panes.overlayLayer.appendChild(div);
}

PolyLineFill.prototype.AdjustPoints = function () {
	//adjust the polygon points based on the projection.
	var proj = this.getProjection();
	var sw = proj.fromLatLngToDivPixel(this.bounds_.getSouthWest());
	var ne = proj.fromLatLngToDivPixel(this.bounds_.getNorthEast());

	var points = "";
	for (var i = 0; i < this.poly_.length; i++) {
		var point = proj.fromLatLngToDivPixel(this.poly_[i]);
		if (i == 0) {
			points += (point.x - sw.x) + ", " + (point.y - ne.y);
		} else {
			points += " " + (point.x - sw.x) + ", " + (point.y - ne.y);
		}
	}
	return points;
}

PolyLineFill.prototype.draw = function () {
	// Size and position the overlay. We use a southwest and northeast
	// position of the overlay to peg it to the correct position and size.
	// We need to retrieve the projection from this overlay to do this.
	var overlayProjection = this.getProjection();

	// Retrieve the southwest and northeast coordinates of this overlay
	// in latlngs and convert them to pixels coordinates.
	// We'll use these coordinates to resize the DIV.
	var sw = overlayProjection.fromLatLngToDivPixel(this.bounds_.getSouthWest());
	var ne = overlayProjection.fromLatLngToDivPixel(this.bounds_.getNorthEast());

	// Resize the image's DIV to fit the indicated dimensions.
	var div = this.div_;
	div.style.left = sw.x + 'px';
	div.style.top = ne.y + 'px';
	div.style.width = (ne.x - sw.x) + 'px';
	div.style.height = (sw.y - ne.y) + 'px';

	this.path_.setAttributeNS(null, "d", 'M' + this.AdjustPoints() + 'z');
}

PolyLineFill.prototype.onRemove = function () {
	this.div_.parentNode.removeChild(this.div_);
	this.div_ = null;
}
///end poly fill code

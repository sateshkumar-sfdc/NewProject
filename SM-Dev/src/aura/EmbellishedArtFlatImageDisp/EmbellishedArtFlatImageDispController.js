/*
*************************************************************
** Name: EmbellishedArtFlatImageDisp.js	 		    	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose: 											   **
** This js controller handles the necessaryfunctions       **
** for the  EmbellishedArtFlatImageDisp.cmp                **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Sumanth Anumukonda 04/16/2018 INITIAL DEVELOPMENT **
** 2.0 -                                                   **
*************************************************************
*/

({
    doInit: function(component,event,helper) {
        try{
            helper.getUrlValues(component,event,helper);
        }
        catch(Err){
            //console.log(Err);
        }
    },
    /*
    Author : Ranjith Thadakala
    version: 1.0
    Date : 4/12/2018
    calling helper to create custom component c:ArtDesign */
    openModal: function(component,event,helper) {
        try{
            helper.openWindow(component, event, helper);
        }catch(Err){
           	//console.log(Err);
        }        
    },
    
    
    /******************************************************************
    * @description Sets the default image url from the static resource
    * to the image tag in the EmbellishedArtFlatImageDisp.cmp when ever
    * the amazon url breaks.
    * @param component the name of the component its related to.
    * @param event the event when this function is called.
    * @return the location to the default image.
    * @example
    * event.target.src = $A.get('$Resource.NoImage') ;
    * ******************************************************************
    */
    errorImage : function(component, event) {
        try{
            event.target.src = $A.get('$Resource.NoImage') ;
        }catch(Err){
            //console.log(Err);
        } 
        
    }
})
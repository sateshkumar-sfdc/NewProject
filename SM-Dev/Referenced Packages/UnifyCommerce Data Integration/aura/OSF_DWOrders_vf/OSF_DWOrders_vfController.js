({
	doInit: function(cmp) {

        //cmp.set("v.startUrl", "https://unify-dev-dev-ed--osf-dwback-dev.eu6.visual.force.com/apex/OSF_DWOrders?scontrolCaching=1&id="+cmp.get("v.recordId"));
        cmp.set("v.startUrl", document.location.origin+"/apex/OSF_DWback__OSF_DWOrders?scontrolCaching=1&id="+cmp.get("v.recordId"));
    }
})
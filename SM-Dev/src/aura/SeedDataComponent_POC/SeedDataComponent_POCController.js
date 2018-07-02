({
	doInit : function(component, event, helper) {
        console.log('test');
		var getSeedData = component.get("c.getRawSeedData");
        getSeedData.setCallback(this, function(getSeedResponse) {
            var seedstate = getSeedResponse.getState();
            console.log('test sap'+seedstate);
            if (seedstate === "SUCCESS") {
                var seedResponse = getSeedResponse.getReturnValue();
                console.log('testttt-->'+seedResponse);
                // set current user information on userInfo attribute
                component.set("v.resultSalesOrgList",seedResponse.seedDataKeyValuesMap_wrapper["SALESORG"]);
                component.set("v.paymentList",seedResponse.seedDataKeyValuesMap_wrapper["PAYT_TERMS"]);
                component.set("v.districtList",seedResponse.seedDataKeyValuesMap_wrapper["DISTRICT"]);
                component.set("v.priceGroupList",seedResponse.seedDataKeyValuesMap_wrapper["PRICE_GROUP"]);
                component.set("v.pricingList",seedResponse.seedDataKeyValuesMap_wrapper["PLTYP"]);
                component.set("v.priceProcedureList",seedResponse.seedDataKeyValuesMap_wrapper["CUST_PRIC_PROC"]);
                component.set("v.shippingCondList",seedResponse.seedDataKeyValuesMap_wrapper["SHIP_COND"]);
                // console.log('Test Seed response123'+component.get("v.resultSalesOrgList"));
                component.set("v.SeedDataWrapper", seedResponse);
                //helper.enableDisableDependancies(component,editRecId);
                console.log('4'+component.get("v.SeedDataWrapper"));
                //var string1 = JSON.stringify(component.get("v.SeedDataWrapper"));
                //console.log('Test result--->'+string1);
            }
        }); 
        $A.enqueueAction(getSeedData);
	},
     getDependantValues : function(component, event, helper) {
        var event = event.getSource();
        var eventId = event.getLocalId();
        //console.log('onchange event'+eventId);
        helper.nullifyDependants(component, eventId);
        var sod = component.find("salesorgId").get("v.value");
        if(sod!= '' && sod!= 'undefined')
            helper.fetchDependants(component);
    }
})
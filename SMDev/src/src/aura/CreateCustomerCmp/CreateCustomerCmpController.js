({
    doInit: function(component, event, helper){
        
        console.log(component.get("v.recordId"));
        var editRecId = component.get("v.recordId");
        if(editRecId != null)
        {
            helper.getAccount(component, editRecId, event);
            helper.enableDisableDependancies(component,editRecId);
        }
        else{
        var getSeedData = component.get("c.getAccountSeedData");
        getSeedData.setCallback(this, function(getSeedResponse) {
            var seedstate = getSeedResponse.getState();
            //console.log('test sap');
            if (seedstate === "SUCCESS") {
                var seedResponse = getSeedResponse.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.resultSalesOrgList",seedResponse.NAME_ITEM_RESULT["SALESORG"]);
                component.set("v.paymentList",seedResponse.NAME_ITEM_RESULT["PAYT_TERMS"]);
                component.set("v.districtList",seedResponse.NAME_ITEM_RESULT["DISTRICT"]);
                component.set("v.priceGroupList",seedResponse.NAME_ITEM_RESULT["PRICE_GROUP"]);
                component.set("v.pricingList",seedResponse.NAME_ITEM_RESULT["PLTYP"]);
                component.set("v.priceProcedureList",seedResponse.NAME_ITEM_RESULT["CUST_PRIC_PROC"]);
                component.set("v.shippingCondList",seedResponse.NAME_ITEM_RESULT["SHIP_COND"]);
                // console.log('Test Seed response123'+component.get("v.resultSalesOrgList"));
                component.set("v.SeedDataWrapper", seedResponse);
                helper.enableDisableDependancies(component,editRecId);
                console.log('4');
                //var string1 = JSON.stringify(component.get("v.SeedDataWrapper"));
                //console.log('Test result--->'+string1);
            }
        }); 
        $A.enqueueAction(getSeedData);
        }
        var getUser = component.get("c.fetchUser");
        getUser.setCallback(this, function(gerUserResponse) {
            var state = gerUserResponse.getState();
            if (state === "SUCCESS") {
                var storeResponse = gerUserResponse.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        var action = component.get("c.getPickValues");
        action.setParams({  "object_name" : "Account", "field_name" : "OriginSource__c" });
        var inputOrigin = component.find("InputAccountOrigin");
        var opts=[];
        action.setCallback(this, function(a) {
            
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.set("v.originSource", opts);
        });
        var competitors = component.get("c.getPickValues");
        competitors.setParams({  "object_name" : "Account", "field_name" : "Competitors__c" });
        var compitetorsopts=[];
        competitors.setCallback(this, function(c) {
            //console.log(c.getReturnValue());
            for(var i=0;i< c.getReturnValue().length;i++){
                compitetorsopts.push({"class": "optionClass", label: c.getReturnValue()[i], value: c.getReturnValue()[i]});
            }
            component.set("v.competitorsList", compitetorsopts);
        });
        var premiumBrands = component.get("c.getPickValues");
        premiumBrands.setParams({  "object_name" : "Account", "field_name" : "Premium_Brands_Carried__c" });
        var premiumBrandOpts=[];
        premiumBrands.setCallback(this, function(pb) {
            //console.log(pb.getReturnValue());
            for(var i=0;i< pb.getReturnValue().length;i++){
                premiumBrandOpts.push({"class": "optionClass", label: pb.getReturnValue()[i], value: pb.getReturnValue()[i]});
            }
            component.set("v.premiumBrandsList", premiumBrandOpts);
            component.set("v.Spinner",false);
        });
        
        $A.enqueueAction(getUser);
        $A.enqueueAction(action); 
        $A.enqueueAction(competitors);
        $A.enqueueAction(premiumBrands);
    },
    handleSaveRecord : function(component, event, helper) {
        var finame = component.find("firstnameId").get("v.value");
        // console.log('fname1'+finame);
        var saveButton = component.find("SavebuttonId");
        //console.log('fname1'+saveButton);
        saveButton.set("v.disabled", true);
        helper.getandsetValues(component);
        saveButton.set("v.disabled", false);
        //component.find("SavebuttonId").set("v.disabled", false);
    },
    handleIndustryElements : function(component, event, helper) {
        helper.handleIndustryElementsHelper(component);
    },
    
    saveAndSync : function(component, event, helper) {
        var createSap = true;
        var saveSyncButton = component.find("SaveSyncId");
        saveSyncButton.set("v.disabled", true);
        console.log('save nd sync');
        helper.getandsetValues(component,createSap);
        saveSyncButton.set("v.disabled", false);
        
    },
    getDependantValues : function(component, event, helper) {
        var event = event.getSource();
        var eventId = event.getLocalId();
        //console.log('onchange event'+eventId);
        helper.nullifyDependants(component, eventId);
        var sod = component.find("salesorgId").get("v.value");
        if(sod!= '' && sod!= 'undefined')
            helper.fetchDependants(component);
    },
    doCancel : function(component){
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Account"
        });
        homeEvt.fire();
    },
})
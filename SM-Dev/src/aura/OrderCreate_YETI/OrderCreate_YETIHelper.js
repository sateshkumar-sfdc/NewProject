({
    getData: function(cmp, lineobj) {
        console.log('test2');
        cmp.set("v.spinner", true);
        console.log(cmp.get("v.recID") + cmp.get("v.AccountID") + cmp.find("ordertypeid").get("v.value") + cmp.find("Salesorgid").get("v.value") + cmp.find("distributionchannelid").get("v.value") + "--" + cmp.find("Divisionid").get("v.value") + "--" + cmp.find("SalesOfficeid11").get("v.value"));
        console.log(cmp.find("SoldToid").get("v.value") + "--" + cmp.get("v.SalesGroup") + "--" + cmp.find("shiptoadd").get("v.value") + "--" + cmp.find("customerpoid").get("v.value") + "--" + cmp.find("Contactid").get("v.value") + "--" + cmp.find("companycodeid").get("v.value") + "--" + cmp.find("csaId").get("v.value") + "--" + cmp.find("EmailId1").get("v.value") + "--" + cmp.find("podateId").get("v.value") + "--" + cmp.find("ShipdateId").get("v.value") + "--" + cmp.find("deposittermsid").get("v.value"));
        console.log(cmp.find("paymenttermsid").get("v.value") + cmp.find("phoneid").get("v.value"));
        var oppId;
        if (cmp.get("v.fromOrder") == true) {
            oppId = cmp.get("v.OpportunityID");
        } else {
            oppId = cmp.get("v.recID");
        }
			console.log('contactId-->'+cmp.find("Contactid").get("v.value"));
	        var orderobj = {
            "AOpportunityID": oppId,
            "AAccountID": cmp.get("v.AccountID"),
            "Doc_Type": cmp.find("ordertypeid").get("v.value"),
            "SalesOrg": cmp.find("Salesorgid").get("v.value"),
            "DistributionChannel": cmp.find("distributionchannelid").get("v.value"),
            "Division": cmp.find("Divisionid").get("v.value"),
            "SalesOffice": cmp.find("SalesOfficeid11").get("v.value"),
            "SoldToCtomerNo": cmp.find("SoldToid").get("v.value"),
            "Salesgroup": cmp.get("v.SalesGroup"),
            "ShipToCustomerNo": cmp.find("shiptoadd").get("v.value"),
            "CustomerPo": cmp.find("customerpoid").get("v.value"),
            "ContactID": cmp.find("Contactid").get("v.value"),
            "companycode": cmp.find("companycodeid").get("v.value"),
            "CustomerShipAccount": cmp.find("csaId").get("v.value"),
            "Emailaddress": cmp.find("EmailId1").get("v.value"),
            "Podate": cmp.find("podateId").get("v.value"),
            "ReqShipDate": cmp.find("ShipdateId").get("v.value"),
            "DepositTerms": cmp.find("deposittermsid").get("v.value"),
            "PaymentTerms": cmp.find("paymenttermsid").get("v.value"),
            "Phonenumber": cmp.find("phoneid").get("v.value"),
            "SapOrderNumber": cmp.get("v.sapOrderNumber"),
            "ShippingInstructions": cmp.find("shippingInstructionsId").get("v.value")



        };
        console.log('TYest--->' + cmp.find("SalesOfficeid11").get("v.value"));
        var myJSON = JSON.stringify(orderobj);

        var action = cmp.get("c.getLineItems");
        action.setParams({
            "prdobj": lineobj,
            "recId": cmp.get("v.orderid"),
            "ordobj": myJSON

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result1 = response.getReturnValue();

                // var result2 = Object.assign({pName:lineobj.Name}, result1);
                console.log('hello');
                console.log(result1);
                console.log('hello2');
                result1.pName = lineobj.Name;
                result1.productkey__c;
                result1.Discount__c;
                result1.Line_Total__c;
                result1.LineTax__c;
                console.log(result1);
                var listofSelectedItems1 = cmp.get("v.Lineitemslist");
                listofSelectedItems1.push(result1);
                console.log('listofitems-->' + listofSelectedItems1);
                cmp.set('v.Lineitemslist', listofSelectedItems1);

                cmp.set('v.orderid', result1.OrderId);

                console.log("working-->");
                console.log(response.getReturnValue());



            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            cmp.set("v.spinner", false)
        });
        $A.enqueueAction(action);
    },


    getDeletedStatus: function(cmp, items, allLineItems, i) {
        cmp.set("v.spinner", true);
        var toDelete = cmp.get("c.deleteLineItem");
        toDelete.setParams({
            "ordItm": items
        });
        toDelete.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("message" + allLineItems[i].IsCreated__c);
                if (allLineItems[i].IsCreated__c != true) {
                    allLineItems.splice(i, 1);
                } else {
                    var delList = cmp.get("v.LineitemsDeletedlist");
                    delList.push(allLineItems[i]);
                    cmp.set("v.LineitemsDeletedlist", delList);
                    cmp.set("v.deleteList",true);
                    console.log("dell--" + delList);
                    allLineItems.splice(i, 1);
                }
                console.log("Ivalue-->" + i);
                cmp.set("v.Lineitemslist", allLineItems);
                cmp.set("v.spinner", false);
            }

        });
        $A.enqueueAction(toDelete);

    },

    showToast: function(cmp, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    checkvalidation: function(cmp, event, helper) {
        var isValid = true;
        var lineitemlst = cmp.get("v.Lineitemslist");
        for (var i = 0; i < lineitemlst.length; i++) {
            console.log(lineitemlst[i].AvailableQuantity__c);
            if (lineitemlst[i].AvailableQuantity__c) {
                console.log('quantity is not null');
            } else {
                isValid = false;
                console.log('quantity is null');
            }
        }
        console.log('before retun' + isValid);
        return isValid;
    },

    ValidateFormFields: function(cmp, event) {


        var isValid = true;
        var vordertype = cmp.find("ordertypeid");
        var vordertype1 = vordertype.get("v.value");
         console.log('11'+vordertype1);        
        var vcustomerpoid = cmp.find("customerpoid");
        var vcustomerpoid1 = vcustomerpoid.get("v.value");
        console.log('12'+vcustomerpoid1); 
        var vContactid = cmp.find("Contactid");
        var vContactid1 = vContactid.get("v.value");
         console.log('13'+vContactid1);
        var vphoneid = cmp.find("phoneid");
        var vphoneid1 = vphoneid.get("v.value");
         console.log('14'+cmp.find("phoneid").get("v.value"));
        var vSalesorgid = cmp.find("Salesorgid");
        var vSalesorgid1 = vSalesorgid.get("v.value");
         console.log('15'+vSalesorgid1);
        var vdeposittermsid = cmp.find("deposittermsid");
        var vdeposittermsid1 = vdeposittermsid.get("v.value");
         console.log('16'+vdeposittermsid1);
        var vpaymenttermsid = cmp.find("paymenttermsid");
        var vpaymenttermsid1 = vpaymenttermsid.get("v.value");
         console.log('17'+vpaymenttermsid1);
        var vSoldToid = cmp.find("SoldToid");
        var vSoldToid1 = vSoldToid.get("v.value");
        console.log('18'+vSoldToid1);
        var vdistributionchannelid = cmp.find("distributionchannelid");
        var vdistributionchannelid1 = vdistributionchannelid.get("v.value");
         console.log('19'+vdistributionchannelid1);
        var vDivisionid = cmp.find("Divisionid");
        var vDivisionid1 = vDivisionid.get("v.value");
         console.log('20'+vDivisionid1);
        var vcompanycodeid = cmp.find("companycodeid");
        var vcompanycodeid1 = vcompanycodeid.get("v.value");
         console.log('21'+vcompanycodeid1);
        var vshiptoadd = cmp.find("shiptoadd");
        var vshiptoadd1 = vshiptoadd.get("v.value");
         console.log("shipto");
         console.log('22'+vshiptoadd1);
        var vSalesOfficeid = cmp.find("SalesOfficeid11");
        var vSalesOfficeid1 = vSalesOfficeid.get("v.value");

        console.log('23'+vSalesOfficeid1);

        if ((vordertype1 == null) || (vordertype1 == "") || (vordertype1 == " ")) {

            //vordertype.focus();
            vordertype.showHelpMessageIfInvalid();
            isValid = false;
            console.log(isValid);
        }

      /*  if ((vcustomerpoid1 == null) || (vcustomerpoid1 == "") || (vcustomerpoid1 == " ") || (vcustomerpoid1 == 'undefined')) {

            vcustomerpoid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }*/

        if ((vContactid1 == null) || (vContactid1 == "") || (vContactid1 == " ") || (vContactid1 == "undefined")) {

            vContactid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vphoneid1 == null) || (vphoneid1 == "") || (vphoneid1 == " ") || (vphoneid1 == "undefined")) {

            vphoneid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vSalesorgid1 == null) || (vSalesorgid1 == "") || (vSalesorgid1 == " ") || (vSalesorgid1 == "undefined")) {

            vSalesorgid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vdeposittermsid1 == null) || (vdeposittermsid1 == "") || (vdeposittermsid1 == " ") || (vdeposittermsid1 == "undefined")) {

            vdeposittermsid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vpaymenttermsid1 == null) || (vpaymenttermsid1 == "") || (vpaymenttermsid1 == " ") || (vpaymenttermsid1 == "undefined")) {

            vpaymenttermsid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vSoldToid1 == null) || (vSoldToid1 == "") || (vSoldToid1 == " ") || (vSoldToid1 == "undefined")) {

            vSoldToid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vdistributionchannelid1 == null) || (vdistributionchannelid1 == "") || (vdistributionchannelid1 == " ") || (vdistributionchannelid1 == "undefined")) {

            vdistributionchannelid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vDivisionid1 == null) || (vDivisionid1 == "") || (vDivisionid1 == " ") || (vDivisionid1 == "undefined")) {

            vDivisionid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vcompanycodeid1 == null) || (vcompanycodeid1 == "") || (vcompanycodeid1 == " ") || (vcompanycodeid1 == "undefined")) {

            vcompanycodeid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vshiptoadd1 == null) || (vshiptoadd1 == "") || (vshiptoadd1 == " ") || (vshiptoadd1 == "undefined")) {

            vshiptoadd.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }

        if ((vSalesOfficeid1 == null) || (vSalesOfficeid1 == "") || (vSalesOfficeid1 == " ") || (vSalesOfficeid1 == "undefined")) {

            vSalesOfficeid.showHelpMessageIfInvalid();

            isValid = false;
            console.log(isValid);
        }
console.log(isValid);
        return isValid;

    },

    // Order Update related functions//
    disableFields: function(component) {


       // component.find("AccountNameId").set("v.disabled", true);

        component.find("Contactid").set("v.disabled", true);
        component.find("phoneid").set("v.disabled", true);
        //component.find("customerpoid").set("v.disabled", true); 
        component.find("podateId").set("v.disabled", true);
        component.find("EmailId1").set("v.disabled", true);
        component.find("comments").set("v.disabled", true);
        component.find("deposittermsid").set("v.disabled", true);
        component.find("paymenttermsid").set("v.disabled", true);
        component.find("distributionchannelid").set("v.disabled", true);
        component.find("Salesorgid").set("v.disabled", true);
        component.find("Divisionid").set("v.disabled", true);
        component.find("SalesOfficeid11").set("v.disabled", true);
        component.find("companycodeid").set("v.disabled", true);
        component.find("carsec").set("v.disabled", true);
        component.find("shiptoadd").set("v.disabled", true);
        component.find("SoldToid").set("v.disabled", true);
        component.find("csaId").set("v.disabled", true);
        //component.find("ShipdateId").set("v.disabled", true);
        component.find("CustomerDiscountConditionGroupId").set("v.disabled", true);
        component.find("CustomerFreightConditionGroupId").set("v.disabled", true);

        console.log("hello123");

    },

    getInitialLoad: function(component, reciD) {

        var action1 = component.get("c.getAccountAddress");
        action1.setParams({
            recordId: reciD
        });
        action1.setCallback(this, function(response) {
            var result = response.getReturnValue();
            component.set("v.Accountobj", (result.accobj));
            component.set("v.AccountID", ((result.accobj).Id));
            component.set("v.SalesGroup", ((result.accobj).SalesGroup__c));
            console.log('ship to-=--'+((result.accobj).ShipToCustomerNo__c));
            var orderTypeList = [];
            for (var key in (result.ordertype)) {
                var ordertype = {
                    key: key,
                    value: (result.ordertype)[key]
                }
                orderTypeList.push(ordertype);
                console.log(key);
                console.log((result.ordertype)[key]);
            }
            component.set("v.ordertype", orderTypeList);
            var discountList = [];
            for (var key1 in (result.discountCondition)) {
                var discount = {
                    key: key1,
                    value: (result.discountCondition)[key1]
                }
                discountList.push(discount);
                // console.log('t'+key1);
                //console.log((result.discountCondition)[key1]);
            }

            //console.log(discountList);
            component.set("v.discountCondList", discountList);

            var freightList = [];
            for (var key2 in (result.freightCondition)) {
                var freight = {
                    key: key2,
                    value: (result.freightCondition)[key2]
                }
                freightList.push(freight);
                //console.log('t'+key2);
                //console.log((result.freightCondition)[key2]);
            }

            //console.log(freightList);
            component.set("v.freightCondList", freightList);


        });
        $A.enqueueAction(action1);

    },

    navigatetoobject: function(cmp, event, objectid) {

        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": objectid,
            "slideDevName": "detail"
        });
        navEvt.fire();

    }

})
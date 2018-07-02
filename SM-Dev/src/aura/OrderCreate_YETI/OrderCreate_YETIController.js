({
    doInit: function(component, event, helper) {

        var reciD = component.get("v.recID");


        console.log("record-->" + reciD + component.get("v.fromOrder"));
        console.log('del list-->'+component.get("v.LineitemsDeletedlist"));

        if (component.get("v.fromOrder") != true) {
            /*  var action1 = component.get("c.getAccountAddress");
              action1.setParams({
                  recordId: reciD
              });
              action1.setCallback(this, function(response) {
                  var result = response.getReturnValue();
                  component.set("v.Accountobj", (result.accobj));
                  component.set("v.AccountID", ((result.accobj).Id));
                  component.set("v.SalesGroup", ((result.accobj).SalesGroup__c));
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
              $A.enqueueAction(action1); */
            helper.getInitialLoad(component, reciD);
        } else {
            component.set("v.orderid", reciD);
           
            helper.disableFields(component);
            //helper.getInitialLoad(component,reciD);
            var getOrder = component.get("c.getOrderResponse");
            getOrder.setParams({
                recordId: reciD
            });
            getOrder.setCallback(this, function(getOrderResponse) {
                var result = getOrderResponse.getReturnValue();
                console.log("Returned Order");
                console.log("ord date shipto" + result.ord.ShipToCustomerNo__c + result.ord.Type + "--->" + result.ord.PoDate);
                console.log(result.orderItems);
                component.set("v.Accountobj", (result.ord));
                component.set("v.Lineitemslist", (result.orderItems));
                console.log("ordPhone"+result.ord.Phone__c);
               // component.find("phoneid").set("v.value", result.ord.Phone__c);
               // console.log("set phone value"+component.find("phoneid").set("v.value"));
                component.find("AccountNameId").set("v.value", result.ord.Account.Name);
                component.find("Contactid").set("v.value", result.ord.BillToContactId);

                component.find("SalesOfficeid11").set("v.value", result.ord.SalesOffice__c);
                console.log('test ord type');
                component.find("customerpoid").set("v.value", result.ord.CustomerPo__c);
				component.find("companycodeid").set("v.value", result.ord.CompanyCode__c);
                component.find("podateId").set("v.value", result.ord.PoDate);
                component.find("ShipdateId").set("v.value", result.ord.RequestedShipDate__c);
                component.find("deposittermsid").set("v.value", result.ord.DepositTerms__c);
                component.find("paymenttermsid").set("v.value", result.ord.PaymentTerms__c);
                component.find("carsec").set("v.value", result.ord.ShippingCondition__c);

                component.find("SoldToid").set("v.value", result.ord.SAPCustomerNumber__c);
                component.find("shiptoadd").set("v.value", result.ord.ShipToCustomerNo__c);
                component.find("ordertypeid").set("v.value", result.ord.Type);
                component.find("csaId").set("v.value", result.ord.CustomerShipAccount__c);


                component.set("v.SalesGroup", result.ord.SalesGroup__c);
                component.set("v.AccountID", result.ord.AccountId);
                component.set("v.OpportunityID", result.ord.OpportunityId);
                component.set("v.sapOrderNumber", result.ord.SAP_Order_Number__c);

                component.find("CustomerDiscountConditionGroupId").set("v.value", result.ord.CustomerDiscountConditionGroup__c);
                component.find("CustomerFreightConditionGroupId").set("v.value", result.ord.CustomerFreightConditionGroup__c);
                component.find("shippingInstructionsId").set("v.value", result.ord.ShippingInstructions__c);

                console.log("test value-->" +result.ord.ShippingInstructions__c);

                var orderTypeList1 = [];
                for (var key in (result.ordertype1)) {
                    var ordertype1 = {
                        key: key,
                        value: (result.ordertype1)[key]
                    }
                    orderTypeList1.push(ordertype1);
                    console.log('tt' + key);
                    console.log((result.ordertype1)[key]);
                }
                component.set("v.ordertype", orderTypeList1);
                console.log(result.ord.Type);
                component.set("v.ordType1", result.ord.Type)
                console.log("ttttt--" + component.get("v.ordType1"));
                //component.find("ordertypeid11").set("v.value",result.ord.Type);
                //component.find("ordertypeid").set("v.disabled", true);


            });
            $A.enqueueAction(getOrder);
        }


    },


    handleApplicationEvent: function(cmp, event, helper) {

        var lineobj = event.getParam("lineitems");
        console.log('test1');
        helper.getData(cmp, lineobj);

    },


    getRecordId: function(cmp, event, helper) {
        var selectedLineItem = event.getSource().get("v.name");
        var allLineItems = cmp.get("v.Lineitemslist");

        for (var i = 0; i < allLineItems.length; i++) {
            if (allLineItems[i].Id == selectedLineItem) {
                var items = allLineItems[i];
                helper.getDeletedStatus(cmp, items, allLineItems, i);
                var message = (items.Product2).Name + " " + "is Removed!";
                helper.showToast(cmp, 'Removed!', message, 'info');

            }
        }

    },


    getPricing: function(cmp, event, helper) {

        var lineitemlst = cmp.get("v.Lineitemslist");
        console.log(lineitemlst);
        let OrderScreenFields = {
            "ShipToCustomerNo": cmp.find("shiptoadd").get("v.value"),
                "SoldToCtomerNo": cmp.find("SoldToid").get("v.value"),
                "SalesOffice": cmp.find("SalesOfficeid11").get("v.value"),
                "SalesOrg": cmp.find("Salesorgid").get("v.value"),
                "Doc_Type": cmp.find("ordertypeid").get("v.value"),
                "Division": cmp.find("Divisionid").get("v.value"),
                "DistributionChannel": cmp.find("distributionchannelid").get("v.value"),
                "CustomerPo": cmp.find("customerpoid").get("v.value"),
                "Salesgroup": cmp.get("v.SalesGroup"),
                "Podate": cmp.find("podateId").get("v.value"),
                "ReqShipDate": cmp.find("ShipdateId").get("v.value"),
                "CustomerPo": cmp.find("customerpoid").get("v.value"),
                "AAccountID": cmp.get("v.AccountID"),
                "ContactID": cmp.find("Contactid").get("v.value"),
                "Phonenumber": cmp.find("phoneid").get("v.value"),
           
                "Emailaddress": cmp.find("EmailId1").get("v.value"),
                "CustomerDiscountCondition": cmp.find("CustomerDiscountConditionGroupId").get("v.value"),
                "CustomerFreightCondition": cmp.find("CustomerFreightConditionGroupId").get("v.value"),
                "DepositTerms": cmp.find("deposittermsid").get("v.value"),
                "PaymentTerms": cmp.find("paymenttermsid").get("v.value"),
                "companycode": cmp.find("companycodeid").get("v.value"),
                "shippingmethod": cmp.find("carsec").get("v.value"),
                "CustomerShipAccount": cmp.find("csaId").get("v.value"),
                "SapOrderNumber": cmp.get("v.sapOrderNumber"),
                "ShippingInstructions": cmp.find("shippingInstructionsId").get("v.value")
            	
        }
        if (lineitemlst.length > 0) {

            if (helper.ValidateFormFields(cmp, event)) {
                console.log('2');
                if (helper.checkvalidation(cmp)) {
                    console.log('1');
                    cmp.set("v.spinner", true);
                    var getSapPricing = cmp.get("c.getPriceSimulation");
                    getSapPricing.setParams({
                        orderScreenInputs: JSON.stringify(OrderScreenFields),
                        orderLitems: cmp.get("v.Lineitemslist"),
                        orderid: cmp.get("v.orderid")
                    });
                    getSapPricing.setCallback(this, function(response) {
                        var PricingResult = response.getReturnValue();
                        console.log('pricing');
                        console.log(PricingResult);
                        var lineItemList = cmp.get("v.Lineitemslist");
                        cmp.set("v.Lineitemslist", null);
                        cmp.set("v.Lineitemslist", PricingResult);
                        cmp.set("v.spinner", false);
                    });
                    $A.enqueueAction(getSapPricing);
                } else {
                    //alert('delete the line item of no Quantity Available');
                    var message = "Remove the line item of no Quantity Available";
                    helper.showToast(cmp, 'Remove!', message, 'error');
                }
            } else {
                var message = "Required Fields Are Missing!";
                helper.showToast(cmp, 'Missing!', message, 'error');
            }
        } else {

            var toastEvent = $A.get("e.force:showToast");
            var message = "Please Add LineItems For Pricing";
            helper.showToast(cmp, 'Missing!', message, 'info');
            //console.log('list is null');
            //alert('List is null');
        }
    },

    ronChange: function(cmp, event, helper) {
        var acc = cmp.find("shiptoadd").get("v.value");
        var listitemid = event.target.name;
        var lineitemlst = cmp.get("v.Lineitemslist");
        for (var i = 0; i < lineitemlst.length; i++) {
            if (lineitemlst[i].Id == listitemid) {
                //console.log(lineitemlst[i].Quantity);
                lineitemlst[i].Quantity = event.target.value;
            }
        }
        cmp.set("v.Lineitemslist", lineitemlst);
        //console.log(cmp.get("v.Lineitemslist"));

    },


    /*getvalue : function(cmp,event){
       console.log(event.getSource().get("v.value")); 
        
    },*/

    createOrder: function(cmp, event, helper) {
        if (helper.ValidateFormFields(cmp, event)) {
            cmp.set("v.show", true);

            var orderobj = {
               "ShipToCustomerNo": cmp.find("shiptoadd").get("v.value"),
                "SoldToCtomerNo": cmp.find("SoldToid").get("v.value"),
                "SalesOffice": cmp.find("SalesOfficeid11").get("v.value"),
                "SalesOrg": cmp.find("Salesorgid").get("v.value"),
                "Doc_Type": cmp.find("ordertypeid").get("v.value"),
                "Division": cmp.find("Divisionid").get("v.value"),
                "DistributionChannel": cmp.find("distributionchannelid").get("v.value"),
                "CustomerPo": cmp.find("customerpoid").get("v.value"),
                "Salesgroup": cmp.get("v.SalesGroup"),
                "Podate": cmp.find("podateId").get("v.value"),
                "ReqShipDate": cmp.find("ShipdateId").get("v.value"),
                "CustomerPo": cmp.find("customerpoid").get("v.value"),
                "AAccountID": cmp.get("v.AccountID"),
                "ContactID": cmp.find("Contactid").get("v.value"),
                "Phonenumber": cmp.find("phoneid").get("v.value"),
                "Emailaddress": cmp.find("EmailId1").get("v.value"),
                "CustomerDiscountCondition": cmp.find("CustomerDiscountConditionGroupId").get("v.value"),
                "CustomerFreightCondition": cmp.find("CustomerFreightConditionGroupId").get("v.value"),
                "DepositTerms": cmp.find("deposittermsid").get("v.value"),
                "PaymentTerms": cmp.find("paymenttermsid").get("v.value"),
                "companycode": cmp.find("companycodeid").get("v.value"),
                "shippingmethod": cmp.find("carsec").get("v.value"),
                "CustomerShipAccount": cmp.find("csaId").get("v.value"),
                "SapOrderNumber": cmp.get("v.sapOrderNumber"),
                "ShippingInstructions": cmp.find("shippingInstructionsId").get("v.value")
                
            };
            var orderfields = JSON.stringify(orderobj);
            var OrderCreate = cmp.get("c.createSAPOrder");
            OrderCreate.setParams({
                "recordId": cmp.get("v.orderid"),
                "orderRecord": orderfields
            });
            OrderCreate.setCallback(this, function(response) {
                var OrderResponse = response.getReturnValue();
                if (OrderResponse == "Success") {
                    cmp.set("v.show", false);
                    var objectid = cmp.get("v.orderid");
                    helper.navigatetoobject(cmp, event, objectid);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire();
                }

            });
            $A.enqueueAction(OrderCreate);
        } else {
            var message = "Required Fields Are Missing!";
            helper.showToast(cmp, 'Missing!', message, 'error');
        }
    },

    createUpdateOrder: function(cmp, event, helper) {
        if (helper.ValidateFormFields(cmp, event)) {
            cmp.set("v.show", true);
            var orderobjforupsert = {
                "ShipToCustomerNo": cmp.find("shiptoadd").get("v.value"),
                "SoldToCtomerNo": cmp.find("SoldToid").get("v.value"),
                "SalesOffice": cmp.find("SalesOfficeid11").get("v.value"),
                "SalesOrg": cmp.find("Salesorgid").get("v.value"),
                "Doc_Type": cmp.find("ordertypeid").get("v.value"),
                "Division": cmp.find("Divisionid").get("v.value"),
                "DistributionChannel": cmp.find("distributionchannelid").get("v.value"),
                "CustomerPo": cmp.find("customerpoid").get("v.value"),
                "Salesgroup": cmp.get("v.SalesGroup"),
                "Podate": cmp.find("podateId").get("v.value"),
                "ReqShipDate": cmp.find("ShipdateId").get("v.value"),
                "CustomerPo": cmp.find("customerpoid").get("v.value"),
                "AAccountID": cmp.get("v.AccountID"),
                "ContactID": cmp.find("Contactid").get("v.value"),
                "Phonenumber": cmp.find("phoneid").get("v.value"),
                "Emailaddress": cmp.find("EmailId1").get("v.value"),
                "CustomerDiscountCondition": cmp.find("CustomerDiscountConditionGroupId").get("v.value"),
                "CustomerFreightCondition": cmp.find("CustomerFreightConditionGroupId").get("v.value"),
                "DepositTerms": cmp.find("deposittermsid").get("v.value"),
                "PaymentTerms": cmp.find("paymenttermsid").get("v.value"),
                "companycode": cmp.find("companycodeid").get("v.value"),
                "shippingmethod": cmp.find("carsec").get("v.value"),
                "CustomerShipAccount": cmp.find("csaId").get("v.value"),
                "SapOrderNumber": cmp.get("v.sapOrderNumber"),
                "ShippingInstructions": cmp.find("shippingInstructionsId").get("v.value")
                

            };
            console.log("Teyts" + cmp.find("SalesOfficeid11").get("v.value"));
            var ordCreateUpdatefields = JSON.stringify(orderobjforupsert);
            var OrderCreateUpdate = cmp.get("c.createUpdateSAPOrder");
            OrderCreateUpdate.setParams({
                "recordId": cmp.get("v.orderid"),
                "orderRec": ordCreateUpdatefields
            });
            OrderCreateUpdate.setCallback(this, function(OrderCreateUpdateresponse) {
                var OrdcreateResponse = OrderCreateUpdateresponse.getReturnValue();
                if (OrdcreateResponse == "SUCCESS") {
                    cmp.set("v.show", false);
                    var ordobjectid = cmp.get("v.orderid");
                    helper.navigatetoobject(cmp, event, ordobjectid);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire();
                }

            });
            $A.enqueueAction(OrderCreateUpdate);
        }
    },

    onCancle: function(cmp, event, helper) {

        var oppid = cmp.get("v.recID");
        helper.navigatetoobject(cmp, event, oppid);

    },

    AddEmbellishment: function(component, event, helper) {
        
       
      
       // window.scrollTo(0, 0);
       //document.body.setAttribute('style', 'overflow: hidden;');
      // window.addEventListener('scroll', noscroll);
       var productkey = event.getSource().get("v.name");
        console.log("concatinate");
        // var str = productkey.toString();
        var n = productkey.lastIndexOf('/');
        var LineItemID = productkey.substring(n + 1);
        var UPK = productkey.substring(0, n);
        //console.log(productkey.substring(0,n));
        console.log('test1');
        $A.createComponent(
            "c:Customizer", {
                "UPK": UPK,
                "itemID": LineItemID
            },

            function(newcomponent) {
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newcomponent);
                    component.set("v.body", body);
                }
            }
        );
    },

    handleComponentEventFired: function(component, event, helper) {
        console.log("componeteventdata");
        console.log(event.getParam("customizerdata"));
        console.log(event.getParam("ItemId"));
        //component.set("v.customizerdataList",event.getParam("customizerdata"));
        var customjson1 = JSON.stringify(event.getParam("customizerdata"));
        console.log('hai');
        //console.log(customjson1.replace("\\", ""));
        var customizerJson = (event.getParam("customizerdata").toString());

        var action = component.get("c.getCustomLineItems");
        action.setParams({
            customizerJson: customjson1,
            itemId: event.getParam("ItemId"),
            orderid: component.get("v.orderid")

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var listofitems = component.get("v.Lineitemslist");
                console.log('listitems-->');
                console.log(listofitems);
                for (var i = 0; i < listofitems.length; i++) {

                    if (listofitems[i].Id == event.getParam("ItemId")) {
                        listofitems[i].Order_Products__r = response.getReturnValue();
                        listofitems[i].jsondata = customjson1;
                    }
                }
                component.set("v.Lineitemslist", listofitems);
                
                console.log(listofitems);
            }

        });

        $A.enqueueAction(action);


    },

    sendToVF: function(component, event, helper) {

        var productkey = event.getSource().get("v.name");
        console.log("concatinate");
        // var str = productkey.toString();
        // var n = str.lastIndexOf('/');
        //var result = str.substring(n + 1);
        console.log(productkey);
        var modalBody;
        $A.createComponent(
            "c:Customizer", {
                "UPK": productkey
            },
            function(content, status) {
                console.log(status);
                console.log(content);
                if (status === "SUCCESS") {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        header: "Application Confirmation",
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: "mymodal",
                        closeCallback: function() {
                            alert('You closed the alert!');
                        }
                    })
                }
            });
    },
    
    productstab : function(cmp,event,helper) {
        var ProductsTab = cmp.find("ProductsId");
        var ProductsDataTab = cmp.find("ProductsDataId");
        
        var Itemstab2 = cmp.find("ItemsId");
        var ItemsDataTab = cmp.find("ItemsDataId");
        
        var AddressTab = cmp.find("AddressId");
        var AddressDataTab = cmp.find("AddressDataId");
        
        var StatusTab = cmp.find("StatusId");
        var StatusDataTab = cmp.find("StatusDataId");
        
        var DetailsTab = cmp.find("DetailsId");
        var DetailsDataTab = cmp.find("DetailsDataId");
        
        
        $A.util.addClass(ProductsTab, 'slds-active');
        $A.util.addClass(ProductsDataTab, 'slds-show');
        $A.util.removeClass(ProductsDataTab, 'slds-hide');
        
        $A.util.removeClass(Itemstab2, 'slds-active');
        $A.util.removeClass(ItemsDataTab, 'slds-show');
        $A.util.addClass(ItemsDataTab, 'slds-hide');
 
        $A.util.removeClass(AddressTab, 'slds-active');
        $A.util.removeClass(AddressDataTab, 'slds-show');
        $A.util.addClass(AddressDataTab, 'slds-hide');
        
        $A.util.removeClass(StatusTab, 'slds-active');
        $A.util.removeClass(StatusDataTab, 'slds-show');
        $A.util.addClass(StatusDataTab, 'slds-hide');
        
        $A.util.removeClass(DetailsTab, 'slds-active');
        $A.util.removeClass(DetailsDataTab, 'slds-show');
        $A.util.addClass(DetailsDataTab, 'slds-hide');
      
    },
    
    ItemsTab : function(cmp,event,helper) {
        
        
        var Itemstab2 = cmp.find("ItemsId");
        var ItemsDataTab = cmp.find("ItemsDataId");
        
        var AddressTab = cmp.find("AddressId");
        var AddressDataTab = cmp.find("AddressDataId");
        
        var ProductsTab = cmp.find("ProductsId");
        var ProductsDataTab = cmp.find("ProductsDataId");
        
        var StatusTab = cmp.find("StatusId");
        var StatusDataTab = cmp.find("StatusDataId");
        
        var DetailsTab = cmp.find("DetailsId");
        var DetailsDataTab = cmp.find("DetailsDataId");
        
        
        $A.util.addClass(Itemstab2, 'slds-active');
        $A.util.removeClass(ItemsDataTab, 'slds-hide');
        $A.util.addClass(ItemsDataTab, 'slds-show');
        
         $A.util.removeClass(AddressTab, 'slds-active');
        $A.util.removeClass(AddressDataTab, 'slds-show');
        $A.util.addClass(AddressDataTab, 'slds-hide');
 
        $A.util.removeClass(ProductsTab, 'slds-active');
        $A.util.removeClass(ProductsDataTab, 'slds-show');
        $A.util.addClass(ProductsDataTab, 'slds-hide');
        
         $A.util.removeClass(StatusTab, 'slds-active');
        $A.util.removeClass(StatusDataTab, 'slds-show');
        $A.util.addClass(StatusDataTab, 'slds-hide');
        
        $A.util.removeClass(DetailsTab, 'slds-active');
        $A.util.removeClass(DetailsDataTab, 'slds-show');
        $A.util.addClass(DetailsDataTab, 'slds-hide');
       
    },
    
     AddressTab : function(cmp,event,helper) {
        
        
        var Itemstab2 = cmp.find("ItemsId");
        var ItemsDataTab = cmp.find("ItemsDataId");
        
        var AddressTab = cmp.find("AddressId");
        var AddressDataTab = cmp.find("AddressDataId");
        
        var ProductsTab = cmp.find("ProductsId");
        var ProductsDataTab = cmp.find("ProductsDataId");
         
        var StatusTab = cmp.find("StatusId");
        var StatusDataTab = cmp.find("StatusDataId");
        
        var DetailsTab = cmp.find("DetailsId");
        var DetailsDataTab = cmp.find("DetailsDataId"); 
        
        
        $A.util.addClass(AddressTab, 'slds-active');
        $A.util.removeClass(AddressDataTab, 'slds-hide');
        $A.util.addClass(AddressDataTab, 'slds-show');
        
         $A.util.removeClass(Itemstab2, 'slds-active');
        $A.util.removeClass(ItemsDataTab, 'slds-show');
        $A.util.addClass(ItemsDataTab, 'slds-hide');
 
        $A.util.removeClass(ProductsTab, 'slds-active');
        $A.util.removeClass(ProductsDataTab, 'slds-show');
        $A.util.addClass(ProductsDataTab, 'slds-hide');
        
         $A.util.removeClass(StatusTab, 'slds-active');
        $A.util.removeClass(StatusDataTab, 'slds-show');
        $A.util.addClass(StatusDataTab, 'slds-hide');
        
        $A.util.removeClass(DetailsTab, 'slds-active');
        $A.util.removeClass(DetailsDataTab, 'slds-show');
        $A.util.addClass(DetailsDataTab, 'slds-hide');
       
    }, 
    
    StatusTab : function(cmp,event,helper) {
        
        
        var Itemstab2 = cmp.find("ItemsId");
        var ItemsDataTab = cmp.find("ItemsDataId");
        
        var AddressTab = cmp.find("AddressId");
        var AddressDataTab = cmp.find("AddressDataId");
        
        var ProductsTab = cmp.find("ProductsId");
        var ProductsDataTab = cmp.find("ProductsDataId");
         
        var StatusTab = cmp.find("StatusId");
        var StatusDataTab = cmp.find("StatusDataId");
        
        var DetailsTab = cmp.find("DetailsId");
        var DetailsDataTab = cmp.find("DetailsDataId"); 
        
        
        $A.util.addClass(StatusTab, 'slds-active');
        $A.util.removeClass(StatusDataTab, 'slds-hide');
        $A.util.addClass(StatusDataTab, 'slds-show');
        
         $A.util.removeClass(Itemstab2, 'slds-active');
        $A.util.removeClass(ItemsDataTab, 'slds-show');
        $A.util.addClass(ItemsDataTab, 'slds-hide');
 
        $A.util.removeClass(ProductsTab, 'slds-active');
        $A.util.removeClass(ProductsDataTab, 'slds-show');
        $A.util.addClass(ProductsDataTab, 'slds-hide');
        
         $A.util.removeClass(AddressTab, 'slds-active');
        $A.util.removeClass(AddressDataTab, 'slds-show');
        $A.util.addClass(AddressDataTab, 'slds-hide');
        
        $A.util.removeClass(DetailsTab, 'slds-active');
        $A.util.removeClass(DetailsDataTab, 'slds-show');
        $A.util.addClass(DetailsDataTab, 'slds-hide');
       
    },    
    DetailsTab : function(cmp,event,helper) {
        
        
        var Itemstab2 = cmp.find("ItemsId");
        var ItemsDataTab = cmp.find("ItemsDataId");
        
        var AddressTab = cmp.find("AddressId");
        var AddressDataTab = cmp.find("AddressDataId");
        
        var ProductsTab = cmp.find("ProductsId");
        var ProductsDataTab = cmp.find("ProductsDataId");
         
        var StatusTab = cmp.find("StatusId");
        var StatusDataTab = cmp.find("StatusDataId");
        
        var DetailsTab = cmp.find("DetailsId");
        var DetailsDataTab = cmp.find("DetailsDataId"); 
        
        
        $A.util.addClass(DetailsTab, 'slds-active');
        $A.util.removeClass(DetailsDataTab, 'slds-hide');
        $A.util.addClass(DetailsDataTab, 'slds-show');
        
         $A.util.removeClass(Itemstab2, 'slds-active');
        $A.util.removeClass(ItemsDataTab, 'slds-show');
        $A.util.addClass(ItemsDataTab, 'slds-hide');
 
        $A.util.removeClass(ProductsTab, 'slds-active');
        $A.util.removeClass(ProductsDataTab, 'slds-show');
        $A.util.addClass(ProductsDataTab, 'slds-hide');
        
         $A.util.removeClass(AddressTab, 'slds-active');
        $A.util.removeClass(AddressDataTab, 'slds-show');
        $A.util.addClass(AddressDataTab, 'slds-hide');
        
        $A.util.removeClass(StatusTab, 'slds-active');
        $A.util.removeClass(StatusDataTab, 'slds-show');
        $A.util.addClass(StatusDataTab, 'slds-hide');
       
    },

})
({
    getandsetValues : function (component,createSap) {
        var isError = false;
        var recId = '';
        isError = this.checkForErrors(component, isError);
       // alert('test country'+component.get("v.acc.BillingCountry"));
        //console.log('after is error'+{!v.acc.BillingCountry});
        //  console.log('create sap value'+createSap);
        //var email = component.find("emailId").get("v.value");
        var origin = component.find("originId").get("v.value");
        console.log('1');
        //component.set("v.acc.Email__c", email);
        component.set("v.acc.OriginSource__c", origin);
        /* Manin Acc Info mapping end */
        //console.log(email+origin);
        /* address mapping start */
       /* var phoneField = component.find("phoneId");
        var phone = phoneField.get("v.value");
        component.set("v.acc.Phone", phone);*/
       /* var street = component.find("myaddress").get("v.street");
        var city = component.find("myaddress").get("v.city");
        var country = component.find("myaddress").get("v.country");
        var province = component.find("myaddress").get("v.province");
        var postalcode = component.find("myaddress").get("v.postalCode");
        component.set("v.acc.BillingStreet", street);
        component.set("v.acc.BillingCity", city);
        component.set("v.acc.BillingState", province);
        component.set("v.acc.BillingPostalCode", postalcode);
        component.set("v.acc.BillingCountry", country);
        component.set("v.acc.ShippingStreet", street);
        component.set("v.acc.ShippingCity", city);
        component.set("v.acc.ShippingState", province);
        component.set("v.acc.ShippingPostalCode", postalcode);
        component.set("v.acc.ShippingCountry", country);*/
        // console.log(street+city+country+province+postalcode);
        /* address mapping end */
        
        /* Billing mapping start */
        var payterms = component.find("paymentTermsId").get("v.value");
        var istaxable = component.find("taxableId").get("v.value");
        var retailLocation = component.find("retailLocationId").get("v.value");
        var isdistributioncenter = component.find("isdistributionId").get("v.value");
        var description = component.find("comments").get("v.value");
        var insideSales = component.find("insiderepId").get("v.value");
        var outsideSales = component.find("outsiderepId").get("v.value");
        var competitorVal = component.find("competitorsId").get("v.value");
        var premiumBrandVal = component.find("premiumbrandId").get("v.value");
        var taxexemptcert = component.find("taxexemptId").get("v.value");
        console.log('2');
        component.set("v.acc.Description", description);
        component.set("v.acc.PaymentTerms__c", payterms);
        component.set("v.acc.IsTaxable__c", istaxable);
        component.set("v.acc.Retail_Location__c", retailLocation);
        component.set("v.acc.Isdistributioncenter__c", isdistributioncenter);
        component.set("v.acc.TaxExemptCertificate__c", taxexemptcert);
        component.set("v.acc.Inside_Sales_Rep__c", insideSales);
        component.set("v.acc.Outside_Sales_Rep__c", outsideSales); 
        component.set("v.acc.Competitors__c", competitorVal);
        component.set("v.acc.Premium_Brands_Carried__c", premiumBrandVal);
        // console.log(insideSales+outsideSales);
        /* Billing mapping end */
        
        /* Accounting mapping start */
        var salesorg = component.find("salesorgId").get("v.value");
        //var companycode = component.find("companycodeId").get("v.value");
        //var reconciliation = component.find("reconciliationId").get("v.value");
        var division = component.find("divisionId").get("v.value");
        var distributionchannel = component.find("distributionchannelId").get("v.value");
        var salesoffice = component.find("salesofficeId").get("v.value");
        console.log('3');
        // console.log(salesorg+companycode+division+distributionchannel+salesoffice);
        
        var salesdist = component.find("salesdistrictId").get("v.value");
        var salesgroup = component.find("salesgroupId").get("v.value");
        var pricinggroup = component.find("pricinggroupId").get("v.value");
        var pricelist = component.find("pricelistId").get("v.value");
        var priceprocedure = component.find("priceprocedureId").get("v.value");
        console.log('4');
        console.log(salesdist+salesgroup+pricinggroup+pricelist+priceprocedure);
        component.set("v.acc.SalesOrg__c", salesorg);
        //component.set("v.acc.CompanyCode__c", companycode);
        component.set("v.acc.Division__c", division);
        component.set("v.acc.DistributionChannel__c", distributionchannel);
        component.set("v.acc.SalesOffice__c", salesoffice);
        component.set("v.acc.SalesDistrict__c", salesdist);
        component.set("v.acc.SalesGroup__c", salesgroup);
        component.set("v.acc.PricingGroup__c", pricinggroup);
        component.set("v.acc.PriceList__c", pricelist);
        component.set("v.acc.PriceProcedure__c", priceprocedure);
        /* Accounting mapping end */
        
        /* shipping mapping start */
        var shippingcond = component.find("shipconditionId").get("v.value");
        var custshipacc = component.find("customershipaccountId").get("v.value");
        component.set("v.acc.ShippingCondition__c", shippingcond);
        component.set("v.acc.CustomerShipAccount__c", custshipacc);
        // console.log('cust:'+shippingcond+custshipacc);
        var lastNamevalue ='' ;
        /* shipping mapping end */
        console.log('before save');
         if(isError !== true){
            component.set("v.error", '');
            var rec = component.get("v.acc");
            //console.log(isError+'acc recprd-->'+rec);
            var firstname = component.find("firstnameId").get("v.value");
            // console.log('fname and lname'+firstname+component.get("v.lastName"));           
            console.log('before save spinner');
            component.set("v.Spinner",true);
            var saveAcc = component.get("c.saveAccount");
            
            saveAcc.setParams({  "ac" : rec , "recType" : component.get('v.customerType') , "fname" : firstname , "lname" : component.get("v.lastName") , "saveAndSync" : createSap});
            saveAcc.setCallback(this, function(saveAccRes) {
                // alert('savedr');
                var savedrecId = saveAccRes.getReturnValue();
                
                if(savedrecId!=null){
                    //alert(savedrecId);
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": savedrecId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    this.showToast(component,"Success!","Save successful!!","success");
                    component.set("v.Spinner",false);
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    component.set("v.Spinner",false);
                    this.showToast(component,"Error!!","Record not saved, please verify the information entered..!!","error");
                    component.set("v.error", 'Record not saved, please verify the information entered.');
                }
            });
            $A.enqueueAction(saveAcc); }
        else {
            this.showToast(component,"Required Fields Missing ","Please complete all required fields..!!","error");
            component.set("v.error", 'Please complete all required fields..!!');
        }
        
    }, 
    checkForErrors : function (component, isError)
    {  //alert();
        var errfld = '';
        // var isError = false;
        if(component.get("v.customerType") == 'Business Account'){
            
            var accname = component.find("accountnameId");
            var nameVal = accname.get("v.value");
            if (nameVal == null || nameVal == "" || nameVal == "undefined" || nameVal == "  "){
                accname.showHelpMessageIfInvalid();
                isError = true;
            }
            else {
                component.set("v.acc.Name", nameVal);      
            }
        }
        var lastname = component.find("lastnameId");
        var lastnameVal = lastname.get("v.value");
        if (lastnameVal == null || lastnameVal == "" || lastnameVal == "undefined" || lastnameVal == "  "){
            lastname.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.lastName", lastnameVal);      
        }
        // Telephone making as Mandatory - Satesh Makineni - 05/29/2018
        
        var accPhone = component.find("phoneId");
        var accPhoneVal = accPhone.get("v.value");
        console.log('test'+accPhoneVal);
        if (accPhoneVal == null || accPhoneVal == "" || accPhoneVal == "undefined" || accPhoneVal == "  "){
            console.log('test if'+accPhoneVal);
            accPhone.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.Phone", accPhoneVal);      
        }
        //Telephone mandatory update complete
        
        var emailField = component.find("emailId");
        var emailFieldValue = emailField.get("v.value");
        if(emailFieldValue == '' || emailFieldValue == null || emailFieldValue == 'undefined')
        {            
        }
        else{
            //alert('email-->'+emailFieldValue);
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
            if(emailFieldValue.match(regExpEmailformat)){
                //emailField.set("v.errors", [{message: null}]);
                component.set("v.acc.Email__c", emailFieldValue);
            }
            else{
                emailField.set('v.validity',{valid:false, badInput:true});
                isError = true;
            }
        }
        var salesOrgn = component.find("salesorgId");
        var salesOrgValue = salesOrgn.get('v.value');
        if(salesOrgValue == '' || salesOrgValue == null ||  salesOrgValue == 'undefined'){
            salesOrgn.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.SalesOrg__c", salesOrgValue);      
        }
        
        var distChan = component.find("distributionchannelId");
        var distChanValue = distChan.get('v.value');
        if(distChanValue == '' || distChanValue == null ||  distChanValue == 'undefined'){
            distChan.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.DistributionChannel__c", salesOrgValue);      
        }
        var divsn = component.find("divisionId");
        var divsnValue = divsn.get('v.value');
        if(divsnValue == '' || divsnValue == null ||  divsnValue == 'undefined'){
            divsn.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.SalesOrg__c", divsnValue);      
        }
        var salesOfc = component.find("salesofficeId");
        var salesOfcValue = salesOfc.get('v.value');
        if(salesOfcValue == '' || salesOfcValue == null ||  salesOfcValue == 'undefined'){
            salesOfc.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.SalesOffice__c", salesOfcValue);      
        }
        
        var salesGrp = component.find("salesgroupId");
        var salesGrpValue = salesGrp.get('v.value');
        if(salesGrpValue == '' || salesGrpValue == null ||  salesGrpValue == 'undefined'){
            salesGrp.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.SalesGroup__c", salesGrpValue);      
        }			
        
        var salesDst = component.find("salesdistrictId");
        var salesDstValue = salesOrgn.get('v.value');
        if(salesDstValue == '' || salesDstValue == null ||  salesDstValue == 'undefined'){
            salesDst.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.SalesDistrict__c", salesOrgValue);      
        }
        var payterm = component.find("paymentTermsId");
        var paytermValue = payterm.get('v.value');
        if(paytermValue == '' || paytermValue == null ||  paytermValue == 'undefined'){
            payterm.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.PaymentTerms__c", paytermValue);      
        }
        
        var prgrp = component.find("pricinggroupId");
        var prgrpValue = prgrp.get('v.value');
        if(prgrpValue == '' || prgrpValue == null ||  prgrpValue == 'undefined'){
            prgrp.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.PricingGroup__c", prgrpValue);      
        }		
        
        var pricproc = component.find("priceprocedureId");
        var pricprocValue = pricproc.get('v.value');
        if(pricprocValue == '' || pricprocValue == null ||  pricprocValue == 'undefined'){
            pricproc.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.PriceProcedure__c", pricprocValue);      
        }
        var priclst = component.find("pricelistId");
        var priclstValue = priclst.get('v.value');
        if(priclstValue == '' || priclstValue == null ||  priclstValue == 'undefined'){
            priclst.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.PriceList__c", priclstValue);      
        }
        
         var shipcond = component.find("shipconditionId");
        var shipcondValue = shipcond.get('v.value');
        if(shipcondValue == '' || shipcondValue == null ||  shipcondValue == 'undefined'){
            shipcond.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.ShippingCondition__c", shipcondValue);      
        }
        
        /*var taxExempt = component.find("taxexemptId");
        var taxExemptValue = taxExempt.get('v.value');
        if(taxExemptValue == '' || taxExemptValue == null ||  taxExemptValue == 'undefined'){
            taxExempt.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.acc.TaxExemptCertificate__c", taxExemptValue);      
        }*/
        var industryComp = component.find("industryCategoryId");
        var industryValue = industryComp.get('v.value');
        if(industryValue == '' || industryValue == null || industryValue == 'undefined'){
            console.log('industry');
            //industryComp.showHelpMessageIfInvalid();
            $A.util.addClass(industryComp, 'is-required slds-has-error');
            isError = true;
            component.set("v.errorIndustry", "Please enter a value");
        }
        else{
            component.set("v.errorIndustry", "");
            $A.util.removeClass(industryComp, 'is-required slds-has-error');
            component.set("v.acc.Industry_Category__c", industryValue);
        }
        // add required fields for Address
           var accstreet = component.find("addressStreetId");
            var streetVal = accstreet.get("v.value");
        	console.log(streetVal);
            if (streetVal == null || streetVal == "" || streetVal == "undefined" || streetVal == "  "){
                accstreet.showHelpMessageIfInvalid();
                isError = true;
            }
            else {
                component.set("v.acc.BillingStreet", streetVal); 
                component.set("v.acc.ShippingStreet", streetVal);
            }
        
        var acccity = component.find("addressCityId");
            var cityVal = acccity.get("v.value");
            if (cityVal == null || cityVal == "" || cityVal == "undefined" || cityVal == "  "){
                acccity.showHelpMessageIfInvalid();
                isError = true;
            }
            else {
                component.set("v.acc.BillingCity", cityVal);
                component.set("v.acc.ShippingCity", cityVal);
            }
         var accstate = component.find("addressStateId");
            var stateVal = accstate.get("v.value");
            if (stateVal == null || stateVal == "" || stateVal == "undefined" || stateVal == "  "){
                accstate.showHelpMessageIfInvalid();
                isError = true;
            }
            else {
                component.set("v.acc.BillingState", stateVal);   
                component.set("v.acc.ShippingState", stateVal);
            }
        
        var acczipid = component.find("addressZipId");
            var zipVal = acczipid.get("v.value");
            if (zipVal == null || zipVal == "" || zipVal == "undefined" || zipVal == "  "){
                acczipid.showHelpMessageIfInvalid();
                isError = true;
            }
            else {
                component.set("v.acc.BillingPostalCode", zipVal);  
                component.set("v.acc.ShippingPostalCode", zipVal);
            }
        
        var acccountry = component.find("addressCountryId");
            var countryVal = acccountry.get("v.value");
            if (countryVal == null || countryVal == "" || countryVal == "undefined" || countryVal == "  "){
                acccountry.showHelpMessageIfInvalid();
                isError = true;
            }
            else {
                
                component.set("v.acc.BillingCountry", countryVal);
                component.set("v.acc.ShippingCountry", countryVal);
            }
        	console.log(countryVal+zipVal+stateVal+cityVal+streetVal);
        //Address
        var industrySubComp = component.find("industrySubCategoryId");
        
        var industrySubValue = industrySubComp.get("v.value");
        console.log('5');
        if(industrySubValue == '' || industrySubValue == null || industrySubValue == 'undefined'){
            //industrySubComp.set("v.errors", [{message:"Required field missing"}]);
            $A.util.addClass(industrySubComp, 'is-required slds-has-error');
            isError = true;
            component.set("v.errorIndustry", "Please enter a value");
            //console.log('IndustryVal sub');
        }
        else{
            component.set("v.errorIndustry", "");
            $A.util.removeClass(industrySubComp, 'is-required slds-has-error');
            component.set("v.acc.Industry_Sub_Category__c", industrySubValue);
        }
        component.set("v.errorField", errfld);
        return isError;
    },
    nullifyDependants : function(component,eventId){
        if(eventId === 'salesorgId') {
            component.find("distributionchannelId").set("v.value","");
            
            component.find("distributionchannelId").set("v.disabled", true);
            component.find("divisionId").set("v.disabled", true);
            component.find("salesofficeId").set("v.disabled", true);
            component.find("salesgroupId").set("v.disabled", true); 
            
            component.find("divisionId").set("v.value","");
            component.find("salesofficeId").set("v.value","");
            component.find("salesgroupId").set("v.value","");
            component.set("v.resultDistChanList", null);
            component.set("v.divisionList", null);
            component.set("v.salesOffList", null);
            component.set("v.salesgrpList", null);
        }
        else if(eventId === 'distributionchannelId') {
            component.find("divisionId").set("v.disabled", true);
            component.find("salesofficeId").set("v.disabled", true);
            component.find("salesgroupId").set("v.disabled", true); 
            
            component.find("divisionId").set("v.value","");
            component.find("salesofficeId").set("v.value","");
            component.find("salesgroupId").set("v.value","");
            component.set("v.divisionList", null);
            component.set("v.salesOffList", null);
            component.set("v.salesgrpList", null);
        }
            else if(eventId === 'divisionId') {
                component.find("salesofficeId").set("v.disabled", true);
                component.find("salesgroupId").set("v.disabled", true);  
                
                component.find("salesofficeId").set("v.value","");
                component.find("salesgroupId").set("v.value","");
                component.set("v.salesOffList", null);
                component.set("v.salesgrpList", null);
            }
                else if(eventId === 'salesofficeId') {
                    component.find("salesgroupId").set("v.disabled", true);
                    
                    component.find("salesgroupId").set("v.value","");
                    component.set("v.salesgrpList", null);
                }
    },
    fetchDependants : function(component){
        component.set("v.Spinner",true);
        var string123 = JSON.stringify(component.get("v.SeedDataWrapper"));
        // console.log('str123--->'+string123);
        var controllingData ;
        var dependant ;
        var controllingSalesOrgData = component.find("salesorgId").get("v.value");
        var controllingDistChanData = component.find("distributionchannelId").get("v.value");
        var controllingDivisionData = component.find("divisionId").get("v.value");
        var controllingSalesOfcData = component.find("salesofficeId").get("v.value");
        var controllingSalesGrpData = component.find("salesgroupId").get("v.value");
        console.log('seed data values'+controllingSalesOrgData+controllingDistChanData+controllingDivisionData+controllingSalesOfcData+controllingSalesGrpData);
        if(controllingDistChanData != '' && controllingDivisionData != '' && controllingSalesOfcData !='' && controllingDistChanData != 'undefined' && controllingDivisionData != 'undefined' && controllingSalesOfcData !='undefined' )
        {
            controllingData = controllingSalesOfcData;
            //controllingData = controllingSalesOrgData+'-'+'10'+'-'+'10'+'-'+'10';   
            dependant = 'SALES_GROUP';
        }
        else if(controllingDistChanData != '' && controllingDivisionData != '' && controllingDistChanData != 'undefined' && controllingDivisionData != 'undefined')
        {											
            controllingData = controllingSalesOrgData+'-'+controllingDistChanData+'-'+controllingDivisionData;
            //controllingData = controllingSalesOrgData+'-'+'10'+'-'+'10';   
            dependant = 'SALES_OFFICE';
        }
            else if(controllingDistChanData != '' && controllingDistChanData != 'undefined' )
            {
                controllingData = controllingSalesOrgData+'-'+controllingDistChanData;
                // controllingData = controllingSalesOrgData+'-'+'10';
                dependant = 'DIVISION';
            }
                else if(controllingSalesOrgData != '' && controllingSalesOrgData != 'undefined')
                {
                    controllingData = controllingSalesOrgData;
                    dependant = 'DISTR_CHAN';
                }
        console.log('controlling and dep-->'+controllingData+dependant);
        // console.log('Test for method');
        var dependantData = component.get("c.getSeedValues");
        dependantData.setParams({  "controlling" : controllingData , "dep" : dependant, "wrap" : string123 });
        dependantData.setCallback(this, function(dependantDataResponse) {
            var dependantDataState = dependantDataResponse.getState();
            //console.log('test sap1'+dependantDataState);
            if (dependantDataState === "SUCCESS") {
                var dependantDataList = dependantDataResponse.getReturnValue();
                //console.log('Test Seed response'+JSON.stringify(dependantDataResponse));
                if(dependant == 'DISTR_CHAN')
                {
                    component.set("v.resultDistChanList", dependantDataList);
                    component.find("distributionchannelId").set("v.disabled", false);
                }
                else if(dependant == 'DIVISION')
                {
                    console.log('Test div');
                    component.set("v.divisionList", dependantDataList);
                    console.log('Test div1');
                    component.find("divisionId").set("v.disabled", false);
                    console.log('Test div2');
                }
                    else if(dependant == 'SALES_OFFICE')
                    {
                        component.set("v.salesOffList", dependantDataList);
                        component.find("salesofficeId").set("v.disabled", false);

                    }
                        else if(dependant == 'SALES_GROUP')
                        {
                            component.set("v.salesgrpList", dependantDataList);
                            component.find("salesgroupId").set("v.disabled", false);
                        }
             
                component.set("v.Spinner",false);
            }
        });
        $A.enqueueAction(dependantData);       
    },
    handleIndustryElementsHelper : function(component){
        var industryId = component.find("industryCategoryId");
        var industryVal = industryId.get("v.value");
        var industrySubId = component.find("industrySubCategoryId");
        var industrySubVal = industrySubId.get("v.value");
      /*  if(industryVal == '' || industryVal == null || industryVal == 'undefined')
        {	
            component.set("v.errorIndustry", "Please enter a value");
            $A.util.addClass(industryId, 'is-required slds-has-error');
        }
        if(industrySubVal == '' || industrySubVal == null || industrySubVal == 'undefined')
        {	
            component.set("v.errorIndustry", "Please enter a value");
            $A.util.addClass(industrySubId, 'is-required slds-has-error');
        }*/
        if(industryVal != '' && industryVal != null && industryVal != 'undefined')
        {
            $A.util.removeClass(industryId, 'is-required slds-has-error');
        }
        if(industrySubVal != '' && industrySubVal != null && industrySubVal != 'undefined')
        {
            $A.util.removeClass(industrySubId, 'is-required slds-has-error');
        }
        if(industryVal != '' && industryVal != null && industryVal != 'undefined' && industrySubVal != '' && industrySubVal != null && industrySubVal != 'undefined')
        {	
            $A.util.removeClass(industrySubId, 'is-required slds-has-error');
            $A.util.removeClass(industrySubId, 'is-required slds-has-error');
            component.set("v.errorIndustry", "");
        }
    },
    enableDisableDependancies : function(component,editRecId){
       		component.find("distributionchannelId").set("v.disabled", true);
            component.find("divisionId").set("v.disabled", true);
            component.find("salesofficeId").set("v.disabled", true);
            component.find("salesgroupId").set("v.disabled", true); 
        	if(editRecId!=null)
            {
                console.log('2');
                component.find("salesorgId").set("v.disabled",true);
                component.find("salesdistrictId").set("v.disabled",true);
                component.find("paymentTermsId").set("v.disabled",true);
                component.find("pricinggroupId").set("v.disabled",true);
                component.find("priceprocedureId").set("v.disabled",true);
                component.find("pricelistId").set("v.disabled",true);
				component.find("shipconditionId").set("v.disabled",true);
                console.log('3');
            }
        	
    },
    getAccount : function(component, editRecId, event)
    {
        console.log('1');
     var account = component.get("c.getAccount");     
        account.setParams({
            "recId" : editRecId
        });
        account.setCallback(this, function(getAccountResponse){
            var AccountResponseState = getAccountResponse.getState();
            if (AccountResponseState === "SUCCESS") {
                var AccountResponseVal = getAccountResponse.getReturnValue();
                
                component.set("v.acc", AccountResponseVal);
                
                console.log('Phone No : -->'+AccountResponseVal.Phone);
                console.log('First Name : -->'+AccountResponseVal.FirstName);
                console.log('OrginOfSource : -->'+AccountResponseVal.OriginSource__c);
                console.log('emailId : -->'+AccountResponseVal.Email__c);
                console.log('outsiderepId : -->'+AccountResponseVal.Outside_Sales_Rep__c);
                console.log('insiderepId : -->'+AccountResponseVal.Inside_Sales_Rep__c);
                console.log('taxexemptId : -->'+AccountResponseVal.TaxExemptCertificate__c);
                console.log('addressStreetId : -->'+AccountResponseVal.BillingStreet);
                console.log('addressCityId : -->'+AccountResponseVal.BillingCity);
                console.log('addressStateId : -->'+AccountResponseVal.BillingState);
                console.log('addressZipId : -->'+AccountResponseVal.BillingPostalCode);
                console.log('addressCountryId : -->'+AccountResponseVal.BillingCountry);
                console.log('retailLocationId : -->'+AccountResponseVal.Retail_Location__c);
                console.log('isdistributionId : -->'+AccountResponseVal.Isdistributioncenter__c);
                console.log('salesorgId : -->'+AccountResponseVal.SalesOrg__c);
                
                component.find("phoneId").set("v.value",AccountResponseVal.Phone);
                component.find("firstnameId").set("v.value",AccountResponseVal.FirstName);
                component.set("v.origin",AccountResponseVal.OriginSource__c);
                component.find("originId").set("v.value",AccountResponseVal.OriginSource__c);
                component.find("emailId").set("v.value",AccountResponseVal.Email__c);
                //component.find("outsiderepId").set("v.value",AccountResponseVal.Outside_Sales_Rep__c);
                //component.find("insiderepId").set("v.value",AccountResponseVal.Inside_Sales_Rep__c);
                component.find("taxexemptId").set("v.value",AccountResponseVal.TaxExemptCertificate__c);
                component.find("addressStreetId").set("v.value",AccountResponseVal.BillingStreet);
                component.find("addressCityId").set("v.value",AccountResponseVal.BillingCity);
                component.find("addressStateId").set("v.value",AccountResponseVal.BillingState);
                component.find("addressZipId").set("v.value",AccountResponseVal.BillingPostalCode);
                component.find("addressCountryId").set("v.value",AccountResponseVal.BillingCountry);
                component.find("retailLocationId").set("v.value",AccountResponseVal.Retail_Location__c);
                component.find("isdistributionId").set("v.value",AccountResponseVal.Isdistributioncenter__c);
             
                component.find("salesorgId").set("v.value",AccountResponseVal.SalesOrg__c);
                
                
                
                //this.setValues(component,AccountResponseVal);
            }
        });
        $A.enqueueAction(account);   
    },
    setValues : function(component)
    {
       // component.find("emailId").set("v.value",v.acc.Email__c);
    },
    showToast : function(component,title,message,type){
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": title,
                "message":message ,
                "type" : type
            });
            toastEvent.fire();
        }catch(Err){
            console.log(Err);
        }
    }
})
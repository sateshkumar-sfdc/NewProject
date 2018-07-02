({
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
        var string123 = component.get("v.SeedDataWrapper");
        //var string123 = JSON.stringify(component.get("v.SeedDataWrapper"));
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
        var AccountSequenceName = string123.seedDataAccSeqFieldsMap_wrapper[dependant];
        var Position = string123.SeedDataFieldNamePositionMap_wrapper[dependant];
        var AccountSequenceDataValues = string123.seedDataAccSeqDataMap_wrapper[AccountSequenceName];
        var dependantlist = [];
        for(var name in AccountSequenceDataValues)
        {
         	var AccDataValueString = AccountSequenceDataValues[name];   
            //console.log('-->'+AccDataValueString);
            if(AccDataValueString.includes(controllingData))
            {
                
                var value = AccDataValueString.split('-')[Position];
                dependantlist.push(value);
                
            }
            //console.log('value-->'+value);
        }
        console.log('Dep List-->'+dependantlist);
        console.log('Acc Seq Data-->'+AccountSequenceDataValues);
        console.log('Dependant-->'+string123.seedDataAccSeqFieldsMap_wrapper[dependant]+Position);
        
        
        
        
        // console.log('Test for method');
      /*  var dependantData = component.get("c.getSeedValues");
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
             */
                component.set("v.Spinner",false);
            //}
        //});
       // $A.enqueueAction(dependantData);       
    },
     enableDisableDependancies : function(component,editRecId){
       		component.find("distributionchannelId").set("v.disabled", true);
            component.find("divisionId").set("v.disabled", true);
            component.find("salesofficeId").set("v.disabled", true);
            component.find("salesgroupId").set("v.disabled", true); 
        	
        	
    }
})
/*
*************************************************************
** Name: AccountService.apxc                        	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose:                  							   **
** This class Contain Account Methods to Call SAP          **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 05/22/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/
public with sharing class AccountService {
    
    @AuraEnabled
    
    public static string createAccountInSAP(Id recId){
        String callOutResult;
        try {
            Account acc;
            account accPer;
            account recType;
            string Name;
            string accType = 'SoldTo';
            
            // This logic will work if the RecordType ID as "Consumer Account"
            if(recId != null ){
                recType = [select RecordTypeId from Account where id=: recId LIMIT 1 ];
                // System.debug('test value '+recType);
                
                if(recType.RecordTypeId=='012i00000016Rc3' || recType.RecordTypeId=='0120H0000016XzG'){
                    accPer = [SELECT FirstName, LastName, Email__c, Phone,CompanyCode__c, 
                              SalesOrg__c, DistributionChannel__c, Division__c,
                              SalesOffice__c,SalesGroup__c, SalesDistrict__c,
                              PaymentTerms__c,PriceList__c,PricingGroup__c,
                              PriceProcedure__c, ShippingCondition__c,
                              CustomerShipAccount__c,BillingStreet,
                              BillingCity,BillingState,BillingPostalCode,
                              BillingCountry, CustomerNumber__c, CurrencyIsoCode 
                              FROM Account 
                              WHERE id=: recId LIMIT 1];
                    //System.debug('Account test Personal'+accPer);
                    
                    //This code will run for default page check the SAP Customer Number 
                    //if not exist will trigger a call to SAP and Create if Exist will send a message on Screen
                    if(accPer.CustomerNumber__c == null || accPer.CustomerNumber__c == ''){
                        Name= accPer.FirstName +' '+ accPer.LastName; 
                        callOutResult =  actuallCallOut(accPer, Name, accType);
                        //system.debug('result from actualCallout : '+callOutResult);
                        if(callOutResult == null || callOutResult == ''){
                            
                            callOutResult ='Error';
                            // System.debug(callOutResult);
                            //System.debug('Test1 :'+callOutResult);
                            
                        }else{
                            accPer.CustomerNumber__c = callOutResult;
                            callOutResult ='Successfully Created Customer in SAP - ' +accPer.CustomerNumber__c;
                            // system.debug('inside personal '+accPer.CustomerNumber__c);
                            upsert accPer;
                        }
                    } else{
                        callOutResult ='Account Already Exist!! - ' +accPer.CustomerNumber__c;
                        // System.debug('Testing');
                        
                    }
                    
                }else{
                    // This logic will work if the RecordType ID as "Business Account" 
                    //System.debug('accountRecord id : '+ recId);
                    
                    // fetch Account information based on recId
                    acc = [SELECT Name, Email__c, Phone,CompanyCode__c, 
                           SalesOrg__c, DistributionChannel__c, Division__c,
                           SalesOffice__c,SalesGroup__c, SalesDistrict__c,
                           PaymentTerms__c,PriceList__c,PricingGroup__c,
                           PriceProcedure__c, ShippingCondition__c,
                           CustomerShipAccount__c,BillingStreet,
                           BillingCity,BillingState,BillingPostalCode,
                           BillingCountry, CustomerNumber__c,CurrencyIsoCode 
                           FROM Account 
                           WHERE id=: recId LIMIT 1];
                    //System.debug('Account test Business'+acc);
                    
                    //This code will run for default page check the SAP Customer Number 
                    //if not exist will trigger a call to SAP and Create if Exist will send a message on Screen
                    if(acc.CustomerNumber__c == null || acc.CustomerNumber__c == ''){
                        Name = acc.Name;
                        callOutResult =  actuallCallOut(acc, Name, accType);
                        if(callOutResult == null || callOutResult == ''){
                            
                            callOutResult ='Error';
                            //  System.debug(callOutResult);
                            //  System.debug('Test2 :'+callOutResult);
                            
                        }else{
                            
                            acc.SAPCustomerNumber__c = callOutResult;
                            callOutResult ='Successfully Created Customer in SAP - ' +acc.CustomerNumber__c;
                            //  system.debug('inside personal '+acc.CustomerNumber__c);
                            upsert acc;
                        }
                    }
                    else{
                        callOutResult ='Account Already Exist!! - ' +acc.CustomerNumber__c;
                        // System.debug('Testing');
                    } 
                }
            }
        }
        
        
        catch(exception e){
            //Write a log in to IntegrationsLog Object for monitoring and support
            Intgeration_Log__c log = new Intgeration_Log__c();
            log.Object_Name__c = 'AccountService';
            log.ServiceName__c = 'createAccountInSAP';
            log.Time_Stamp__c = System.now();
            //log.RecordId__c = recordId;
            log.Target_System__c = 'SAP';
            log.Log__c = e.getMessage();
            insert log;
            
            System.debug('The following exception has occurred: ' + e.getMessage());
            callOutResult = e.getMessage();
            
        }
        return callOutResult;
    }
    /* Reusable purpose created common class for Business and Personal accounts.*/
    @AuraEnabled
    public static string actuallCallOut(Account ac, string Name, String accType){
        try{
            // System.debug('Result'+name);
            // Convert Today's date to SAP Required format as "20180517"
            Date d = date.today();
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYYMMdd'); // Sap Required Date format "20180516"            
            //System.debug('++++++Date : '+dt);
            
            AccountRequest req = new AccountRequest();
            // System.debug('++++inside'+req);
            
            //initiate the data for Request message
            AccountRequest.ADDRESSDATA AddrDat = new AccountRequest.ADDRESSDATA();        
            AddrDat.CITY=ac.BillingCity;//'Phoenix';
            AddrDat.POSTL_COD1=ac.BillingPostalCode;//'85048';
            AddrDat.STREET=ac.BillingStreet;//'2345 E Amberwood Dr';
            AddrDat.COUNTRY=ac.BillingCountry;//'US';
            AddrDat.REGION=ac.BillingState;//'AZ'; 
            AddrDat.LANGU=CommonUtil.getCommonMetaData('Language'); // Language value get from the Custom MetaData with common util class.
            req.ADDRESSDATA = AddrDat;
            
            AccountRequest.CENTRALDATA CenDat = new AccountRequest.CENTRALDATA(); 
            AccountRequest.CENTRALDATAORGANIZATION CenOrg = new AccountRequest.CENTRALDATAORGANIZATION();
            
            //handling the Name for Personal Account and Business Account
            //System.debug('name test : '+NAME);
            
            CenDat.SEARCHTERM1=Name; //CenDat.SEARCHTERM1='test234';//ac.Name;
            CenOrg.NAME1=Name;//CenOrg.NAME1='test234';//ac.Name;
            
            //System.debug('Searchterm1' +CenDat.SEARCHTERM1);
            //System.debug('Name' +CenOrg.NAME1);
           // CenDat.PARTNERTYPE='SP';
           // CenDat.PARTNERLANGUAGE=CommonUtil.getCommonMetaData('Language'); // Default value get from the common Util class with Custom Metadata
            req.CENTRALDATAORGANIZATION = CenOrg;
            req.CENTRALDATA = CenDat;
            
            AccountRequest.COMPANY_DATA ComDat = new AccountRequest.COMPANY_DATA();        
            ComDat.RECACCT=CommonUtil.getCommonMetaData('RECACCT'); //Default value from Custom Metadata -'0012100000'
            ComDat.PAYTERM=CommonUtil.getCommonMetaData('PAYT_TERMS');//Possible Values - Default 'NTCC'
            req.COMPANY_DATA = ComDat;
            
            //If SalesOrg as 1100 then Company code should assign as 1100
            AccountRequest.COMPANY_KEY ComKey = new AccountRequest.COMPANY_KEY();        
            ComKey.COMPANY=ac.SalesOrg__c;//ac.CompanyCode__c;//'1100'; Possible Values
            req.COMPANY_KEY = ComKey;
            
            AccountRequest.Item_Z EmaItm = new AccountRequest.Item_Z();
            AccountRequest.E_MAILDATA EmaData = new AccountRequest.E_MAILDATA();       
            EmaItm.E_MAIL=ac.Email__c;//'pietwieletjies@whoknows.com';
            EmaData.item = EmaItm;
            req.E_MAILDATA = EmaData;
            
            AccountRequest.Item_Y RolItm = new AccountRequest.Item_Y();
            AccountRequest.ROLES Rol = new AccountRequest.ROLES();
            req.PARTNERCATEGORY=CommonUtil.getCommonMetaData('PARTNERCATEGORY'); //Default as '2'
           if(accType == 'SoldTo')
            req.PARTNERGROUP='SP'; // Sold To as SP and Ship To as Sh
           else
               req.PARTNERGROUP='SH';
            
            Rol.item = RolItm;
            req.ROLES = Rol;
            
            RolItm.PARTNERROLE=CommonUtil.getCommonMetaData('PARTNERROLE');//'ZYTISP' for sold-to & 'FLCU01' for ship-to's
            RolItm.VALID_FROM=dt; // Default to current date
            RolItm.VALID_TO=CommonUtil.getCommonMetaData('VALID_TO');//Default to '99991231'
            
            AccountRequest.SALES_DATA SalDat = new AccountRequest.SALES_DATA(); 
            SalDat.CUST_STAT_GRP=CommonUtil.getCommonMetaData('CUST_STAT_GRP'); // Always '1'
            SalDat.CUST_PRIC_PROC=ac.PriceProcedure__c;//;'ZI'
            SalDat.DISTRICT=CommonUtil.getCommonMetaData('DISTRICT'); // SAP Maintaining this value
            SalDat.PRICE_GROUP=ac.PricingGroup__c;//'YT';
            SalDat.PLTYP=ac.PriceList__c;//'01';//
            SalDat.INCO1=CommonUtil.getCommonMetaData('INCO1'); //Incoterms (hard-code to FOB)
            SalDat.INCO2=CommonUtil.getCommonMetaData('INCO2'); // Inco location (hard-code to Origin)
            SalDat.PART_DLV=CommonUtil.getCommonMetaData('PART_DLV'); //Always 'C' for complete only
            SalDat.SHP_COND=ac.ShippingCondition__c;//'02'; //Possible Values
            SalDat.CURRENCY1=ac.CurrencyIsoCode; //USD' for US - 'CAD' for Canada
            SalDat.PAYT_TERMS=CommonUtil.getCommonMetaData('PAYT_TERMS');//Possible Values - Default 'NTCC'
            SalDat.DELIVER_PLANT=CommonUtil.getCommonMetaData('DELIVER_PLANT'); //Default '1200'
            SalDat.SALES_GROUP=ac.SalesGroup__c;//'STD';//Possible Values
            SalDat.SALES_OFFICE=ac.SalesOffice__c;//'STD';//Possible Values
            req.SALES_DATA = SalDat;
            
            AccountRequest.SALES_KEY SalKey = new AccountRequest.SALES_KEY();
            SalKey.SALESORG=ac.SalesOrg__c;//'1100';//;
            SalKey.DISTR_CHAN=ac.DistributionChannel__c;//'10';//;
            SalKey.DIVISION=ac.Division__c;//'10';//;
            req.SALES_KEY = SalKey;
            System.debug('Saleskey :'+SalKey);
            AccountRequest.Item TelItm = new   AccountRequest.Item();
            AccountRequest.TELEFONDATA TelDat = new AccountRequest.TELEFONDATA();        
            TelItm.COUNTRY=ac.BillingCountry; //'US';
            TelItm.TELEPHONE=ac.Phone;//'14805553456';//acc.Phone;
            TelDat.item = TelItm;
            req.TELEFONDATA = TelDat;
            
            System.debug('++++outside'+req);
            system.debug('Request Message with Currency');    
            //Request Message Serialize to Json format
            string request = JSON.serialize(req);
            string reqString = request.replace('CURRENCY1','CURRENCY');
            System.debug('request-->' +reqString);
            
            // Send request, and return response with Common API utility Class with POST method
            String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:BPMaintain', reqString, 'POST');
            System.debug(JsonResponse);
            
            //Capture the Responce to Wrapper
            AccountResponse wrapper =(AccountResponse)JSON.deserialize(JsonResponse,AccountResponse.class);
            //System.debug('responce results : '+wrapper); 
            if (wrapper.BUSINESSPARTNER == null || wrapper.BUSINESSPARTNER == '' ){
                // System.debug('Not Created');
                system.debug('final value if null'+wrapper.BUSINESSPARTNER);
                return null;
                
                
            } else{
                system.debug('final Value'+wrapper.BUSINESSPARTNER);
                
               // ac.CustomerNumber__c = wrapper.BUSINESSPARTNER;
                
                // Record Values upsert into record 
                // upsert ac;
                //System.debug('Sap Customer Number : '+ac.CustomerNumber__c);
                return  wrapper.BUSINESSPARTNER;
                // return 'Successfully Created SAP Customer: ' +ac.CustomerNumber__c;
                
                
            }
        }catch(exception e){
            
            //Write a log in to IntegrationsLog Object for monitoring and support
            Intgeration_Log__c log = new Intgeration_Log__c();
            log.Object_Name__c = 'AccountService';
            log.ServiceName__c = 'createAccountInSAP';
            log.Time_Stamp__c = System.now();
            //log.RecordId__c = recordId;
            log.Target_System__c = 'SAP';
            log.Log__c = e.getMessage();
            insert log;
            
            System.debug('The following exception has occurred: ' + e.getMessage());
            //  callOutResult = e.getMessage();
            return + e.getMessage();
        }
        
    }
}
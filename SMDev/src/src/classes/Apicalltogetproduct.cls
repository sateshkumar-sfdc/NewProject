public with sharing class Apicalltogetproduct {
    
     public with sharing class productWrapper {
        
       @AuraEnabled  public Decimal Quantitys {get;set;}
       @AuraEnabled  public Decimal salesprice {get;set;} 
       @AuraEnabled  public string materialname {get;set;}
  }
    

    
    
   @AuraEnabled
   public Static string productAvailji(Integer Sapnumber, String Materialnumber, string Materialname){
       //    try{
              //list<QuoteLineItem> updatelist = new list<QuoteLineItem>();
              //Quote quote = [select Account.SAPCustomerNumber__c, Account.Sales_Office__c,(select Product2.ENSX_EDM__Material__c FROM QuoteLineItems) from Quote where Id =:recordId];
           
           
        List<AvailabilityRequest.Item> itmlist = new List<AvailabilityRequest.Item>();
            
        // if(quote.QuoteLineItems.size()>0){
             //for(QuoteLineItem ql: quote.QuoteLineItems){
                AvailabilityRequest.Item itmobj = new  AvailabilityRequest.Item();
                itmobj.MATERIAL = Materialnumber;
                itmlist.add(itmobj);
            //  }
               //system.debug('itm-->'+itm );
               
           AvailabilityRequest.PRODUCTS products = new AvailabilityRequest.PRODUCTS();
           products.item = itmlist;
           
           Date d = date.today();
           String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYY-MM-dd');
           //system.debug(dt);
		
           AvailabilityRequest req = new AvailabilityRequest();
           req.CUSTOMER = string.valueOf(Sapnumber);
           req.PRICE_DATE = dt;
           req.PRODUCTS = products;
           req.SALES_GRP='STD';
           req.SALES_OFF= 'STD';
           req.SALES_ORG='1100';
           string request = JSON.serialize(req);
           System.debug('request-->' +request);
       
           String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_Availability', request, 'POST');
           System.debug(JsonResponse);
             
           
        AvailabilityResponse wrapper =(AvailabilityResponse)JSON.deserialize(JsonResponse,AvailabilityResponse.class);
          
               map<string, AvailabilityResponse.Item_Z> results = new map<string,AvailabilityResponse.Item_Z>();
                   
               for(AvailabilityRequest.Item material1: itmlist){
                        for(AvailabilityResponse.Item_Z itemz : (wrapper.PRODUCT_LIST).item){
                                 if(itemz.MATERIAL == material1.MATERIAL){
                                    results.put(material1.MATERIAL, itemz);   
                                  }
                         }
                    }
              system.debug('test1-->'+ results);
               system.debug('test2-->');
              
           productWrapper objwrap = new productWrapper();
               objwrap.Quantitys = (results.get(Materialnumber)).QTY_AVAILABLE; 
               for(AvailabilityResponse.Item sb : ((results.get(Materialnumber)).PRICING).item){
                          
                          //qutobj.Plant__c = (results.get(qutobj.Product2.ENSX_EDM__Material__c)).PLANT;
                          //qutobj.Item_Number__c = (results.get(qutobj.Product2.ENSX_EDM__Material__c)).ITM_NUMBER;
                           //system.debug('test3-->');
                         // if(sb.COND_DESC == 'Freight'){
                          //  qutobj.Frieght__c = sb.COND_VALUE;
                         // }
                          if(sb.COND_DESC == 'Price'){
                            objwrap.salesprice = sb.COND_VALUE;
                          }
                         // if(sb.COND_DESC == 'Net Line Value'){
//                             qutobj.Net_Line_Value__c = sb.COND_VALUE;
                         //  }
        
                     }
           objwrap.materialname = Materialname;
    
        system.debug(objwrap);
       return 'success';
       }
                 
             
                      
//system.debug('test 4');                
       

    



}
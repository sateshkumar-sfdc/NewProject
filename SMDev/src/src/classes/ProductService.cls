/*
######################################################################################################################
Name:       ProductService.apxc 
Description: This Class contains methods to make Api call to SAP 
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     4/26/2018    1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/


public with sharing class ProductService {
    
 
/*
######################################################################################################################
Method Name:       checkAvailability
Description:  This methods makes an Api Call to SAP to get the Availability of products and updates Base price in QuoteLineItem 
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     4/26/2018    1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/   
    
     
    
       @AuraEnabled
       public Static string checkAvailability(Id recordId){
            try{
              list<QuoteLineItem> updatelist = new list<QuoteLineItem>();
              Quote quote = [select Account.SAPCustomerNumber__c, Account.Sales_Office__c,(select Product2.ENSX_EDM__Material__c FROM QuoteLineItems) from Quote where Id =:recordId];
           
              List<AvailabilityRequest.Item> itmlist = new List<AvailabilityRequest.Item>();
            
         if(quote.QuoteLineItems.size()>0){
             for(QuoteLineItem ql: quote.QuoteLineItems){
                AvailabilityRequest.Item itmobj = new  AvailabilityRequest.Item();
                itmobj.MATERIAL = ql.Product2.ENSX_EDM__Material__c;
                itmlist.add(itmobj);
              }
               //system.debug('itm-->'+itm );
               
           AvailabilityRequest.PRODUCTS products = new AvailabilityRequest.PRODUCTS();
           products.item = itmlist;
           
           Date d = date.today();
           String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYY-MM-dd');
           //system.debug(dt);
		
           AvailabilityRequest req = new AvailabilityRequest();
           req.CUSTOMER = quote.Account.SAPCustomerNumber__c;//'100422';
           req.PRICE_DATE = dt;
           req.PRODUCTS = products;
           req.SALES_GRP='STD';
           req.SALES_OFF= quote.Account.Sales_Office__c;
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
              
               for(QuoteLineItem qutobj :quote.QuoteLineItems){
                    for(AvailabilityResponse.Item sb : ((results.get(qutobj.Product2.ENSX_EDM__Material__c)).PRICING).item){
                          qutobj.QuantityAvailable__c = (results.get(qutobj.Product2.ENSX_EDM__Material__c)).QTY_AVAILABLE; 
                          qutobj.Plant__c = (results.get(qutobj.Product2.ENSX_EDM__Material__c)).PLANT;
                          qutobj.Item_Number__c = (results.get(qutobj.Product2.ENSX_EDM__Material__c)).ITM_NUMBER;
                           //system.debug('test3-->');
                          if(sb.COND_DESC == 'Freight'){
                            qutobj.Frieght__c = sb.COND_VALUE;
                          }
                          if(sb.COND_DESC == 'Price'){
                            qutobj.UnitPrice = sb.COND_VALUE;
                          }
                          if(sb.COND_DESC == 'Net Line Value'){
                             qutobj.Net_Line_Value__c = sb.COND_VALUE;
                           }
        
                     }updatelist.add(qutobj);
    
                  }
             
            
          
                  update updateList;
             
                      
system.debug('test 4');                
          
          
             return updateStatus(updateList);
         }else{
              //      System.debug('1'+log);

            return null;
        }
                
           }catch(exception e){
               //Write a log in to IntegrationsLog Object for monitoring and support
               Intgeration_Log__c log = new Intgeration_Log__c();
               	log.Object_Name__c = 'Quote';
                log.ServiceName__c = 'checkAvailability';
                log.Time_Stamp__c = System.now();
                log.RecordId__c = recordId;
                log.Target_System__c = 'SAP';
                log.Log__c = e.getMessage();
               	log.Status__c = 'Failed';
               
                insert log;
           }
            
               return null;
              
           }
        
    
/*
######################################################################################################################
Method Name:       getPriceSimulation
Description:  This methods makes an Api Call to SAP to get the ActualPricing of products based on Quantity
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     4/28/2018     1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/   
  
    @AuraEnabled
    public Static string  getPriceSimulation(Id recordId){
        try{
         
        list<QuoteLineItem> updatelist = new list<QuoteLineItem>();
        Quote quote = [select Account.SAPCustomerNumber__c, Account.Sales_Office__c,(select Product2.ENSX_EDM__Material__c,Plant__c,Item_Number__c,Quantity,IsAvailable__c FROM QuoteLineItems) from Quote where Id =:recordId];
         
            if(quote.QuoteLineItems.size()>0){
            Date d = date.today();
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYYMMdd');
            
            PricingRequest.ORDER_HEADER_IN orderheader = new PricingRequest.ORDER_HEADER_IN();
              orderheader.DOC_TYPE ='ZCLC';
              orderheader.SALES_ORG ='1100';
              orderheader.DISTR_CHAN ='10';
              orderheader.DIVISION ='10';
              orderheader.SALES_GRP ='STD';
              orderheader.SALES_OFF = quote.Account.Sales_Office__c;
              orderheader.REQ_DATE_H = dt;
              orderheader.PRICE_DATE = dt;

       PricingRequest.ORDER_ITEMS_IN orderItems = new PricingRequest.ORDER_ITEMS_IN();
              list<PricingRequest.Item> listi = new list<PricingRequest.Item>();
              for(QuoteLineItem ql: quote.QuoteLineItems){
                    PricingRequest.Item Itemobj = new  PricingRequest.Item();
                    Itemobj.ITM_NUMBER = ql.Item_Number__c;  //'000010';
                    Itemobj.MATERIAL = ql.Product2.ENSX_EDM__Material__c;
                    Itemobj.PLANT = ql.Plant__c;   //'1200';
                    Itemobj.TARGET_QTY = String.valueOf(ql.Quantity);
                    listi.add(Itemobj);
              }
              orderItems.item = listi;


        list<PricingRequest.Item_Z> itemlist = new list<PricingRequest.Item_Z>();
               PricingRequest.Item_Z iteobj =new  PricingRequest.Item_Z();
                   iteobj.PARTN_ROLE ='AG';
                   iteobj.PARTN_NUMB = quote.Account.SAPCustomerNumber__c;
                   itemlist.add(iteobj);

        PricingRequest.ORDER_PARTNERS orderitem = new PricingRequest.ORDER_PARTNERS();
        orderitem.item = itemlist;


         PricingRequest requestprc = new PricingRequest();
             requestprc.ORDER_HEADER_IN = orderheader;
             requestprc.ORDER_ITEMS_IN =orderItems;
             requestprc.ORDER_PARTNERS =orderitem;

         string request = JSON.serialize(requestprc);
             system.debug(request); 
        
         String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_Pricing', request, 'POST');
             system.debug(JsonResponse);
        
         PricingResponse wrapper =(PricingResponse)JSON.deserialize(JsonResponse,PricingResponse.class);
        // system.debug(wrapper);

         system.debug((wrapper.ORDER_PRICING).item);
          Map<String,list<PricingResponse.Item>> results = new Map<String, list<PricingResponse.Item>>();
            for(PricingResponse.Item_Z it : (wrapper.ORDER_PRICING).item){
                   results.put(it.MATERIAL,(it.PRICING).item);
                }

            for(QuoteLineItem qutobj : quote.QuoteLineItems){
                 
         
                      for(PricingResponse.Item sb : results.get(qutobj.Product2.ENSX_EDM__Material__c)){
        
                          
                          if(sb.COND_DESC == 'Line Tax'){
                            qutobj.LineTax__c = sb.CONDVALUE;
                            qutobj.LTax__c = sb.COND_VALUE;
                              
                          }
                          if(sb.COND_DESC == 'Line Total'){
                            qutobj.Line_Total__c = sb.COND_VALUE;
                          }
                          if(sb.COND_DESC == 'Freight'){
                            qutobj.Frieght__c = sb.COND_VALUE;
                          }
                          if(sb.COND_DESC == 'Discount'){
                              Decimal de = sb.CONDVALUE;
                            qutobj.Discount__c = math.abs(de);
                               Decimal disct = sb.COND_VALUE;
                            qutobj.Discount = math.abs(disct);
                              
                          }
                          if(sb.COND_DESC == 'Price'){
                            qutobj.UnitPrice = sb.COND_VALUE;
                          }
                          if(sb.COND_DESC == 'Net Line Value'){
                             qutobj.Net_Line_Value__c = sb.COND_VALUE;
                           }
        
        
                      }
         updatelist.add(qutobj);
            
    //system.debug('test1');
                  }
                  update updateList;

        
        return updateStatus(updateList);
             }else{
                return null;
            }
        }catch(exception e){
            
            
            return null;
            
        }
    }
    
    
    public static string updateStatus(List<QuoteLineItem> quotelineitems){
        string status = '';
        
        
        
         Database.SaveResult[] srList = Database.update(quotelineitems, true);
                  // Database method to update the records in List
          if(quotelineitems.size()>0){
                   // Iterate through each returned result by the method
                  for (Database.SaveResult sr : srList) {
                  if (sr.isSuccess()) {
                        // This condition will be executed for successful records and will fetch
                       // the ids of successful records
                      	 System.debug('Successfully updated  : ' + sr.getId());
                        status = 'Successfully updated';       
                       } else {
                            // This condition will be executed for failed records
                          status = 'Check the Inputs (or) Try Next ';
                       }
                    }  
    
    return status;
        
        }else{
           
            return null;
        }
    }
    
    
    /*
######################################################################################################################
Method Name:       createOrder
Description:  This methods makes an Api Call to SAP to create Order. 
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     5/02/2018   1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/ 
    
          @AuraEnabled 
      public static id createOrder(Id recordId, Boolean check, String aStreet, String aCity, String aState, String aZIPCode)
      {
   
            Quote quote = [select Name,Account.SAPCustomerNumber__c,OpportunityId,Pricebook2Id, Account.Sales_Office__c,(select Product2.ENSX_EDM__Material__c,Quantity,UnitPrice,PricebookEntryId,Product2Id FROM QuoteLineItems) from Quote where Id =:recordId];
            
            Date d = date.today();
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYYMMdd');

            CreateOrderRequest.ORDER_CCARD  orderccard =  new CreateOrderRequest.ORDER_CCARD();
                CreateOrderRequest.Item itemobj = new CreateOrderRequest.Item();
                  itemobj.CC_TYPE = 'AMEX';
                  itemobj.CC_NUMBER = 'T3806411154002145';
                  itemobj.CC_VALID_T = '20181130';
                  itemobj.BILLAMOUNT = '8.67';
                  itemobj.AUTHAMOUNT = '8.67';
                  itemobj.CURRENCYz = 'USD';
                orderccard.item = itemobj;


            CreateOrderRequest.ORDER_HEADER_IN  orderheaderin =  new CreateOrderRequest.ORDER_HEADER_IN();
                orderheaderin.DOC_TYPE = 'TA';
		        orderheaderin.SALES_ORG = '1100';
				orderheaderin.DISTR_CHAN = '10';
				orderheaderin.DIVISION ='10';
                orderheaderin.SALES_GRP ='STD';
                orderheaderin.SALES_OFF ='STD';
                orderheaderin.REQ_DATE_H = dt;
                orderheaderin.PRICE_DATE = dt;
                orderheaderin.PURCH_NO_C ='Customer PO - 001';

            CreateOrderRequest.ORDER_ITEMS_IN orderitemsobj = new CreateOrderRequest.ORDER_ITEMS_IN();
            List<CreateOrderRequest.Item_Z> itemzlist = new  List<CreateOrderRequest.Item_Z>();
            CreateOrderRequest.Item_Z itemzobj = new  CreateOrderRequest.Item_Z();
            
            for(QuoteLineItem ql: quote.QuoteLineItems){
                    itemzobj.ITM_NUMBER = '000010';
                    itemzobj.MATERIAL = ql.Product2.ENSX_EDM__Material__c;
                    itemzobj.PLANT ='1200';
                    itemzobj.TARGET_QTY = String.valueOf(ql.Quantity);
                    itemzobj.TARGET_QU ='EA';
                    itemzobj.HG_LV_ITEM ='000000';
                itemzlist.add(itemzobj);
            }
			orderitemsobj.item = itemzlist;
            
            CreateOrderRequest.ORDER_PARTNERS  orderpartners = new CreateOrderRequest.ORDER_PARTNERS();
            List<CreateOrderRequest.Item_Y> itemlisty = new List<CreateOrderRequest.Item_Y>();
            CreateOrderRequest.Item_Y itemy = new CreateOrderRequest.Item_Y();
            itemy.PARTN_ROLE = 'AG';
            itemy.PARTN_NUMB = quote.Account.SAPCustomerNumber__c;
            itemlisty.add(itemy);
			CreateOrderRequest.Item_Y itemy2 = new CreateOrderRequest.Item_Y();
               itemy2.PARTN_ROLE = 'WE';
               itemy2.PARTN_NUMB = quote.Account.SAPCustomerNumber__c;
               
                   if(check == true){
                   itemy2.ADDR_LINK = '100';
                   }
      
            itemlisty.add(itemy2);
 			orderpartners.item = itemlisty;
       
			CreateOrderRequest.PARTNERADDRESSES partneraddress = new CreateOrderRequest.PARTNERADDRESSES();
     		List<CreateOrderRequest.Item_X> itemxlist  = new List<CreateOrderRequest.Item_X>();
		if(check == true && aCity != ''){
				CreateOrderRequest.Item_X itemxobj  = new CreateOrderRequest.Item_X();
                    itemxobj.ADDR_NO = '100';
                    itemxobj.NAME = 'Hennie Nel';
                    itemxobj.CITY = aCity; //'Phoenix';
                    itemxobj.POSTL_COD1 = aZIPCode; //'85048';
                    itemxobj.STREET = aStreet; //'2635 E Amberwood Dr';
                    itemxobj.COUNTRY = 'US';
                    itemxobj.REGION = aState; //'AZ';
				itemxlist.add(itemxobj);
		}
    	 partneraddress.item = itemxlist;

		JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeObjectField('ORDER_CCARD', orderccard);
            gen.writeObjectField('ORDER_HEADER_IN', orderheaderin);
            gen.writeObjectField('ORDER_ITEMS_IN', orderitemsobj);
            gen.writeObjectField('ORDER_PARTNERS', orderpartners);
            
            if(itemxlist != null && !itemxlist.isEmpty()){ 
            gen.writeObjectField('PARTNERADDRESSES',partneraddress);
            }
			gen.writeEndObject();
			String reqstr = gen.getAsString();
            //system.debug(reqstr);
            string jsonreq = reqstr.replace('"CURRENCYz"','"CURRENCY"');
            //system.debug(jsonreq);

          String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_OrderCreate', jsonreq, 'POST');
           //system.debug(JsonResponse);

		  CreateOrderResponse wrapper = (CreateOrderResponse)JSON.deserialize(JsonResponse,CreateOrderResponse.class);

           //system.debug(wrapper.SALESDOCUMENT);
          //system.debug( quote.AccountId);
 			List<OrderItem> orderprdlist = new List<OrderItem>();
                ID recdId = null;
                if(wrapper.SALESDOCUMENT != ''){
                    Order ordobj = new Order();
                    ordobj.Name = quote.Name ;
                    ordobj.Pricebook2Id = quote.Pricebook2Id;
                    ordobj.SAP_Order_Number__c = wrapper.SALESDOCUMENT;
                    ordobj.AccountId = quote.AccountId;
                    ordobj.EffectiveDate = date.today();
                    ordobj.Status = 'Draft';
                    ordobj.QuoteId = quote.id;
                    ordobj.OpportunityId = quote.OpportunityId;
                   if(check == true){
                            ordobj.ShippingCity = aCity;
                            ordobj.ShippingPostalCode = aZIPCode;
                            ordobj.ShippingState = aState;
                            ordobj.ShippingStreet = aStreet;
                            ordobj.ShippingCountry = 'US';
                    }
                    insert ordobj;
                    recdId = ordobj.id;
  
               
                if(quote.QuoteLineItems.size()>0){
                for(QuoteLineItem quotelnitem : quote.QuoteLineItems){
                    OrderItem orderline = new OrderItem();
                    orderline.OrderId = recdId;
                    orderline.PricebookEntryId = quotelnitem.PricebookEntryId;
                    orderline.Product2Id = quotelnitem.Product2Id;
                    orderline.Quantity = quotelnitem.Quantity;
                    orderline.UnitPrice = quotelnitem.UnitPrice;
                    orderprdlist.add(orderline);
                  }
                   insert orderprdlist; 
                }
    
		
   
 		system.debug('objid-->'+ recdId);
        return recdId;  
                }else{
                    return null;
                }
 
      }
    
 
    
}
public with sharing class createorderWithAddress {
    
     
      @AuraEnabled 
      public static id createOrder(Id recordId, Boolean check, String aStreet, String aCity, String aState, String aZIPCode)
      {
   
            Quote quote = [select Name,Account.ENSX_EDM__SAP_Customer_Number__c,Pricebook2Id, Account.Sales_Office__c,(select Product2.ENSX_EDM__Material__c,Quantity,UnitPrice,PricebookEntryId,Product2Id FROM QuoteLineItems) from Quote where Id =:recordId];
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
itemy.PARTN_NUMB = quote.Account.ENSX_EDM__SAP_Customer_Number__c;
itemlisty.add(itemy);
CreateOrderRequest.Item_Y itemy2 = new CreateOrderRequest.Item_Y();
       itemy2.PARTN_ROLE = 'WE';
       itemy2.PARTN_NUMB = quote.Account.ENSX_EDM__SAP_Customer_Number__c;
       
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



//CreateOrderRequest request = new CreateOrderRequest();
  //  request.ORDER_CCARD = orderccard;
  //  request.ORDER_HEADER_IN = orderheaderin;
  //  request.ORDER_ITEMS_IN = orderitemsobj;
  //  request.ORDER_PARTNERS = orderpartners;
  //  request.PARTNERADDRESSES = partneraddress;

//string sendrequest = JSON.serialize(request);
//string jsonreq = sendrequest.replace('"CURRENCYz"','"CURRENCY"');
//system.debug(jsonreq); 

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
String pretty = gen.getAsString();
//system.debug(pretty);
string jsonreq = pretty.replace('"CURRENCYz"','"CURRENCY"');
     system.debug(jsonreq);
String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_OrderCreate', jsonreq, 'POST');
system.debug(JsonResponse);

CreateOrderResponse wrapper =(CreateOrderResponse)JSON.deserialize(JsonResponse,CreateOrderResponse.class);

system.debug(wrapper.SALESDOCUMENT);
//system.debug( quote.AccountId);
 List<OrderItem> orderprdlist = new List<OrderItem>();
ID abc = null;
if(wrapper.SALESDOCUMENT != ''){
    Order ordobj = new Order();
    ordobj.Name = quote.Name ;
    ordobj.Pricebook2Id = quote.Pricebook2Id;
    ordobj.SAP_Order_Number__c = wrapper.SALESDOCUMENT;
    ordobj.AccountId = quote.AccountId;
    ordobj.EffectiveDate = date.today();
    ordobj.Status = 'Draft';
    ordobj.QuoteId = quote.id;
   if(check == true){
            ordobj.ShippingCity = aCity;
            ordobj.ShippingPostalCode = aZIPCode;
            ordobj.ShippingState = aState;
            ordobj.ShippingStreet = aStreet;
            ordobj.ShippingCountry = 'US';
    }
    insert ordobj;
     abc = ordobj.id;
  
   
    if(quote.QuoteLineItems.size()>0){
    for(QuoteLineItem quotelnitem : quote.QuoteLineItems){
        OrderItem orderline = new OrderItem();
        orderline.OrderId = abc;
        orderline.PricebookEntryId = quotelnitem.PricebookEntryId;
        orderline.Product2Id = quotelnitem.Product2Id;
        orderline.Quantity = quotelnitem.Quantity;
        orderline.UnitPrice = quotelnitem.UnitPrice;
        orderprdlist.add(orderline);
      }
       insert orderprdlist; 
    }
    
}
   
 

 system.debug('objid-->'+ abc);
       
    return abc;  
 }
    
    

}
public with sharing class OrderCreatecontroller {

    public with sharing class ordobjwrapper {
        public String Asalesoffice;
        public String Asalesorg;
        public String ASAPCustomerNum;
        public Id AAccountID;
        public Id AOpportunityID;
    }

    public with sharing class AccountDetailsWrapper {
        public String ShipToCustomerNo;
        public String SoldToCtomerNo;
        public String SalesOffice;
        public String SalesOrg;
        public String Salesgroup;
        public String Doc_Type;
        public String Division;
        public String DistributionChannel;
        public String CustomerPo;
        public Id AAccountID;
        public Id AOpportunityID;
        public Id ContactID;
        public Date Podate;
        public Date ReqShipDate;
        public String Emailaddress;
        public String DepositTerms;
        public String PaymentTerms;
        public String CustomerShipAccount;
        public String Phonenumber;
        public String companycode;
        public String shippingmethod;
        public String CustomerDiscountCondition;
        public String CustomerFreightCondition;
        public String SapOrderNumber;
        public String ShippingInstructions;
        


    }

    public with sharing class InitialLoadWrapper {

        @AuraEnabled public Account accobj {
            get;
            set;
        }
        @AuraEnabled public map < String, String > ordertype {
            get;
            set;
        }
        @AuraEnabled public map < String, String > discountCondition {
            get;
            set;
        }
        @AuraEnabled public map < String, String > freightCondition {
            get;
            set;
        }
    }

    public with sharing class InitialLoadWrapperForOrderUpdate {

        @AuraEnabled public Order ord {
            get;
            set;
        }
        @AuraEnabled public List < OrderItem > orderItems {
            get;
            set;
        }
        @AuraEnabled public map < String, String > ordertype1 {
            get;
            set;
        }
        @AuraEnabled public map < String, String > discountCondition1 {
            get;
            set;
        }
        @AuraEnabled public map < String, String > freightCondition1 {
            get;
            set;
        }
    }



    @AuraEnabled
    public static map < String, String > getOrderValues(string object_name, String field_name) {
        //List<String> options = new List<String>(); //new list for holding all of the picklist options

        system.debug('op-->' + object_name + field_name);
        Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(object_name); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List < Schema.PicklistEntry > pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        map < string, string > opptions = new map < string, string > ();

        for (Schema.PicklistEntry a: pick_list_values) { //for all values in the picklist list

            opptions.put(a.getLabel(), a.getValue());

        }


        return opptions;
    }

    @AuraEnabled
    public static string deleteLineItem(OrderItem ordItm) {
        // Perform isDeletable() check here 
        string message;
        try {
            if (ordItm.IsCreated__c == true) {
                List < OrderItem > dependantOrderItem = [select Id, RejectReason__c from OrderItem Where Order_Product_Parent__c =: ordItm.Id];
                List < OrderItem > updateRejectReasonForOrdItemList = new List < OrderItem > ();
                for (OrderItem ord: dependantOrderItem) {
                    ord.RejectReason__c = '61';
                    updateRejectReasonForOrdItemList.add(ord);
                }
                ordItm.RejectReason__c = '61';
                updateRejectReasonForOrdItemList.add(ordItm);
                update updateRejectReasonForOrdItemList;
            } else {
                delete ordItm;
            }
            message = 'Success';
        } catch (DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {

                message = e.getDmlMessage(i);
            }
        }

        return message;
    }

    @AuraEnabled
    public static string updateLineItem(OrderItem ordItm) {
        // Perform isDeletable() check here 
        string message;
        try {

            update ordItm;
            message = 'Success';
        } catch (DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {

                message = e.getDmlMessage(i);
            }
        }

        return message;
    }



    @AuraEnabled
    public static InitialLoadWrapper getAccountAddress(Id recordId) {
        //  ID recID = Id.valueOf(recordId);
        system.debug(recordId);
        Account Acclist = [SELECT Name, Phone, Id, ShippingCondition__c, SalesGroup__c, PaymentTerms__c, Division__c, DistributionChannel__c, CompanyCode__c, CustomerShipAccount__c, SalesOrg__c, Email__c, SalesOffice__c, CustomerNumber__c, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, (SELECT Name, Id from Contacts), (SELECT CustomerNumber__c, SAP_Ship_To_Number__c, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode FROM ChildAccounts) FROM Account WHERE Id In(SELECT AccountId FROM Opportunity WHERE Id =: recordId) limit 1];
        system.debug(Acclist.ChildAccounts);
        map < String, String > orderTypeList = OrderCreatecontroller.getOrderValues('Order', 'Type');
        map < String, String > freightConditionMap = OrderCreatecontroller.getOrderValues('Order', 'CustomerFreightConditionGroup__c');
        map < String, String > discountConditionMap = OrderCreatecontroller.getOrderValues('Order', 'CustomerDiscountConditionGroup__c');
        system.debug('freight-->' + freightConditionMap);
        system.debug('discount-->' + discountConditionMap);
        InitialLoadWrapper loadWrapper = new InitialLoadWrapper();
        loadWrapper.accobj = Acclist;
        loadWrapper.ordertype = orderTypeList;
        loadWrapper.freightCondition = freightConditionMap;
        loadWrapper.discountCondition = discountConditionMap;
        return loadWrapper;
    }

    @AuraEnabled
    public static List < OrderItem > getCustomLineItems(String customizerJson, Id itemId, Id orderid) {

        system.debug(itemId);
        String customizerJson1 = customizerJson.replace('\\', '');
        string customjsaon2 = customizerJson1.replace('"{', '{');
        system.debug(customjsaon2);
        string customizerJson3 = customjsaon2.replace('}"', '}');
        system.debug(customizerJson3);
        system.debug(customizerJson1);
        Blob CustomizerBlob = Blob.valueof(customizerJson1);
        String Text = EncodingUtil.base64Encode(CustomizerBlob);
        system.debug('base64encoded-->'+Text );

        List < customizerdata > custwrapper = (List < customizerdata > ) JSON.deserialize(customizerJson3, List < customizerdata > .class);
        system.debug(custwrapper);
         List < OrderItem > insertorderItemlist = new List < OrderItem > ();
        
        OrderItem ordItmParent = new OrderItem();
         ordItmParent.Id = itemId;
         ordItmParent.Json_Text__c = Text;
         update ordItmParent;
         
        
        
       
        for (customizerdata customdata: custwrapper) {

            OrderItem ordItm = new OrderItem();
            Id productid = [select Id from product2 where Name =: customdata.customtype AND ramsideloc__c =: customdata.ramsideloc limit 1].Id;
            ordItm.OrderId = orderid;
            ordItm.Order_Product_Parent__c = itemId;
            ordItm.Product2Id = productid;
            ordItm.custpreview__c = customdata.custpreview;
            ordItm.ramsideloc__c = customdata.ramsideloc;
            ordItm.warpedpreview__c = customdata.warpedpreview;
            ordItm.Quantity = 1;
            ordItm.UnitPrice = 1;
            PricebookEntry Standardbook = [SELECT Id FROM PricebookEntry WHERE Product2Id =: productid AND Pricebook2Id IN(select Pricebook2Id from Order where Id =: orderid) AND CurrencyIsoCode =: UserInfo.getDefaultCurrency()];
            ordItm.PricebookEntryId = Standardbook.Id;
            //ordItm.Json_Text__c = Text;
            insertorderItemlist.add(ordItm);
        }

        insert insertorderItemlist;

        return insertorderItemlist;



    }



    @AuraEnabled
    public static OrderItem getLineItems(Product2 prdobj, Id recId, String ordobj) {
        system.debug('product-->' + prdobj);
        system.debug('orderid-->' + recId);
        system.debug('productid-->' + ordobj);
        AccountDetailsWrapper ordwrapper = (AccountDetailsWrapper) JSON.deserialize(ordobj, AccountDetailsWrapper.class);
        //system.debug(ordwrapper.Asalesoffice);
        Id recordId = '8010t000001APRjAAO';


        AvailabilityRequest.PRODUCTS products = new AvailabilityRequest.PRODUCTS();
        List < AvailabilityRequest.Item > itmlist = new List < AvailabilityRequest.Item > ();
        AvailabilityRequest.Item itmobj = new AvailabilityRequest.Item();
        itmobj.MATERIAL = prdobj.ENSX_EDM__Material__c;
        itmlist.add(itmobj);
        products.item = itmlist;

        Date d = date.today();
        String dt = DateTime.newInstance(d.year(), d.month(), d.day()).format('YYYY-MM-dd');
        //system.debug(dt);

        AvailabilityRequest request = new AvailabilityRequest();
        request.CUSTOMER = ordwrapper.SoldToCtomerNo; //'100422';
        request.PRICE_DATE = dt;
        request.PRODUCTS = products;
        request.SALES_GRP = ordwrapper.Salesgroup;
        request.SALES_OFF = ordwrapper.SalesOffice;
        request.SALES_ORG = ordwrapper.SalesOrg;
        request.DISTR_CHAN = ordwrapper.DistributionChannel;
        request.DIVISION = ordwrapper.Division;

        String Jsonrequest = JSON.serialize(request);
        System.debug('request-->' + Jsonrequest);

        String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_Availability', Jsonrequest, 'POST');
        System.debug(JsonResponse);
        map < string, AvailabilityResponse.Item_Z > results = new map < string, AvailabilityResponse.Item_Z > ();
        AvailabilityResponse wrapper = (AvailabilityResponse) JSON.deserialize(JsonResponse, AvailabilityResponse.class);

        for (AvailabilityRequest.Item material1: itmlist) {
            for (AvailabilityResponse.Item_Z itemz: (wrapper.PRODUCT_LIST).item) {
                if (itemz.MATERIAL == material1.MATERIAL) {
                    results.put(material1.MATERIAL, itemz);
                }
            }
        }
        system.debug('test1-->' + results);
        system.debug('test2-->');

        Order orderObj = new Order();
        orderObj.AccountId = ordwrapper.AAccountID;
        orderObj.OpportunityId = ordwrapper.AOpportunityID;
        orderObj.Status = 'Draft';
        orderObj.EffectiveDate = date.today();
        orderObj.CustomerPo__c = ordwrapper.CustomerPo;
        orderObj.DistributionChannel__c = ordwrapper.DistributionChannel;
        orderObj.Division__c = ordwrapper.Division;
        orderObj.Type = ordwrapper.Doc_Type;
        orderObj.SalesGroup__c = ordwrapper.Salesgroup;
        orderObj.SalesOffice__c = ordwrapper.SalesOffice;
        orderObj.SalesOrg__c = ordwrapper.SalesOrg;
        orderObj.SAPCustomerNumber__c = ordwrapper.SoldToCtomerNo;
        orderObj.ShipToCustomerNo__c = ordwrapper.ShipToCustomerNo;
        orderObj.ShipToContactId = ordwrapper.ContactID;
        orderObj.Phone__c = ordwrapper.Phonenumber;
        orderObj.PoDate = ordwrapper.Podate;
        orderObj.RequestedShipDate__c = ordwrapper.ReqShipDate;
        orderObj.Email__c = ordwrapper.Emailaddress;
        orderObj.DepositTerms__c = ordwrapper.DepositTerms;
        orderObj.PaymentTerms__c = ordwrapper.PaymentTerms;
        orderObj.CustomerShipAccount__c = ordwrapper.CustomerShipAccount;
        orderObj.CompanyCode__c = ordwrapper.companycode;
        orderObj.ShippingInstructions__c = ordwrapper.ShippingInstructions;
		orderObj.ShippingMethod__c = ordwrapper.shippingmethod;
        orderObj.BillToContactId = ordwrapper.ContactID;
        orderObj.CustomerDiscountConditionGroup__c = ordwrapper.CustomerDiscountCondition;
        orderObj.CustomerFreightConditionGroup__c = ordwrapper.CustomerFreightCondition;
        Id pricebookid = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE AND CurrencyIsoCode =: UserInfo.getDefaultCurrency()].Id;
        orderObj.Pricebook2Id = pricebookid;
        if (recId != null) {
            orderObj.id = recId;
            update orderObj;

        } else {
            insert orderObj;
        }



        OrderItem orderitm = new OrderItem();
        orderitm.OrderId = orderObj.Id;
        orderitm.Product2Id = prdobj.Id;
        orderitm.Quantity = 1;

        PricebookEntry Standardbook = [SELECT Id FROM PricebookEntry WHERE Product2Id =: prdobj.Id AND Pricebook2Id =: orderObj.Pricebook2Id AND CurrencyIsoCode =: UserInfo.getDefaultCurrency()];
        // SELECT Id FROM PricebookEntry WHERE Product2Id = '01ti0000009Ay9TAAS' AND Pricebook2Id = '01si0000001DwFIAA0'
        orderitm.PricebookEntryId = Standardbook.Id;

        //[SELECT Id FROM PricebookEntry WHERE Product2Id =:prdobj.Id AND Pricebook2Id IN (SELECT Pricebook2Id FROM Order) AND CurrencyIsoCode =: UserInfo.getDefaultCurrency()];
        // Id p = '01ui000000zOf0SAAS';

        orderitm.AvailableQuantity__c = (results.get(prdobj.ENSX_EDM__Material__c)).QTY_AVAILABLE;
        orderitm.Plant__c = (results.get(prdobj.ENSX_EDM__Material__c)).PLANT;
        orderitm.ItemNumber__c = (results.get(prdobj.ENSX_EDM__Material__c)).ITM_NUMBER;

        for (AvailabilityResponse.Item sb: ((results.get(prdobj.ENSX_EDM__Material__c)).PRICING).item) {

            //system.debug('test3-->');
            if (sb.COND_DESC == 'Freight') {
                orderitm.Freight__c = sb.COND_VALUE;
            }
            if (sb.COND_DESC == 'Price') {
                orderitm.UnitPrice = sb.COND_VALUE;
            }
            if (sb.COND_DESC == 'Net Line Value') {
                orderitm.Net_Line_Value__c = sb.COND_VALUE;
            }

        }

        insert orderitm;
        system.debug('test-->for name' + prdobj.Id);
        OrderItem orderobjt = [select Id, Plant__c, LineTax__c, Quantity, NetLineValue__c, Discount__c, Freight__c, AvailableQuantity__c, Line_Total__c, ItemNumber__c, productkey__c, MaterialId__c, OrderId, UnitPrice, Product2.Name, Product2.ENSX_EDM__Material__c From OrderItem where Id =: orderitm.Id limit 1];
        // Order orderobjt = [select id,(select Product2.Name, AvailableQuantity,UnitPrice from OrderItems) from Order where id =:orderObj.Id]; 

        return orderobjt;


    }

    @AuraEnabled
    public Static List < OrderItem > getPriceSimulation(String orderScreenInputs, List <OrderItem> orderLitems, Id orderid) {
		system.debug('update pricing-->'+orderLitems+orderid);
      
       Order order = [select Name, Account.CustomerNumber__c,ShippingInstructions__c, OpportunityId, (select MaterialId__c, Order_Product_Parent__c, IsCreated__c, Quantity, UnitPrice,Json_Text__c,ItemNumber__c, Plant__c FROM OrderItems) from Order where Id =: orderid];
        List < OrderItem > ordItemUpdateList = new list < OrderItem > ();
        map < Id, string > itemnumbers = new map < Id, string > ();
        Integer count = 000010;
        for (OrderItem ql: orderLitems) {
           // ql.IsCreated__c = true;
            ql.ItemNumber__c = String.valueOf(count);
            count += 10;
            itemnumbers.put(ql.Id, ql.ItemNumber__c);
            ordItemUpdateList.add(ql);
            system.debug('Item number' + ordItemUpdateList);
        }
        // Order order = [select Account.SAPCustomerNumber__c, Account.Sales_Office__c,(select Product2.ENSX_EDM__Material__c,Plant__c,ItemNumber__c,Quantity FROM OrderItems where Quantity > 0 ) from Order	 where Id =:recordId];
        AccountDetailsWrapper ScreenInputs = (AccountDetailsWrapper) JSON.deserialize(orderScreenInputs, AccountDetailsWrapper.class);
        // if(order.OrderItems.size()>0){
        Date d = date.today();
        String dt = DateTime.newInstance(d.year(), d.month(), d.day()).format('YYYYMMdd');

        PricingRequest.ORDER_HEADER_IN orderheader = new PricingRequest.ORDER_HEADER_IN();
        orderheader.DOC_TYPE = ScreenInputs.Doc_Type; //'ZCLC';
        orderheader.SALES_ORG = ScreenInputs.SalesOrg; //'1100';
        orderheader.DISTR_CHAN = ScreenInputs.DistributionChannel; //'10';
        orderheader.DIVISION = ScreenInputs.Division; //'10';
        orderheader.SALES_GRP = ScreenInputs.Salesgroup; //'STD';
        orderheader.SALES_OFF = ScreenInputs.SalesOffice; //'STD'; //quote.Account.Sales_Office__c;
        orderheader.REQ_DATE_H = dt;
        orderheader.PRICE_DATE = dt;

        PricingRequest.ORDER_ITEMS_IN orderItems = new PricingRequest.ORDER_ITEMS_IN();
        list < PricingRequest.Item > listi = new list < PricingRequest.Item > ();
        for (OrderItem lineitem: ordItemUpdateList) {
            PricingRequest.Item Itemobj = new PricingRequest.Item();
            Itemobj.ITM_NUMBER = lineitem.ItemNumber__c; //'000010';
            Itemobj.MATERIAL = lineitem.MaterialId__c;
            Itemobj.PLANT = lineitem.Plant__c; //'1200';
            Itemobj.TARGET_QTY = String.valueOf(lineitem.Quantity);
             if (lineitem.Order_Product_Parent__c != null) {
                Itemobj.HG_LV_ITEM = itemnumbers.get(lineitem.Order_Product_Parent__c);
            }
            listi.add(Itemobj);
        }
        orderItems.item = listi;
        
       


        list < PricingRequest.Item_Z > itemlist = new list < PricingRequest.Item_Z > ();
        PricingRequest.Item_Z iteobj = new PricingRequest.Item_Z();
        iteobj.PARTN_ROLE = 'AG';
        iteobj.PARTN_NUMB = ScreenInputs.SoldToCtomerNo;
        itemlist.add(iteobj);

        PricingRequest.ORDER_PARTNERS orderitem = new PricingRequest.ORDER_PARTNERS();
        orderitem.item = itemlist;


        PricingRequest requestprc = new PricingRequest();
        requestprc.ORDER_HEADER_IN = orderheader;
        requestprc.ORDER_ITEMS_IN = orderItems;
        requestprc.ORDER_PARTNERS = orderitem;

        string request = JSON.serialize(requestprc);
        system.debug('request-->' + request);

        String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_Pricing', request, 'POST');
        system.debug(JsonResponse);

        PricingResponse wrapper = (PricingResponse) JSON.deserialize(JsonResponse, PricingResponse.class);
        system.debug(wrapper);

        system.debug('test-->' + (wrapper.ORDER_PRICING).item);
        Map < Integer, list < PricingResponse.Item >> results = new Map < Integer, list < PricingResponse.Item >> ();
        for (PricingResponse.Item_Z it: (wrapper.ORDER_PRICING).item) {
            String quantity = String.valueOf((it.REQ_QTY).round(System.RoundingMode.FLOOR));
            //results.put(it.MATERIAL + quantity, (it.PRICING).item);
           // Integer myInt = Integer.valueOf(it.ITM_NUMBER);

            results.put(Integer.valueOf(it.ITM_NUMBER), (it.PRICING).item);
        }
        system.debug('results---->' + results);

        list < OrderItem > updatelist = new list < OrderItem > ();

        system.debug('--->'+orderLitems);

        for (OrderItem ordobj: ordItemUpdateList) {

            String material = String.valueOf((ordobj.Quantity).round(System.RoundingMode.FLOOR));
            //string material = ordobj.MaterialId__c + String.valueOf(ordobj.Quantity);
           // system.debug('results map--->'+results.get(ordobj.ItemNumber__c));
            for (PricingResponse.Item sb: results.get(Integer.valueOf(ordobj.ItemNumber__c)) ) {
                // system.debug(valueOf((ordobj.Quantity).round(System.RoundingMode.FLOOR)));
                if (sb.COND_DESC == 'Line Tax') {
                    ordobj.LineTax__c = sb.CONDVALUE;
                    //qutobj.LTax__c = sb.COND_VALUE;

                }
                if (sb.COND_DESC == 'Line Total') {
                    ordobj.Line_Total__c = sb.COND_VALUE;
                }
                if (sb.COND_DESC == 'Freight') {
                    ordobj.Freight__c = sb.COND_VALUE;
                }
                if (sb.COND_DESC == 'Discount') {
                    Decimal de = sb.CONDVALUE;
                    ordobj.Discount__c = math.abs(de);
                    // Decimal disct = sb.COND_VALUE;
                    //ordobj.Discount = math.abs(disct);

                }
                if (sb.COND_DESC == 'Price') {
                    ordobj.UnitPrice = sb.COND_VALUE;
                }
                if (sb.COND_DESC == 'Net Line Value') {
                    ordobj.NetLineValue__c = sb.COND_VALUE;
                }
            }
            updatelist.add(ordobj);

        }


        update updatelist;



        system.debug('listreturned' + updatelist);
        return updatelist;

    }

    @AuraEnabled
    public static String createSAPOrder(Id recordId, String orderRecord) {
        system.debug('order-->' + orderRecord);
        system.debug('id-->' + recordId);
        AccountDetailsWrapper accountdetails = (AccountDetailsWrapper) JSON.deserialize(orderRecord, AccountDetailsWrapper.class);
        Order order = [select Name, Account.CustomerNumber__c,ShippingInstructions__c, OpportunityId, (select Product2.ENSX_EDM__Material__c, Order_Product_Parent__c, IsCreated__c, Quantity, UnitPrice,Json_Text__c,ItemNumber__c, Plant__c FROM OrderItems) from Order where Id =: recordId];
        List < OrderItem > ordItemUpdateList = new list < OrderItem > ();
        map < Id, string > itemnumbers = new map < Id, string > ();
        Integer count = 000010;
        for (OrderItem ql: order.OrderItems) {
            ql.IsCreated__c = true;
            ql.ItemNumber__c = String.valueOf(count);
            count += 10;
            itemnumbers.put(ql.Id, ql.ItemNumber__c);


            ordItemUpdateList.add(ql);
            system.debug('Item number' + ordItemUpdateList);
        }

        Date d = date.today();
        String dt = DateTime.newInstance(d.year(), d.month(), d.day()).format('YYYYMMdd');

        CreateOrderRequest.ORDER_CCARD orderccard = new CreateOrderRequest.ORDER_CCARD();
        CreateOrderRequest.Item itemobj = new CreateOrderRequest.Item();
        itemobj.CC_TYPE = 'AMEX';
        itemobj.CC_NUMBER = 'T3806411154002145';
        itemobj.CC_VALID_T = '20181130';
        itemobj.BILLAMOUNT = '8.67';
        itemobj.AUTHAMOUNT = '8.67';
        itemobj.CURRENCYz = 'USD';
        orderccard.item = itemobj;


        CreateOrderRequest.ORDER_HEADER_IN orderheaderin = new CreateOrderRequest.ORDER_HEADER_IN();
        orderheaderin.DOC_TYPE = accountdetails.Doc_Type; //'TA';
        orderheaderin.SALES_ORG = accountdetails.SalesOrg; //'1100';
        orderheaderin.DISTR_CHAN = accountdetails.DistributionChannel; // '10';
        orderheaderin.DIVISION = accountdetails.Division; //'10';
        orderheaderin.SALES_GRP = accountdetails.Salesgroup; //'STD';
        orderheaderin.SALES_OFF = accountdetails.SalesOffice; //'STD';
        orderheaderin.REQ_DATE_H = dt;
        orderheaderin.PRICE_DATE = dt;
        orderheaderin.PURCH_NO_C = accountdetails.CustomerPo; //'Customer PO - 001';



        CreateOrderRequest.ORDER_ITEMS_IN orderitemsobj = new CreateOrderRequest.ORDER_ITEMS_IN();
        List < CreateOrderRequest.Item_Z > itemzlist = new List < CreateOrderRequest.Item_Z > ();
        system.debug('list' + ordItemUpdateList);


        for (OrderItem OrderItm: ordItemUpdateList) {
            system.debug('Item number 1' + OrderItm.ItemNumber__c);
            CreateOrderRequest.Item_Z itemzobj = new CreateOrderRequest.Item_Z();
            OrderItm.ParentLineNumber__c = itemnumbers.get(OrderItm.Order_Product_Parent__c);
            itemzobj.ITM_NUMBER = OrderItm.ItemNumber__c;
            system.debug('Item number 2' + itemzobj.ITM_NUMBER);
            itemzobj.MATERIAL = OrderItm.Product2.ENSX_EDM__Material__c;
            itemzobj.PLANT = String.valueOf(OrderItm.Plant__c); //'1200';
            itemzobj.TARGET_QTY = String.valueOf(OrderItm.Quantity);
            itemzobj.TARGET_QU = 'EA';
            if (OrderItm.Order_Product_Parent__c != null) {
                itemzobj.HG_LV_ITEM = itemnumbers.get(OrderItm.Order_Product_Parent__c);
            }
            itemzlist.add(itemzobj);
            system.debug('test1' + itemzobj);
        }
        system.debug('itemnumber list -->' + itemzlist);

        orderitemsobj.item = itemzlist;

        CreateOrderRequest.ORDER_PARTNERS orderpartners = new CreateOrderRequest.ORDER_PARTNERS();
        List < CreateOrderRequest.Item_Y > itemlisty = new List < CreateOrderRequest.Item_Y > ();
        CreateOrderRequest.Item_Y itemy = new CreateOrderRequest.Item_Y();
        itemy.PARTN_ROLE = 'AG';
        itemy.PARTN_NUMB = accountdetails.SoldToCtomerNo; //order.Account.SAPCustomerNumber__c;
        itemlisty.add(itemy);
        CreateOrderRequest.Item_Y itemy2 = new CreateOrderRequest.Item_Y();
        itemy2.PARTN_ROLE = 'WE';
        itemy2.PARTN_NUMB = accountdetails.ShipToCustomerNo; //order.Account.SAPCustomerNumber__c;
        itemlisty.add(itemy2);
        orderpartners.item = itemlisty;

        /*CreateOrderRequest.PARTNERADDRESSES partneraddress = new CreateOrderRequest.PARTNERADDRESSES();
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
    	 partneraddress.item = itemxlist;*/
        CreateOrderRequest.ORDER_TEXT ordertext = new CreateOrderRequest.ORDER_TEXT();
        List<CreateOrderRequest.Item_V> itemvlist = new  List<CreateOrderRequest.Item_V>();
         for (OrderItem OrderItmv: ordItemUpdateList) {
        CreateOrderRequest.Item_V itemv = new CreateOrderRequest.Item_V();
        itemv.ITM_NUMBER = OrderItmv.ItemNumber__c;
        itemv.TEXT_ID =  'ZJSO';
        itemv.TEXT_STRING = OrderItmv.Json_Text__c;   
         itemvlist.add(itemv);
         }
           ordertext.item = itemvlist;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('ORDER_CCARD', orderccard);
        gen.writeObjectField('ORDER_HEADER_IN', orderheaderin);
        gen.writeObjectField('ORDER_ITEMS_IN', orderitemsobj);
        gen.writeObjectField('ORDER_PARTNERS', orderpartners);
        if(itemvlist != null){
        gen.writeObjectField('ORDER_TEXT', ordertext);
        /* if(itemxlist != null && !itemxlist.isEmpty()){ 
         gen.writeObjectField('PARTNERADDRESSES',partneraddress);
         }*/
        }
        gen.writeEndObject();
        String reqstr = gen.getAsString();
        //system.debug(reqstr);
        string jsonreq = reqstr.replace('"CURRENCYz"', '"CURRENCY"');
        system.debug('request-->' + jsonreq);

        String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_OrderCreate', jsonreq, 'POST');
        system.debug(JsonResponse);

        CreateOrderResponse wrapper = (CreateOrderResponse) JSON.deserialize(JsonResponse, CreateOrderResponse.class);

        system.debug(wrapper.SALESDOCUMENT);


        if (wrapper.SALESDOCUMENT != '') {
            Order ordobj = new Order();
            ordobj.Id = recordId;
            ordobj.SAP_Order_Number__c = wrapper.SALESDOCUMENT;
            update ordobj;
            /*List<OrderItem> ordItemUpdateList = new list<OrderItem>();
                     for(OrderItem oi : order.OrderItems){
                   				oi.IsCreated__c = true;
                				ordItemUpdateList.add(oi);
           						 }*/
            update ordItemUpdateList;
            system.debug('Final Avail Items Create-->' + ordItemUpdateList);
            return 'Success';
        } else {
            return null;
        }
    }


    @AuraEnabled
    public static String createUpdateSAPOrder(Id recordId, String orderRec) {

        Order ord1 = [select Id, Phone__c,
            PoDate,
            Email__c,
            RequestedShipDate__c,
            DepositTerms__c,
            PaymentTerms__c,
            CustomerShipAccount__c,
            BillToContactId,
            Account.Name,
            BillToContact.Name,
            SAP_Order_Number__c,
            CompanyCode__c,
            ShippingCondition__c,
            Type,
            CustomerFreightConditionGroup__c,
            CustomerDiscountConditionGroup__c,
            ShippingInstructions__c,          
            ShipToCustomerNo__c, SoldToCustomerNo__c, SalesOffice__c, SalesGroup__c, SAPCustomerNumber__c, SalesOrg__c, DocType__c, Division__c, DistributionChannel__c, CustomerPo__c, AccountId, OpportunityId, Status, EffectiveDate, (select product2.Name, AvailableQuantity__c, MaterialId__c, UnitPrice, Quantity, Discount__c, LineTax__c, Line_Item_Status__c, Line_Total__c, Order_Product_Parent__c, Product2.ENSX_EDM__Material__c, ItemNumber__c, Plant__c, IsCreated__C, RejectReason__c FROM OrderItems) FROM Order where ID =: recordId
        ];
        AccountDetailsWrapper orderRecord = (AccountDetailsWrapper) JSON.deserialize(orderRec, AccountDetailsWrapper.class);
        system.debug('salesofffcie -->' + orderRecord);
        List < OrderItem > availableItems = new List < OrderItem > ();
        List < OrderItem > newItems = new List < OrderItem > ();
        map < Id, string > itemnumbers = new map < Id, string > ();
        Integer count = 10;
        for (OrderItem aoi: ord1.OrderItems) {
            system.debug('is created-->'+aoi.IsCreated__C);
            if (aoi.IsCreated__C == true) {
                if (Integer.valueof(aoi.ItemNumber__c) > count) {
                    count = Integer.valueof(aoi.ItemNumber__c);
                }
                availableItems.add(aoi);
            } else {
                system.debug('is created12-->'+aoi.IsCreated__C);
                newItems.add(aoi);

            }
            system.debug('itemNumber-->'+aoi.ItemNumber__c+'count-->'+count);
            itemnumbers.put(aoi.Id, aoi.ItemNumber__c);
        }
        system.debug('count check--'+newItems);
        if (newItems.size() > 0) {
            for (OrderItem newaoi: newItems) {
                system.debug('count check--'+count);
                count += 10;
                newaoi.IsCreated__C = true;
                newaoi.ItemNumber__c = String.valueof(count);
                availableItems.add(newaoi);
                itemnumbers.put(newaoi.Id, newaoi.ItemNumber__c);
                system.debug('new items itemNumber-->'+newaoi.ItemNumber__c+'count-->'+count);
            }
        }

        Date po = orderRecord.Podate;
        String podt = DateTime.newInstance(po.year(), po.month(), po.day()).format('YYYYMMdd');
        Date ship = orderRecord.ReqShipDate;
        String shipdt = DateTime.newInstance(ship.year(), ship.month(), ship.day()).format('YYYYMMdd');
        
        OrderService ordservice = new OrderService();
        ordservice.SALESDOCUMENT = orderRecord.SapOrderNumber;

        OrderService.ORDER_CCARD orderccard = new OrderService.ORDER_CCARD();
        OrderService.Item itemobj = new OrderService.Item();
        itemobj.CC_TYPE = 'AMEX';
        itemobj.CC_NUMBER = 'T3806411154002145';
        itemobj.CC_VALID_T = '20181130';
        itemobj.BILLAMOUNT = '8.67';
        itemobj.AUTHAMOUNT = '8.67';
        itemobj.CURRENCYz = 'USD';
        orderccard.item = itemobj;
        ordservice.ORDER_CCARD = orderccard;

        OrderService.ORDER_HEADER_IN orderheaderin = new OrderService.ORDER_HEADER_IN();
        orderheaderin.DOC_TYPE = orderRecord.Doc_Type; //'TA';
        orderheaderin.SALES_ORG = orderRecord.SalesOrg; //'1100';
        orderheaderin.DISTR_CHAN = orderRecord.DistributionChannel; // '10';
        orderheaderin.DIVISION = orderRecord.Division; //'10';
        orderheaderin.SALES_GRP = orderRecord.Salesgroup; //'STD';
        orderheaderin.SALES_OFF = orderRecord.SalesOffice; //'STD';
        orderheaderin.REQ_DATE_H = shipdt;
        orderheaderin.PRICE_DATE = podt;
        orderheaderin.PURCH_NO_C = orderRecord.CustomerPo; //'Customer PO - 001';
        ordservice.ORDER_HEADER_IN = orderheaderin;

        OrderService.ORDER_ITEMS_IN orderitemsobj = new OrderService.ORDER_ITEMS_IN();
        List < OrderService.Item_Z > itemzlist = new List < OrderService.Item_Z > ();
       
		
        orderService.ADD_ORDER_ITEMS_IN addOrdItems = new orderService.ADD_ORDER_ITEMS_IN();
		List <OrderService.Item_Y> itemylist = new List <OrderService.Item_Y> ();   
        
         OrderService.ORDER_TEXT ordtext = new OrderService.ORDER_TEXT();
        List < OrderService.Item_V > itemlistv = new List < OrderService.Item_V > ();
        OrderService.Item_V itemv = new OrderService.Item_V();
        itemv.ITM_NUMBER = '000000';
        itemv.TEXT_ID = 'TX03';
        itemv.TEXT_STRING = orderRecord.ShippingInstructions;
        itemlistv.add(itemv);
        ordtext.item = itemlistv;

        ordservice.ORDER_TEXT = ordtext;
        
        
        for (OrderItem ql: availableItems) {
             OrderService.Item_Z itemzobj = new OrderService.Item_Z();
             OrderService.Item_Y itemyobj = new OrderService.Item_Y();
            itemzobj.ITM_NUMBER = ql.ItemNumber__c;
            itemzobj.MATERIAL = ql.MaterialId__c;
            itemzobj.PLANT = String.valueOf(ql.Plant__c); //'1200';
            itemzobj.TARGET_QTY = String.valueOf(ql.Quantity);
            itemzobj.TARGET_QU = 'EA';
            if (ql.Order_Product_Parent__c != null) {
                itemzobj.HG_LV_ITEM = itemnumbers.get(ql.Order_Product_Parent__c);
                ql.ParentLineNumber__c = itemnumbers.get(ql.Order_Product_Parent__c);
            }
            else{
                if(ql.RejectReason__c == null){
                   
                itemyobj.ITM_NUMBER = ql.ItemNumber__c;
                itemyobj.READY_FOR_PROD = 'Y';
                        }
            }
            //itemzobj.HG_LV_ITEM ='000000';
            if (ql.RejectReason__c != null) {
                itemzobj.REASON_REJ = '61';
            }

            itemzlist.add(itemzobj);
            itemylist.add(itemyobj);
        }
        orderitemsobj.item = itemzlist;
        addOrdItems.item = itemylist;

        ordservice.ORDER_ITEMS_IN = orderitemsobj;
        ordservice.ADD_ORDER_ITEMS_IN = addOrdItems;

        OrderService.ORDER_PARTNERS orderpartners = new OrderService.ORDER_PARTNERS();
        List < OrderService.Item_W > itemlisty = new List < OrderService.Item_W > ();
        OrderService.Item_W itemy = new OrderService.Item_W();
        itemy.PARTN_ROLE = 'AG';
        itemy.PARTN_NUMB = ord1.SapCustomerNumber__c; //order.Account.SAPCustomerNumber__c;
        itemlisty.add(itemy);
        OrderService.Item_W itemy2 = new OrderService.Item_W();
        itemy2.PARTN_ROLE = 'WE';
        itemy2.PARTN_NUMB = ord1.ShipToCustomerNo__c; //order.Account.SAPCustomerNumber__c;
        itemlisty.add(itemy2);
        orderpartners.item = itemlisty;
        ordservice.ORDER_PARTNERS = orderpartners;
        string request = JSON.serialize(ordservice);
        string reqString = request.replace('CURRENCYz', 'CURRENCY');
        System.debug('Update request-->' + reqString);
        // Send request, and return response with Common API utility Class with POST method
        String JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_OrderChange', reqString, 'POST');
        System.debug('Update response---->'+JsonResponse);
        system.debug('Final Avail Items update-->' + availableItems);
        OrderUpdateResponse1 wrapper =(OrderUpdateResponse1)JSON.deserialize(JsonResponse,OrderUpdateResponse1.class);
        SYSTEM.debug('RESPONSE PARSER-->'+wrapper.RETURN_Z);
        System.JSONParser parser = System.JSON.createParser(JsonResponse);
       	List<String> responseList = OrderUpda(parser);
        if (responseList.contains('S')) {
            system.debug('response type----->'+responseList);
           	Order orderObj = new Order();
            if(recordId !=null){
			orderObj.Id = recordId;
            orderObj.CustomerPo__c = orderRecord.CustomerPo;
            orderObj.RequestedShipDate__c = orderRecord.ReqShipDate;
            orderObj.ShippingInstructions__c = orderRecord.ShippingInstructions;
                update orderObj;
                }
            Update availableItems;
            return 'SUCCESS';
        }
        else{
        return null;}
    }

public static List<String> OrderUpda(JSONParser parser) {
	List<String> responseType = new List<string>();	
    while (parser.nextToken() != null) {
            system.debug('JSON Token-->'+parser.getText());
               
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != null) {
					if (text == 'TYPE') {
						system.debug('Type-->'+parser.getText());
                        responseType.add(parser.getText());
					} 
				}
			}
		}
    return responseType;
	}

    
    @AuraEnabled
    public static InitialLoadWrapperForOrderUpdate getOrderResponse(Id recordId) {
        Order ord = [select Id, Phone__c,
            PoDate,
            Email__c,
            RequestedShipDate__c,
            DepositTerms__c,
            PaymentTerms__c,
            CustomerShipAccount__c,
            BillToContactId,
            Account.Name,
            BillToContact.Name,
            CompanyCode__c,
            ShippingCondition__c,
            SAP_Order_Number__c,
            ShippingInstructions__c,
            Type,
            CustomerFreightConditionGroup__c,
            CustomerDiscountConditionGroup__c,
            ShipToCustomerNo__c, SoldToCustomerNo__c, SalesOffice__c, SalesGroup__c, SAPCustomerNumber__c, SalesOrg__c, DocType__c, Division__c, DistributionChannel__c, CustomerPo__c, AccountId, OpportunityId, Status, EffectiveDate, (select product2.Name, AvailableQuantity__c, MaterialId__c, UnitPrice, Quantity, Discount__c, LineTax__c, Line_Item_Status__c, Line_Total__c, Product2.ENSX_EDM__Material__c, ItemNumber__c, Plant__c, IsCreated__C FROM OrderItems Where RejectReason__c =: null And IsCreated__C =: true) FROM Order where ID =: recordId
        ];
        system.debug('Order-->' + ord.poDate);
        //return ord;
        map < String, String > orderTypeList1 = OrderCreatecontroller.getOrderValues('Order', 'Type');
        map < String, String > freightConditionMap1 = OrderCreatecontroller.getOrderValues('Order', 'CustomerFreightConditionGroup__c');
        map < String, String > discountConditionMap1 = OrderCreatecontroller.getOrderValues('Order', 'CustomerDiscountConditionGroup__c');

        InitialLoadWrapperForOrderUpdate initialUpdate = new InitialLoadWrapperForOrderUpdate();
        initialUpdate.ord = ord;
        initialUpdate.orderItems = ord.orderitems;
        initialUpdate.ordertype1 = orderTypeList1;
        initialUpdate.discountCondition1 = discountConditionMap1;
        initialUpdate.freightCondition1 = freightConditionMap1;
        return initialupdate;
    }
}
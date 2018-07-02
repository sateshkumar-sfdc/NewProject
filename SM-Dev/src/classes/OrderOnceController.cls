public with sharing class OrderOnceController {


    public class wSearchAccount{
        public @AuraEnabled string accountId; 
        public @AuraEnabled string accountName;
        public @AuraEnabled string accountAddress;
        public wSearchAccount(string aid, string aname,string add){
            AccountId = aid;
            AccountName = aname;
            accountAddress = add;
        }
    }
    
    public class wLineItem{
        
        @AuraEnabled boolean ischeck{get;set;}
        public @AuraEnabled Id pbeid{get;set;}
        @AuraEnabled PriceBookEntry pbe{get;set;}
        @AuraEnabled Product2 prd{get;set;}
        
        @AuraEnabled Date lineNeedByDate{get;set;}
        @AuraEnabled decimal linePrice{get;set;}
        @AuraEnabled decimal lineQuantity{get;set;}
        @AuraEnabled decimal lineDiscountPercent{get;set;}
        @AuraEnabled decimal linecalcTotalPrice{get;set;}

        public wLineItem(boolean ischeck, PriceBookEntry pbe, Product2 prd){
            this.ischeck = ischeck;
            this.pbeid = pbe.id;
            this.pbe = pbe;            
            this.prd = prd; 
            this.lineNeedByDate =system.today();
            this.linePrice = (pbe.UnitPrice <> null)?pbe.UnitPrice:0;
            this.lineDiscountPercent = lineDiscountPercent;
            this.linecalcTotalPrice = linecalcTotalPrice;
            
            if(prd <> null ){
                if (prd.Minimum_Order_Quantity__c == null) this.lineQuantity = 1.00;
                else this.lineQuantity = prd.Minimum_Order_Quantity__c.setScale(2);
            }
            
            
            this.linecalcTotalPrice = (linePrice * lineQuantity);
        }
    }
    public class wOrderOnce{
        public @AuraEnabled string strShipTo;
        public @AuraEnabled Date needByDate;
        public @AuraEnabled string AccountId;
        
        public @AuraEnabled string ShipToId;
        public @AuraEnabled string poNumber;
        
        
        public @AuraEnabled String accountname;
        public @AuraEnabled string AccountAddress;
        public @AuraEnabled String shiptoname;
        public @AuraEnabled String oppname;
        public @AuraEnabled string ownername;
        public @AuraEnabled string recordtypename; 

        public @AuraEnabled opportunity oppObj;     

        public @AuraEnabled List<Opportunity> lstLatestOpp;
        
        
        public @AuraEnabled List<wSearchAccount> AccountOptions;        
        public @AuraEnabled List<wSearchAccount> ShipToOptions;
        public @AuraEnabled string message;
        public @AuraEnabled List<wLineItem> lstShipLine{get;set;} 
        public @AuraEnabled List<wLineItem> lstAvaiLine{get;set;}  
        public wOrderOnce(string shipto, Date needdate, string aid, List<wSearchAccount> lst, string m, List<wLineItem> lstShipLine, List<wLineItem> lstAvaiLine){
            oppObj = new opportunity();
            strShipTo = shipto;
            needByDate = needdate;
            AccountId =aid;
            AccountOptions = lst;
            message = m;
            this.lstShipLine = lstShipLine;
            this.lstAvaiLine = lstAvaiLine;
        }
    }
    
    
        
    @AuraEnabled
    public static wOrderOnce Intialization(){
        User cuser = [select Id,Name,Account.Name ,Account.shippingStreet,Account.shippingCity,Account.shippingState,Account.shippingPostalCode,Account.shippingCountry from User where Id =: userinfo.getUserId()];
        List<wSearchAccount> lst = new List<wSearchAccount>();
        string address = cuser.Account.shippingStreet+' '+cuser.Account.shippingCity+' '+cuser.Account.shippingState+' '+cuser.Account.shippingPostalCode+' '+cuser.Account.shippingCountry;
        address = address.replaceAll('null','');
        if(address <> null && address.trim() <> '')
        lst.add(new wSearchAccount(cuser.AccountId,cuser.Account.Name,address));
        
        
        List<wLineItem> lstShipLine = new List<wLineItem>();
        List<wLineItem> lstAvaiLine = new List<wLineItem>();
        
        boolean multipleCurrencies = UserInfo.isMultiCurrencyOrganization();

        
        //2016 YETI Select Program
        String pricebookid = label.OrderOncePricebook;        
        List<priceBookEntry> AvailableProducts = getPricebookEntry(pricebookid,null,null,null);     
        set<Id> setProduct = new set<Id>();
        for(priceBookEntry d:AvailableProducts){
            setProduct.add(d.Product2Id);
        }
        map<Id,Product2> mapProduct = new map<Id,Product2>([select Id,Name,Availability_Date__c,ProductCode,Product_Category__c,Description,Expected_Ship_Date__c,Minimum_Order_Quantity__c from Product2 where Id IN: setProduct]);
        
        for(priceBookEntry d:AvailableProducts){
            lstAvaiLine.add(new wLineItem(false,d,mapProduct.get(d.Product2Id)));
        }
        
        
        wOrderOnce w = new wOrderOnce(cuser.Account.Name,system.today(),cuser.AccountId,lst,null,lstShipLine,lstAvaiLine); 
        w.OwnerName = cuser.Name;
        string recordTypeName = 'Inside Sales/Field Sales';       
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
       
        
        w.lstLatestOpp = [select id,name,Ship_To__r.Name,StageName,closeDate,Owner.Name from opportunity where recordtypeId =:RecordTypeId and pricebook2Id =: pricebookid order by createdDate desc limit 10];
        w = setShipToList(w);
        w.accountName = cuser.Account.Name;
        w.accountAddress=cuser.Account.shippingStreet+' '+cuser.Account.shippingCity+' '+cuser.Account.shippingState+' '+cuser.Account.shippingPostalCode+' '+cuser.Account.shippingCountry;
        w.accountAddress = (w.accountAddress <> null)?(w.accountAddress).replaceAll('null',''):'';
        return w;
    }
    @AuraEnabled
    public static List<wSearchAccount> getShipToAccount(string wObj){
        wOrderOnce obj = (wOrderOnce)JSON.deserialize(wObj,wOrderOnce.class);
        List<wSearchAccount> ShipToOptions = findAllShipTo(obj.AccountId);
        if(ShipToOptions.size() >0){
            obj.ShipToId = ShipToOptions[0].accountid;
        }
        return ShipToOptions;
    }
    
    @AuraEnabled
    public static wOrderOnce saveOpportunity(string wObj, string stage){
        wOrderOnce obj = (wOrderOnce)JSON.deserialize(wObj,wOrderOnce.class);
        
        map<string,Account> mapAccount = new map<string,Account>();
        for(Account Acc : [select Id,Name from Account where Id =: obj.AccountId]){
            mapAccount.put(Acc.Id,Acc);
        }
        
        //Opportunity
        Opportunity opp = obj.oppObj;
        opp.AccountId = (mapAccount.containsKey(obj.AccountId))?mapAccount.get(obj.AccountId).Id:obj.AccountId;
        
        opp.stageName = stage;
        if(obj.shiptoname <> null){
            opp.Ship_To__c = obj.shiptoname;
        }else{
            opp.Ship_To__c = opp.AccountId; 
        }
        //opp.Sold_To_Address__c = (obj.shiptoname <> null)?[select Id];
        
        insert opp;
        
        //Opportunity line item
        List<OpportunityLineItem> lstOppLineItem = new List<OpportunityLineItem> ();
        for(wLineItem w : obj.lstShipLine){
            OpportunityLineItem oppline = new OpportunityLineItem();
            
            oppline.opportunityId = opp.Id;         
            oppline.Need_By_Date__c = w.lineNeedByDate;            
            oppline.UnitPrice = w.linePrice;
            oppline.Quantity = w.lineQuantity;
            oppline.Discount_Percent__c = string.valueOf(w.lineDiscountPercent);
            oppline.calcTotalPrice__c = w.linecalcTotalPrice;
            oppline.PriceBookEntry = w.pbe;
            oppline.PriceBookEntryId = w.pbeid;
            
            lstOppLineItem.add(oppline);
        }
        
        insert lstOppLineItem;
        
        Id caseRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        User cUser = [select Id,AccountId,ContactId from User where Id=: userinfo.getUserId()];
        Opportunity OppObj = [select Id,Name,CurrencyIsoCode from Opportunity where id =: opp.Id];
        
        //Case Notification
        Case c = new Case();
        c.Subject = OppObj.Name;
        c.Priority = 'Normal';
        c.Status = 'Trading Post Submitted';
        c.Origin = 'Trading Post';
        c.Opportunity__c = OppObj.id;
        c.AccountId = cuser.AccountId;
        c.contactId = cUser.ContactId;
        c.RecordTypeId = caseRT;
        c.Description = 'Trading Post Submitted';
        c.Reason = 'Other';
        c.Type = 'Dealer';   
        c.CurrencyIsoCode = OppObj.CurrencyIsoCode;  
        insert c;
        
       
        
        return Intialization();
    }
     
    @AuraEnabled
    public static wOrderOnce getNewOpportunity(string wObj){
        wOrderOnce obj = (wOrderOnce)JSON.deserialize(wObj,wOrderOnce.class);

        
        string recordTypeName = 'Inside Sales/Field Sales';
        Opportunity opp = new Opportunity();
        
        map<string,string> mapAccount = new map<string,string>();
        for(Account Acc : [select Id,Name from Account where Id =: obj.AccountId or Id =: obj.ShipToId]){
            mapAccount.put(Acc.Id,Acc.Name);
        }
        
        opp.OwnerId = userinfo.getUserId();
        opp.Name = (mapAccount.containsKey(obj.AccountId))?mapAccount.get(obj.AccountId)+' - '+System.now().format():''+System.now().format();
        opp.CloseDate= system.today();
        opp.StageName= 'Trading Post Submitted';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        
        obj.RecordTypeName = recordTypeName;
        opp.PO_Number__c = obj.poNumber;
        opp.Need_By_Date__c = obj.needByDate;
        opp.CloseDate = system.today();
        User cUser = [select id,name,ContactId,Contact.Name from user where id =: userinfo.getUserId()];
        obj.ownerName = cUser.Name;
        
        if(obj.AccountId <> null){
            Account Acc = [select Id,Name from Account where Id =: obj.AccountId];
            obj.accountName = Acc.Name;
            opp.AccountId = Acc.Id;          
        }
        if(obj.AccountId <> null){
            Account Acc = [select Id,Name from Account where Id =: obj.ShipToId];
            opp.Ship_To__c = Acc.Id;
            obj.shiptoname = Acc.Id;          
        }        
        obj.oppObj = opp;
        //obj.ShipToOptions = getShipToAccount(obj.AccountId);
        return obj;
    }
    
    @AuraEnabled
    public static wOrderOnce getFilteredProducts(string wObj, string searchText, string productCategory){
        wOrderOnce obj = (wOrderOnce)JSON.deserialize(wObj,wOrderOnce.class);
        
        set<Id> setSelectedItems = new set<Id>();
        
        for(wLineItem s : obj.lstShipLine){
            setSelectedItems.add(s.pbeid);
        }
        
        //2016 YETI Select Program
        String pricebookid = label.OrderOncePricebook;        
        List<priceBookEntry> AvailableProducts = getPricebookEntry(pricebookid,searchText,productCategory,null);        
        set<Id> setProduct = new set<Id>();
        for(priceBookEntry d:AvailableProducts){
            setProduct.add(d.Product2Id);
        }
        map<Id,Product2> mapProduct = new map<Id,Product2>([select Id,Name,Availability_Date__c,ProductCode,Product_Category__c,Description,Expected_Ship_Date__c,Minimum_Order_Quantity__c from Product2 where Id IN: setProduct]);
        List<wLineItem> lstAvaiLine = new List<wLineItem>();
        for(priceBookEntry d:AvailableProducts){
            boolean flag = false;
            if(setSelectedItems.contains(d.id))flag = true;
            lstAvaiLine.add(new wLineItem(flag, d,mapProduct.get(d.Product2Id)));
        }
        obj.lstAvaiLine = lstAvaiLine;
        return obj;
    }
    
    
    @AuraEnabled
    public static wOrderOnce saveOrderOnce(string wObj){
        wOrderOnce obj = (wOrderOnce)JSON.deserialize(wObj,wOrderOnce.class);
        map<Id,wLineItem> mapSelectedItems = new map<Id,wLineItem>();
        List<wLineItem> lstShipLine = new List<wLineItem>();
        
        for(wLineItem w : obj.lstShipLine){
            mapSelectedItems.put(w.pbeid,w);
        }
        system.debug('AU:'+lstShipLine);
        for(wLineItem w : obj.lstAvaiLine){
            if(mapSelectedItems.containsKey(w.pbeid) && !w.ischeck){
                mapSelectedItems.put(w.pbeid,null);
            }
            if(!mapSelectedItems.containsKey(w.pbeid) && w.ischeck){
                mapSelectedItems.put(w.pbeid,w);
            }
        }
        for(Id pid : mapSelectedItems.keyset()){
            if(mapSelectedItems.get(pid) <> null)lstShipLine.add(mapSelectedItems.get(pid));
        }
        obj.lstShipLine = saveOrderOnce(lstShipLine);
        return obj;
    }
    
    @AuraEnabled
    public static wOrderOnce removeShipToItem(string wObj, string pbeid){
        wOrderOnce obj = (wOrderOnce)JSON.deserialize(wObj,wOrderOnce.class);
        List<wLineItem> lstShipLine = new List<wLineItem>();
        system.debug('AU:'+lstShipLine);
        for(wLineItem w : obj.lstAvaiLine){
            if(w.pbeid == pbeid){
                w.ischeck = false;
            }
        }
        for(wLineItem w : obj.lstShipLine){
            if(w.pbeid <> pbeid){
                lstShipLine.add(w);
            }
        }
        obj.lstShipLine = lstShipLine;
        return obj;
    }
    
    
    public static List<wLineItem> saveOrderOnce(List<wLineItem> lstShipLine){
        for(wLineItem w : lstShipLine){
            decimal total = 0;
            if(w.linePrice <> null && w.lineQuantity <> null){
                total = w.linePrice * w.lineQuantity;
            }
            if(w.lineDiscountPercent <> null){
                total = total - (total * (w.lineDiscountPercent/100.0));
            }
            w.linecalcTotalPrice = total;
        }
        return lstShipLine;
    }
    
    @AuraEnabled
    public static wOrderOnce searchOrderOnce(string wObj){
        wOrderOnce obj = (wOrderOnce)JSON.deserialize(wObj,wOrderOnce.class);
        List<wSearchAccount> lstWOrderOnce = new List<wSearchAccount>();
        
        obj.AccountOptions = new List<wSearchAccount>();
        List<Account> lstAccount = database.Query('select Id,Name,shippingStreet,shippingCity,shippingState,shippingPostalCode,shippingCountry from Account where Name like \'%'+obj.strShipTo+'%\' limit 20');
        for(Account a : lstAccount){
            string address = a.shippingStreet+' '+a.shippingCity+' '+a.shippingState+' '+a.shippingPostalCode+' '+a.shippingCountry;
            address = address.replaceAll('null','');
            if(address <> null && address.trim() <> '')
            lstWOrderOnce.add(new wSearchAccount(a.id,a.name,address));
        }
        if(lstWOrderOnce.size() >0){
            obj.AccountOptions = lstWOrderOnce;
            obj.AccountId = lstAccount[0].id;
            obj.message = null;
        }else{            
            obj.message = 'There is no any acocunt related to "'+obj.strShipTo+'"';
        }    
        obj = setShipToList(obj);
        return obj;
    }
    
    public static wOrderOnce setShipToList(wOrderOnce obj){
        if(obj.AccountId == null)return obj;
        
        obj.ShipToOptions = findAllShipTo(obj.AccountId);
        if(obj.ShipToOptions.size() >0){
            obj.ShipToId = obj.ShipToOptions[0].accountid;
            obj.message = null;
        }else{
            obj.message = 'There is no any shipto related to "'+obj.strShipTo+'"';
        }
        return obj;
    }
    
    public static List<wSearchAccount> findAllShipTo(string AccountId){
        List<Account> lstAccount = [select Id,Name,shippingStreet,shippingCity,shippingState,shippingPostalCode,shippingCountry from Account where Id=: AccountId limit 1];
        lstAccount.addAll([select Id,Name,shippingStreet,shippingCity,shippingState,shippingPostalCode,shippingCountry from Account where parentId=:AccountId  limit 99]);
        List<wSearchAccount> lstWOrderOnce = new List<wSearchAccount>();
        for(Account a : lstAccount){
            string address = a.shippingStreet+' '+a.shippingCity+' '+a.shippingState+' '+a.shippingPostalCode+' '+a.shippingCountry;
            address = address.replaceAll('null','');
            if(address <> null && address.trim() <> '')
            lstWOrderOnce.add(new wSearchAccount(a.id,a.name,address));
        }
        return lstWOrderOnce;
    }
    
    
    
    public static List<PricebookEntry> getPricebookEntry(String pricebookid,string searchString, string productCategory, Set<Id> selectedEntries){
        
        String qString = 'select Id,Product2Id, Pricebook2Id, IsActive, Product2.Availability_Date__c, Product2.Minimum_Order_Quantity__c, Product2.Name, '+
        'Product2.ProductCode, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice, Product2.Product_Category__c, Product2.Expected_Ship_Date__c '+
        'from PricebookEntry where IsActive=true and Pricebook2Id = \'' + pricebookid + '\'';

        
        if(searchString <> '' && searchString <> null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\' or Product2.ProductCode like \'%' + searchString + '%\')';
        }
        if(productCategory <> '' && productCategory <> null && productCategory <> 'All'){
            qString+= ' and Product2.Product_Category__c = \'' + productCategory + '\'';
        }
        
        if(selectedEntries <> null && selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }
      //  qString+= ' limit 20';       
        return database.query(qString);
    }
     
    
}
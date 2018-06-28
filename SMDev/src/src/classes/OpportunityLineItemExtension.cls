public with sharing class OpportunityLineItemExtension {

   
   
   
   public class wOpportunity{
        @AuraEnabled Opportunity OppObj{get;set;}    
        @AuraEnabled public List<wOpportunityLine> lstSelLine{get;set;} 
        @AuraEnabled public List<wOpportunityLine> lstAvaiLine{get;set;}    
        public wOpportunity(Opportunity OppObj, List<wOpportunityLine> lstSelLine, List<wOpportunityLine> lstAvaiLine){
            this.OppObj = OppObj;
            this.lstSelLine = lstSelLine;
            this.lstAvaiLine = lstAvaiLine;
        }
    }
    public class wNewOpportunity{
        @AuraEnabled Opportunity OppObj{get;set;} 
        @AuraEnabled String OwnerName{get;set;} 
        @AuraEnabled String AccountName{get;set;}
        @AuraEnabled String ShipTo{get;set;}
        @AuraEnabled String RecordTypeName{get;set;}        
          
        public wNewOpportunity(Opportunity OppObj, String OwnerName, String RecordTypeName, string  AccountName){
            this.OppObj = OppObj;
            this.OwnerName = OwnerName;
            this.RecordTypeName = RecordTypeName;
            this.AccountName = AccountName;
            this.ShipTo = AccountName;
            
        }
    }
    
    public class wOpportunityLine{
       public @AuraEnabled Id PriceBookEntryId{get;set;}
        @AuraEnabled PriceBookEntry newPBE{get;set;}
        @AuraEnabled OpportunityLineItem line{get;set;}
        @AuraEnabled Product2 productObj{get;set;}
        @AuraEnabled Decimal selectedQty {get; set;}
        @AuraEnabled Date dateAvail{get; set;}
        
        @AuraEnabled Date lineNeedByDate{get;set;}
        @AuraEnabled decimal linePrice{get;set;}
        @AuraEnabled decimal lineQuantity{get;set;}
        @AuraEnabled string lineDiscountPercent{get;set;}
        @AuraEnabled decimal linecalcTotalPrice{get;set;}
        
        
        public wOpportunityLine(Id PriceBookEntryId, PriceBookEntry newPBE, OpportunityLineItem line, Product2 productObj){
            this.PriceBookEntryId = PriceBookEntryId;
            this.line = line;
            this.productObj = productObj;
            
            this.lineNeedByDate = line.Need_By_Date__c;
            this.linePrice = line.UnitPrice;
            this.lineQuantity = line.Quantity;
            this.lineDiscountPercent = line.Discount_Percent__c;
            this.linecalcTotalPrice = line.calcTotalPrice__c;
            
            if(newPBE <> null ){
                if (newPBE.Product2.Minimum_Order_Quantity__c == null) {
                    this.selectedQty = 1.00;
                }
                else{
                    this.selectedQty = newPBE.Product2.Minimum_Order_Quantity__c.setScale(2);
                }
                this.dateAvail = newPBE.Product2.Availability_Date__c;
            }
            
            
            
        }
    }

    @AuraEnabled
    public static List<Opportunity> getAllOpportunity(){ 
        String pricebookid = '01s0S0000000TWQ';
        return [select Id,name,Account.Name,StageName,Amount from Opportunity where pricebook2Id =: pricebookid or pricebook2Id = null];
    }
     @AuraEnabled
    public static wNewOpportunity getNewOpportunity(){ 
        string recordTypeName = 'Inside Sales/Field Sales';
        User cuser = [select Name,Account.Name from User where Id =: userinfo.getUserId()];
        string OwnerName = cuser.Name;
        Opportunity oppObj = new Opportunity();
        oppObj.OwnerId = userinfo.getUserId();
        oppObj.CloseDate= system.today();
        oppObj.StageName= 'New';
        oppObj.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        wNewOpportunity obj = new wNewOpportunity(oppObj,OwnerName,recordTypeName,cuser.Account.Name);
        return obj;
    }
    @AuraEnabled
    public static string saveOpportunity(string wOppObj){ 
        try{
            wNewOpportunity obj = (wNewOpportunity)JSON.deserialize(wOppObj,wNewOpportunity.class); 
            string defaultName;
            if(obj.AccountName <> null && obj.AccountName <> ''){
                List<Account> lstAcc = [select Id,Name from Account where Name =: obj.AccountName limit 1];
                if(lstAcc.size()>0){obj.OppObj.AccountId = lstAcc[0].id;defaultName = lstAcc[0].Name+' ' +system.today();}
                
            }
            if(obj.shipto <> null && obj.shipto <> ''){
                List<Account> lstAcc = [select Id,Name from Account where Name =: obj.shipto limit 1];
                if(lstAcc.size()>0){obj.OppObj.Ship_To__c = lstAcc[0].id;defaultName = lstAcc[0].Name+' ' +system.today();}
            }
            if(obj.OppObj.Name == null || obj.OppObj.Name == '')obj.OppObj.Name =defaultName ;
            insert obj.OppObj;
            return 'successfully inserted, opportunity Id is: '+obj.OppObj.id;
        }catch(Exception e){return e.getMessage()+'';}
    }
    
    @AuraEnabled
    public static void saveProducts(string wOppObj,string btnname){ 
        wOpportunity obj = (wOpportunity)JSON.deserialize(wOppObj,wOpportunity.class); 
        List<OpportunityLineItem> lstLine = new List<OpportunityLineItem>();
        
        map<Id,OpportunityLineItem> mapExistingOpporunity = new map<Id,OpportunityLineItem>([select Id from OpportunityLineItem where OpportunityId =: obj.OppObj.Id]);
        set<Id> setNewLine = new set<Id>();
        for(wOpportunityLine w : obj.lstSelLine){
            
            OpportunityLineItem oppline = w.line;
            if(oppline <> null && oppline.id <> null)setNewLine.add(oppline.id);
            oppline.Need_By_Date__c = w.lineNeedByDate;
            
            oppline.UnitPrice = w.linePrice;
            system.debug('oppline.UnitPrice:'+oppline.UnitPrice);
            oppline.Quantity = w.lineQuantity;
            oppline.Discount_Percent__c = w.lineDiscountPercent;
            //oppline.calcTotalPrice__c = w.linecalcTotalPrice;
            
            if (oppline.Discount_Percent__c == null && oppline.Discount_Percent__c == '' && oppline.Discount_Percent__c.isNumeric()) {  
                oppline.calcTotalPrice__c = (oppline.UnitPrice * oppline.Quantity * (1-Decimal.valueOf(oppline.Discount_Percent__c)/100));
            }
            else {
                oppline.calcTotalPrice__c = (oppline.UnitPrice * oppline.Quantity);
            }
            system.debug('#:save:'+oppline.PricebookEntryId+'--'+obj.OppObj.Pricebook2Id);
            lstLine.add(oppline);
        }       
        upsert lstLine;   
        
        if(btnname == 'Submit'){
            Opportunity opp = [select Id,StageName from Opportunity where id=: obj.OppObj.Id];
            opp.StageName = 'Submit';
            update opp;
        }
        
        List<OpportunityLineItem> lstDeleteLine = new List<OpportunityLineItem>();
        for(Id lid : mapExistingOpporunity.keyset()){
            if(!setNewLine.contains(lid))
            lstDeleteLine.add(mapExistingOpporunity.get(lid));
        }
        delete lstDeleteLine;
    }
    
    @AuraEnabled
    public static wOpportunity  getRemoveOpportunityLineItems(string wOppObj, string ProductEntryId){ 
        wOpportunity obj = (wOpportunity)JSON.deserialize(wOppObj,wOpportunity.class); 
        
        List<wOpportunityLine> lstnewSelLine = new List<wOpportunityLine>();
        
        for(wOpportunityLine w : obj.lstSelLine ){
            if(!(w.PriceBookEntryId).equals(ProductEntryId)){
                lstnewSelLine.add(w);
            }else{
                obj.lstAvaiLine.add(w);
            }
        }
        obj.lstSelLine.clear();
        obj.lstSelLine= lstnewSelLine;
        return obj;
    }
    @AuraEnabled
    public static wOpportunity  getRefreshOpportunityLineItems(string wOppObj, string ProductEntryId){ 
        wOpportunity obj = (wOpportunity)JSON.deserialize(wOppObj,wOpportunity.class); 
        
        List<wOpportunityLine> lstnewSelLine = new List<wOpportunityLine>();
        List<wOpportunityLine> lstnewAvaiLine = new List<wOpportunityLine>();
        
        for(wOpportunityLine w : obj.lstAvaiLine){
            if(!(w.PriceBookEntryId).equals(ProductEntryId)){
                lstnewAvaiLine.add(w);
            }else{
                obj.lstSelLine.add(w);
            }
        }
        
        //obj.lstSelLine = lstnewSelLine;
        obj.lstAvaiLine = lstnewAvaiLine;
        return obj;
    }
    
    @AuraEnabled
    public static wOpportunity  getFilteredProducts(string wOppObj, string searchText, string productCategory){ 
        wOpportunity obj = (wOpportunity)JSON.deserialize(wOppObj,wOpportunity.class); 
        
        //2016 YETI Select Program
        String pricebookid = '01s0S0000000TWQ';
        List<wOpportunityLine> lstnewAvaiLine = new List<wOpportunityLine>();
        Set<Id> selectedEntries = new Set<Id>();
        set<Id> setProduct = new set<Id>();
        for(wOpportunityLine d: obj.lstSelLine){
            selectedEntries.add(d.PricebookEntryId);
            
        }
        
        List<priceBookEntry> AvailableProducts = getPricebookEntry(obj.OppObj.id,pricebookid,searchText,productCategory,selectedEntries);
        
        for(priceBookEntry d:AvailableProducts){
            setProduct.add(d.Product2Id);
        }
        map<Id,Product2> mapProduct = new map<Id,Product2>([select Id,Name,ProductCode,Product_Category__c,Description,Expected_Ship_Date__c,Minimum_Order_Quantity__c from Product2 where Id IN: setProduct]);
        
        
        for(priceBookEntry d:AvailableProducts){
            decimal selectedQty = (d.Product2.Minimum_Order_Quantity__c == null)?1.00:d.Product2.Minimum_Order_Quantity__c.setScale(2);
            date dateAvail = (d.Product2.Availability_Date__c <> null)?d.Product2.Availability_Date__c:system.today();
            opportunityLineItem l = new opportunityLineItem();
            l.opportunityId =obj.OppObj.id;
            l.Need_By_Date__c =  dateAvail;
            l.PriceBookEntry = d;
            lstnewAvaiLine.add(new wOpportunityLine(d.id,d,l,mapProduct.get(d.Product2Id)));
        }   
        
        obj.lstAvaiLine = lstNewAvaiLine;
        return obj;
    }
    
    public static List<PricebookEntry> getPricebookEntry(string OppId,String pricebookid,string searchString, string productCategory, Set<Id> selectedEntries){
        
        Opportunity opp;
        boolean multipleCurrencies = UserInfo.isMultiCurrencyOrganization();
        if(multipleCurrencies)
            opp = database.query('select Id, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + OppId + '\' limit 1');
        else
            opp = [select Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :OppId limit 1];
        
        
        String qString = 'select Id,Product2Id, Pricebook2Id, IsActive, Product2.Availability_Date__c, Product2.Minimum_Order_Quantity__c, Product2.Name, '+
        'Product2.ProductCode, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice, Product2.Product_Category__c, Product2.Expected_Ship_Date__c '+
        'from PricebookEntry where IsActive=true and Pricebook2Id = \'' + pricebookid + '\'';
       
        if(multipleCurrencies)
            qstring += ' and CurrencyIsoCode = \'' + opp.get('currencyIsoCode') + '\'';
        
        if(searchString <> '' && searchString <> null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\' or Product2.ProductCode like \'%' + searchString + '%\')';
        }
        if(productCategory <> '' && productCategory <> null && productCategory <> 'All'){
            qString+= ' and Product2.Product_Category__c = \'' + productCategory + '\'';
        }
        
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }
        qString+= ' limit 10';       
        return database.query(qString);
    }
    @AuraEnabled
    public static wOpportunity getOpportunityLineItems(string OppId) {
   
        wOpportunity wOppObj;
        List<wOpportunityLine> lstSelLine = new List<wOpportunityLine>();
        List<wOpportunityLine> lstAvaiLine = new List<wOpportunityLine>();
        
        boolean multipleCurrencies = UserInfo.isMultiCurrencyOrganization();

        Opportunity opp;
        if(multipleCurrencies)
            opp = database.query('select Id, Name,Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + OppId + '\' limit 1');
        else
            opp = [select Id,Name, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :OppId limit 1];
        
        
        List<opportunityLineItem> shoppingCart = [select Id, Quantity, Discount_Percent__c, Need_By_Date__c, UnitPrice, calcTotalPrice__c, Description, PriceBookEntryId, 
        PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id, 
        PriceBookEntry.Product2.ProductCode, PriceBookEntry.Product2.Description, PriceBookEntry.UnitPrice, PriceBookEntry.Product2.Product_Category__c, 
        PriceBookEntry.Product2.Expected_Ship_Date__c from opportunityLineItem where OpportunityId=:OppId order by sortorder, pricebookentry.product2.name];
       
        
        //2016 YETI Select Program
        String pricebookid = '01s0S0000000TWQ';
        
        Set<Id> selectedEntries = new Set<Id>();
        set<Id> setProduct = new set<Id>();
        for(opportunityLineItem d:shoppingCart){
            selectedEntries.add(d.PricebookEntryId);
            setProduct.add(d.PriceBookEntry.Product2Id);
        }
        
        List<priceBookEntry> AvailableProducts = getPricebookEntry(opp.id,pricebookid,null,null,selectedEntries);
        
        for(priceBookEntry d:AvailableProducts){
            setProduct.add(d.Product2Id);
        }
        map<Id,Product2> mapProduct = new map<Id,Product2>([select Id,Name,ProductCode,Product_Category__c,Description,Expected_Ship_Date__c,Minimum_Order_Quantity__c from Product2 where Id IN: setProduct]);
        
        
        for(opportunityLineItem d:shoppingCart){
            lstSelLine.add(new wOpportunityLine(d.PricebookEntryId, null,d,mapProduct.get(d.PriceBookEntry.Product2Id)));
        }
        
        for(priceBookEntry d:AvailableProducts){
            decimal selectedQty = (d.Product2.Minimum_Order_Quantity__c == null)?1.00:d.Product2.Minimum_Order_Quantity__c.setScale(2);
            date dateAvail = (d.Product2.Availability_Date__c <> null)?d.Product2.Availability_Date__c:system.today();
            opportunityLineItem l = new opportunityLineItem();
            l.opportunityId = oppid;
            l.Need_By_Date__c =  dateAvail;
            l.UnitPrice =  d.UnitPrice;
            l.Quantity = selectedQty;l.PriceBookEntry = d;
            l.PriceBookEntry = d;
            l.PriceBookEntryId = d.id;
            lstAvaiLine.add(new wOpportunityLine(d.id,d,l,mapProduct.get(d.Product2Id)));
        }   
        
        wOppObj = new wOpportunity(opp, lstSelLine, lstAvaiLine);

        
        return wOppObj;

    }     
    
}
public with sharing class OpportunityProductEntryExtension {

    public Opportunity theOpp {get;set;}
    public opportunityLineItem[] shoppingCart {get;set;}
    public Pricebook2 theBook {get;set;}    
    public priceBookEntry[] AvailableProducts {get;set;}
    public List<PBEWrap> wrappers {get; set;}    
    
    public String searchString {get;set;}    
    public String productCategory {get;set;}
    public String toSelect {get; set;}
    public String toUnselect {get; set;} 
    public String toUnselectColor {get; set;}   
    public Boolean toggleSort = false;
    
    
    public String toCalc {get; set;}
    public Decimal grandTotal;
    
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get;set;}
        
    private Map<Id,Decimal> pbeToSelectedQty = new Map<Id,Decimal>();    
    private Boolean forcePricebookSelection = false;    
    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    public OpportunityProductEntryExtension(ApexPages.StandardController controller) {

        //Setup defaults
        productCategory = 'All';
        multipleCurrencies = UserInfo.isMultiCurrencyOrganization();

        // Get information about the Opportunity being worked on
        if(multipleCurrencies)
            theOpp = database.query('select Id, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1');
        else
            theOpp = [select Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1];
        
        // If products were previously selected need to put them in the "selected products" section to start with
        shoppingCart = [select Id, PricebookEntry.Color__c ,color__c,Color_Type__c,Color_Price__c,Quantity, Discount_Percent__c, Need_By_Date__c, UnitPrice, calcTotalPrice__c, Description, PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id, PriceBookEntry.Product2.ProductCode, PriceBookEntry.Product2.Description, PriceBookEntry.UnitPrice, PriceBookEntry.Product2.Product_Category__c, PriceBookEntry.Product2.Expected_Ship_Date__c from opportunityLineItem where OpportunityId=:theOpp.Id order by sortorder, pricebookentry.product2.name];

        // Check if Opp has a pricebook associated yet
        if(theOpp.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = theOpp.Pricebook2;
        }
        
        if(!forcePricebookSelection)
            updateAvailableList();
    }
    
    public void oncolorChangeAction(){
        string productId = apexpages.currentpage().getparameters().get('productId');
        string colorId = apexpages.currentpage().getparameters().get('colorId');
        string color = apexpages.currentpage().getparameters().get('color');
        string colorVal = apexpages.currentpage().getparameters().get('colorVal');
        
        for(OpportunityLineItem oli : shoppingCart){
            if((String)oli.PricebookEntryId==productId && oli.color__c==color){
                if(colorVal == 'true'){
                    if(colorId == '1'){oli.Color_Type__c = 'One Color';  oli.Color_Price__c = 1000;}
                    if(colorId == '2'){oli.Color_Type__c = 'Two Color';  oli.Color_Price__c = 1500;}
                    if(colorId == '3'){oli.Color_Type__c = 'Three Color';    oli.Color_Price__c = 2000;}
                }
                else{
                    oli.Color_Type__c = null;
                    oli.Color_Price__c = 0;
                }
                
                if (oli.Discount_Percent__c <> null) {
                    if (oli.Discount_Percent__c.isNumeric()) {  
                        oli.calcTotalPrice__c = (oli.UnitPrice * oli.Quantity * (1-Decimal.valueOf(oli.Discount_Percent__c)/100));
                    }
                    else {
                    oli.calcTotalPrice__c = (oli.UnitPrice * oli.Quantity);
                    }
                }
                else {
                    oli.calcTotalPrice__c = (oli.UnitPrice * oli.Quantity);
                }
                oli.calcTotalPrice__c += oli.Color_Price__c;
            }
        }
    }
    
   
    
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    public void updateAvailableList() {
    
        // toggle column sort if desired (product isn't added or removed from shopping cart)
        if (toggleSort == true) {
            if (sortDir == 'asc') {
                sortDir = 'desc';
            }
            else {
                sortDir = 'asc';
            }
        }
        //reset togglesort on for columns
        toggleSort = true;
        
        // We dynamically build a query string and exclude items already in the shopping cart
        String qString = 'select Id, color__c,Pricebook2Id, IsActive, Product2.Availability_Date__c, Product2.Minimum_Order_Quantity__c, Product2.Name, Product2.ProductCode, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice, Product2.Product_Category__c, Product2.Expected_Ship_Date__c from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        if(multipleCurrencies)
            qstring += ' and CurrencyIsoCode = \'' + theOpp.get('currencyIsoCode') + '\'';
        
        // note that we are looking for the search string entered by the user in the name OR description
        // modify this to search other fields if desired
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\' or Product2.ProductCode like \'%' + searchString + '%\')';
        }
        
        // add product category filter to where clause
        if(searchString!=null && productCategory!=null && productCategory!='All'){
            qString+= ' and Product2.Product_Category__c = \'' + productCategory + '\'';
        }
        
        Set<Id> selectedEntries = new Set<Id>();
        map<Id,set<string>> mapSelectedEntryColor = new map<Id,set<string>>();
        for(opportunityLineItem d:shoppingCart){
            selectedEntries.add(d.PricebookEntryId);
            set<string> setcolor = new set<string>();
            setcolor.add(d.color__c);
            if(mapSelectedEntryColor.containsKey(d.PricebookEntryId)){
                setcolor.addAll(mapSelectedEntryColor.get(d.PricebookEntryId));
            }
            mapSelectedEntryColor.put(d.PricebookEntryId,setcolor);
            
        }
        
        
        
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            //qString+= extraFilter;
        }
        
       //set sort field and direction
        qstring+= ' order by ' + sortField + ' ' + sortDir;
        qString+= ' limit 101';
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);

        // We only display up to 500 results... if there are more than we let the user know (see vf page)
        if(AvailableProducts.size()==501){
            AvailableProducts.remove(500);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
        
        //keep inputed quanties during search
        if (wrappers <> null) {
            for(PBEWrap w : wrappers){
                if (w.selectedQty <> 1) {
                    pbeToSelectedQty.put(w.pbe.Id,w.selectedQty);
                }               
            }
        }
                      
        // clear wrapper list
        wrappers = new List<PBEWrap>();
        
        system.debug('mapSelectedEntryColor:'+mapSelectedEntryColor);
        
        map<string,string> mapColors = getListColor();
        system.debug('mapColors:'+mapColors);
        // add queried pricebookentries to wrapper list (to enter quantity and maintain during search/sort)
        for (PriceBookEntry availProd : AvailableProducts) {
            
            //01u1D000002R4SxQAK
            List<SelectOption> lstColor = new list<SelectOption>();
            
            for(string cval : mapColors.keyset()){
                if(!mapSelectedEntryColor.containsKey(availProd.id) || !(mapSelectedEntryColor.get(availProd.id).contains(cval))){
                    lstColor.add(new SelectOption(mapColors.get(cval),cval));
                }
            }
            
            if(lstColor.size()>0){          
                PBEWrap newEntry = new PBEWrap(availProd,lstColor);
                if(pbeToSelectedQty.containsKey(newEntry.pbe.Id)) {
                    newEntry.selectedQty = pbeToSelectedQty.get(newEntry.pbe.Id);
                }
                else if (newEntry.pbe.Product2.Minimum_Order_Quantity__c == null) {
                    newEntry.pbe.Product2.Minimum_Order_Quantity__c = 1;
                }
                newEntry.pbe.Color__c = lstColor[lstColor.size()-1].getValue();
                wrappers.add(newEntry);
            }
        }
    }
    public map<string,string> getListColor(){
            map<string,string> options = new map<string,string>();
            for( Schema.PicklistEntry f : (OpportunityLineItem.Color__c.getDescribe()).getPicklistValues())
            {
                options.put(f.getValue(),f.getLabel());
            }       
            return options;
        }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    public void addToShoppingCart(){
    
        // This function runs when a user hits "select" button next to a product
        
        for(PBEWrap w : wrappers){
            //Determine the default needByDate - CS 10/15/2015
            if (w.dateAvail == null) w.dateAvail = date.today();
            if((String)w.pbe.Id==toSelect){
                shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, color__c=w.pbe.color__c,Need_By_Date__c=w.dateAvail, PriceBookEntry=w.pbe, PriceBookEntryId=w.pbe.Id, UnitPrice=w.pbe.UnitPrice, Quantity=w.selectedQty, calcTotalPrice__c=w.pbe.UnitPrice*w.selectedQty));
                toggleSort = false;                
            }
            /*
            if (selectedQty <> 1) {
                pbeToSelectedQty.put(w.pbe.Id,w.selectedQty);
            }
            */
        }
        
        updateAvailableList();  
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

    public PageReference removeFromShoppingCart(){
    
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
    
        Integer count = 0;
    
        for(opportunityLineItem d : shoppingCart){
            if((String)d.PriceBookEntryId==toUnselect && d.color__c == toUnselectColor){
            
                if(d.Id!=null)
                    forDeletion.add(d);
            
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
        
        toggleSort = false;
        updateAvailableList();
        
        return null;
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    public PageReference onSave(){
    
        // If previously selected products are now removed, we need to delete them
        if(forDeletion.size()>0)
            delete(forDeletion);
    
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
            if(shoppingCart.size()>0){
                /*for(opportunityLineItem d : shoppingCart){
                    decimal additionalAmount = 0;
                    if(d.Color_Price__c <> null && d.Color_Price__c <> 0){
                        additionalAmount = d.Color_Price__c/d.quantity;
                    }
                    d.UnitPrice= d.UnitPrice+additionalAmount ;
                }*/
                upsert(shoppingCart);
                
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
           
        // After save return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    public PageReference onCancel(){
 
        // If user hits cancel we commit no changes and return them to the Opportunity   
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // this is the 'action' method on the page
    public PageReference priceBookCheck(){
    
        // if the user needs to select a pricebook before we proceed we send them to standard pricebook selection screen
        if(forcePricebookSelection){        
            return changePricebook();
        }
        else{
        
            //if there is only one active pricebook we go with it and save the opp
            if(theOpp.pricebook2Id != theBook.Id){
                try{
                    theOpp.Pricebook2Id = theBook.Id;
                    update(theOpp);
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            
            return null;
        }
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           
    public String getChosenCurrency(){
    
        if(multipleCurrencies)
            return (String)theOpp.get('CurrencyIsoCode');
        else
            return '';
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    public PageReference changePricebook(){
    
        // This simply returns a PageReference to the standard Pricebook selection screen
        // Note that is uses retURL parameter to make sure the user is sent back after they choose
    
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);
        
        return ref;
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // calculate total price of a line item when quantity, unitprice or discount is updated
    public void calcTotalPrice(){
        
        for(OpportunityLineItem oli : shoppingCart){
            if((String)oli.PricebookEntryId==toCalc){
                if (oli.Discount_Percent__c <> null) {
                    if (oli.Discount_Percent__c.isNumeric()) {  
                        oli.calcTotalPrice__c = (oli.UnitPrice * oli.Quantity * (1-Decimal.valueOf(oli.Discount_Percent__c)/100));
                    }
                    else {
                    oli.calcTotalPrice__c = (oli.UnitPrice * oli.Quantity);
                    }
                }
                else {
                    oli.calcTotalPrice__c = (oli.UnitPrice * oli.Quantity);
                }
            }
        }
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // calculate grand total of all opp line items
    public Decimal getGrandTotal() {
            
        grandTotal = 0;
        
        for (OpportunityLineItem oli : shoppingCart) {
            if(oli.Color_Price__c == null)oli.Color_Price__c = 0;
            if (oli.Discount_Percent__c <> null) {
                if (oli.Discount_Percent__c.isNumeric()) {  
                    grandTotal = grandTotal + (oli.UnitPrice * oli.Quantity * (1-Decimal.valueOf(oli.Discount_Percent__c)/100)) + oli.Color_Price__c;
                }
                else {
                grandTotal = grandTotal + (oli.UnitPrice * oli.Quantity) + oli.Color_Price__c;
                }
            }
            else {
                grandTotal = grandTotal + (oli.UnitPrice * oli.Quantity) + oli.Color_Price__c;
            }
        }
        
        return grandTotal;
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // the options for Product Category picklist
    public List<SelectOption> getProductCategoryOptions() {
        List<SelectOption> options = new List<SelectOption>();   
        options.add(new SelectOption('All','All'));   
        options.add(new SelectOption('Accessories','Accessories'));
        options.add(new SelectOption('Custom Logo','Custom Logo'));
        options.add(new SelectOption('Gear','Gear'));
        options.add(new SelectOption('Hard colors','Hard colors'));
        options.add(new SelectOption('Parts','Parts'));
        options.add(new SelectOption('Promotional','Promotional'));
        options.add(new SelectOption('Raw Materials','Raw Materials'));
        options.add(new SelectOption('Seconds','Seconds'));
        options.add(new SelectOption('Soft colors','Soft colors'));
        options.add(new SelectOption('Other','Other'));
        
        return options;
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // the current sort direction. defaults to asc
    public String sortDir {
        // To set a Direction either in ascending order or descending order.
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;}
        set;
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // the current field to sort by. defaults to last name
    public String sortField {
        // To set a Field for sorting.
        get  { if (sortField == null) {sortField = 'Product2.Name'; } return sortField;  }
        set;
    } 
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    //wrapper class to be able to input a quantity
    public class PBEWrap
    {
       public PriceBookEntry pbe {get; set;}
       public List<SelectOption> colors {get; set;}
       public Decimal selectedQty {get; set;}
       public Date dateAvail{get; set;}
    
       public PBEWrap(PriceBookEntry newPBE, List<SelectOption> colors)
       {
          this.pbe=newPBE;
          this.colors = colors;
          
          if (newPBE.Product2.Minimum_Order_Quantity__c == null) {
            this.selectedQty = 1.00;
          }
          else {
            this.selectedQty = newPBE.Product2.Minimum_Order_Quantity__c.setScale(2);
          }
          this.dateAvail = newPBE.Product2.Availability_Date__c;
       }
       
    }
    
}
/// enosiX Inc. Generated Apex Model
/// Generated On: 8/1/2017 2:59:05 PM
/// SAP Host: From REST Service On: https://na3.salesforce.com
/// CID: From REST Service On: https://na3.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

public with sharing class SBO_YetiSalesOrderSync_Search extends ensx.EnosixFramework.SearchSBO 
{
    
    public SBO_YetiSalesOrderSync_Search() 
    {
        super('YetiSalesOrderSync', SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SC.class, SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SR.class);
    }
    
    public override Type getType() { return SBO_YetiSalesOrderSync_Search.class; }

    public YetiSalesOrderSync_SR execute()
    {
        return (YetiSalesOrderSync_SR)super.executeSearch();
    }

    public YetiSalesOrderSync_SC SearchContext 
    {
        get { return (YetiSalesOrderSync_SC)this.getSearchContext(); }
    }

    public class YetiSalesOrderSync_SC extends ensx.EnosixFramework.SearchContext 
    { 		
        public YetiSalesOrderSync_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => SBO_YetiSalesOrderSync_Search.SEARCHPARAMS.class		
                });		
        }

        public override Type getType() { return SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SC.class; }




        public SBO_YetiSalesOrderSync_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (SBO_YetiSalesOrderSync_Search.SEARCHPARAMS)this.getStruct(SBO_YetiSalesOrderSync_Search.SEARCHPARAMS.class);
            }
        }
        
        }

    public class YetiSalesOrderSync_SR extends ensx.EnosixFramework.SearchResult 
    {
        public YetiSalesOrderSync_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_YetiSalesOrderSync_Search.SEARCHRESULT.class } );
        }
        
        public ensx.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(SBO_YetiSalesOrderSync_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return SBO_YetiSalesOrderSync_Search.YetiSalesOrderSync_SR.class; }

    }

    public class SEARCHPARAMS extends ensx.EnosixFramework.ValueObject 
    {
        public override Type getType() { return SBO_YetiSalesOrderSync_Search.SEARCHPARAMS.class; }

        public Date FromCreateDate
        { 
            get { return this.getDate ('ERDAT_FR'); } 
            set { this.Set (value, 'ERDAT_FR'); }
        }

        public Date ToCreateDate
        { 
            get { return this.getDate ('ERDAT_TO'); } 
            set { this.Set (value, 'ERDAT_TO'); }
        }

        public String CustomerNumberFrom
        { 
            get { return this.getString ('KUNNR_FR'); } 
            set { this.Set (value, 'KUNNR_FR'); }
        }

        public String CustomerNumberTo
        { 
            get { return this.getString ('KUNNR_TO'); } 
            set { this.Set (value, 'KUNNR_TO'); }
        }

        public Date FromLastChangeDate
        { 
            get { return this.getDate ('AEDAT_FR'); } 
            set { this.Set (value, 'AEDAT_FR'); }
        }

        public Date ToLastChangeDate
        { 
            get { return this.getDate ('AEDAT_TO'); } 
            set { this.Set (value, 'AEDAT_TO'); }
        }

        public Time FromChangeTime
        { 
            get { return this.getTime ('AEZET_FR'); } 
            set { this.Set (value, 'AEZET_FR'); }
        }

        public Time ToChangeTime
        { 
            get { return this.getTime ('AEZET_TO'); } 
            set { this.Set (value, 'AEZET_TO'); }
        }

        public Integer MAX_ROWS
        { 
            get { return this.getInteger ('MAX_ROWS'); } 
            set { this.Set (value, 'MAX_ROWS'); }
        }

    }

    public class SEARCHRESULT extends ensx.EnosixFramework.ValueObject 
    {
        public override Type getType() { return SBO_YetiSalesOrderSync_Search.SEARCHRESULT.class; }

        public String ShipComplete
        { 
            get { return this.getString ('SHIP_COMPLETE'); } 
            set { this.Set (value, 'SHIP_COMPLETE'); }
        }

        public String BillTo
        { 
            get { return this.getString ('BILL_TO'); } 
            set { this.Set (value, 'BILL_TO'); }
        }

        public String BillToName1
        { 
            get { return this.getString ('BILL_TO_NAME1'); } 
            set { this.Set (value, 'BILL_TO_NAME1'); }
        }

        public String BillToName2
        { 
            get { return this.getString ('BILL_TO_NAME2'); } 
            set { this.Set (value, 'BILL_TO_NAME2'); }
        }

        public String BillToStreet
        { 
            get { return this.getString ('BILL_TO_STREET'); } 
            set { this.Set (value, 'BILL_TO_STREET'); }
        }

        public String BillToCity
        { 
            get { return this.getString ('BILL_TO_CITY'); } 
            set { this.Set (value, 'BILL_TO_CITY'); }
        }

        public String BillToPostCode
        { 
            get { return this.getString ('BILL_TO_POST_CODE1'); } 
            set { this.Set (value, 'BILL_TO_POST_CODE1'); }
        }

        public String BillToCountry
        { 
            get { return this.getString ('BILL_TO_COUNTRY'); } 
            set { this.Set (value, 'BILL_TO_COUNTRY'); }
        }

        public Decimal DiscountAmount
        { 
            get { return this.getDecimal ('DISCOUNT_AMOUNT'); } 
            set { this.Set (value, 'DISCOUNT_AMOUNT'); }
        }

        public String ErpOrderNumber
        { 
            get { return this.getString ('ERP_ORDER_NUMBER'); } 
            set { this.Set (value, 'ERP_ORDER_NUMBER'); }
        }

        public String SalesDocumentType
        { 
            get { return this.getString ('AUART'); } 
            set { this.Set (value, 'AUART'); }
        }

        public String Fob
        { 
            get { return this.getString ('FOB'); } 
            set { this.Set (value, 'FOB'); }
        }

        public String Misc
        { 
            get { return this.getString ('MISC'); } 
            set { this.Set (value, 'MISC'); }
        }

        public Date NeedByDate
        { 
            get { return this.getDate ('NEED_BY_DATE'); } 
            set { this.Set (value, 'NEED_BY_DATE'); }
        }

        public String OrderComment
        { 
            get { return this.getString ('ORDER_COMMENT'); } 
            set { this.Set (value, 'ORDER_COMMENT'); }
        }

        public Date OrderDate
        { 
            get { return this.getDate ('ORDER_DATE'); } 
            set { this.Set (value, 'ORDER_DATE'); }
        }

        public String OrderHeld
        { 
            get { return this.getString ('ORDER_HELD'); } 
            set { this.Set (value, 'ORDER_HELD'); }
        }

        public String OrderSource
        { 
            get { return this.getString ('ORDER_SOURCE'); } 
            set { this.Set (value, 'ORDER_SOURCE'); }
        }

        public String OrderStatus
        { 
            get { return this.getString ('ORDER_STATUS'); } 
            set { this.Set (value, 'ORDER_STATUS'); }
        }

        public Decimal OrderSubtotal
        { 
            get { return this.getDecimal ('ORDER_SUBTOTAL'); } 
            set { this.Set (value, 'ORDER_SUBTOTAL'); }
        }

        public Decimal OrderTotal
        { 
            get { return this.getDecimal ('ORDER_TOTAL'); } 
            set { this.Set (value, 'ORDER_TOTAL'); }
        }

        public String PurchaseOrder
        { 
            get { return this.getString ('PO'); } 
            set { this.Set (value, 'PO'); }
        }

        public Date ShipBy
        { 
            get { return this.getDate ('SHIP_BY'); } 
            set { this.Set (value, 'SHIP_BY'); }
        }

        public String ShipTo
        { 
            get { return this.getString ('SHIP_TO'); } 
            set { this.Set (value, 'SHIP_TO'); }
        }

        public String ShipToName
        { 
            get { return this.getString ('SHIP_TO_NAME'); } 
            set { this.Set (value, 'SHIP_TO_NAME'); }
        }

        public String ShipVia
        { 
            get { return this.getString ('SHIP_VIA'); } 
            set { this.Set (value, 'SHIP_VIA'); }
        }

        public String SoldTo
        { 
            get { return this.getString ('SOLD_TO'); } 
            set { this.Set (value, 'SOLD_TO'); }
        }

        public String SoldToName
        { 
            get { return this.getString ('SOLD_TO_NAME'); } 
            set { this.Set (value, 'SOLD_TO_NAME'); }
        }

        public Decimal Subtotal
        { 
            get { return this.getDecimal ('SUBTOTAL'); } 
            set { this.Set (value, 'SUBTOTAL'); }
        }

        public Decimal Tax
        { 
            get { return this.getDecimal ('TAX'); } 
            set { this.Set (value, 'TAX'); }
        }

        public String Terms
        { 
            get { return this.getString ('TERMS'); } 
            set { this.Set (value, 'TERMS'); }
        }

        public Decimal DiscountPrice
        { 
            get { return this.getDecimal ('DISCOUNTPRICE'); } 
            set { this.Set (value, 'DISCOUNTPRICE'); }
        }

        public Decimal ExtPrice
        { 
            get { return this.getDecimal ('EXT_PRICE'); } 
            set { this.Set (value, 'EXT_PRICE'); }
        }

        public String LineComment
        { 
            get { return this.getString ('LINE_COMMENT'); } 
            set { this.Set (value, 'LINE_COMMENT'); }
        }

        public String LineNumber
        { 
            get { return this.getString ('LINE_NUMBER'); } 
            set { this.Set (value, 'LINE_NUMBER'); }
        }

        public String LineStatus
        { 
            get { return this.getString ('LINE_STATUS'); } 
            set { this.Set (value, 'LINE_STATUS'); }
        }

        public String LineStatusDesc
        { 
            get { return this.getString ('LINE_STATUS_DESC'); } 
            set { this.Set (value, 'LINE_STATUS_DESC'); }
        }

        public Date NeedBy
        { 
            get { return this.getDate ('NEED_BY'); } 
            set { this.Set (value, 'NEED_BY'); }
        }

        public String Order
        { 
            get { return this.getString ('ORDER_C'); } 
            set { this.Set (value, 'ORDER_C'); }
        }

        public Decimal OrderQuantity
        { 
            get { return this.getDecimal ('ORDER_QUANTITY'); } 
            set { this.Set (value, 'ORDER_QUANTITY'); }
        }

        public String PartNumber
        { 
            get { return this.getString ('PART_NUMBER'); } 
            set { this.Set (value, 'PART_NUMBER'); }
        }

        public String ProductGroup
        { 
            get { return this.getString ('PRODUCT_GROUP'); } 
            set { this.Set (value, 'PRODUCT_GROUP'); }
        }

        public String Product
        { 
            get { return this.getString ('PRODUCT'); } 
            set { this.Set (value, 'PRODUCT'); }
        }

        public String ProductDesc
        { 
            get { return this.getString ('PRODUCT_DESC'); } 
            set { this.Set (value, 'PRODUCT_DESC'); }
        }

        public Date RequestDate
        { 
            get { return this.getDate ('REQUEST_DATE'); } 
            set { this.Set (value, 'REQUEST_DATE'); }
        }

        public String SalesCategory
        { 
            get { return this.getString ('SALES_CATEGORY'); } 
            set { this.Set (value, 'SALES_CATEGORY'); }
        }

        public Decimal TotalShipped
        { 
            get { return this.getDecimal ('TOTAL_SHIPPED'); } 
            set { this.Set (value, 'TOTAL_SHIPPED'); }
        }

        public Decimal UnitPrice
        { 
            get { return this.getDecimal ('UNIT_PRICE'); } 
            set { this.Set (value, 'UNIT_PRICE'); }
        }

        public Decimal ShippingAmount
        { 
            get { return this.getDecimal ('SHIPPING_AMT'); } 
            set { this.Set (value, 'SHIPPING_AMT'); }
        }

        public String Upc
        { 
            get { return this.getString ('UPC'); } 
            set { this.Set (value, 'UPC'); }
        }

        public String CreditHoldStatus
        { 
            get { return this.getString ('CREDIT_HOLD_STATUS'); } 
            set { this.Set (value, 'CREDIT_HOLD_STATUS'); }
        }

        public String CreditHoldStatusDescription
        { 
            get { return this.getString ('CREDIT_HOLD_STATUS_DESC'); } 
            set { this.Set (value, 'CREDIT_HOLD_STATUS_DESC'); }
        }

        public Date LastChangeDate
        { 
            get { return this.getDate ('LAST_CHANGE_DATE'); } 
            set { this.Set (value, 'LAST_CHANGE_DATE'); }
        }

        public Time LastChangeTime
        { 
            get { return this.getTime ('LAST_CHANGE_TIME'); } 
            set { this.Set (value, 'LAST_CHANGE_TIME'); }
        }

    }


}
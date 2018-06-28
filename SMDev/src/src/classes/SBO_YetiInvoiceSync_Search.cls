/// enosiX Inc. Generated Apex Model
/// Generated On: 8/1/2017 2:59:05 PM
/// SAP Host: From REST Service On: https://na3.salesforce.com
/// CID: From REST Service On: https://na3.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

public with sharing class SBO_YetiInvoiceSync_Search extends ensx.EnosixFramework.SearchSBO 
{
    
    public SBO_YetiInvoiceSync_Search() 
    {
        super('YetiInvoiceSync', SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SC.class, SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SR.class);
    }
    
    public override Type getType() { return SBO_YetiInvoiceSync_Search.class; }

    public YetiInvoiceSync_SR execute()
    {
        return (YetiInvoiceSync_SR)super.executeSearch();
    }

    public YetiInvoiceSync_SC SearchContext 
    {
        get { return (YetiInvoiceSync_SC)this.getSearchContext(); }
    }

    public class YetiInvoiceSync_SC extends ensx.EnosixFramework.SearchContext 
    { 		
        public YetiInvoiceSync_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => SBO_YetiInvoiceSync_Search.SEARCHPARAMS.class		
                });		
        }

        public override Type getType() { return SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SC.class; }




        public SBO_YetiInvoiceSync_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (SBO_YetiInvoiceSync_Search.SEARCHPARAMS)this.getStruct(SBO_YetiInvoiceSync_Search.SEARCHPARAMS.class);
            }
        }
        
        }

    public class YetiInvoiceSync_SR extends ensx.EnosixFramework.SearchResult 
    {
        public YetiInvoiceSync_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_YetiInvoiceSync_Search.SEARCHRESULT.class } );
        }
        
        public ensx.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(SBO_YetiInvoiceSync_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return SBO_YetiInvoiceSync_Search.YetiInvoiceSync_SR.class; }

    }

    public class SEARCHPARAMS extends ensx.EnosixFramework.ValueObject 
    {
        public override Type getType() { return SBO_YetiInvoiceSync_Search.SEARCHPARAMS.class; }

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

        public String FromSalesDocumentNumber
        { 
            get { return this.getString ('VBELN_FR'); } 
            set { this.Set (value, 'VBELN_FR'); }
        }

        public String ToSalesDocumentNumber
        { 
            get { return this.getString ('VBELN_TO'); } 
            set { this.Set (value, 'VBELN_TO'); }
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

        public Time ChangeTimeFrom
        { 
            get { return this.getTime ('AEZET_FR'); } 
            set { this.Set (value, 'AEZET_FR'); }
        }

        public Time ChangeTimeTo
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
        public override Type getType() { return SBO_YetiInvoiceSync_Search.SEARCHRESULT.class; }

        public String InvoiceSalesRep
        { 
            get { return this.getString ('INVOICE_SALES_REP'); } 
            set { this.Set (value, 'INVOICE_SALES_REP'); }
        }

        public Decimal InvoiceAmount
        { 
            get { return this.getDecimal ('INVOICE_AMT'); } 
            set { this.Set (value, 'INVOICE_AMT'); }
        }

        public Decimal InvoiceBalance
        { 
            get { return this.getDecimal ('INVOICE_BALANCE'); } 
            set { this.Set (value, 'INVOICE_BALANCE'); }
        }

        public Date InvoiceDate
        { 
            get { return this.getDate ('INVOICE_DATE'); } 
            set { this.Set (value, 'INVOICE_DATE'); }
        }

        public String BillToParty
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

        public String BillToPostalCode
        { 
            get { return this.getString ('BILL_TO_POST_CODE1'); } 
            set { this.Set (value, 'BILL_TO_POST_CODE1'); }
        }

        public String BillToCountry
        { 
            get { return this.getString ('BILL_TO_COUNTRY'); } 
            set { this.Set (value, 'BILL_TO_COUNTRY'); }
        }

        public Decimal TotalBeforeDiscount
        { 
            get { return this.getDecimal ('TOTAL_BEFORE_DIS'); } 
            set { this.Set (value, 'TOTAL_BEFORE_DIS'); }
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

        public Decimal ShippingAmount
        { 
            get { return this.getDecimal ('SHIP_AMOUNT'); } 
            set { this.Set (value, 'SHIP_AMOUNT'); }
        }

        public Decimal DepositBalance
        { 
            get { return this.getDecimal ('DEPOSIT_BALANCE'); } 
            set { this.Set (value, 'DEPOSIT_BALANCE'); }
        }

        public Decimal Discount
        { 
            get { return this.getDecimal ('DISCOUNT'); } 
            set { this.Set (value, 'DISCOUNT'); }
        }

        public Date DueDate
        { 
            get { return this.getDate ('DUE_DATE'); } 
            set { this.Set (value, 'DUE_DATE'); }
        }

        public String FOB
        { 
            get { return this.getString ('FOB'); } 
            set { this.Set (value, 'FOB'); }
        }

        public String PurchaseOrderNumber
        { 
            get { return this.getString ('PO'); } 
            set { this.Set (value, 'PO'); }
        }

        public String SalesOrder
        { 
            get { return this.getString ('SALES_ORDER'); } 
            set { this.Set (value, 'SALES_ORDER'); }
        }

        public String Delivery
        { 
            get { return this.getString ('DELIVERY'); } 
            set { this.Set (value, 'DELIVERY'); }
        }

        public String SoldToParty
        { 
            get { return this.getString ('SOLD_TO'); } 
            set { this.Set (value, 'SOLD_TO'); }
        }

        public String SoldToName
        { 
            get { return this.getString ('SOLD_TO_NAME'); } 
            set { this.Set (value, 'SOLD_TO_NAME'); }
        }

        public String ShipToParty
        { 
            get { return this.getString ('SHIP_TO'); } 
            set { this.Set (value, 'SHIP_TO'); }
        }

        public String ShipToName
        { 
            get { return this.getString ('SHIP_TO_NAME'); } 
            set { this.Set (value, 'SHIP_TO_NAME'); }
        }

        public String Status
        { 
            get { return this.getString ('STATUS'); } 
            set { this.Set (value, 'STATUS'); }
        }

        public String Terms
        { 
            get { return this.getString ('TERMS'); } 
            set { this.Set (value, 'TERMS'); }
        }

        public String Description
        { 
            get { return this.getString ('DESCRIPTION'); } 
            set { this.Set (value, 'DESCRIPTION'); }
        }

        public Decimal ExtPrice
        { 
            get { return this.getDecimal ('EXT_PRICE'); } 
            set { this.Set (value, 'EXT_PRICE'); }
        }

        public Decimal InvoicedQuantity
        { 
            get { return this.getDecimal ('ORDER_QUANTITY'); } 
            set { this.Set (value, 'ORDER_QUANTITY'); }
        }

        public String PackingLineitemNumber
        { 
            get { return this.getString ('PACKING_LINE'); } 
            set { this.Set (value, 'PACKING_LINE'); }
        }

        public String PackingSlipnumber
        { 
            get { return this.getString ('PACKING_SLIP'); } 
            set { this.Set (value, 'PACKING_SLIP'); }
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

        public Decimal UnitPrice
        { 
            get { return this.getDecimal ('UNIT_PRICE'); } 
            set { this.Set (value, 'UNIT_PRICE'); }
        }

        public String Invoice
        { 
            get { return this.getString ('INVOICE'); } 
            set { this.Set (value, 'INVOICE'); }
        }

        public String InvoiceItemNumber
        { 
            get { return this.getString ('INVOICE_POSNR'); } 
            set { this.Set (value, 'INVOICE_POSNR'); }
        }

        public String UPC
        { 
            get { return this.getString ('UPC'); } 
            set { this.Set (value, 'UPC'); }
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
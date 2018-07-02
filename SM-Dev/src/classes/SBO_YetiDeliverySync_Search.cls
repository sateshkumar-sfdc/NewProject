/// enosiX Inc. Generated Apex Model
/// Generated On: 8/1/2017 2:59:05 PM
/// SAP Host: From REST Service On: https://na3.salesforce.com
/// CID: From REST Service On: https://na3.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

public with sharing class SBO_YetiDeliverySync_Search extends ensx.EnosixFramework.SearchSBO 
{
    
    public SBO_YetiDeliverySync_Search() 
    {
        super('YetiDeliverySync', SBO_YetiDeliverySync_Search.YetiDeliverySync_SC.class, SBO_YetiDeliverySync_Search.YetiDeliverySync_SR.class);
    }
    
    public override Type getType() { return SBO_YetiDeliverySync_Search.class; }

    public YetiDeliverySync_SR execute()
    {
        return (YetiDeliverySync_SR)super.executeSearch();
    }

    public YetiDeliverySync_SC SearchContext 
    {
        get { return (YetiDeliverySync_SC)this.getSearchContext(); }
    }

    public class YetiDeliverySync_SC extends ensx.EnosixFramework.SearchContext 
    { 		
        public YetiDeliverySync_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => SBO_YetiDeliverySync_Search.SEARCHPARAMS.class		
                });		
        }

        public override Type getType() { return SBO_YetiDeliverySync_Search.YetiDeliverySync_SC.class; }




        public SBO_YetiDeliverySync_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (SBO_YetiDeliverySync_Search.SEARCHPARAMS)this.getStruct(SBO_YetiDeliverySync_Search.SEARCHPARAMS.class);
            }
        }
        
        }

    public class YetiDeliverySync_SR extends ensx.EnosixFramework.SearchResult 
    {
        public YetiDeliverySync_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_YetiDeliverySync_Search.SEARCHRESULT.class } );
        }
        
        public ensx.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(SBO_YetiDeliverySync_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return SBO_YetiDeliverySync_Search.YetiDeliverySync_SR.class; }

    }

    public class SEARCHPARAMS extends ensx.EnosixFramework.ValueObject 
    {
        public override Type getType() { return SBO_YetiDeliverySync_Search.SEARCHPARAMS.class; }

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

        public Time LastChangeTimeFrom
        { 
            get { return this.getTime ('AEZET_FR'); } 
            set { this.Set (value, 'AEZET_FR'); }
        }

        public Time LastChangeTimeTo
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
        public override Type getType() { return SBO_YetiDeliverySync_Search.SEARCHRESULT.class; }

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

        public String BillToParty
        { 
            get { return this.getString ('BILL_TO'); } 
            set { this.Set (value, 'BILL_TO'); }
        }

        public String BillToName
        { 
            get { return this.getString ('BILL_TO_NAME'); } 
            set { this.Set (value, 'BILL_TO_NAME'); }
        }

        public String UniqueID
        { 
            get { return this.getString ('UNIQUE_ID'); } 
            set { this.Set (value, 'UNIQUE_ID'); }
        }

        public Date ShipDate
        { 
            get { return this.getDate ('SHIP_DATE'); } 
            set { this.Set (value, 'SHIP_DATE'); }
        }

        public String Site
        { 
            get { return this.getString ('SITE'); } 
            set { this.Set (value, 'SITE'); }
        }

        public String TrackingNumber
        { 
            get { return this.getString ('TRACKING_NUMBER'); } 
            set { this.Set (value, 'TRACKING_NUMBER'); }
        }

        public String ShipVia
        { 
            get { return this.getString ('SHIP_VIA'); } 
            set { this.Set (value, 'SHIP_VIA'); }
        }

        public String ShipMethod
        { 
            get { return this.getString ('SHIP_MTHD'); } 
            set { this.Set (value, 'SHIP_MTHD'); }
        }

        public String Account
        { 
            get { return this.getString ('ACCOUNT'); } 
            set { this.Set (value, 'ACCOUNT'); }
        }

        public String SentTo3pl
        { 
            get { return this.getString ('SENT_TO_3PL'); } 
            set { this.Set (value, 'SENT_TO_3PL'); }
        }

        public String PartNumber
        { 
            get { return this.getString ('PART_NUMBER'); } 
            set { this.Set (value, 'PART_NUMBER'); }
        }

        public String Uom
        { 
            get { return this.getString ('UOM'); } 
            set { this.Set (value, 'UOM'); }
        }

        public String Upc
        { 
            get { return this.getString ('UPC'); } 
            set { this.Set (value, 'UPC'); }
        }

        public String PartDescription
        { 
            get { return this.getString ('PART_DESCRIPTION'); } 
            set { this.Set (value, 'PART_DESCRIPTION'); }
        }

        public Decimal Quantity
        { 
            get { return this.getDecimal ('QUANTITY'); } 
            set { this.Set (value, 'QUANTITY'); }
        }

        public Decimal QuantityOrdered
        { 
            get { return this.getDecimal ('QTY_ORDERED'); } 
            set { this.Set (value, 'QTY_ORDERED'); }
        }

        public String PackLineNum
        { 
            get { return this.getString ('PACK_LINE_NUM'); } 
            set { this.Set (value, 'PACK_LINE_NUM'); }
        }

        public Date NeedByDate
        { 
            get { return this.getDate ('NEED_BY_DATE'); } 
            set { this.Set (value, 'NEED_BY_DATE'); }
        }

        public Date ShipByDate
        { 
            get { return this.getDate ('SHIP_BY_DATE'); } 
            set { this.Set (value, 'SHIP_BY_DATE'); }
        }

        public String Warehouse
        { 
            get { return this.getString ('WAREHOUSE'); } 
            set { this.Set (value, 'WAREHOUSE'); }
        }

        public String ErpOrder
        { 
            get { return this.getString ('ERP_ORDER'); } 
            set { this.Set (value, 'ERP_ORDER'); }
        }

        public String CustomerShipment
        { 
            get { return this.getString ('CUSTOMER_SHIPMENT'); } 
            set { this.Set (value, 'CUSTOMER_SHIPMENT'); }
        }

        public String DeliveryItemNumber
        { 
            get { return this.getString ('DELIVERY_POSNR'); } 
            set { this.Set (value, 'DELIVERY_POSNR'); }
        }

        public String SearchResultStatus
        { 
            get { return this.getString ('STATUS'); } 
            set { this.Set (value, 'STATUS'); }
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

        public String Invoice
        { 
            get { return this.getString ('INVOICE'); } 
            set { this.Set (value, 'INVOICE'); }
        }

    }


}
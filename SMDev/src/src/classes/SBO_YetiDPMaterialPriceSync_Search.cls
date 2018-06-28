/// enosiX Inc. Generated Apex Model
/// Generated On: 8/24/2017 1:28:25 PM
/// SAP Host: From REST Service On: https://na37.salesforce.com
/// CID: From REST Service On: https://na37.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

public with sharing class SBO_YetiDPMaterialPriceSync_Search extends ensx.EnosixFramework.SearchSBO 
{
    
    public SBO_YetiDPMaterialPriceSync_Search() 
    {
        super('YetiDPMaterialPriceSync', SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SC.class, SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SR.class);
    }
    
    public override Type getType() { return SBO_YetiDPMaterialPriceSync_Search.class; }

    public YetiDPMaterialPriceSync_SR execute()
    {
        return (YetiDPMaterialPriceSync_SR)super.executeSearch();
    }

    public YetiDPMaterialPriceSync_SC SearchContext 
    {
        get { return (YetiDPMaterialPriceSync_SC)this.getSearchContext(); }
    }

    public class YetiDPMaterialPriceSync_SC extends ensx.EnosixFramework.SearchContext 
    { 		
        public YetiDPMaterialPriceSync_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => SBO_YetiDPMaterialPriceSync_Search.SEARCHPARAMS.class		
                });		
        }

        public override Type getType() { return SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SC.class; }




        public SBO_YetiDPMaterialPriceSync_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (SBO_YetiDPMaterialPriceSync_Search.SEARCHPARAMS)this.getStruct(SBO_YetiDPMaterialPriceSync_Search.SEARCHPARAMS.class);
            }
        }
        
        }

    public class YetiDPMaterialPriceSync_SR extends ensx.EnosixFramework.SearchResult 
    {
        public YetiDPMaterialPriceSync_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT.class } );
        }
        
        public ensx.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SR.class; }

    }

    public class SEARCHPARAMS extends ensx.EnosixFramework.ValueObject 
    {
        public override Type getType() { return SBO_YetiDPMaterialPriceSync_Search.SEARCHPARAMS.class; }

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

        public Integer PageNumber
        { 
            get { return this.getInteger ('PAGE_NUMBER'); } 
            set { this.Set (value, 'PAGE_NUMBER'); }
        }

        public Integer MaxRows
        { 
            get { return this.getInteger ('MAX_ROWS'); } 
            set { this.Set (value, 'MAX_ROWS'); }
        }

    }

    public class SEARCHRESULT extends ensx.EnosixFramework.ValueObject 
    {
        public override Type getType() { return SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT.class; }

        public String Material
        { 
            get { return this.getString ('MATNR'); } 
            set { this.Set (value, 'MATNR'); }
        }

        public String MaterialDescription
        { 
            get { return this.getString ('MAKTX'); } 
            set { this.Set (value, 'MAKTX'); }
        }

        public Decimal Amount
        { 
            get { return this.getDecimal ('KBETR'); } 
            set { this.Set (value, 'KBETR'); }
        }

        public String FieldCurrency
        { 
            get { return this.getString ('KONWA'); } 
            set { this.Set (value, 'KONWA'); }
        }

        public Date CreateDate
        { 
            get { return this.getDate ('ERDAT'); } 
            set { this.Set (value, 'ERDAT'); }
        }

        public Time EntryTime
        { 
            get { return this.getTime ('ERZET'); } 
            set { this.Set (value, 'ERZET'); }
        }

        public Date ChangeDate
        { 
            get { return this.getDate ('LAST_CHANGE_DATE'); } 
            set { this.Set (value, 'LAST_CHANGE_DATE'); }
        }

        public Time ChangeTime
        { 
            get { return this.getTime ('LAST_CHANGE_TIME'); } 
            set { this.Set (value, 'LAST_CHANGE_TIME'); }
        }

        public String Active
        { 
            get { return this.getString ('ACTIVE'); } 
            set { this.Set (value, 'ACTIVE'); }
        }

    }


}
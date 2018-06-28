/// enosiX Inc. Generated Apex Model
/// Generated On: 9/19/2017 10:28:11 AM
/// SAP Host: From REST Service On: https://cs14.salesforce.com
/// CID: From REST Service On: https://cs14.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework v1.10

public with sharing class SBO_YetiAddressSync_Search extends ensx.EnosixFramework.SearchSBO 
{
    
    public SBO_YetiAddressSync_Search() 
    {
        super('YetiAddressSync', SBO_YetiAddressSync_Search.YetiAddressSync_SC.class, SBO_YetiAddressSync_Search.YetiAddressSync_SR.class);
    }
    
    public override Type getType() { return SBO_YetiAddressSync_Search.class; }

    public YetiAddressSync_SR execute()
    {
        return (YetiAddressSync_SR)super.executeSearch();
    }

    public YetiAddressSync_SC SearchContext 
    {
        get { return (YetiAddressSync_SC)this.getSearchContext(); }
    }

    public class YetiAddressSync_SC extends ensx.EnosixFramework.SearchContext 
    { 		
        public YetiAddressSync_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => SBO_YetiAddressSync_Search.SEARCHPARAMS.class		
                });		
        }

        public override Type getType() { return SBO_YetiAddressSync_Search.YetiAddressSync_SC.class; }




        public SBO_YetiAddressSync_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (SBO_YetiAddressSync_Search.SEARCHPARAMS)this.getStruct(SBO_YetiAddressSync_Search.SEARCHPARAMS.class);
            }
        }
        
        }

    public class YetiAddressSync_SR extends ensx.EnosixFramework.SearchResult 
    {
        public YetiAddressSync_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => SBO_YetiAddressSync_Search.SEARCHRESULT.class } );
        }
        
        public ensx.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(SBO_YetiAddressSync_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return SBO_YetiAddressSync_Search.YetiAddressSync_SR.class; }

    }

    public class SEARCHPARAMS extends ensx.EnosixFramework.ValueObject 
    {
        public override Type getType() { return SBO_YetiAddressSync_Search.SEARCHPARAMS.class; }

        public Date FromChangeDate
        { 
            get { return this.getDate ('DATE_FR'); } 
            set { this.Set (value, 'DATE_FR'); }
        }

        public Date ToChangeDate
        { 
            get { return this.getDate ('DATE_TO'); } 
            set { this.Set (value, 'DATE_TO'); }
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
        public override Type getType() { return SBO_YetiAddressSync_Search.SEARCHRESULT.class; }

        public String CustomerNumber
        { 
            get { return this.getString ('PARTNER'); } 
            set { this.Set (value, 'PARTNER'); }
        }

        public String Street
        { 
            get { return this.getString ('STREET'); } 
            set { this.Set (value, 'STREET'); }
        }

        public String HouseNumber
        { 
            get { return this.getString ('HOUSE_NUM1'); } 
            set { this.Set (value, 'HOUSE_NUM1'); }
        }

        public String District
        { 
            get { return this.getString ('CITY2'); } 
            set { this.Set (value, 'CITY2'); }
        }

        public String PostalCode
        { 
            get { return this.getString ('POST_CODE1'); } 
            set { this.Set (value, 'POST_CODE1'); }
        }

        public String City
        { 
            get { return this.getString ('CITY1'); } 
            set { this.Set (value, 'CITY1'); }
        }

        public String Country
        { 
            get { return this.getString ('COUNTRY'); } 
            set { this.Set (value, 'COUNTRY'); }
        }

        public String Region
        { 
            get { return this.getString ('REGION'); } 
            set { this.Set (value, 'REGION'); }
        }

        public Date ChangeDate
        { 
            get { return this.getDate ('UDATE'); } 
            set { this.Set (value, 'UDATE'); }
        }

        public Time ChangeTime
        { 
            get { return this.getTime ('UTIME'); } 
            set { this.Set (value, 'UTIME'); }
        }

        public String InsideSalesRep
        { 
            get { return this.getString ('ZI_KUNN2'); } 
            set { this.Set (value, 'ZI_KUNN2'); }
        }

        public String InsideSalesRepName1
        { 
            get { return this.getString ('ZI_BP_NAME1'); } 
            set { this.Set (value, 'ZI_BP_NAME1'); }
        }

        public String InsideSalesRepName2
        { 
            get { return this.getString ('ZI_BP_NAME2'); } 
            set { this.Set (value, 'ZI_BP_NAME2'); }
        }

        public String OutsideSalesRep
        { 
            get { return this.getString ('Z0_KUNN2'); } 
            set { this.Set (value, 'Z0_KUNN2'); }
        }

        public String OutsideSalesRepName1
        { 
            get { return this.getString ('Z0_BP_NAME1'); } 
            set { this.Set (value, 'Z0_BP_NAME1'); }
        }

        public String OutsideSalesRepName2
        { 
            get { return this.getString ('Z0_BP_NAME2'); } 
            set { this.Set (value, 'Z0_BP_NAME2'); }
        }

        public String SalesOffice
        { 
            get { return this.getString ('VKBUR'); } 
            set { this.Set (value, 'VKBUR'); }
        }

        public String VKBUR_TEXT
        { 
            get { return this.getString ('VKBUR_TEXT'); } 
            set { this.Set (value, 'VKBUR_TEXT'); }
        }

    }


}
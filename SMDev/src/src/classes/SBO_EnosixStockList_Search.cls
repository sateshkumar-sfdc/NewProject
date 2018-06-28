public with sharing class SBO_EnosixStockList_Search extends ENSX.EnosixFramework.SearchSBO {

    public SBO_EnosixStockList_Search() {
        super('EnosixStockList', SBO_EnosixStockList_Search.EnosixStockList_SC.class, SBO_EnosixStockList_Search.EnosixStockList_SR.class);

    }


    public class EnosixStockList_SC extends ENSX.EnosixFramework.SearchContext {
        public EnosixStockList_SC() {
            super(new Map<string, type>{
                    'SEARCHPARAMS' => SBO_EnosixStockList_Search.SEARCHPARAMS.class

            });
        }

        public SBO_EnosixStockList_Search.SEARCHPARAMS SEARCHPARAMS {
            get {
                return (SEARCHPARAMS) this.getStruct(SBO_EnosixStockList_Search.SEARCHPARAMS.class);
            }
        }

    }

    public EnosixStockList_SC SearchContext {
        get {
            return (EnosixStockList_SC) this.getSearchContext();
        }
    }

    public class EnosixStockList_SR extends ENSX.EnosixFramework.SearchResult {
        public EnosixStockList_SR() {
            super(new Map<string, type>{
                    'SEARCHRESULT' => SBO_EnosixStockList_Search.SEARCHRESULT.class
            });
        }

        public ENSX.EnosixFramework.FrameworkCollection SearchResults {
            get {
                return super.getCollection(SBO_EnosixStockList_Search.SEARCHRESULT.class);
            }
        }

        public List<SEARCHRESULT> getResults() {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }
    }

    public EnosixStockList_SR execute() {
        return (EnosixStockList_SR) super.executeSearch();
    }

    public class SEARCHPARAMS extends ENSX.EnosixFramework.ValueObject {
        public String Material {
            get {
                return this.getString ('MATNR');
            }
            set {
                this.Set (value, 'MATNR');
            }
        }

        public String Plant {
            get {
                return this.getString ('WERKS');
            }
            set {
                this.Set (value, 'WERKS');
            }
        }

        public Date FromDate {
            get {
                return this.getDate ('FROM_DT');
            }
            set {
                this.Set (value, 'FROM_DT');
            }
        }

        public Date ToDate {
            get {
                return this.getDate ('TO_DT');
            }
            set {
                this.Set (value, 'TO_DT');
            }
        }

    }
    public class SEARCHRESULT extends ENSX.EnosixFramework.ValueObject {
        public String Material {
            get {
                return this.getString ('MATNR');
            }
            set {
                this.Set (value, 'MATNR');
            }
        }

        public String Plant {
            get {
                return this.getString ('WERKS');
            }
            set {
                this.Set (value, 'WERKS');
            }
        }

        public Date ReceiptRequirementDate {
            get {
                return this.getDate ('DAT00');
            }
            set {
                this.Set (value, 'DAT00');
            }
        }

        public String MRPElement {
            get {
                return this.getString ('DELB0');
            }
            set {
                this.Set (value, 'DELB0');
            }
        }

        public String MRPElementData {
            get {
                return this.getString ('EXTRA');
            }
            set {
                this.Set (value, 'EXTRA');
            }
        }

        public Date ReschedulingDate {
            get {
                return this.getDate ('UMDAT');
            }
            set {
                this.Set (value, 'UMDAT');
            }
        }

        public Decimal QtyReceivedReserved {
            get {
                return this.getDecimal ('MNG01');
            }
            set {
                this.Set (value, 'MNG01');
            }
        }

        public Decimal AvailableQty {
            get {
                return this.getDecimal ('MNG02');
            }
            set {
                this.Set (value, 'MNG02');
            }
        }

        public Decimal AvailableQtyAfterAssignment {
            get {
                return this.getDecimal ('RESV_QTY');
            }
            set {
                this.Set (value, 'RESV_QTY');
            }
        }

        public String StorageLocation {
            get {
                return this.getString ('LGORT');
            }
            set {
                this.Set (value, 'LGORT');
            }
        }

    }

}
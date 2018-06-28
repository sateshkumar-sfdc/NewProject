/// enosiX Inc. Generated Apex Model
/// Generated On: 12/12/2016 9:15:22 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

public with sharing class SBO_EnosixSalesDocFlow_Search extends ENSX.EnosixFramework.SearchSBO {

    public SBO_EnosixSalesDocFlow_Search() {
        super('EnosixSalesDocFlow', SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SC.class, SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SR.class);
    }

    public override Type getType() {
        return SBO_EnosixSalesDocFlow_Search.class;
    }

    public class EnosixSalesDocFlow_SC extends ENSX.EnosixFramework.SearchContext {
        public EnosixSalesDocFlow_SC() {
            super(new Map<string, type>{
                    'SEARCHPARAMS' => SBO_EnosixSalesDocFlow_Search.SEARCHPARAMS.class

            });
        }

        public override Type getType() {
            return SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SC.class;
        }

        public SBO_EnosixSalesDocFlow_Search.SEARCHPARAMS SEARCHPARAMS {
            get {
                return (SEARCHPARAMS) this.getStruct(SBO_EnosixSalesDocFlow_Search.SEARCHPARAMS.class);
            }
        }

    }

    public EnosixSalesDocFlow_SC SearchContext {
        get {
            return (EnosixSalesDocFlow_SC) this.getSearchContext();
        }
    }

    public class EnosixSalesDocFlow_SR extends ENSX.EnosixFramework.SearchResult {
        public EnosixSalesDocFlow_SR() {
            super(new Map<string, type>{
                    'SEARCHRESULT' => SBO_EnosixSalesDocFlow_Search.SEARCHRESULT.class
            });
        }

        public ENSX.EnosixFramework.FrameworkCollection SearchResults {
            get {
                return super.getCollection(SBO_EnosixSalesDocFlow_Search.SEARCHRESULT.class);
            }
        }

        public List<SEARCHRESULT> getResults() {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() {
            return SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SR.class;
        }
    }

    public EnosixSalesDocFlow_SR execute() {
        return (EnosixSalesDocFlow_SR) super.executeSearch();
    }

    public class SEARCHPARAMS extends ENSX.EnosixFramework.ValueObject {

        public override Type getType() {
            return SBO_EnosixSalesDocFlow_Search.SEARCHPARAMS.class;
        }

        public String SalesDocument {
            get {
                return this.getString ('VBELN');
            }
            set {
                this.Set (value, 'VBELN');
            }
        }

        public String CustomerPONumber {
            get {
                return this.getString ('BSTNK');
            }
            set {
                this.Set (value, 'BSTNK');
            }
        }

        public String DocumentCategory {
            get {
                return this.getString ('VBTYP');
            }
            set {
                this.Set (value, 'VBTYP');
            }
        }

        public String X_PrecedingDocuments {
            get {
                return this.getString ('X_PRECEDING');
            }
            set {
                this.Set (value, 'X_PRECEDING');
            }
        }

        public String X_SubsequentDocuments {
            get {
                return this.getString ('X_SUBSEQUENT');
            }
            set {
                this.Set (value, 'X_SUBSEQUENT');
            }
        }

    }
    public class SEARCHRESULT extends ENSX.EnosixFramework.ValueObject {

        public override Type getType() {
            return SBO_EnosixSalesDocFlow_Search.SEARCHRESULT.class;
        }

        public String SalesDocument {
            get {
                return this.getString ('VBELN');
            }
            set {
                this.Set (value, 'VBELN');
            }
        }

        public String ItemNumber {
            get {
                return this.getString ('POSNR');
            }
            set {
                this.Set (value, 'POSNR');
            }
        }

        public String DocumentCategory {
            get {
                return this.getString ('VBTYP');
            }
            set {
                this.Set (value, 'VBTYP');
            }
        }

        public String DocumentCategoryText {
            get {
                return this.getString ('VBTYP_TEXT');
            }
            set {
                this.Set (value, 'VBTYP_TEXT');
            }
        }

        public String CustomerNumber {
            get {
                return this.getString ('KUNNR');
            }
            set {
                this.Set (value, 'KUNNR');
            }
        }

        public Date CreateDate {
            get {
                return this.getDate ('ERDAT');
            }
            set {
                this.Set (value, 'ERDAT');
            }
        }

        public String CreatedBy {
            get {
                return this.getString ('ERNAM');
            }
            set {
                this.Set (value, 'ERNAM');
            }
        }

        public Date DateChanged {
            get {
                return this.getDate ('AEDAT');
            }
            set {
                this.Set (value, 'AEDAT');
            }
        }

        public String ChangedBy {
            get {
                return this.getString ('AENAM');
            }
            set {
                this.Set (value, 'AENAM');
            }
        }

        public String X_PrecedingDocuments {
            get {
                return this.getString ('X_PRECEDING');
            }
            set {
                this.Set (value, 'X_PRECEDING');
            }
        }

        public String X_SubsequentDocuments {
            get {
                return this.getString ('X_SUBSEQUENT');
            }
            set {
                this.Set (value, 'X_SUBSEQUENT');
            }
        }

        public String DocumentStatus {
            get {
                return this.getString ('STATUS');
            }
            set {
                this.Set (value, 'STATUS');
            }
        }

    }

}
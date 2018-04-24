public with sharing class CTRL_DocFlow_Search {

    public List<SBO_EnosixSalesDocFlow_Search.SEARCHRESULT> searchResults {get; private set;}

    public String salesDocNum {get; set;}
    public String customerPoNum {get; set;}
    public String docCategory {get; set;}

    // ctor
    public CTRL_DocFlow_Search() {
        salesDocNum = UTIL_PageState.current.docNum;
        // if it's set, do immediate search
        if (salesDocNum != null) {
            search();
        }

        docCategoryValues = getDocTypeValues();
    }

    // init doc category values
    RFC_SD_GET_DOC_CATEG_VALUES.RESULT getDocTypeValues() {
        RFC_SD_GET_DOC_CATEG_VALUES rfc = new RFC_SD_GET_DOC_CATEG_VALUES();
        RFC_SD_GET_DOC_CATEG_VALUES.RESULT result = rfc.execute();

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }

        return result;
    }

    // Doc Category dropdown
    RFC_SD_GET_DOC_CATEG_VALUES.RESULT docCategoryValues;
    public List<SelectOption> docCategoryOptions {
        get {
            List<SelectOption> result = new List<SelectOption>();

            if (null != docCategoryValues) {
                for (RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES cat : docCategoryValues.ET_VALUES_List) {
                    System.debug('cat: ' + cat.VBTYP + ': ' + cat.VBTYP_TEXT);
                    if (null != cat.VBTYP && null != cat.VBTYP_TEXT)
                    {
                        result.add(new SelectOption(cat.VBTYP, cat.VBTYP_TEXT));
                    }
                }
            }
            return result;
        }
    }

    public void search() {
        SBO_EnosixSalesDocFlow_Search sbo = new SBO_EnosixSalesDocFlow_Search();
        sbo.SearchContext.SEARCHPARAMS.SalesDocument = salesDocNum;
        sbo.SearchContext.SEARCHPARAMS.CustomerPONumber = salesDocNum;
        sbo.SearchContext.SEARCHPARAMS.DocumentCategory = docCategory;
        sbo.SearchContext.SEARCHPARAMS.X_PrecedingDocuments = 'X';
        sbo.SearchContext.SEARCHPARAMS.X_SubsequentDocuments = 'X';

        // execute search and fill searchResults property
        SBO_EnosixSalesDocFlow_Search.EnosixSalesDocFlow_SR result = sbo.execute();
        if (!result.isSuccess()) {
            searchResults = new SBO_EnosixSalesDocFlow_Search.SEARCHRESULT[0];
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
            System.debug('Search failed');
        }
        else {
            searchResults = result.getResults();
        	System.debug('Search success - docs found: ' + searchResults.size());
        }
    }

    // make sure this matches all the selectedDocCategory values below
    public String validLinkCategories { get { return 'CHIMJTB'; } }

    public PageReference gotoDetailPage() {
        String selectedDocCategory = System.currentPageReference().getParameters().get('selectedDocCategory');
        String selectedDocNum = System.currentPageReference().getParameters().get('selectedDocNum');

        String page = null;

        // order
        if (selectedDocCategory == 'C') {
            UTIL_PageState.current.orderNum = selectedDocNum;
            page = UTIL_PageFlow.VFP_OrderDetail;
        }
        // return order
        if (selectedDocCategory == 'H' || selectedDocCategory == 'I') {
            UTIL_PageState.current.rmaId = selectedDocNum;
            page = UTIL_PageFlow.VFP_Return_Order_Detail;
        }
        // invoice
        else if (selectedDocCategory == 'M') {
            UTIL_PageState.current.invoiceNum = selectedDocNum;
            page = UTIL_PageFlow.VFP_Invoice_Detail;
        }
        // delivery
        else if (selectedDocCategory == 'J' || selectedDocCategory == 'T') {
            UTIL_PageState.current.deliveryNum = selectedDocNum;
            page = UTIL_PageFlow.VFP_DeliveryDetail;
        }
        // quotation
        else if (selectedDocCategory == 'B') {
            UTIL_PageState.current.quoteId = selectedDocNum;
            page = UTIL_PageFlow.VFP_Quote_Detail;
        }

        return UTIL_PageFlow.redirectTo(page, UTIL_PageState.current);
    }
}
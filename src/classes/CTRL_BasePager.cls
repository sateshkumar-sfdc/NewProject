public abstract class CTRL_BasePager {
    // pagination use
    public Integer numperpage { get; set; }
    public Integer pagenum { get; set; }  // current page number
    public Integer totalpages { get; set; }
    public Integer startofpage { get; set; }    // start record number for the page
    public Boolean disableprev { get; set; }  // at the first page, disable previous arrows
    public Boolean disablenext { get; set; }  // at the end of the page, disable next arrows

    public Boolean hasrecords { get; set; }   // if this is true, we have records in the grid

    // if this is true, search again when pagination
    Boolean search_every_time;

    public CTRL_BasePager() {
        this(false);
    }

    public CTRL_BasePager(Boolean search_every_time) {
        numperpage = 10;
        hasrecords = false;
        pagenum = 1;
        disableprev = true;
        disablenext = true;
        this.search_every_time = search_every_time;
    }

    protected void setTotalPages(Integer recordsize) {
        System.debug('recordSize:' + recordsize);
        if (recordsize > 0) hasrecords = true; else hasrecords = false;
        System.debug('hasRecords:' + hasrecords);
        System.debug('recordsizeDouble:' + Double.valueOf(recordsize));
        System.debug('numperpage:' + Double.valueOf(numperpage));

        totalpages = Integer.valueOf(Math.ceil(Double.valueOf(recordsize) / Double.valueOf(numperpage)));

    }

    // method to be overridden by children
    protected abstract void runSearch();    // actual search method
    protected abstract void updatePaginatedResult();    // update the paginated result into the children variable

    /**
     * called directly by the pages
     */
    
    /** 
     * pagination use, based on what the pagination parameters are, perform pagination work
     */
    public void doPagination() {
        String action = System.currentPageReference().getParameters().get('action');
        // handle pagination action, actions are: first, prev, next, end
        if (action != null) {
            if (action == 'first')
                pagenum = 1;
            else if (action == 'prev')
                pagenum--;
            else if (action == 'next')
                pagenum++;
            else if (action == 'end')
                pagenum = totalpages;
        } else {
            pagenum = 1;
        }

        // we set full record to transient so we have to search again on page change
        if (search_every_time) runSearch();


        disableprev = (pagenum == 1 ? true : false);
        disablenext = (pagenum == totalpages ? true : false);

        // determine the start record based on numperpage and pagenum
        startofpage = (pagenum - 1) * numperpage;

        if (hasrecords) updatePaginatedResult();

    } 

    
    /** update number of records to display per page */
    public void updateNumPerPage() {
        pagenum = 1;    // everytime we update num per page, we reset page number to 1, salesforce default behavior
        doPagination();
    }


    public List<SelectOption> getNumPerPageOptions() {
        List<SelectOption> numperpageoptions = new List<SelectOption>();
        numperpageoptions.add(new SelectOption('5', '5'));
        numperpageoptions.add(new SelectOption('10', '10'));
        numperpageoptions.add(new SelectOption('25', '25'));
        numperpageoptions.add(new SelectOption('50', '50'));
        numperpageoptions.add(new SelectOption('100', '100'));
        numperpageoptions.add(new SelectOption('200', '200'));
        return numperpageoptions;
    }

}
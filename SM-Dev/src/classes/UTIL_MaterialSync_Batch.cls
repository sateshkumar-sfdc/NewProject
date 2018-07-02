public with sharing class UTIL_MaterialSync_Batch
    implements Database.Batchable<SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT>,
    Database.AllowsCallouts,
    Database.Stateful,
    I_ParameterizedSync
{

    // MAX_ROWS is a SBO parameter which controls the maximum header rows retrieved,
    //  however, there have been 2600+ detail records returned by a MAX_ROWS of 150
    //  because of headers with large numbers of lines.
    // The response size needs to remain within a reasonable size so that the Apex heap
    //  limit isn't exceeded which would cause the job to fail.
    private final Integer MAX_ROWS = 150;

    // isAnotherBatchNeeded is a flag set in start() after examing how many rows were returned
    //  telling finish() whether to schedule another instance to retrieve additional records
    private Boolean isAnotherBatchNeeded = false;

    // jobInfo contains debug information persisted across contexts since start(),
    //   execute(), and finish() all run in separate contexts with separate debug logs
    private List<String> jobInfo = new List<String>();

    /* I_ParameterizedSync methods - setBatchParam() */
    // In this case, we will store the next page number to use.
    private Integer pageNumber = 1;

    private Id custPriceBookId = null;

    public void setBatchParam(String value)
    {
        try
        {
            Integer pgNum = Integer.valueOf(value);
            if (pgNum < 1)
            {
                pgNum = 1;
                System.debug('Batch param value (pageNumber) cannot be a negative value. Defaulting to 1.');
            }

            this.pageNumber = pgNum;
        }
        catch (Exception ex)
        {
            System.debug('Batch parameter not a valid integer. Ignoring param value: ' + value);
            this.jobInfo.add('Batch parameter for page number not a valid integer. Ignoring param value and starting at 1.');
        }
    }

    // start()
    //
    // Start the batch job
    public List<SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> start(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' started');

        SBO_YetiDPMaterialPriceSync_Search sbo = new SBO_YetiDPMaterialPriceSync_Search();
        sbo.SearchContext.SEARCHPARAMS.MaxRows = MAX_ROWS;
        sbo.SearchContext.SEARCHPARAMS.PageNumber = this.pageNumber;

        /* Reverted UTIL_MaterialSync_Batch to full material sync per https://tickets.enosix.com/servicedesk/customer/portal/2/SUPPORT-379
        try //Graham
        {
            Pricebook2 customPricebook = UTIL_YetiSyncHelper.getCustomPricebook();
            SObject lastChangedRecord = Database.query('SELECT LastModifiedDate FROM PriceBookEntry WHERE Pricebook2Id = \'' + customPricebook.Id + '\' ORDER BY LastModifiedDate DESC NULLS LAST LIMIT 1');
            Datetime lastSync = (Datetime)lastChangedRecord.get('LastModifiedDate');
            sbo.SearchContext.SEARCHPARAMS.FromLastChangeDate = lastSync.date();
            sbo.SearchContext.SEARCHPARAMS.FromChangeTime = lastSync.time();
            this.jobInfo.add('from:' + lastSync.format('yyyy-MM-dd HH:mm:ss'));
        }
        catch (Exception ex)
        {
            System.debug(ex);
        }
		*/

        // Execute the search
        SBO_YetiDPMaterialPriceSync_Search.YetiDPMaterialPriceSync_SR result = sbo.execute();
        
        // Write any response messages to the debug log
        List<ENSX.EnosixFramework.Message> messages = result.getMessages();
        if (null != messages)
        {
            for (ENSX.EnosixFramework.Message m: messages)
            {
                System.debug('response message[' + m.Type.name() + ']: ' + m.Text);
            }
        }

        if (!result.isSuccess())
        {
            System.debug('search failed');
            UTIL_SyncHelper.printJobInfo(this.jobInfo);
            return null;
        }

        List<SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> searchResults = result.getResults();
        System.debug('search successfully retrieved ' + searchResults.size() + ' result records');

        // let finish() know to queue up another instance
        this.isAnotherBatchNeeded = searchResults.size() >= MAX_ROWS / 2;

        this.jobInfo.add('searchResultsSize:' + searchResults.size());
        this.jobInfo.add('isAnotherBatchNeeded:' + this.isAnotherBatchNeeded);
        this.jobInfo.add('pageNumber: ' + String.valueOf(this.pageNumber));

        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        return searchResults;
    }

    // execute()
    //
    // Execute the batch job
    public void execute(
        Database.BatchableContext context,
        List<SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> searchResults)
    {
        System.debug(context.getJobId() + ' executing');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        if (searchResults.size() < 1 || null == searchResults)
        {
            return;
        }

        List<Product2> materialUpdates = new List<Product2>();
        List<Product2> materialInserts = new List<Product2>();
        List<PricebookEntry> pbEntryAll = new List<PricebookEntry>();
        List<PricebookEntry> pbEntryUpdates = new List<PricebookEntry>();
        List<PricebookEntry> pbEntryInserts = new List<PricebookEntry>();
        Pricebook2 standardPricebook = UTIL_Object_Lookups.getStandardPricebook();
        Pricebook2 customPricebook = UTIL_YetiSyncHelper.getCustomPricebook();
        this.custPriceBookId = customPricebook.Id;
        Map<String, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> existingMaterialSRMap = 
            new Map<String, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT>();
        Set<String> productIds = new Set<String>();

        Map<String, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> materialSyncMapInsert = createMaterialMap(searchResults);
        Map<String, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> materialSyncMapAll = createMaterialMap(searchResults);

        // Update existing records
        List<sObject> existingMaterialSObjects = UTIL_SyncHelper.getMatchingRecords('Product2', materialSyncMapAll.keySet());
        for (SObject existingMaterialSObject : existingMaterialSObjects)
        {
            Product2 existingMaterial = (Product2) existingMaterialSObject;
            String materialNumber = existingMaterial.Name;
            SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT sr = materialSyncMapAll.get(materialNumber);
            if (null != sr)
            {
                mapSrToProduct(existingMaterial, sr);
                materialUpdates.add(existingMaterial);
            }

            sr = materialSyncMapInsert.get(materialNumber);
            if (null != sr)
            {
                existingMaterialSRMap.put(materialNumber, sr);
                productIds.add(materialNumber);
                // Remove from map so we end up with a map that only has new results in it
                materialSyncMapInsert.remove(materialNumber);
            }
        }

        // Insert new record
        for (SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT sr : materialSyncMapInsert.values())
        {
            Product2 newProduct = new Product2();
            mapSrToProduct(newProduct, sr);
            materialInserts.add(newProduct);
        }

        // Update and Insert Products
        if (materialUpdates.size() > 0)
        {
            System.debug('Updating ' + materialUpdates.size() + ' Product2');
            upsert materialUpdates;
            pbEntryAll = getPricebookEntryByProducts(productIds);

            for (PricebookEntry pbEntry : pbEntryAll)
            {
                if (null != customPricebook)
                {
                    SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT sr = existingMaterialSRMap.get(pbEntry.Name);
                    if (pbEntry.Pricebook2Id == customPricebook.Id)
                    {
                        if (null != sr.Amount)
                        {
                            pbEntry.UnitPrice = sr.Amount;                            
                        }
                        pbEntry.IsActive = sr.Active == 'X' ? true : false;
                        pbEntryUpdates.add(pbEntry);

                    }
                }
            }

            for (Product2 material : materialUpdates)
            {
                Boolean foundStandard = false;
                Boolean foundCustom = false;
                for (PricebookEntry pbEntry : pbEntryAll)
                {
                    if (pbEntry.Product2Id == material.Id && pbEntry.Pricebook2Id == standardPricebook.Id)
                    {
                        foundStandard = true;
                    }
                    if (null != customPricebook && pbEntry.Product2Id == material.Id && pbEntry.Pricebook2Id == customPricebook.Id)
                    {
                        foundCustom = true;
                    }
                    if (foundStandard && foundCustom)
                    {
                        break;
                    }
                }

                if (!foundStandard)
                {
                    addPriceBook(materialSyncMapAll, standardPricebook, material, pbEntryInserts);
                }

                if (!foundCustom)
                {
                    addPriceBook(materialSyncMapAll, customPricebook, material, pbEntryInserts);
                }
            }
        }

        if (materialInserts.size() > 0)
        {
            System.debug('Inserting ' + materialInserts.size() + ' Product2');
            insert materialInserts;

            for (Product2 material : materialInserts)
            {
                addPriceBook(materialSyncMapAll, standardPricebook, material, pbEntryInserts);
                addPriceBook(materialSyncMapAll, customPricebook, material, pbEntryInserts);
            }
        }

        // Insert and Update Pricebook Entries
        if (pbEntryUpdates.size() > 0)
        {
            System.debug('Updating ' + pbEntryUpdates.size() + ' PricebookEntry');
            update pbEntryUpdates;
        }

        if (pbEntryInserts.size() > 0)
        {
            System.debug('Inserting ' + pbEntryInserts.size() + ' PricebookEntry');
            insert pbEntryInserts;
        }
    }

    private void addPriceBook(Map<String, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> materialSyncMap,
        Pricebook2 pricebook, Product2 material, List<PricebookEntry> pbEntryInserts)
    {

        if (null != pricebook)
        {
            SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT sr = materialSyncMap.get(material.Name);
            PricebookEntry pbEntry = new PricebookEntry();
            if (pricebook.Id == this.custPriceBookId)
            {
                pbEntry.IsActive = sr.Active == 'X' ? true : false;
            }
            pbEntry.Pricebook2Id = pricebook.Id;
            pbEntry.Product2Id = material.Id;
            pbEntry.UnitPrice = sr.Amount;
            pbEntry.UseStandardPrice = false;
            pbEntryInserts.add(pbEntry);
        }
    }

    // finish()
    //
    // queues up another batch when isAnotherBatchNeeded is true
    public void finish(Database.BatchableContext context)
    {
        this.pageNumber += 1;        // Move to the next page of results.
        System.debug(context.getJobId() + ' finished');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);
        UTIL_SyncHelper.launchAnotherBatchIfNeeded(
            this.isAnotherBatchNeeded, 'UTIL_MaterialSync_Schedule', String.valueOf(this.pageNumber));
    }

    // createMaterialMap()
    //
    // Create a map of Material and SearchResult
    private Map<String, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> createMaterialMap(
        List<SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> searchResults)
    {
        Map<String, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT> materialMap =
            new Map<String, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT>();

        for (SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT sr : searchResults)
        {
            materialMap.put(sr.Material, sr);
        }

        return materialMap;
    }

    // mapSrToProduct
    //
    // Map the searchResult field to the standard product field
    private void mapSrToProduct(Product2 prod, SBO_YetiDPMaterialPriceSync_Search.SEARCHRESULT sr)
    {
        prod.Name = sr.Material;
        prod.ProductCode = sr.Material;
        prod.Description = sr.MaterialDescription;
        //prod.IsActive = sr.Active == 'X' ? true : false;
        prod.ENSX_EDM__Material__c = sr.Material;
    }

    // getPricebookEntryByProducts()
    //
    // Get pricebook entries from Product Ids
    private List<PricebookEntry> getPricebookEntryByProducts(Set<String> productNumbers)
    {
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        try
        {
            pbEntries = Database.query('SELECT Id, Name, Product2Id, UnitPrice, Pricebook2Id FROM PricebookEntry WHERE Name IN :productNumbers');
        }
        catch (Exception ex)
        {
            System.debug(ex);
        }
        return pbEntries;
    }
}
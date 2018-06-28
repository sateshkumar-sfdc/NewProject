public with sharing class UTIL_AddressSync_Batch
    implements Database.Batchable<SBO_YetiAddressSync_Search.SEARCHRESULT>,
        Database.AllowsCallouts,
        Database.Stateful,
        I_ParameterizedSync
{
    // MAX_ROWS is a SBO parameter which controls the maximum sales header rows retrieved,
    //  however, there have been 2600+ detail records returned by a MAX_ROWS of 150
    //  because of sales orders with large numbers of lines.
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
    // In this case, we will store the largest change date/time as the param
    private String fromLastSync = null;

    public void setBatchParam(String value)
    {
        this.fromLastSync = value;
    }
    /* end I_ParameterizedSync methods */

    /* Database.Batchable methods start(), execute(), and finish() */
    // start()
    //
    // Calls SBO and returns search results of update sales orders
    public List<SBO_YetiAddressSync_Search.SEARCHRESULT> start(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' started');

        SBO_YetiAddressSync_Search sbo = new SBO_YetiAddressSync_Search();

        sbo.SearchContext.SEARCHPARAMS.MAX_ROWS = MAX_ROWS;

        Datetime lastSync = getLastSyncDate();
        if (null != lastSync)
        {
            sbo.SearchContext.SEARCHPARAMS.FromChangeDate = lastSync.date();
            sbo.SearchContext.SEARCHPARAMS.FromChangeTime = lastSync.time();
            this.jobInfo.add('from:' + lastSync.format('yyyy-MM-dd HH:mm:ss'));
        }
        else
        {
            this.jobInfo.add('starting from the beginning');
        }

        // Execute the search
        SBO_YetiAddressSync_Search.YetiAddressSync_SR result = sbo.execute();
        UTIL_SyncHelper.debugLogResultMessages(result.getMessages());
        if (!result.isSuccess())
        {
            System.debug('search failed');
            UTIL_SyncHelper.printJobInfo(this.jobInfo);
            return null;
        }

        List<SBO_YetiAddressSync_Search.SEARCHRESULT> searchResults = result.getResults();
        System.debug('search successfully retrieved ' + searchResults.size() + ' result records');

        // let finish() know to queue up another instance
        this.isAnotherBatchNeeded = searchResults.size() >= MAX_ROWS / 2;
        this.fromLastSync = getHighestLastChangeDateTimeInResultsForLastSync(searchResults);
        if (null != lastSync && null != this.fromLastSync)
        {
            Datetime searchLastSync = Datetime.newInstance(long.valueOf(this.fromLastSync));
            if (lastSync.getTime() == searchLastSync.getTime())
            {
                searchLastSync = searchLastSync.addSeconds(1);
                this.fromLastSync = String.valueOf(searchLastSync.getTime());
            }
        }

        this.jobInfo.add('searchResultsSize:' + searchResults.size());
        this.jobInfo.add('isAnotherBatchNeeded:' + this.isAnotherBatchNeeded);
        this.jobInfo.add(String.format('fromLastSync:{0}({1})', new List<String> {
            this.fromLastSync,
            this.fromLastSync == null ? null :
                Datetime.newInstance(long.valueOf(this.fromLastSync)).format('yyyy-MM-dd HH:mm:ss')
        }));

        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        return searchResults;
    }

    // execute()
    //
    // Given the updated search results, does the work of updating the account records
    public void execute(
        Database.BatchableContext context,
        List<SBO_YetiAddressSync_Search.SEARCHRESULT> searchResults)
    {
        System.debug(context.getJobId() + ' executing');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        if (null == searchResults || 0 == searchResults.size()){ return; }

        List<sObject> errors = new List<sObject>();
        List<Account> accountUpdates = new List<Account>();
        Set<String> customerIds = getCustomerIdsFromSearchResults(searchResults);
        Set<String> salesReps = getAllSalesReps(searchResults);
        Map<String, Set<Account>> accountMap = createAccountMap(customerIds);
        Map<String, User> userMap = createUserMap(salesReps);

        for (SBO_YetiAddressSync_Search.SEARCHRESULT sr : searchResults)
        {
            Set<Account> aSet = accountMap.get(sr.CustomerNumber);            
            if (null == aSet)
            {
                UTIL_SyncHelper.addLog(
                    errors,
                    'WARNING',
                    'Address Sync: No matching account for customer ' + sr.CustomerNumber
                );
                continue;
            }

            for (Account acct : aSet)
            {
                this.updateAccountFieldsFromSearchResult(acct, sr, userMap);
                accountUpdates.add(acct);
            }
        }

        if (accountUpdates.size() > 0)
        {
            update accountUpdates;
        }

        if (errors.size() > 0)
        {
            insert errors;
        }
    }

    // finish()
    //
    // queues up another batch when isAnotherBatchNeeded is true
    public void finish(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' finished');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);
        UTIL_SyncHelper.launchAnotherBatchIfNeeded(
           this.isAnotherBatchNeeded, 'UTIL_AddressSync_Schedule', this.fromLastSync);
    }
    /* end Database.Batchable methods */

    // getLastSyncDate()
    //
    // returns the Datetime we should sync back to
    private Datetime getLastSyncDate()
    {
        if (null != this.fromLastSync)
        {
            return Datetime.newInstance(long.valueOf(this.fromLastSync));
        }
        return null;
    }

    // getCustomerIdsFromSearchResults()
    //
    // returns a set of all the customer ids referenced in the SR
    private Set<String> getCustomerIdsFromSearchResults(
        List<SBO_YetiAddressSync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiAddressSync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.CustomerNumber))
            {
                result.add(sr.CustomerNumber);
            }
        }
        return result;
    }

    // getAllSalesReps
    //
    // Get all the sales reps from the searchResults
    private Set<String> getAllSalesReps(List<SBO_YetiAddressSync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiAddressSync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.InsideSalesRep))
            {
                result.add(sr.InsideSalesRep);
            }
            if (String.isNotBlank(sr.OutsideSalesRep))
            {
                result.add(sr.OutsideSalesRep);
            }
        }

        return result;
    }

    // createAccountMap()
    //
    // Looks up accounts for the given customer IDs and creates a map of customer -> accounts
    private Map<String, Set<Account>> createAccountMap(Set<String> customerIds)
    {
        Map<String, Set<Account>> result = new Map<String, Set<Account>>();
        List<Account> accounts = [SELECT Id, ENSX_EDM__SAP_Customer_Number__c
            FROM Account WHERE ENSX_EDM__SAP_Customer_Number__c IN :customerIds];
            
        for (Account account : accounts)
        {
            if (result.containsKey(account.ENSX_EDM__SAP_Customer_Number__c))
            {
                result.get(account.ENSX_EDM__SAP_Customer_Number__c).add(account);
            }
            else
            {
                result.put(account.ENSX_EDM__SAP_Customer_Number__c, new Set<Account>{ account });
            }
        }
        return result;
    }

    // createUserMap()
    //
    // Create a map of Sales Rep and User
    private Map<String, User> createUserMap(Set<String> salesReps)
    {
        Map<String, User> userMap = new Map<String, User>();
        List<User> users = null;
        try
        {
            users = [SELECT Id, SAP_Rep__c FROM User WHERE SAP_Rep__c IN :salesReps];
        }
        catch(Exception ex)
        {
            System.debug('Failed querying users: ' + ex);
        }

        if (null != users)
        {
            for (User usr : users)
            {
                if (!userMap.containsKey(usr.SAP_Rep__c))
                {
                    userMap.put(usr.SAP_Rep__c, usr);
                }
            }
        }

        return userMap;
    }

    private void updateAccountFieldsFromSearchResult(
        Account acct, SBO_YetiAddressSync_Search.SEARCHRESULT sr, Map<String, User> userMap)
    {
        String addr = sr.HouseNumber + ' ' + sr.Street;
        acct.ShippingStreet = addr.normalizeSpace();
        acct.ShippingPostalCode = sr.PostalCode;
        acct.ShippingCity = sr.City;
        acct.ShippingCountry = sr.Country;
        acct.ShippingState = sr.Region;
        acct.Inside_Sales_Rep__c = sr.InsideSalesRepName1 + ' ' + sr.InsideSalesRepName2;
        acct.Inside_Sales_Rep_Text__c = sr.InsideSalesRepName1 + ' ' + sr.InsideSalesRepName2;
        acct.Outside_Sales_Rep_Text__c = sr.OutsideSalesRepName1 + ' ' + sr.OutsideSalesRepName2;
        acct.Sales_Office__c = sr.SalesOffice;
        if (userMap.containsKey(sr.InsideSalesRep))
        {
            acct.Inside_SR__c = userMap.get(sr.InsideSalesRep).Id;
        }
        if (userMap.containsKey(sr.OutsideSalesRep))
        {
            acct.Outside_SR__c = userMap.get(sr.OutsideSalesRep).Id;
        }
        acct.SAP_Address_Sync_Time__c = Datetime.newInstance(sr.ChangeDate, sr.ChangeTime);
    }

    // getHighestLastChangeDateTimeInResultsForLastSync()
    //
    // Loops over all the results and returns the highest change timestamp as the number of
    // milliseconds since January 1, 1970, 00:00:00 GMT, which will be used as a search param on
    // the next batch execution.
    private String getHighestLastChangeDateTimeInResultsForLastSync(
        List<SBO_YetiAddressSync_Search.SEARCHRESULT> searchResults)
    {
        if (0 == searchResults.size())
        {
            return null;
        }
        Long result = 0;
        for (SBO_YetiAddressSync_Search.SEARCHRESULT sr : searchResults)
        {
            Long value = Datetime.newInstance(sr.ChangeDate, sr.ChangeTime).getTime();
            if (value > result)
            {
                result = value;
            }
        }
        return String.valueOf(result);
    }
}
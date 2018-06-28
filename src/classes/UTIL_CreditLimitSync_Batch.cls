public with sharing class UTIL_CreditLimitSync_Batch
    implements Database.Batchable<SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT>,
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
    // In this case, we will store the largest customer number as the param
    private String fromCustomerNumber = null;

    public void setBatchParam(String value)
    {
        this.fromCustomerNumber = value;
    }
    /* end I_ParameterizedSync methods */

    /* Database.Batchable methods start(), execute(), and finish() */
    // start()
    //
    // Calls SBO and returns search results of update sales orders
    public List<SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT> start(Database.BatchableContext context)
    {
        System.debug(context.getJobId() + ' started');

        SBO_YetiCustCreditLimitSync_Search sbo = new SBO_YetiCustCreditLimitSync_Search();

        sbo.SearchContext.SEARCHPARAMS.MAX_ROWS = MAX_ROWS;

        if (null != this.fromCustomerNumber)
        {
            sbo.SearchContext.SEARCHPARAMS.FromCustomerNumber = this.fromCustomerNumber;
            this.jobInfo.add('Credit limit sync starting from customer: ' + this.fromCustomerNumber);
        }
        else
        {
            this.jobInfo.add('no existing batch param - completely fresh start');
        }

        // Execute the search
        SBO_YetiCustCreditLimitSync_Search.YetiCustCreditLimitSync_SR result = sbo.execute();
        UTIL_SyncHelper.debugLogResultMessages(result.getMessages());
        if (!result.isSuccess())
        {
            System.debug('search failed');
            UTIL_SyncHelper.printJobInfo(this.jobInfo);
            return null;
        }

        List<SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT> searchResults = result.getResults();
        System.debug('search successfully retrieved ' + searchResults.size() + ' result records');

        // let finish() know to queue up another instance
        this.isAnotherBatchNeeded = searchResults.size() >= MAX_ROWS / 2;
        this.fromCustomerNumber = getHighestCustomerNumberInResults(searchResults);

        this.jobInfo.add('searchResultsSize:' + searchResults.size());
        this.jobInfo.add('isAnotherBatchNeeded:' + this.isAnotherBatchNeeded);

        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        return searchResults;
    }

    // execute()
    //
    // Given the updated search results, does the work of updating the account records
    public void execute(
        Database.BatchableContext context,
        List<SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT> searchResults)
    {
        System.debug(context.getJobId() + ' executing');
        UTIL_SyncHelper.printJobInfo(this.jobInfo);

        if (null == searchResults || 0 == searchResults.size())
            return;

        List<sObject> errors = new List<sObject>();
        List<Account> accountUpdates = new List<Account>();
        Set<String> customerIds = getCustomerIdsFromSearchResults(searchResults);
        Map<String, Set<Account>> accountMap = createAccountMap(customerIds);

        for (SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT sr : searchResults)
        {
            Set<Account> aSet = accountMap.get(sr.CustomerNumber);
            if (null == aSet)
            {
                UTIL_SyncHelper.addLog(
                    errors,
                    'WARNING',
                    'Credit Limit Sync: No matching account for customer ' + sr.CustomerNumber
                );
                continue;
            }

            for (Account a : aSet)
            {
                this.updateAccountFieldsFromSearchResult(a, sr);
                accountUpdates.add(a);
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
            this.isAnotherBatchNeeded, 'UTIL_CreditLimitSync_Schedule', this.fromCustomerNumber);
    }
    /* end Database.Batchable methods */

    // getCustomerIdsFromSearchResults()
    //
    // returns a set of all the customer ids referenced in the SR
    private Set<String> getCustomerIdsFromSearchResults(
        List<SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT> searchResults)
    {
        Set<String> result = new Set<String>();
        for (SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT sr : searchResults)
        {
            if (String.isNotBlank(sr.CustomerNumber))
            {
                result.add(sr.CustomerNumber);
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
        List<Account> accounts = [
            SELECT Id, ENSX_EDM__SAP_Customer_Number__c
            FROM Account
            WHERE ENSX_EDM__SAP_Customer_Number__c IN :customerIds
        ];
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

    // updateAccountFieldsFromSearchResult()
    //
    // Copies search result credit limit fields to the matching account record
    private void updateAccountFieldsFromSearchResult(
        Account a, SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT sr)
    {
        a.put('Limit__c', sr.CreditLimit);
        a.put('Credit_Exposure__c', sr.TotalCreditExposure);
        a.put('Credit_Exposure_Horizon__c', sr.HorizonExposure);
        a.put('Horizon_Date__c', sr.HorizonDate);
    }

    // getHighestCustomerNumberInResults()
    //
    // Loops over all the results and returns the highest customer number,
    // which will be used as a search param on the next batch execution
    private String getHighestCustomerNumberInResults(
        List<SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT> searchResults)
    {
        String result = '';
        for (SBO_YetiCustCreditLimitSync_Search.SEARCHRESULT sr : searchResults)
        {
            if (sr.CustomerNumber > result)
            {
                result = sr.CustomerNumber;
            }
        }
        return result;
    }
}
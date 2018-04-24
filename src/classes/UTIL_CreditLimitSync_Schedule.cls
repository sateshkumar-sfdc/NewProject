// The entire purpose of UTIL_CreditLimitSync_Schedule is to get UTIL_CreditLimitSync_Batch reliably
// into the Database.executeBatch queue.
public with sharing class UTIL_CreditLimitSync_Schedule implements Schedulable, I_ParameterizedSync
{
    private String batchParam = null;

    public UTIL_CreditLimitSync_Schedule() { }

    public UTIL_CreditLimitSync_Schedule(String param)
    {
        this.setBatchParam(param);
    }

    public void setBatchParam(String value)
    {
        this.batchParam = value;
    }

    public void execute(SchedulableContext sc)
    {
        /* Enable this block of code in the Developer Console to short-circuit a
        //   runaway batch that keeps scheduling itself.
        System.debug('pretending to schedule another instance');
        return;
        //*/

        UTIL_SyncHelper.executeBatch(
            'UTIL_CreditLimitSync_Batch', 'UTIL_CreditLimitSync_Schedule', batchParam);
    }
}
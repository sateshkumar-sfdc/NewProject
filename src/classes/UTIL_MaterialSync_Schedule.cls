// The entire purpose of UTIL_InvoiceSync_Schedule is to get UTIL_InvoiceSync_Batch reliably
// into the Database.executeBatch queue.
public with sharing class UTIL_MaterialSync_Schedule implements Schedulable, I_ParameterizedSync
{
    private String batchParam = null;

    public UTIL_MaterialSync_Schedule() { }

    public UTIL_MaterialSync_Schedule(String param)
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

        UTIL_SyncHelper.executeBatch('UTIL_MaterialSync_Batch', 'UTIL_MaterialSync_Schedule', batchParam);
    }
}
@isTest
public class TSTU_AllSync_Schedule
{
    @isTest public static void test_insertSchedule()
    {
        Set<Schedulable> syncSchedulables = new Set<Schedulable> {
            new UTIL_DeliverySync_Schedule(),
            new UTIL_InvoiceSync_Schedule(),
            new UTIL_SalesOrderSync_Schedule(),
            new UTIL_AddressSync_Schedule('0'),
            new UTIL_CreditLimitSync_Schedule('fake batch param')
        };
        Test.startTest();
        for (Schedulable syncInstance : syncSchedulables)
        {
            Datetime dt = Datetime.now().addMinutes(1);
            String timeForScheduler = dt.format('s m H d M \'?\' yyyy ');
            String schedId = System.Schedule(
                String.valueOf(syncInstance).split(':')[0] + 'RetryAfter' + timeForScheduler.trim(),
                timeForScheduler,
                syncInstance
            );
            // ID in API is 15 digits
            System.assertEquals(15, schedId.length());
        }
        Test.stopTest();
    }
}
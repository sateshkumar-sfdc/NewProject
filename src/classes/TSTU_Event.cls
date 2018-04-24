@IsTest
private class TSTU_Event
{
    @isTest
    public static void test_registerEvent()
    {
        Test.startTest();
        String eventName = 'TestEntity.TestAction';
        TestEventHandler te1 = new TestEventHandler();
        UTIL_Event.registerEventHandler(eventName, te1);
        System.assert(UTIL_Event.getEnosixEventHandlerByName(eventName) != null);
        System.assert(UTIL_Event.isEnosixEventHandlerRegistered(eventName));
        UTIL_Event.registerEventHandler(null, null);
        Test.stopTest();
    }

    @isTest
    public static void test_populateEventHandlersSuccess()
    {
        String eventName = 'TEST';
        UTIL_AppSettings.resourceJson = '{"Event.Handlers":{"TEST":"TSTU_Event.TestEventHandler"}}';

        Test.startTest();
        // Instantiation triggers the static {} block to run which fires populateEventHandlers()
        new UTIL_Event();
        Test.stopTest();

        System.assert(UTIL_Event.getEnosixEventHandlerByName(eventName) != null);
        System.assert(UTIL_Event.isEnosixEventHandlerRegistered(eventName));
    }

    // These two exception tests have to be separate because once the JSON is deserialized by
    // AppSettings, changed JSON won't be re-read
    @isTest
    public static void test_populateEventHandlersNotTypeException()
    {
        UTIL_AppSettings.resourceJson = '{"Event.Handlers":{"TEST":"TSTU_Event.TestEventHandler",' +
            '"TEST_EXCEPTION":"NotRealEventHandler"}}';
        Boolean isException = false;

        Test.startTest();
        try
        {
            // Instantiation triggers the static {} block to run which fires populateEventHandlers()
            new UTIL_Event();
        }
        catch (UTIL_Event.EventConfigurationException ex)
        {
            isException = true;
        }
        Test.stopTest();

        System.assert(isException == true, 'populateEventHandlers() did not throw');
    }

    @isTest
    public static void test_populateEventHandlersNotEventHandlerException()
    {
        UTIL_AppSettings.resourceJson = '{"Event.Handlers":{"TEST":"TSTU_Event.TestEventHandler",' +
            '"TEST_EXCEPTION":"Account"}}';
        Boolean isException = false;

        Test.startTest();
        try
        {
            // Instantiation triggers the static {} block to run which fires populateEventHandlers()
            new UTIL_Event();
        }
        catch (UTIL_Event.EventConfigurationException ex)
        {
            isException = true;
        }
        Test.stopTest();

        System.assert(isException == true, 'populateEventHandlers() did not throw');
    }

    @isTest
    public static void test_executeEvent()
    {
        Test.startTest();
        //register event
        String eventName = 'TestEntity.TestAction';
        String eventName2 = 'TestEntity2.TestAction';
        TestEventHandler te1 = new TestEventHandler();
        UTIL_Event.registerEventHandler(eventName, te1);
        TestEventHandler te2 = new TestEventHandler();
        UTIL_Event.registerEventHandler(eventName2, te2);
        //execute event
        Map<String, object> params = new Map<String, object>();
        params.put(te1.executionKey, 0);
        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(eventName, params);

        System.assert(result.isSuccess == true);
        System.assert((Integer) params.get(te1.executionKey) == 1);
        Test.stopTest();
    }

    @isTest
    public static void test_executeExceptionEvent()
    {
        Test.startTest();
        //register event
        String eventName = 'TestExeption';
        TestExceptionEventHandler te1 = new TestExceptionEventHandler();
        UTIL_Event.registerEventHandler(eventName, te1);
        //execute event
        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(eventName, null);
        System.assert(result.isSuccess == false);
        System.assert(result.capturedException != null);
        Test.stopTest();
    }

    @isTest
    public static void test_executeEventWithoutHandler()
    {
        Test.startTest();
        String eventName = 'TestEventWithoutHandler';
        System.assert(UTIL_Event.getEnosixEventHandlerByName(eventName) == null);
        System.assert(!UTIL_Event.isEnosixEventHandlerRegistered(eventName));
        //execute event
        UTIL_Event.EnosixEventResult result = UTIL_Event.executeEvent(eventName, null);
        System.assert(result.isSuccess == true);
        Test.stopTest();
    }

    public class TestEventHandler implements I_EventHandler
    {
        public final String executionKey = 'testExecutionRan';
        public Integer eventFired { get; set; }
        public TestEventHandler()
        {
            this.eventFired = 0;
        }
        public void run(Map<string, object> parameter)
        {
            //do something special with parameter
            this.eventFired++;
            if (parameter == null)
            {
                parameter = new Map<String, object>();
            }
            parameter.put(executionKey, this.eventFired);
        }
    }

    public class TestExceptionEventHandler implements I_EventHandler
    {
        public void run(Map<string, object> parameter)
        {
            throw new TSTU_Event.TestException();
        }
    }

    public class TestException extends Exception
    {

    }
}
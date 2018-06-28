public with sharing class UTIL_Event
{
    public static final String CUSTOMER_CREATED = 'CUSTOMER_CREATED';
    public static final String CUSTOMER_INITIALIZED = 'CUSTOMER_INITIALIZED';
    public static final String CUSTOMER_INITIALIZING = 'CUSTOMER_INITIALIZING';
    public static final String CUSTOMER_LINKED = 'CUSTOMER_LINKED';
    public static final String CUSTOMER_UPDATED = 'CUSTOMER_UPDATED';
    public static final String DELIVERY_INITIALIZED = 'DELIVERY_INITIALIZED';
    public static final String DELIVERY_INITIALIZING = 'DELIVERY_INITIALIZING';
    public static final String DELIVERY_CREATED = 'DELIVERY_CREATED';
    public static final String DELIVERY_UPDATED = 'DELIVERY_UPDATED';
    public static final String MATERIAL_INITIALIZED = 'MATERIAL_INITIALIZED';
    public static final String MATERIAL_INITIALIZING = 'MATERIAL_INITIALIZING';
    public static final String MATERIAL_CREATED = 'MATERIAL_CREATED';
    public static final String MATERIAL_UPDATED = 'MATERIAL_UPDATED';
    public static final String INVOICE_INITIALIZED = 'INVOICE_INITIALIZED';
    public static final String INVOICE_INITIALIZING = 'INVOICE_INITIALIZING';
    public static final String INVOICE_CREATED = 'INVOICE_CREATED';
    public static final String INVOICE_UPDATED = 'INVOICE_UPDATED';
    public static final String OPPORTUNITY_QUOTEPRICING_INITIALIZED = 'OPPORTUNITY_QUOTEPRICING_INITIALIZED';
    public static final String OPPORTUNITY_QUOTEPRICING_INITIALIZING = 'OPPORTUNITY_QUOTEPRICING_INITIALIZING';
    public static final String OPPORTUNITY_QUOTEPRICING_CREATED = 'OPPORTUNITY_QUOTEPRICING_CREATED';
    public static final String OPPORTUNITY_QUOTEPRICING_UPDATED = 'OPPORTUNITY_QUOTEPRICING_UPDATED';
    public static final String ORDER_INITIALIZED = 'ORDER_INITIALIZED';
    public static final String ORDER_INITIALIZING = 'ORDER_INITIALIZING';
    public static final String PARTNER_ADDED = 'PARTNER_ADDED';
    public static final String ORDER_CREATED = 'ORDER_CREATED';
    public static final String ORDER_UPDATED = 'ORDER_UPDATED';
    public static final String QUOTE_INITIALIZED = 'QUOTE_INITIALIZED';
    public static final String QUOTE_INITIALIZING = 'QUOTE_INITIALIZING';
    public static final String QUOTE_CREATED = 'QUOTE_CREATED';
    public static final String QUOTE_UPDATED = 'QUOTE_UPDATED';
    public static final String RETURN_ORDER_INITIALIZED = 'RETURN_ORDER_INITIALIZED';
    public static final String RETURN_ORDER_INITIALIZING = 'RETURN_ORDER_INITIALIZING';
    public static final String RETURN_ORDER_CREATED = 'RETURN_ORDER_CREATED';
    public static final String RETURN_ORDER_UPDATED = 'RETURN_ORDER_UPDATED';
    public static final String STOCK_LIST_INITIALIZED = 'STOCK_LIST_INITIALIZED';
    public static final String STOCK_LIST_INITIALIZING = 'STOCK_LIST_INITIALIZING';
    public static final String STOCK_LIST_CREATED = 'STOCK_LIST_CREATED';
    public static final String STOCK_LIST_UPDATED = 'STOCK_LIST_UPDATED';

    static
    {
        UTIL_Event.subscribedEventHandlers = new Map<String, I_EventHandler>();
        UTIL_Event.populateEventHandlers();
    }

    public static Map<String, I_EventHandler> subscribedEventHandlers { get; set; }

    public class EnosixEventResult
    {
        public Exception capturedException { get; set; }
        public Boolean isSuccess { get {return capturedException == null;} }
    }

    public static Boolean isEnosixEventHandlerRegistered(String eventName)
    {
        return null != UTIL_Event.getEnosixEventHandlerByName(eventName);
    }

    public static UTIL_Event.EnosixEventResult executeEvent(string eventName, Map<String, object> context)
    {
        UTIL_Event.EnosixEventResult eventResult = new UTIL_Event.EnosixEventResult();
        try
        {
            I_EventHandler evnt = getEnosixEventHandlerByName(eventName);
            if (evnt != null)
            {
                if (null == context)
                {
                    context = new Map<String, object>();
                }
                context.put('EventName', eventName);
                evnt.run(context);
            }
        }
        catch (Exception e)
        {
            System.debug('There was an issue executing the ' + eventName + ' event: ' + e.getMessage());
            eventResult.capturedException = e;
        }
        if (!eventResult.isSuccess)
        {
            ApexPages.addMessage(new Apexpages.Message(
                ApexPages.Severity.ERROR,
                eventName + ' event: ' + eventResult.capturedException.getMessage()
            ));
        }
        return eventResult;
    }

    public static I_EventHandler getEnosixEventHandlerByName(String eventName)
    {
        return subscribedEventHandlers.get(eventName);
    }

    public static void registerEventHandler(String eventName, I_EventHandler eventHandlerToRegister)
    {
        subscribedEventHandlers.put(eventName, eventHandlerToRegister);
    }

    // populateEventHandlers()
    //
    // Gets map of event name -> handler type name from App Settings and registers each handler
    // Throws an exception if any of the type names are invalid I_EventHandlers.
    private static void populateEventHandlers()
    {
        Map<String, String> handlers = (Map<String, String>)UTIL_AppSettings.getMap(
            'Event.Handlers', String.class, String.class, new Map<String, String>());

        for (String event: handlers.keySet())
        {
            String handlerType = handlers.get(event);
            Type t = Type.forName(handlerType);

            if (null == t)
            {
                throw new EventConfigurationException('AppSettings configuration error: ' +
                    handlerType + ' is not a valid type.');
            }

            Object handler = t.newInstance();
            if (handler instanceof I_EventHandler)
            {
                UTIL_Event.registerEventHandler(event, (I_EventHandler)handler);
            }
            else
            {
                throw new EventConfigurationException('AppSettings configuration error: ' +
                    handlerType + ' is not a valid event handler.');
            }
        }
    }

    public class EventConfigurationException extends Exception {}
}
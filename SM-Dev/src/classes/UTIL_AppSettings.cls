// UTIL_AppSettings - Class to manage customer configuration settings
//
// To override system defaults, add an AppSettings.json file in the root folder
// of the customer child project
public virtual class UTIL_AppSettings
{
    static final string SETTINGS_JSON_RESOURCE = 'EnsxAppSettings';

    @testVisible
    private static Map<String, Boolean> hasBeenRetyped = new Map<String, Boolean>();

    // getValue()
    //
    // Get a setting by key, with a default value in case the setting was never set
    //
    // Use this for primitive settings like Integer, Decimal, String, Boolean
    // If you have a complex type like a list, use getList(), getSet(), or getMap()
    //
    // You need to cast the output to the expected type.
    // Example:
    //      String s = (String)UTIL_AppSettings.getValue('s', 'not set');
    public static Object getValue(String key, Object defaultValue)
    {
        return UTIL_AppSettings.getTypedValue(key, Object.class, defaultValue);
    }

    // getValue()
    //
    // Get primitive setting with a default of null
    public static Object getValue(String key)
    {
        return UTIL_AppSettings.getValue(key, null);
    }


    // getList()
    //
    // Get a list setting by key with the given list type and default value
    //
    // Example:
    //    List<Boolean> bools =
    //        (List<Boolean>)UTIL_AppSettings.getList('bools', Boolean.class, new Boolean[]);
    public static Object getList(String key, Type itemType, Object defaultValue)
    {
        Type collectionType = Type.forName('List<' + itemType.getName() + '>');
        return UTIL_AppSettings.getTypedValue(key, collectionType, defaultValue);
    }

    // getList()
    //
    // Get a list setting with default of null
    public static Object getList(String key, Type itemType)
    {
        return UTIL_AppSettings.getList(key, itemType, null);
    }


    // getSet()
    //
    // Get a set setting by key with the given set type and default value
    //
    // Example:
    //    Set<String> stringSet =
    //        (Set<String>)UTIL_AppSettings.getList('strings', String.class, new String[]);
    public static Object getSet(String key, Type itemType, Object defaultValue)
    {
        Type collectionType = Type.forName('Set<' + itemType.getName() + '>');
        return UTIL_AppSettings.getTypedValue(key, collectionType, defaultValue);
    }

    // getSet()
    //
    // Get a set setting with default of null
    public static Object getSet(String key, Type itemType)
    {
        return UTIL_AppSettings.getSet(key, itemType, null);
    }


    // getMap()
    //
    // Get a map settings by key with the given key and item types and a default value
    //
    // Example:
    //     Map<String, Boolean> defaultBools = new Map<String, Boolean>{
    //        'b1' => true,
    //        'b2' => false
    //     };
    //     Map<String, Boolean> namedBools = (Map<String, Boolean>)UTIL_AppSettings.getMap(
    //         'namedBools', String.class, Boolean.class, defaultBools)
    public static Object getMap(String key, Type keyType, Type itemType, Object defaultValue)
    {
        Type collectionType = Type.forName('Map<' + keyType.getName() + ',' + itemType.getName() + '>');
        return UTIL_AppSettings.getTypedValue(key, collectionType, defaultValue);
    }

    // getMap()
    //
    // Get a map setting with default of null
    public static Object getMap(String key, Type keyType, Type itemType)
    {
        return UTIL_AppSettings.getMap(key, keyType, itemType, null);
    }


    // getSObject()
    //
    // Get an sObject setting by key with the given type and default value
    //
    // Example:
    //     Account acc =
    //         (Account)UTIL_AppSettings.getSObject('account', Account.type, new Account());
    public static Object getSObject(String key, Type outputType, Object defaultValue)
    {
        return UTIL_AppSettings.getTypedValue(key, outputType, defaultValue);
    }

    // getSObject()
    //
    // Get an sObject setting with default of null
    public static Object getSObject(String key, Type outputType)
    {
        return UTIL_AppSettings.getSObject(key, outputType, null);
    }


    // getInstance()
    //
    // Get a type name by key and return an instance of that type, or the default type specified
    //
    // Example:
    //    OptionBuilder builder = (OptionBuilder)UTIL_AppSettings.getInstance(
    //        'UTIL_YetiBuilders.YetiPartnerOptionBuilder', UTIL_Order.PartnerOptionBuilder.class);
    public static Object getInstance(String key, Type defaultType)
    {
        Type resultType = defaultType;
        String typeName = (String)UTIL_AppSettings.getValue(key);
        if (null != typeName)
        {
            resultType = Type.forName(typeName);
        }
        return resultType.newInstance();
    }


    // getTypedValue()
    //
    // Underlying implementation of getValue(), getList(), getSet(), and getMap()
    // Returns setting for key with the given default converted to the desired outputType
    private static Object getTypedValue(String key, Type outputType, Object defaultValue)
    {
        Object result = defaultValue;
        if (UTIL_AppSettings.settings.containsKey(key))
        {
            result = UTIL_AppSettings.settings.get(key);

            // If the object in the map is too generic, re-type it
            // More explicitly -
            // if
            //   result has a value
            // AND
            //   The desired output type is not Object (no need to re-type)
            // AND
            //   The map item hasn't been re-typed already
            if (result != null && Object.class != outputType && true != hasBeenRetyped.get(key))
            {
                result = UTIL_AppSettings.retype(key, result, outputType);
            }
        }
        return result;
    }

    // Gets settings from json file and saves map for re-use
    private static Map<String, Object> settings
    {
        get
        {
            // Only deserialize the file once
            if (null == settings)
            {
                settings = (Map<String, Object>)JSON.deserializeUntyped(resourceJson);
            }
            return settings;
        }
    }

    // This is a property so that it can be "mocked" in the tests
    @testVisible
    private static String resourceJson
    {
        get
        {
            // If resourceJson is null, read it in from the resource file.
            // If the file doesn't exist, return '{}' representing an empty JSON object
            if (null == resourceJson)
            {
                resourceJson = UTIL_StaticResource.getStringResourceContents(SETTINGS_JSON_RESOURCE);
                if (null == resourceJson)
                {
                    resourceJson = '{}';
                }
            }
            return resourceJson;
        }
        set;
    }

    // retype()
    //
    // Up-converts the given value/collection to the outputType, and stores it back into the
    // settings map.
    //
    // This is needed because the JSON.deserialize() method will bring in lists or other collections
    // from the JSON file as List<Object> when we will typically want List<String> or something
    // else specific, and you cannot just cast List<Object> to List<String>
    private static Object retype(String key, Object value, Type outputType)
    {
        // Let the built-in Apex deserialize() do the hard conversion work for us
        String temp = JSON.serialize(value);
        Object result = JSON.deserialize(temp, outputType);

        // Put it back in the map so we don't have to re-do this later
        UTIL_AppSettings.settings.put(key, result);
        UTIL_AppSettings.hasBeenRetyped.put(key, true);

        return result;
    }
}
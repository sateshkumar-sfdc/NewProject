public class UTIL_StaticResource
{
    // getResourceUrl()
    //
    // Return url path for the given resource name
    public static String getResourceUrl(string resource)
    {
        StaticResource sr = [
            SELECT Id, NamespacePrefix, SystemModstamp
            FROM StaticResource
            WHERE Name = :resource LIMIT 1
        ];

        String prefix = sr.NamespacePrefix;
        if (String.isEmpty(prefix))
        {
            prefix = '';
        }
        else
        {
            // If has NamespacePrefix
            prefix += '__';
        }

        return '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + resource + '/';
    }

    // getStringResourceContents()
    //
    // Returns the resource body as a string, or null if the resource isn't found
    public static String getStringResourceContents(String resource)
    {
        String result = null;

        List<StaticResource> resources = [
            SELECT Body FROM StaticResource
            WHERE Name = :resource LIMIT 1
        ];

        if (resources.size() > 0)
        {
            result = resources.get(0).Body.toString();            
        }

        return result;
    }
}
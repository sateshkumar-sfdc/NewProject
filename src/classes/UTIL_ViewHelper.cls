public with sharing class UTIL_ViewHelper {
    public static void sortOptionsByLabel(List<SelectOption> options) {
        Map<String, SelectOption> optionMapByLabel = new Map<String, SelectOption>();
        // Suffix to avoid issue with duplicate labels
        Integer suffix = 1;
        for (SelectOption opt : options) {
            optionMapByLabel.put(opt.getLabel() + suffix++, opt);
        }

        List<String> sortKeys = new List<String>();
        sortKeys.addAll(optionMapByLabel.keySet());
        sortKeys.sort();

        // clear the original collection to rebuilt it
        options.clear();
        for (String key : sortKeys) {
            options.add(optionMapByLabel.get(key));
        }
    }

    public static string pickFirst(List<SelectOption> options) {
        if (options.size() <= 0) return '';
        SelectOption firstOption = options.get(0);
        if (null != firstOption) {
            return firstOption.getValue();
        }
        return '';
    }

    public static string getLabelForSelectOptionValue(List<SelectOption> selectOptions, String val)
    {
        for (SelectOption so : selectOptions)
        {
            if (so.getValue() == val)
            {
                return so.getLabel();
            }
        }
        return '';
    }

    public static string getValueForSelectOptionLabel(List<SelectOption> selectOptions, String label)
    {
        for (SelectOption so : selectOptions)
        {
            if (so.getLabel() == label)
            {
                return so.getValue();
            }
        }
        return '';
    }

    // getValueForSelectOptionByValueOrLabel()
    //
    // Find a matching select option. First search for a matching value,
    // then if not found, search for a matching label.
    //
    // Returns the value of the option no matter how the match is found.
    // Returns '' if no match is found
    public static string getValueForSelectOptionByValueOrLabel(
        List<SelectOption> selectOptions, String lookup)
    {
        for (SelectOption so : selectOptions)
        {
            if (so.getValue() == lookup)
            {
                return so.getValue();
            }
        }
        for (SelectOption so : selectOptions)
        {
            if (so.getLabel() == lookup)
            {
                return so.getValue();
            }
        }
        return '';
    }

    public static boolean validateStringPropertyIsNotBlank(string property, string propertyName) {
        boolean isValid = true;
        if (string.isBlank(property)) {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, propertyName + ' is required'));
            system.debug(string.format('Validation error on property: {0}, value was: {1}', new String[]{
                    propertyName, property
            }));
            isValid = false;
        }
        return isValid;
    }

    /* Adds a SelectOption to the list if the option value is no present */
    public static void addSelectOption(List<SelectOption> selectOptions, SelectOption selectOption) {
        if (null == selectOptions || null == selectOption) return;
        String selectValue = selectOption.getValue();
        for (SelectOption so : selectOptions) {
            if (so.getValue() == selectValue)
                return;
        }
        selectOptions.add(selectOption);
    }

    @testVisible
    //This method does nothing beyond connactenating a phone number with x and an extension if it exists.
    //This *does not* try and do any standard formatting or validation that the number is actually valid.
    public static string formatPhoneForDisplay(string phoneNumber, string extension)
    {
        string formattedPhone = '';
        if(null != phoneNumber)
            formattedPhone += phoneNumber;
        if(string.isNotBlank(extension))
            formattedPhone += ' x' + extension;
        return formattedPhone;
    }
}
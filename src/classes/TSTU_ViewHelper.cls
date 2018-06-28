@isTest
public with sharing class TSTU_ViewHelper
{
    @isTest
    public static void testAddSelectOption()
    {
        Test.startTest();
        List<SelectOption> selectOptions = new List<SelectOption>();
        selectOptions.add(new SelectOption('A', 'Item A'));
        selectOptions.add(new SelectOption('B', 'Item B'));
        selectOptions.add(new SelectOption('C', 'Item C'));
        final Integer sizeBeforeAddingE = selectOptions.size();
        System.assertEquals(sizeBeforeAddingE, 3);
        UTIL_ViewHelper.addSelectOption(selectOptions, new SelectOption('E', 'Item E'));
        final Integer sizeAfterAddingFirstE = selectOptions.size();
        System.assertEquals(sizeAfterAddingFirstE, 4);
        System.assertNotEquals(sizeBeforeAddingE, sizeAfterAddingFirstE);
        //add the same item, should not add duplicates
        UTIL_ViewHelper.addSelectOption(selectOptions, new SelectOption('E', 'Item E'));
        System.assertEquals(sizeAfterAddingFirstE, selectOptions.size());
        Test.stopTest();
    }

    @isTest
    public static void testSortListByLabel()
    {
        Test.startTest();
        List<SelectOption> selectOptions = new List<SelectOption>();
        selectOptions.add(new SelectOption('A', 'Item A'));
        selectOptions.add(new SelectOption('B', 'Item B'));
        selectOptions.add(new SelectOption('C', 'Item C'));
        selectOptions.add(new SelectOption('E', 'Item E'));
        SelectOption selectOption = new SelectOption('D', 'Item D');
        selectOptions.add(selectOption);
        UTIL_ViewHelper.sortOptionsByLabel(selectOptions);
        SelectOption lastSelectOption = selectOptions.get(selectOptions.size() - 1);
        System.assertNotEquals(selectOption.getValue(), lastSelectOption.getValue());
        Test.stopTest();
    }

    @isTest
    public static void testFormatPhone()
    {
        Test.startTest();
        string formatted = UTIL_ViewHelper.formatPhoneForDisplay('123','99');
        System.assertEquals('123 x99', formatted);
        Test.stopTest();
    }

    @isTest
    public static void testPickFirst()
    {
        Test.startTest();
        SelectOption testOption = null;
        String formatted = UTIL_ViewHelper.pickFirst(new List<SelectOption> {new SelectOption ('value', 'label')});
        formatted = UTIL_ViewHelper.pickFirst(new List<SelectOption> {testOption});
        Test.stopTest();
    }

    @isTest
    public static void testGetLabelForSelectOptionValue()
    {
        Test.startTest();
        String formatted = UTIL_ViewHelper.getLabelForSelectOptionValue(new List<SelectOption>{},'');
        formatted = UTIL_ViewHelper.getLabelForSelectOptionValue(new List<SelectOption> {new SelectOption ('value', 'label')}, 'value');
        Test.stopTest();
    }

    @isTest
    public static void testGetValueForSelectOptionByValueOrLabel()
    {
        Test.startTest();
        String formatted = UTIL_ViewHelper.getValueForSelectOptionLabel(new List<SelectOption>{},'');
        formatted = UTIL_ViewHelper.getValueForSelectOptionLabel(new List<SelectOption> {new SelectOption ('value', 'label')}, 'label');
        formatted = UTIL_ViewHelper.getValueForSelectOptionByValueOrLabel(new List<SelectOption>{},'');
        formatted = UTIL_ViewHelper.getValueForSelectOptionByValueOrLabel(new List<SelectOption> {new SelectOption ('value', 'label')}, 'label');
        formatted = UTIL_ViewHelper.getValueForSelectOptionByValueOrLabel(new List<SelectOption> {new SelectOption ('value', 'label')}, 'value');
        Test.stopTest();
    }

    @isTest
    public static void testValidateStringPropertyIsNotBlank()
    {
        Test.startTest();
        UTIL_ViewHelper.validateStringPropertyIsNotBlank('', '');
        UTIL_ViewHelper.validateStringPropertyIsNotBlank('property', 'property name');
        Test.stopTest();
    }
}
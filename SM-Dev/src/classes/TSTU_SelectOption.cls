@isTest
public class TSTU_SelectOption
{
    class OptionBuilder_buildOptionsFromList_value extends UTIL_SelectOption.OptionBuilder
    {
        public override string getItemValue(object item)
        {
            return 'value';
        }
    }

    @isTest
    public static void test_buildOptionsFromList_value()
    {
        Test.startTest();
        List<SelectOption> result = UTIL_SelectOption.buildOptionsFromList(
            new OptionBuilder_buildOptionsFromList_value(), new Integer[] { 1, 2 }
        );
        Test.stopTest();

        System.assertEquals(2, result.size());
        for (SelectOption item : result)
        {
            System.assertEquals('value', item.getValue());
        }
    }


    class OptionBuilder_buildOptionsFromList_description extends UTIL_SelectOption.OptionBuilder
    {
        public override string getItemDescription(object item)
        {
            return 'description';
        }
        public override string getItemLabel(object item)
        {
            return getItemDescription(item);
        }
    }

    @isTest
    public static void test_buildOptionsFromList_description()
    {
        Test.startTest();
        List<SelectOption> result = UTIL_SelectOption.buildOptionsFromList(
            new OptionBuilder_buildOptionsFromList_description(), new Integer[] { 1, 2 }
        );
        Test.stopTest();

        System.assertEquals(2, result.size());
        for (SelectOption item : result)
        {
            System.assertEquals('description', item.getLabel());
        }
    }


    class OptionBuilder_buildOptionsFromList_label extends UTIL_SelectOption.OptionBuilder
    {
        public override string getItemValue(object item)
        {
            return 'value';
        }
        public override string getItemDescription(object item)
        {
            return 'description';
        }
    }

    @isTest
    public static void test_buildOptionsFromList_label()
    {
        Test.startTest();
        List<SelectOption> result = UTIL_SelectOption.buildOptionsFromList(
            new OptionBuilder_buildOptionsFromList_label(), new Integer[] { 1, 2, 3 }
        );
        Test.stopTest();

        System.assertEquals(3, result.size());
        for (SelectOption item : result)
        {
            System.assertEquals('value - description', item.getLabel());
        }
    }


    class OptionBuilder_buildOptionsFromList_filter extends UTIL_SelectOption.OptionBuilder
    {
        public override boolean isItemDisplayed(object item)
        {
            return false;
        }
    }

    @isTest
    public static void test_buildOptionsFromList_filter()
    {
        Test.startTest();
        List<SelectOption> result = UTIL_SelectOption.buildOptionsFromList(
            new OptionBuilder_buildOptionsFromList_filter(), new Integer[] { 1, 2 }
        );
        Test.stopTest();

        System.assertEquals(0, result.size());
    }


    @isTest
    public static void test_getOptionsByUniqueValue()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'label1_1'));
        options.add(new SelectOption('1', 'label1_2'));
        options.add(new SelectOption('2', 'label2'));

        Test.startTest();
        List<SelectOption> result = UTIL_SelectOption.getOptionsByUniqueValue(options);
        Test.stopTest();

        System.assertEquals(2, result.size());
        System.assertEquals('1', result.get(0).getValue());
        System.assertEquals('label1_1', result.get(0).getLabel());
        System.assertEquals('2', result.get(1).getValue());
        System.assertEquals('label2', result.get(1).getLabel());
    }

    @isTest
    public static void test_getOptionsByUniqueLabel()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'label1'));
        options.add(new SelectOption('2', 'label2'));
        options.add(new SelectOption('3', 'label2'));
        options.add(new SelectOption('4', 'label4'));

        Test.startTest();
        List<SelectOption> result = UTIL_SelectOption.getOptionsByUniqueLabel(options);
        Test.stopTest();

        System.assertEquals(3, result.size());
        System.assertEquals('1', result.get(0).getValue());
        System.assertEquals('label1', result.get(0).getLabel());
        System.assertEquals('2', result.get(1).getValue());
        System.assertEquals('label2', result.get(1).getLabel());
        System.assertEquals('4', result.get(2).getValue());
        System.assertEquals('label4', result.get(2).getLabel());
    }

    @isTest
    public static void test_getUniqueOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'label1'));
        options.add(new SelectOption('1', 'label1'));
        options.add(new SelectOption('2', 'label1'));
        options.add(new SelectOption('2', 'label2'));
        options.add(new SelectOption('2', 'label2'));
        options.add(new SelectOption('2', 'label2_2'));
        options.add(new SelectOption('X', 'YZ'));
        options.add(new SelectOption('XY', 'Z'));
        options.add(new SelectOption('A', 'labelA'));
        options.add(new SelectOption('A', 'labelA'));

        Test.startTest();
        List<SelectOption> result = UTIL_SelectOption.getUniqueOptions(options);
        Test.stopTest();

        System.assertEquals(7, result.size());
        System.assertEquals('1', result.get(0).getValue());
        System.assertEquals('label1', result.get(0).getLabel());

        System.assertEquals('2', result.get(1).getValue());
        System.assertEquals('label1', result.get(1).getLabel());

        System.assertEquals('2', result.get(2).getValue());
        System.assertEquals('label2', result.get(2).getLabel());

        System.assertEquals('2', result.get(3).getValue());
        System.assertEquals('label2_2', result.get(3).getLabel());

        System.assertEquals('X', result.get(4).getValue());
        System.assertEquals('YZ', result.get(4).getLabel());

        System.assertEquals('XY', result.get(5).getValue());
        System.assertEquals('Z', result.get(5).getLabel());

        System.assertEquals('A', result.get(6).getValue());
        System.assertEquals('labelA', result.get(6).getLabel());
    }
}
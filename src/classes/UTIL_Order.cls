public with sharing class UTIL_Order {

    public static final string SOLD_TO_PARTNER_CODE = 'SP';
    public static final string SHIP_TO_PARTNER_CODE = 'SH';
    public static final string CARRIER_PARTNER_CODE = 'CR';
    public static String formatSAPDateStringToReadableFormat(String sapDate)
    {
        String returnDateString = '';
        if (!String.isEmpty(sapDate) && sapDate.length() == 8)
        {
            String month = sapDate.subString(4, 6);
            String day = sapDate.subString(6, 8);
            String year = sapDate.subString(0, 4);
            returnDateString = month + '/' + day + '/' + year;
        }
        return returnDateString;
    }

    public static string formatReadableDateToSAPString(string readableDate)
    {
        String returnDateString = '';

        if (!String.isEmpty(readableDate) && readableDate.length() == 10)
        {
            String month = readableDate.subString(0, 2);
            String day = readableDate.subString(3, 5);
            String year = readableDate.subString(6);
            returnDateString = year + month + day;
        }

        return returnDateString;
    }

    public class OrderItem {
        public SBO_EnosixSO_Detail.ITEMS item { get; private set; }
        public SBO_EnosixSO_Detail.ITEMS_SCHEDULE maxItemSchedule { get; private set; }

        public String FormattedScheduleLineDate
        {
            get
            {
                return formatSAPDateStringToReadableFormat(this.item.ScheduleLineDate);
            }
        }


        public Date convertedItemDate
        {
            get
            {
                if (null == this.item || string.isEmpty(this.item.ScheduleLineDate)) {
                    return null;
                }

                // Only convert if the string appears to be in the correct starting format: MM/dd/yyyy
                if (this.item.ScheduleLineDate.contains('/') && 10 == this.item.ScheduleLineDate.length())
                {
                    // TODO: This is a red-flag. This class should be a view transform, it shouldn't
                    // be changing the underlying data. Also, get{} shouldn't ever have side effects
                    this.item.ScheduleLineDate = formatReadableDateToSAPString(this.item.ScheduleLineDate);
                }
                String readableDate = formatSAPDateStringToReadableFormat(this.item.ScheduleLineDate);
                if ('' == readableDate)
                {
                    return null;
                }
                return Date.parse(readableDate);
            }
        }

        public OrderItem ( SBO_EnosixSO_Detail.ITEMS item, List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> itemSchedules )
        {
            this.item = item;
            maxItemSchedule = findMaxSchedule(itemSchedules);
        }

        private SBO_EnosixSO_Detail.ITEMS_SCHEDULE findMaxSchedule(List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> itemSchedules)
        {
            if( itemSchedules.size() == 0 )
            {
                return null;
            }

            SBO_EnosixSO_Detail.ITEMS_SCHEDULE maxSchedule = itemSchedules[0];

            for(SBO_EnosixSO_Detail.ITEMS_SCHEDULE schedule : itemSchedules)
            {
                if(schedule.ScheduleLineDate > maxSchedule.ScheduleLineDate)
                {
                    maxSchedule = schedule;
                }
            }

            return maxSchedule;
        }
    }

    @testVisible
    public static List<UTIL_Order.OrderItem> convertOrderDetailToOrderItem(SBO_EnosixSO_Detail.EnosixSO rawOrder)
    {
        List<SBO_EnosixSO_Detail.ITEMS> allItems = new List<SBO_EnosixSO_Detail.ITEMS>();
        List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> allItemSchedule = new List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE>();
        List<UTIL_Order.OrderItem> convertedItems = new List<UTIL_Order.OrderItem>();

        if(null != rawOrder)
        {
            rawOrder.ITEMS.copyTo(allItems);
            rawOrder.ITEMS_SCHEDULE.copyTo(allItemSchedule);

            for(SBO_EnosixSO_Detail.ITEMS item : allItems)
            {
                List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE> matchedItemSchedules =
                    new List<SBO_EnosixSO_Detail.ITEMS_SCHEDULE>();

                for(SBO_EnosixSO_Detail.ITEMS_SCHEDULE scheduledItem : allItemSchedule)
                {
                    if( item.ItemNumber == scheduledItem.ItemNumber )
                    {
                        matchedItemSchedules.add(scheduledItem);
                    }
                }

                convertedItems.add( new UTIL_Order.OrderItem(item, matchedItemSchedules) );
            }
        }

        return convertedItems;
    }

    public class QuoteItem {
        public SBO_EnosixQuote_Detail.ITEMS item { get; private set; }
        public SBO_EnosixQuote_Detail.ITEMS_SCHEDULE maxItemSchedule { get; private set; }

        public String FormattedScheduleLineDate
        {
            get
            {
                return formatSAPDateStringToReadableFormat(this.item.ScheduleLineDate);
            }
        }

        public Date convertedItemDate
        {
            get
            {
                if (null == this.item || string.isEmpty(this.item.ScheduleLineDate)) {
                    return null;
                }
                // Only convert if the string appears to be in the correct starting format: MM/dd/yyyy
                if (this.item.ScheduleLineDate.contains('/') && 10 == this.item.ScheduleLineDate.length())
                {
                    // TODO: This is a red-flag. This class should be a view transform, it shouldn't
                    // be changing the underlying data. Also, get{} shouldn't ever have side effects
                    this.item.ScheduleLineDate = formatReadableDateToSAPString(this.item.ScheduleLineDate);
                }
                String readableDate = formatSAPDateStringToReadableFormat(this.item.ScheduleLineDate);
                if ('' == readableDate)
                {
                    return null;
                }
                return Date.parse(readableDate);
            }
        }

        public QuoteItem(SBO_EnosixQuote_Detail.ITEMS item, List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> itemSchedules)
        {
            this.item = item;
            maxItemSchedule = findMaxSchedule(itemSchedules);
        }

        private SBO_EnosixQuote_Detail.ITEMS_SCHEDULE findMaxSchedule(List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> itemSchedules)
        {
            if( itemSchedules.size() == 0 )
            {
                return null;
            }

            SBO_EnosixQuote_Detail.ITEMS_SCHEDULE maxSchedule = itemSchedules[0];

            for(SBO_EnosixQuote_Detail.ITEMS_SCHEDULE schedule : itemSchedules)
            {
                if(schedule.ScheduleLineDate > maxSchedule.ScheduleLineDate)
                {
                    maxSchedule = schedule;
                }
            }

            return maxSchedule;
        }
    }

    @testVisible
    public static List<UTIL_Order.QuoteItem> convertQuoteDetailToQuoteItem(SBO_EnosixQuote_Detail.EnosixQuote rawQuote)
    {
        List<SBO_EnosixQuote_Detail.ITEMS> allItems = new List<SBO_EnosixQuote_Detail.ITEMS>();
        List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> allItemSchedule = new List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE>();
        List<UTIL_Order.QuoteItem> convertedItems = new List<UTIL_Order.QuoteItem>();

        if(null != rawQuote)
        {
            rawQuote.ITEMS.copyTo(allItems);
            rawQuote.ITEMS_SCHEDULE.copyTo(allItemSchedule);

            for(SBO_EnosixQuote_Detail.ITEMS item : allItems)
            {
                List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE> matchedItemSchedules =
                    new List<SBO_EnosixQuote_Detail.ITEMS_SCHEDULE>();

                for(SBO_EnosixQuote_Detail.ITEMS_SCHEDULE scheduledItem : allItemSchedule)
                {
                    if( item.ItemNumber == scheduledItem.ItemNumber )
                    {
                        matchedItemSchedules.add(scheduledItem);
                    }
                }

                convertedItems.add( new UTIL_Order.QuoteItem(item,matchedItemSchedules) );
            }
        }

        return convertedItems;
    }

    @testVisible
    public static void CopyCustomerInfoToOrder(SBO_EnosixSO_Detail.EnosixSO result, SBO_EnosixCustomer_Detail.EnosixCustomer customer) {

        SBO_EnosixCustomer_Detail.PARTNERS customerSoldTo = getPartnerFromCustomer(customer, SOLD_TO_PARTNER_CODE);

        if (null != customerSoldTo) {
            SBO_EnosixSO_Detail.PARTNERS orderSoldTo = getPartnerFromOrder(result, SOLD_TO_PARTNER_CODE, true);
            orderSoldTo.CustomerNumber = customerSoldTo.PartnerNumber;
        }
    }
    @testVisible
    public static void CopyCustomerInfoToQuote(SBO_EnosixQuote_Detail.EnosixQuote result, SBO_EnosixCustomer_Detail.EnosixCustomer customer) {

        SBO_EnosixCustomer_Detail.PARTNERS customerSoldTo = getPartnerFromCustomer(customer, SOLD_TO_PARTNER_CODE);

        if (null != customerSoldTo) {
            SBO_EnosixQuote_Detail.PARTNERS orderSoldTo = getPartnerFromQuote(result, SOLD_TO_PARTNER_CODE, true);
            orderSoldTo.CustomerNumber = customerSoldTo.PartnerNumber;
        }
    }

    @testVisible
    public static List<SBO_EnosixCustomer_Detail.PARTNERS> getCustomerPartners(SBO_EnosixCustomer_Detail.EnosixCustomer customer, string function) {
        List<SBO_EnosixCustomer_Detail.PARTNERS> result = new List<SBO_EnosixCustomer_Detail.PARTNERS>();
        List<SBO_EnosixCustomer_Detail.PARTNERS> partners = new List<SBO_EnosixCustomer_Detail.PARTNERS>();
        customer.PARTNERS.copyTo(partners);

        for (SBO_EnosixCustomer_Detail.PARTNERS partner : partners) {
            if (function == partner.PartnerFunction) {
                result.add(partner);
            }
        }

        return result;
    }

    @testVisible
    public static SBO_EnosixCustomer_Detail.PARTNERS getPartnerFromCustomer(SBO_EnosixCustomer_Detail.EnosixCustomer customer, string function) {
        SBO_EnosixCustomer_Detail.PARTNERS result = null;
        list<SBO_EnosixCustomer_Detail.PARTNERS> partners = new list<SBO_EnosixCustomer_Detail.PARTNERS>();

        if (null != customer) {

            customer.PARTNERS.copyTo(partners);

            for (SBO_EnosixCustomer_Detail.PARTNERS partner : partners) {
                if (function == partner.PartnerFunction) {
                    result = partner;
                    break;
                }
            }
        }

        return result;

    }

    @testVisible
    public static void AddPartners(List<SelectOption> result, List<SBO_EnosixCustomer_Detail.PARTNERS> partners,
            string salesOrganization, string distributionChannel, string division) {
                System.debug('Entering Add Partners');
        Set<string> values = new Set<string>();
        for (SBO_EnosixCustomer_Detail.PARTNERS partner : partners) {
            if (string.isNotBlank(partner.PartnerNumber) && !values.contains(partner.PartnerNumber) && salesOrganization == partner.salesOrganization && distributionChannel == partner.DistributionChannel && division == partner.Division) {
                string description = string.format('{0} - {1}', new list<string>{
                        partner.PartnerNumber, partner.PartnerName
                });
                result.add(new SelectOption(partner.PartnerNumber, description));
                values.add(partner.PartnerNumber);
            }
        }
        System.debug(values);
    }

    @testVisible
    public static List<SBO_EnosixCustomer_Detail.PARTNERS> getPartnersByOrgChannelDivision(List<SBO_EnosixCustomer_Detail.PARTNERS> partners,
        string salesOrganization, string distributionChannel, string division) {
        System.debug('Entering getPartnersByOrgChannelDivision');
        List<SBO_EnosixCustomer_Detail.PARTNERS> values = new List<SBO_EnosixCustomer_Detail.PARTNERS>();

        for (SBO_EnosixCustomer_Detail.PARTNERS partner : partners) {
            system.debug('Found this raw partner: ' + partner.PartnerNumber);
            if (string.isNotBlank(partner.PartnerNumber)  && salesOrganization == partner.salesOrganization && distributionChannel == partner.DistributionChannel && division == partner.Division)
            {
                values.add(partner);
            }
        }

        System.debug(values);
        return values;
    }


    @testVisible
    public static SBO_EnosixSO_Detail.PARTNERS getPartnerFromOrder(SBO_EnosixSO_Detail.EnosixSO salesOrder, string function, boolean create) {
        SBO_EnosixSO_Detail.PARTNERS result = null;
        list<SBO_EnosixSO_Detail.PARTNERS> partners = new list<SBO_EnosixSO_Detail.PARTNERS>();
        salesOrder.PARTNERS.copyTo(partners);
        for(SBO_EnosixSO_Detail.PARTNERS partner : partners) {
            if (function == partner.PartnerFunction) {
                result = partner;
                break;
            }
        }

        if (null == result && create) {
            result = new SBO_EnosixSO_Detail.PARTNERS();
            result.PartnerFunction = function;
            salesOrder.PARTNERS.add(result);
        }

        return result;

    }

    @testVisible
    public static SBO_EnosixQuote_Detail.PARTNERS getPartnerFromQuote(SBO_EnosixQuote_Detail.EnosixQuote quote, string function, boolean create) {
        SBO_EnosixQuote_Detail.PARTNERS result = null;
        list<SBO_EnosixQuote_Detail.PARTNERS> partners = new list<SBO_EnosixQuote_Detail.PARTNERS>();
        quote.PARTNERS.copyTo(partners);
        for(SBO_EnosixQuote_Detail.PARTNERS partner : partners) {
            if (function == partner.PartnerFunction) {
                result = partner;
                break;
            }
        }

        if (null == result && create) {
            result = new SBO_EnosixQuote_Detail.PARTNERS();
            result.PartnerFunction = function;
            quote.PARTNERS.add(result);
        }

        return result;
    }

    @testVisible
    public static SBO_EnosixRO_Detail.PARTNERS getPartnerFromReturnOrder(SBO_EnosixRO_Detail.EnosixRO returnOrder, string function, boolean create) {
        SBO_EnosixRO_Detail.PARTNERS result = null;
        list<SBO_EnosixRO_Detail.PARTNERS> partners = new list<SBO_EnosixRO_Detail.PARTNERS>();

        if (returnOrder.PARTNERS != null) {
            returnOrder.PARTNERS.copyTo(partners);

            for (SBO_EnosixRO_Detail.PARTNERS partner : partners) {
                if (function == partner.PartnerFunction) {
                    result = partner;
                    break;
                }
            }
        }

        if (null == result && create) {
            result = new SBO_EnosixRO_Detail.PARTNERS();
            result.PartnerFunction = function;
            returnOrder.PARTNERS.add(result);
        }

        return result;
    }

    @testVisible
    public static List<SBO_EnosixCustomer_Detail.SALES_DATA> getSalesDataListFromCustomer(SBO_EnosixCustomer_Detail.EnosixCustomer customer) {
        List<SBO_EnosixCustomer_Detail.SALES_DATA> result = new List<SBO_EnosixCustomer_Detail.SALES_DATA>();
        if (null != customer) {
            customer.SALES_DATA.copyTo(result);
        }
        return result;
    }

    @testVisible
    public static void AddSalesOrganizations(List<SelectOption> result, List<SBO_EnosixCustomer_Detail.SALES_DATA> areas) {
        Set<string> values = new Set<string>();
        for (SBO_EnosixCustomer_Detail.SALES_DATA area : areas) {
            if (!values.contains(area.SalesOrganization)) {
                result.add(new SelectOption(area.SalesOrganization, area.SalesOrganizationName));
                values.add(area.SalesOrganization);
            }
        }
    }

    @testVisible
    public static void AddDistributionChannels(List<SelectOption> result, List<SBO_EnosixCustomer_Detail.SALES_DATA> areas, string salesOrganization) {
        Set<string> values = new Set<string>();
        for (SBO_EnosixCustomer_Detail.SALES_DATA area : areas) {
            if (!values.contains(area.DistributionChannel) && area.SalesOrganization.equalsIgnoreCase(salesOrganization)) {
                result.add(new SelectOption(area.DistributionChannel, area.DistributionChannelName));
                values.add(area.DistributionChannel);
            }
        }
    }

    @testVisible
    public static void AddDistributionDivisions(List<SelectOption> result, List<SBO_EnosixCustomer_Detail.SALES_DATA> areas, string salesOrganization, string distributionChannel) {
        Set<string> values = new Set<string>();
        for (SBO_EnosixCustomer_Detail.SALES_DATA area : areas) {
            if (!values.contains(area.Division) && area.SalesOrganization.equalsIgnoreCase(salesOrganization) && area.DistributionChannel.equalsIgnoreCase(distributionChannel)) {
                result.add(new SelectOption(area.Division, area.DivisionName));
                values.add(area.Division);
            }
        }
    }

    @testVisible
    public static RFC_SD_GET_DOC_TYPE_VALUES.RESULT getDocTypeMaster() {
        RFC_SD_GET_DOC_TYPE_VALUES rfc = new RFC_SD_GET_DOC_TYPE_VALUES();

        RFC_SD_GET_DOC_TYPE_VALUES.RESULT result = rfc.execute();

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
        }

        return result;
    }

    // Gets all of the available order types for a specific business object.
    @testVisible
    public static RFC_SD_GET_ORDER_TYPES.RESULT getOrderTypes(string businessObjectType) {
        RFC_SD_GET_ORDER_TYPES rfc = new RFC_SD_GET_ORDER_TYPES();

        rfc.Params.IV_BOTYPE = businessObjectType;
        RFC_SD_GET_ORDER_TYPES.RESULT result = rfc.execute();

        if (!result.isSuccess())
        {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }

        return result;
    }

    public static List<OpportunityLineItem> getOpportunityLineItemsFromOpportunity(Opportunity opp){
        return  [SELECT Id, UnitPrice, Quantity, Product2Id, Product2.Name, Product2.Id, ServiceDate, Description FROM OpportunityLineItem WHERE OpportunityId = :opp.Id];
    }

    //
    @testVisible
    public static RFC_SD_GET_RETURN_CUSTINSPEC.RESULT getReturnCustomerInspection() {
        RFC_SD_GET_RETURN_CUSTINSPEC rfc = new RFC_SD_GET_RETURN_CUSTINSPEC();

        RFC_SD_GET_RETURN_CUSTINSPEC.RESULT result = rfc.execute();

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
        }

        return result;
    }

    @testVisible
    public static void AddDocTypesOfCategory(List<SelectOption> result, List<RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT> docTypes,
            List<string> documentCategories, List<string> documentTypes) {
        Set<string> values = new Set<string>();
        for (RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT docType : docTypes) {
            //system.debug(string.format('"{0}"', new string[]{ docType.AUART }));
            if (string.isNotBlank(docType.AUART) && string.isNotBlank(docType.BEZEI)) {
                boolean include = true;
                if (null != documentCategories && documentCategories.size() > 0) {

                    include = false;
                    for (string docCat : documentCategories) {
                        if (null != docType.VBTYP && ('*' == docCat || docType.VBTYP.equalsIgnoreCase(docCat))) {
                            include = true;
                            break;
                        }
                    }
                }

                if (!include) continue;

                if (null != documentTypes && documentTypes.size() > 0) {
                    include = false;
                    for (string docTp : documentTypes) {
                        if (null != docType.AUART && ('*' == docTp || docType.AUART.equalsIgnoreCase(docTp))) {
                            include = true;
                            break;
                        }
                    }
                }

                if (!include) continue;

                string description = string.format('{0} - {1}', new string[]{
                        docType.AUART, docType.BEZEI
                });
                result.add(new SelectOption(docType.AUART, description));
                values.add(docType.AUART);
            }
        }
    }

    @testVisible
    public static SBO_EnosixRO_Detail.EnosixRO getReturnOrderForId(string id) {
        SBO_EnosixRO_Detail ro = new SBO_EnosixRO_Detail();
        SBO_EnosixRO_Detail.EnosixRO result =  ro.getDetail(id);
        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO);
        }
        return result;
    }


    @testVisible
    public static SBO_EnosixSO_Detail.ITEMS getItemFromOrderByItemNumber(SBO_EnosixSO_Detail.EnosixSO salesOrder, string itemNumber) {
        List<SBO_EnosixSO_Detail.ITEMS> items = new List<SBO_EnosixSO_Detail.ITEMS>();

        if (null != salesOrder) {
            salesOrder.ITEMS.copyTo(items);
        }

        for (SBO_EnosixSO_Detail.ITEMS item : Items) {
            if (itemNumber == item.ItemNumber) {
                return item;
            }
        }

        return null;
    }

    @testVisible
    public static RFC_SD_GET_CARRIER_LIST.RESULT getCarriers() {
        RFC_SD_GET_CARRIER_LIST rfc = new RFC_SD_GET_CARRIER_LIST();
        
        RFC_SD_GET_CARRIER_LIST.RESULT result = rfc.execute();

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
        }

        return result;
    }

    @testVisible
    public static RFC_SD_GET_CARRIER_LIST.RESULT getCarriers(string SalesOrg) {
        RFC_SD_GET_CARRIER_LIST rfc = new RFC_SD_GET_CARRIER_LIST();
        
        rfc.Params.IV_SALESORG = SalesOrg;
        RFC_SD_GET_CARRIER_LIST.RESULT result = rfc.execute();

        if (!result.isSuccess()) {
            ENSX.EnosixFramework.displayResultMessages(result, ENSX.EnosixFramework.MessageType.INFO); // Display all messages
        }

        return result;
    }

    @testVisible
    public static UTIL_SelectOption.OptionBuilder getShipToOptionBuilder()
    {
        return (UTIL_SelectOption.OptionBuilder) UTIL_AppSettings.getInstance(
            'Order.ShipToOptionBuilder', PartnerOptionBuilder.class);
    }

    // This helps build select options for the material type checkboxes
    public class CarrierOptionBuilder extends UTIL_SelectOption.OptionBuilder {
        public override string getItemValue(object item) {
            return ((RFC_SD_GET_CARRIER_LIST.ET_OUTPUT)item).CARRIER;
        }

        public override string getItemDescription(object item) {
            return ((RFC_SD_GET_CARRIER_LIST.ET_OUTPUT)item).CARRIER_NAME;
        }

        // We don't want KEY - Desc on this one either
        public override string getItemLabel(object item) {
            return getItemDescription(item);
        }
    }

    // This helps build select options for the Partner dropdowns
    public class PartnerOptionBuilder extends UTIL_SelectOption.OptionBuilder {
        public override string getItemValue(object item) {
            return ((SBO_EnosixCustomer_Detail.PARTNERS)item).PartnerNumber;
        }

        public override string getItemDescription(object item) {
            return ((SBO_EnosixCustomer_Detail.PARTNERS)item).PartnerName;
        }

        // We don't want KEY - Desc on this one either
        public override string getItemLabel(object item) {
            return string.Format('{0} - {1}', new list<string>{ getItemValue(item), getItemDescription(item) });
        }
    }

    @testVisible
    public static UTIL_SelectOption.OptionBuilder getCustomerConditionOptionBuilder1()
    {
        return (UTIL_SelectOption.OptionBuilder) UTIL_AppSettings.getInstance(
            'Order.CustomerConditionGroupBuilder1', CustomerConditonOptionBuilder.class);
    }

    @testVisible
    public static UTIL_SelectOption.OptionBuilder getCustomerConditionOptionBuilder2()
    {
        return (UTIL_SelectOption.OptionBuilder) UTIL_AppSettings.getInstance(
            'Order.CustomerConditionGroupBuilder2', CustomerConditonOptionBuilder.class);
    }

    // This helps build select options for the Customer Condition dropdowns
    public virtual class CustomerConditonOptionBuilder extends UTIL_SelectOption.OptionBuilder
    {
        public override string getItemValue(object item)
        {
            return ((RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP)item).KDKGR;
        }

        public override string getItemDescription(object item)
        {
            return ((RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP)item).VTEXT;
        }

        public override string getItemLabel(object item)
        {
            return getItemDescription(item);
        }
    }

    public static List<RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP> getConditionGroups()
    {
        List<RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP> conditionGroups = new List<RFC_SD_GET_CONDITION_GROUP.ET_COND_GROUP>();
        RFC_SD_GET_CONDITION_GROUP rfc = new RFC_SD_GET_CONDITION_GROUP();
        RFC_SD_GET_CONDITION_GROUP.RESULT result = rfc.execute();
        if (result.ET_COND_GROUP_List.size() > 0)
        {
            conditionGroups = result.ET_COND_GROUP_List;
        }
        return conditionGroups;
    }

    public static Boolean isShipToPartnerAddressDisplayed
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Order.IsShipToPartnerAddressDisplayed', true);
        }
    }

    public static Boolean isCardLimitEnabled
    {
        get
        {
            return (Boolean)UTIL_AppSettings.getValue('Order.IsCardLimitEnabled', false);
        }
    }

    private static Set<String> orderTypesWithCreditCardSectionHidden
    {
        get
        {
            return (Set<String>)UTIL_AppSettings.getSet(
                'Order.OrderTypesWithCreditCardSectionHidden', String.class, new Set<String>{ });
        }
    }

    private static Set<String> orderTypesWithCreditCardEntryHidden
    {
        get
        {
            return (Set<String>)UTIL_AppSettings.getSet(
                'Order.OrderTypesWithCreditCardEntryHidden', String.class, new Set<String>{ });
        }
    }

    private static Map<String, Set<String>> allowedItemCategoriesByOrderType
    {
        get
        {
            return (Map<String, Set<String>>)UTIL_AppSettings.getMap(
                'Order.AllowedItemCategoriesByOrderType',
                String.class,
                Set<String>.class,
                new Map<String, Set<String>>()
            );
        }
    }

    // getDisplayCreditCardSection()
    //
    // Determines whether or not to display the credit card section on page based on order type.
    public static Boolean getDisplayCreditCardSection(String orderType)
    {
        return !UTIL_Order.orderTypesWithCreditCardSectionHidden.contains(orderType);
    }

    // getDisplayCreditCardEntry()
    //
    // Determines whether or not to display the credit card entry control on page based on order type.
    public static Boolean getDisplayCreditCardEntry(String orderType)
    {
        return !UTIL_Order.orderTypesWithCreditCardEntryHidden.contains(orderType);
    }

    // This helps build the select option list for order item categories
    public class ItemCategoryOptionBuilder extends UTIL_SelectOption.OptionBuilder
    {
        public override string getItemValue(object item){
            return ((RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT)item).PSTYV;
        }

        public override string getItemLabel(object item) {
            return string.format('{1} - {0}', new string[]{getItemValue(item), getItemDescription(item)});
        }

        public override string getItemDescription(object item) {
            return ((RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT)item).AUART;
        }
    }

    // Filters a list of item categories
    @testVisible
    public static List<RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT> filterItemCategories(
        RFC_SD_GET_ORDER_TYPES.RESULT orderTypeMaster, string orderType)
    {
        List<RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT> filteredList =
            new List<RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT>();

        if (null != orderTypeMaster)
        {
            for (RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT itemCategory : orderTypeMaster.ET_ITEM_CAT_List)
            {
                if (itemCategory.AUART == orderType)
                {
                    if (allowedItemCategoriesByOrderType.containsKey(orderType))
                    {
                        // If not * or PSTYV, skip.
                        Set<String> cat = allowedItemCategoriesByOrderType.get(orderType);
                        if (cat.contains('*') || cat.contains(itemCategory.PSTYV))
                        {
                            filteredList.add(itemCategory);
                        }
                    }
                    else
                    {
                        filteredList.add(itemCategory);
                    }
                }
            }
        }

        return filteredList;
    }


}
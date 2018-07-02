public class UTIL_YetiQuoteInitializedEventHandler implements I_EventHandler
{
    public void run(Map<String, object> context)
    {
        System.debug('UTIL_YetiQuoteInitializedEventHandler');

        SBO_EnosixQuote_Detail.EnosixQuote quoteDetail =
        (SBO_EnosixQuote_Detail.EnosixQuote) context.get('SBO_EnosixQuote_Detail.EnosixQuote');
        SBO_EnosixQuote_Detail.PARTNERS shippingPartner =
        UTIL_Order.getPartnerFromQuote(quoteDetail, UTIL_Order.SHIP_TO_PARTNER_CODE, true);

        Opportunity opp = (Opportunity) context.get('Opportunity');
        if (opp == null || String.isEmpty(opp.Id))
        {
            return;
        }

        List<Opportunity> customOpps = Database.query('SELECT Ship_To__c, Need_By_Date__c, PO_Number__c '
        + 'FROM Opportunity WHERE Id = \'' + opp.Id + '\' LIMIT 1');

        // Copy custom Yeti fields from Opportunity to Quote.
        if (customOpps.size() > 0)
        {
            Opportunity customOpp = customOpps[0];

            if (null != customOpp.get('Need_By_Date__c'))
            {
                quoteDetail.Sales.RequestedDeliveryDate = (Date) customOpp.get('Need_By_Date__c');
            }

            if (null != customOpp.get('PO_Number__c'))
            {
                quoteDetail.CustomerPurchaseOrderNumber = (String) customOpp.get('PO_Number__c');
            }

            if (null != customOpp.get('Ship_To__c'))
            {
                try
                {
                    List<Account> shipToAccounts = Database.query('SELECT ENSX_EDM__SAP_Customer_Number__c '
                    + 'FROM Account WHERE Id = \'' + customOpp.get('Ship_To__c') + '\' LIMIT 1');
                    if (shipToAccounts.size() > 0)
                    {
                        shippingPartner.CustomerNumber = (String) shipToAccounts[0].get('ENSX_EDM__SAP_Customer_Number__c');
                    }
                }
                catch (Exception ex)
                {
                    ApexPages.addMessages(ex);
                }
            }
        }
    }
}
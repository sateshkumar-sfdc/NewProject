public class UTIL_YetiOppQuotePriceInitEvtHandler implements I_EventHandler
{
    public void run(Map<String, object> context)
    {
        System.debug('UTIL_YetiOppQuotePriceInitEvtHandler');

        SBO_EnosixQuote_Detail.EnosixQuote quoteDetail =
            (SBO_EnosixQuote_Detail.EnosixQuote) context.get('SBO_EnosixQuote_Detail.EnosixQuote');
        SBO_EnosixQuote_Detail.PARTNERS shippingPartner =
            UTIL_Order.getPartnerFromQuote(quoteDetail, UTIL_Order.SHIP_TO_PARTNER_CODE, true);

        Opportunity opp = (Opportunity) context.get('Opportunity');

        List<Opportunity> shipToOpportunitys = Database.query('SELECT Ship_To__c '
            + 'FROM Opportunity WHERE Id = \'' + opp.Id + '\' LIMIT 1');

        // Copy custom Yeti fields from Opportunity to Quote.
        if (shipToOpportunitys.size() > 0)
        {
            Opportunity shipToOpportunity = shipToOpportunitys[0];

            if (null != shipToOpportunity.get('Ship_To__c'))
            {
                try
                {
                    List<Account> shipToAccounts = Database.query('SELECT ENSX_EDM__SAP_Customer_Number__c '
                        + 'FROM Account WHERE Id = \'' + shipToOpportunity.get('Ship_To__c') + '\' LIMIT 1');
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
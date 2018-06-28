public class UTIL_YetiOppQuotePriceUpdatedEvtHandler implements I_EventHandler
{
    public void run(Map<String, object> context)
    {
        System.debug('UTIL_YetiOppQuotePriceUpdatedEvtHandler');

        SBO_EnosixQuote_Detail.EnosixQuote quoteDetail = 
            (SBO_EnosixQuote_Detail.EnosixQuote) context.get('SBO_EnosixQuote_Detail.EnosixQuote');
        Opportunity opp = (Opportunity) context.get('Opportunity');
        SBO_EnosixQuote_Detail.PARTNERS shippingPartner = 
            UTIL_Order.getPartnerFromQuote(quoteDetail, UTIL_Order.SHIP_TO_PARTNER_CODE, true);
        if (shippingPartner != null)
        {
            Account shipToAccount = UTIL_Object_Lookups.getAccountByCustomerId(shippingPartner.CustomerNumber);
            if ( null != shipToAccount && (shipToAccount.ParentId == opp.AccountId || shipToAccount.Id == opp.AccountId) )
            {
                opp.put('Ship_To__c', shipToAccount.Id);
                update opp;
            }
            else
            {
                opp.put('Ship_To__c', null);
                update opp;

                Account oppAccount = UTIL_Object_Lookups.getAccountById(opp.AccountId);
                if (null == shipToAccount)
                {
                    throw new UTIL_YetiCustomExceptions.ShipToAccountMissingException(
                        'Unable to find a Salesforce Ship To Account for SAP Customer Number '
                        + shippingPartner.CustomerNumber
                    );
                }
                else
                {
                    throw new UTIL_YetiCustomExceptions.ParentIdShipToMismatchException(String.format(
                        'Unable to set "{0}" ({1}) as Opportunity Ship To because it is not a child of "{2}" ({3}) in the Salesforce Account Hierarchy',
                        new List<String>
                        {
                            shipToAccount.Name,
                            (String) shipToAccount.get('ENSX_EDM__SAP_Customer_Number__c'),
                            oppAccount.Name,
                            (String) oppAccount.get('ENSX_EDM__SAP_Customer_Number__c')
                        }
                    ));
                }
            }
        }
    }
}
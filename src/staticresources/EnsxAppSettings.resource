{
  "Account.PartnerPreviewFunctionFilter": [
    "Z0",
    "ZI"
  ],
  "Account.PartnerPreviewTitle": "SAP Sales Reps",
  "Customer.AllowedClientTypes": [
    "SP",
    "SH",
    "BP",
    "PY",
    "DTC",
    "EC"
  ],
  "Customer.IsPaymentTermsEditEnabled": false,
  "Customer.IsContactEditable": true,
  "Customer.IsAddressEditable": true,
  "Customer.ShipToParentPartnerTypes": [
    "SP",
    "EC"
  ],
  "Event.Handlers": {
    "CUSTOMER_CREATED": "UTIL_YetiCustomerTouchedEventHandler",
    "CUSTOMER_LINKED": "UTIL_YetiCustomerTouchedEventHandler",
    "CUSTOMER_UPDATED": "UTIL_YetiCustomerTouchedEventHandler",
    "CUSTOMER_INITIALIZING": "UTIL_YetiCustomerInitEventHandler",
    "PARTNER_ADDED": "UTIL_YetiPartnerAddedEventHandler",
    "OPPORTUNITY_QUOTEPRICING_INITIALIZED": "UTIL_YetiOppQuotePriceInitEvtHandler",
    "OPPORTUNITY_QUOTEPRICING_UPDATED": "UTIL_YetiOppQuotePriceupdatedEvtHandler",
    "ORDER_INITIALIZED": "UTIL_YetiOrderInitializedEventHandler",
    "QUOTE_INITIALIZED": "UTIL_YetiQuoteInitializedEventHandler"
  },
  "Inventory.DefaultMaterialTypes": [
    "ZERT",
    "ZALB"
  ],
  "MaterialSearch.ProductAttributeTranslator": "UTIL_YetiMaterialProductTranslator",
  "Opportunity.DefaultMaterialTypes": [
    "ZERT"
  ],
  "Opportunity.DefaultMaterialProductAttributes": [
    "Product attribute 1"
  ],
  "Opportunity.IsSalesInfoEnabled": false,
  "Opportunity.IsAtpEnabled": false,
  "Order.DefaultMaterialTypes": [
    "ZERT"
  ],
  "Order.DefaultMaterialProductAttributes": [
    "Product attribute 1"
  ],
  "Order.AllowedShippingConditions": [
    "01",
    "02",
    "NL"
  ],
  "Order.DocumentTypes": [
    "OR",
    "CBFD",
    "ZBFD"
  ],
  "Order.IsShipToPartnerAddressDisplayed": false,
  "Order.AllowedItemCategoriesByOrderType": {
    "OR": [
      "TAN",
      "TANN"
    ],
    "QT": [
      "AGN"
    ],
    "ZARM": [
      "*"
    ]
  },
  "Order.OrderTypesWithCreditCardSectionHidden": [
    "QT"
  ],
  "Order.ShipToOptionBuilder": "UTIL_YetiShipToOptionBuilder",
  "Order.CustomerConditionGroupBuilder1": "UTIL_YetiCustomerConditionOptionBuilder1",
  "Order.CustomerConditionGroupBuilder2": "UTIL_YetiCustomerConditionOptionBuilder2",
  "Quote.DefaultMaterialTypes": [
    "ZERT"
  ],
  "Quote.DefaultMaterialProductAttributes": [
    "Product attribute 1"
  ],
  "ReturnOrder.DefaultMaterialTypes": [
    "ZERT"
  ],
  "ReturnOrder.DefaultMaterialProductAttributes": [
    "Product attribute 1"
  ],
  "ReturnOrder.IsSingleRefundTypeEnabled": true,
  "ReturnOrder.IsOrderTypeEnabled": false,
  "ReturnOrder.IsSalesOrganizationEnabled": false,
  "ReturnOrder.IsDistributionChannelEnabled": false,
  "ReturnOrder.IsDivisionEnabled": false,
  "ReturnOrder.IsSoldToPartnerEnabled": false,
  "Pricebook.Dealer": "2017 Dealer Products"
}
/// enosiX Inc. Generated Apex Model
/// Generated On: 4/28/17 1:45:59 PM
/// SAP Host: yeti-sfdc-api.enosix.com
/// CID: S4H

public with sharing class SBO_EnosixCustomer_Detail extends ENSX.EnosixFramework.DetailSBO {

    public SBO_EnosixCustomer_Detail() {
      super('EnosixCustomer', SBO_EnosixCustomer_Detail.EnosixCustomer.class);
    }

  public override Type getType() { return SBO_EnosixCustomer_Detail.class; }

  public EnosixCustomer initialize(EnosixCustomer obj) {
      return (EnosixCustomer)this.executeInitialize(obj);
    }

    public EnosixCustomer getDetail(object key) {
      return (EnosixCustomer)this.executeGetDetail(key);
    }

    public EnosixCustomer save(EnosixCustomer obj) {
      return (EnosixCustomer) this.executeSave(obj);
    }

    public EnosixCustomer command(string command, EnosixCustomer obj) {
      return (EnosixCustomer) this.executeCommand(command, obj);
    }

    public with sharing class EnosixCustomer extends ENSX.EnosixFramework.DetailObject {
       public EnosixCustomer() {
      super('GENERAL_DATA', new Map<string,type>{'COMPANY_DATA' => SBO_EnosixCustomer_Detail.COMPANY_DATA.class
,'SALES_DATA' => SBO_EnosixCustomer_Detail.SALES_DATA.class
,'PAYMENT_DATA' => SBO_EnosixCustomer_Detail.PAYMENT_DATA.class
,'PARTNERS' => SBO_EnosixCustomer_Detail.PARTNERS.class
,'CREDIT' => SBO_EnosixCustomer_Detail.CREDIT.class
,'USER_DEFINED' => SBO_EnosixCustomer_Detail.USER_DEFINED.class
});
      }

    public override Type getType() { return SBO_EnosixCustomer_Detail.EnosixCustomer.class; }

        public String CustomerNumber
    {
      get { return this.getString ('KUNNR'); }
      set { this.Set (value, 'KUNNR'); }
    }

    public String BPRole
    {
      get { return this.getString ('BP_ROLE'); }
      set { this.Set (value, 'BP_ROLE'); }
    }

    public String BPRoleDescription
    {
      get { return this.getString ('BP_ROLE_TEXT'); }
      set { this.Set (value, 'BP_ROLE_TEXT'); }
    }

    public String BusinessPartnerCategory
    {
      get { return this.getString ('PARTNER_CATEG'); }
      set { this.Set (value, 'PARTNER_CATEG'); }
    }

    public String BusinessPartnerCategoryDescription
    {
      get { return this.getString ('PARTNERCATEG_TEXT'); }
      set { this.Set (value, 'PARTNERCATEG_TEXT'); }
    }

    public String BusinessPartnerType
    {
      get { return this.getString ('PARTNER_TYPE'); }
      set { this.Set (value, 'PARTNER_TYPE'); }
    }

    public String BusinessPartnerTypeDescription
    {
      get { return this.getString ('PARTNERTY_TEXT'); }
      set { this.Set (value, 'PARTNERTY_TEXT'); }
    }

    public String BusinessPartnerGrouping
    {
      get { return this.getString ('BU_GROUP'); }
      set { this.Set (value, 'BU_GROUP'); }
    }

    public String BusinessPartnerGroupingDesc
    {
      get { return this.getString ('BU_GROUP_TEXT'); }
      set { this.Set (value, 'BU_GROUP_TEXT'); }
    }

    public String Title
    {
      get { return this.getString ('TITLE'); }
      set { this.Set (value, 'TITLE'); }
    }

    public String TitleName
    {
      get { return this.getString ('TITLE_TEXT'); }
      set { this.Set (value, 'TITLE_TEXT'); }
    }

    public String Name
    {
      get { return this.getString ('NAME1'); }
      set { this.Set (value, 'NAME1'); }
    }

    public String Name2
    {
      get { return this.getString ('NAME2'); }
      set { this.Set (value, 'NAME2'); }
    }

    public String SearchTerm1
    {
      get { return this.getString ('SORT1'); }
      set { this.Set (value, 'SORT1'); }
    }

    public String HouseNumber
    {
      get { return this.getString ('HOUSE_NUM1'); }
      set { this.Set (value, 'HOUSE_NUM1'); }
    }

    public String Street
    {
      get { return this.getString ('STREET'); }
      set { this.Set (value, 'STREET'); }
    }

    public String City
    {
      get { return this.getString ('CITY1'); }
      set { this.Set (value, 'CITY1'); }
    }

    public String PostalCode
    {
      get { return this.getString ('POST_CODE1'); }
      set { this.Set (value, 'POST_CODE1'); }
    }

    public String Region
    {
      get { return this.getString ('REGION'); }
      set { this.Set (value, 'REGION'); }
    }

    public String RegionDescription
    {
      get { return this.getString ('REGIO_BEZEI'); }
      set { this.Set (value, 'REGIO_BEZEI'); }
    }

    public String Country
    {
      get { return this.getString ('COUNTRY'); }
      set { this.Set (value, 'COUNTRY'); }
    }

    public String CountryName
    {
      get { return this.getString ('COUNTRY_LANDX'); }
      set { this.Set (value, 'COUNTRY_LANDX'); }
    }

    public String POBox
    {
      get { return this.getString ('PO_BOX'); }
      set { this.Set (value, 'PO_BOX'); }
    }

    public String POBoxPostalCode
    {
      get { return this.getString ('POST_CODE2'); }
      set { this.Set (value, 'POST_CODE2'); }
    }

    public String CompanyPostalCode
    {
      get { return this.getString ('POST_CODE3'); }
      set { this.Set (value, 'POST_CODE3'); }
    }

    public String Language
    {
      get { return this.getString ('LANGU'); }
      set { this.Set (value, 'LANGU'); }
    }

    public String LanguageDesc
    {
      get { return this.getString ('LANGU_SPTXT'); }
      set { this.Set (value, 'LANGU_SPTXT'); }
    }

    public String TelephoneNumber
    {
      get { return this.getString ('TEL_NUMBER'); }
      set { this.Set (value, 'TEL_NUMBER'); }
    }

    public String TelephoneNumberExtension
    {
      get { return this.getString ('TEL_EXTENS'); }
      set { this.Set (value, 'TEL_EXTENS'); }
    }

    public String MobileNumber
    {
      get { return this.getString ('MOB_NUMBER'); }
      set { this.Set (value, 'MOB_NUMBER'); }
    }

    public String FaxNumber
    {
      get { return this.getString ('FAX_NUMBER'); }
      set { this.Set (value, 'FAX_NUMBER'); }
    }

    public String FaxNumberExtension
    {
      get { return this.getString ('FAX_EXTENS'); }
      set { this.Set (value, 'FAX_EXTENS'); }
    }

    public String EMailAddress
    {
      get { return this.getString ('SMTP_ADDR'); }
      set { this.Set (value, 'SMTP_ADDR'); }
    }

    public String Attribute1
    {
      get { return this.getString ('ATTRIBUTE1'); }
      set { this.Set (value, 'ATTRIBUTE1'); }
    }

    public String Attribute1Description
    {
      get { return this.getString ('ATTRIBUTE1_DESC'); }
      set { this.Set (value, 'ATTRIBUTE1_DESC'); }
    }


    public ENSX.EnosixFramework.FrameworkCollection COMPANY_DATA {
        get { return this.getCollection(SBO_EnosixCustomer_Detail.COMPANY_DATA.class); }
      }


    public ENSX.EnosixFramework.FrameworkCollection SALES_DATA {
        get { return this.getCollection(SBO_EnosixCustomer_Detail.SALES_DATA.class); }
      }


    public ENSX.EnosixFramework.FrameworkCollection PAYMENT_DATA {
        get { return this.getCollection(SBO_EnosixCustomer_Detail.PAYMENT_DATA.class); }
      }


    public ENSX.EnosixFramework.FrameworkCollection PARTNERS {
        get { return this.getCollection(SBO_EnosixCustomer_Detail.PARTNERS.class); }
      }


    public SBO_EnosixCustomer_Detail.CREDIT CREDIT {
      get { return (SBO_EnosixCustomer_Detail.CREDIT)this.getStruct(SBO_EnosixCustomer_Detail.CREDIT.class); }
    }


    public ENSX.EnosixFramework.FrameworkCollection USER_DEFINED {
        get { return this.getCollection(SBO_EnosixCustomer_Detail.USER_DEFINED.class); }
      }


  }

  //Write child objects
  public class COMPANY_DATA extends ENSX.EnosixFramework.ValueObject
{
  public override Type getType() { return SBO_EnosixCustomer_Detail.COMPANY_DATA.class; }

  public override List<string> getKeyFields()
  {
    List<string> keyFields = new List<string>{ 'BUKRS' };

    return keyFields;
  }

      public String CompanyCode
    {
      get { return this.getString ('BUKRS'); }
      set { this.Set (value, 'BUKRS'); }
    }

    public String CompanyCodeDescription
    {
      get { return this.getString ('BUKRS_TEXT'); }
      set { this.Set (value, 'BUKRS_TEXT'); }
    }

    public String ReconciliationAccount
    {
      get { return this.getString ('AKONT'); }
      set { this.Set (value, 'AKONT'); }
    }

    public String TermsofPaymentKey
    {
      get { return this.getString ('ZTERM'); }
      set { this.Set (value, 'ZTERM'); }
    }

    public String TermsOfPaymentDescription
    {
      get { return this.getString ('ZTERM_TEXT'); }
      set { this.Set (value, 'ZTERM_TEXT'); }
    }

}
public class SALES_DATA extends ENSX.EnosixFramework.ValueObject
{
  public override Type getType() { return SBO_EnosixCustomer_Detail.SALES_DATA.class; }

  public override List<string> getKeyFields()
  {
    List<string> keyFields = new List<string>{ 'VKORG','VTWEG','SPART' };

    return keyFields;
  }

      public String SalesOrganization
    {
      get { return this.getString ('VKORG'); }
      set { this.Set (value, 'VKORG'); }
    }

    public String SalesOrganizationName
    {
      get { return this.getString ('VKORG_VTEXT'); }
      set { this.Set (value, 'VKORG_VTEXT'); }
    }

    public String DistributionChannel
    {
      get { return this.getString ('VTWEG'); }
      set { this.Set (value, 'VTWEG'); }
    }

    public String DistributionChannelName
    {
      get { return this.getString ('VTWEG_VTEXT'); }
      set { this.Set (value, 'VTWEG_VTEXT'); }
    }

    public String Division
    {
      get { return this.getString ('SPART'); }
      set { this.Set (value, 'SPART'); }
    }

    public String DivisionName
    {
      get { return this.getString ('SPART_VTEXT'); }
      set { this.Set (value, 'SPART_VTEXT'); }
    }

    public String SalesDistrict
    {
      get { return this.getString ('BZIRK'); }
      set { this.Set (value, 'BZIRK'); }
    }

    public String SalesDistrictName
    {
      get { return this.getString ('BZIRK_TEXT'); }
      set { this.Set (value, 'BZIRK_TEXT'); }
    }

    public String SalesOffice
    {
      get { return this.getString ('VKBUR'); }
      set { this.Set (value, 'VKBUR'); }
    }

    public String SalesOfficeName
    {
      get { return this.getString ('VKBUR_TEXT'); }
      set { this.Set (value, 'VKBUR_TEXT'); }
    }

    public String SalesGroup
    {
      get { return this.getString ('VKGRP'); }
      set { this.Set (value, 'VKGRP'); }
    }

    public String SalesGroupName
    {
      get { return this.getString ('VKGRP_TEXT'); }
      set { this.Set (value, 'VKGRP_TEXT'); }
    }

    public String DeliveryPlant
    {
      get { return this.getString ('VWERK'); }
      set { this.Set (value, 'VWERK'); }
    }

    public String DeliveryPlantName
    {
      get { return this.getString ('VWERK_TEXT'); }
      set { this.Set (value, 'VWERK_TEXT'); }
    }

    public String PriceGroup
    {
      get { return this.getString ('KONDA'); }
      set { this.Set (value, 'KONDA'); }
    }

    public String PriceGroupDescription
    {
      get { return this.getString ('KONDA_TEXT'); }
      set { this.Set (value, 'KONDA_TEXT'); }
    }

    public String CustomerPricingProcedure
    {
      get { return this.getString ('KALKS'); }
      set { this.Set (value, 'KALKS'); }
    }

    public String CustomerPricProcedureDesc
    {
      get { return this.getString ('KALKS_TEXT'); }
      set { this.Set (value, 'KALKS_TEXT'); }
    }

    public String PriceListType
    {
      get { return this.getString ('PLTYP'); }
      set { this.Set (value, 'PLTYP'); }
    }

    public String PriceListTypeDescription
    {
      get { return this.getString ('PLTYP_TEXT'); }
      set { this.Set (value, 'PLTYP_TEXT'); }
    }

    public String StatisticsGroup
    {
      get { return this.getString ('VERSG'); }
      set { this.Set (value, 'VERSG'); }
    }

    public String StatisticsGroupDescription
    {
      get { return this.getString ('VERSG_TEXT'); }
      set { this.Set (value, 'VERSG_TEXT'); }
    }

    public String ShippingConditions
    {
      get { return this.getString ('VSBED'); }
      set { this.Set (value, 'VSBED'); }
    }

    public String ShippingConditionDescription
    {
      get { return this.getString ('VSBED_TEXT'); }
      set { this.Set (value, 'VSBED_TEXT'); }
    }

    public String CompleteDeliveryDefined
    {
      get { return this.getString ('AUTLF'); }
      set { this.Set (value, 'AUTLF'); }
    }

    public String MaximumNoOfPartialDelivery
    {
      get { return this.getString ('MAX_PARTIAL_DEL'); }
      set { this.Set (value, 'MAX_PARTIAL_DEL'); }
    }

    public String TermsofPaymentKey
    {
      get { return this.getString ('ZTERM'); }
      set { this.Set (value, 'ZTERM'); }
    }

    public String TermsOfPaymentDescription
    {
      get { return this.getString ('ZTERM_TEXT'); }
      set { this.Set (value, 'ZTERM_TEXT'); }
    }

    public String CurrencyKey
    {
      get { return this.getString ('WAERS'); }
      set { this.Set (value, 'WAERS'); }
    }

    public String TaxClassification
    {
      get { return this.getString ('TAXKD'); }
      set { this.Set (value, 'TAXKD'); }
    }

    public String TaxClassificationDescription
    {
      get { return this.getString ('TAXKD_TEXT'); }
      set { this.Set (value, 'TAXKD_TEXT'); }
    }

    public String CustomerGroup1
    {
      get { return this.getString ('KVGR1'); }
      set { this.Set (value, 'KVGR1'); }
    }

    public String CustomerGroup1Name
    {
      get { return this.getString ('KVGR1_TEXT'); }
      set { this.Set (value, 'KVGR1_TEXT'); }
    }

    public String CustomerBlock
    {
      get { return this.getString ('AUFSD'); }
      set { this.Set (value, 'AUFSD'); }
    }

}
public class PAYMENT_DATA extends ENSX.EnosixFramework.ValueObject
{
  public override Type getType() { return SBO_EnosixCustomer_Detail.PAYMENT_DATA.class; }

  public override List<string> getKeyFields()
  {
    List<string> keyFields = new List<string>{ 'CCARD_ID','CCINS','CCNUM' };

    return keyFields;
  }

      public String PaymentCardID
    {
      get { return this.getString ('CCARD_ID'); }
      set { this.Set (value, 'CCARD_ID'); }
    }

    public String PaymentCardType
    {
      get { return this.getString ('CCINS'); }
      set { this.Set (value, 'CCINS'); }
    }

    public String PaymentCardTypeDesc
    {
      get { return this.getString ('CCINS_TEXT'); }
      set { this.Set (value, 'CCINS_TEXT'); }
    }

    public String CardNumber
    {
      get { return this.getString ('CCNUM'); }
      set { this.Set (value, 'CCNUM'); }
    }

    public String DefaultPaymentCard
    {
      get { return this.getString ('CCDEF'); }
      set { this.Set (value, 'CCDEF'); }
    }

    public String CreditCardName
    {
      get { return this.getString ('CREDITCARDNAME'); }
      set { this.Set (value, 'CREDITCARDNAME'); }
    }

    public String CardHolderName
    {
      get { return this.getString ('CCNAM'); }
      set { this.Set (value, 'CCNAM'); }
    }

    public String CardCategory
    {
      get { return this.getString ('CCTYP'); }
      set { this.Set (value, 'CCTYP'); }
    }

    public String CardCategoryDescription
    {
      get { return this.getString ('CCTYP_TEXT'); }
      set { this.Set (value, 'CCTYP_TEXT'); }
    }

    public Date ValidFromDate
    {
      get { return this.getDate ('DATAB'); }
      set { this.Set (value, 'DATAB'); }
    }

    public Date ValidToDate
    {
      get { return this.getDate ('DATBI'); }
      set { this.Set (value, 'DATBI'); }
    }

    public String X_RemoveCard
    {
      get { return this.getString ('X_CARD_DELETE'); }
      set { this.Set (value, 'X_CARD_DELETE'); }
    }

}
public class PARTNERS extends ENSX.EnosixFramework.ValueObject
{
  public override Type getType() { return SBO_EnosixCustomer_Detail.PARTNERS.class; }

  public override List<string> getKeyFields()
  {
    List<string> keyFields = new List<string>{ 'VKORG','VTWEG','SPART','PARVW' };

    return keyFields;
  }

      public String SalesOrganization
    {
      get { return this.getString ('VKORG'); }
      set { this.Set (value, 'VKORG'); }
    }

    public String DistributionChannel
    {
      get { return this.getString ('VTWEG'); }
      set { this.Set (value, 'VTWEG'); }
    }

    public String Division
    {
      get { return this.getString ('SPART'); }
      set { this.Set (value, 'SPART'); }
    }

    public String PartnerFunction
    {
      get { return this.getString ('PARVW'); }
      set { this.Set (value, 'PARVW'); }
    }

    public String PartnerFunctionName
    {
      get { return this.getString ('PARVW_VTEXT'); }
      set { this.Set (value, 'PARVW_VTEXT'); }
    }

    public String PartnerNumber
    {
      get { return this.getString ('PARTNER_NUM'); }
      set { this.Set (value, 'PARTNER_NUM'); }
    }

    public String PartnerName
    {
      get { return this.getString ('PARTNER_NAME'); }
      set { this.Set (value, 'PARTNER_NAME'); }
    }

    public String HouseNumber
    {
      get { return this.getString ('HOUSE_NUM1'); }
      set { this.Set (value, 'HOUSE_NUM1'); }
    }

    public String Street
    {
      get { return this.getString ('STREET'); }
      set { this.Set (value, 'STREET'); }
    }

    public String City
    {
      get { return this.getString ('CITY1'); }
      set { this.Set (value, 'CITY1'); }
    }

    public String PostalCode
    {
      get { return this.getString ('POST_CODE1'); }
      set { this.Set (value, 'POST_CODE1'); }
    }

    public String Region
    {
      get { return this.getString ('REGION'); }
      set { this.Set (value, 'REGION'); }
    }

    public String Country
    {
      get { return this.getString ('COUNTRY'); }
      set { this.Set (value, 'COUNTRY'); }
    }

}
public class CREDIT extends ENSX.EnosixFramework.ValueObject
{
  public override Type getType() { return SBO_EnosixCustomer_Detail.CREDIT.class; }

  public override List<string> getKeyFields()
  {
    List<string> keyFields = new List<string>{ 'EnosixObjKey' };

    return keyFields;
  }

      public Decimal CreditLimit
    {
      get { return this.getDecimal ('CREDIT_LIMIT'); }
      set { this.Set (value, 'CREDIT_LIMIT'); }
    }

    public Decimal CreditAvailable
    {
      get { return this.getDecimal ('CREDIT_AVAIL'); }
      set { this.Set (value, 'CREDIT_AVAIL'); }
    }

    public String CurrencyKey
    {
      get { return this.getString ('WAERS'); }
      set { this.Set (value, 'WAERS'); }
    }

    public String CreditManagmentBlock
    {
      get { return this.getString ('XBLOCKED'); }
      set { this.Set (value, 'XBLOCKED'); }
    }

    public Date ValidToDate
    {
      get { return this.getDate ('LIMIT_VALID_DATE'); }
      set { this.Set (value, 'LIMIT_VALID_DATE'); }
    }

    public Date ChangeDate
    {
      get { return this.getDate ('LIMIT_CHG_DATE'); }
      set { this.Set (value, 'LIMIT_CHG_DATE'); }
    }

    public String CreditAnalyst
    {
      get { return this.getString ('COORDINATOR'); }
      set { this.Set (value, 'COORDINATOR'); }
    }

    public String CustomerCreditGroup
    {
      get { return this.getString ('CUST_GROUP'); }
      set { this.Set (value, 'CUST_GROUP'); }
    }

    public Date ResubmissionDate
    {
      get { return this.getDate ('FOLLOW_UP_DT'); }
      set { this.Set (value, 'FOLLOW_UP_DT'); }
    }

    public Decimal CalculatedCreditLimit
    {
      get { return this.getDecimal ('CRED_LIM_CALC'); }
      set { this.Set (value, 'CRED_LIM_CALC'); }
    }

    public String SpecialAttentonRequired
    {
      get { return this.getString ('XCRITICAL'); }
      set { this.Set (value, 'XCRITICAL'); }
    }

    public String LimitIsZero
    {
      get { return this.getString ('X_LIMIT_ZERO'); }
      set { this.Set (value, 'X_LIMIT_ZERO'); }
    }

    public String CreditBlockReason
    {
      get { return this.getString ('BLOCK_REASON'); }
      set { this.Set (value, 'BLOCK_REASON'); }
    }

    public Decimal CreditLimitRequested
    {
      get { return this.getDecimal ('CRED_LIM_REQ'); }
      set { this.Set (value, 'CRED_LIM_REQ'); }
    }

    public String AutomaticLimitRequest
    {
      get { return this.getString ('AUTOMATIC_REQ'); }
      set { this.Set (value, 'AUTOMATIC_REQ'); }
    }

    public Date RequestedValidToDate
    {
      get { return this.getDate ('LIM_VAL_DATE_REQ'); }
      set { this.Set (value, 'LIM_VAL_DATE_REQ'); }
    }

    public Date RequestDate
    {
      get { return this.getDate ('REQ_DATE'); }
      set { this.Set (value, 'REQ_DATE'); }
    }

    public Decimal DaysInArrears
    {
      get { return this.getDecimal ('OVDUE_DAYS'); }
      set { this.Set (value, 'OVDUE_DAYS'); }
    }

}
public class USER_DEFINED extends ENSX.EnosixFramework.ValueObject
{
  public override Type getType() { return SBO_EnosixCustomer_Detail.USER_DEFINED.class; }

  public override List<string> getKeyFields()
  {
    List<string> keyFields = new List<string>{ 'FIELD' };

    return keyFields;
  }

      public String FIELD
    {
      get { return this.getString ('FIELD'); }
      set { this.Set (value, 'FIELD'); }
    }

    public String VALUE
    {
      get { return this.getString ('VALUE'); }
      set { this.Set (value, 'VALUE'); }
    }

}
}
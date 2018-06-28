public  class UTIL_Object_Lookups
{
	public static Case getCaseById(string id)
	{
		Case cse = new Case();
		try
		{
			cse = [SELECT Id, IsDeleted,CaseNumber,Contact.Email,ContactId,AccountId,AssetId,ParentId,SuppliedName,SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, Status,Reason,Origin, Subject, Priority, Description, IsClosed, ClosedDate,IsEscalated, OwnerId,ENSX_EDM__Product_del__c, ENSX_EDM__Return_Order_Number__c FROM Case WHERE Id = :id];
		}
		catch (Exception e)
		{
            system.debug(e);
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'There was an issue retrieving a Case record for the provided Id'));
        }
        return cse;
    }

	public static Opportunity getOpportunityById(string id)
	{
		Opportunity result = null;
		try
		{
			result = [SELECT Id, Name, Description, StageName, Amount, Type, NextStep, Probability, HasOpportunityLineItem, LeadSource, AccountID, CloseDate, Pricebook2Id, ENSX_EDM__Quote_Number__c, ENSX_EDM__OrderNumber__c from Opportunity where Id = :id];
		}
		catch (Exception e)
		{
			System.debug(e);
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'There was an issue retrieving an Opportunity record for the provided Id'));
		}

		return result;
	}

	public static Pricebook2 getOpportunityPriceBook(Opportunity opp)
	{
		Pricebook2 result = null;

		if (null != opp)
		{
			Id id = opp.Pricebook2Id;
			if (null != id)
			{
				try
				{
					result = [SELECT Id, Name, Description, IsStandard FROM Pricebook2 WHERE Id = :id LIMIT 1];
				}
				catch (Exception e)
				{
					System.debug(e);
					ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'There was an issue retrieving an Pricebook2 record for the provided Id'));
				}
			}
		}

		return result;
	}

	public static Pricebook2 getStandardPriceBook()
	{
		Pricebook2 result = null;

		try
		{
			result = [SELECT Id, Name, Description, IsStandard FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
		}
		catch (Exception e)
		{
			system.debug(e);
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'There was an issue retrieving the standard pricebook'));
		}

		return result;
	}

    public static Product2 getProductById(String id)
	{
        return getProductForGivenParameterAndValue('Id', id);
    }

    public static Product2 getProductByProductCode(string code)
	{
        return getProductForGivenParameterAndValue('ProductCode', code);
    }

    public static Product2 getProductByMaterialField(string mat)
	{
        return getProductForGivenParameterAndValue(UTIL_Product.MaterialFieldName, mat);
    }

    private static Product2 getProductForGivenParameterAndValue(String param, String value)
	{
        Product2 result = null;
        try
		{
            result = Database.query('SELECT Id ,Description,Family ,IsActive,LastReferencedDate,LastViewedDate, ' + UTIL_Product.MaterialFieldName + ' , Name FROM Product2 WHERE ' + param + ' = :value');
        }
		catch (Exception e)
		{
            System.debug(e);
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'There was an issue retrieving an Product record for the provided ' + param));
        }
        return result;
    }

    public static Account getAccountById(String id)
	{
        Account result = null;
        try
		{
            //parity left due to several uses-
            result = UTIL_Account.getAccountFromId(id);
        }
		catch (Exception e)
		{
            System.debug(e);
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'There was an issue retrieving an Account record for the provided Id'));
        }
        return result;
    }

    public static Account getAccountByCustomerId(String id)
	{
        Account result = null;
        try
		{
            result = Database.query('SELECT Name, BillingCity, Phone, BillingStreet, BillingPostalCode, BillingState, BillingCountry, CreatedDate, ParentId, ' + UTIL_Account.CustomerFieldName + ' from Account where ' + UTIL_Account.CustomerFieldName + '= :id LIMIT 1');
        }
		catch (Exception e)
		{
            System.debug(e);
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'There was an issue retrieving an Account record for the provided Customer Id'));
        }
        return result;
    }

    public static SBO_EnosixCustomer_Detail.EnosixCustomer GetCustomerForCase(Case cse)
	{
        SBO_EnosixCustomer_Detail.EnosixCustomer cust = new SBO_EnosixCustomer_Detail.EnosixCustomer();
        if (cse != null)
		{
            Account acct = getAccountById(cse.AccountId);
            if (acct != null)
			{
                String customerId = UTIL_Account.getCustomerNumberFromAccount(acct);
                if (string.isBlank(customerId))
				{
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,
                            'This account is not configured with an SAP customer'));
                }
				else
				{
                    cust = UTIL_Customer.fetchEnosixCustomer(customerId);
                    if (null == cust)
					{
                        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING,
                                'This Account/SAP customer is not configured for order creation'));
                    }
                }
            }
        }
        return cust;
    }

    public static SBO_EnosixMaterial_Detail.EnosixMaterial getMaterialFromMaterialNumber(string materialNumber)
	{
        SBO_EnosixMaterial_Detail sbo = new SBO_EnosixMaterial_Detail();
        //if (Test.isRunningTest()) EnosixFramework.setMock(EnosixFramework.DetailSBOMock.class, new TestMockUtils.MockSBO_EnosixSO_Search());

        SBO_EnosixMaterial_Detail.EnosixMaterial result = sbo.getDetail(materialNumber);

        if (!result.isSuccess())
		{
            ENSX.EnosixFramework.displayResultMessages(result, ensx.EnosixFramework.MessageType.INFO);
        }
        return result;
    }
}
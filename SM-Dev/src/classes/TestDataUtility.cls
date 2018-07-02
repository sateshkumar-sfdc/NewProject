@isTest
public class TestDataUtility {
    
    public static User newUser(String newUserName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(UserName = newUserName, EMail = newUserName, Alias = newUserName.left(8), CommunityNickname = newUserName, LastName = newUserName, ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US' );
        insert u;
        u = [SELECT Id FROM User WHERE UserName =: newUserName];
        return u;
    }
    
    public static Lead newLead(String leadLastName, String leadCompany, Boolean approved) {
        Lead l = new Lead(LastName = leadLastName, Company = leadCompany, Company_Email__c = 'name@company.com', Email = 'company@company.com', Street = 'Test Street', City = 'Test City', State = 'NV', PostalCode = '89521', Country = 'USA', Phone = '7757777777', Approved__c = approved);
        insert l;
        l = [SELECT Id, OwnerId FROM Lead WHERE LastName=:leadLastName ORDER BY Id DESC LIMIT 1];
        return l; 
    }

    public static Lead_Assignment_Rule__c newLeadAssignmentRule(Id salesRep, String zipCode) {
        Lead_Assignment_Rule__c lar = new Lead_Assignment_Rule__c(Name = zipcode, Zip_Code__c = zipcode, Sales_Rep__c = salesRep);
        insert lar;
        lar = [SELECT Id, Zip_Code__c, Sales_Rep__c FROM Lead_Assignment_Rule__c WHERE Zip_Code__c =: zipCode];         
        return lar;
    }
    
       
}
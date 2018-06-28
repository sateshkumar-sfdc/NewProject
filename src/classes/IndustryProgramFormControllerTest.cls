/*
Name                IndustryProgramFormControllerTest
Created By          Nitish Bansal
Created Date        03/10/2016
Purpose             T-483901
*/

@isTest
private class IndustryProgramFormControllerTest
{
    @isTest
    static void itShouldCreateCaseBBQ()
    {
       // acCore__FOB__c fob = TestDataUtility.newFOB('Origin', 'OR');
      //  acCore__PaymentTerms__c pt = TestDataUtility.newPaymentTerms('Credit Card', 'CC');
      //  acCore__ShippingMethod__c sm = TestDataUtility.newShippingMethod('FedEx Ground', 'FEDX');
     //   Account a = new Account(Name='accountName',acCore__ERPAccountType__c='Customer',BillingCountry='United States');
       // insert a;
        
      //  Contact c = new Contact(Email = 'nitish@my.in', LastName = 'lastName', AccountId = a.Id, MailingCountry='United States');
      //  insert c;
        
        IndustryProgramFormController classVar = new IndustryProgramFormController();
        classVar.firstName = 'Ni7ck';
        classVar.lastName = 'Te7st';
        classVar.streetLine1 = 'abc St7reet';
        classVar.city = 'M7DB';
        classVar.zipcode = '2440701';
        classVar.email = 'nitish@my.in';
        classVar.newcase.Country__c = 'United States';
        classVar.showProGuide = false;
        classVar.companyName = 'test companyName';
        classVar.showMilitary = false;
        classVar.militaryBranch = 'militaryBranch';
        classVar.showBBQ = true;
        classVar.teamName = 'teamName';
        classVar.headCookName ='headCookName';
        classVar.compBBQ = 'compBBQ';
        classVar.webAddr = 'https://www.abc.com';
        classVar.phoneNumber = '1234567890';
        classVar.doc1.Name = 'doc1.pdf';
        classVar.doc1.Body = Blob.valueof('doc1');
        classVar.doc2.Name = 'doc2.pdf';
        classVar.doc2.Body = Blob.valueof('doc2');
        classVar.doc3.Name = 'doc3.pdf';
        classVar.doc3.Body = Blob.valueof('doc3');
        classVar.doc.Name = 'doc4.pdf';
        classVar.doc.Body = Blob.valueof('doc4');
        classVar.newcase.T_C_Agreement__c = true;
        classVar.save();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Boolean messageFound = false;
            for(ApexPages.Message message : pageMessages) {
                if(message.getDetail().contains(Label.Case_Successfully_Created)) {
                    messageFound = true;        
                }
            }
            System.assertEquals(true, messageFound);
    }

    @isTest
    static void itShouldFireValidations()
    {
        IndustryProgramFormController classVar = new IndustryProgramFormController();
        
        classVar.newProg = 'Industry';
        classVar.selectProgram();
        classVar.newProg = 'BBQ';
        classVar.selectProgram();
        classVar.showProGuide = true;
        classVar.showMilitary = true;
        classVar.showBBQ = true;
        classVar.newProg = 'Military';
        classVar.selectProgram();

        classVar.doc1.Name = 'doc1';
        classVar.doc1.Body = Blob.valueof('doc1');
        classVar.doc2.Name = 'doc2';
        classVar.doc2.Body = Blob.valueof('doc2');
        classVar.doc3.Name = 'doc3';
        classVar.doc3.Body = Blob.valueof('doc3');
        classVar.doc.Name = 'doc4';
        classVar.doc.Body = Blob.valueof('doc4');
        classVar.save();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Boolean messageFound = false;
            for(ApexPages.Message message : pageMessages) {
                if(message.getDetail().contains(Label.Case_Successfully_Created)) {
                    messageFound = true;        
                }
            }
            System.assertEquals(false, messageFound);
    }

    @isTest
    static void itShouldFireMoreValidations()
    {
        IndustryProgramFormController classVar = new IndustryProgramFormController();
        
        classVar.showProGuide = true;
        classVar.showMilitary = true;
        classVar.showBBQ = true;
        classVar.newProg = 'BBQ';
        classVar.selectProgram();
        classVar.newcase.Country__c = 'Canada';
        classVar.zipcode = '244001';
        classVar.doc1.Name = 'doc1';
        classVar.doc1.Body = Blob.valueof('doc1');
        classVar.doc2.Name = 'doc2';
        classVar.doc2.Body = Blob.valueof('doc2');
        classVar.doc3.Name = 'doc3';
        classVar.doc3.Body = Blob.valueof('doc3');
        classVar.doc.Name = 'doc4';
        classVar.doc.Body = Blob.valueof('doc4');
        classVar.save();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Boolean messageFound = false;
            for(ApexPages.Message message : pageMessages) {
                if(message.getDetail().contains(Label.Case_Successfully_Created)) {
                    messageFound = true;        
                }
            }
            System.assertEquals(false, messageFound);
    }

    @isTest
    static void itShouldCreateCaseMilitary()
    {
        IndustryProgramFormController classVar = new IndustryProgramFormController();
        classVar.firstName = 'Nick';
        classVar.lastName = 'Test';
        classVar.streetLine1 = 'abc Street';
        classVar.city = 'MDB';
        classVar.zipcode = '244001';
        classVar.email = 'nick@nick.com';
        classVar.newcase.Country__c = 'United States';
        classVar.showProGuide = false;
        classVar.companyName = 'test companyName';
        classVar.showMilitary = true;
        classVar.militaryBranch = 'militaryBranch';
        classVar.showBBQ = false;
        classVar.teamName = 'teamName';
        classVar.headCookName ='headCookName';
        classVar.compBBQ = 'compBBQ';
        classVar.newcase.T_C_Agreement__c = true;
        classVar.webAddr = 'https://www.abc.com';
        classVar.phoneNumber = '1234567890';
        classVar.doc1.Name = 'doc1.pdf';
        classVar.doc1.Body = Blob.valueof('doc1');
        classVar.doc2.Name = 'doc2.pdf';
        classVar.doc2.Body = Blob.valueof('doc2');
        classVar.doc3.Name = 'doc3.pdf';
        classVar.doc3.Body = Blob.valueof('doc3');
        classVar.doc.Name = 'doc4.pdf';
        classVar.doc.Body = Blob.valueof('doc3');
    }

    @isTest
    static void itShouldCreateCasePro()
    {
        IndustryProgramFormController classVar = new IndustryProgramFormController();
        classVar.firstName = 'Nick';
        classVar.lastName = 'Test';
        classVar.streetLine1 = 'abc Street';
        classVar.city = 'MDB';
        classVar.zipcode = '244001';
        classVar.email = 'nick@nick.com';
        classVar.newcase.Country__c = 'United States';
        classVar.showProGuide = true;
        classVar.companyName = 'test companyName';
        classVar.showMilitary = false;
        classVar.militaryBranch = 'militaryBranch';
        classVar.showBBQ = false;
        classVar.teamName = 'teamName';
        classVar.headCookName ='headCookName';
        classVar.compBBQ = 'compBBQ';
        classVar.newcase.T_C_Agreement__c = true;
        classVar.webAddr = 'https://www.abc.com';
        classVar.phoneNumber = '1234567890';
        classVar.doc1.Name = 'doc1.pdf';
        classVar.doc1.Body = Blob.valueof('doc1');
        classVar.doc2.Name = 'doc2.pdf';
        classVar.doc2.Body = Blob.valueof('doc2');
        classVar.doc3.Name = 'doc3.pdf';
        classVar.doc3.Body = Blob.valueof('doc3');
        classVar.doc.Name = 'doc4.pdf';
        classVar.doc.Body = Blob.valueof('doc3');
    }

    @isTest
    static void itShouldFireCanadaValidation()
    {
        IndustryProgramFormController classVar = new IndustryProgramFormController();
        
        classVar.showProGuide = true;
        classVar.webAddr = 'com';
        classVar.newcase.Country__c = 'Canada';
        classVar.zipcode = '24001';
        
        classVar.save();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Boolean messageFound = false;
            for(ApexPages.Message message : pageMessages) {
                if(message.getDetail().contains(Label.Case_Successfully_Created)) {
                    messageFound = true;        
                }
            }
            System.assertEquals(false, messageFound);
    }

    @isTest
    static void itShouldFireUSzipValidation()
    {
        IndustryProgramFormController classVar = new IndustryProgramFormController();
        
        classVar.showProGuide = true;
        classVar.webAddr = 'com';
        classVar.zipcode = '240';
        
        classVar.save();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Boolean messageFound = false;
            for(ApexPages.Message message : pageMessages) {
                if(message.getDetail().contains(Label.Case_Successfully_Created)) {
                    messageFound = true;        
                }
            }
            System.assertEquals(false, messageFound);
    }
}
/*
*************************************************************
** Name: UpdateOpportunityOwner_test.apxc              	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose: (Omni Channel)								   **
** This Server Side controller handles based on WorkItemId **
** Capture the Work Accepted owner and Update the Owner to ** 
** Orginal Opportunity.                                    **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 05/04/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/
@isTest
public class UpdateOpportunityOwner_test {
    
    //test method1
    static testMethod void testMethod1(){
        
        System.test.startTest();
        
        //insert User
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-',''); 
        
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id); 
        insert uu;
        
        // insert Account          
        Account acc = new Account(Name ='Test Account',
                                  Industry ='test');
        insert acc;
        
        // insert opportunity
        Opportunity opp = new Opportunity(Name = 'TestOpportunity',
                                          CloseDate=System.today(),
                                          AccountId = acc.id,
                                          StageName = 'Prospecting',
                                          PO_Number__c = '12345',
                                          Need_By_Date__c = System.today());
        insert opp;
        
        // insert Custom OpportunityAssignment
        OpportunityAssignment__c oppa = new OpportunityAssignment__c(Opportunity__c = opp.id,
                                                                     Name = opp.Name);
        insert oppa;
        
        oppa.OwnerId = uu.Id;
        update oppa;
        
        system.assertEquals('Success',UpdateOpportunityOwner.updateOpportunityOwner(oppa.Id));
        System.test.stopTest();
        
        
    }
}
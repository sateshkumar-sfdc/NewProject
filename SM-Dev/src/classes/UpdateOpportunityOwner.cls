/*
*************************************************************
** Name: UpdateOpportunityOwner.apxc                	   **
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

public class UpdateOpportunityOwner {
    
    // @AuraEnabled to enable Client -and server-side access to the method
    @AuraEnabled
    public static string updateOpportunityOwner(Id workItemId){
        try { 
            //system.debug('Test ----' + workItemId);
            //Capturing the OpportunityAssignment Owner based on the workItemId.
            List<OpportunityAssignment__c> opptList = [SELECT Id, name, owner.Id, Opportunity__c, owner.name FROM OpportunityAssignment__c WHERE Id =:workItemId LIMIT 1];
            List<Opportunity> originalOppUpdate = new List<Opportunity>();
            
            // if Owner name as Queue shouldn't assign to orginal Opportunity
            for(OpportunityAssignment__c op : opptList) {
                String s1 = op.owner.id;
                if(!s1.startsWith('00G')) {
                    opportunity o = new opportunity();
                    o.Id = op.Opportunity__c;
                    o.OwnerId = op.owner.Id; 
                    originalOppUpdate.add(o);
                } 
            }                 
            
            //Size greater than 0 Update DML will fire on Opportunity and Update the owner as Work Accepted Owner
            if(originalOppUpdate.size()>0) {
                update originalOppUpdate;
            }
            
            //System.debug('query result'+opptList);
            return 'Success';
        }catch(exception e){
            System.debug('Error : '+e.getMessage());
            return null;
        }
    } 
}
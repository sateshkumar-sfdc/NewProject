public class LeadUtil{

    //The leadAssignment method assigns leads owners based on zip code (lookups user based on zip code in lead_assignment__c object)
    public static void leadAssignment(List<Lead> leads) {

        //Create list of zip codes on new leads
        List<String> zipCodes = new List<String>();
        for (Lead l : leads) {
            if (l.PostalCode <> '' && l.PostalCode <> null) {
                zipCodes.add(l.PostalCode.Left(5));
            }
        }

        //Create list of states on new leads
        List<String> states = new List<String>();
        for (Lead l : leads) {
            if (l.State <> '' && l.State <> null) {
                states.add(l.State);
            }
        }

        //Create map of zip codes to Sales Reps for assignment
        List<Lead_Assignment_Rule__c> leadAssignRulesZip = [SELECT Zip_Code__c, Sales_Rep__c FROM Lead_Assignment_Rule__c WHERE Zip_Code__c IN : zipCodes];
        Map<String,Lead_Assignment_Rule__c> zipToAssignRuleZipMap = new Map<String,Lead_Assignment_Rule__c>();
        for (Lead_Assignment_Rule__c lar : leadAssignRulesZip) {
            zipToAssignRuleZipMap.put(lar.Zip_Code__c, lar);
        }

        //Create map of States to Sales Reps for assignment
        List<Lead_Assignment_Rule__c> leadAssignRulesState = [SELECT State__c, Sales_Rep__c FROM Lead_Assignment_Rule__c WHERE State__c IN : states];
        Map<String,Lead_Assignment_Rule__c> zipToAssignRuleStateMap = new Map<String,Lead_Assignment_Rule__c>();
        for (Lead_Assignment_Rule__c lar : leadAssignRulesState) {
            zipToAssignRuleStateMap.put(lar.State__c, lar);
        }


    String recordTypeName = 'Dealer'; // 
      Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Lead.getRecordTypeInfosByName();
      Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
      id recordTypeId = rtInfo.getRecordTypeId();
    
        //Assign new leads to appropriate owner (based on zip) and set Lead Assigned by Zip Code flag
        // List<RecordType> rt [SELECT Id FROM RecordType FROM Lead WHERE Name = Dealer LIMIT 1];
        for (Lead l : leads) {
         if(l.RecordTypeId == recordTypeId) {
          Integer counter = 0;
    
            if (zipToAssignRuleZipMap.containsKey(l.PostalCode)) {
                l.Lead_Assigned_by_Zip_Code__c = true;
                l.OwnerId = zipToAssignRuleZipMap.get(l.PostalCode).Sales_Rep__c;
                
            }
        }

     //   for (lead l : leads) {
            if (zipToAssignRuleStateMap.containsKey(l.State) && l.Lead_Assigned_by_Zip_Code__c == false) {
                l.Lead_Assigned_by_State__c = true;
                l.OwnerId = zipToAssignRuleStateMap.get(l.State).Sales_Rep__c;
            }
        }

    }
}
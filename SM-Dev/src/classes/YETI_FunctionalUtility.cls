//
// (c) 2017 Appirio, Inc.
//
// Apex Class Name: YETI_FunctionalUtility
// Description: This apex class contains utility methods.
//
// 03rd March 2017    Hemendra Singh Bhati    Original (Task # T-581740) - Please see the task description for more details.
// 21st March 2017    Hemendra Singh Bhati    Modified (Task # T-586235) - Please see the task description for more details.
//
public class YETI_FunctionalUtility {
  // Public Constants.
  public final static Id DEALER_CORPORATE_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = :Label.YETI_DealerCorporateProfileName].Id;

  // Public Data Members.
  // Private Constants.
  // Private Data Members.

  /*
  @method      : getDealerCorporateUserAccountId
  @description : This method is used to fetch account id for the currently logged-in partner community login user
                 with profile named "Dealer - Corporate".
  @params      : void
  @returns     : Id theAccountId
  */
  public static Id getDealerCorporateUserAccountId() {
    Id theAccountId = null;
    for(User theUser : [SELECT Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()]) {
      theAccountId = theUser.Contact.AccountId;
    }
    return theAccountId;
  }

  /*
  @method      : isTriggerActive
  @description : This method queries custom metadata type named "Trigger_Setting__mdt" to determine whether a particular apex
                 trigger is turned ON or OFF.
  @params      : String theApexTriggerName
  @returns     : Boolean isActive
  */
  public static Boolean isTriggerActive(String theApexTriggerName) {
    Boolean isActive = true;
    if(String.isNotBlank(theApexTriggerName)) {
      for(Trigger_Setting__mdt theRecord : [SELECT DeveloperName, Switch_Trigger_Off__c FROM Trigger_Setting__mdt
                                            WHERE DeveloperName = :theApexTriggerName]) {
        if(theRecord.Switch_Trigger_Off__c) {
          isActive = false;
        }
      }
    }
    return isActive;
  }

  /*
  @method      : insertOrderShareRecords
  @description : This method is used to insert "Order__c" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndOrderIdsMap
  @returns     : void
  */
  public void insertOrderShareRecords(Map<Id, Set<Id>> theUserIdAndOrderIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - insertOrderShareRecords - theUserIdAndOrderIdsMap - ' + theUserIdAndOrderIdsMap);

    // Initializing data member.
    List<Order__Share> toBeInserted = new List<Order__Share>();

    // Determining order share records to insert.
    for(Id theUserId : theUserIdAndOrderIdsMap.keySet()) {
      for(Id theOrderId : theUserIdAndOrderIdsMap.get(theUserId)) {
        toBeInserted.add(new Order__Share(
          ParentId = theOrderId,
          UserOrGroupId = theUserId,
          AccessLevel = 'Read',
          RowCause = Schema.Order__Share.RowCause.Manual
        ));
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - insertOrderShareRecords - toBeInserted - ' + toBeInserted);

    // Inserting order share records.
    if(toBeInserted.size() > 0) {
      List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);
      System.debug('TRACE: YETI_FunctionalUtility - insertOrderShareRecords - theSaveResult - ' + theSaveResult);
    }
  }

  /*
  @method      : deleteOrderShareRecords
  @description : This method is used to delete "Order__c" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndOrderIdsMap
  @returns     : void
  */
  public void deleteOrderShareRecords(Map<Id, Set<Id>> theUserIdAndOrderIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - deleteOrderShareRecords - theUserIdAndOrderIdsMap - ' + theUserIdAndOrderIdsMap);

    // Initializing data member.
    Set<Id> theUserIds = new Set<Id>();
    Set<Id> theOrderIds = new Set<Id>();
    List<Order__Share> toBeDeleted = new List<Order__Share>();

    // Determining user ids and order ids to process.
    for(Id theUserId : theUserIdAndOrderIdsMap.keySet()) {
      theUserIds.add(theUserId);
      for(Id theOrderId : theUserIdAndOrderIdsMap.get(theUserId)) {
        theOrderIds.add(theOrderId);
      }
    }

    // Determining order share records to delete.
    for(Order__Share theRecord : [SELECT UserOrGroupId, ParentId FROM Order__Share WHERE UserOrGroupId IN :theUserIds AND
                                  ParentId IN :theOrderIds]) {
      if(
        theUserIdAndOrderIdsMap.containsKey(theRecord.UserOrGroupId) &&
        theUserIdAndOrderIdsMap.get(theRecord.UserOrGroupId).contains(theRecord.ParentId)
      ) {
        toBeDeleted.add(theRecord);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - deleteOrderShareRecords - toBeDeleted - ' + toBeDeleted);

    // Deleting order share records.
    if(toBeDeleted.size() > 0) {
      List<Database.DeleteResult> theDeleteResult = Database.delete(toBeDeleted, false);
      System.debug('TRACE: YETI_FunctionalUtility - deleteOrderShareRecords - theDeleteResult - ' + theDeleteResult);
    }
  }

  /*
  @method      : insertInvoiceShareRecords
  @description : This method is used to insert "Invoice__c" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndInvoiceIdsMap
  @returns     : void
  */
  public void insertInvoiceShareRecords(Map<Id, Set<Id>> theUserIdAndInvoiceIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - insertInvoiceShareRecords - theUserIdAndInvoiceIdsMap - ' + theUserIdAndInvoiceIdsMap);

    // Initializing data member.
    List<Invoice__Share> toBeInserted = new List<Invoice__Share>();

    // Determining invoice share records to insert.
    for(Id theUserId : theUserIdAndInvoiceIdsMap.keySet()) {
      for(Id theInvoiceId : theUserIdAndInvoiceIdsMap.get(theUserId)) {
        toBeInserted.add(new Invoice__Share(
          ParentId = theInvoiceId,
          UserOrGroupId = theUserId,
          AccessLevel = 'Read',
          RowCause = Schema.Invoice__Share.RowCause.Manual
        ));
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - insertInvoiceShareRecords - toBeInserted - ' + toBeInserted);

    // Inserting invoice share records.
    if(toBeInserted.size() > 0) {
      List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);
      System.debug('TRACE: YETI_FunctionalUtility - insertInvoiceShareRecords - theSaveResult - ' + theSaveResult);
    }
  }

  /*
  @method      : deleteInvoiceShareRecords
  @description : This method is used to delete "Invoice__c" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndInvoiceIdsMap
  @returns     : void
  */
  public void deleteInvoiceShareRecords(Map<Id, Set<Id>> theUserIdAndInvoiceIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - deleteInvoiceShareRecords - theUserIdAndInvoiceIdsMap - ' + theUserIdAndInvoiceIdsMap);

    // Initializing data member.
    Set<Id> theUserIds = new Set<Id>();
    Set<Id> theInvoiceIds = new Set<Id>();
    List<Invoice__Share> toBeDeleted = new List<Invoice__Share>();

    // Determining user ids and invoice ids to process.
    for(Id theUserId : theUserIdAndInvoiceIdsMap.keySet()) {
      theUserIds.add(theUserId);
      for(Id theInvoiceId : theUserIdAndInvoiceIdsMap.get(theUserId)) {
        theInvoiceIds.add(theInvoiceId);
      }
    }

    // Determining invoice share records to delete.
    for(Invoice__Share theRecord : [SELECT UserOrGroupId, ParentId FROM Invoice__Share WHERE UserOrGroupId IN :theUserIds AND
                                    ParentId IN :theInvoiceIds]) {
      if(
        theUserIdAndInvoiceIdsMap.containsKey(theRecord.UserOrGroupId) &&
        theUserIdAndInvoiceIdsMap.get(theRecord.UserOrGroupId).contains(theRecord.ParentId)
      ) {
        toBeDeleted.add(theRecord);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - deleteInvoiceShareRecords - toBeDeleted - ' + toBeDeleted);

    // Deleting invoice share records.
    if(toBeDeleted.size() > 0) {
      List<Database.DeleteResult> theDeleteResult = Database.delete(toBeDeleted, false);
      System.debug('TRACE: YETI_FunctionalUtility - deleteInvoiceShareRecords - theDeleteResult - ' + theDeleteResult);
    }
  }

  /*
  @method      : insertDeliveriesShareRecords
  @description : This method is used to insert "Deliveries__c" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndDeliveriesIdsMap
  @returns     : void
  */
  public void insertDeliveriesShareRecords(Map<Id, Set<Id>> theUserIdAndDeliveriesIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - insertDeliveriesShareRecords - theUserIdAndDeliveriesIdsMap - ' + theUserIdAndDeliveriesIdsMap);

    // Initializing data member.
    List<Deliveries__Share> toBeInserted = new List<Deliveries__Share>();

    // Determining deliveries share records to insert.
    for(Id theUserId : theUserIdAndDeliveriesIdsMap.keySet()) {
      for(Id theDeliveriesId : theUserIdAndDeliveriesIdsMap.get(theUserId)) {
        toBeInserted.add(new Deliveries__Share(
          ParentId = theDeliveriesId,
          UserOrGroupId = theUserId,
          AccessLevel = 'Read',
          RowCause = Schema.Deliveries__Share.RowCause.Manual
        ));
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - insertDeliveriesShareRecords - toBeInserted - ' + toBeInserted);

    // Inserting deliveries share records.
    if(toBeInserted.size() > 0) {
      List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);
      System.debug('TRACE: YETI_FunctionalUtility - insertDeliveriesShareRecords - theSaveResult - ' + theSaveResult);
    }
  }

  /*
  @method      : deleteDeliveriesShareRecords
  @description : This method is used to delete "Deliveries__c" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndDeliveriesIdsMap
  @returns     : void
  */
  public void deleteDeliveriesShareRecords(Map<Id, Set<Id>> theUserIdAndDeliveriesIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - deleteDeliveriesShareRecords - theUserIdAndDeliveriesIdsMap - ' + theUserIdAndDeliveriesIdsMap);

    // Initializing data member.
    Set<Id> theUserIds = new Set<Id>();
    Set<Id> theDeliveriesIds = new Set<Id>();
    List<Deliveries__Share> toBeDeleted = new List<Deliveries__Share>();

    // Determining user ids and deliveries ids to process.
    for(Id theUserId : theUserIdAndDeliveriesIdsMap.keySet()) {
      theUserIds.add(theUserId);
      for(Id theDeliveriesId : theUserIdAndDeliveriesIdsMap.get(theUserId)) {
        theDeliveriesIds.add(theDeliveriesId);
      }
    }

    // Determining deliveries share records to delete.
    for(Deliveries__Share theRecord : [SELECT UserOrGroupId, ParentId FROM Deliveries__Share WHERE UserOrGroupId IN :theUserIds AND
                                                                             ParentId IN :theDeliveriesIds]) {
      if(
        theUserIdAndDeliveriesIdsMap.containsKey(theRecord.UserOrGroupId) &&
        theUserIdAndDeliveriesIdsMap.get(theRecord.UserOrGroupId).contains(theRecord.ParentId)
      ) {
        toBeDeleted.add(theRecord);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - deleteDeliveriesShareRecords - toBeDeleted - ' + toBeDeleted);

    // Deleting deliveries share records.
    if(toBeDeleted.size() > 0) {
      List<Database.DeleteResult> theDeleteResult = Database.delete(toBeDeleted, false);
      System.debug('TRACE: YETI_FunctionalUtility - deleteDeliveriesShareRecords - theDeleteResult - ' + theDeleteResult);
    }
  }

  /*
  @method      : insertOpportunityShareRecords
  @description : This method is used to insert "Opportunity" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndOpportunityIdsMap
  @returns     : void
  */
  public void insertOpportunityShareRecords(Map<Id, Set<Id>> theUserIdAndOpportunityIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - insertOpportunityShareRecords - theUserIdAndOpportunityIdsMap - ' + theUserIdAndOpportunityIdsMap);

    // Initializing data member.
    List<OpportunityShare> toBeInserted = new List<OpportunityShare>();

    // Determining opportunity share records to insert.
    for(Id theUserId : theUserIdAndOpportunityIdsMap.keySet()) {
      for(Id theOpportunityId : theUserIdAndOpportunityIdsMap.get(theUserId)) {
        toBeInserted.add(new OpportunityShare(
          OpportunityId = theOpportunityId,
          UserOrGroupId = theUserId,
          OpportunityAccessLevel = 'Read',
          RowCause = Schema.OpportunityShare.RowCause.Manual
        ));
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - insertOpportunityShareRecords - toBeInserted - ' + toBeInserted);

    // Inserting opportunity share records.
    if(toBeInserted.size() > 0) {
      List<Database.SaveResult> theSaveResult = Database.insert(toBeInserted, false);
      System.debug('TRACE: YETI_FunctionalUtility - insertOpportunityShareRecords - theSaveResult - ' + theSaveResult);
    }
  }

  /*
  @method      : deleteOpportunityShareRecords
  @description : This method is used to delete "Opportunity" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndOpportunityIdsMap
  @returns     : void
  */
  public void deleteOpportunityShareRecords(Map<Id, Set<Id>> theUserIdAndOpportunityIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - deleteOpportunityShareRecords - theUserIdAndOpportunityIdsMap - ' + theUserIdAndOpportunityIdsMap);

    // Initializing data member.
    Set<Id> theUserIds = new Set<Id>();
    Set<Id> theOpportunityIds = new Set<Id>();
    List<OpportunityShare> toBeDeleted = new List<OpportunityShare>();

    // Determining user ids and opportunity ids to process.
    for(Id theUserId : theUserIdAndOpportunityIdsMap.keySet()) {
      theUserIds.add(theUserId);
      for(Id theOpportunityId : theUserIdAndOpportunityIdsMap.get(theUserId)) {
        theOpportunityIds.add(theOpportunityId);
      }
    }

    // Determining opportunity share records to delete.
    for(OpportunityShare theRecord : [SELECT UserOrGroupId, OpportunityId FROM OpportunityShare WHERE UserOrGroupId IN :theUserIds AND
                                                                            OpportunityId IN :theOpportunityIds]) {
      if(
        theUserIdAndOpportunityIdsMap.containsKey(theRecord.UserOrGroupId) &&
        theUserIdAndOpportunityIdsMap.get(theRecord.UserOrGroupId).contains(theRecord.OpportunityId)
      ) {
        toBeDeleted.add(theRecord);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - deleteOpportunityShareRecords - toBeDeleted - ' + toBeDeleted);

    // Deleting opportunity share records.
    if(toBeDeleted.size() > 0) {
      List<Database.DeleteResult> theDeleteResult = Database.delete(toBeDeleted, false);
      System.debug('TRACE: YETI_FunctionalUtility - deleteOpportunityShareRecords - theDeleteResult - ' + theDeleteResult);
    }
  }

  /*
  @method      : insertCaseShareRecords
  @description : This method is used to insert "Case" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndCaseIdsMap
  @returns     : void
  */
  public void insertCaseShareRecords(Map<Id, Set<Id>> theUserIdAndCaseIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - insertCaseShareRecords - theUserIdAndCaseIdsMap - ' + theUserIdAndCaseIdsMap);

    // Initializing data member.
    List<CaseShare> toBeInserted = new List<CaseShare>();

    // Determining case share records to insert.
    CaseShare theCaseShare = null;
    for(Id theUserId : theUserIdAndCaseIdsMap.keySet()) {
      for(Id theCaseId : theUserIdAndCaseIdsMap.get(theUserId)) {
        theCaseShare = new CaseShare(
          CaseId = theCaseId,
          UserOrGroupId = theUserId,
          CaseAccessLevel = 'Read',
          RowCause = Schema.CaseShare.RowCause.Manual
        );
        System.debug('TRACE: YETI_FunctionalUtility - insertCaseShareRecords - theCaseShare - ' + theCaseShare);

        toBeInserted.add(theCaseShare);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - insertCaseShareRecords - toBeInserted - ' + toBeInserted);

    // Inserting case share records.
    if(toBeInserted.size() > 0) {
      List<Database.SaveResult> theSaveResults = Database.insert(toBeInserted, false);
      for(Database.SaveResult theSaveResult : theSaveResults) {
        if(theSaveResult.isSuccess()) {
          System.debug('TRACE: YETI_FunctionalUtility - insertCaseShareRecords - Case Share Id - ' + theSaveResult.getId());
        }
        else {
          System.debug('TRACE: YETI_FunctionalUtility - insertCaseShareRecords - Error - ');
          for(Database.Error theError : theSaveResult.getErrors()) {
            System.debug(theError.getStatusCode() + ' - ' + theError.getMessage() + ' - ' + theError.getFields());
          }
        }
      }
    }
  }

  /*
  @method      : deleteCaseShareRecords
  @description : This method is used to delete "Case" sharing records.
  @params      : Map<Id, Set<Id>> theUserIdAndCaseIdsMap
  @returns     : void
  */
  public void deleteCaseShareRecords(Map<Id, Set<Id>> theUserIdAndCaseIdsMap) {
    System.debug('TRACE: YETI_FunctionalUtility - deleteCaseShareRecords - theUserIdAndCaseIdsMap - ' + theUserIdAndCaseIdsMap);

    // Initializing data member.
    Set<Id> theUserIds = new Set<Id>();
    Set<Id> theCaseIds = new Set<Id>();
    List<CaseShare> toBeDeleted = new List<CaseShare>();

    // Determining user ids and case ids to process.
    for(Id theUserId : theUserIdAndCaseIdsMap.keySet()) {
      theUserIds.add(theUserId);
      for(Id theCaseId : theUserIdAndCaseIdsMap.get(theUserId)) {
        theCaseIds.add(theCaseId);
      }
    }

    // Determining case share records to delete.
    for(CaseShare theRecord : [SELECT UserOrGroupId, CaseId FROM CaseShare WHERE UserOrGroupId IN :theUserIds AND
                               CaseId IN :theCaseIds]) {
      if(
        theUserIdAndCaseIdsMap.containsKey(theRecord.UserOrGroupId) &&
        theUserIdAndCaseIdsMap.get(theRecord.UserOrGroupId).contains(theRecord.CaseId)
      ) {
        toBeDeleted.add(theRecord);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - deleteCaseShareRecords - toBeDeleted - ' + toBeDeleted);

    // Deleting case share records.
    if(toBeDeleted.size() > 0) {
      List<Database.DeleteResult> theDeleteResult = Database.delete(toBeDeleted, false);
      System.debug('TRACE: YETI_FunctionalUtility - deleteCaseShareRecords - theDeleteResult - ' + theDeleteResult);
    }
  }

  /*
  @method      : findParentAccountId
  @description : This method is used to search account parent id in a map passed a method parameter.
  @params      : String childAccountId, Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap
  @returns     : Id theParentAccountId
  */
  public Id findParentAccountId(String childAccountId, Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap) {
    System.debug('TRACE: YETI_FunctionalUtility - findParentAccountId - childAccountId - ' + childAccountId);
    System.debug('TRACE: YETI_FunctionalUtility - findParentAccountId - theChildAccountIdsAndItsParentAccountIdMap - ' + theChildAccountIdsAndItsParentAccountIdMap);

    // Initializing data members.
    Id theParentAccountId = null;

    // Searching for parent account id.
    if(theChildAccountIdsAndItsParentAccountIdMap.size() > 0) {
      for(String childAccountIds : theChildAccountIdsAndItsParentAccountIdMap.keySet()) {
        if(childAccountIds.contains(childAccountId)) {
          theParentAccountId = theChildAccountIdsAndItsParentAccountIdMap.get(childAccountIds);
          break;
        }
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - findParentAccountId - theParentAccountId - ' + theParentAccountId);

    return theParentAccountId;
  }

  /*
  @method      : determineParentAccountIds
  @description : This method is used to determine parent accounts ids for child accounts ids passed as method parameter.
  @params      : Set<Id> theAccountIdsSet
  @returns     : Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap
  */
  public Map<String, Id> determineParentAccountIds(Set<Id> theAccountIdsSet) {
    System.debug('TRACE: YETI_FunctionalUtility - determineParentAccountIds - theAccountIdsSet - ' + theAccountIdsSet);

    // Initializing data members.
    Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap = new Map<String, Id>();
    Map<Id, Set<Id>> theParentAccountIdAndChildAccountIdsMap = new Map<Id, Set<Id>>();

    // Fetching parent account ids.
    if(theAccountIdsSet.size() > 0) {
      for(Account theAccount : [SELECT ParentId FROM Account WHERE Id IN :theAccountIdsSet AND ParentId != null]) {
        if(!theParentAccountIdAndChildAccountIdsMap.containsKey(theAccount.ParentId)) {
          theParentAccountIdAndChildAccountIdsMap.put(theAccount.ParentId, new Set<Id>());
        }
        theParentAccountIdAndChildAccountIdsMap.get(theAccount.ParentId).add(theAccount.Id);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - determineParentAccountIds - theParentAccountIdAndChildAccountIdsMap - ' + theParentAccountIdAndChildAccountIdsMap);

    // Building a map of child account ids and parent account id.
    if(theParentAccountIdAndChildAccountIdsMap.size() > 0) {
      String childAccountIds = null;
      for(Id parentAccountId : theParentAccountIdAndChildAccountIdsMap.keySet()) {
        childAccountIds = '';
        for(Id childAccountId : theParentAccountIdAndChildAccountIdsMap.get(parentAccountId)) {
          childAccountIds += childAccountId + '-';
        }
        childAccountIds = childAccountIds.removeEnd('-');
        theChildAccountIdsAndItsParentAccountIdMap.put(childAccountIds, parentAccountId);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - determineParentAccountIds - theChildAccountIdsAndItsParentAccountIdMap - ' + theChildAccountIdsAndItsParentAccountIdMap);

    return theChildAccountIdsAndItsParentAccountIdMap;
  }

  /*
  @method      : extractPartnerUserIds
  @description : This method is used to determine partner user ids for account ids passed as parameter.
  @params      : Set<Id> theAccountIdsSet
  @returns     : Map<Id, Set<Id>> theAccountIdAndUserIdsMap
  */
  public Map<Id, Set<Id>> extractPartnerUserIds(Set<Id> theAccountIdsSet) {
    System.debug('TRACE: YETI_FunctionalUtility - extractPartnerUserIds - theAccountIdsSet - ' + theAccountIdsSet);

    // Initializing data members.
    Map<Id, Set<Id>> theAccountIdAndUserIdsMap = new Map<Id, Set<Id>>();
    if(theAccountIdsSet.size() > 0) {
      for(User theUser : [SELECT Contact.AccountId FROM User WHERE ProfileId = :DEALER_CORPORATE_PROFILE_ID AND isActive = true AND
                          Contact.AccountId IN :theAccountIdsSet]) {
        if(!theAccountIdAndUserIdsMap.containsKey(theUser.Contact.AccountId)) {
          theAccountIdAndUserIdsMap.put(theUser.Contact.AccountId, new Set<Id>());
        }
        theAccountIdAndUserIdsMap.get(theUser.Contact.AccountId).add(theUser.Id);
      }
    }
    System.debug('TRACE: YETI_FunctionalUtility - extractPartnerUserIds - theAccountIdAndUserIdsMap - ' + theAccountIdAndUserIdsMap);

    return theAccountIdAndUserIdsMap;
  }
}
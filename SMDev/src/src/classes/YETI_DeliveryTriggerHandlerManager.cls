//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Manager Name: YETI_DeliveryTriggerHandlerManager
// For Apex Trigger Handler: YETI_DeliveryTriggerHandler
// For Apex Trigger: YETI_DeliveryTrigger
// On SObject: Deliveries__c
// Description: This apex trigger handler manager class implements the following functionalities:
//  1: A dealer corporate user must have read access to all deliveries(Deliveries__c) associated with partner user's contact account record and
//     its parent account record.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
// 22nd March 2017    Hemendra Singh Bhati    Modified (Task # T-586235) - Please see the task description for more details.
//
public without sharing class YETI_DeliveryTriggerHandlerManager {
  // Private Constants.
  // Private Data Members.
  // Public Data Members.

  /*
  @method      : grantRevokeAccessToDeliveryRecords
  @description : This method is used to grant/revoke access to/from delivery records for "Dealer - Corporate" profile user
                 with license "Partner Community Login".
  @params      : List<Deliveries__c> newValues, Map<Id, Deliveries__c> oldMap, Boolean isInsert
  @returns     : void
  */
  public void grantRevokeAccessToDeliveryRecords(List<Deliveries__c> newValues, Map<Id, Deliveries__c> oldMap, Boolean isInsert) {
    // Initializing data members.
    Set<Id> deliveryAccountIds = new Set<Id>();
    Map<Id, Set<Id>> grantDeliveryIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<Id, Set<Id>> revokeDeliveryIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap = new Map<String, Id>();

    // Processing newly inserted delivery records.
    if(isInsert) {
      for(Deliveries__c theDelivery : newValues) {
        if(!grantDeliveryIdAndAccountIdsMap.containsKey(theDelivery.Id)) {
          grantDeliveryIdAndAccountIdsMap.put(theDelivery.Id, new Set<Id>());
        }

        if(theDelivery.Bill_To__c != null) {
          deliveryAccountIds.add(theDelivery.Bill_To__c);
          grantDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(theDelivery.Bill_To__c);
        }
        if(theDelivery.Ship_To__c != null) {
          deliveryAccountIds.add(theDelivery.Ship_To__c);
          grantDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(theDelivery.Ship_To__c);
        }
        if(theDelivery.Sold_To__c != null) {
          deliveryAccountIds.add(theDelivery.Sold_To__c);
          grantDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(theDelivery.Sold_To__c);
        }
      }
    }
    // Processing newly updated delivery records.
    else {
      for(Deliveries__c theDelivery : newValues) {
        // Grant access to delivery records mapping.
        if(!grantDeliveryIdAndAccountIdsMap.containsKey(theDelivery.Id)) {
          grantDeliveryIdAndAccountIdsMap.put(theDelivery.Id, new Set<Id>());
        }

        // Revoke access to delivery records mapping.
        if(!revokeDeliveryIdAndAccountIdsMap.containsKey(theDelivery.Id)) {
          revokeDeliveryIdAndAccountIdsMap.put(theDelivery.Id, new Set<Id>());
        }

        // Bill to account changed.
        if(oldMap.get(theDelivery.Id).Bill_To__c != theDelivery.Bill_To__c) {
          // Old bill to account id.
          if(oldMap.get(theDelivery.Id).Bill_To__c != null) {
            deliveryAccountIds.add(oldMap.get(theDelivery.Id).Bill_To__c);
            revokeDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(oldMap.get(theDelivery.Id).Bill_To__c);
          }

          // New bill to account id.
          if(theDelivery.Bill_To__c != null) {
            deliveryAccountIds.add(theDelivery.Bill_To__c);
            grantDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(theDelivery.Bill_To__c);
          }
        }

        // Ship to account changed.
        if(oldMap.get(theDelivery.Id).Ship_To__c != theDelivery.Ship_To__c) {
          // Old ship to account id.
          if(oldMap.get(theDelivery.Id).Ship_To__c != null) {
            deliveryAccountIds.add(oldMap.get(theDelivery.Id).Ship_To__c);
            revokeDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(oldMap.get(theDelivery.Id).Ship_To__c);
          }

          // New ship to account id.
          if(theDelivery.Ship_To__c != null) {
            deliveryAccountIds.add(theDelivery.Ship_To__c);
            grantDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(theDelivery.Ship_To__c);
          }
        }

        // Sold to account changed.
        if(oldMap.get(theDelivery.Id).Sold_To__c != theDelivery.Sold_To__c) {
          // Old sold to account id.
          if(oldMap.get(theDelivery.Id).Sold_To__c != null) {
            deliveryAccountIds.add(oldMap.get(theDelivery.Id).Sold_To__c);
            revokeDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(oldMap.get(theDelivery.Id).Sold_To__c);
          }

          // New sold to account id.
          if(theDelivery.Sold_To__c != null) {
            deliveryAccountIds.add(theDelivery.Sold_To__c);
            grantDeliveryIdAndAccountIdsMap.get(theDelivery.Id).add(theDelivery.Sold_To__c);
          }
        }
      }
    }
    System.debug('TRACE: YETI_DeliveryTriggerHandlerManager - grantRevokeAccessToDeliveryRecords - deliveryAccountIds - ' + deliveryAccountIds);
    System.debug('TRACE: YETI_DeliveryTriggerHandlerManager - grantRevokeAccessToDeliveryRecords - revokeDeliveryIdAndAccountIdsMap - ' + revokeDeliveryIdAndAccountIdsMap);
    System.debug('TRACE: YETI_DeliveryTriggerHandlerManager - grantRevokeAccessToDeliveryRecords - grantDeliveryIdAndAccountIdsMap - ' + grantDeliveryIdAndAccountIdsMap);

    // Instantiating utility class.
    YETI_FunctionalUtility theUtility = new YETI_FunctionalUtility();

    // Determining parent accounts ids.
    if(deliveryAccountIds.size() > 0) {
      theChildAccountIdsAndItsParentAccountIdMap = theUtility.determineParentAccountIds(deliveryAccountIds);
      if(theChildAccountIdsAndItsParentAccountIdMap.size() > 0) {
        deliveryAccountIds.addAll(theChildAccountIdsAndItsParentAccountIdMap.values());
      }
      System.debug('TRACE: YETI_DeliveryTriggerHandlerManager - grantRevokeAccessToDeliveryRecords - deliveryAccountIds - ' + deliveryAccountIds);
    }

    // Determining partner user ids for account ids filtered above.
    Map<Id, Set<Id>> theAccountIdAndUserIdsMap = new Map<Id, Set<Id>>();
    if(deliveryAccountIds.size() > 0) {
      theAccountIdAndUserIdsMap = theUtility.extractPartnerUserIds(deliveryAccountIds);
    }

    // Granting/revoking access to/from delivery records filtered above.
    if(theAccountIdAndUserIdsMap.size() > 0) {
      // Initializing data members.
      Id theParentAccountId = null;

      // Revoking access from delivery records filtered above.
      if(revokeDeliveryIdAndAccountIdsMap.size() > 0) {
        Map<Id, Set<Id>> theUserIdAndDeliveryIdsMap = new Map<Id, Set<Id>>();
        for(Id theDeliveryId : revokeDeliveryIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : revokeDeliveryIdAndAccountIdsMap.get(theDeliveryId)) {
            // Revoking access from delivery account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!theUserIdAndDeliveryIdsMap.containsKey(theUserId)) {
                  theUserIdAndDeliveryIdsMap.put(theUserId, new Set<Id>());
                }
                theUserIdAndDeliveryIdsMap.get(theUserId).add(theDeliveryId);
              }
            }

            // Revoking access from delivery account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!theUserIdAndDeliveryIdsMap.containsKey(theUserId)) {
                    theUserIdAndDeliveryIdsMap.put(theUserId, new Set<Id>());
                  }
                  theUserIdAndDeliveryIdsMap.get(theUserId).add(theDeliveryId);
                }
              }
            }
          }
        }

        // Revoking access from delivery records.
        if(theUserIdAndDeliveryIdsMap.size() > 0) {
          theUtility.deleteDeliveriesShareRecords(theUserIdAndDeliveryIdsMap);
        }
      }

      // Granting access to delivery records filtered above.
      if(grantDeliveryIdAndAccountIdsMap.size() > 0) {
        Map<Id, Set<Id>> theUserIdAndDeliveryIdsMap = new Map<Id, Set<Id>>();
        for(Id theDeliveryId : grantDeliveryIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : grantDeliveryIdAndAccountIdsMap.get(theDeliveryId)) {
            // Granting access to delivery account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!theUserIdAndDeliveryIdsMap.containsKey(theUserId)) {
                  theUserIdAndDeliveryIdsMap.put(theUserId, new Set<Id>());
                }
                theUserIdAndDeliveryIdsMap.get(theUserId).add(theDeliveryId);
              }
            }

            // Granting access to delivery account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!theUserIdAndDeliveryIdsMap.containsKey(theUserId)) {
                    theUserIdAndDeliveryIdsMap.put(theUserId, new Set<Id>());
                  }
                  theUserIdAndDeliveryIdsMap.get(theUserId).add(theDeliveryId);
                }
              }
            }
          }
        }

        // Granting access to delivery records.
        if(theUserIdAndDeliveryIdsMap.size() > 0) {
          theUtility.insertDeliveriesShareRecords(theUserIdAndDeliveryIdsMap);
        }
      }
    }
  }
}
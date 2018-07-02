//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Manager Name: YETI_OrderTriggerHandlerManager
// For Apex Trigger Handler: YETI_OrderTriggerHandler
// For Apex Trigger: YETI_OrderTrigger
// On SObject: Order__c
// Description: This apex trigger handler manager class implements the following functionalities:
//  1: A dealer corporate user must have read access to all orders(Order__c) associated with partner user's contact account record and
//     its parent account record.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
// 22nd March 2017    Hemendra Singh Bhati    Modified (Task # T-586235) - Please see the task description for more details.
//
public without sharing class YETI_OrderTriggerHandlerManager {
  // Private Constants.
  // Private Data Members.
  // Public Data Members.

  /*
  @method      : grantRevokeAccessToOrderRecords
  @description : This method is used to grant/revoke access to/from order records for "Dealer - Corporate" profile user
                 with license "Partner Community Login".
  @params      : List<Order__c> newValues, Map<Id, Order__c> oldMap, Boolean isInsert
  @returns     : void
  */
  public void grantRevokeAccessToOrderRecords(List<Order__c> newValues, Map<Id, Order__c> oldMap, Boolean isInsert) {
    // Initializing data members.
    Set<Id> orderAccountIds = new Set<Id>();
    Map<Id, Set<Id>> grantOrderIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<Id, Set<Id>> revokeOrderIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap = new Map<String, Id>();

    // Processing newly inserted order records.
    if(isInsert) {
      for(Order__c theOrder : newValues) {
        if(!grantOrderIdAndAccountIdsMap.containsKey(theOrder.Id)) {
          grantOrderIdAndAccountIdsMap.put(theOrder.Id, new Set<Id>());
        }

        if(theOrder.Bill_To__c != null) {
          orderAccountIds.add(theOrder.Bill_To__c);
          grantOrderIdAndAccountIdsMap.get(theOrder.Id).add(theOrder.Bill_To__c);
        }
        if(theOrder.Ship_To__c != null) {
          orderAccountIds.add(theOrder.Ship_To__c);
          grantOrderIdAndAccountIdsMap.get(theOrder.Id).add(theOrder.Ship_To__c);
        }
        if(theOrder.Sold_To__c != null) {
          orderAccountIds.add(theOrder.Sold_To__c);
          grantOrderIdAndAccountIdsMap.get(theOrder.Id).add(theOrder.Sold_To__c);
        }
      }
    }
    // Processing newly updated order records.
    else {
      for(Order__c theOrder : newValues) {
        // Grant access to order records mapping.
        if(!grantOrderIdAndAccountIdsMap.containsKey(theOrder.Id)) {
          grantOrderIdAndAccountIdsMap.put(theOrder.Id, new Set<Id>());
        }

        // Revoke access to order records mapping.
        if(!revokeOrderIdAndAccountIdsMap.containsKey(theOrder.Id)) {
          revokeOrderIdAndAccountIdsMap.put(theOrder.Id, new Set<Id>());
        }

        // Bill to account changed.
        if(oldMap.get(theOrder.Id).Bill_To__c != theOrder.Bill_To__c) {
          // Old bill to account id.
          if(oldMap.get(theOrder.Id).Bill_To__c != null) {
            orderAccountIds.add(oldMap.get(theOrder.Id).Bill_To__c);
            revokeOrderIdAndAccountIdsMap.get(theOrder.Id).add(oldMap.get(theOrder.Id).Bill_To__c);
          }

          // New bill to account id.
          if(theOrder.Bill_To__c != null) {
            orderAccountIds.add(theOrder.Bill_To__c);
            grantOrderIdAndAccountIdsMap.get(theOrder.Id).add(theOrder.Bill_To__c);
          }
        }

        // Ship to account changed.
        if(oldMap.get(theOrder.Id).Ship_To__c != theOrder.Ship_To__c) {
          // Old ship to account id.
          if(oldMap.get(theOrder.Id).Ship_To__c != null) {
            orderAccountIds.add(oldMap.get(theOrder.Id).Ship_To__c);
            revokeOrderIdAndAccountIdsMap.get(theOrder.Id).add(oldMap.get(theOrder.Id).Ship_To__c);
          }

          // New ship to account id.
          if(theOrder.Ship_To__c != null) {
            orderAccountIds.add(theOrder.Ship_To__c);
            grantOrderIdAndAccountIdsMap.get(theOrder.Id).add(theOrder.Ship_To__c);
          }
        }

        // Sold to account changed.
        if(oldMap.get(theOrder.Id).Sold_To__c != theOrder.Sold_To__c) {
          // Old sold to account id.
          if(oldMap.get(theOrder.Id).Sold_To__c != null) {
            orderAccountIds.add(oldMap.get(theOrder.Id).Sold_To__c);
            revokeOrderIdAndAccountIdsMap.get(theOrder.Id).add(oldMap.get(theOrder.Id).Sold_To__c);
          }

          // New sold to account id.
          if(theOrder.Sold_To__c != null) {
            orderAccountIds.add(theOrder.Sold_To__c);
            grantOrderIdAndAccountIdsMap.get(theOrder.Id).add(theOrder.Sold_To__c);
          }
        }
      }
    }
    System.debug('TRACE: YETI_OrderTriggerHandlerManager - grantRevokeAccessToOrderRecords - orderAccountIds - ' + orderAccountIds);
    System.debug('TRACE: YETI_OrderTriggerHandlerManager - grantRevokeAccessToOrderRecords - revokeOrderIdAndAccountIdsMap - ' + revokeOrderIdAndAccountIdsMap);
    System.debug('TRACE: YETI_OrderTriggerHandlerManager - grantRevokeAccessToOrderRecords - grantOrderIdAndAccountIdsMap - ' + grantOrderIdAndAccountIdsMap);

    // Instantiating utility class.
    YETI_FunctionalUtility theUtility = new YETI_FunctionalUtility();

    // Determining parent accounts ids.
    if(orderAccountIds.size() > 0) {
      theChildAccountIdsAndItsParentAccountIdMap = theUtility.determineParentAccountIds(orderAccountIds);
      if(theChildAccountIdsAndItsParentAccountIdMap.size() > 0) {
        orderAccountIds.addAll(theChildAccountIdsAndItsParentAccountIdMap.values());
      }
      System.debug('TRACE: YETI_OrderTriggerHandlerManager - grantRevokeAccessToOrderRecords - orderAccountIds - ' + orderAccountIds);
    }

    // Determining partner user ids for account ids filtered above.
    Map<Id, Set<Id>> theAccountIdAndUserIdsMap = new Map<Id, Set<Id>>();
    if(orderAccountIds.size() > 0) {
      theAccountIdAndUserIdsMap = theUtility.extractPartnerUserIds(orderAccountIds);
    }

    // Granting/revoking access to/from order records filtered above.
    if(theAccountIdAndUserIdsMap.size() > 0) {
      // Initializing data members.
      Id theParentAccountId = null;

      // Revoking access from order records filtered above.
      if(revokeOrderIdAndAccountIdsMap.size() > 0) {
        Map<Id, Set<Id>> theUserIdAndOrderIdsMap = new Map<Id, Set<Id>>();
        for(Id theOrderId : revokeOrderIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : revokeOrderIdAndAccountIdsMap.get(theOrderId)) {
            // Revoking access from order account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!theUserIdAndOrderIdsMap.containsKey(theUserId)) {
                  theUserIdAndOrderIdsMap.put(theUserId, new Set<Id>());
                }
                theUserIdAndOrderIdsMap.get(theUserId).add(theOrderId);
              }
            }

            // Revoking access from order account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!theUserIdAndOrderIdsMap.containsKey(theUserId)) {
                    theUserIdAndOrderIdsMap.put(theUserId, new Set<Id>());
                  }
                  theUserIdAndOrderIdsMap.get(theUserId).add(theOrderId);
                }
              }
            }
          }
        }

        // Revoking access from order records.
        if(theUserIdAndOrderIdsMap.size() > 0) {
          theUtility.deleteOrderShareRecords(theUserIdAndOrderIdsMap);
        }
      }

      // Granting access to order records filtered above.
      if(grantOrderIdAndAccountIdsMap.size() > 0) {
        Map<Id, Set<Id>> theUserIdAndOrderIdsMap = new Map<Id, Set<Id>>();
        for(Id theOrderId : grantOrderIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : grantOrderIdAndAccountIdsMap.get(theOrderId)) {
            // Granting access to order account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!theUserIdAndOrderIdsMap.containsKey(theUserId)) {
                  theUserIdAndOrderIdsMap.put(theUserId, new Set<Id>());
                }
                theUserIdAndOrderIdsMap.get(theUserId).add(theOrderId);
              }
            }

            // Granting access to order account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!theUserIdAndOrderIdsMap.containsKey(theUserId)) {
                    theUserIdAndOrderIdsMap.put(theUserId, new Set<Id>());
                  }
                  theUserIdAndOrderIdsMap.get(theUserId).add(theOrderId);
                }
              }
            }
          }
        }

        // Granting access to order records.
        if(theUserIdAndOrderIdsMap.size() > 0) {
          theUtility.insertOrderShareRecords(theUserIdAndOrderIdsMap);
        }
      }
    }
  }
}
//
// (c) 2017 Appirio, Inc.
//
// Apex Trigger Handler Manager Name: YETI_InvoiceTriggerHandlerManager
// For Apex Trigger Handler: YETI_InvoiceTriggerHandler
// For Apex Trigger: YETI_InvoiceTrigger
// On SObject: Invoice__c
// Description: This apex trigger handler manager class implements the following functionalities:
//  1: A dealer corporate user must have read access to all invoices(Invoice__c) associated with partner user's contact account record and
//     its parent account record.
//
// 14th March 2017    Hemendra Singh Bhati    Original (Task # T-580530) - Please see the task description for more details.
// 22nd March 2017    Hemendra Singh Bhati    Modified (Task # T-586235) - Please see the task description for more details.
//
public without sharing class YETI_InvoiceTriggerHandlerManager {
  // Private Constants.
  // Private Data Members.
  // Public Data Members.

  /*
  @method      : grantRevokeAccessToInvoiceRecords
  @description : This method is used to grant/revoke access to/from invoice records for "Dealer - Corporate" profile user
                 with license "Partner Community Login".
  @params      : List<Invoice__c> newValues, Map<Id, Invoice__c> oldMap, Boolean isInsert
  @returns     : void
  */
  public void grantRevokeAccessToInvoiceRecords(List<Invoice__c> newValues, Map<Id, Invoice__c> oldMap, Boolean isInsert) {
    // Initializing data members.
    Set<Id> invoiceAccountIds = new Set<Id>();
    Map<Id, Set<Id>> grantInvoiceIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<Id, Set<Id>> revokeInvoiceIdAndAccountIdsMap = new Map<Id, Set<Id>>();
    Map<String, Id> theChildAccountIdsAndItsParentAccountIdMap = new Map<String, Id>();

    // Processing newly inserted invoice records.
    if(isInsert) {
      for(Invoice__c theInvoice : newValues) {
        if(!grantInvoiceIdAndAccountIdsMap.containsKey(theInvoice.Id)) {
          grantInvoiceIdAndAccountIdsMap.put(theInvoice.Id, new Set<Id>());
        }

        if(theInvoice.Bill_To__c != null) {
          invoiceAccountIds.add(theInvoice.Bill_To__c);
          grantInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(theInvoice.Bill_To__c);
        }
        if(theInvoice.Ship_To__c != null) {
          invoiceAccountIds.add(theInvoice.Ship_To__c);
          grantInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(theInvoice.Ship_To__c);
        }
        if(theInvoice.Sold_To__c != null) {
          invoiceAccountIds.add(theInvoice.Sold_To__c);
          grantInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(theInvoice.Sold_To__c);
        }
      }
    }
    // Processing newly updated invoice records.
    else {
      for(Invoice__c theInvoice : newValues) {
        // Grant access to invoice records mapping.
        if(!grantInvoiceIdAndAccountIdsMap.containsKey(theInvoice.Id)) {
          grantInvoiceIdAndAccountIdsMap.put(theInvoice.Id, new Set<Id>());
        }

        // Revoke access to invoice records mapping.
        if(!revokeInvoiceIdAndAccountIdsMap.containsKey(theInvoice.Id)) {
          revokeInvoiceIdAndAccountIdsMap.put(theInvoice.Id, new Set<Id>());
        }

        // Bill to account changed.
        if(oldMap.get(theInvoice.Id).Bill_To__c != theInvoice.Bill_To__c) {
          // Old bill to account id.
          if(oldMap.get(theInvoice.Id).Bill_To__c != null) {
            invoiceAccountIds.add(oldMap.get(theInvoice.Id).Bill_To__c);
            revokeInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(oldMap.get(theInvoice.Id).Bill_To__c);
          }

          // New bill to account id.
          if(theInvoice.Bill_To__c != null) {
            invoiceAccountIds.add(theInvoice.Bill_To__c);
            grantInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(theInvoice.Bill_To__c);
          }
        }

        // Ship to account changed.
        if(oldMap.get(theInvoice.Id).Ship_To__c != theInvoice.Ship_To__c) {
          // Old ship to account id.
          if(oldMap.get(theInvoice.Id).Ship_To__c != null) {
            invoiceAccountIds.add(oldMap.get(theInvoice.Id).Ship_To__c);
            revokeInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(oldMap.get(theInvoice.Id).Ship_To__c);
          }

          // New ship to account id.
          if(theInvoice.Ship_To__c != null) {
            invoiceAccountIds.add(theInvoice.Ship_To__c);
            grantInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(theInvoice.Ship_To__c);
          }
        }

        // Sold to account changed.
        if(oldMap.get(theInvoice.Id).Sold_To__c != theInvoice.Sold_To__c) {
          // Old sold to account id.
          if(oldMap.get(theInvoice.Id).Sold_To__c != null) {
            invoiceAccountIds.add(oldMap.get(theInvoice.Id).Sold_To__c);
            revokeInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(oldMap.get(theInvoice.Id).Sold_To__c);
          }

          // New sold to account id.
          if(theInvoice.Sold_To__c != null) {
            invoiceAccountIds.add(theInvoice.Sold_To__c);
            grantInvoiceIdAndAccountIdsMap.get(theInvoice.Id).add(theInvoice.Sold_To__c);
          }
        }
      }
    }
    System.debug('TRACE: YETI_InvoiceTriggerHandlerManager - grantRevokeAccessToInvoiceRecords - invoiceAccountIds - ' + invoiceAccountIds);
    System.debug('TRACE: YETI_InvoiceTriggerHandlerManager - grantRevokeAccessToInvoiceRecords - revokeInvoiceIdAndAccountIdsMap - ' + revokeInvoiceIdAndAccountIdsMap);
    System.debug('TRACE: YETI_InvoiceTriggerHandlerManager - grantRevokeAccessToInvoiceRecords - grantInvoiceIdAndAccountIdsMap - ' + grantInvoiceIdAndAccountIdsMap);

    // Instantiating utility class.
    YETI_FunctionalUtility theUtility = new YETI_FunctionalUtility();

    // Determining parent accounts ids.
    if(invoiceAccountIds.size() > 0) {
      theChildAccountIdsAndItsParentAccountIdMap = theUtility.determineParentAccountIds(invoiceAccountIds);
      if(theChildAccountIdsAndItsParentAccountIdMap.size() > 0) {
        invoiceAccountIds.addAll(theChildAccountIdsAndItsParentAccountIdMap.values());
      }
      System.debug('TRACE: YETI_InvoiceTriggerHandlerManager - grantRevokeAccessToInvoiceRecords - invoiceAccountIds - ' + invoiceAccountIds);
    }

    // Determining partner user ids for account ids filtered above.
    Map<Id, Set<Id>> theAccountIdAndUserIdsMap = new Map<Id, Set<Id>>();
    if(invoiceAccountIds.size() > 0) {
      theAccountIdAndUserIdsMap = theUtility.extractPartnerUserIds(invoiceAccountIds);
    }

    // Granting/revoking access to/from invoice records filtered above.
    if(theAccountIdAndUserIdsMap.size() > 0) {
      // Initializing data members.
      Id theParentAccountId = null;

      // Revoking access from invoice records filtered above.
      if(revokeInvoiceIdAndAccountIdsMap.size() > 0) {
        Map<Id, Set<Id>> theUserIdAndInvoiceIdsMap = new Map<Id, Set<Id>>();
        for(Id theInvoiceId : revokeInvoiceIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : revokeInvoiceIdAndAccountIdsMap.get(theInvoiceId)) {
            // Revoking access from invoice account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!theUserIdAndInvoiceIdsMap.containsKey(theUserId)) {
                  theUserIdAndInvoiceIdsMap.put(theUserId, new Set<Id>());
                }
                theUserIdAndInvoiceIdsMap.get(theUserId).add(theInvoiceId);
              }
            }

            // Revoking access from invoice account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!theUserIdAndInvoiceIdsMap.containsKey(theUserId)) {
                    theUserIdAndInvoiceIdsMap.put(theUserId, new Set<Id>());
                  }
                  theUserIdAndInvoiceIdsMap.get(theUserId).add(theInvoiceId);
                }
              }
            }
          }
        }

        // Revoking access from invoice records.
        if(theUserIdAndInvoiceIdsMap.size() > 0) {
          theUtility.deleteInvoiceShareRecords(theUserIdAndInvoiceIdsMap);
        }
      }

      // Granting access to invoice records filtered above.
      if(grantInvoiceIdAndAccountIdsMap.size() > 0) {
        Map<Id, Set<Id>> theUserIdAndInvoiceIdsMap = new Map<Id, Set<Id>>();
        for(Id theInvoiceId : grantInvoiceIdAndAccountIdsMap.keySet()) {
          for(Id theAccountId : grantInvoiceIdAndAccountIdsMap.get(theInvoiceId)) {
            // Granting access to invoice account partner users.
            if(theAccountIdAndUserIdsMap.containsKey(theAccountId)) {
              for(Id theUserId : theAccountIdAndUserIdsMap.get(theAccountId)) {
                if(!theUserIdAndInvoiceIdsMap.containsKey(theUserId)) {
                  theUserIdAndInvoiceIdsMap.put(theUserId, new Set<Id>());
                }
                theUserIdAndInvoiceIdsMap.get(theUserId).add(theInvoiceId);
              }
            }

            // Granting access to invoice account's -> parent account -> partner users.
            theParentAccountId = theUtility.findParentAccountId(theAccountId, theChildAccountIdsAndItsParentAccountIdMap);
            if(theParentAccountId != null) {
              if(theAccountIdAndUserIdsMap.containsKey(theParentAccountId)) {
                for(Id theUserId : theAccountIdAndUserIdsMap.get(theParentAccountId)) {
                  if(!theUserIdAndInvoiceIdsMap.containsKey(theUserId)) {
                    theUserIdAndInvoiceIdsMap.put(theUserId, new Set<Id>());
                  }
                  theUserIdAndInvoiceIdsMap.get(theUserId).add(theInvoiceId);
                }
              }
            }
          }
        }

        // Granting access to invoice records.
        if(theUserIdAndInvoiceIdsMap.size() > 0) {
          theUtility.insertInvoiceShareRecords(theUserIdAndInvoiceIdsMap);
        }
      }
    }
  }
}
trigger ArtWorkflow on Order(after update) {

    if (RecursiveTriggerHandler.isFirstTime) {
        RecursiveTriggerHandler.isFirstTime = false;
        if (trigger.isUpdate && trigger.isAfter) {
        list < orderitem > updatelineitems = new list < orderitem > ();
        list < order > updateorder = new list < order > ();
       
        list < order > orderlist = [select id, OriginSource__c, Internal_Review_Status__c, (select id, CGS_Status__c,Product2.name from orderitems where testflag__c = true) from order where id IN: Trigger.newMap.keySet()];
           for (order ordobj: orderlist) {
             if(((Trigger.oldMap.get(ordobj.id)).OriginSource__c != (Trigger.newMap.get(ordobj.id)).OriginSource__c) || (Trigger.oldMap.get(ordobj.id)).OriginSource__c == ''){
                if (ordobj.OriginSource__c == 'SFDC' && (Trigger.newMap.get(ordobj.id)).OriginSource__c== 'SFDC' ) {
                    ordobj.Internal_Review_Status__c = 'Approved';
                    updateorder.add(ordobj);
                    for (orderitem lineitems: ordobj.orderitems) {
                        lineitems.CGS_Status__c = 'Approved';
                        updatelineitems.add(lineitems);
                    }

                } 
            else if( (ordobj.OriginSource__c == 'SFCC' && (Trigger.newMap.get(ordobj.id)).OriginSource__c== 'SFCC') ||  ( ordobj.OriginSource__c == 'SAP' && (Trigger.newMap.get(ordobj.id)).OriginSource__c== 'SAP')) {
                    ordobj.Internal_Review_Status__c = 'Pending';
                    updateorder.add(ordobj);
                    for (orderitem lineitem: ordobj.orderitems) {
                        if(lineitem.Product2.name == 'prepared'){
                            lineitem.CGS_Status__c = 'Approved';  
                          }
                        if(lineitem.Product2.name == 'text'){
                            lineitem.CGS_Status__c = 'pending';  
                          }
                        if(lineitem.Product2.name == 'image'){
                            lineitem.CGS_Status__c = 'pending';  
                          }
                        if(lineitem.Product2.name == 'monogram'){
                            lineitem.CGS_Status__c = 'pending';  
                          }
                        updatelineitems.add(lineitem);
                    }
                  
                }
               }
            }   

            update updatelineitems;
            update orderlist;


        }
    }
}
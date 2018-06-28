trigger ArtWork on OrderItem (after update){
   if (RecursiveTriggerHandler.isFirstTime) {
        RecursiveTriggerHandler.isFirstTime = false;
        List<order> updateorder = new  List<order>(); 
        set<id> orderids = new set<id>(); 
        for(orderitem lineitem : trigger.new){
             orderids.add(lineitem.orderid);
          }  
       List<order> orderlst = [select id, OriginSource__c, Internal_Review_Status__c, (select id, CGS_Status__c,Product2.name from orderitems where testflag__c = true) from order where id IN: orderids];
       system.debug(orderlst);
      
      Boolean Flagged = false;
      Boolean Pending = false; 
      Boolean Approved = false;
      
      for(order ordobj : orderlst){
          for(orderitem lineitems : ordobj.orderitems){
             if(lineitems.CGS_Status__c == 'Flagged'){
                   Flagged = true; 
               }
             if(lineitems.CGS_Status__c == 'Pending'){
                   Pending = true; 
               }
             if(lineitems.CGS_Status__c == 'Approved'){
                   Approved = true; 
               }     
               
          }
         
         if(Flagged == true){
           ordobj.Internal_Review_Status__c = 'Flagged';
         }else if(Flagged == false && Pending ==true &&  Approved == true ){
           ordobj.Internal_Review_Status__c = 'Partially';   
         }else if(Flagged == false && Pending == false &&  Approved == true){
            ordobj.Internal_Review_Status__c = 'Approved';
         }else{
            ordobj.Internal_Review_Status__c = 'Pending';
         } 
         updateorder.add(ordobj);
      }
      
      update updateorder;
}
}
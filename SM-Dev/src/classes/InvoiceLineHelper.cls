public without sharing class InvoiceLineHelper 

   //  Link the Sales Target to the Invoice Line if there is a match
   // public void SalesTargetLinktoInvoiceLine(List<acSales__InvoiceLine__c> invoiceLineList)
    {   
            
          Set<Id> ownerIdSet = new Set<Id>();
            
            // Loop through invoices and pull back the Users or Sales People values 
      //      for (acSales__InvoiceLine__c il:invoiceLineList){
        //        ownerIdSet.add(il.Invoice_User_Owner__c);
          //  }
        
        
            // this map will contain a list of Sales Orders with the same salesman #
            Map<String, List<Sales_Target__c>> SalesTargetByOwnerMap = new Map<String, List<Sales_Target__c>> ();
            Map<String, List<Sales_Target__c>> SalesTargetByOwnerMapNoProductCat = new Map<String, List<Sales_Target__c>> ();
        
        
            // Pull back only the Users/Sales Person Sales Target Records that are referenced  
            //for (Sales_Target__c st:[Select Id, OwnerId, Description__c, Start_Date__c, End_Date__c, Product_Category__c, CreatedDate
              //                       From Sales_Target__c 
                //                     Where OwnerId IN :ownerIdSet
                  //                   order by CreatedDate
           // ]){
                                         
                     {    // Check if the Sales Target has a Product Category if so place into Map 
                       //  if (st.Product_Category__c !='All Other' ){ //|| st.Product_Category__c != null){
                            // Not check if the record exists in the MAP if NOT add the different Sales Targets 
                           // if (!SalesTargetByOwnerMap.containsKey(st.OwnerId)){
                             //   SalesTargetByOwnerMap.put(st.OwnerId, new List<Sales_Target__c>());     // First create the Id with a blank List
                            }
                            // Add the new record to the list 
                           // SalesTargetByOwnerMap.get(st.OwnerId).add(st);  // Now add the value to the Map 
                         }
                    

                         // Check if the Sales Target Does not have a Product Category assign to another map for No Product Categories
                       //  if (st.Product_Category__c =='All Other'){ // || st.Product_Category__c == null ){
                      
                          //  if (!SalesTargetByOwnerMapNoProductCat.containsKey(st.OwnerId)){
                               // SalesTargetByOwnerMapNoProductCat.put(st.OwnerId, new List<Sales_Target__c>());     // First create the Id with a blank List
                          //  }
                            // Add the new record to the list 
                           // SalesTargetByOwnerMapNoProductCat.get(st.OwnerId).add(st);  // Now add the value to the Map 
                                                               
            

          //  acSales__InvoiceLine__c tempInvoiceLine = new acSales__InvoiceLine__c();
          //  List<acSales__InvoiceLine__c> updateInvoiceLines = new List<acSales__InvoiceLine__c>();
        //    Boolean foundMatch = false; 
            
            
            
            //loop through invoice lines and see if there is a match with a Sales Target record  
            //for (acSales__InvoiceLine__c il:invoiceLineList){
          //  for (acSales__InvoiceLine__c il:[Select Id,
                                                 //   Product_Category__c,
                                               //     Invoice_User_Owner__c,
                                                    //Invoice_Date__c,
                                                   // Sales_Target__c
                                          //   from acSales__InvoiceLine__c where Id IN :invoiceLineList]){
                
                // Initialize values for next Invoice Line
                //foundMatch = false;
                
               
               // if (il.Product_Category__c !='All Other' && SalesTargetByOwnerMap.containsKey(il.Invoice_User_Owner__c)){

                                        //    for (Sales_Target__c stLoop:SalesTargetByOwnerMap.get(il.Invoice_User_Owner__c)){
                        
                     //     if (    // See if there is a match 
                                   // foundMatch == false  // If record is not found continue to process 
                                    //&& il.Invoice_User_Owner__c == stLoop.OwnerId                   // Match on User Owner
                                    //&& il.Product_Category__c == stLoop.Product_Category__c      // Match on Product Category
                                    //&& (il.Invoice_Date__c >= stLoop.Start_Date__c && il.Invoice_Date__c <= stLoop.End_Date__c)   // Match on Dates Betwen start and end date
                         //       ){
                                
                       //             il.Sales_Target__c = stLoop.Id;    // Link Sales Target Record
                                
                                // Add the changes to the List for updating 
                       //         updateInvoiceLines.add(il);
                        //        foundMatch = true;  // If Match is found, no need to further process a Sales Target Record for this line.
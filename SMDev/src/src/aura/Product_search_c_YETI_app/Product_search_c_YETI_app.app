<aura:application extends="force:slds">
  <!-- Create attribute to store lookup value as a sObject--> 
  <aura:attribute name="selectedLookUpRecords" type="sObject[]" default="[]"/>
 
  <c:Product_search_P_YETI objectAPIName="Product2"
                               IconName="standard:pricebook"
                               lstSelectedRecords="{!v.selectedLookUpRecords}"
                               label="Product Name"/>
   <!-- here c: is org. namespace prefix-->
</aura:application>
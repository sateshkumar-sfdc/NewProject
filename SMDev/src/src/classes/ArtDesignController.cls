/*
######################################################################################################################
Name:       ArtDesignController.apxc 
Description:  This class contain method to return the list 
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     4/12/2018    1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/
public with sharing class ArtDesignController{
       


 /*wrapper class*/
 public with sharing class ArtDesignWrapper {

  @AuraEnabled public string productName{get;set;}
  @AuraEnabled public string laser{get;set;}
  @AuraEnabled public string laserback{get;set;}
  @AuraEnabled public string front {get;set;}
  @AuraEnabled public string back {get;set;}
    
}
 
/*
######################################################################################################################
Method Name:       getProducts
Description:  This methods returns the product urls for the Art images.
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     4/12/2018    1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/
    @AuraEnabled
    public static List<ArtDesignWrapper>  getProducts(Id recordId){
     try{
       List<ArtDesignWrapper> wrapList = new List<ArtDesignWrapper>(); 
       List<EmbellishedProduct__c> EmbPrdtList = [select ProductName__c, ProductYETIKey__c from EmbellishedProduct__c  ];
       string Webkey = [select WebKey__c from EmbellishedArt__c where id =: recordId limit 1].WebKey__c;
       string Url = CommonUtil.getCommonMetaData('AmazonUrl')+ Webkey +'/';
       ArtDesignWrapper wrpObj;
       for(EmbellishedProduct__c embobj : EmbPrdtList ){	
            wrpObj = new ArtDesignWrapper();
            wrpObj.productName = embobj.ProductName__c;
            wrpObj.laser= Url+ embobj.ProductYETIKey__c +'/'+ CommonUtil.getCommonMetaData('Laser');
            wrpObj.laserback = Url+ embobj.ProductYETIKey__c +'/'+ CommonUtil.getCommonMetaData('LaserReady');
            wrpObj.front = Url+ embobj.ProductYETIKey__c +'/'+ CommonUtil.getCommonMetaData('Approvalfront');
            wrpObj.back = Url+ embobj.ProductYETIKey__c +'/'+ CommonUtil.getCommonMetaData('ApprovalBack');
            wrapList.add(wrpObj);
            system.debug(wrapList);
        }
      return wrapList;
     }catch(exception e){
         return null;
       }
     }

}
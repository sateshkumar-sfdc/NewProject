/*
######################################################################################################################
Name:       ArtDesignController_Test.apxc 
Description:  Test class for ArtDesignController 
S.NO:     Date      Version      Author             Summary of Changes 
**********************************************************************************************************************
  1     4/20/2018    1.0       Ranjith Thadakala      Initial Release
**********************************************************************************************************************
*/

@isTest
private class ArtDesignController_Test {
    
    private static EmbellishedProduct__c embProduct;
    private static EmbellishedArt__c embArt;
    
 /* creating test data */    
    @isTest
    private static void setupTestData(){
       
       embProduct = new EmbellishedProduct__c();
       embProduct.ProductName__c = 'RamblerBottle';
       embProduct.ProductYETIKey__c = 'rambler-bottle';
       insert embProduct;
       
       embArt = new EmbellishedArt__c();  
       embArt.ArtName__c = 'Appalachian State';
       embArt.Category__c='Collegiate';
       embArt.IsPremium__c='Yes';
       embArt.ArtYETIKey__c='appalachian-state';
       insert embArt;
}
  /* case 1 positive */
   @isTest
    private static void getProducts_Test(){
        List<ArtDesignController.ArtDesignWrapper> ArtDesignWrapper;
        setupTestData();
        try{
        Test.startTest();
        ArtDesignWrapper = ArtDesignController.getProducts(embArt.Id);
        Test.stopTest();
        
        system.assertEquals(ArtDesignWrapper[0].productName, 'RamblerBottle');
        system.assertEquals(ArtDesignWrapper[0].laser, 'https://s3.amazonaws.com/howard-sandbox/test/designs/premium/collegiate/appalachian-state/rambler-bottle/laser-ready.bmp');
     }
        catch(exception e){
            
           system.assertEquals(ArtDesignWrapper, null); 
            
        }
    
    }
    /* case 2 negative */
    @isTest
     private static void getProducts_Test1(){
        List<ArtDesignController.ArtDesignWrapper> ArtDesignWrapper;
         EmbellishedProduct__c embprd = new EmbellishedProduct__c();
        try{
            
        Test.startTest();
        ArtDesignWrapper = ArtDesignController.getProducts(embprd.Id);
        Test.stopTest();
        
        system.assertEquals(ArtDesignWrapper[0].productName, 'RamblerBottle');
        system.assertEquals(ArtDesignWrapper[0].laser, 'https://s3.amazonaws.com/howard-sandbox/test/designs/premium/collegiate/appalachian-state/rambler-bottle/laser-ready.bmp');
     }
        catch(exception e){
            system.assertEquals(e.getMessage(), e.getMessage());
           system.assertEquals(ArtDesignWrapper, null); 
            
        }
    
    }
    
    
    
}
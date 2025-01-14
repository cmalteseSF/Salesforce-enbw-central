public with sharing class PlusNet_TriggerHelper {

      public static void updateContratLineItemAssetId(List<Asset> oListAssets) {

         Map<String,ID> oListToUpdate = new Map<String,ID>();
         Set<String> oListAssetReferenceIds = new Set<String>();
         Map<String,ID> oAssetListToUpdate = new Map<String,ID>();
 
         for(Asset oCurAsset : oListAssets) {
            oListToUpdate.put(oCurAsset.vlocity_cmt__AssetReferenceId__c,oCurAsset.id);
         }    
    
        
         List<vlocity_cmt__ContractLineItem__c> oListCLIs = [SELECT Id, vlocity_cmt__AssetReferenceId__c, vlocity_cmt__AssetId__c FROM vlocity_cmt__ContractLineItem__c WHERE vlocity_cmt__AssetReferenceId__c in :oListToUpdate.keySet()];

         if(oListCLIs.size() > 0){
    
            Integer iIndex = 0;
       
            while(iIndex < oListCLIs.size()){
               ID curAssetId = oListToUpdate.get(oListCLIs.get(iIndex).vlocity_cmt__AssetReferenceId__c);
          
                oAssetListToUpdate.put(oListCLIs.get(iIndex).vlocity_cmt__AssetReferenceId__c,oListCLIs.get(iIndex).Id);
          
               if(curAssetId != null){
                  oListCLIs.get(iIndex).vlocity_cmt__AssetId__c = curAssetId;
               }
          
             iIndex++;
          }
       
          update oListCLIs;
          
          //============
         /*
             
          List<Asset> oListAssetsForUpdate = [SELECT Id, vlocity_cmt__AssetReferenceId__c, PlusNet_Contract_Line_Id__c from Asset WHERE vlocity_cmt__AssetReferenceId__c in :oAssetListToUpdate.keySet()];  
             
             if(oListAssetsForUpdate.size() > 0){   
                 
                 Integer iIndex1 = 0;   
                 
                 While(iIndex1 < oListAssetsForUpdate.size()){  
                     ID curContractLineId = oAssetListToUpdate.get(oListAssetsForUpdate.get(iIndex1).vlocity_cmt__AssetReferenceId__c); 
                     
                     If(curContractLineId != null){ 
                         oListAssetsForUpdate.get(iIndex1).PlusNet_Contract_Line_Id__c = curContractLineId; 
                     }  
                     
                     iIndex1++; 
                 }  
                 
                 update oListAssetsForUpdate;   
             }      
          
          //================================= 
          */
         }   
      }
      
      public static void updateQuoteContractId(List< Contract > oListContracts) {
      
         List<Quote> oQuote = new List<Quote>();
         
         Map<ID,ID> oListToUpdate = new Map<ID,ID>();
         
         for(Contract oCurContract : oListContracts) {
            oListToUpdate.put(oCurContract.vlocity_cmt__QuoteId__c,oCurContract.id);
         }
         
         List<Quote> oListQuotes = [SELECT Id, ContractId FROM quote WHERE id in :oListToUpdate.keySet()];
         
         if(oListQuotes.size() > 0){
            Integer iIndex = 0;
            
            while(iIndex < oListQuotes.size()){
               ID curContractId = oListToUpdate.get(oListQuotes.get(iIndex).id);
               oListQuotes.get(iIndex).ContractId = curContractId;
               iIndex++;
            }
            
            update oListQuotes;
            
         }

      }
}
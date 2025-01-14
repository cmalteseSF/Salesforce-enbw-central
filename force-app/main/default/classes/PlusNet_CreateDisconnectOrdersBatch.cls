global class PlusNet_CreateDisconnectOrdersBatch implements Database.Batchable<Asset> {

    global String sAccountId;
    global String sRequestDate;
    global Boolean isFinalorder;
    String sCurAssetId;
    Map<String,Object> mCurBatchinput;

    global PlusNet_CreateDisconnectOrdersBatch(List<Object> listArgs,String CLIAssetId, Map<String,Object> input,Boolean isFinalOrderCheck){
       
       sAccountId = (String)listArgs.get(0);
       sRequestDate = String.valueOf(listArgs.get(1));
       isFinalorder = isFinalOrderCheck;
       sCurAssetId = CLIAssetId;
       mCurBatchinput = input;
    }

    global Iterable<Asset> start(Database.BatchableContext BC) {
    
        // collect the batches of records or objects to be passed to execute. Get All Root Assets given the root contract line item id
        List<Asset> oAsset = [Select ID from Asset where id = :sCurAssetId];
        
        return oAsset;
    }
    
    global void execute(Database.BatchableContext BC, List<Asset> oAsset) { //Process For every root asset
        
    try{ 
        

            Integer iIndex = 0;
            Integer iNumofAssets = oAsset.size();
            String assetIdList = null;
            String chargeId = '';

        while(iIndex < iNumofAssets){
            Id CurAssetId = oAsset.get(iIndex).id;
            
            Map <String, Object> ipInputDisc = new Map <String, Object> ();
            Map <String, Object> ipOutputDisc = new Map <String, Object> ();
            Map <String, Object> ipOptionsDisc = new Map <String, Object> ();
            String sIntegrationProcedureNameDisc;
            
            sIntegrationProcedureNameDisc = 'PlusNet_ContractDisconnectService'; 

            ipInputDisc.put('Id', CurAssetId);   
            ipInputDisc.put('TerminationDate', sRequestDate);  
            ipOutputDisc = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(sIntegrationProcedureNameDisc, ipInputDisc,ipOptionsDisc);                  
                    
            iIndex++;
        }
    }
    catch(Exception e){
        system.debug('Exception : ' + e.getMessage());
    }

    }   
    
    global void finish(Database.BatchableContext BC) {
       try{      
          
          Map < String, Object > input = new Map < String, Object >();
          Map < String, Object > output = new Map < String, Object >();
          Map < String, Object > options = new Map < String, Object >();
    
          input.put('AccountId',sAccountId);
          input.put('RequestDate',sRequestDate);
          input.put('BatchSize',0); 
           
          List<Object> listContractItems = (List<Object>) mCurBatchinput.get('CLI');            
          List<Map<string, object>> mCurBatchinputList = new List<Map<string, object>>();

          
          listContractItems.remove(0);
          if(listContractItems.size() > 0){
              mCurBatchinput.remove('CLI');
              mCurBatchinput.put('CLI',listContractItems);
              input.put('CLI',listContractItems);
              if(listContractItems.size()==1){
                input.put('isFinalOrder',true);  
              }  
              PlusNet_CreateDisconnectOrdersWrapper oCreateDisconnectOrdersWrapper = new PlusNet_CreateDisconnectOrdersWrapper();
              oCreateDisconnectOrdersWrapper.CreateDisconnectOrders(input,output,options);
          }
          
          
       }
       catch(Exception e){
          system.debug('Exception: ' + e.getMessage());
       }

    }
       
}
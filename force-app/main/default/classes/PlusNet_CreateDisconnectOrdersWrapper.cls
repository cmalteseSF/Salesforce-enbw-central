global with sharing class PlusNet_CreateDisconnectOrdersWrapper implements vlocity_cmt.VlocityOpenInterface2 {
 global Boolean invokeMethod(String methodName,
    Map < String, Object > input,
    Map < String, Object > output,
    Map < String, Object > options) {    
        
    switch on methodName{
       when 'CreateDisconnectOrders'{
          return CreateDisconnectOrders(input, output, options);
       }
    }
    return false;
 }

public Boolean CreateDisconnectOrders (Map < String, Object > input,Map < String, Object > output,Map < String, Object > options) {
 try{

    List<Object> listContractItems = (List<Object>)input.get('CLI');
     
    
    String sAccountId = (String)input.get('AccountId');
    String sRequestDate = String.valueOf(input.get('RequestDate'));
    Integer iBatchSize =  Integer.valueof(input.get('BatchSize')); 

    Integer iNumberOfObjects = listContractItems.size();     
     
    String CLIAssetId;

     //Process objects and build batches


     Integer iIndex = 0;
     Boolean recordSpecfcNotify;
     Boolean recordSpecfcCanSubmitOrder;
      Boolean isFinalOrder;          
     if(iNumberOfObjects > 0){
                        
        List<Object> listArgs = new List<Object>();
        listArgs.add(sAccountId);
        listArgs.add(sRequestDate);
      
        Map<String,Object> curCLIRefId = (Map<String,Object>)listContractItems.get(0);
         if(iNumberOfObjects==1){
            isFinalOrder =true;  
         }

        CLIAssetId = (String)curCLIRefId.get('AssetId');
        PlusNet_CreateDisconnectOrdersBatch oCreateDiscOrdersBatch = new PlusNet_CreateDisconnectOrdersBatch(listArgs,CLIAssetId,input,isFinalOrder);           
        database.executeBatch(oCreateDiscOrdersBatch);
                       
     }                       
 }
 catch(Exception e) {
     system.debug('Exception: ' + e.getMessage() + '---' + e.getCause() + '--'+e.getLineNumber() );
 }
return true;
}


}
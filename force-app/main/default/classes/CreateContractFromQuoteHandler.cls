/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 09-04-2023
 * @last modified by  : Sudhir Kumar Thanna
**/
global with sharing class CreateContractFromQuoteHandler implements vlocity_cmt.VlocityOpenInterface {
  
    private string contractId {get; set;}
    public void createAndUpdateContract(Map<String,object> input, Map<String,object> output,Map<String, object> options){

        String quoteId = (String) input.get('QuoteId');
        System.debug( 'Quote Id From Context Id is...' + quoteId );
        contractId = vlocity_cmt.ContractServiceResource.createContractWithoutTemplate(quoteId); 
        System.debug( 'Contract Id Created Controller ' + contractId );
        output.put('ContractId', contractId);
    }

    global boolean invokeMethod (String methodName, Map<String, object> input, Map<String, object> output, Map<String, object> options) {
        Boolean result=true;
            try{
                if(methodName.equalsIgnoreCase('createAndUpdateContract')){
                    createAndUpdateContract(input, output, options);
                }
                else{
                    output.put('result', '');
                }
            }
            catch(Exception e){
                return false;
            }
            return result;
        } 

}
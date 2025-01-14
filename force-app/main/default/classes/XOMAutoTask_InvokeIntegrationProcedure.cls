/*******************************************************************
* Class Name                    :   XOMAutoTask_InvokeIntegrationProcedure
* Usage                         :   Invokes an OmniStudio Integration Procedure from an Orchestration Item (AutoTask)
* Author                        :   XXXXXX
* Last Modified By              :   XXXXX
* Version                       :   1.0
* Methods                       :   executeBatch()
* 
*******************************************************************/

global class XOMAutoTask_InvokeIntegrationProcedure implements vlocity_cmt.XOMOrchestrationInterfaces.IAutoTask {
    private class OrchItemException extends Exception {}

    /***************************************************************************************************************
    * @description Executes auto-task business logic 
    * @param List of orchestration items (auto-tasks)
    * @return Nothing, business logic is executed
    * @example
    *
    * Not invoked directly but rather called by Vlocity XOM Orchestration Engine
    */

    global void executeBatch(List <vlocity_cmt__OrchestrationItem__c> items) {
        
        //retrieve additional information for orchestration items: order Id, account Id
        List <vlocity_cmt__OrchestrationItem__c> itemsExt = [
            SELECT 
                Id,
                vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__c,
                vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.AccountId,
                vlocity_cmt__AutoTaskParameters__c
            FROM 
                vlocity_cmt__OrchestrationItem__c 
            WHERE Id IN :items];

        for (vlocity_cmt__OrchestrationItem__c item : itemsExt) {        
            /* Initialize variables */
            String autotaskParametersString = item.vlocity_cmt__AutoTaskParameters__c;
            Map <String, Object> autotaskParametersMap = (Map <String, Object>) JSON.deserializeUntyped(autotaskParametersString);
            String procedureName = (String) autotaskParametersMap.get('procedureName');
            Map <String, Object> ipInput = autotaskParametersMap;
            Map <String, Object> ipOutput = new Map <String, Object> ();
            Map <String, Object> ipOptions = new Map <String, Object> ();

            if (String.isBlank(procedureName)) {
                SObjectException ex = new SObjectException();
                ex.setMessage('Procedure name (procedureName) is not defined for the auto-task. Verify that the Auto Task Parameters field is properly populated');
                throw ex;
            }

            /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
            /* If you need more input information for VIP, you can extend the code here. Alternatively, you can use dataraptors within your VIP to collect such information */
            ipInput.put('accountId',            item.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.AccountId);
            ipInput.put('orderId',              item.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__c);
            ipInput.put('orchestrationItemId',  item.Id);
            ipInput.put('orchestrationPlanId',  item.vlocity_cmt__OrchestrationPlanId__c);


            /* Call the IP via runIntegrationService, and save the output to ipOutput */
            ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
            system.debug('!!!!!!!!Mayank'+ipOutput);
            if(!ipOutput.isEmpty() && ipOutput.get('success') != null && (Boolean)ipOutput.get('success') == false)
            {
                throw new OrchItemException('Something went wrong');
            }
            
        }
    }
}
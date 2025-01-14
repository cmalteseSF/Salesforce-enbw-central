global class IntegrationProcedureSystemInterface extends vlocity_cmt.XOMEnhancedSystemInterface {

    global void cleanOrchestrationItems(List<vlocity_cmt__OrchestrationItem__c> items)
    {
    }

    global IntegrationProcedureSystemInterface() {
        super();
    }
 
    global override void executeItem(String url, String path, vlocity_cmt__OrchestrationItem__c item) 
    {
        Id orderId = null;
        
        if (item.vlocity_cmt__OrderItemId__c != null) 
            orderId = item.vlocity_cmt__OrderItemId__r.OrderId;
        else {
            vlocity_cmt__OrchestrationItem__c orchItem = [SELECT 
                                                            Id,
                                                            vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.Id 
                                                            FROM vlocity_cmt__OrchestrationItem__c 
                                                            WHERE Id = :item.Id];
            orderId = orchItem.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.Id;
        }

        Map<String, Object> ipInput   = new Map<String, Object>();
        Map<String, Object> ipOptions = new Map<String, Object>();

        ipInput.put('orderId', orderId);
        ipInput.put('url', url);
        ipInput.put('orchestration_item_id', item.Id);
        ipInput.put('orchestration_item_name', item.Name);       

        Map<String, Object> ipOutput = new Map<String, Object>();
        
        try{
            ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(path, ipInput, ipOptions);  
        } catch(Exception e) {
            throw new vlocity_cmt.XOMOrchestrationInterfaces.SystemInterfaceRecoverableException('IP invocation error: ' + e.getMessage());
        }
        
        processResponse(item, ipInput, ipOutput);
    }
 
    global virtual void processResponse(vlocity_cmt__OrchestrationItem__c item, Map<String, Object> ipInput, Map<String, Object> ipOutput) {

        System.debug('IP Output: ' + JSON.serialize(ipOutput));

        Id orderId = item.vlocity_cmt__OrderItemId__c != null ? item.vlocity_cmt__OrderItemId__r.OrderId : item.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.Id;

        item.vlocity_cmt__Request__c = JSON.serialize(ipInput);
        item.vlocity_cmt__Response__c = JSON.serialize(ipOutput);
        update item;

        if(!ipOutput.isEmpty() && ipOutput.get('success') != null && (Boolean)ipOutput.get('success') == false)
            throw new CalloutException();
    }
 }
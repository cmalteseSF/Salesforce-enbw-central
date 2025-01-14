global with sharing class CopyBaseChargePricingPlanStepImpl implements vlocity_cmt.VlocityOpenInterface 
{
    global Boolean invokeMethod (String methodName,
                                 Map<String, Object> input,
                                 Map<String, Object> output,
                                 Map<String, Object> options)
    {
        if (methodName == 'CopyBaseCharges')
        {
            copyBaseCharges();
            return true;
        }
        return false;
    }
    
    private void copyBaseCharges()
    {
        Map<Id, Map<String, Object>> priceVarMap;
        if (!Test.isRunningTest()) 
        {
            priceVarMap = vlocity_cmt.PricingPlanService.getLineItemPricingVariableValues();
        } 
        else 
        {
            priceVarMap = (Map<Id, Map<String, Object>>)vlocity_cmt.PricingPlanService.getFromPricingContext('TestLineItemPricingVariableValues');
        }              
        
        if (priceVarMap == null || priceVarMap.isEmpty()) return;
                
        for (Id itemId : priceVarMap.keySet())
        {            
            Map<String, Object> valuesMap = priceVarMap.get(itemId);
            if (valuesMap != null)
            {
                Map<String, Object> lineItemVariableMap = (Map<String, Object>)valuesMap.get('PricingVariableValues');
                if (lineItemVariableMap != null)
                {
                    lineItemVariableMap.put('REC_MNTH_STD_BS_PRC', lineItemVariableMap.get('REC_MNTH_STD_PRC'));
                    lineItemVariableMap.put('OT_STD_BS_PRC', lineItemVariableMap.get('OT_STD_PRC'));
                }
            }
        }
    }     
}
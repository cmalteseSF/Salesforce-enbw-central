global class SyncQuoteToOpportunity implements  Callable {
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        try
        {
            if (methodName.equalsIgnoreCase('syncToOppty'))
            {
                System.debug('inside quote');
                syncToOppty(input, output, options);
                return true;
            }
            return false;
        }
        catch (Exception ex) {
            output.put('error', ex.getMessage());
            throw ex;
        }   
    }

    public Object call(String action, Map<String, Object> args) 
    {
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        return invokeMethod(action, inputMap, outputMap, options);
    }
    
	public void syncToOppty(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        String quoteId = (String)input.get('quoteId');
        String opportunityId = (String)input.get('opportunityId');
        updateQuoteIdInOpportunity(opportunityId ,quoteId);
        Map<String, String> fieldMap = new Map<String, String>();
        List<vlocity_cmt__CustomFieldMap__c> mappings = [SELECT Id, vlocity_cmt__DestinationFieldName__c, vlocity_cmt__DestinationSObjectType__c, vlocity_cmt__SourceFieldName__c, vlocity_cmt__SourceFieldSObjectType__c, vlocity_cmt__SourceFieldType__c, vlocity_cmt__SourceSObjectType__c FROM vlocity_cmt__CustomFieldMap__c where vlocity_cmt__SourceSObjectType__c = 'QuoteLineItem' and vlocity_cmt__DestinationSObjectType__c = 'OpportunityLineItem' ];
        System.debug('mappings are ' + mappings);
        for(vlocity_cmt__CustomFieldMap__c mapping : mappings) {
            fieldMap.put(mapping.vlocity_cmt__SourceFieldName__c, mapping.vlocity_cmt__DestinationFieldName__c);
        }

        String fieldStr = String.join(new List<String>(fieldMap.keySet()), ',');
        String queryStr = 'SELECT Id,quote.OpportunityId,OpportunityLineItemId,' + fieldStr + ' FROM QuoteLineItem where quoteId = \'' + quoteId + '\'';
       	System.debug(queryStr);
		List<QuoteLineItem> qliList = Database.query(queryStr);
        List<OpportunityLineItem> optyLineList = new List<OpportunityLineItem>();
        for(QuoteLineItem qli: qliList) {
			if(qli.OpportunityLineItemId != null) {
                OpportunityLineItem optyItem = new OpportunityLineItem(
                    Id = qli.OpportunityLineItemId
                );
                for(String field : fieldMap.keySet()) {
                    optyItem.put(fieldMap.get(field), qli.get(field));
                }
                optyLineList.add(optyItem);
            }
        }
        if(!optyLineList.isEmpty()){
            update optyLineList;
        }
    }
    
    private void updateQuoteIdInOpportunity(String oppId ,String quoteId ){
		if(String.isNotBlank(oppId)){
            Opportunity quoteOpportunity = new Opportunity(id =oppId , SyncedQuoteId =quoteId);
            update quoteOpportunity ;
        }
    }
}
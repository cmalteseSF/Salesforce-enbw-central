public with sharing class IPHandlerController {
    @AuraEnabled(cacheable=true)
    /** test for package.xml  */
    public static List<QuoteLineItem> getQLIRecord(String quoteId,String productCode)
    {
        return [SELECT Id,Product2.Name,Product2.ProductCode, vlocity_cmt__AttributeSelectedValues__c,VoiceSubscriber__c FROM QuoteLineItem WHERE QuoteId  =:quoteId AND Product2.ProductCode =:productCode
        ORDER BY vlocity_cmt__LineNumber__c];
    }

    @AuraEnabled
    public static Map<String, Object> upsertQLIRecord(String subnetValue, String quoteId, String qliId, 
        String rootProductCode, String isNotFirst, String isLast, String dmlType)
    {
        String procedureName = 'PlusNet_IPNetworkHandler';
        Map<String, Object> ipInput = new Map<String, Object> ();
        Map<String, Object> ipOutput = new Map<String, Object> ();
        Map<String, Object> ipOptions = new Map<String, Object> ();
        ipInput.put('subnetValue', subnetValue);
        ipInput.put('quoteId', quoteId);
        ipInput.put('qliId', qliId);
        ipInput.put('rootProductCode', rootProductCode);
        ipInput.put('isNotFirst', isNotFirst);
        ipInput.put('isLast', isLast);
        ipInput.put('dmlType', dmlType);
        ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
        return ipOutput;
    }
}
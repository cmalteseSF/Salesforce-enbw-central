/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 10-24-2023
 * @last modified by  : Sudhir Kumar Thanna
**/
global with sharing class SplitInterfaceLogic implements vlocity_cmt.VlocityOpenInterface 
{

    global Boolean invokeMethod (String methodName, Map<String, object> input, Map<String, object> output, Map<String, object> options) 
    {
        try{
            if(methodName.equalsIgnoreCase('splitQLI')){
                splitQLI(input, output, options);
                return true;
            }
        }
        catch(Exception e){
            System.debug('Exception: ' + e);
            return false;
        }
        return false;
    }

    public static void splitQLI(Map<String,Object> input, Map<String,Object> output, Map<String, Object> options)
    {   
        String quoteId = (String) input.get('QuoteId');
        String productCode = (String) input.get('productCode');

        if(String.isBlank(quoteId) || String.isBlank(productCode))
            throw new IllegalArgumentException();

        QuoteLineItem qli = [SELECT Id, QuoteId 
                            FROM QuoteLineItem 
                            WHERE QuoteId=:quoteId 
                            AND Product2.ProductCode =:productCode 
                            LIMIT 1];

        Map<String,Object> itemInfoMap = new Map<String,Object>();
        vlocity_cmt.ProductLineItemActionParam productLineItemActionParam = new vlocity_cmt.ProductLineItemActionParam();
        productLineItemActionParam.action = 'Split';
        productLineItemActionParam.parentId = qli.QuoteId;
        productLineItemActionParam.lineItemId = qli.Id;
        productLineItemActionParam.itemInfoMap = itemInfoMap;

        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('SplitProduct', productLineItemActionParam);

        Map<String,Object> outputMap = new Map<String,Object>();
        Map<String,Object> optionsMap = new Map<String,Object>();

        vlocity_cmt.DefaultSplitProductImplementation split = new vlocity_cmt.DefaultSplitProductImplementation();
        split.invokeMethod('SplitProduct',inputMap,outputMap,optionsMap);
        System.debug('outputMap: ' + outputMap);

        output.put('qlisIds', outputMap);
    }    
}
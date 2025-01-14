/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 01-11-2024
 * @last modified by  : Sudhir Kumar Thanna
**/
global class DRCustomFunctions implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {

        Boolean result = false;
        System.debug('method - '+methodName);
        
        if (methodName == 'toLabel') 
            outputMap.put('result', toLabel((List<Object>)inputMap.get('arguments')));
        if(methodName.equalsIgnoreCase('trimString')){
            String trimmedString = trimString((List<Object>)inputMap.get('arguments'));
            outputMap.put('result', trimmedString);
        }
        if(methodName.equalsIgnoreCase('toDecimal')){
            Decimal val = toDecimal((List<Object>)inputMap.get('arguments'));
            outputMap.put('result', val);
        }
        if(methodName == 'loadAttributesToJSON'){
            List<Object> args = (List<Object>)inputMap.get('arguments');      
            String attributeValueSerializedMap;
            try{
                attributeValueSerializedMap = loadAttributesToJSON(String.valueOf(args.get(0)),String.valueOf(args.get(1)));
            }
            catch(Exception e){
                outputMap.put('error', e);
                return result;
            }
            result = true;
            outputMap.put('result', attributeValueSerializedMap);
        }
        if(methodName == 'setNodeTo'){
            Object nodeList = setNodeTo((List<Object>)inputMap.get('arguments'));
            outputMap.put('result', nodeList);
        }
        //Check if ACR already exists for billing account
        if(methodName == 'checkACRForBillingAccount'){
            System.debug('acrList is ' + inputMap.get('acrList'));
            Object nodeList = checkACRForBillingAccount((Object)inputMap.get('acrList'));
            outputMap.put('result',nodeList);           
        }
        return true;
    }

    private String toLabel(List<Object> args) {
        if(args.size() != 1){
            InvalidParameterValueException e = new InvalidParameterValueException('toLabel', 'The function must be called with 1 argument');
            throw e;
        }

        Map<String,String> apiToLabelMap = new Map<String,String>();
        List<Schema.PicklistEntry> values = Lead.BusinessCountry__c.getDescribe().getPicklistValues();
            
        for(Schema.PicklistEntry pe : values)
            apiToLabelMap.put(pe.getValue(), pe.getLabel());

        return apiToLabelMap.get((String)args[0]);
    }

    public String trimString(List<Object> args){
        System.debug( 'args...' + args );
        if(args.size() != 1){
            InvalidParameterValueException e = new InvalidParameterValueException('trimString', 'The function must be called with 1 argument');
            throw e;
        }

        String str = (String)args[0];
        System.debug( 'serializedString From Input JSON ...' + str );
        System.debug('String after removing spaces' + str.deleteWhitespace());
        String trimmedString = str.deleteWhitespace();
        return trimmedString;
    }

    public Decimal toDecimal(List<Object> args){
        System.debug( 'In toDecimal args...' + args );
        System.debug( 'In toDecimal args.size() ...' + args.size()  );
        System.debug( 'In toDecimal args[0] ...' + args[0]  );
        if(args.size() != 1){
            InvalidParameterValueException e = new InvalidParameterValueException('toDecimal', 'The function must be called with 1 argument');
            throw e;
        }
        
        //String str = (String)args[0];
        Decimal dec = (Decimal) args[0];
        System.debug( 'In toDecimal dec.' + dec );
        return dec;
    }

    // Created a new Method to update attributes value to FRL JsonAttribute Field
    global static String loadAttributesToJSON(String jsonString, String lisOfAttr) {
        // Early exit if nothing to process
        if(String.isBlank(jsonString)) 
            throw new CustomException('JSON is blank.');
        if(String.isBlank(lisOfAttr)) 
            throw new CustomException('Attributes are required.');
        
        try {
            
            Map<String, Object> jsonParseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
            for(Object abc : (List<Object>)jsonParseMap.values()){        
                for(Object jsonObject : (List<Object>)abc){          
                    Map<String, Object> jsonElementMap;
                    
                    jsonElementMap = (Map<String, Object>)jsonObject;                    
                    String key = (String)jsonElementMap.get('attributeuniquecode__c');                  
                    Map<String, Object> runtimeValMap = (Map<String, Object>)jsonElementMap.get('attributeRunTimeInfo');
        
                    Map<String, Object> jsonParseAttrMap = (Map<String, Object>)JSON.deserializeUntyped(lisOfAttr);          
        if(jsonParseAttrMap.containsKey(key))
        {          
            runtimeValMap.put('value', jsonParseAttrMap.get(key));
        }          
                }                
            }
            return (String)JSON.serialize(jsonParseMap);
        }
        catch(Exception e){
            throw new CustomException(e.getMessage());
        }
    }

    public static Object setNodeTo(List<Object> args){
        if(args.size() != 3){
            InvalidParameterValueException e = new InvalidParameterValueException('setNodeTo', 'The function must be called with 3 arguments. setNodeTo(<json>,<attr-code>,<replaceWith>)');
            throw e;
        }
        
        String inputJson = String.valueOf(args.get(0));
        String nodeName = String.valueOf(args.get(1));
        String replaceWith = String.valueOf(args.get(2));

        Map<String, Object> inputMap = (Map<String, Object>) JSON.deserializeUntyped(inputJson);

        if (inputMap.containsKey(nodeName))
            inputMap.put(nodeName, replaceWith);
       
        return inputMap;
    }
    
    //Check ACR for the billing account
    //If Role has only Billing, set IsActive to false
    //If Roles has more values separated by ;, set IsActive to false and also set Roles to Billing
    public static Object checkACRForBillingAccount(Object args){       
        if(args=='' || args == null){
            throw new IllegalArgumentException('Input ACR list is empty or null');
        }
        List<Map<String,Object>> acrListToReturn = new List<Map<String,Object>>();
        List<Map<String,Object>> acrList = (List<Map<String,Object>>)args;
        for(Map<String,Object> acr:acrList){
            Map<String,Object> mapOfBillingRoleACR = new Map<String,Object>();
            Map<String,Object> mapOfMultipleRoleACR = new Map<String,Object>();
            String roles = (String)acr.get('Roles');
            System.debug('Roles are ' + roles);
            List<String> acrSplit = roles.split(';');
            if(acrSplit.size() == 1){ //Only Billing
                mapOfBillingRoleACR.put('Id',(String)acr.get('Id'));
                mapOfBillingRoleACR.put('IsActive','false');
                acrListToReturn.add(mapOfBillingRoleACR);    
            }
            else if(acrSplit.size() > 1){ //E.g. Billing;Technical
                mapOfMultipleRoleACR.put('Id',(String)acr.get('Id'));
                mapOfMultipleRoleACR.put('IsActive','false');
                mapOfMultipleRoleACR.put('Roles','Billing');
                acrListToReturn.add(mapOfMultipleRoleACR);    
            }
        }    
        return acrListToReturn;
    }
    
    public class CustomException extends Exception{}
    
}
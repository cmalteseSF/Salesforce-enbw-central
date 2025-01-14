/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 01-11-2024
 * @last modified by  : Sudhir Kumar Thanna
**/
@isTest
public class DRCustomFunctionsTest {

    @isTest
    static void testInvokeMethod() {
        List<Object> arguments = new List<Object>{'DE'};
        Map<String, Object> inputMap = new Map<String, Object>{
            'arguments' => arguments
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        DRCustomFunctions drClass = new DRCustomFunctions();
        
        Test.startTest();
        Boolean result = drClass.invokeMethod('toLabel', inputMap, outputMap, optionsMap);
        Test.stopTest();

        Assert.areEqual('Deutschland', outputMap.get('result'));
    }

    @isTest
    static void testInvokeMethodFalse() {
        List<Object> arguments = new List<Object>();
        Map<String, Object> inputMap = new Map<String, Object>{
            'arguments' => arguments
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        
        Boolean exc = false;
        DRCustomFunctions drClass = new DRCustomFunctions();
        
        Test.startTest();
        try{
            Boolean result = drClass.invokeMethod('toLabel', inputMap, outputMap, optionsMap);
        } catch(Exception e){
            exc = true;
        }
        Test.stopTest();

        Assert.isTrue(exc);
    }

    @isTest
    static void testTrimStringInvokeMethod() {
        List<Object> arguments = new List<Object>{'01uMU000000YsKuYAK, 01uMU000000YsKwYAK, 01uMU000000YsLCYA0, 01uMU000000YsLBYA0, 01uMU000000YsKSYA0'};
        Map<String, Object> inputMap = new Map<String, Object>{
            'arguments' => arguments
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        DRCustomFunctions drClass = new DRCustomFunctions();
        
        Test.startTest();
        Boolean result = drClass.invokeMethod('trimString', inputMap, outputMap, optionsMap);
        Test.stopTest();

        Assert.areEqual('01uMU000000YsKuYAK,01uMU000000YsKwYAK,01uMU000000YsLCYA0,01uMU000000YsLBYA0,01uMU000000YsKSYA0', outputMap.get('result'));
    }
    
    @isTest
    static void testTrimStringInvokeMethodException() {
        List<Object> arguments = new List<Object>();
        Map<String, Object> inputMap = new Map<String, Object>{
            'arguments' => arguments
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        DRCustomFunctions drClass = new DRCustomFunctions();
        
        Test.startTest();
        Boolean exc = false;
        try{
        	Boolean result = drClass.invokeMethod('trimString', inputMap, outputMap, optionsMap);
        }catch(Exception e){
			exc = true;            
        }
        Test.stopTest();
        Assert.isTrue(exc);
    }

    @isTest
    public static void testLoadAttributesSuccess(){
        String methodName = 'loadAttributesToJSON';
        String jsonString = '{"b5d70882-1d35-bca3-dd01-279220ed2c3b":[{"attributeuniquecode__c":"TEF_TATTR_ACCOUNT_ID","attributeRunTimeInfo":{"dataType":"Text","default":"","value":"A1-0000000421"}}]}';
        String jsonAttr = '{"PLUSNET_TATTR_ACCOUNT_ID":"A1-0000000500"}';
        
        Map<String, List<Object>> ipMap = new Map<String, List<Object>>();
        
        List<Object> arguments = new List<Object>();
        arguments.add(jsonString);
        arguments.add(jsonAttr);
        
        ipMap.put('arguments', arguments);
        
        Map<String, Object> opMap = new Map<String, Object>();
        
        //PlusNet_DataRaptorService service = new PlusNet_DataRaptorService();
        DRCustomFunctions drClass = new DRCustomFunctions();

        Test.startTest();
        drClass.invokeMethod(methodName, ipMap, opMap, new Map<String, Object>());
        Test.stopTest();
        
        System.assert(opMap.containsKey('error') == false);
  }
    @isTest
    public static void testLoadAttributesException(){
        String methodName = 'loadAttributesToJSON';
        
        Map<String, List<Object>> ipMap = new Map<String, List<Object>>();
        List<Object> arguments = new List<Object>();
        
        ipMap.put('arguments', arguments);
        
        Map<String, Object> opMap = new Map<String, Object>();
        
        //PlusNet_DataRaptorService service = new PlusNet_DataRaptorService();
        DRCustomFunctions drClass = new DRCustomFunctions();

        Test.startTest();
      	drClass.invokeMethod(methodName, ipMap, opMap, new Map<String, Object>());
        Test.stopTest();
	}
    
    @isTest
    static void setNodeTo(){
        
        Map<String, Object> inputMap = new Map<String, Object>{
            'selectedValues' => new Map<String, Object>{
                'ATT-SER-NUM' => 123
            }
        };
        String inputJson = JSON.serialize(inputMap);
        String nodeName = 'ATT-SER-NUM';

        List<Object> args = new List<Object>{inputJson, nodeName, ' '};
        Map<String, Object> outputMap = (Map<String, Object>) DRCustomFunctions.setNodeTo(args);
    }
    
    @isTest
    static void setNodeToInvalidArgs(){
        Map<String, Object> inputMap = new Map<String, Object>{
            'selectedValues' => new Map<String, Object>{
                'ATT-SER-NUM' => 123
            }
        };
        String inputJson = JSON.serialize(inputMap);
        String nodeName = 'ATT-SER-NUM';

        List<Object> args = new List<Object>{inputJson};
        try{
            Map<String, Object> outputMap = (Map<String, Object>) DRCustomFunctions.setNodeTo(args);
        }
        catch(Exception e){}
    }
    
    @isTest
    static void toDecimal(){
        String methodName = 'toDecimal';
        Map<String, List<Object>> ipMap = new Map<String, List<Object>>();
        Map<String, Object> opMap = new Map<String, Object>();
        
        Decimal dec = 10;
        
        List<Object> arguments = new List<Object>();
        arguments.add(dec);
        ipMap.put('arguments', arguments);
        
        //PlusNet_DataRaptorService service = new PlusNet_DataRaptorService();
        DRCustomFunctions drClass = new DRCustomFunctions();

        Test.startTest();
        drClass.invokeMethod(methodName, ipMap, opMap, new Map<String, Object>());
        Test.stopTest();
        
        System.assert(opMap.containsKey('error') == false);
  }
    
    @isTest
    static void toDecimalInvalidArgs(){
        String methodName = 'toDecimal';
        Map<String, List<Object>> ipMap = new Map<String, List<Object>>();
        Map<String, Object> opMap = new Map<String, Object>();
        
        List<Object> arguments = new List<Object>();
        ipMap.put('arguments', arguments);
        
        //PlusNet_DataRaptorService service = new PlusNet_DataRaptorService();
        DRCustomFunctions drClass = new DRCustomFunctions();

        Test.startTest();
        Boolean exc = false;
        try{
        	drClass.invokeMethod(methodName, ipMap, opMap, new Map<String, Object>());
        }catch(Exception e){
            exc = true;
        }
        Test.stopTest();
        
		Assert.isTrue(exc);  
    }
    
    @isTest
    static void checkACRForBillingAccount(){
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        List<Map<String,Object>> acrListToReturn = new List<Map<String,Object>>();
        Map<String,Object> mapOfBillingRole = new Map<String,Object>();
        mapOfBillingRole.put('Id','TestId');
        mapOfBillingRole.put('IsActive','false');
        mapOfBillingRole.put('Roles','Billing');
        acrListToReturn.add(mapOfBillingRole);
        Map<String,Object> mapOfMultipleRole = new Map<String,Object>();
        mapOfMultipleRole.put('Id','TestId');
        mapOfMultipleRole.put('IsActive','false');
        mapOfMultipleRole.put('Roles','Billing;Technical');
        acrListToReturn.add(mapOfMultipleRole);
        Map<String, Object> inputMap = new Map<String, Object>{
            'acrList' => acrListToReturn
        };

        Test.startTest();
            DRCustomFunctions obj = new DRCustomFunctions();
            Boolean result = obj.invokeMethod('checkACRForBillingAccount', inputMap, outputMap, optionsMap);
        Test.stopTest();
        
        Assert.isTrue(result);  
    }
    
    @isTest
    static void checkACRForBillingAccountIsNullArgs(){
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>{
            'acrList' => ''
        };

        Test.startTest();
            DRCustomFunctions obj = new DRCustomFunctions();
            Boolean exc = false;
            try{
                obj.invokeMethod('checkACRForBillingAccount', inputMap, outputMap, optionsMap);
            }catch(Exception e){
                exc = true;
            }
        Test.stopTest();
        
        Assert.isTrue(exc);  
    }
}
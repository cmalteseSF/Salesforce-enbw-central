@isTest
private class EncryptionHandlerTest {

    @isTest
    static void decryptTestSuccess() {
        String encryptedData = '9T1dkX4yRFrLoqZP%2BgNk8jBMM1LuRCEcgUr0obFmA%2FM%3D';
        String key = [SELECT Id, PrivateKey__c FROM Encryption_Configuration__mdt WHERE DeveloperName = 'Portal'].PrivateKey__c;
        
        Map<String, Object> inputMap = new Map<String, Object>{
            'encryptedData' => encryptedData,
            'key' => key
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        
        EncryptionHandler encryptionClass = new EncryptionHandler();
        
        Test.startTest();
        Boolean result = encryptionClass.invokeMethod('decrypt', inputMap, outputMap, optionsMap);
        Test.stopTest();

        Assert.isNotNull(outputMap.get('decryptedData'));
    }

    @isTest
    static void decryptTestFailure() {
        String encryptedData = 'mnPpX+AdILJpPzfvWfo0BmYhLJopqAUGPKEee+yXNxfm3TOOhKufQiWVsN1H6Trd';
        String key = [SELECT Id, PrivateKey__c FROM Encryption_Configuration__mdt WHERE DeveloperName = 'Portal'].PrivateKey__c;
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        
        EncryptionHandler encryptionClass = new EncryptionHandler();
        
        Test.startTest();
        Boolean result = false;
        try{
            Boolean decryptedString = encryptionClass.invokeMethod('decrypt', inputMap, outputMap, optionsMap);
        } catch (Exception e){
            result = true;
        }
        Test.stopTest();

        Assert.isTrue(result);
    }

    @isTest
    static void invokeMethodTestFailure() {
        String encryptedData = 'mnPpX+AdILJpPzfvWfo0BmYhLJopqAUGPKEee+yXNxfm3TOOhKufQiWVsN1H6Trd';
        String key = [SELECT Id, PrivateKey__c FROM Encryption_Configuration__mdt WHERE DeveloperName = 'Portal'].PrivateKey__c;
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        
        EncryptionHandler encryptionClass = new EncryptionHandler();
        
        Test.startTest();
        Boolean decryptedString = encryptionClass.invokeMethod('', inputMap, outputMap, optionsMap);
        Test.stopTest();

        Assert.isFalse(decryptedString);
    }

    @isTest
    static void encryptTestSuccess() {
        String data = 'aaa';
        String key = [SELECT Id, PrivateKey__c FROM Encryption_Configuration__mdt WHERE DeveloperName = 'Portal'].PrivateKey__c;
                
        Test.startTest();
        String encryptedData = EncryptionUtil.encrypt(data, key);
        Test.stopTest();

        Assert.areNotEqual(data, encryptedData);
    }

}
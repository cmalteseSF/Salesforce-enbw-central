@isTest(seeAllData=true)
private class PortalRestServiceTests {
    @isTest
    public static void testSuccessfulGetQuoteDetails(){
        Quote quo = [SELECT Id FROM Quote WHERE Status='Accepted' LIMIT 1];
        Encryption_Configuration__mdt encryptionConfig = [SELECT Id, PrivateKey__c FROM Encryption_Configuration__mdt WHERE DeveloperName='Portal'];
        String encryptedData = EncryptionUtil.encrypt(quo.Id,encryptionConfig.PrivateKey__c);
        
        // Initialize Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/portal/apexrest/quotes';
        req.params.put('quoteId',encryptedData);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            PortalRestService.getQuoteDetails();
        Test.stopTest();
        
        System.assertEquals(200, res.StatusCode, 'The Response is not successful and the response is ' + res.responseBody.toString());
    }
    
    @isTest
    public static void testUnSuccessfulGetQuoteDetails(){
        // Initialize Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/portal/apexrest/quotes';
        req.params.put('quoteId','');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            PortalRestService.getQuoteDetails();
        Test.stopTest();
        
        System.assertEquals(400, res.StatusCode, 'The Response is not as expected and the response is ' + res.responseBody.toString());
    }
    
    @isTest
    public static void testExceptionGetQuoteDetails(){
        // Initialize Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/portal/apexrest/quotes';
        req.params.put('quoteId',null);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            PortalRestService.getQuoteDetails();
        Test.stopTest();
        
        System.assertEquals(400, res.StatusCode, 'The Response is not as expected and the response is ' + res.responseBody.toString());
    }
    
    @isTest
    public static void testSuccessfulUpdateQuoteDetails(){
        Quote quo = [SELECT Id FROM Quote WHERE Status='Accepted' LIMIT 1];
        Encryption_Configuration__mdt encryptionConfig = [SELECT Id, PrivateKey__c FROM Encryption_Configuration__mdt WHERE DeveloperName='Portal'];
        String encryptedData = EncryptionUtil.encrypt(quo.Id,encryptionConfig.PrivateKey__c);
        
        // Initialize Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/portal/apexrest/quotes';
        req.params.put('quoteId',encryptedData);
        req.httpMethod = 'POST';
        String jsonString = '{"status" : "Accepted"}';
        req.requestBody = Blob.valueOf(jsonString);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            PortalRestService.updateQuoteDetails();
        Test.stopTest();
        
        System.assertEquals(200, res.StatusCode, 'The Response is not successful and the response is ' + res.responseBody.toString());
    }
    
    @isTest
    public static void testUnSuccessfulUpdateQuoteDetails(){
        // Initialize Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/portal/apexrest/quotes';
        req.params.put('quoteId','');
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"status": "Accepted","signedBy": {"position": "Manager","name": "Test Name","email": "test@gmail.com"},"termsConditions": {"term1": "Term1 Condition","term2": "Term2 Condition","term3": "Term3 Condition","term4": "Term4 Condition"}}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            PortalRestService.updateQuoteDetails();
        Test.stopTest();
        
        System.assertEquals(400, res.StatusCode, 'The Response is not as expected and the response is ' + res.responseBody.toString());
    }
    
    @isTest
    public static void testExceptionUpdateQuoteDetails(){
        // Initialize Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/portal/apexrest/quotes';
        req.params.put('quoteId',null);
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"status": "Accepted","signedBy": {"position": "Manager","name": "Test Name","email": "test@gmail.com"},"termsConditions": {"term1": "Term1 Condition","term2": "Term2 Condition","term3": "Term3 Condition","term4": "Term4 Condition"}}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            PortalRestService.updateQuoteDetails();
        Test.stopTest();
        
        System.assertEquals(400, res.StatusCode, 'The Response is not as expected and the response is ' + res.responseBody.toString());
    }
}
@isTest
public class EmailNotificationHandlerTest {

    @testSetup
    static void setupTestData() {
        // Create Email Template for Quote Document
        EmailTemplate quoteTemplate = new EmailTemplate(
            Name = 'QuoteDocumentTemplateTestName',
            DeveloperName = 'QuoteDocumentTemplateTest',
            HtmlValue = '<html><body>{{{Quote.QuoteNumber}}} - {{{Sender.CompanyName}}}</body></html>',
            Subject = 'TestQuote: {{{Quote.QuoteNumber}}}',
            Body = 'TestQuote: {{{Quote.QuoteNumber}}} - {{{Sender.CompanyName}}}',
            FolderId = UserInfo.getUserId(),
            TemplateType = 'custom'
        );
        insert quoteTemplate;

        // Create Email Template for Order Voice Termination
        EmailTemplate orderTemplate = new EmailTemplate(
            Name = 'OrderVoiceTerminationTemplateTestName',
            DeveloperName = 'OrderVoiceTerminationTemplateTest',
            HtmlValue = '<html><body>{{{Order.OrderNumber}}} - {{{Order.ATPBillingAccountId__c}}}</body></html>',
            Subject = 'TestOrder: {{{Order.OrderNumber}}}',
            Body = 'TestOrder: {{{Order.OrderNumber}}} - {{{Order.ATPBillingAccountId__c}}}',
            FolderId = UserInfo.getUserId(),
            TemplateType = 'custom'
        );
        insert orderTemplate;

        // Create Encryption Configuration
       /* Encryption_Configuration__mdt encryptionConfig = new Encryption_Configuration__mdt(
            DeveloperName = 'Portal',
            PrivateKey__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256))
        );
        insert encryptionConfig;*/

    }

    @isTest
    static void testInvokeMethod_SendEmailQuoteDocument() {
        // Mock input data
        Map<String, Object> input = new Map<String, Object>{
            'emailTemplateName' => 'QuoteDocumentTemplateTest',
            'quoteCreatedDate' => '10-09-24',     
            'quoteNumber' => 'Q-00001',
            'userCompanyName' => 'Test Company',
            'userName' => 'Test User',
            'userAddress' => '123 Test St',
            'whatId' => 'a0S1H00000kPpILUA0',
            'fromAddress' => System.Label.FromAddress,
            'emailTargetObjectId' => UserInfo.getUserId()
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String emailAddressFromTemplate = (String)input.get('fromAddress');
        OrgWideEmailAddress[] addresses = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: emailAddressFromTemplate];


        // Invoke method
        Boolean result = (new EmailNotificationHandler()).invokeMethod('sendEmailQuoteDocument', input, outMap, options);

        // Assertions
        System.assert(result);
        System.assertEquals(true, outMap.get('EmailResult'));
    }

    @isTest
    static void testInvokeMethod_SendEmailOrderVoiceTermination() {
        // Mock input data
        Map<String, Object> orderData = new Map<String, Object>{
            'OrderNumber' => 'O-00001',
            'ATPBillingAccountId' => '0011H00001kPpILUA0',
            'RequestDate' => '2024-05-31T00:00:00.000Z',
            'LegacyContractId' => 'LC-12345',
            'BusinessAccountName' => 'Business Account',
            'PartnerId' => 'P-12345',
            'ServiceAddress' => '456 Service St',
            'BusinessAddress' => '789 Business St',
            'OrderItemCount' => 1
        };

        List<Map<String, Object>> orderItemData = new List<Map<String, Object>>{
            new Map<String, Object>{
                'ProductName' => 'Product1',
                'PhoneNo' => '1234567890'
            }
        };

        Map<String, Object> input = new Map<String, Object>{
            'emailTemplateName' => 'OrderVoiceTerminationTemplateTest',
            'orderData' => orderData,
            'orderItemData' => orderItemData,
            'orderId' => 'a0S1H00000kPpILUA0',
            'fromAddress' => System.Label.FromAddress,
            'emailTargetObjectId' => UserInfo.getUserId()
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String emailAddressFromTemplate = (String)input.get('fromAddress');
        OrgWideEmailAddress[] addresses = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: emailAddressFromTemplate];

        // Invoke method
        Boolean result = (new EmailNotificationHandler()).invokeMethod('sendEmailOrderVoiceTermination', input, outMap, options);

        // Assertions
        System.assert(result);
        System.assertEquals(true, outMap.get('EmailResult'));
    }

   /*  @isTest
    static void testEncrypt() {
        String clearText = 'TestString';
        String key = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        String encryptedText = EmailNotificationHandler.encrypt(clearText, key);
        System.assertNotEquals(clearText, encryptedText);
    }*/

    @isTest
    static void testConvertListObjectToListString() {
        List<Object> objectList = new List<Object>{'item1', 'item2', 'item3'};
        Map<String, Object> input = new Map<String, Object>{'key' => objectList};

        List<String> stringList = EmailNotificationHandler.convertListObjectToListString(input, 'key');
        System.assertEquals(3, stringList.size());
        System.assertEquals('item1', stringList[0]);
    }
}
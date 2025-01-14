/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 07-31-2023
 * @last modified by  : Sudhir Kumar Thanna
**/
@isTest
private class CreateContractFromQuoteHandlerTest {

    // Test data setup method for Account, Contact, Opportunity, and Quote
    static void setupTestData() {
        // Create an Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Create a Contact associated with the Account
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        // Create an Opportunity associated with the Account and Contact
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Qualifikation',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            ContactId = testContact.Id
        );
        insert testOpportunity;
        
        // Create a Quote associated with the Opportunity
        Quote testQuote = new Quote(
            Name = 'Test Quote',
            OpportunityId = testOpportunity.Id
        );
        insert testQuote;

    }

    @isTest
    static void testCreateAndUpdateContract() {
        setupTestData();
        // Retrieve the test Quote created in the setup method
        Quote testQuote = [SELECT Id,Name,AccountId,OpportunityId FROM Quote WHERE Name = 'Test Quote' LIMIT 1];
        System.debug('testQuote ... ' + testQuote);

        // Set up the input and output maps
        Map<String, Object> input = new Map<String, Object>{'QuoteId' => testQuote.Id};
        Map<String, Object> output = new Map<String, Object>();

        String methodName = 'createAndUpdateContract';
        // Call the method to test
        CreateContractFromQuoteHandler handler = new CreateContractFromQuoteHandler();
        handler.invokeMethod(methodName,input, output, new Map<String, Object>());
    }
        @isTest
    static void testCreateAndUpdateContractNoMethodName() {
        setupTestData();
        // Retrieve the test Quote created in the setup method
        Quote testQuote = [SELECT Id,Name,AccountId,OpportunityId FROM Quote WHERE Name = 'Test Quote' LIMIT 1];
        System.debug('testQuote ... ' + testQuote);

        // Set up the input and output maps
        Map<String, Object> input = new Map<String, Object>{'QuoteId' => testQuote.Id};
        Map<String, Object> output = new Map<String, Object>();

        String methodName = '';
        // Call the method to test
        CreateContractFromQuoteHandler handler = new CreateContractFromQuoteHandler();
        handler.invokeMethod(methodName,input, output, new Map<String, Object>());

    }
}
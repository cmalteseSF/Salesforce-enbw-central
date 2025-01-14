@isTest
public with sharing class IPHandlerControllerTest {
    @TestSetup static void createData() {
        // Create test data
        Account acc = new Account(name = 'test acc');
        insert acc;

        Opportunity opp = new Opportunity(name = 'test opp');
        opp.AccountId = acc.Id;
        opp.StageName = 'Qualifikation';
        opp.CloseDate = Date.today();
        insert opp;
        
        Product2 pro = new Product2(Name = 'Test Product', ProductCode = 'PNET-IP-NET');
        insert pro;
        
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );       
        update standardPricebook;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 10,
            IsActive = true
        );
        insert pbe;

        Quote quo = new Quote(name = 'test Quote');
        quo.OpportunityId = opp.Id;
        quo.Pricebook2Id = standardPricebook.Id;
        insert quo;
        
        QuoteLineItem testQuoteLineItem = new QuoteLineItem(
            QuoteId = quo.Id,
            Product2Id = pro.Id,
            UnitPrice = 10,
            PricebookEntryId = pbe.Id,
            Quantity = 1
        );
        insert testQuoteLineItem;
	}
    
    @isTest
    static void testGetQuoteLineItems() {
        Quote quo = [SELECT Id FROM Quote LIMIT 1];

        Test.startTest();
        	List<QuoteLineItem> result = IPHandlerController.getQLIRecord(quo.Id,'PNET-IP-NET');
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(1, result.size(), 'Expected one QuoteLineItem in the result');
    }

    @isTest
    static void testUpsertQLIRecord() {
        Quote quo = [SELECT Id FROM Quote LIMIT 1];
        QuoteLineItem qli = [SELECT Id FROM QuoteLineItem LIMIT 1];
        
        Test.startTest();
        	Object ipOutput = IPHandlerController.upsertQLIRecord('27', quo.Id, qli.Id, 'PNET-IP-NET', 'false' , 'false' , 'Add');
        Test.stopTest();

        Assert.isNotNull(ipOutput);
    }
}
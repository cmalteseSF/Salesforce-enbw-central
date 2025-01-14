/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 02-15-2024
 * @last modified by  : Sudhir Kumar Thanna
**/
@isTest
public with sharing class QuoteControllerTest {

    @isTest
    static void testGetQuoteLineItems() {
        // Create test data
        Account acc = new Account(name = 'test acc');
        insert acc;

        Opportunity opp = new Opportunity(name = 'test opp');
        opp.AccountId = acc.Id;
        opp.StageName = 'Qualifikation';
        opp.CloseDate = Date.today();
        insert opp;

       
        
        Product2 pro = new Product2(Name = 'Test Product', ProductCode = 'PNET-IPF-ACC');
        Insert pro;
        
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        Update standardPricebook;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 10,
            IsActive = true
        );
        Insert pbe;

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

        Test.startTest();
        List<QuoteLineItem> result = QuoteController.getQuoteLineItems(quo.Id,pro.ProductCode);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(1, result.size(), 'Expected one QuoteLineItem in the result');
    }

    @isTest
    static void testGetQuoteDetails() {
        Account acc = new Account(name = 'test acc');
        insert acc;

        Opportunity opp = new Opportunity(name = 'test opp');
        opp.AccountId = acc.Id;
        opp.StageName = 'Qualifikation';
        opp.CloseDate = Date.today();
        insert opp;

        Quote quo = new Quote(name = 'test Quote');
        quo.OpportunityId = opp.Id;
        insert quo;

        Test.startTest();
        List<Quote> result = QuoteController.getQuoteDetails(quo.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(1, result.size(), 'Expected one Quote in the result');
    }
}
@isTest
public with sharing class SyncQuoteToOpportunityTest {
    @TestSetup
    static void setupTestData() {
        // Create test data
        Account acc = new Account(name = 'test acc');
        insert acc;

        Opportunity opp = new Opportunity(name = 'test opp');
        opp.AccountId = acc.Id;
        opp.StageName = 'Qualifikation';
        opp.CloseDate = Date.today();
        insert opp;
       
        Product2 pro = new Product2(Name = 'Test Product', ProductCode = 'PNET-SIP-ACC');
        pro.IsActive = true;
        insert pro;
        
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

        OpportunityLineItem opportunityProduct = new OpportunityLineItem(
            OpportunityId = opp.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 10,
            UnitPrice = pbe.UnitPrice,
            vlocity_cmt__OneTimeDiscountPrice__c = 100
        );
        insert opportunityProduct;
        
        Quote quo = new Quote(name = 'test Quote');
        quo.OpportunityId = opp.Id;
        quo.Pricebook2Id = standardPricebook.Id;
        insert quo;
        
        QuoteLineItem testQuoteLineItem = new QuoteLineItem(
            QuoteId = quo.Id,
            Product2Id = pro.Id,
            UnitPrice = 10,
            PricebookEntryId = pbe.Id,
            vlocity_cmt__OneTimeDiscountPrice__c = 100,
            Quantity = 3
        );
        insert testQuoteLineItem;
        
        vlocity_cmt__CustomFieldMap__c customFieldRecord = new vlocity_cmt__CustomFieldMap__c();
        customFieldRecord.vlocity_cmt__SourceSObjectType__c = 'QuoteLineItem';
        customFieldRecord.vlocity_cmt__DestinationSObjectType__c = 'OpportunityLineItem';
        customFieldRecord.vlocity_cmt__SourceFieldName__c = 'vlocity_cmt__OneTimeDiscountPrice__c';
        customFieldRecord.vlocity_cmt__DestinationFieldName__c = 'vlocity_cmt__OneTimeDiscountPrice__c';
        customFieldRecord.Name = 'Test';
        insert customFieldRecord;
    }

    @isTest
    static void testSyncToOppty() {
        Quote testQuote = [SELECT Id  FROM Quote LIMIT 1];
        Opportunity testOpp = [SELECT Id  FROM Opportunity LIMIT 1];
        QuoteLineItem testQuoteLineItem =[SELECT Id , vlocity_cmt__OneTimeDiscountPrice__c FROM QuoteLineItem LIMIT 1];
        OpportunityLineItem testOpptyLineItem = [SELECT Id , vlocity_cmt__OneTimeDiscountPrice__c FROM OpportunityLineItem LIMIT 1];
        vlocity_cmt__CustomFieldMap__c record = [SELECT Id FROM vlocity_cmt__CustomFieldMap__c LIMIT 1];
       
        // Call the syncToOppty method
        SyncQuoteToOpportunity syncClass = new SyncQuoteToOpportunity();
        Map<String, Object> input = new Map<String, Object>{'quoteId' => testQuote.Id , 'opportunityId'=> testOpp.Id };
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>();
        args.put('input',input);
        args.put('output',output);
        args.put('options',options);
        
        Test.startTest();
            syncClass.call('syncToOppty', args);
        Test.stopTest();

        OpportunityLineItem updatedOpptyLineItem = [SELECT Id, vlocity_cmt__OneTimeDiscountPrice__c  FROM OpportunityLineItem LIMIT 1];
        System.assertEquals(testQuoteLineItem.vlocity_cmt__OneTimeDiscountPrice__c , updatedOpptyLineItem.vlocity_cmt__OneTimeDiscountPrice__c , 'vlocity_cmt__OneTimeDiscountPrice__c should be updated');
    }
}
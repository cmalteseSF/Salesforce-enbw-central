/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 02-15-2024
 * @last modified by  : Sudhir Kumar Thanna
**/
@isTest
private class OrderControllerTest {

    @isTest
    static void testGetOrderItems() {


// Create test data
        Account acc = new Account(name = 'test acc');
        insert acc;

        Opportunity opp = new Opportunity(name = 'test opp');
        opp.AccountId = acc.Id;
        opp.StageName = 'Qualifikation';
        opp.CloseDate = Date.today();
        insert opp;

        Product2 pro = new Product2();
        pro.Name = 'test-SOHO-300';
        pro.ProductCode = 'test-PNET-B2B-FIB-SOHO-300';
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

        Contract cont = new Contract(name = 'test contract');
        cont.AccountId = acc.Id;
        cont.vlocity_cmt__QuoteId__c = quo.Id;
        cont.vlocity_cmt__OpportunityId__c = opp.Id;
        insert cont;

        Order testOrder = new Order();
        testOrder.AccountId = acc.Id;
        testOrder.vlocity_cmt__QuoteId__c = quo.Id;
        testOrder.ContractId = cont.Id;
        testOrder.EffectiveDate = System.Today();
        testOrder.Status = 'Draft';
        testOrder.Pricebook2Id = standardPricebook.Id;
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(
            OrderId = testOrder.Id,
            Product2Id = pro.Id,
            UnitPrice = 10,
            PricebookEntryId = pbe.Id,
            Quantity = 1
        );
        insert testOrderItem;

        Test.startTest();
        List<OrderItem> result = OrderController.getOrderItems(testOrder.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
       
    }

    @isTest
    static void testGetCarrierNames() {
       

        Test.startTest();
        List<vlocity_cmt__PicklistValue__c> result = OrderController.getCarrierNames();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
      
    }
}
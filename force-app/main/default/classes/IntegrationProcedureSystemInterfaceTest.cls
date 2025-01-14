@isTest  
global class IntegrationProcedureSystemInterfaceTest {
    @testSetup static void setup(){
        Account acc=createAccount('Test_ConsumerAccount', 'Consumer','Active','External Referral');
        acc.vlocity_cmt__PreferredLanguage__c = 'NL';
        insert acc;
        Product2 prod=createProduct2('Electricity Fixed 3 Years', 'Product');
        prod.vlocity_cmt__Type__c='Service';
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = createPriceBookEntry(pricebookId, prod.id, 5);
        insert pbe;
        
        Order ord=createOrder(acc.id,'MasterOrder', 'Draft',System.today());
        ord.Pricebook2Id=pricebookId;
        insert ord;
        
        OrderItem oItem = createOrderItem(ord.Id, prod.Id, 1, 1, pbe.Id);
        insert oItem;
        
        vlocity_cmt__OrchestrationPlan__c orcPlan = new vlocity_cmt__OrchestrationPlan__c();
        insert orcPlan;
        
        vlocity_cmt__OrchestrationItem__c orcItem = new vlocity_cmt__OrchestrationItem__c();
        orcItem.vlocity_cmt__OrderItemId__c = oItem.Id;
        orcItem.vlocity_cmt__OrchestrationPlanId__c = orcPlan.Id;
        orcItem.Name = 'On Supply';
        insert orcItem;
        
        vlocity_cmt__OrchestrationItem__c orcItem2 = new vlocity_cmt__OrchestrationItem__c();
        orcItem2.vlocity_cmt__OrderItemId__c = oItem.Id;
        orcItem2.vlocity_cmt__OrchestrationPlanId__c = orcPlan.Id;
        orcItem2.Name = 'Monitor Cancellation';
        insert orcItem2;
        
        vlocity_cmt__OrchestrationItem__c orcItem3 = new vlocity_cmt__OrchestrationItem__c();
        orcItem3.vlocity_cmt__OrderItemId__c = oItem.Id;
        orcItem3.vlocity_cmt__OrchestrationPlanId__c = orcPlan.Id;
        orcItem3.Name = 'Supply Agreement';
        insert orcItem3;
    }
    
    static testMethod void testmethod1(){
        IntegrationProcedureSystemInterface testInstance = new IntegrationProcedureSystemInterface();
        vlocity_cmt__OrchestrationItem__c test1 = new vlocity_cmt__OrchestrationItem__c();
        test1 = [Select Id,vlocity_cmt__OrderItemId__c,vlocity_cmt__OrderItemId__r.OrderId, vlocity_cmt__OrchestrationItem__c.Name from vlocity_cmt__OrchestrationItem__c where Name = 'On Supply'].get(0);
        Map<String,Object> valMap1 = new Map<String,Object>();
        Map<String,Object> valMap2 = new Map<String,Object>();
        valMap2.put('success',true);
        test.startTest();
        try{
            testInstance.startBatch('url', 'path');
            testInstance.executeItem('startCoolDown','OM_StartCoolDown',test1);
            testInstance.processResponse(test1, valMap1, valMap2);
            testInstance.endBatch('url', 'path');
        } catch (Exception e){
            System.debug(e.getMessage());
        }
        test.stopTest();
    }
    
    static testMethod void testmethod2(){
        IntegrationProcedureSystemInterface testInstance = new IntegrationProcedureSystemInterface();
        vlocity_cmt__OrchestrationItem__c test1 = new vlocity_cmt__OrchestrationItem__c();
        test1 = [Select Id,vlocity_cmt__OrderItemId__c,vlocity_cmt__OrderItemId__r.OrderId,vlocity_cmt__fulfilmentRequestLineId__r.vlocity_cmt__fulfilmentRequestId__c, vlocity_cmt__OrchestrationItem__c.Name from vlocity_cmt__OrchestrationItem__c where Name = 'Monitor Cancellation'].get(0);
        Map<String,Object> valMap1 = new Map<String,Object>();
        Map<String,Object> valMap2 = new Map<String,Object>();
        valMap2.put('hasError',true);
        valMap2.put('errorMessage','error');
        test.startTest();
        try{
            testInstance.startBatch('url', 'path');
            testInstance.executeItem('startCoolDown','OM_CreateCommunityUser',test1);
        } catch (Exception e){
            System.debug(e.getMessage());
        }
        test.stopTest();
    }
    
    static testMethod void testmethod3(){
        IntegrationProcedureSystemInterface testInstance = new IntegrationProcedureSystemInterface();
        vlocity_cmt__OrchestrationItem__c test1 = new vlocity_cmt__OrchestrationItem__c();
        test1 = [Select Id,vlocity_cmt__OrderItemId__c,vlocity_cmt__OrderItemId__r.OrderId, vlocity_cmt__OrchestrationItem__c.Name from vlocity_cmt__OrchestrationItem__c where Name = 'Supply Agreement'].get(0);
        Map<String,Object> valMap1 = new Map<String,Object>();
        Map<String,Object> valMap2 = new Map<String,Object>();
        valMap2.put('hasError',true);
        valMap2.put('errorMessage','error');
        test.startTest();
        try{
            testInstance.startBatch('url', 'path');
            testInstance.executeItem('startCoolDown','OM_CreateCommunityUser',test1);
            testInstance.processResponse(test1, valMap1, valMap2);
        } catch (Exception e){
            System.debug(e.getMessage());
        }
        test.stopTest();
    }
    
    static testMethod void testmethod4(){
        IntegrationProcedureSystemInterface testInstance = new IntegrationProcedureSystemInterface();
        vlocity_cmt__OrchestrationItem__c test1 = new vlocity_cmt__OrchestrationItem__c();
        test1 = [Select Id,vlocity_cmt__OrderItemId__c,vlocity_cmt__OrderItemId__r.OrderId, vlocity_cmt__OrchestrationItem__c.Name from vlocity_cmt__OrchestrationItem__c where Name = 'Supply Agreement'].get(0);
        Map<String,Object> valMap1 = new Map<String,Object>();
        Map<String,Object> valMap2 = new Map<String,Object>();
        valMap2.put('hasError',true);
        valMap2.put('errorMessage','error');
        test.startTest();
        try{
            testInstance.cleanOrchestrationItems(new List<vlocity_cmt__OrchestrationItem__c>{test1});
            testInstance.executeItem('startCoolDown','OM_CreateCommunityUser',test1);
            testInstance.processResponse(test1, valMap1, valMap2);
        } catch (Exception e){
            System.debug(e.getMessage());
        }
        test.stopTest();
    }
    
    // Method to create a test Account
    private static Account createAccount(String name, String type, String status, String source) {
        Account acc = new Account();
        acc.Name = name;
        acc.Type = type;
        acc.vlocity_cmt__Status__c = status;
        acc.AccountSource = source;
        return acc;
    }

    // Method to create a test Product2
    private static Product2 createProduct2(String name, String family) {
        Product2 prod = new Product2();
        prod.Name = name;
        prod.Family = family;
        return prod;
    }

    // Method to create a test PricebookEntry
    private static PricebookEntry createPriceBookEntry(Id pricebookId, Id productId, Decimal unitPrice) {
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = pricebookId;
        pbe.Product2Id = productId;
        pbe.UnitPrice = unitPrice;
        pbe.IsActive = true;
        return pbe;
    }

    // Method to create a test Order
    private static Order createOrder(Id accountId, String type, String status, Date effectiveDate) {
        Order ord = new Order();
        ord.AccountId = accountId;
        ord.Type = type;
        ord.Status = status;
        ord.EffectiveDate = effectiveDate;
        return ord;
    }

    // Method to create a test OrderItem
    private static OrderItem createOrderItem(Id orderId, Id productId, Decimal quantity, Decimal unitPrice, Id pricebookEntryId) {
        OrderItem oItem = new OrderItem();
        oItem.OrderId = orderId;
        oItem.Product2Id = productId;
        oItem.Quantity = quantity;
        oItem.UnitPrice = unitPrice;
        oItem.PricebookEntryId = pricebookEntryId;
        return oItem;
    }
}
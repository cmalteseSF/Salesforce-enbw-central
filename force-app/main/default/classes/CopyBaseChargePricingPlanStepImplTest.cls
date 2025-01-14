@isTest
private class CopyBaseChargePricingPlanStepImplTest {
    
    static testMethod void testCopyBaseCharges() 
    {      
        try
        {
            List<SObject> sObjList = new List<SObject>();
            
            // Create products
            Product2 prod1 = new Product2 (Name='Product 1', ProductCode = 'PROD1');
            sObjList.add(prod1);

            Product2 prod2 = new Product2 (Name='Product 2', ProductCode = 'PROD2');
            sObjList.add(prod2);

            insert sObjList;            
            sObjList.clear();
            
            // Create Price Book Entries
            Pricebook2 testPricebook =  new Pricebook2(Id = Test.getStandardPricebookId(), Name = 'TestPricebook', IsActive = true);
            PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = testPricebook.Id,
                Product2Id = prod1.Id, UnitPrice = 10, vlocity_cmt__RecurringPrice__c = 5, IsActive = true);
            sObjList.add(pbe1);

            PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = testPricebook.Id,
                Product2Id = prod2.Id, UnitPrice = 20, vlocity_cmt__RecurringPrice__c = 10, IsActive = true);
            sObjList.add(pbe2);

            insert sObjList;            
            sObjList.clear();
            
            // Create Account
            Account testAccount = new Account();
            testAccount.Name = 'Test Account';
            insert testAccount;
            
            // Create Order and OrderItems
            Order testOrder = new Order(Name='Test Order',EffectiveDate=System.today(),status='Draft',AccountId = testAccount.Id, Pricebook2Id = testPricebook.Id);
            insert testOrder;

            OrderItem orderItem = new OrderItem();
            orderItem.OrderId = testOrder.Id;
            orderItem.PricebookEntryId = pbe1.Id;
            orderItem.Quantity = 1;
            orderItem.UnitPrice = 10;
            orderItem.vlocity_cmt__LineNumber__c = '0001';
            orderItem.vlocity_cmt__Action__c = 'Add';
            orderItem.vlocity_cmt__ProvisioningStatus__c = 'New';
            orderItem.vlocity_cmt__OneTimeCharge__c = 10.00;
            orderItem.vlocity_cmt__RecurringCharge__c = 5.00;
            sObjList.add(orderItem);

            OrderItem orderItem2 = new OrderItem();
            orderItem2.OrderId = testOrder.Id;
            orderItem2.PricebookEntryId = pbe2.Id;
            orderItem2.Quantity = 1;
            orderItem2.UnitPrice = 20;
            orderItem2.vlocity_cmt__LineNumber__c = '0001.0001';
            orderItem2.vlocity_cmt__Action__c = 'Add';
            orderItem2.vlocity_cmt__ProvisioningStatus__c = 'New';
            orderItem.vlocity_cmt__OneTimeCharge__c = 20.00;
            orderItem.vlocity_cmt__RecurringCharge__c = 10.00;
            sObjList.add(orderItem2);
            
            insert sObjList;
            sObjList.clear();
    
            Test.startTest();
            
            List<SObject> itemList = [SELECT Id, PricebookEntry.Id, PricebookEntry.Product2.Id, PricebookEntry.Product2.Name, Quantity, vlocity_cmt__LineNumber__c,
                vlocity_cmt__OneTimeCharge__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__Action__c, vlocity_cmt__ProvisioningStatus__c from OrderItem where OrderId =: testOrder.Id];
            
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();
            Map<Id, Map<String, Object>> testData = new Map<Id, Map<String, Object>>();
            
            for (SObject sObj : itemList)
            {
                Map<String, Object> infoMap = new Map<String, Object>();
                infoMap.put('ProductId', sObj.getSObject('PricebookEntry').getSObject('Product2').Id);
                infoMap.put('PricingVariableLog', new Map<String, Object>()); // we don't care about this in CopyBaseChargePricingPlanStepImpl
                
                Map<String, Object> pricingVariableCodeToValueMap = new Map<String, Object>();
                pricingVariableCodeToValueMap.put('REC_MNTH_STD_PRC', sObj.get('vlocity_cmt__RecurringCharge__c'));
                pricingVariableCodeToValueMap.put('OT_STD_PRC', sObj.get('vlocity_cmt__OneTimeCharge__c'));
                
                infoMap.put('PricingVariableValues', pricingVariableCodeToValueMap);
                testData.put(sObj.Id, infoMap);      
            }
                                    
            CopyBaseChargePricingPlanStepImpl pStep = new CopyBaseChargePricingPlanStepImpl();
            
            vlocity_cmt.PricingPlanService.putInPricingContext('TestLineItemPricingVariableValues', testData);
            
            pStep.invokeMethod('CopyBaseCharges', input, output, options);
            
            for (Map<String, Object> infoMap : testData.values())
            {
                Map<String, Object> pricingVariableCodeToValueMap = (Map<String, Object>)infoMap.get('PricingVariableValues');
                System.assertEquals(pricingVariableCodeToValueMap.get('REC_MNTH_STD_PRC'), pricingVariableCodeToValueMap.get('REC_MNTH_STD_BS_PRC'));
                System.assertEquals(pricingVariableCodeToValueMap.get('OT_STD_PRC'), pricingVariableCodeToValueMap.get('OT_STD_BS_PRC'));
            }
            
            Test.stopTest();
            
        }
        catch(Exception e)
        {
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception stack trace: ' + e.getStackTraceString());
            throw e;
        }
    }    
}
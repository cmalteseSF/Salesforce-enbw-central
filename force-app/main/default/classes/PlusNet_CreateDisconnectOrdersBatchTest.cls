@isTest
public class PlusNet_CreateDisconnectOrdersBatchTest {

    
    @isTest
    public static void orderBatchTest() {
        Map<String,Object> input = new Map<String,Object>();
        List<Object> lstObjects = new List<Object>();
        Account objAcc = new Account(BillingStreet = 'Lower Saxony', BillingCity = 'Lower Saxony', BillingState = 'Lower Saxony', BillingCountry = 'Germany', BillingPostalCode = '30169'); 
        objAcc.Name = 'Test Account';
        insert objAcc;
        input.put('AccountId',objAcc.Id);
        lstObjects.add(objAcc.Id); 
        
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description='Test Product Entry For Product';
        p.productCode = '123';
        p.isActive = true;
        insert p;
        
        List<Asset> lstAsset = new List<Asset>();
        Asset objAsset = new Asset();
        objAsset.Name = 'Test Asset';
        objAsset.AccountId = objAcc.Id;
        objAsset.Product2Id = p.Id;
        objAsset.Status = 'Registered';
        objAsset.vlocity_cmt__AssetReferenceId__c='100999';
        insert objAsset;
        lstAsset.add(objAsset);
        
        Asset objAsset1 = new Asset();
        objAsset1.Name = 'Test Asset1';
        objAsset1.AccountId = objAcc.Id;
        objAsset1.Product2Id = p.Id;
        objAsset1.Status = 'Registered';
        objAsset1.vlocity_cmt__AssetReferenceId__c='110999';
        insert objAsset1;
        lstAsset.add(objAsset1);

        
        Contract cont = New Contract();
        cont.Name = 'Test Contract';
        cont.AccountId = objAcc.ID;
        //cont.Status = 'Activated';
        cont.StartDate = Date.today();
        insert cont;
        input.put('RequestDate',cont.StartDate);
        input.put('BatchSize','10');
        lstObjects.add(cont.StartDate);
        
        vlocity_cmt__ContractLineItem__c objContractLineItem = new vlocity_cmt__ContractLineItem__c();
        objContractLineItem.Name = 'test contract';
        objContractLineItem.vlocity_cmt__AssetReferenceId__c = objAsset.vlocity_cmt__AssetReferenceId__c;
        //objContractLineItem.vlocity_cmt__AssetId__c = objAsset.Id;
        objContractLineItem.vlocity_cmt__ContractId__c = cont.Id;
        insert objContractLineItem;
        
        vlocity_cmt__ContractLineItem__c objContractLineItem1 = new vlocity_cmt__ContractLineItem__c();
        objContractLineItem1.Name = 'test contract1';
        objContractLineItem1.vlocity_cmt__AssetReferenceId__c = objAsset.vlocity_cmt__AssetReferenceId__c;
        //objContractLineItem.vlocity_cmt__AssetId__c = objAsset.Id;
        objContractLineItem1.vlocity_cmt__ContractId__c = cont.Id;
        insert objContractLineItem1;
        
        String CLI = '[{"AssetId": objAsset.Id,"product_name": "Laptop","quantity": 5,"unit_price": 1000,"total_price": 5000},{"AssetId": objAsset.Id,"product_name": "Monitor","quantity": 3,"unit_price": 500,"total_price": 1500}]';

        //Map<Id,List<Object>> map1 = new Map<Id,List<Object>>();
        List<Object> objCLI = [select id,vlocity_cmt__AssetId__c from vlocity_cmt__ContractLineItem__c where ID =:objContractLineItem.Id OR ID=: objContractLineItem1.Id];
        input.put('CLI', objCLI);
        
        System.Test.startTest();
        PlusNet_CreateDisconnectOrdersBatch objBatch = new PlusNet_CreateDisconnectOrdersBatch(lstObjects, objAsset.vlocity_cmt__AssetReferenceId__c, input, true);
        objBatch.execute(null,lstAsset);
        ID batchID = DataBase.executeBatch(objBatch); 
        System.assertNotEquals(batchID, null);
       
        System.Test.stopTest();
    }
    
   
}
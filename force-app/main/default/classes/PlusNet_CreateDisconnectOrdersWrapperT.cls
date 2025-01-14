@isTest
private class PlusNet_CreateDisconnectOrdersWrapperT {

  @isTest static void invokeCreateDisconnectOrdersMethodTest()
  {
    Map<String,Object> input = new Map<String,Object>();
    Map<String,Object> output = new Map<String,Object>();
    Map<String, Object> item  = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object> {
      'CreateDisconnectOrders' => 'ThisWillNotDoAnything'
    };
    String methodName = 'CreateDisconnectOrders';

    Type classType = Type.forName('PlusNet_CreateDisconnectOrdersWrapper');
    vlocity_cmt.VlocityOpenInterface2 classInstance = (vlocity_cmt.VlocityOpenInterface2) classType.newInstance();
    

    
    Account objAcc = new Account(BillingStreet = 'Lower Saxony', BillingCity = 'Lower Saxony', BillingState = 'Lower Saxony', BillingCountry = 'Germany', BillingPostalCode = '30169'); 
        objAcc.Name = 'Test Account';
        insert objAcc;
        input.put('AccountId',objAcc.Id);
        
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description='Test Product Entry For Product';
        p.productCode = '123';
        p.isActive = true;
        insert p;
        
        Asset objAsset = new Asset();
        objAsset.Name = 'Test Asset';
        objAsset.AccountId = objAcc.Id;
        objAsset.Product2Id = p.Id;
        objAsset.Status = 'Registered';
        objAsset.vlocity_cmt__AssetReferenceId__c='100999';
        insert objAsset;
        
        Contract cont = New Contract();
        cont.Name = 'Test Contract';
        cont.AccountId = objAcc.ID;
        //cont.Status = 'Activated';
        cont.StartDate = Date.today();
        insert cont;
        input.put('RequestDate',cont.StartDate);
        input.put('BatchSize','10');
        
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
       /* for(Object obj : objCLI){
            if(map1.containsKey(obj.id)){
                map1.put('AssestId',new Object[]{obj});
            }else{
                map1.get(obj.vlocity_cmt__AssetId__c).add(obj);
            }

        }*/

        input.put('CLI', objCLI);

    Object result1 = classInstance.invokeMethod(methodName, input, output, options);
  }

 
 
}
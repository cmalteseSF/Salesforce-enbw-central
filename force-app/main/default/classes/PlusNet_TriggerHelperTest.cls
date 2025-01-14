@isTest
public class PlusNet_TriggerHelperTest {

     @testSetup 
    static void testdatasetup() {
        Profile pf = [Select Id from profile where Name = 'System Administrator'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer RandomId = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + RandomId;

        User usr = new User(firstname = 'PLusNet',
            lastName = 'Test Helper',
            email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'Europe/Berlin',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = pf.Id);

        insert(usr);
        
        /*Default_Case_Owner__c defCaseowner= new Default_Case_Owner__c();
        defCaseowner.ID_Val__c=usr.Id;
        insert defCaseowner;*/
    }
    
    @isTest
    public static void updateContratLineItemAssetIdTest(){
        Account objAcc = new Account(BillingStreet = 'Lower Saxony', BillingCity = 'Lower Saxony', BillingState = 'Lower Saxony', BillingCountry = 'Germany', BillingPostalCode = '30169'); 
        objAcc.Name = 'Test Account';
        insert objAcc;
        
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
        
        vlocity_cmt__ContractLineItem__c objContractLineItem = new vlocity_cmt__ContractLineItem__c();
        objContractLineItem.Name = 'test contract';
        objContractLineItem.vlocity_cmt__AssetReferenceId__c = objAsset.vlocity_cmt__AssetReferenceId__c;
        //objContractLineItem.vlocity_cmt__AssetId__c = objAsset.Id;
        objContractLineItem.vlocity_cmt__ContractId__c = cont.Id;
        insert objContractLineItem;
        
        Test.startTest();
        PlusNet_TriggerHelper.updateContratLineItemAssetId(new List<Asset> {objAsset});
        vlocity_cmt__ContractLineItem__c objCLI = [select id,vlocity_cmt__AssetId__c from vlocity_cmt__ContractLineItem__c where ID=:objContractLineItem.Id];
        System.assertEquals(objCLI.vlocity_cmt__AssetId__c, objAsset.Id);
        Test.stopTest();
        
    }
    
    @isTest
    public static void updateQuoteContractIdTest(){
        Account objAcc = new Account(BillingStreet = 'Lower Saxony', BillingCity = 'Lower Saxony', BillingState = 'Lower Saxony', BillingCountry = 'Germany', BillingPostalCode = '30169'); 
        objAcc.Name = 'Test Account';
        insert objAcc;
        
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
        
        PriceBookEntry objPBE = new PriceBookEntry(UnitPrice = 300, PriceBook2Id = Test.getStandardPricebookId(),
                                                        Product2Id = p.Id, IsActive = true);
                                                               
        
        insert objPBE;
        
        Opportunity objOpp = new Opportunity(Name = 'Test Opp', AccountId = objAcc.Id, StageName = 'Proposal', CloseDate = Date.today()+1);
        insert objOpp;
        
        Quote objQuote = new Quote();
        objQuote.OpportunityId = objOpp.Id;
        objQuote.Name = 'Test Quote';
        objQuote.Pricebook2Id = Test.getStandardPricebookId();
        objQuote.Status = 'Review Pending';
        insert objQuote;
        
        Contract cont = New Contract();
        cont.Name = 'Test Contract';
        cont.AccountId = objAcc.ID;
        //cont.Status = 'Activated';
        cont.vlocity_cmt__QuoteId__c = objQuote.Id;
        cont.StartDate = Date.today();
        insert cont;
        
        Test.startTest();
        PlusNet_TriggerHelper.updateQuoteContractId(new List<Contract> {cont});
        Quote qt = [select id,ContractId from Quote where id=:objQuote.Id];
        System.assertEquals(qt.ContractId,cont.Id );
        Test.stopTest();
    }
}
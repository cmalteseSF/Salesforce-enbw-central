/*******************************************************************
* Class Name                    :   XOMAutoTask_InvokeIntegrationProcedure_T
* Usage                         :   Tests XOMAutoTask_InvokeIntegrationProcedure Apex Class
* Author                        :   
* Last Modified By              :   
* Version                       :   1.0
* Methods                       :   setup(), testExecuteBatch1(), testExecuteBatch2()
* 
*******************************************************************/

@isTest
private class XOMAutoTask_InvokeIntegrationProcedure_T {
    
    @testSetup
    static void setup(){
        
        //Create Standard Test Account
        Account acct = new Account(
            Name = 'Test Account'
        );
        acct.BillingStreet = 'gjhj';
        acct.BillingCity = 'gjhj';
        acct.BillingCountry = 'gjhj';
        acct.BillingPostalCode = 'gjhj';
        acct.BillingState = 'gjhj';
        insert acct;
        
        //Create Test Order
        Order ord = new Order(
            AccountId = acct.Id, //link to above account
            EffectiveDate = date.today(),
            Status = 'Draft'
        );
        insert ord;
        
        //Create Orchestration Plan
        vlocity_cmt__OrchestrationPlan__c op = New vlocity_cmt__OrchestrationPlan__c(
            vlocity_cmt__OrderId__c = ord.Id //link to above order
        );
        insert op;
        
        //Create Orchestration Item
        vlocity_cmt__OrchestrationItem__c oi = New vlocity_cmt__OrchestrationItem__c(
            vlocity_cmt__OrchestrationPlanId__c = op.Id, //link to above orchestration plan
            vlocity_cmt__AutoTaskParameters__c = '{\"procedureName\":\"OM_OrderStatusUpdate\"}'
        );
        insert oi;
    }
    
    static testMethod void testExecuteBatch1(){
        List <vlocity_cmt__OrchestrationItem__c> items = [
            SELECT 
            Id,
            vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__c,
            vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.AccountId,
            vlocity_cmt__AutoTaskParameters__c
            FROM 
            vlocity_cmt__OrchestrationItem__c];
        
        XOMAutoTask_InvokeIntegrationProcedure xom = new XOMAutoTask_InvokeIntegrationProcedure();
        xom.executeBatch(items);
        Order ord = [SELECT Id,Status FROM Order];    
        System.assertEquals('Draft', ord.Status);
    }
    
    static testMethod void testExecuteBatch2(){
        
        //Get Orchestration Item
        vlocity_cmt__OrchestrationItem__c oi = [SELECT Id,vlocity_cmt__OrchestrationPlanId__c, vlocity_cmt__AutoTaskParameters__c 
                                                FROM vlocity_cmt__OrchestrationItem__c];
        //Modify the autotask parameters
        oi.vlocity_cmt__AutoTaskParameters__c = '{}';
        
        //Save the modifications
        update oi;
        
        List <vlocity_cmt__OrchestrationItem__c> items = [
            SELECT 
            Id,
            vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__c,
            vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.AccountId,
            vlocity_cmt__AutoTaskParameters__c
            FROM 
            vlocity_cmt__OrchestrationItem__c];
        
        //Attempt to run same test as above
        try{
            XOMAutoTask_InvokeIntegrationProcedure xom = new XOMAutoTask_InvokeIntegrationProcedure();
            xom.executeBatch(items);  
        }
        catch (Exception e){
            System.Assert(e.getMessage().contains('Verify that the Auto Task Parameters field is properly populated'));
        }
    }
}
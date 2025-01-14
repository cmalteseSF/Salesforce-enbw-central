/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 11-27-2023
 * @last modified by  : Sudhir Kumar Thanna
**/
public with sharing class OrderController {
    //Order Controller Class
    @AuraEnabled
    public static List<OrderItem> getOrderItems(String orderId)
    {
        List<OrderItem> orderItemIds =  [SELECT Id,Product2.Name,Product2.ProductCode, vlocity_cmt__AttributeSelectedValues__c,PortingDate__c, LegacyContractId__c FROM OrderItem WHERE OrderId  =:orderId AND Product2.ProductCode = 'PNET-IPF-ACC'];
        System.debug('Order - orderitems..' + orderItemIds);
        return orderItemIds;
    }

    @AuraEnabled
    public static List<vlocity_cmt__PicklistValue__c> getCarrierNames()
    {
        List<vlocity_cmt__PicklistValue__c> entry  =  [SELECT Id, Name, vlocity_cmt__Value__c FROM vlocity_cmt__PicklistValue__c WHERE vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c = 'PNET-PKL-CRR-NAM'];
        System.debug(' entry..' + entry);
        return entry;
    }
}
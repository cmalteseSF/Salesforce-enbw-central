/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 10-26-2023
 * @last modified by  : Sudhir Kumar Thanna
**/
public with sharing class QuoteController {
    //Quote Controller Class
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItems(String quoteId,String productCode)
    {
        //List<QuoteLineItem> qlis =  [SELECT Id,Product2Id,Product2.Name, vlocity_cmt__AttributeSelectedValues__c  FROM QuoteLineItem WHERE QuoteId  =:quoteId];
        List<QuoteLineItem> qlis =  [SELECT Id,Product2.Name,Product2.ProductCode, vlocity_cmt__AttributeSelectedValues__c,VoiceSubscriber__c FROM QuoteLineItem WHERE QuoteId  =:quoteId AND Product2.ProductCode =:productCode];
        System.debug('Quote - qlis..' + qlis);
        return qlis;
    }

    @AuraEnabled
    public static List<Quote> getQuoteDetails(String quoteId)
    {
        List<Quote> quoteObj =  [SELECT Id,Status FROM Quote WHERE Id  =:quoteId ];
        System.debug('Quote - quoteObj..' + quoteObj);
        return quoteObj;
    }

}
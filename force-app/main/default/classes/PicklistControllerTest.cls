/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 02-20-2024
 * @last modified by  : Sudhir Kumar Thanna
**/
@isTest
public with sharing class PicklistControllerTest {

    static void setupTestData() {
       
        // Create test data

        vlocity_cmt__Picklist__c picklist = new vlocity_cmt__Picklist__c();
        picklist.Name = 'test Carrier Name';
        picklist.vlocity_cmt__Code__c = 'PNET-PKL-CRR-NAM';
        insert picklist;


        vlocity_cmt__PicklistValue__c picklistVal = new vlocity_cmt__PicklistValue__c();
        picklistVal.Name = 'Avaya';
        picklistVal.vlocity_cmt__PicklistId__c = picklist.Id;
        picklistVal.vlocity_cmt__Code__c = 'PNET-PKL-CRR-NAM';
        insert picklistVal;

    }


    @isTest
    static void testPopulateCarriersPicklist() {

        setupTestData();

        String methodName = 'populateCarriersPicklist';

        // Set up the input and output maps
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();

        // Call the method to test
        PicklistController handler = new PicklistController();
        handler.invokeMethod(methodName,input, output, new Map<String, Object>());

    }

    
}
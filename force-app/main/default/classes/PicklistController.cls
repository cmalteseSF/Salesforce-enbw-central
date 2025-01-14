/**
 * @description       : 
 * @author            : Sudhir Kumar Thanna
 * @group             : 
 * @last modified on  : 02-16-2024
 * @last modified by  : Sudhir Kumar Thanna
**/
global class PicklistController implements vlocity_cmt.VlocityOpenInterface {

    public Boolean invokeMethod(String methodName, Map < String, Object > input, Map < String, Object > outMap, Map < String, Object > options) {
       /*  if (methodName.equals('PopulateDependentPicklist')) {
            System.debug('In PopulateDependentPicklist');
            //populateDependentPicklist(input, outMap, options);
        }
        else if (methodName.equals('PopulatePicklist')) {
            System.debug('In PopulatePicklist');
            //populatePicklist(input, outMap, options);
        }
        else  */
        if (methodName.equalsIgnoreCase('populateCarriersPicklist')) {
            System.debug('In populateCarriersPicklist');
            populateCarriersPicklist(input, outMap, options);
        }
        return true;
    }
    
    public void populateCarriersPicklist(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {       
        List<Map<String,String>> picklist = new List<Map<String, String>>();
        Map<String, String> picklistOption = new Map<String, String>();
        
        for(vlocity_cmt__PicklistValue__c entry :  [SELECT Id, Name, vlocity_cmt__Value__c FROM vlocity_cmt__PicklistValue__c WHERE vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c = 'PNET-PKL-CRR-NAM'])
        {
            picklistOption = new Map<String, String>();
            picklistOption.put('name', entry.Name);
            picklistOption.put('value', entry.vlocity_cmt__Value__c);
            picklist.add(picklistOption);
        }
        outMap.put('options', picklist);
    }
    
    // add the map under options to populate the picklist
    /* public void populatePicklist(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        // hard coded list, these options could be results from a remote call/3rd party api
        List<Map<String,String>> picklist = new List<Map<String, String>>();

        Map<String, String> picklistOption = new Map<String, String>();
        List<PicklistEntry> entries = getGlobalSetGermanCountryValues();
       
        for(PicklistEntry entry :  entries ){
            System.debug('Entries Label...' + entry.getLabel());
            System.debug('Entries Values...' + entry.getValue());
            picklistOption = new Map<String, String>();
            picklistOption.put('name', entry.getLabel());
            picklistOption.put('value', entry.getValue());
            picklist.add(picklistOption);
            System.debug('picklist Value is...' + picklist);
        }
        //picklist.add(picklistOption);
        //picklistOption.put('name', 'Licensing & Permitting');
        //picklistOption.put('value','Licensing & Permitting');
        //picklist.add(picklistOption);
            
        //picklistOption = new Map<String, String>();
        //picklistOption.put('name', 'Contract');
        //picklistOption.put('value','Contract');
        
        System.debug('final country picklist ... ' + picklist);
        outMap.put('options', picklist);
    }
    
    // add the map of all possible picklists that will be chosen given the "controllingElement"
    // note that the "controllingElement" is an element name that gets passed in from omniscript
    public void populateDependentPicklist(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        // Map of List where the Key is the Potential Values in the Other Picklist
        Map<String, List<Map<String, String>>> dependency = new Map<String, List<Map<String, String>>>();
        //List<Map<String,String>> picklist = new List<Map<String, String>>();
                
        List<String> controlValList = new List<String>();

        List<PicklistEntry> entries = getGlobalSetGermanCountryValues();
        List<PicklistEntry> entriesState = getGlobalSetGermanStateValues();

        for(PicklistEntry entry :  entries){
            //if(entry.getLabel() == 'Deutschland'){
                controlValList.add(entry.getLabel());
            //}
        }
        // note that these are listed (above)
        //controlValList.add('Licensing & Permitting');
        //controlValList.add('Contract');

        // generating arbitrary entries for each of the above keys
        for(Integer i=0; i<controlValList.size(); i++)
        {
            List<Map<String, String>> optionList = new List<Map<String, String>>();
            for(Integer j=0; j<1; j++) {
                if(controlValList[i] == 'Deutschland'){
                    for(PicklistEntry entry :  entriesState){
                        Map<String, String> tempMap = new Map<String, String>();
                        tempMap.put('name', entry.getLabel()); 
                        tempMap.put('value', entry.getLabel());
                        optionList.add(tempMap); 
                      
                    }
                }
                else{
                    Map<String, String> tempMap = new Map<String, String>();
                    tempMap.put('name', 'None'); 
                    tempMap.put('value', 'None');
                    optionList.add(tempMap);
                }  
                System.debug('optionList...' +  optionList);
                System.debug('controlValList[i]...' +  controlValList[i]);
            }
            dependency.put(controlValList[i], optionList);
            System.debug('dependency...' +  dependency);
        }
        System.debug('Final dependency...' +  dependency);
        outMap.put('dependency',dependency);
   }
    
    public static List<PicklistEntry> getGlobalSetGermanStateValues(){
        Schema.DescribeFieldResult describeObj = Lead.ServiceState__c.getDescribe();
        Schema.sObjectField describeObjFields = describeObj.getSObjectField();
        List<PicklistEntry> entries = describeObjFields.getDescribe().getPicklistValues();
        System.debug('Entries...' + entries);
      
        return entries;
    }

    public static List<PicklistEntry> getGlobalSetGermanCountryValues(){
        Schema.DescribeFieldResult describeObj = Lead.ServiceCountry__c.getDescribe();
        Schema.sObjectField describeObjFields = describeObj.getSObjectField();
        List<PicklistEntry> entries = describeObjFields.getDescribe().getPicklistValues();
        System.debug('In getGlobalSetGermanCountryValues .. Entries...' + entries);
        Map<String, String> picklistGermanCountryOptions = new Map<String, String>();
      
        return entries;
    } */

}
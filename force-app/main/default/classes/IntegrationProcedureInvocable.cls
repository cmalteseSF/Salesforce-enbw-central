global with sharing class IntegrationProcedureInvocable {
  @InvocableMethod(label = 'Integration Procedure')
  global static List < IntegrationProcedureOutput > runIntegrationServiceInvocable(List < IntegrationProcedureInput > input) {
   
   System.debug(LoggingLevel.Error, JSON.serialize(input));
 
   IntegrationProcedureOutput result = new IntegrationProcedureOutput();
   
   if(input[0].procedureAPIName.equalsIgnoreCase('PlusNet_OrderResponseHandler'))
   {
       result.output = JSON.serialize(
        vlocity_cmt.IntegrationProcedureService.runIntegrationService(
         input[0].procedureAPIName,
         new Map < String, Object >
             {
              'Id' => JSON.deserializeUntyped(input[0].input.deleteWhitespace())
             },
         new Map < String, Object > ()));
   }
   else{
       result.output = JSON.serialize(
            vlocity_cmt.IntegrationProcedureService.runIntegrationService(
             input[0].procedureAPIName,
             new Map < String, Object >
                 {
                  'Id' => input[0].input
                 },
             new Map < String, Object > ()));
   }
  
   System.debug(LoggingLevel.Error, JSON.serialize(result));
   return new List < IntegrationProcedureOutput >
    {
     result
    };
  }
  global class IntegrationProcedureInput
  {
   @InvocableVariable(label = 'Procedure Name') global String procedureAPIName;
   @InvocableVariable(label = 'Input') global String input;
  }
  global class IntegrationProcedureOutput
  {
   @InvocableVariable(label = 'Output') global String output;
  }
 }
@isTest
public class IntegrationProcedureInvocableTest {
    static testMethod void passIPNameParams() {
        IntegrationProcedureInvocable.IntegrationProcedureInput firstInput1 = new IntegrationProcedureInvocable.IntegrationProcedureInput();
        firstInput1.procedureAPIName = 'PlusNet/SubmitOrder';
        firstInput1.input = '1234';
        //firstInput1.input1='test';
         Boolean iAmFalse = !true;
        //firstInput1.isFuture=true;
        //firstInput1.isQueueable=false;
        
        
        List<IntegrationProcedureInvocable.IntegrationProcedureOutput> firstOutList1 = new List<IntegrationProcedureInvocable.IntegrationProcedureOutput>();
        
        List<IntegrationProcedureInvocable.IntegrationProcedureInput> listOfInputClass1 = new List<IntegrationProcedureInvocable.IntegrationProcedureInput>();
        listOfInputClass1.add(firstInput1);
        
        
        firstOutList1 = IntegrationProcedureInvocable.runIntegrationServiceInvocable(listOfInputClass1);
    }
     static testMethod void passIPNameParams1() {
        IntegrationProcedureInvocable.IntegrationProcedureInput firstInput2 = new IntegrationProcedureInvocable.IntegrationProcedureInput();
        firstInput2.procedureAPIName = 'PlusNet/SubmitOrder';
        firstInput2.input = '1234';
        //firstInput2.input1='test';
         Boolean iAmFalse = !true;
        //firstInput2.isFuture=false;
      //  firstInput2.isQueueable=true;
        
        
        List<IntegrationProcedureInvocable.IntegrationProcedureOutput> firstOutList2 = new List<IntegrationProcedureInvocable.IntegrationProcedureOutput>();
        
        List<IntegrationProcedureInvocable.IntegrationProcedureInput> listOfInputClass2 = new List<IntegrationProcedureInvocable.IntegrationProcedureInput>();
        listOfInputClass2.add(firstInput2);
        
        
        firstOutList2 = IntegrationProcedureInvocable.runIntegrationServiceInvocable(listOfInputClass2);
    }
     static testMethod void passIPNameParams2() {
        IntegrationProcedureInvocable.IntegrationProcedureInput firstInput3 = new IntegrationProcedureInvocable.IntegrationProcedureInput();
        firstInput3.procedureAPIName = 'PlusNet/SubmitOrder';
        firstInput3.input = '1234';
        //firstInput3.input1='test';
         Boolean iAmFalse = !true;
        //firstInput3.isFuture=false;
        //firstInput3.isQueueable=false;
        
        
        List<IntegrationProcedureInvocable.IntegrationProcedureOutput> firstOutList3 = new List<IntegrationProcedureInvocable.IntegrationProcedureOutput>();
        
        List<IntegrationProcedureInvocable.IntegrationProcedureInput> listOfInputClass3 = new List<IntegrationProcedureInvocable.IntegrationProcedureInput>();
        listOfInputClass3.add(firstInput3);
        
        
        firstOutList3 = IntegrationProcedureInvocable.runIntegrationServiceInvocable(listOfInputClass3);
    }
    static testMethod void passIPNameParams3() {
        IntegrationProcedureInvocable.IntegrationProcedureInput firstInput3 = new IntegrationProcedureInvocable.IntegrationProcedureInput();
        firstInput3.procedureAPIName = 'PlusNet_OrderResponseHandler';
        firstInput3.input = '1234';
        //firstInput3.input1='test';
         Boolean iAmFalse = !true;
        //firstInput3.isFuture=false;
        //firstInput3.isQueueable=false;
        
        
        List<IntegrationProcedureInvocable.IntegrationProcedureOutput> firstOutList3 = new List<IntegrationProcedureInvocable.IntegrationProcedureOutput>();
        
        List<IntegrationProcedureInvocable.IntegrationProcedureInput> listOfInputClass3 = new List<IntegrationProcedureInvocable.IntegrationProcedureInput>();
        listOfInputClass3.add(firstInput3);
        
        
        firstOutList3 = IntegrationProcedureInvocable.runIntegrationServiceInvocable(listOfInputClass3);
    }
}
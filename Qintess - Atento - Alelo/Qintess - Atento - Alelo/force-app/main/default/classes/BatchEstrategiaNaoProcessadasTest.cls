@isTest
public class BatchEstrategiaNaoProcessadasTest
{

    @isTest(SeeAllData=true)
    static void test_method_01() 
    {
        
        BatchEstrategiaNaoProcessadas batch = new BatchEstrategiaNaoProcessadas();

        Estrategia_Implantacao__c estrategia = DadosEstrategiaTest.criaEstrategiaAtiva();
    
        String estratJson = JSON.serialize(estrategia);
        AuxiliarUpdateEstrategiaImplantacao.updateEstrategiaImplant(estratJson);
    
        Test.startTest();

        Database.executeBatch(batch,1); 

        Test.stopTest();

    }
}
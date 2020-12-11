@isTest
public class BatchEstrategiaExcluirFilasTest
{

    @isTest(SeeAllData=true)
    static void test_method_01() 
    {
        
        Estrategia_Implantacao__c estrategia = DadosEstrategiaTest.criaEstrategiaVencida();
        estrategia.Processado__c = true;
        estrategia.Ativado__c = false;
        estrategia.Data_Inicio_Vigencia__c = System.today().addDays(-90);
        estrategia.Data_Fim_Vigencia__c = System.today().addDays(-60);
        update estrategia;
        
        Test.startTest();

        System.debug('estrategia: '+estrategia);
    
        BatchEstrategiaExcluirFilas batch = new BatchEstrategiaExcluirFilas();
        Database.executeBatch(batch,1); 
        
        Test.stopTest();
        
    }

}
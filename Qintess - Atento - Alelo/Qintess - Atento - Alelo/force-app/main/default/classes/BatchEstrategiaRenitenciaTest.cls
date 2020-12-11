@isTest
public class BatchEstrategiaRenitenciaTest 
{
    
    @isTest(SeeAllData=true)
    static void test_method_01() 
    {
        Estrategia_Implantacao__c estrategia = DadosEstrategiaTest.criaEstrategiaAtiva();
        estrategia.Renitencia__c = true;
        estrategia.Data_Inicio_Vigencia__c = system.today().addDays(+1);
        insert estrategia;
        
        List<Opportunity> lstOpp = [Select Id, Name from Opportunity where StageName = 'Em Implantação' AND Id IN
                                   (Select Oportunidade__c from Produtos_Alelo__c) LIMIT 100];
        List<Opportunity> lstOppUpd = new List<Opportunity>();
        for (Opportunity opp :lstOpp)
        {
            opp.Estrategia_Implantacao__c = estrategia.Id;
            lstOppUpd.add(opp);
        }
        Database.SaveResult[] lstSrOpp = Database.update(lstOppUpd, false);
        String idOppSuccess = '';
        for (Database.SaveResult srOpp :lstSrOpp)
        {
            if (srOpp.isSuccess())
            {
                idOppSuccess = srOpp.getId();
                break;
            }
        }

        Test.startTest();
         
        BatchEstrategiaRenitencia batch = new BatchEstrategiaRenitencia();
        Database.executeBatch(batch,1); 
        
        Test.stopTest();
        
    }
}
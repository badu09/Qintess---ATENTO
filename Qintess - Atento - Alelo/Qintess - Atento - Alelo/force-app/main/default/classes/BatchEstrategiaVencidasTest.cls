@isTest
public class BatchEstrategiaVencidasTest
{

    @isTest(SeeAllData=true)
    static void test_method_01() 
    {
        
        Estrategia_Implantacao__c estrategia = DadosEstrategiaTest.criaEstrategiaVencida();
        estrategia.Processado__c = true;
        estrategia.Ativado__c = false;
        estrategia.Data_Inicio_Vigencia__c = System.today().addDays(-1);
        estrategia.Data_Fim_Vigencia__c = System.today().addDays(1);
        update estrategia;
        
        List<Opportunity> lstOpp = [SELECT Id, Name from Opportunity Where Propriet_rio_Processo_de_Implantacao__c <> '' ORDER BY CreatedDate DESC LIMIT 10];
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
        
        List<Order> lstOrder = [SELECT Id, OrderNumber from Order ORDER BY CreatedDate DESC LIMIT 10];
        List<Order> lstOrderUpd = new List<Order>();
        for (Order order :lstOrder)
        {
            order.OpportunityId = idOppSuccess;
            order.OwnerId = estrategia.Fila_Nova__c;
            lstOrderUpd.add(order);
        }
        Database.SaveResult[] lstSrOrder = Database.update(lstOrderUpd, false);
        String idOrderSuccess = '';
        for (Database.SaveResult srOrder :lstSrOrder)
        {
            if (srOrder.isSuccess())
            {
                idOrderSuccess = srOrder.getId();
                break;
            }
        }
        
        Opportunity oppUpd = new Opportunity();
        oppUpd.Id = idOppSuccess;
        oppUpd.Processo_Implantacao__c = idOrderSuccess;
        update oppUpd;
        
        Test.startTest();

        System.debug('Oportunidade: '+oppUpd);
        System.debug('estrategia: '+estrategia);
    
        BatchEstrategiaVencidas batch = new BatchEstrategiaVencidas();
        Database.executeBatch(batch,1); 
        
        Test.stopTest();
        
    }

}
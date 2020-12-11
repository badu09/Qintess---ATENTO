@IsTest
public class BatchCorrecaoFilaRoteamentoTest {

	static testMethod void Test_Method01() {

        List<Group> fila = [SELECT Id, Name, DeveloperName FROM Group where DeveloperName  = 'Implantacao_Aguardando_Agendamento'];
                
        Opportunity oportunidade = TestData.getOpportunity();
        oportunidade.Agendamento_Retorno_Implanta_o__c = System.now().addDays(-1);
        update oportunidade;
        
        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = oportunidade.id;
        produto.Numero_do_Contrato__c = '123';
        insert produto;
        
        Order pedido = new Order();
        pedido.OpportunityId = oportunidade.Id;
        pedido.AccountId = oportunidade.AccountId;
        pedido.EffectiveDate = System.today();
        pedido.Status = 'Disponivel';
        pedido.OwnerId = fila[0].Id;
        insert pedido;
        
        System.debug('Pedido: '+pedido);

        Test.startTest();
         
        BatchCorrecaoFilaRoteamento batch = new BatchCorrecaoFilaRoteamento();
        Database.executeBatch(batch,1); 
        
        Test.stopTest();
        
    }
    
}
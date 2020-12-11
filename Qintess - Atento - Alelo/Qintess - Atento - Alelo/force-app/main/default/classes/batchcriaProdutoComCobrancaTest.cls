@isTest
public class batchcriaProdutoComCobrancaTest {
    
    static testMethod void Test_Method01() {
                
        Opportunity oportunidade = TestData.getOpportunity();
        oportunidade.Agendamento_Retorno_Implanta_o__c = System.now().addDays(-1);
        
        update oportunidade;
        
        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = oportunidade.id;
        produto.Numero_do_Contrato__c = '123';
        produto.Tem_Cobranca__c = false;
        produto.Tabulacao_Pai_Implantacao__c = 'IMPLANTADO';
        produto.Tabulacao_Filho_Implantacao__c = 'AGUARDANDO FATURAMENTO';
        produto.Valor_Implantado__c = 1500.00;
        
        
        List<Produtos_Alelo__c> lstProduto = new List<Produtos_Alelo__c>();
        lstProduto.add(produto);
        
        Test.startTest();
        
        insert lstProduto;
        
        batchcriaProdutoComCobranca bt = new batchcriaProdutoComCobranca();
        Database.executeBatch(bt,1); 
        
        Test.stopTest();  
        
    }
}
@IsTest
public class ReverterImplantacaoTest 
{

	static testMethod void Test_Method01() 
    {
        Opportunity oportunidade = TestData.getOpportunity();
        oportunidade.Agendamento_Retorno_Implanta_o__c = System.now().addDays(-1);
        update oportunidade;
        
        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = oportunidade.id;
        produto.Numero_do_Contrato__c = '123';
        insert produto;
        
        List<Id> lId = new List<Id>();
        lId.add(produto.Id);
        
        ReverterImplantacao.reverterImplantacao(lId);
    }  
    
	static testMethod void Test_Method02() 
    {
        Opportunity oportunidade = TestData.getOpportunity();
        oportunidade.Agendamento_Retorno_Implanta_o__c = System.now().addDays(-1);
        update oportunidade;
        
        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = oportunidade.id;
        produto.Numero_do_Contrato__c = '123';
        insert produto;
        
        List<Id> lId = new List<Id>();
        lId.add(produto.Id);
        
        ReverterImplantacaoProcCadastral.reverterImplantacao(lId);
    }  
}
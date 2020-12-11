//Classe de teste para as triggers ProdutosAlelo_Before e ProdutosAlelo_After
@IsTest
public class ProdutosAleloTest 
{

	static testMethod void Test_Method01() 
    {
        Estrategia_Implantacao__c estrat = new Estrategia_Implantacao__c();
        estrat.Data_Fim_Vigencia__c = System.today().addDays(2);
        estrat.Data_Inicio_Vigencia__c = System.today().addDays(1);
        estrat.Implantacao_Fidelizada__c = 'Vigente Com Fidelização';
        estrat.Id_Relatorio_Estrategia__c = '123';
        estrat.Quantidade_Maxima_Tentativas__c = 1;
        insert estrat;
        
        Account conta = new Account();
        conta.CPF_CNPJ__c = '33052107704';
        conta.Name = 'Nome Teste';
        insert conta;

        Opportunity oportunidade = TestData.getOpportunity();
        
        oportunidade.StageName = 'Auditoria Finalizada/ Transf Implantação';
        oportunidade.Data_da_Auditoria__c = System.today();
        update oportunidade;
        
        oportunidade.Estrategia_Implantacao__c = estrat.Id;
        update oportunidade;
        
        System.debug('opp.Processo_Implantacao__c: '+oportunidade.Processo_Implantacao__c);
        
        Test.startTest();

        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = oportunidade.id;
        produto.Numero_do_Contrato__c = '123';
        produto.E_mail_do_Interlocutor__c = 'email@email.com';
        insert produto;

        produto.Data_Hora_Tabulacao__c = System.now().addMinutes(-1);
        produto.Nome_do_Implantador__c = UserInfo.getName();
        produto.Tabulacao_Pai_Implantacao__c = 'NÃO CONSEGUE CONTATO';
        produto.Tabulacao_Filho_Implantacao__c = 'TELEFONE ERRADO';
        update produto;
        
        produto.Data_Hora_Tabulacao__c = System.now();
        produto.Nome_do_Implantador__c = UserInfo.getName();
        produto.Tabulacao_Pai_Implantacao__c = 'NÃO CONSEGUE CONTATO';
        produto.Tabulacao_Filho_Implantacao__c = 'TELEFONE OCUPADO OU NÃO ATENDE';
        update produto;
        
        Test.stopTest();
        
    }
    
	static testMethod void Test_Method02() 
    {
        Estrategia_Implantacao__c estrat = new Estrategia_Implantacao__c();
        estrat.Data_Fim_Vigencia__c = System.today().addDays(2);
        estrat.Data_Inicio_Vigencia__c = System.today().addDays(1);
        estrat.Implantacao_Fidelizada__c = 'Vigente Com Fidelização';
        estrat.Id_Relatorio_Estrategia__c = '123';
        estrat.Quantidade_Maxima_Tentativas__c = 10;
        insert estrat;
        
        Account conta = new Account();
        conta.CPF_CNPJ__c = '33052107704';
        conta.Name = 'Nome Teste';
        insert conta;

        Opportunity oportunidade = TestData.getOpportunity();
        
        oportunidade.StageName = 'Auditoria Finalizada/ Transf Implantação';
        oportunidade.Data_da_Auditoria__c = System.today();
        update oportunidade;
        
        oportunidade.Estrategia_Implantacao__c = estrat.Id;
        update oportunidade;
        
        System.debug('opp.Processo_Implantacao__c: '+oportunidade.Processo_Implantacao__c);
        
        Test.startTest();

        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = oportunidade.id;
        produto.Numero_do_Contrato__c = '123';
        produto.E_mail_do_Interlocutor__c = 'email@email.com';
        insert produto;

        produto.Data_Hora_Tabulacao__c = System.now().addMinutes(-2);
        produto.Nome_do_Implantador__c = UserInfo.getName();
        produto.Tabulacao_Pai_Implantacao__c = 'NÃO CONSEGUE CONTATO';
        produto.Tabulacao_Filho_Implantacao__c = 'TELEFONE OCUPADO OU NÃO ATENDE';
        update produto;
        
        produto.Data_Hora_Tabulacao__c = System.now().addMinutes(-1);
        produto.Nome_do_Implantador__c = UserInfo.getName();
        produto.Tabulacao_Pai_Implantacao__c = 'NÃO CONSEGUE CONTATO';
        produto.Tabulacao_Filho_Implantacao__c = 'TELEFONE OCUPADO OU NÃO ATENDE';
        update produto;
        
        produto.Data_Hora_Tabulacao__c = System.now();
        produto.Nome_do_Implantador__c = UserInfo.getName();
        produto.Tabulacao_Pai_Implantacao__c = 'NÃO CONSEGUE CONTATO';
        produto.Tabulacao_Filho_Implantacao__c = 'TELEFONE OCUPADO OU NÃO ATENDE';
        update produto;
        
        Test.stopTest();
        
    }

}
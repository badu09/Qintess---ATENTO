@isTest
public class RoteamentoArmazenaCodProdutoAleloTest {
	@isTest public static void novaOportunidade(){
		//Criando a conta
		Account novaConta = new Account(Name = 'Juliana', CPF_CNPJ__c = '63518800094');
		Database.insert(novaConta);
		novaConta = [SELECT Id FROM Account where Name = 'Juliana' LIMIT 1];

		//Criando a oportunidade
		Opportunity novaOportunidade =
				New Opportunity(name = 'Nova oportunidade', StageName = 'A', AccountId = novaConta.Id,
						CloseDate = Date.today().addDays(1), campanha__c = '123');
		Database.insert(novaOportunidade);

		//Criando o produto alelo auto
		Produtos_Alelo__c novoProdutoAleloAuto =
				new Produtos_Alelo__c(Codigo_de_Produtos__c = '301', Oportunidade__c = novaOportunidade.Id);
		Database.insert(novoProdutoAleloAuto);

		//Criando o processo de roteamento
		Order novoProcessoRoteamento =
				New Order(OpportunityId = novaOportunidade.Id, Account = novaConta, AccountId = novaConta.Id, EffectiveDate = Date.today(), Status = 'Vendas');
		Database.upsert(novoProcessoRoteamento);

		//capturando dados atualizados do processo de roteamento criado
		novoProcessoRoteamento = [select Id, Codigo_do_Produto_1__c, Codigo_do_Produto_2__c from Order WHERE AccountId = :novaConta.Id limit 1];

		//capturando dados atualizados da oportunidade criada
		novaOportunidade = [SELECT Id, Codigo_Alelo_Auto__c FROM Opportunity Where StageName = 'A' AND AccountId = :novaConta.Id LIMIT 1];

//		System.assertEquals(301, novoProcessoRoteamento.Codigo_do_Produto_1__c);
//		System.assertEquals(301, novaOportunidade.Codigo_Alelo_Auto__c);
	}

}
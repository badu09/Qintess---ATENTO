// Created by Juliana Neres on 14/01/2020.
// Arquivo de teste paras as classes BatchArmazenaCodProdutoAlelo, BatchRemoveCodProdutoAlelo
// e para a trigger ArmazenaCodProdutoAlelo <-  trigger que faz a chamada das batches

@isTest
	public class ArmazenaCodProdutoAleloTest {

	// Funções de base para a realização dos testes
	public static Account criaConta(){
		Account novaConta =
				new Account(Name = 'Juliana', CPF_CNPJ__c = '63518800094', Email__c	= 'juliana.neres@qintess.com');
		Database.insert(novaConta);
		novaConta = [SELECT Id FROM Account WHERE Name = 'Juliana' LIMIT 1];
		return novaConta;
	}

	public static Contact criaContato(Account novaConta){
		Contact novoContato = new Contact(LastName = 'Neres', Account = novaConta, AccountId = novaConta.Id,
				Email = 'neres.juliana@qintess.com');
		Database.insert(novoContato);
		return novoContato;
	}

	public static Opportunity criaOportunidade(Account novaConta, Contact novoContato){
		Opportunity novaOportunidade =
				New Opportunity(name = 'Nova oportunidade', StageName = 'Auditoria Finalizada/ Transf Implantação',
						AccountId = novaConta.Id, CloseDate = Date.today().addDays(1), campanha__c = '123',
						RecordTypeId = '01236000000nFt4', Data_da_Auditoria__c = Date.today().addDays(1),
						Contato_da_oportunidade__c = novoContato.Id, Contato_da_oportunidade__r = novoContato);
		Database.insert(novaOportunidade);
		return novaOportunidade;
	}

	public static Produtos_Alelo__c criaAleloAuto(Opportunity novaOportunidade){
		Produtos_Alelo__c novoProdutoAleloAuto =
				new Produtos_Alelo__c(Codigo_de_Produtos__c = '301', Oportunidade__c = novaOportunidade.Id,
						Numero_do_Contrato__c = '10000');
		Database.insert(novoProdutoAleloAuto);
		return novoProdutoAleloAuto;
	}

	public static Produtos_Alelo__c criaAleloMobilidade(Opportunity novaOportunidade){
		Produtos_Alelo__c novoProdutoAleloMob =
				new Produtos_Alelo__c(Codigo_de_Produtos__c = '302', Oportunidade__c = novaOportunidade.Id,
						Numero_do_Contrato__c = '20000');
		Database.insert(novoProdutoAleloMob);
		return novoProdutoAleloMob;
	}

	public static void criaProcessoRoteamento(Opportunity novaOportunidade, Account novaConta){
		Order novoProcessoRoteamento =
				New Order(OpportunityId = novaOportunidade.Id, Account = novaConta, AccountId = novaConta.Id, EffectiveDate = Date.today(), Status = 'Vendas');
		Database.upsert(novoProcessoRoteamento);
	}

	// GATILHO: Inserção do produto alelo
	// FUNÇÃO: Testar se o processo de roteamento possui os códigos do produto depois que o produto foi inserido ou atualizado
	@isTest public static void insereProdutoAlelo(){
		Test.startTest();

		// Criando a conta
		Account novaConta = criaConta();

		// Criando o contato
		Contact novoContato = criaContato(novaConta);

		// Criando a oportunidade
		Opportunity novaOportunidade = criaOportunidade(novaConta, novoContato);

		//Criando o produto alelo auto
		Produtos_Alelo__c novoAleloAuto = criaAleloAuto(novaOportunidade);

		//Inserindo o produto alelo mobilidade
		Produtos_Alelo__c novoAleloMob = criaAleloMobilidade(novaOportunidade);

		// Criando o processo de roteamento
		criaProcessoRoteamento(novaOportunidade, novaConta);

		//Capturando dados atualizados do processo de roteamento criado
		Order novoProcessoRoteamento = [SELECT Id, Codigo_do_Produto_1__c,
								  Codigo_do_Produto_2__c,
								  AccountId
								  FROM Order
								  WHERE AccountId = :novaConta.Id limit 1];

		Test.stopTest();

		// SELECT com o processo de rotamento atualizado (após inserir os produtos)
		novoProcessoRoteamento = [SELECT ID,Codigo_do_Produto_1__c, Codigo_do_Produto_2__c
									FROM Order
									WHERE id = :novoProcessoRoteamento.Id limit 1].get(0);

		// VALIDA SE O CÓDIGO DO PRODUTO 1 É EQUIVALENTE A 301
		 System.assertEquals(301, novoProcessoRoteamento.Codigo_do_Produto_1__c);

		// VALIDA SE O CÓDIGO DO PRODUTO 2 É EQUIVALENTE A 302
		 System.assertEquals(302, novoProcessoRoteamento.Codigo_do_Produto_2__c);
	}

	//GATILHO: Exclusão de um produto alelo
	//FUNÇÃO: Testar se o processo de roteamento não possui mais o código do produto alelo despois que o produto foi removido.
	@isTest public static void removeProdutoAlelo(){

		// Criando a conta
		Account novaConta = criaConta();

		// Criando contato
		Contact novoContato = criaContato(novaConta);

		// Criando a oportunidade
		Opportunity novaOportunidade = criaOportunidade(novaConta, novoContato);

		// Criando o produto alelo auto
		Produtos_Alelo__c novoAleloAuto = criaAleloAuto(novaOportunidade);

		// Criando o produto alelo mobilidade
		Produtos_Alelo__c novoAleloMob = criaAleloMobilidade(novaOportunidade);

		// Criando o processo de roteamento
		criaProcessoRoteamento(novaOportunidade, novaConta);

		// Capturando dados atualizados do processo de roteamento criado
		Order novoProcessoRoteamento = [SELECT Id, Codigo_do_Produto_1__c, Codigo_do_Produto_2__c, AccountId
											FROM Order
											WHERE AccountId = :novaConta.Id limit 1];

		Test.startTest();
		// Deleta os produos cadastrados na oportunidade
		Database.delete(novoAleloAuto.Id);
		Database.delete(novoAleloMob.Id);
		Test.stopTest();

		// SELECT com o processo de roteamento atualizado (após excluir os produtos)
		novoProcessoRoteamento = [SELECT ID,Codigo_do_Produto_1__c, Codigo_do_Produto_2__c
									FROM Order
									WHERE id = :novoProcessoRoteamento.Id limit 1].get(0);

		// VALIDA SE O CÓDIGO DO PRODUTO 1 É EQUIVALENTE A NULL
		 System.assertEquals(null, novoProcessoRoteamento.Codigo_do_Produto_1__c);

		// VALIDA SE O CÓDIGO DO PRODUTO 2 É EQUIVALENTE A NULL
		 System.assertEquals(null, novoProcessoRoteamento.Codigo_do_Produto_2__c);
	}

}
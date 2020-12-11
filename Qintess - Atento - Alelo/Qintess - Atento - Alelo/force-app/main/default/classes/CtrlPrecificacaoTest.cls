/**
 * Created by re039622 on 05/08/2020.
 */
@isTest
public class CtrlPrecificacaoTest {
	@isTest
	public static void teste01(){
		Test.startTest();
		String opportunitiesJson = '{"E_mail_Enviado__c":false, "Codigo_do_Banco__c": 1, "Name": "TESTE_11H - DATA CLOUD SISTEMAS DE INFORMATICA LTDA", "StageName": "Apresentação Enviada", "CloseDate": "2016-09-30","Produtos_Alelo__r":{"totalSize":5,"done":true,"records":[{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Não Identificado","Nome_do_Produto__c":"Não Identificado","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"302","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Auto","Nome_do_Produto__c":"Auto","Quantidade_de_Cartoes__c":4,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"301","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false},{"Name":"Flex Car Visa Vale","Nome_do_Produto__c":"Flex Car Visa Vale","Quantidade_de_Cartoes__c":5,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"300","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false}]},"Account":{"Name":"DATA CLOUD SISTEMAS DE INFORMATICA LTDA","CPF_CNPJ__c":"18146085000186", "Razao_Social__c" : "DATA CLOUD SISTEMAS DE INFORMATICA LTDA"}}';
		Opportunity oportunidade = (Opportunity) JSON.deserialize(opportunitiesJson, Opportunity.class);
		insert oportunidade.Account;
		oportunidade.AccountId = oportunidade.Account.Id;
		insert oportunidade;

		Dominio__c dominio = new Dominio__c(Codigo_Identificador__c = 300.0, Descricao__c = 'Alelo Cultura', Identificador__c = 'ProductCode');
		insert dominio;

		Produtos_Alelo__c produtoAlelo = new Produtos_Alelo__c(Codigo_de_Produtos__c = '300', Forma_de_Pagamento__c = 'CARTAO CREDITO', Oportunidade__c = oportunidade.Id, Valor_Unitario__c = 100.0, Quantidade_de_Cartoes__c = 10.0);
		Tarifas_Alelo__c tarifa = new Tarifas_Alelo__c(Codigo_da_Tarifa__c = 2.0, Qtd_Min__c = 55.0, Qtd_Max_Beneficios__c = 64.0, Valor_Minimo__c = 30.0, Valor_Maximo__c = 50.0, Nome_da_Forma_de_Pagamento__c = 'CARTAO CREDITO');
		Tarifas_Alelo__c tarifa2 = new Tarifas_Alelo__c(Codigo_da_Tarifa__c = 4.0, Qtd_Min__c = 55.0, Qtd_Max_Beneficios__c = 64.0, Valor_Minimo__c = 30.0, Valor_Maximo__c = 50.0, Nome_da_Forma_de_Pagamento__c = 'CARTAO CREDITO');
		Nivel_de_Alcada__c nivelAlcada = new Nivel_de_Alcada__c(Name = 'Nivel Teste', Codigo_da_Tarifa__c = 2.0, Nome_da_Tarifa__c = tarifa.Nome_da_Tarifa__c, Nome_do_Produto__c = 'Alelo Cultura', Nivel_de_Alcada__c = '1', Nivel__c = '1', Valor_Medio__c = 50.0, Quantidade_Beneficios__c = 10.0, Nome_da_Forma_de_Pagamento__c = 'CARTAO CREDITO', Valor_Maximo__c = 100.0, Qtd_Min__c = 55.0, Qtd_Max_Beneficios__c = 64.0, Codigo_de_Produtos__c = '2');
		insert produtoAlelo;
		insert tarifa;
		insert tarifa2;
		insert nivelAlcada;

		PageReference page = new ApexPages.StandardController(oportunidade).view();
		Test.setCurrentPage(page);

		ApexPages.currentPage().getParameters().put('Id', oportunidade.Id);
		ApexPages.currentPage().getParameters().put('index', '0');

		CtrlPrecificacao controllerPrecificacao = new CtrlPrecificacao();
		controllerPrecificacao.ItemSelecionado = new CtrlPrecificacao.TOItem(dominio);
		controllerPrecificacao.ItemSelecionado.Produto.Codigo_Identificador__c = 400.0;
		controllerPrecificacao.ValorMedioIndividual = 50.0;
		controllerPrecificacao.Quantidade = 60;
		controllerPrecificacao.produtosAlelo = produtoAlelo;
		controllerPrecificacao.Oportunidade = oportunidade;
		controllerPrecificacao.temAuto = true;
		controllerPrecificacao.temMobilidade = true;
		controllerPrecificacao.ProdutoSelecionado = produtoAlelo.Id;
		controllerPrecificacao.Produtos.put(produtoAlelo.Id, dominio);
		controllerPrecificacao.NomeEmpresa = 'Empresa teste';

		System.debug(controllerPrecificacao.IdOportunidade);
		controllerPrecificacao.indexTarifa = 1;

		CtrlPrecificacao.TOTarifaPrecificacao precificacaoTarifa = new CtrlPrecificacao.TOTarifaPrecificacao(tarifa, 1);
		CtrlPrecificacao.TOTarifaPrecificacao precificacaoTarifa2 = new CtrlPrecificacao.TOTarifaPrecificacao(tarifa2, 1);

		controllerPrecificacao.Tarifas = new List<CtrlPrecificacao.TOTarifaPrecificacao>();
		controllerPrecificacao.Tarifas.add(precificacaoTarifa);
		controllerPrecificacao.Tarifas.add(precificacaoTarifa2);

		controllerPrecificacao.simularNivelAlcada();

		controllerPrecificacao.selecionarProduto();
		controllerPrecificacao.carregarProdutoAlelo();
		controllerPrecificacao.simular();

		controllerPrecificacao.Tarifas.add(precificacaoTarifa);
		controllerPrecificacao.Tarifas.add(precificacaoTarifa2);
		controllerPrecificacao.removerTarifa();

		controllerPrecificacao.Tarifas = new List<CtrlPrecificacao.TOTarifaPrecificacao>();
		controllerPrecificacao.Tarifas.add(precificacaoTarifa);
		controllerPrecificacao.ItemSelecionado = new CtrlPrecificacao.TOItem(dominio);
		controllerPrecificacao.ItemSelecionado.EntregaCentralizada = true;
		controllerPrecificacao.ItemSelecionado.FaturamentoCentralizado = true;
		controllerPrecificacao.ItemSelecionado.SolicitacaoReemissao = true;
		controllerPrecificacao.ItemSelecionado.ValorUnitario = 20;
		controllerPrecificacao.ItemSelecionado.Quantidade = 10;
		controllerPrecificacao.ItemSelecionado.Produto.Codigo_Identificador__c = 400.0;
		controllerPrecificacao.ItemSelecionado.ProdutoObj = produtoAlelo;
		controllerPrecificacao.ItemSelecionado.ProdutoObj.Quantidade_de_Cartoes__c = 100.0;
		controllerPrecificacao.ItemSelecionado.ProdutoObj.Valor_Unitario__c = 150.0;
		controllerPrecificacao.ItemSelecionado.ProdutoObj.Nome_Empresa_Gravacao_Cartao__c = 'Empresa teste';
		controllerPrecificacao.ItemSelecionado.Tarifas = controllerPrecificacao.Tarifas;


		controllerPrecificacao.adicionarCarrinho();

		controllerPrecificacao.editar();

		controllerPrecificacao.Carrinho.add(controllerPrecificacao.ItemSelecionado);
		ApexPages.currentPage().getParameters().put('index', '0');
		controllerPrecificacao.excluir();

		controllerPrecificacao.limparSimulacao();

		Test.stopTest();

	}
}
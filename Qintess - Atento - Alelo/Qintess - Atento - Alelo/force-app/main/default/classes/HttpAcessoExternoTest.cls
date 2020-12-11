@isTest
public class HttpAcessoExternoTest {
	static testMethod void Test_Method01(){
		Test.startTest();
		TOTarifa t1 = new TOTarifa('301', 'ALELO AUTO', '1.0', 'Tarifa de entrega de cartão', 'a', TOTarifa.FORMA_PAGAMENTO_BOLETO);
		TOTarifa t2 = new TOTarifa('301', 'ALELO AUTO', '1.0', 'Tarifa de entrega de cartão', 'b', TOTarifa.FORMA_PAGAMENTO_CREDITO);

		Account acc = geraConta();
		Opportunity opp = geraOportunidade();
		Produtos_Alelo__c product = geraProduto(opp.Id,'Alelo Alimentação');

		HttpAcessoExterno.test();
		Test.setMock(HttpCalloutMock.class, new HttpAcessoExternoMock(200, 'OK', '', null));
		HttpAcessoExterno.getPricePolicy(t1);
		HttpAcessoExterno.getPricePolicy(t2);

		HttpAcessoExterno.maitainContractIS(acc,opp,product);

		Test.stopTest();
	}
	private static Account geraConta(){
		String AccountJson = '{"Name":"RD AUTOS","CPF_CNPJ__c":"20140366000173","Ramo_de_Atividade__c":"funilaria e pintura automotiva","Inscricao_Municipal__c":"isento","Complemento__c":"TESTE","Numero__c":175,"Bairro__c":"TABOAO DA SERRA","Estado__c":"SP","Nome_Fantasia__c":"RD AUTOS","Inscricao_Estadual__c":"isento","Razao_Social__c":"RD AUTOS PRESTADORA DE SERVIÇOS LTDA","BillingStreet":"RUA MARIA RITA ASSUNÇÃO FERREIRA","Quantidade_de_Funcionarios__c":1,"Tipo_de_Empresa__c":"Empresa Privada (001)","BillingPostalCode":"06773330","BillingCity":"SAO PAULO","OwnerId":"005P0000001LE7NIAW"}';
		Account objAccount = (Account)JSON.deserialize(AccountJson, Account.class);

		objAccount.OwnerId = UserInfo.getUserId();
		objAccount.Bairro__c = 'Baiiro';
		objAccount.ShippingPostalCode = '09580260';
		objAccount.ShippingCity = 'Sao Paulo';
		objAccount.Divisao_Ramo_de_Atividade__c = 'Serviços Pessoais';
		objAccount.Razao_Social__c = 'Razao Social';
		objAccount.Nome_Fantasia__c = 'Razao Social';
		objAccount.Inscricao_Estadual__c = '89278923';
		objAccount.Inscricao_Municipal__c = '89278923';
		objAccount.Tipo_de_Empresa__c = 'Empresa Privada (001)';
		objAccount.Secao_Ramo_de_Atividade__c = 'C - Industrias Extrativas';
		objAccount.Quantidade_de_Funcionarios__c = 20;
		objAccount.Numero__c = 300;
		objAccount.ShippingStreet = 'Endereco';
		objAccount.Estado__c = 'SP';
		objAccount.MIdia__c = 'CATHO';
		objAccount.Complemento_Cobranca__c = 'Complemento';
		objAccount.Bairro_Cobranca__c = 'Bairro';


		return objAccount;
	}

	private static Opportunity geraOportunidade(){
		String OpportunityJson = '{"IsDeleted":false,"RecordTypeId":"01236000000nFsuAAE","IsPrivate":false,"Name":"- RD AUTOS","StageName":"Venda Confirmada","Probability":90,"CloseDate":"2016-09-30","LeadSource":"Outros","IsClosed":false,"IsWon":false,"ForecastCategory":"Pipeline","ForecastCategoryName":"Funil","HasOpportunityLineItem":false,"CreatedDate":"2016-09-22T18:27:21.000+0000","LastModifiedDate":"2016-10-03T17:01:37.000+0000","SystemModstamp":"2016-10-05T10:31:08.000+0000","FiscalQuarter":3,"FiscalYear":2016,"Fiscal":"2016 3","LastViewedDate":"2016-10-06T16:40:30.000+0000","LastReferencedDate":"2016-10-06T16:40:30.000+0000","HasOpenActivity":false,"HasOverdueTask":false,"Campanha__c":"Teste 24/9","Interesse_em_ALELO_Auto__c":false,"Interesse_em_Alimentacao__c":false,"Interesse_em_Cesta_Alimentacao__c":false,"Interesse_em_Flex_Car__c":false,"Interesse_em_Natal_Alimentacao__c":false,"Interesse_em_Refeicao__c":false,"Interesse_Vale_Transporte__c":false,"Motivo_Detalhado__c":"LIGAÇÃO CAIU (098)","Devolver_Para_Televendas__c":false,"V18__c":false,"Central_de_Origem__c":"","Sub_Campanha__c":"sexta","Venda_Centralizada__c":false,"E_mail_Enviado__c":true,"Dias_Parados__c":3,"Telefone_Decisor__c":"11975193465","Telefone_Operacional__c":"11 965156201","Valor_Total_Produtos__c":28000,"Valor_Total_Implantado__c":0,"Total_de_Contratos__c":4,"Total_de_Contratos_Gerados__c":0}';

		Opportunity objOpportunity = (Opportunity)JSON.deserialize(OpportunityJson, Opportunity.class);
		Contact objContact = TestData.getContact();

		objOpportunity.AccountId = objContact.AccountId;
		objOpportunity.OwnerId = objContact.OwnerId;
		objOpportunity.Contato_da_oportunidade__c = objContact.Id;
		objOpportunity.Contato_da_oportunidade_2__c = objContact.Id;

		return objOpportunity;
	}

	private static Produtos_Alelo__c geraProduto(Id OpportunityId, String nameProduct){
		String ProdutoAleloJson = '{"IsDeleted":false,"Name":"Alelo Alimentação","CreatedDate":"2016-09-27T18:37:08.000+0000","CreatedById":"005P0000001LE7NIAW","LastModifiedDate":"2016-10-06T19:10:56.000+0000","LastModifiedById":"00536000001PqKVAA0","SystemModstamp":"2016-10-07T10:31:14.000+0000","LastViewedDate":"2016-10-07T20:38:20.000+0000","LastReferencedDate":"2016-10-07T20:38:20.000+0000","Codigo_de_Produtos__c":"200","Quantidade_de_Cartoes__c":20,"Oportunidade__c":"006P0000007DrAHIA0","Nome_do_Produto__c":"Alelo Alimentação","Disponibilizacao_mensal__c":500,"Valor_Total__c":10000,"Valor_Unitario__c":500,"Nome_Empresa_Gravacao_Cartao__c":"teste","Entrega_Centralizada__c":false,"Faturamento_Centralizado__c":false,"Permitir_Reemissao_Usuario__c":true,"F_Valor_Total__c":10000,"Tabulacao_Pai_Implantacao__c":"DESEJA CANCELAR","Tabulacao_Filho_Implantacao__c":"DESISTIU DA CONTRATAÇÃO","Motivo_de_Cancelamento__c":"PERIODO DE ENTREGA NÃO ESCLARECIDO CORRETAMENTE","Descricao__c":"gdfb","Observacao_Implantacao__c":"Em contato Sr (a) 003P000000zXH7dIAG na data  , informa que desistiu da contratação do serviço pelo motivo PERIODO DE ENTREGA NÃO ESCLARECIDO CORRETAMENTE ."}';

		Produtos_Alelo__c objProdutoAlelo = (Produtos_Alelo__c)JSON.deserialize(ProdutoAleloJson, Produtos_Alelo__c.class);
		objProdutoAlelo.Oportunidade__c = OpportunityId;
		objProdutoAlelo.Name = nameProduct;
		objProdutoAlelo.Nome_do_Produto__c = nameProduct;
		objProdutoAlelo.FormaPagamento__c = TOTarifa.FORMA_PAGAMENTO_BOLETO;
		objProdutoAlelo.Banco__c = 'Banco do Brasil';

		return objProdutoAlelo;
	}
}
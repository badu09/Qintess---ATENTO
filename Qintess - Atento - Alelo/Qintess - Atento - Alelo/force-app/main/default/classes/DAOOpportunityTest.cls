@isTest
public class DAOOpportunityTest {
	static testMethod void testOpportunity() {
		Test.startTest();
		String opportunitiesJson = '{"E_mail_Enviado__c":false, "Codigo_do_Banco__c": 1, "Name": "TESTE_11H - DATA CLOUD SISTEMAS DE INFORMATICA LTDA", "StageName": "Apresentação Enviada", "CloseDate": "2016-09-30","Produtos_Alelo__r":{"totalSize":5,"done":true,"records":[{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Não Identificado","Nome_do_Produto__c":"Não Identificado","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"102","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Auto","Nome_do_Produto__c":"Auto","Quantidade_de_Cartoes__c":4,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"501","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false},{"Name":"Flex Car Visa Vale","Nome_do_Produto__c":"Flex Car Visa Vale","Quantidade_de_Cartoes__c":5,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"300","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false}]},"Account":{"Name":"DATA CLOUD SISTEMAS DE INFORMATICA LTDA","CPF_CNPJ__c":"18146085000186"}}';
		Opportunity oportunidade = (Opportunity) JSON.deserialize(opportunitiesJson, Opportunity.class);
		insert oportunidade.Account;
		oportunidade.AccountId = oportunidade.Account.Id;
		insert oportunidade;
		for(Produtos_Alelo__c produto : oportunidade.Produtos_Alelo__r) {
			produto.Oportunidade__c = oportunidade.Id;
		}
        
        List<Produtos_Alelo__c> alelo = oportunidade.Produtos_Alelo__r;
        Set<Produtos_Alelo__c> a = new Set<Produtos_Alelo__C>(alelo);
        List<Produtos_Alelo__c> alelos = new List<Produtos_Alelo__c>(a);
		insert alelos;
		DAOOpportunity.getOpportunityById(oportunidade.Id);
		DAOOpportunity.getQueryIndicacaoBanco(Integer.valueOf(oportunidade.Codigo_do_Banco__c));
        DAOOpportunity.getQueryIndicacaoBancos(1,33,237);
		DAOOpportunity.getOpportunityForAccount(oportunidade.AccountId);
		DAOOpportunity.getOpportunityForAccountProdutoAlelo(oportunidade.AccountId);
		DAOOpportunity.getOpportunityForAccountProdutoAleloByCobranca(oportunidade.AccountId, oportunidade.Id);
        DAOOpportunity.getOpportunityValidaBKOById(oportunidade.Id);
        DAOOpportunity.getOpportunityApprovalStatusForById(oportunidade.Id);
		Test.stopTest();
	}

	static testmethod void testUpdateListOpportunity(){
		List<Opportunity> listOpportunities = [SELECT Name FROM Opportunity LIMIT 10];
		Test.startTest();
		DAOOpportunity.updateListOpportunity(listOpportunities);
		Test.stopTest();
	}

	static testmethod void testGetOpportunityForSetId(){
		List<Opportunity> setOpportunities = [SELECT Id FROM Opportunity LIMIT 10];
		Set<ID> setOpportunitiesId = new Set<Id>();

		for (Opportunity opp : setOpportunities) {
			setOpportunitiesId.add(opp.Id);
		}

		Test.startTest();
		DAOOpportunity.getOpportunityForSetId(setOpportunitiesId);
		Test.stopTest();

	}

	static testmethod void testGetOpportunityFromConsultaClienteSet(){
		Test.startTest();
		String opportunitiesJson = '{"E_mail_Enviado__c":false, "Codigo_do_Banco__c": 1, "Name": "TESTE_11H - DATA CLOUD SISTEMAS DE INFORMATICA LTDA", "StageName": "Apresentação Enviada", "CloseDate": "2016-09-30","Produtos_Alelo__r":{"totalSize":5,"done":true,"records":[{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Não Identificado","Nome_do_Produto__c":"Não Identificado","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"382","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Auto","Nome_do_Produto__c":"Auto","Quantidade_de_Cartoes__c":4,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"391","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false},{"Name":"Flex Car Visa Vale","Nome_do_Produto__c":"Flex Car Visa Vale","Quantidade_de_Cartoes__c":5,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"300","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false}]},"Account":{"Name":"DATA CLOUD SISTEMAS DE INFORMATICA LTDA","CPF_CNPJ__c":"18146085000186", "Razao_Social__c" : "DATA CLOUD SISTEMAS DE INFORMATICA LTDA"}}';
		Opportunity oportunidade = (Opportunity) JSON.deserialize(opportunitiesJson, Opportunity.class);
		insert oportunidade.Account;
		oportunidade.AccountId = oportunidade.Account.Id;
		insert oportunidade;
		for(Produtos_Alelo__c produto : oportunidade.Produtos_Alelo__r) {
			produto.Oportunidade__c = oportunidade.Id;
		}
		insert oportunidade.Produtos_Alelo__r;

		List<Opportunity> oportunidades = [ SELECT Id FROM Opportunity LIMIT 2];
		Set<String> oportunidadesStringSet = new Set<String>();

		for (Opportunity opp : oportunidades) {
			oportunidadesStringSet.add(opp.Id);
		}

		DAOOpportunity.getOpportunityFromConsultaCliente(oportunidade.Account.CPF_CNPJ__c, oportunidade.Account.Razao_Social__c, oportunidadesStringSet);

		Test.stopTest();
	}

	static testmethod void testGetOpportunityForSetIdLIM2K(){
		Test.startTest();
		List<Opportunity> opportunitiesList = [SELECT Id FROM Opportunity LIMIT 10];
		Set<Id> opportunitiesIdSet = new Set<Id>();
		for (Opportunity opp : opportunitiesList) {
			opportunitiesIdSet.add(opp.Id);
		}

		DAOOpportunity.getOpportunityForSetIdLIM2K(opportunitiesIdSet);
		Test.stopTest();
	}

}
@IsTest
private class TestTabulaLead {

	static testMethod void TestTabulaLead() {
		PageReference pageRef = new PageReference('/apex/TabulaLead');
		Test.setCurrentPage(pageRef);
		Test.startTest();

		Lead lead = TestData.getLead();
		// Telefone 1
		lead.Phone = '438493443';
		update lead;

		ApexPages.StandardController sc = new ApexPages.StandardController(lead);

		// Insere configuração personalizada
		insert new TabulacoesNovo__c(Name = '043', Agendamento__c = true, DispositionID__c = 278,
				EncerraTabulacao__c = true, FaseOportunidade__c = 'Venda Confirmada',
				Motivo_Detalhado__c = 'VENDA REALIZADA COM SUCESSO (043)', Omitir_Usuario__c = false,
				Status_1__c = 'CONTATO', Status_do_Lead__c = 'TEM INTERESSE (003)');

		CtrlTabulaLead controller = new CtrlTabulaLead(sc);
		controller.telefone = '438493443';
		controller.leadObj.Agendamento_Retorno__c = Datetime.now().addDays(1);
		controller.getTabulacoes();
		controller.tabulacao1 = '043';
		controller.selecionarTabulacao();
		controller.salvar();

		// Telefone 2
		controller.leadObj.Phone = '';
		controller.leadObj.Telefone2__c = '438493443';
		controller.leadObj.Agendamento_Retorno__c = null;
		controller.leadObj.Agendamento_Retorno__c = Datetime.now().addDays(1);
		controller.salvar();

		// Telefone 3
		controller.leadObj.Telefone2__c = '';
		controller.leadObj.Telefone3__c = '438493443';
		controller.leadObj.Agendamento_Retorno__c = null;
		controller.leadObj.Agendamento_Retorno__c = Datetime.now().addDays(1);
		controller.salvar();

		// Telefone 4
		controller.leadObj.Telefone3__c = '';
		controller.leadObj.Telefone4__c = '438493443';
		controller.leadObj.Agendamento_Retorno__c = null;
		controller.leadObj.Agendamento_Retorno__c = Datetime.now().addDays(1);
		controller.salvar();

		// Telefone 5
		controller.leadObj.Telefone4__c = '';
		controller.leadObj.Telefone5__c = '438493443';
		controller.leadObj.Agendamento_Retorno__c = null;
		controller.leadObj.Agendamento_Retorno__c = Datetime.now().addDays(1);
		controller.salvar();

		// Sem data de Agendamento
		controller.leadObj.Telefone4__c = '';
		controller.leadObj.Telefone5__c = '438493443';
		controller.leadObj.Agendamento_Retorno__c = null;
		controller.salvar();

		Test.stopTest();
	}

}
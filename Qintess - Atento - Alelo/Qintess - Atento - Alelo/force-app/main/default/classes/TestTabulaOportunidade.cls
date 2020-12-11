@IsTest
private class TestTabulaOportunidade {

	static testMethod void TestTabulaOportunidade() {
		PageReference pageRef = new PageReference('/apex/TabulaOportunidade');
		Test.setCurrentPage(pageRef);
		Test.startTest();

		Opportunity oportunidade = TestData.getOpportunity();
		// Telefone 1
		oportunidade.Telefone_Decisor__c = '438493443';
		oportunidade.Telefone_Operacional__c = '438493443';
		update oportunidade;

		ApexPages.StandardController sc = new ApexPages.StandardController(oportunidade);

		// Insere configuração personalizada
		insert new TabulacoesNovo__c(Name = '033', Agendamento__c = true, DispositionID__c = 278,
				EncerraTabulacao__c = true, FaseOportunidade__c = 'Agendamento',
				Motivo_Detalhado__c = 'AGENDAMENTO FIDELIZADO (033)', Omitir_Usuario__c = false,
				Status_do_Lead__c = '	AGENDAMENTO (001)');

		CtrlTabulaOportunidade controller = new CtrlTabulaOportunidade(sc);
		controller.telefone = '438493443';
		controller.fakeOportunidade.Agendamento_Retorno__c = Datetime.now().addDays(1);
		controller.getTabulacoes();
		controller.tabulacao1 = '033';
		controller.selecionarTabulacao();
		controller.salvar();

		controller.fakeOportunidade.Agendamento_Retorno__c = null;
		controller.getTabulacoes();
		controller.tabulacao1 = '033';
		controller.selecionarTabulacao();
		controller.salvar();

		Test.stopTest();
	}

}
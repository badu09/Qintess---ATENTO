@IsTest
private class CtrlCallControlTest {

	static Opportunity o;
	static Produtos_Alelo__c prod;

    @TestSetup
	static void setup(){
		Lead lead = new Lead();

		lead.LastName = 'Teste';
		lead.CNPJ__c = '24315647000170';
		lead.Company = 'Company';
		lead.Phone = '1199999999';

		insert lead;


		List<Endpoint_Servico__c> lista = new List<Endpoint_Servico__c>();
		Endpoint_Servico__c endpoint_servico = new Endpoint_Servico__c();
		endpoint_servico.Endpoint__c = 'teste';
		endpoint_servico.Name = 'AgentCmd';

		lista.add(endpoint_servico);

		Endpoint_Servico__c endpoint_servico2 = new Endpoint_Servico__c();
		endpoint_servico2.Endpoint__c = 'teste';
		endpoint_servico2.Name = 'AgentEvt';

		lista.add(endpoint_servico2);

		Endpoint_Servico__c endpoint_servico3 = new Endpoint_Servico__c();
		endpoint_servico3.Endpoint__c = 'teste';
		endpoint_servico3.Name = 'MailingCmd';

		lista.add(endpoint_servico3);

		insert lista;

		TabulacoesNovo__c tab = new TabulacoesNovo__c();
		tab.Name = '098';
		insert tab;

		Account acc = new Account();
		acc.Name = 'Conta teste';
		acc.CPF_CNPJ__c = '55384786000180';

		insert acc;

		Contact con = new Contact();
		con.LastName = 'Teste';
		con.AccountId = acc.Id;
		con.CPF__c = '11111111111';
		con.Email='test@gmail.com';

		insert con;

		Opportunity oportunidade = TestData.getOpportunity();

		oportunidade.Telefone_Decisor__c = '1199999999';
		oportunidade.StageName = 'Auditoria Finalizada/ Transf Implantação';
		oportunidade.Data_da_Auditoria__c = System.today();
		update oportunidade;

		o = oportunidade;

		Produtos_Alelo__c produto = new Produtos_Alelo__c();
		produto.Oportunidade__c = o.id;
		produto.Numero_do_Contrato__c = '123555';
		produto.E_mail_do_Interlocutor__c = 'email@email.com';

		produto.Data_Hora_Tabulacao__c = System.now();
		produto.Nome_do_Implantador__c = UserInfo.getName();
		produto.Tabulacao_Pai_Implantacao__c = 'IMPLANTADO';
		produto.Tabulacao_Filho_Implantacao__c = 'AGUARDANDO FATURAMENTO';
		produto.Valor_Implantado__c = 5000;
		produto.Data_do_pedido__c = Date.today();
		insert produto;

		prod = produto;

		Order roteamento = new Order();
		roteamento.OwnerId = DAOQueueSobject.getGroupMemberByDeveloperName('ALELO_IMPLANTACAO_M0_NOVOS').QueueId;
		roteamento.OpportunityId = oportunidade.Id;
		roteamento.AccountId = acc.Id;
		roteamento.EffectiveDate = Date.today();
		roteamento.Status = 'Disponivel';

		insert roteamento;
	}

	@IsTest
	static void testCtrlCallControl(){


		/*PageReference pageRefControl = new PageReference('/apex/CallControl');
		Test.setCurrentPage(pageRefControl);
		Test.startTest();


		CtrlCallControl controller = new CtrlCallControl();
		controller.getListaTab();
		List<Lead> listaLeads = (List<Lead>) JSON.deserialize(CtrlCallControl.getLeads('1199999999'), List<Lead>.class);
		ApexPages.currentPage().getParameters().put('idObjeto', listaLeads[0].Id);
		controller.verificaChamadaManual();
		controller.carregarLead();
        
        
		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		controller.LeadObj = listaLeads[0];
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('telefone', '1199999999');
		controller.encerrarChamada();

		controller.LeadObj = listaLeads[0];
		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('phoneNumber', '1199999999');
		controller.salvarTabulacao();

		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		controller.LeadObj = listaLeads[0];
		controller.LeadObj.Telefone2__c = controller.LeadObj.Phone;
		controller.LeadObj.Phone = '1139096765';
		update controller.LeadObj;
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('telefone', '1199999999');
		controller.encerrarChamada();

		controller.LeadObj = listaLeads[0];
		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('phoneNumber', '1199999999');
		controller.salvarTabulacao();

		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		controller.LeadObj = listaLeads[0];
		controller.LeadObj.Telefone3__c = controller.LeadObj.Telefone2__c;
		controller.LeadObj.Telefone2__c = '1139875673';
		update controller.LeadObj;
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('telefone', '1199999999');
		controller.encerrarChamada();

		controller.LeadObj = listaLeads[0];
		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('phoneNumber', '1199999999');
		controller.salvarTabulacao();

		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		controller.LeadObj = listaLeads[0];
		controller.LeadObj.Telefone4__c = controller.LeadObj.Telefone3__c;
		controller.LeadObj.Telefone3__c = '1139567473';
		update controller.LeadObj;
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('telefone', '1199999999');
		controller.encerrarChamada();

		controller.LeadObj = listaLeads[0];
		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('phoneNumber', '1199999999');
		controller.salvarTabulacao();

		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		controller.LeadObj = listaLeads[0];
		controller.LeadObj.Telefone5__c = controller.LeadObj.Telefone4__c;
		controller.LeadObj.Telefone4__c = '1139233545';
		update controller.LeadObj;
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('telefone', '1199999999');
		controller.encerrarChamada();

		controller.LeadObj = listaLeads[0];
		controller.tabSelecionadaStr = '098';
		controller.selecionaTabulacao();
		ApexPages.currentPage().getParameters().put('dtAgendamento','12/04.2017 08:40');
		ApexPages.currentPage().getParameters().put('phoneNumber', '1199999999');
		controller.salvarTabulacao();


		controller.doNothing();
		CtrlCallControl.verificaStatusOportunidade(listaLeads[0].Id, '55','alelo ativo manual');
		       
		CtrlCallControl.consultarProcessoImplantacao([SELECT Id FROM Order LIMIT 1].Id);
        CtrlCallControl.consultarProcessoImplantacao([SELECT Id FROM Lead LIMIT 1].Id);
        CtrlCallControl.consultarProcessoImplantacao('Uma String');

		CtrlCallControl.ClickToDialObject clickToDial = new CtrlCallControl.ClickToDialObject('string', 'string', 'string', 'string');

		CtrlCallControl.StatusRelogio statusRelogio = new CtrlCallControl.StatusRelogio();

		statusRelogio.DataFim = Datetime.now();
		statusRelogio.DataInicio = Datetime.now();
		statusRelogio.MotivoPausa = 'pausa';
		statusRelogio.Status = 'status';

		CtrlCallControl.salvarStatus(JSON.serialize(statusRelogio));

		ApexPages.currentPage().getParameters().put('idObjeto',[SELECT id FROM Opportunity LIMIT 1].id);
		controller.carregarLead();       
        
        controller.login = '';
        controller.password = '';
        
		Test.stopTest();
		 */
	}
    
    static testmethod void testCtrlCallControl_Cobranca(){
        
   		/*CtrlCallControl.ClickToDialObject clickToDial = new CtrlCallControl.ClickToDialObject('string', 'string', 'string', 'string');
        
        Cobranca__c cob = new Cobranca__c();
        cob.Produtos_Alelo__c = prod.Id;
        cob.Oportunidade__c = o.id;
        insert cob;
        
        Test.startTest();
			       
        CtrlCallControl.consultarProcessoImplantacao(cob.Id);
       
		Test.stopTest();*/

		CtrlCallControl.testIt();

        
    }
    
}
@IsTest
public class BatchAlteraFilasConceitoMTest {

	@TestSetup
	static void setup(){

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

		Opportunity opp = new Opportunity();
		opp.Name = 'Opp Teste';
		opp.Campanha__c = 'Campanha teste';
		opp.RecordTypeId = DAORecordType.obterPorDeveloperName('Implantacao', 'Opportunity').Id;
		opp.AccountId = acc.Id;
		opp.CloseDate = Date.today()+20;
		opp.StageName = 'Auditoria Finalizada/ Transf Implantação';
		opp.Data_da_Auditoria__c = System.today();
		opp.Contato_da_oportunidade__c = con.Id;
		opp.Contato_da_oportunidade_2__c = con.Id;
		opp.Telefone_Decisor__c = '21212121';
		opp.Telefone_Operacional__c = '21212121';

		insert opp;

		Produtos_Alelo__c prod = new Produtos_Alelo__c();
		prod.Name = 'Alelo Alimentação';
		prod.Oportunidade__c = opp.Id;
		prod.Nome_Empresa_Gravacao_Cartao__c = 'Teste';
		prod.Tabulacao_Pai_Implantacao__c = 'SEM PREVISÃO';
		prod.Tabulacao_Filho_Implantacao__c = 'IMPACTO PANDEMIA';

		prod.Agendamento_Retorno_Implanta_o__c = Date.today().addMonths(1);
		prod.Numero_do_Contrato__c = '123';

		insert prod;

		prod.Tabulacao_Pai_Implantacao__c = 'EM IMPLANTAÇÃO';
		prod.Tabulacao_Filho_Implantacao__c = 'PROCESSO CADASTRAL';
		prod.Tabulacao_Neto_Implantacao__c = 'NÃO DEFINIU VALORES';
		prod.Agendamento_Retorno_Implanta_o__c = Date.today()+2;

		update prod;

		Order roteamento = new Order();
		roteamento.OwnerId = DAOQueueSobject.getGroupMemberByDeveloperName('ALELO_IMPLANTACAO_M0_NOVOS').QueueId;
		roteamento.OpportunityId = opp.Id;
		roteamento.AccountId = acc.Id;
		roteamento.EffectiveDate = Date.today();
		roteamento.Status = 'Disponivel';

		insert roteamento;

	}

	@IsTest
	static void test_method_one(){

		ScheduleAlterarFilasConceitoM s = new ScheduleAlterarFilasConceitoM();
		String schedule = '0 1 * * * ?';

		Test.startTest();
			System.schedule('Test ScheduleAlterarFilasConceitoM', schedule, s);
			List<QueueSobject> lista = DAOQueueSobject.getGroupMemberByDeveloperName(new Set<String>{'Alelo_Auto_Agendamento'});
			for (QueueSobject a : lista){
				a.Id = null;
			}
			DAOQueueSobject.insereQueueSobject(lista);
		Test.stopTest();
	}

}
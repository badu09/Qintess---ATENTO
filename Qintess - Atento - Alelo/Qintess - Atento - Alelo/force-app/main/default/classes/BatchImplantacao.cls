public class BatchImplantacao implements Database.Batchable<Implantacao__c>, Database.Stateful {

	BatchImplantacaoConfig__c config = BatchImplantacaoConfig__c.getOrgDefaults();
	public static String CRON_EXP = '0 {0} {1} ? * *';
	private static Integer addMinutes {get; set;}
	Map<Id, Implantacao__c> mapIdToImplantacao;
	Set<Id> setIdErrors;
	Map<String, Id> mapCNPJToId;
	List<Implantacao__c> lstRetry;
	List<Log__c> lstLogs;

	public BatchImplantacao() {
		mapIdToImplantacao = new Map<Id, Implantacao__c>();
		mapCNPJToId = new Map<String, Id>();
		setIdErrors = new Set<Id>();
		lstRetry = new List<Implantacao__c>();
		lstLogs = new List<Log__c>();
	}

	public System.Iterable<Implantacao__c> start(Database.BatchableContext jobId) {

		Log__c logInicio = new Log__c();
		logInicio.Descricao__c = 'Início da Implantação: ' + Datetime.now();
		logInicio.Nome_da_Classe__c = 'BatchImplantacao';
		logInicio.Nome_do_Metodo__c = 'finish';

		if (config.Gravar_Logs__c)
			Database.insert(logInicio);

		Integer max = config.Tentativas_de_Processamento_Maxima__c != null ? (Integer) config.Tentativas_de_Processamento_Maxima__c : 3;

		List<Implantacao__c> lstImplantacao =
		[SELECT Id, Bairro__c, BillingCity__c, Estado_Provincia_de_entrega__c, CPF_CNPJ__c, Numero__c, Phone__c, Razao_Social__c, Rua_de_entrega__c,
				Telefone_2__c, LastName__c, DDDCelular__c, dddfax__c, DDD__c, DDDRedidencial__c, Email__c, Fax__c, Ramal__c, Telefone__c, Tipo__c, Telefone_Residencial__c,
				Interlocutor_Operacao__c, Celular_Operacional__c, DDDCelular_Operacional__c, dddfax_Operacional__c, DDD_Operacional__c, Email_Operacional__c,
				Fax_Operacional__c, Ramal_Operacional__c, Telefone_Operacional__c, Telefone_Residencial_Operacional__c, Canal_de_Venda__c, Cobranca__c,
				Data_do_Cadastramento__c, Data_do_Mailing__c, DDDVendedor__c, Entrega__c, Nome_do_Vendedor__c, Sistema_de_Pedidos__c, Status__c, Telefone_Vendedor__c,
				Usuarios__c, VendedorRamal__c, IdCampanha__c, Operacao__c, Agencia_Debito_em_Conta__c, Agencia_Digito__c, Banco__c, Banco_Debito_em_Conta__c, Faturamento__c,
				Faturamento_Previsto_Implantacao__c, Forma_de_Pagamento__c, Nome_de_Produto_Alelo__c, Numero_do_Contrato__c, Retry_Count__c
				FROM Implantacao__c
				WHERE Processado__c = false AND Retry_Count__c <=:max LIMIT 2000];

		mapIdToImplantacao = new Map<Id, Implantacao__c>(lstImplantacao);

		for (Implantacao__c imp : lstImplantacao) {
			mapCNPJToId.put(imp.CPF_CNPJ__c, imp.Id);
		}

		return lstImplantacao;
	}

	public Void execute(Database.BatchableContext jobId, List<Implantacao__c> recordList) {
		lstLogs.clear();
		inserirContas(recordList); //Este metodo altera o conteúdo de recordList
		inserirContatosOportunidadeProdutosAlelo(recordList);
        
        for(Implantacao__c impl : recordList){
            impl.Processado__c = true;
        }
        
        update recordList;
		System.debug(lstLogs);
		if (config.Gravar_Logs__c)
			insert lstLogs;
	}

	public Void finish(Database.BatchableContext jobId) {
		for (Implantacao__c imp : lstRetry)
			imp.Retry_Count__c = imp.Retry_Count__c+1;

		update lstRetry;

		Log__c logFim = new Log__c();
		logFim.Descricao__c = 'Término da Implantação: ' + Datetime.now().format('dd/MM/yyyy HH:mm:ss');
		logFim.Nome_da_Classe__c = 'BatchImplantacao';
		logFim.Nome_do_Metodo__c = 'finish';

		if (config.Gravar_Logs__c)
			Database.insert(logFim);

		scheduleIt(1, 0);
	}

	public static String scheduleIt(Integer minutes, Integer minutesGap) {

		ScheduleBatchImplantacao scheduleBatchImplantacao = new ScheduleBatchImplantacao();
		addMinutes = minutes;
		String jobName = 'Schedule Batch Implantação';
		Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
		string strMinutes = string.valueof(nextScheduleTime.minute());
		string strHours = String.valueOf(nextScheduleTime.hour());
		CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes,strHours});

		return System.schedule(jobName, CRON_EXP, scheduleBatchImplantacao);
	}

	public void inserirContas(List<Implantacao__c> lstImplantacao)
		{
			Set<String> setCNPJ = new Set<String>();
			List<Account> lstContas = new List<Account>();

			String cnpjAtual = '';

			try {
				for (Implantacao__c item : lstImplantacao) {
					if (!setCNPJ.contains(item.CPF_CNPJ__c)) {

						setCNPJ.add(item.CPF_CNPJ__c);
						cnpjAtual = item.CPF_CNPJ__c;
						Account conta = convertImplantacaoToAccount(item);
						lstContas.add(conta);
						cnpjAtual = '';
					}

				}
			} catch (Exception e) {
				Log__c log = new Log__c();
				log.Descricao__c = e.getMessage() +' | '+ e.getStackTraceString();
				log.Nome_da_Classe__c = 'BatchImplantacao';
				log.Nome_do_Metodo__c = 'inserirContas';
				lstLogs.add(log);
				Id impId = mapCNPJToId.get(cnpjAtual);
				if (String.isNotEmpty(impId)) {
					setIdErrors.add(impId);
				}
			}

			List<Database.UpsertResult> srList = Database.upsert(lstContas, Account.CPF_CNPJ__c, false);
			for (Integer i = 0;i<srList.size();i++) {
				Database.UpsertResult sr = srList.get(i);
				if (!sr.isSuccess()) {
					Account acc = lstContas.get(i);
					Id impId = mapCNPJToId.get(acc.CPF_CNPJ__c);
					if (String.isNotEmpty(impId)) {
						setIdErrors.add(impId);
					}
					Log__c log = new Log__c();
					log.Descricao__c = JSON.serialize(sr.getErrors());
					log.Nome_da_Classe__c = 'BatchImplantacao';
					log.Nome_do_Metodo__c = 'Upsert do inserirContas';
					lstLogs.add(log);
				}
			}

			for (Integer i = 0;i<lstImplantacao.size();i++) {
				Implantacao__c imp = lstImplantacao.get(i);

				if (setIdErrors.contains(imp.Id)) {
					lstImplantacao.remove(i);
					lstRetry.add(imp);
				}
			}

			//lstImplantacao é um ponteiro, logo os valores removidos aqui refletirão na chamada do próximo método
		}

	public void inserirContatosOportunidadeProdutosAlelo(List<Implantacao__c> lstImplantacao) {

		List<Contact> lstContatos = new List<Contact>();
		List<Contact> lstContatosOperacional = new List<Contact>();
		List<Opportunity> lstOportunidades = new List<Opportunity>();
		List<Produtos_Alelo__c> lstProdutosAlelo = new List<Produtos_Alelo__c>();

		for (Implantacao__c item : lstImplantacao) {
			lstContatos.add(convertImplantacaoToContact(item));

			if (item.Interlocutor_Operacao__c != null)
			{
				lstContatosOperacional.add(convertImplantacaoToContactOperacional(item));
			} else {
				lstContatosOperacional.add(new Contact(Bairro__c = 'remove me'));
			}
		}

		List<Database.SaveResult> srList = Database.insert(lstContatos, false);
		for (Integer i = 0;i<srList.size();i++) {
			Database.SaveResult sr = srList.get(i);
			if (!sr.isSuccess()) {
				Contact con = lstContatos.get(i);
				if (con.Bairro__c != 'remove me') {
					Id impId = mapCNPJToId.get(con.Account.CPF_CNPJ__c);
					setIdErrors.add(impId);
					Log__c log = new Log__c();
					log.Descricao__c = JSON.serialize(sr.getErrors());
					log.Nome_da_Classe__c = 'BatchImplantacao';
					log.Nome_do_Metodo__c = 'Insert Contatos do inserirContatosOportunidadeProdutosAlelo';
					lstLogs.add(log);
				}
			}
		}

		List<Database.SaveResult> srListCO = Database.insert(lstContatosOperacional, false);
		for (Integer i = 0;i<srListCO.size();i++) {
			Database.SaveResult sr = srListCO.get(i);
			if (!sr.isSuccess()) {
				Contact con = lstContatosOperacional.get(i);
				if (con.Bairro__c != 'remove me') {
					Id impId = mapCNPJToId.get(con.Account.CPF_CNPJ__c);
					setIdErrors.add(impId);
					Log__c log = new Log__c();
					log.Descricao__c = JSON.serialize(sr.getErrors());
					log.Nome_da_Classe__c = 'BatchImplantacao';
					log.Nome_do_Metodo__c = 'Insert ContatosOperacional do inserirContatosOportunidadeProdutosAlelo';
					lstLogs.add(log);
				}
			}
		}


		for (Integer i = 0;i<lstImplantacao.size();i++) {
			Implantacao__c item = lstImplantacao.get(i);

			if (setIdErrors.contains(item.Id))
				continue;

			try {

				lstOportunidades.add(convertImplantacaoToOpportunity(item, lstContatos.get(i),
						lstContatosOperacional.get(i)));

			} catch (Exception e) {
				setIdErrors.add(item.Id);
				Log__c log = new Log__c();
				log.Descricao__c = e.getMessage() +' | '+ e.getStackTraceString();
				log.Nome_da_Classe__c = 'BatchImplantacao';
				log.Nome_do_Metodo__c = 'convertImplantacaoToOpportunity';
				lstLogs.add(log);
				lstOportunidades.add(new Opportunity(Campanha__c = 'remove me'));
			}
		}

		List<Database.SaveResult> srListO = Database.insert(lstOportunidades, false);
		for (Integer i = 0;i<srListO.size();i++) {
			Database.SaveResult sr = srListO.get(i);
			if (!sr.isSuccess()) {
				Opportunity opp = lstOportunidades.get(i);
				if (opp.Campanha__c != 'remove me') {
					Id impId = mapCNPJToId.get(opp.Account.CPF_CNPJ__c);
					setIdErrors.add(impId);
					Log__c log = new Log__c();
					log.Descricao__c = JSON.serialize(sr.getErrors());
					log.Nome_da_Classe__c = 'BatchImplantacao';
					log.Nome_do_Metodo__c = 'Insert Oportunidades do inserirContatosOportunidadeProdutosAlelo';
					lstLogs.add(log);
				}
			}
		}

		for (Integer i = 0;i<lstImplantacao.size();i++) {
			Implantacao__c item = lstImplantacao.get(i);

			if (setIdErrors.contains(item.Id))
				continue;

			try{
				lstProdutosAlelo.add(convertImplantacaoToProdutoAlelo(item, lstOportunidades.get(i)));
			} catch (Exception e){
				setIdErrors.add(item.Id);
				Log__c log = new Log__c();
				log.Descricao__c = e.getMessage() +' | '+ e.getStackTraceString();
				log.Nome_da_Classe__c = 'BatchImplantacao';
				log.Nome_do_Metodo__c = 'convertImplantacaoToProdutoAlelo';
				lstLogs.add(log);
				lstProdutosAlelo.add(new Produtos_Alelo__c(Name = 'remove me'));
			}
		}

		List<Database.UpsertResult> srListPA = Database.upsert(lstProdutosAlelo, Produtos_Alelo__c.Numero_do_Contrato__c, false);

		for (Integer i = 0;i<srListPA.size();i++) {
			Database.UpsertResult sr = srListPA.get(i);
			if (!sr.isSuccess()) {
				Produtos_Alelo__c produtosAlelo = lstProdutosAlelo.get(i);
				if (produtosAlelo.Name != 'remove me') {
					Id impId = mapCNPJToId.get(produtosAlelo.Oportunidade__r.Account.CPF_CNPJ__c);
					System.debug('impId: '+impId);
					setIdErrors.add(impId);
					Log__c log = new Log__c();
					log.Descricao__c = JSON.serialize(sr.getErrors());
					log.Nome_da_Classe__c = 'BatchImplantacao';
					log.Nome_do_Metodo__c = 'convertImplantacaoToProdutoAlelo';
					lstLogs.add(log);
				}
			}
		}

		for (Integer i = 0;i<lstImplantacao.size();i++) {
			Implantacao__c imp = lstImplantacao.get(i);
			if (setIdErrors.contains(imp.Id)) {
				lstImplantacao.remove(i);
				lstRetry.add(imp);
			}
		}

		//lstImplantacao é um ponteiro, logo os valores removidos aqui refletirão na chamada do próximo método

	}


	public Account convertImplantacaoToAccount(Implantacao__c implatacao)
	{
		Account objAccount = new Account();
		objAccount.Bairro__c = implatacao.Bairro__c;
		objAccount.BillingCity = implatacao.BillingCity__c;
		objAccount.BillingPostalCode = implatacao.Estado_Provincia_de_entrega__c;
		objAccount.CPF_CNPJ__c = implatacao.CPF_CNPJ__c;
		objAccount.Numero__c = implatacao.Numero__c;
		objAccount.Phone = implatacao.Phone__c;
		objAccount.Name = implatacao.Razao_Social__c;
		objAccount.BillingStreet = implatacao.Rua_de_entrega__c;
		objAccount.Telefone2__c = implatacao.Telefone_2__c;

		return objAccount;
	}

	public Contact convertImplantacaoToContact(Implantacao__c implatacao)
	{
		Contact objContact = new Contact();

		objContact.Account = new Account(CPF_CNPJ__c = implatacao.CPF_CNPJ__c);
		objContact.LastName = implatacao.LastName__c;
		objContact.DDDCelular__c = implatacao.DDDCelular__c;
		objContact.dddfax__c = implatacao.dddfax__c;
		objContact.DDD__c = implatacao.DDD__c;
		objContact.DDDResidencial__c = implatacao.DDDRedidencial__c;
		objContact.Email = implatacao.Email__c;
		objContact.Fax = implatacao.Fax__c;
		objContact.Ramal__c = implatacao.Ramal__c;
		objContact.Telefone__c = implatacao.Telefone__c;
		objContact.Tipo__c = implatacao.Tipo__c;
		objContact.Telefone_Residencial__c = implatacao.Telefone_Residencial__c;

		return objContact;
	}

	public Contact convertImplantacaoToContactOperacional(Implantacao__c implatacao)
	{
		Contact objContact = new Contact();

		objContact.Account = new Account(CPF_CNPJ__c = implatacao.CPF_CNPJ__c);

		objContact.LastName = implatacao.Interlocutor_Operacao__c;
		objContact.Celular__c = implatacao.Celular_Operacional__c;
		objContact.DDDCelular__c = implatacao.DDDCelular_Operacional__c;
		objContact.dddfax__c = implatacao.dddfax_Operacional__c;
		objContact.DDD__c = implatacao.DDD_Operacional__c;
		objContact.DDDResidencial__c = implatacao.DDDRedidencial__c;
		objContact.Email = implatacao.Email_Operacional__c;
		objContact.Fax = implatacao.Fax_Operacional__c;
		objContact.Ramal__c = implatacao.Ramal_Operacional__c;
		objContact.Tipo__c = 'Operacional';
		objContact.Telefone__c = implatacao.Telefone_Operacional__c;
		objContact.Telefone_Residencial__c = implatacao.Telefone_Residencial_Operacional__c;

		return objContact;
	}

	public Opportunity convertImplantacaoToOpportunity(Implantacao__c implatacao,
															  Contact contato,
															  Contact contatoOperacional)
	{
		Opportunity objOpportunity = new Opportunity();
		objOpportunity.Canal_de_Venda__c = implatacao.Canal_de_Venda__c;
		objOpportunity.Cobranca__c = implatacao.Cobranca__c;
		objOpportunity.Data_do_Cadastamento__c = implatacao.Data_do_Cadastramento__c;
		objOpportunity.Data_da_Auditoria__c =
				Datetime.newInstance(implatacao.Data_do_Cadastramento__c, Time.newInstance(9, 0, 0, 0));
		objOpportunity.Data_do_Mailing__c = implatacao.Data_do_Mailing__c;
		objOpportunity.DDDVendedor__c = implatacao.DDDVendedor__c;
		objOpportunity.Entrega__c = implatacao.Entrega__c;
		objOpportunity.Nome_do_Vendedor__c = implatacao.Nome_do_Vendedor__c;
		objOpportunity.Operacao__c = implatacao.Operacao__c;
		objOpportunity.Sistema_de_Pedidos__c = implatacao.Sistema_de_Pedidos__c;
		objOpportunity.Status__c = implatacao.Status__c;
		objOpportunity.TelefoneVendedor__c = implatacao.Telefone_Vendedor__c;
		objOpportunity.Usuarios__c = implatacao.Usuarios__c;
		objOpportunity.Ramal__c = implatacao.VendedorRamal__c;
		objOpportunity.CloseDate = implatacao.Data_do_Cadastramento__c;
		objOpportunity.StageName = 'Auditoria Finalizada/ Transf Implantação';
		objOpportunity.Campanha__c = 'Mailing Implantação';
		objOpportunity.Id_da_Campanha__c = implatacao.IdCampanha__c;
		objOpportunity.Telefone_Decisor__c = implatacao.DDD__c + implatacao.Phone__c;
		objOpportunity.Telefone_Operacional__c = implatacao.DDD_Operacional__c + implatacao.Telefone_Operacional__c;

		objOpportunity.Account = new Account(CPF_CNPJ__c = implatacao.CPF_CNPJ__c);
		objOpportunity.Name = Date.Today() + ' - ' + implatacao.Razao_Social__c;
		objOpportunity.Contato_da_oportunidade__c = contato.Id;

		if (implatacao.Interlocutor_Operacao__c != null)
		{
			objOpportunity.Contato_da_oportunidade_2__c = contatoOperacional.Id;
		}

		return objOpportunity;
	}

	public Produtos_Alelo__c convertImplantacaoToProdutoAlelo(Implantacao__c implatacao,
																	 Opportunity oportunidade)
	{
		Produtos_Alelo__c objProdutosAlelo = new Produtos_Alelo__c();

		objProdutosAlelo.Oportunidade__c = oportunidade.Id;
		objProdutosAlelo.Agencia_Debito_em_Conta__c = implatacao.Agencia_Debito_em_Conta__c;
		objProdutosAlelo.Agencia_Digito__c = Util.StringValueOf(implatacao.Agencia_Digito__c);
		objProdutosAlelo.Banco__c = getnameBank(implatacao.Banco__c);
		objProdutosAlelo.Banco_Debito_em_Conta__c = implatacao.Banco_Debito_em_Conta__c;
		objProdutosAlelo.Data_Hora_Auditoria__c =
				Datetime.newInstance(implatacao.Data_do_Cadastramento__c, Time.newInstance(9, 0, 0, 0));
		objProdutosAlelo.Faturamento__c = implatacao.Faturamento__c;
		objProdutosAlelo.Faturamento_Previsto_Implantacao__c = implatacao.Faturamento_Previsto_Implantacao__c;
		objProdutosAlelo.Forma_de_Pagamento__c = implatacao.Forma_de_Pagamento__c;
		objProdutosAlelo.Name = implatacao.Nome_de_Produto_Alelo__c;
		objProdutosAlelo.Numero_do_Contrato__c = implatacao.Numero_do_Contrato__c;

		objProdutosAlelo.Valor_Total__c = implatacao.Faturamento__c;


		return objProdutosAlelo;
	}

	public String getnameBank(String numberBank) {
		if (numberBank == '1')
			return 'Banco do Brasil';
		else if (numberBank == '33')
			return 'Santander';
		else if (numberBank == '237')
			return 'Bradesco';
		else if (numberBank == '724')
			return 'Porto Seguro';
		else
			return '';
	}
}
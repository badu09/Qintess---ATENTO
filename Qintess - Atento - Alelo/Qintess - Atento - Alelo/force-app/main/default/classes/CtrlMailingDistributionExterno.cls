public with sharing class CtrlMailingDistributionExterno {
	public List<Mailing_Distribution__c> lMailingDistribution {
		get; set;
	}
	public Map<String, String> mGroup {
		get; set;
	}
	public String identificacaoFiltro {
		get; set;
	}

	public Integer linha {
		get; set;
	}

	private integer counter = 0;
	private integer listSize = 50;
	public integer totalSize;

	public CtrlMailingDistributionExterno() {
		init();
	}

	public void init() {
		getMailingDistributions();
	}

	public void getMailingDistributions() {
		if (identificacaoFiltro != null && identificacaoFiltro != '') {
			totalSize = [select count() from Mailing_Distribution__c WHERE Identificacao__c = :identificacaoFiltro];
			this.lMailingDistribution =
					DAOMailingDistribution.getMailingDistributionPagination(listSize, counter, identificacaoFiltro);
		} else {
			totalSize = [select count() from Mailing_Distribution__c];
			this.lMailingDistribution = DAOMailingDistribution.getMailingDistributionPagination(listSize, counter);
		}
	}

	public SelectOption[] getIdentificacoes() {
		List<SelectOption> retorno = new List<SelectOption>();
		retorno.add(new SelectOption('', 'Sem Seleção'));
		for (AggregateResult ident : [SELECT Identificacao__c FROM Mailing_Distribution__c GROUP BY Identificacao__c]) {
			String value = (String) ident.get('Identificacao__c');
			if (value != null) {
				retorno.add(new SelectOption(value, value));
			}
		}
		return retorno;
	}

	public List<SelectOption> getItems() {

		this.mGroup = new Map<String, String>();

		List<SelectOption> options = new List<SelectOption>();

		options.add(new SelectOption('', 'Sem seleção'));

		for (Group grupo : DAOGroup.getGroup()) {
			this.mGroup.put(grupo.Name, grupo.Id);
			options.add(new SelectOption(grupo.Name, grupo.Name));
		}

		return options;
	}

	public void save() {
		try {
			Id idBatch;

			Mailing_Distribution__c mailingDistribution = this.lMailingDistribution[this.linha];

			mailingDistribution.Status_Fila__c = 'Em processamento';
			mailingDistribution.Id_fila__c = this.mGroup.get(mailingDistribution.Fila__c);
			if (mailingDistribution.Id_fila__c != null)
			{
				mailingDistribution.DataFila__c = Date.today();
			}

			update mailingDistribution;

			if (mailingDistribution.Identificacao__c.equalsIgnoreCase('lead')) {

				BatchMailingDistribution batchMailingDistribution =
						new BatchMailingDistribution(mailingDistribution.Id);

				idBatch = Database.executeBatch(batchMailingDistribution, 50);
			} else if (mailingDistribution.Identificacao__c.equalsIgnoreCase('implantação')) {

				BatchMailingDistributionPedido batchMailingDistributionPedido =
						new BatchMailingDistributionPedido(mailingDistribution.Id);

				idBatch = Database.executeBatch(batchMailingDistributionPedido, 50);
			}

			system.debug('idBatch: ' + idBatch);

			ApexPages.addmessage(
					new ApexPages.message(ApexPages.severity.CONFIRM, 'Processo de atribuição iniciado com sucesso.'));

		} catch (Exception e) {
			System.debug(e + '\n' + e.getStackTraceString());
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro na atualização.'));
		}
	}

	public void enviarMailing() {
		try {

			Mailing_Distribution__c mailingDistribution = this.lMailingDistribution[this.linha];

			mailingDistribution.Status_Discador__c = 'Em processamento';
			mailingDistribution.DataDiscador__c = Date.today();

			if (mailingDistribution.Identificacao__c.equalsIgnoreCase('lead')) {
				BatchMailingOlos batchMailingOlos = new BatchMailingOlos(mailingDistribution.Id);

				Id idBatch = Database.executeBatch(batchMailingOlos, 50000);

				system.debug(idBatch);
			} else if (mailingDistribution.Identificacao__c.equalsIgnoreCase('implantação')) {

				BatchMailingOlosPedido batchMailingOlosPedido = new BatchMailingOlosPedido(mailingDistribution.Id);

				Id idBatch = Database.executeBatch(batchMailingOlosPedido, 50000);

				system.debug(idBatch);
			}

			// List<String> lMailing = new List<String>();

			// if(mailingDistribution.Identificacao__c.equalsIgnoreCase('lead')) {
			// 	String query = 'SELECT Id, Phone, Telefone2__c, Telefone3__c, Telefone4__c, Telefone5__c, Nome_da_Campanha__c, Sub_Campanha__c, CNPJ__c, Name, Id_da_Campanha__c FROM Lead WHERE IsConverted = false AND Id_da_Campanha__c = \'' + mailingDistribution.Id_Campanha__c + '\'';
			//
			//
			// 	for(Lead lead : Database.query(query)) {
			//     	lMailing.add(lead.Id + ';' +
			// 		                    Util.StringValueOf(lead.CNPJ__c) + ';' +
			// 		                    Util.StringValueOf(lead.Id_da_Campanha__c) + ';' +
			// 		                    Util.StringValueOf(lead.Name) + ';' +
			// 		                    Util.StringValueOf(lead.Phone).replace(' ', '') + ';' +
			// 		                    Util.StringValueOf(lead.Telefone2__c).replace(' ', '') + ';' +
			// 		                    Util.StringValueOf(lead.Telefone3__c).replace(' ', '') + ';' +
			// 		                    Util.StringValueOf(lead.Telefone4__c).replace(' ', '') + ';' +
			// 		                    Util.StringValueOf(lead.Telefone5__c).replace(' ', '') + ';');
			//  	}
			//
			// }
			// else if(mailingDistribution.Identificacao__c.equalsIgnoreCase('implantação')) {
			// 	String query = 'SELECT Id, Contato_da_oportunidade__c, Account.CPF_CNPJ__c, Telefone_Decisor__c, Telefone_Operacional__c, Id_da_Campanha__c, (Select Id From Orders LImit 1) FROM Opportunity WHERE Id_da_Campanha__c = \'' + mailingDistribution.Id_Campanha__c + '\'';
			//
			// 	for(Opportunity opp : Database.query(query)) {
			// 		lMailing.add(opp.Orders[0].Id + ';' +
			//                     Util.StringValueOf(opp.Account.CPF_CNPJ__c) + ';' +
			//                     Util.StringValueOf(opp.Id_da_Campanha__c) + ';' +
			//                     Util.StringValueOf(opp.Contato_da_oportunidade__c) + ';' +
			//                     Util.StringValueOf(opp.Telefone_Decisor__c).replace(' ', '') + ';' +
			//                     Util.StringValueOf(opp.Telefone_Operacional__c).replace(' ', '') + ';;;;');
			//  	}
			//
			// }
			// system.debug('this.lMailing: ' + lMailing.size());

			// BOMailing.enviar(lMailing, mailingDistribution.Id);

			update mailingDistribution;

			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,
					'Processo de envio de mailing iniciado com sucesso.'));
		} catch (Exception e) {
			System.debug(e + '\n' + e.getStackTraceString());
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro na atualização.'));
		}
	}

	public void atualizarMailing() {
		init();
	}

	public PageReference Beginning() {
		counter = 0;
		getMailingDistributions();
		return null;
	}

	public PageReference Previous() {
		counter -= listSize;
		getMailingDistributions();
		return null;
	}

	public PageReference Next() {
		counter += listSize;
		getMailingDistributions();
		return null;
	}

	public PageReference End() {
		counter = totalSize - math.mod(listSize, totalSize);
		getMailingDistributions();
		return null;
	}

	public Boolean getDisablePrevious() {
		if (counter > 0) return false; else return true;
	}

	public Boolean getDisableNext() {
		if (counter + listSize < totalSize) return false; else return true;
	}

	public Integer gettotalSize() {
		return totalSize;
	}

	public Integer getPageNumber() {
		return counter / listSize + 1;
	}

	public Integer getTotalPages() {
		if (math.mod(totalSize, listSize) > 0) {
			return totalSize / listSize + 1;
		} else {
			return (totalSize / listSize);
		}
	}

}
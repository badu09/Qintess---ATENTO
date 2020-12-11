public with sharing class CtrlMailingDistributionInterno {
	public List<Mailing_Distribution__c> lMailingDistribution { get; set; }
	public List<Report> lReport { get; set; }
	public Map<ID, Report> mReport { get; set; }
	public Map<String, String> mGroup { get; set; }
	public String identificacaoFiltro { get; set; }
	public Id reportSelecionado { get; set; }

	public Integer linha { get; set; }

	private integer counter=0;
	private integer listSize=50;
	public integer totalSize;
	
	public CtrlMailingDistributionInterno() {
		totalSize = [select count() from Mailing_Distribution__c];
		init();
	}

	public void init() {
		getMailingDistributions();
		lReport = DAOReport.getReportByFolder('Mailing Distribution Interno');
		mReport = new Map<Id, Report>(lReport);
	}
	
	public void carregar() {
		if(mReport.containsKey(reportSelecionado)) {
			Report relatorio = mReport.get(reportSelecionado);
			Mailing_Distribution__c mailing = new Mailing_Distribution__c();
			// mailing.Id_Campanha__c = lead.Id_da_Campanha__c.trim();
			// mailing.Name = lead.Nome_da_Campanha__c;
		}
		
	}
	
	public void getReportResult() {
		
	}
	
	public Mailing_Distribution__c[] getMailingDistributions() {
		if(identificacaoFiltro != null && identificacaoFiltro != '') {
			this.lMailingDistribution = DAOMailingDistribution.getMailingDistributionPagination(listSize, counter, identificacaoFiltro);
		}
		else {
			this.lMailingDistribution = DAOMailingDistribution.getMailingDistributionPagination(listSize, counter);
		}
		return this.lMailingDistribution;
	}
	
	public SelectOption[] getReportNames() {
		List<SelectOption> retorno = new List<SelectOption>();
		retorno.add(new SelectOption('', 'Sem Seleção'));
		for(Report rep : lReport) {
			retorno.add(new SelectOption(rep.Id, rep.Name));
		}
		return retorno;
	}

	public List<SelectOption> getItems() {
		
		this.mGroup = new Map<String, String>();
		
		List<SelectOption> options = new List<SelectOption>();
		
		options.add(new SelectOption('', 'Sem seleção'));
		
		for(Group grupo : DAOGroup.getGroup()) {
			this.mGroup.put(grupo.Name, grupo.Id);
			options.add(new SelectOption(grupo.Name, grupo.Name));
		}
		
		return options;
	}
	
	public void save() {
		try {
			
			Mailing_Distribution__c mailingDistribution = this.lMailingDistribution[this.linha];
			
			mailingDistribution.Status_Fila__c = 'Em processamento';
			mailingDistribution.Id_fila__c = this.mGroup.get(mailingDistribution.Fila__c);
			
			update mailingDistribution;
			
			BatchMailingDistribution batchMailingDistribution = new BatchMailingDistribution(mailingDistribution.Id);

		    Id idBatch = Database.executeBatch(batchMailingDistribution, 50);
			
			system.debug(idBatch);
			
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Processo de atribuição iniciado com sucesso.'));
			
		}
		catch(Exception e) {
			System.debug(e + '\n' + e.getStackTraceString());
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro na atualização.'));
		}
	}
	
	public void enviarMailing() {
		try {
			
			Mailing_Distribution__c mailingDistribution = this.lMailingDistribution[this.linha];
			
			mailingDistribution.Status_Discador__c = 'Em processamento';
			
			update mailingDistribution;
			
			//BatchMailingOlos batchMailingOlos = new BatchMailingOlos(mailingDistribution.Id);

		    //Id idBatch = Database.executeBatch(batchMailingOlos, 50000);
			
			//system.debug(idBatch);
			
			String query = 'SELECT Id, Phone, Telefone2__c, Telefone3__c, Telefone4__c, Telefone5__c, Nome_da_Campanha__c, Sub_Campanha__c, CNPJ__c, Name, Id_da_Campanha__c FROM Lead WHERE IsConverted = false AND Id_da_Campanha__c = \'' + mailingDistribution.Id_Campanha__c + '\'';
			
			List<String> lMailing = new List<String>();
    	
	    	for(Lead lead : Database.query(query)) {
		    	lMailing.add(lead.Id + ';' +
				                    Util.StringValueOf(lead.CNPJ__c) + ';' +
				                    Util.StringValueOf(lead.Id_da_Campanha__c) + ';' +
				                    Util.StringValueOf(lead.Name) + ';' +
				                    Util.StringValueOf(lead.Phone).replace(' ', '') + ';' +
				                    Util.StringValueOf(lead.Telefone2__c).replace(' ', '') + ';' +
				                    Util.StringValueOf(lead.Telefone3__c).replace(' ', '') + ';' +
				                    Util.StringValueOf(lead.Telefone4__c).replace(' ', '') + ';' +
				                    Util.StringValueOf(lead.Telefone5__c).replace(' ', '') + ';');
		 	}
		 	
		 	system.debug('this.lMailing: ' + lMailing.size());
			
			BOMailing.enviar(lMailing, mailingDistribution.Id);
			
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Processo de envio de mailing iniciado com sucesso.'));			
		}
		catch(Exception e) {
			System.debug(e + '\n' + e.getStackTraceString());
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro na atualização.'));
		}
	}
	
	public void atualizarMailing() {
		init();
	}

   public PageReference Beginning() {
      counter = 0;
      return null;
   }

   public PageReference Previous() {
      counter -= listSize;
      return null;
   }

   public PageReference Next() {
      counter += listSize;
      return null;
   }

   public PageReference End() {
      counter = totalSize - math.mod(listSize, totalSize);
      return null;
   }

   public Boolean getDisablePrevious() {
      if (counter>0) return false; else return true;
   }

   public Boolean getDisableNext() {
      if (counter + listSize < totalSize) return false; else return true;
   }

   public Integer gettotalSize() {
      return totalSize;
   }

   public Integer getPageNumber() {
      return counter/listSize + 1;
   }

   public Integer getTotalPages() {
      if (math.mod(totalSize, listSize) > 0) {
         return totalSize/listSize + 1;
      } else {
         return (totalSize/listSize);
      }
   }
}
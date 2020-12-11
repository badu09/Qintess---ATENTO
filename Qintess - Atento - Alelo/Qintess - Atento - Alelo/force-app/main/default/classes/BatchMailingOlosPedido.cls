global class BatchMailingOlosPedido  implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    private Mailing_Distribution__c mailingDistribution {get;set;}
    
    global BatchMailingOlosPedido(Id idMailingDistribution) {
    	this.mailingDistribution = DAOMailingDistribution.obterMailingDistribution(idMailingDistribution);
    }  
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    	
    	String query = 'SELECT Id, Account.CPF_CNPJ__c, Telefone_Decisor__c, Telefone_Operacional__c, Id_da_Campanha__c, Name, (Select Id From Orders LImit 1) FROM Opportunity WHERE Id_da_Campanha__c = \'' + this.mailingDistribution.Id_Campanha__c + '\'';
    	
    	return Database.getQueryLocator(query);
    }

	global void execute(Database.BatchableContext BC, List<Opportunity> scope) {

		List<String> lMailing = new List<String>();
		String retorno;

		if (scope != null && scope.size() > 0) {

			for (Opportunity opp : scope) {
				lMailing.add(opp.Orders[0].Id + ';' +
						Util.StringValueOf(opp.Account.CPF_CNPJ__c) + ';' +
						Util.StringValueOf(opp.Id_da_Campanha__c) + ';' +
						Util.StringValueOf(opp.Name) + ';' +
						Util.StringValueOf(opp.Telefone_Decisor__c).replace(' ', '') + ';' +
						Util.StringValueOf(opp.Telefone_Operacional__c).replace(' ', '') + ';;;;');
			}

			system.debug('this.lMailing: ' + lMailing.size());

			Boolean partialMailing = true;

			String mailingName = this.mailingDistribution.Id_Campanha__c;

			WSMailingCommand.WSMailingCommandSoap service = new WSMailingCommand.WSMailingCommandSoap();

			service.timeout_x = 120000;

			WSMailingCommand.ArrayOfString mailingString = new WSMailingCommand.ArrayOfString();

			mailingString.string_x = lMailing;

			retorno = service.ImportMailing(mailingName, mailingString, partialMailing);
		} else {
			retorno = 'Não existe Oportunidades para esse Mailing';
		}

		this.mailingDistribution.Retorno_Discador__c = retorno;

		update this.mailingDistribution;
	}
	
	global void finish(Database.BatchableContext BC){Boolean partialMailing = true; 
	    
	    String mailingName = this.mailingDistribution.Id_Campanha__c;
	    
		WSMailingCommand.WSMailingCommandSoap service = new WSMailingCommand.WSMailingCommandSoap();
    	
    	service.timeout_x = 120000;
    	
	    WSMailingCommand.ArrayOfString mailingString = new WSMailingCommand.ArrayOfString();
	    
	    mailingString.string_x = new List<String>();
	    
	    String retorno = service.ImportMailing(mailingName, mailingString, partialMailing);
		
		service.ImportMailing(mailingName, mailingString, false);

		if(retorno != null)
			this.mailingDistribution.Retorno_Discador__c = retorno;
		
		this.mailingDistribution.Status_Discador__c = 'Finalizado';
		
		update this.mailingDistribution;
	}
	
	private void carregar(Id idMailingDistribution) {
		this.mailingDistribution = DAOMailingDistribution.obterMailingDistribution(idMailingDistribution);
	}
}
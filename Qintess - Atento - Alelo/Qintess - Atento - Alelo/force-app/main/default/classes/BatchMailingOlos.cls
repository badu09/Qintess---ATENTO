global class BatchMailingOlos implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    private Mailing_Distribution__c mailingDistribution {get;set;}
    
    global BatchMailingOlos(Id idMailingDistribution) {
    	this.mailingDistribution = DAOMailingDistribution.obterMailingDistribution(idMailingDistribution);
    }  
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    	
    	String query = 'SELECT Id, Phone, Telefone2__c, Telefone3__c, Telefone4__c, Telefone5__c, Nome_da_Campanha__c, Sub_Campanha__c, CNPJ__c, Name, Id_da_Campanha__c FROM Lead WHERE IsConverted = false AND Id_da_Campanha__c = \'' + this.mailingDistribution.Id_Campanha__c + '\'';
    	
    	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
    	
    	List<String> lMailing = new List<String>();
		String retorno;

		if(scope != null && scope.size() > 0) {
			for (Lead lead : scope) {
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

			Boolean partialMailing = true;

			String mailingName = this.mailingDistribution.Id_Campanha__c;

			WSMailingCommand.WSMailingCommandSoap service = new WSMailingCommand.WSMailingCommandSoap();

			service.timeout_x = 120000;

			WSMailingCommand.ArrayOfString mailingString = new WSMailingCommand.ArrayOfString();

			mailingString.string_x = lMailing;

			retorno = service.ImportMailing(mailingName, mailingString, partialMailing);
		}
		else {
			retorno = 'Não existe Leads para esse Mailing';
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
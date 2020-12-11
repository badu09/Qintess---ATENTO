global class BatchMailingDistribution implements Database.Batchable<sObject> {
	
	private Mailing_Distribution__c mailingDistribution {get;set;}
    
    global BatchMailingDistribution(Id idMailingDistribution) {
    	carregar(idMailingDistribution);
    }  
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    	
    	String query = 'SELECT Id, OwnerId FROM Lead WHERE Id_da_Campanha__c = \'' + mailingDistribution.Id_Campanha__c + '\'';
    	
    	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
    	
    	for(Lead lead : scope) {
			lead.ownerId = this.mailingDistribution.Id_fila__c;
		}
		
		Database.update(scope, false);
	}
	
	global void finish(Database.BatchableContext BC){
		this.mailingDistribution.Status_Fila__c = 'Finalizado';
		
		update this.mailingDistribution;
	}
	
	private void carregar(Id idMailingDistribution) {
		this.mailingDistribution = DAOMailingDistribution.obterMailingDistribution(idMailingDistribution);
	}
}
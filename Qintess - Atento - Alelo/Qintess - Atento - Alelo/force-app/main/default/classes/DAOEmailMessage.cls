global without sharing class DAOEmailMessage {
    
    public static List<EmailMessage> listar() {
    	return [SELECT Id FROM EmailMessage];
    }
    
    @future
    public static void carregarLead(Id idPai, Id id)
    {
    	system.debug('idPai: ' + json.serialize(idPai));
    	system.debug('id: ' + json.serialize(id));
    	 
    	
    	//EmailMessage emailMessagePai = [SELECT Id, Lead__c FROM EmailMessage WHERE Id =:idPai];
    	//system.debug('emailMessagePai: ' + json.serialize(emailMessagePai));
    	
    	
    	EmailMessage emailMessage = [SELECT Id, Lead__c FROM EmailMessage WHERE Id =:id];
    	system.debug('emailMessage: ' + json.serialize(emailMessage));    	
    }		
}
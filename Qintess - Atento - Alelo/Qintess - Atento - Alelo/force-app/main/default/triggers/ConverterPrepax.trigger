trigger ConverterPrepax on Prepax__c (after insert) {

    try{
    	system.debug('Inicio: ConverterPrepax');
    	
		BOPrepax.convertPrepax(Trigger.new);
		
		system.debug('Fim: ConverterPrepax');
    } catch(Exception ex) {
    	
    	for(Prepax__c prepax : Trigger.new) {
    		prepax.addError('Ocorreu um erro ao converter Prepax. ' + ex.getMessage());	
    	} 
    	
        System.debug('Exception: ' + ex.getStackTraceString() + ' - Message: ' + ex.getMessage());
    }
}
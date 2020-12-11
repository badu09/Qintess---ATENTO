trigger GerarMailingDistributionImplantacao on Implantacao__c (after insert) {
	
	Set<String> setIdCampanha = new Set<String>();
	List<Mailing_Distribution__c> lMailingDistribution = new List<Mailing_Distribution__c>();
	
    for(Implantacao__c impl : Trigger.new) {
    	
    	if(impl.IdCampanha__c != null &&
    		impl.IdCampanha__c != '' &&
    		!setIdCampanha.contains(impl.IdCampanha__c)) {
    	
    			Mailing_Distribution__c mailing = new Mailing_Distribution__c();
    			mailing.Id_Campanha__c = impl.IdCampanha__c.trim();
    			mailing.Name = impl.Nome_da_Campanha__c;
    			mailing.Identificacao__c = 'Implantação';
				mailing.DataCarga__c = Date.today();
   
    			lMailingDistribution.add(mailing);
    			setIdCampanha.add(impl.IdCampanha__c.trim());
    		}
    }
    
    if(!lMailingDistribution.isEmpty()) {
    	Database.upsert(lMailingDistribution, Mailing_Distribution__c.fields.Id_Campanha__c);
    }
    
}
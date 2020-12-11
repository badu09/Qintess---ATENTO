trigger GerarMailingDistribution on Lead (after insert) {

	Set<String> setIdCampanha = new Set<String>();
	List<Mailing_Distribution__c> lMailingDistribution = new List<Mailing_Distribution__c>();

	for (Lead lead : Trigger.new) {

		if (lead.Id_da_Campanha__c != null &&
						lead.Id_da_Campanha__c != '' &&
				!setIdCampanha.contains(lead.Id_da_Campanha__c)) {

			Mailing_Distribution__c mailing = new Mailing_Distribution__c();
			mailing.Id_Campanha__c = lead.Id_da_Campanha__c.trim();
			mailing.Name = lead.Nome_da_Campanha__c;
			mailing.Identificacao__c = 'Lead';
			mailing.DataCarga__c = Date.today();

			lMailingDistribution.add(mailing);
			setIdCampanha.add(lead.Id_da_Campanha__c.trim());
		}
	}

	if (!lMailingDistribution.isEmpty()) {
		Database.upsert(lMailingDistribution, Mailing_Distribution__c.fields.Id_Campanha__c);
	}
}
public class DAOMailingDistribution {
	public static List<Mailing_Distribution__c> getMailingDistribution() {
		return [SELECT 
					Id, 
					Name, 
					Ativo__c, 
					Fila__c,
					Habilita_Discador__c,
					Id_Campanha__c,
					Id_fila__c,
					Status_Discador__c,
					Status_Fila__c,
					Retorno_Discador__c,
					Canal__c,
					DataFila__c,
					DataDiscador__c,
					DataCarga__c,
					Name__c,
					Identificacao__c
				FROM 
					Mailing_Distribution__c];
	}
	
	public static List<Mailing_Distribution__c> getMailingDistributionPagination(Integer sizeList, Integer counter, String identificacao) {
		return [SELECT 
					Id, 
					Name, 
					Ativo__c, 
					Fila__c,
					Habilita_Discador__c,
					Id_Campanha__c,
					Id_fila__c,
					Status_Discador__c,
					Status_Fila__c,
					Retorno_Discador__c,
					Canal__c,
					DataFila__c,
					DataDiscador__c,
					DataCarga__c,
					Name__c,
					Identificacao__c
				FROM 
					Mailing_Distribution__c
				WHERE
					Identificacao__c = :identificacao
				ORDER BY
					DataCarga__c DESC
				LIMIT :sizeList
				OFFSET :counter];
	}
	
	public static List<Mailing_Distribution__c> getMailingDistributionPagination(Integer sizeList, Integer counter) {
		return [SELECT 
					Id, 
					Name, 
					Ativo__c, 
					Fila__c,
					Habilita_Discador__c,
					Id_Campanha__c,
					Id_fila__c,
					Status_Discador__c,
					Status_Fila__c,
					Retorno_Discador__c,
					Canal__c,
					DataFila__c,
					DataDiscador__c,
					DataCarga__c,
					Name__c,
					Identificacao__c
				FROM 
					Mailing_Distribution__c
				ORDER BY
					DataCarga__c DESC
				LIMIT :sizeList
				OFFSET :counter];
	}
	
	public static Mailing_Distribution__c obterMailingDistribution(Id id) {
		return [SELECT 
					Id, 
					Name, 
					Ativo__c, 
					Fila__c,
					Habilita_Discador__c,
					Id_Campanha__c,
					Id_fila__c,
					Status_Discador__c,
					Status_Fila__c,
					Retorno_Discador__c,
					Canal__c,
					DataFila__c,
					DataDiscador__c,
					DataCarga__c,
					Name__c,
					Identificacao__c
				FROM 
					Mailing_Distribution__c
				WHERE
					Id =: id];
	}
}
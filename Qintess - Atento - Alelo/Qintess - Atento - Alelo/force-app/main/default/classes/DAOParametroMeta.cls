public class DAOParametroMeta {
	public static List<ParametroMeta__c> getParametroMeta(Integer mes, Integer ano) {
		Date inicio = Date.newInstance(ano, mes, 1);
		Date fim = Date.newInstance(ano, mes+1, 1).addDays(-1);
		return [SELECT Id,
					DataReferencia__c,
					Desdobramento__c,
					Desdobramento__r.Name,
					Representacao__c,
					MetaGlobal__c,
					Qtd_de_Operador__c,
					Ativo__c,
					Qtd_Supervisor__c,
					Valor_Meta_Operador__c,
					Valor_Meta_Supervisor__c,
					Qtd_de_Contratos__c,
					Qtd_Contratos_Operador__c,
					Qtd_Contratos_Supervisor__c
				FROM ParametroMeta__c
				WHERE DataReferencia__c >= :inicio
		AND DataReferencia__c <= :fim];
	}

	public static List<ParametroMeta__c> getParametroMeta(Integer mes, Integer ano, String area) {
		Date inicio = Date.newInstance(ano, mes, 1);
		Date fim = Date.newInstance(ano, mes+1, 1).addDays(-1);
		return [SELECT Id,
					DataReferencia__c,
					Desdobramento__c,
					Desdobramento__r.Name,
					Representacao__c,
					MetaGlobal__c,
					Ativo__c,
					Qtd_de_Operador__c,
					Qtd_Supervisor__c,
					Valor_Meta_Operador__c,
					Valor_Meta_Supervisor__c,
					Qtd_de_Contratos__c,
					Qtd_Contratos_Operador__c,
					Qtd_Contratos_Supervisor__c
				FROM ParametroMeta__c
				WHERE DataReferencia__c >= :inicio
		AND DataReferencia__c <= :fim
		AND Desdobramento__r.Area__c = :area];
	}
}
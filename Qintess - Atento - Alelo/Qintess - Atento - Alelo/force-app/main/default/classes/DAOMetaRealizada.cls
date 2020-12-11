public class DAOMetaRealizada {
	public static void limpaMesMetaRealizada(Integer mes, Integer ano) {
		Date inicio = Date.newInstance(ano, mes, 1);
		Date fim = Date.newInstance(ano, mes + 1, 1).addDays(-1);
		delete [SELECT Id FROM MetaRealizada__c WHERE CreatedDate >= :inicio AND CreatedDate <= :fim];
	}
}
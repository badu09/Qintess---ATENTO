public class DAODesdobramento {
	public static List<Desdobramento__c> getAll() {
		return [SELECT Id, Name, Area__c, CreatedDate, Ativo__c FROM Desdobramento__c];
	}

	public static List<Desdobramento__c> getByRecordType(String tipoRegistro) {
		return [SELECT Id, Name, Area__c, CreatedDate, Ativo__c FROM Desdobramento__c WHERE RecordTypeId = :tipoRegistro];
	}

	public static List<Desdobramento__c> getByArea(String area) {
		return [SELECT Id, Name, Area__c, CreatedDate, Ativo__c FROM Desdobramento__c WHERE Area__c = :area];
	}
	
	public static Desdobramento__c getById(Id id) {
		return [SELECT Id, Name, Area__c, CreatedDate, Ativo__c FROM Desdobramento__c WHERE Id = :id];
	}
}
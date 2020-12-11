public with sharing class DAODesdobramentoUsuario {
    public static List<Desdobramento_Usuario__c> getByDesdobramentoSupervisor(Id idDesdobramento, Id idSupervisor) {
		List<Desdobramento_Usuario__c> listDesdobramentoUsuario = null;
		
		listDesdobramentoUsuario = [SELECT 
										Id,
										Desdobramento__c,
										Desdobramento__r.Name,
										Supervisor__r.Id,
										Supervisor__r.Name,
										Operador__r.Id,
										Operador__r.Name
									FROM 
										Desdobramento_Usuario__c 
									WHERE
										Desdobramento__c =:idDesdobramento
									AND
										Supervisor__c = :idSupervisor];
										
		return listDesdobramentoUsuario;
	}
	
	public static List<Desdobramento_Usuario__c> getByDesdobramento(Id idDesdobramento) {
		List<Desdobramento_Usuario__c> listDesdobramentoUsuario = null;
		
		listDesdobramentoUsuario = [SELECT 
										Id,
										Desdobramento__c,
										Desdobramento__r.Name,
										Supervisor__r.Id,
										Supervisor__r.Name,
										Operador__r.Id,
										Operador__r.Name,
										CreatedDate
									FROM 
										Desdobramento_Usuario__c 
									WHERE
										Desdobramento__r.Id =:idDesdobramento
									ORDER BY Supervisor__r.Name, Operador__r.Name];
										
		return listDesdobramentoUsuario;
	}

	public static List<Desdobramento_Usuario__c> getBySupervisor(Id idSupervisor) {
		List<Desdobramento_Usuario__c> listDesdobramentoUsuario = null;

		listDesdobramentoUsuario = [SELECT
				Id,
				Desdobramento__c,
				Desdobramento__r.Name,
				Desdobramento__r.Area__c,
				Supervisor__r.Id,
				Supervisor__r.Name,
				Operador__r.Id,
				Operador__r.Name,
				CreatedDate
				FROM
		Desdobramento_Usuario__c
				WHERE
				Supervisor__r.Id = :idSupervisor
		ORDER BY Operador__r.Name];

		return listDesdobramentoUsuario;
	}

	public static List<Desdobramento_Usuario__c> getByArea(String area) {
		List<Desdobramento_Usuario__c> listDesdobramentoUsuario = null;

		listDesdobramentoUsuario = [SELECT
				Id,
				Desdobramento__c,
				Desdobramento__r.Name,
				Desdobramento__r.Area__c,
				Supervisor__r.Id,
				Supervisor__r.Name,
				Operador__r.Id,
				Operador__r.Name,
				CreatedDate
				FROM
		Desdobramento_Usuario__c
				WHERE
				Desdobramento__r.Area__c = :area
		ORDER BY Operador__r.Name];

		return listDesdobramentoUsuario;
	}
}
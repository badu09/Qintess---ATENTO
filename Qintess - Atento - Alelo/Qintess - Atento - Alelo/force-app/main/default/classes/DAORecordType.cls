public with sharing class DAORecordType {
    
    public static RecordType obterPorDeveloperName(String developerName) {
	    List<RecordType> lRecordType = [SELECT
											Id,
											Name
								        FROM
								        	RecordType
								        WHERE
								        	DeveloperName =: developerName];
		
		return lRecordType.isEmpty() ? null : lRecordType[0];
	}

	public static RecordType obterPorDeveloperName(String developerName, String sObjectType) {
		List<RecordType> lRecordType = [SELECT
				Id,
				Name
				FROM
		RecordType
				WHERE
				DeveloperName =: developerName AND
				SobjectType =: sObjectType];

		return lRecordType.isEmpty() ? null : lRecordType[0];
	}

	public static RecordType obterPorId(String id, String sObjectType) {
		List<RecordType> lRecordType = [SELECT
				Id,
				Name,
				DeveloperName
				FROM
		RecordType
				WHERE
				Id =: id AND
				SobjectType =: sObjectType];

		return lRecordType.isEmpty() ? null : lRecordType[0];
	}
}
public with sharing class DAOUser {
    public static User getUser() {
    	String idUser = UserInfo.getUserId();
    	return [Select 
    				Id,
    				Name,
    				CPF__c
    			FROM
    				User
    			WHERE
    				Id = :idUser];
    }
    
    public static List<User> getUserBySetId(Set<Id> setId) {
    	return [Select 
    				Id,
    				Name,
    				CPF__c,
    				FirstName
    			FROM
    				User
    			WHERE
    				Id IN :setId];
    }

	public static List<User> getUserByProfile(List<Id> profiles) {
		return [Select
				Id,
				Name,
				CPF__c,
				FirstName,
				Desdobramento__c
				FROM
		User
				WHERE
		ProfileId IN :profiles];
	}

	public static List<User> getUserByProfile(List<Profile> profiles) {
		List<Id> ids = new List<Id>();

		for(Profile p : profiles) {
			ids.add(p.Id);
		}

		System.debug(JSON.serialize('ids: ' + ids));

		return getUserByProfile(ids);
	}
	
	public static List<User> getBySupervisorProfile(Id idSupervisor, List<Profile> listProfile) {
    	return [Select 
    				Id,
    				Name,
    				CPF__c,
    				FirstName,
    				Supervisor__r.Id,
    				Supervisor__r.Name,
    				Supervisor__r.FirstName
    			FROM
    				User
    			WHERE
    				Supervisor__r.Id =:idSupervisor
    			AND
    				ProfileId IN :listProfile];
    }
    
    public static List<User> getBySupervisorProfileSale(Id idSupervisor, List<Profile> listProfile) {
    	return [Select 
    				Id,
    				Name,
    				CPF__c,
    				FirstName,
    				Supervisor__r.Id,
    				Supervisor__r.Name,
    				Supervisor__r.FirstName
    			FROM
    				User
    			WHERE
    				Supervisor__r.Id =:idSupervisor
    			And
    				ID NOT IN (Select Operador__c From Desdobramento_Usuario__c Where Supervisor__c =:idSupervisor)
    			AND
    				ProfileId IN :listProfile];
    }

    public static List<User> getUserByName(string userName, List<Profile> listProfile){

        List<Id> ids = new List<Id>();

        for(Profile p : listProfile) {
            ids.add(p.Id);
        }

        List<User> listaUsers = [SELECT id, name FROM User WHERE name like :userName AND ProfileId IN: ids AND isActive = True];

        return listaUsers;
    }

    public static List<User> getUserIsActiveByProfile(List<Profile> listProfile){

        List<Id> ids = new List<Id>();

        for(Profile p : listProfile) {
            ids.add(p.Id);
        }

        List<User> listaUsers = [SELECT id, name FROM User WHERE  ProfileId IN: ids AND isActive = True];

        return listaUsers;
    }
}
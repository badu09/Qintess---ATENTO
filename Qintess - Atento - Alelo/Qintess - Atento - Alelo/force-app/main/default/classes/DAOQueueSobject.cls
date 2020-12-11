public with sharing class DAOQueueSobject {
    
    public static QueueSobject getGroupMemberByDeveloperName(String developerName) {
		List<QueueSobject> lQueueSobject = [SELECT 
												Id,
												QueueId,
												Queue.DeveloperName
											FROM 
												QueueSobject 
											WHERE 
												Queue.DeveloperName = :developerName];
												
		return lQueueSobject.isEmpty() ? null : lQueueSobject[0];
	}
    
    public static List<QueueSobject> getGroupMemberByDeveloperName(Set<String> setDeveloperName) {
		return [SELECT 
					Id,
					QueueId,
					Queue.DeveloperName
				FROM 
					QueueSobject 
				WHERE 
					Queue.DeveloperName IN :setDeveloperName];
	}

	public static List<QueueSobject> insereQueueSobject(List<QueueSobject> listQueueObj){

		try{

            insert listQueueObj;

		}catch (Exception e){

             return null;

		}

        return listQueueObj;

	}

	public static List<QueueSobject> obterTodasFilasConceitoM(){
		return [SELECT QueueId,Queue.DeveloperName FROM QueueSobject where Queue.DeveloperName like 'ALELO_IMPLANTACAO_M_%'];
	}

	public static List<Group> obterFilasConceitoM(){
		return [SELECT DeveloperName,Id FROM Group WHERE Type = 'Queue' AND DeveloperName like 'ALELO_IMPLANTACAO_M_%'];
	}
}
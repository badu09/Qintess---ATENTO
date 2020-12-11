public with sharing class DAOQueueRoutingConfig {
    
    public static QueueRoutingConfig getByDeveloperName(String developerName) {
		List<QueueRoutingConfig> lQueueRoutingConfig = [SELECT 
															Id
														FROM 
															QueueRoutingConfig 
														WHERE 
															DeveloperName = :developerName];
												
		return lQueueRoutingConfig.isEmpty() ? null : lQueueRoutingConfig[0];
	}

	public static Map<String,QueueRoutingConfig> getQueueRoutingByListDeveloperName(String novosPedidos,
	                                                                          String contatosPedidos, 
	                                                                          String contatoAgendado){
		
		List<QueueRoutingConfig> listaQueueRouting = [SELECT Id,DeveloperName FROM QueueRoutingConfig 
		                                             Where DeveloperName = :novosPedidos or
		                                                   DeveloperName = :contatosPedidos or
		                                                   DeveloperName = :contatoAgendado];

		Map<String,QueueRoutingConfig> mapQueueRouting = new Map<String,QueueRoutingConfig>();

		for(QueueRoutingConfig queueRouting : listaQueueRouting){
			mapQueueRouting.put(queueRouting.DeveloperName,queueRouting);
		}
		return mapQueueRouting;                                             
	}
}
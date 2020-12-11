public with sharing class DAOOrder {
	public static List<Order> getOrderByAccountId(Id idConta) {
		return [SELECT
				Id,
				Status,
				OwnerId,
				RecordTypeId,
				Opportunity.Id,
				Opportunity.Implantador_Atribuido__c,
				Opportunity.StageName,
				Opportunity.Processo_Implantacao__c
				FROM
		Order
				WHERE
				Opportunity.Account.Id =: idConta AND
				Status != 'Implantacao' AND
				Status != 'Finalizado'];
	}
	public static List<Order> getOrderByOpportunityId(Id idOpportunity) {
		return [SELECT
				Id,
				Status,
				OwnerId,
				RecordTypeId,
				Opportunity.Id,
				Opportunity.Implantador_Atribuido__c,
				Opportunity.StageName,
				Opportunity.Processo_Implantacao__c
				FROM
		Order
				WHERE
				Opportunity.Id =: idOpportunity];
	}

    public static Order getOrderById(Id idProcesso) {
    	return [SELECT
    				Id,
    				Status,
					OwnerId,
    				Opportunity.Id,
    				Opportunity.Implantador_Atribuido__c,
    				Opportunity.StageName,
    				Opportunity.Processo_Implantacao__c,
    				Opportunity.Telefone_Decisor__c,
    				Opportunity.Id_da_Campanha__c,
    				Opportunity.Name,
					RecordTypeId
    			FROM
    				Order
    			WHERE
    				Id = :idProcesso];
    }

	public static List<Order> getOrderBySetId(Set<Id> setId) {
		return [SELECT
				Id,
				Status,
				RecordTypeId,
				Opportunity.Id,
				OwnerId,
				Opportunity.Implantador_Atribuido__c,
				Opportunity.Implantador_Atribuido__r.Name,
				Opportunity.StageName,
				Opportunity.Processo_Implantacao__c,
				Opportunity.Telefone_Decisor__c,
				Opportunity.Telefone_Operacional__c,
				Opportunity.Id_da_Campanha__c,
				Opportunity.Name,
				Opportunity.OwnerId,
                Implantacao_Fidelizada_Estrategia__c,
				LastModifiedById
				FROM
		Order
				WHERE
		Id IN :setId];
	}

	public static List<Order> getOrderBySetId(Set<String> setId) {
		return [SELECT
				Id,
				Status,
				RecordTypeId,
				Opportunity.Id,
				OwnerId,
				Opportunity.Implantador_Atribuido__c,
				Opportunity.Implantador_Atribuido__r.Name,
				Opportunity.StageName,
				Opportunity.Processo_Implantacao__c,
				Opportunity.Telefone_Decisor__c,
				Opportunity.Telefone_Operacional__c,
				Opportunity.Id_da_Campanha__c,
				Opportunity.Name
				FROM
		Order
				WHERE
		Id IN :setId];
	}
}
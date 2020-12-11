// Created by Juliana Neres on 06/04/2020.
public class BatchRemoveCodProdutoAlelo implements Database.Batchable<Produtos_Alelo__c>,Database.Stateful{

	public List<Produtos_Alelo__c> listProdutoAlelo;

	public BatchRemoveCodProdutoAlelo(List<Produtos_Alelo__c> listProdutoAlelo) {
		this.listProdutoAlelo = listProdutoAlelo;
	}

	public System.Iterable<Produtos_Alelo__c> start(Database.BatchableContext jobId) {
		return listProdutoAlelo;
	}

	public Void execute(Database.BatchableContext jobId, List<Produtos_Alelo__c> recordList) {
		List<Id> listIdOpp = new List<Id>();
		List<Opportunity> listOpp = new List<Opportunity>();

		//LISTA PARA ATUALIZAÇÃO DOS PEDIDOS
		List<Order> listOrderUpdate = new List<Order>();

		//POPULANDO A LISTA DE ID OPORTUNIDADE
		for (Produtos_Alelo__c prodAlelo : recordList) {
			listIdOpp.add(prodAlelo.Oportunidade__c);
		}

		//QUERY DE BUSCA DAS OPORTUNIDADES QUE ESTÃO NA LISTA DE ID
		listOpp = [SELECT Codigo_Alelo_Auto__c,
				Codigo_Alelo_Mobilidade__c,
				OwnerId,
				Total_Fidelizado__c,
				RecordTypeId,
				Conceito_Implantacao__c,
				CloseDate,
				AccountId
				FROM Opportunity
				WHERE Id IN :listIdOpp];

		//MAP DE ID E OPORTUNIDADE
		Map<Id,Opportunity> mapOpp = new Map<Id, Opportunity>();
		for (Opportunity opp : listOpp) {
			mapOpp.put(opp.Id, opp);
		}

		//QUERY DE BUSCA DOS PEDIDOS QUE ESTÃO NA LISTA DE ID
		List<Order> lstOrder = [SELECT Id,
				Codigo_do_Produto_1__c,
				Codigo_do_Produto_2__c,
				OpportunityId
				FROM Order
				WHERE OpportunityId IN :listIdOpp];

		//MAP DE ID DE OPORTUNIDADE E DE PEDIDOS
		Map<Id,List<Order>> mapOrderOpp = new Map<Id, List<Order>>();
		for (Order ord : lstOrder) {
			if(!mapOrderOpp.containsKey(ord.OpportunityId)){
				mapOrderOpp.put(ord.OpportunityId, new List<Order>());
			}
			mapOrderOpp.get(ord.OpportunityId).add(ord);
		}

		//ATUALIZAÇÃO DOS OBJETOS OPORTUNIDADE E PEDIDO
		for (Produtos_Alelo__c prodAlelo : recordList) {
			if (prodAlelo.Codigo_de_Produtos__c == '301' || prodAlelo.Codigo_de_Produtos__c == '302'){

				//INSERÇÃO DO CÓDIGO DO PRODUTO NO PROCESSO DE ROTEAMENTO (OBJETO ORDER/PEDIDO)
				List<Order> selectOrder = mapOrderOpp.get(prodAlelo.Oportunidade__c);
				if (selectOrder != null){
					for (Order order : selectOrder) {
						if('301'.equals(prodAlelo.Codigo_de_Produtos__c)){
							order.Codigo_do_Produto_1__c = null;
						} else if ('302'.equals(prodAlelo.Codigo_de_Produtos__c)){
							order.Codigo_do_Produto_2__c = null;
						}

						listOrderUpdate.add(order);
					}
				}
			}
		}
		Database.update(listOrderUpdate);
	}

	public Void finish(Database.BatchableContext jobId) {
		System.debug('TERMINOU E REMOVEU(?)!');
	}
}